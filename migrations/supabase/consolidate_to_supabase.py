#!/usr/bin/env python3
"""
Consolidate All Data into Supabase
====================================
PURPOSE: Migrate all data from SQLite + Notion into Supabase as single source of truth.

SOURCES:
    - SQLite: ~/projects/data/client_product_database.db (all tables except NCCN/GRXP tests)
    - Notion: NCCN test cases (204 tests) — authoritative for NCCN
    - Notion: GRXP test cases (114+ tests, still being updated) — authoritative for GRXP

TARGET SCHEMA: TraceWell (propel-requirements-dashboard)
    - Test cases → test_cases (UUID PK, JSONB test_steps)
    - Test executions → test_executions (UUID PK)
    - Legacy tables (uat_test_cases, audit_history, roadmap_*, etc.) archived in 018

PREREQUISITES:
    1. Run migrations 017-019 in Supabase SQL Editor
    2. pip install supabase python-dotenv

USAGE:
    python3 consolidate_to_supabase.py --preview          # Dry run — show what would be inserted
    python3 consolidate_to_supabase.py --execute           # Full migration
    python3 consolidate_to_supabase.py --execute --skip-notion  # SQLite only (no Notion fetch)
    python3 consolidate_to_supabase.py --verify            # Post-migration verification
    python3 consolidate_to_supabase.py --execute --notion-only nccn  # Only NCCN from Notion
    python3 consolidate_to_supabase.py --execute --notion-only grxp  # Only GRXP from Notion

ENVIRONMENT:
    SUPABASE_URL        - Supabase project URL
    SUPABASE_SERVICE_KEY - Service role key (bypasses RLS for migration)

    Optional (for Notion):
    NOTION_API_KEY      - Notion integration token
"""

import sqlite3
import json
import os
import sys
import argparse
import time
import uuid as _uuid
from datetime import datetime
from pathlib import Path
from typing import Any, Optional


# ---------------------------------------------------------------------------
# Reused helpers from export_sqlite_data.py
# ---------------------------------------------------------------------------

def escape_sql_string(value: Any) -> str:
    """Escape a value for safe inclusion in SQL statements."""
    if value is None:
        return "NULL"
    if isinstance(value, bool):
        return "TRUE" if value else "FALSE"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, str):
        escaped = value.replace("'", "''")
        escaped = escaped.replace("\n", "\\n").replace("\r", "\\r")
        return f"'{escaped}'"
    if isinstance(value, (dict, list)):
        json_str = json.dumps(value).replace("'", "''")
        return f"'{json_str}'::JSONB"
    return f"'{str(value)}'"


def convert_sqlite_bool(value: Any) -> Optional[bool]:
    """Convert SQLite integer boolean to Python bool."""
    if value is None:
        return None
    if isinstance(value, bool):
        return value
    return bool(value)


def convert_text_to_jsonb_array(value: str, delimiter: str = ",") -> list:
    """Convert comma-separated TEXT to a JSONB-ready list."""
    if not value or not value.strip():
        return []
    return [item.strip() for item in value.split(delimiter) if item.strip()]


def parse_json_or_default(value: str, default: Any = None) -> Any:
    """Safely parse a JSON string, returning default if invalid."""
    if not value or not value.strip():
        return default
    try:
        return json.loads(value)
    except json.JSONDecodeError:
        if "," in value and not value.startswith("{"):
            return convert_text_to_jsonb_array(value)
        return default


def safe_timestamp(value: Any) -> Optional[str]:
    """Convert a SQLite timestamp to ISO format for Supabase."""
    if not value:
        return None
    s = str(value).strip()
    if not s:
        return None
    # Already ISO-ish — just return it
    return s


def make_deterministic_uuid(text_id: str) -> str:
    """
    Generate a deterministic UUID from a text ID using uuid5(NAMESPACE_DNS).

    PURPOSE: Convert legacy TEXT test_id values to UUID test_case_id values
             that are reproducible across runs. Uses the same namespace as
             migration 017_migrate_test_cases.sql for consistency.

    R EQUIVALENT: No direct equivalent — R would use digest::digest(text_id, algo="md5")
                  but this produces a proper UUID v5.
    """
    return str(_uuid.uuid5(_uuid.NAMESPACE_DNS, text_id))


def map_test_type(raw_type: str) -> str:
    """Map legacy free-text test_type to TraceWell enum values."""
    if not raw_type:
        return "functional"
    normalized = raw_type.strip().lower()
    valid = {"functional", "regression", "integration", "smoke",
             "boundary", "security", "accessibility"}
    return normalized if normalized in valid else "functional"


def map_priority(raw_priority: str) -> str:
    """Map legacy priority to TraceWell enum values."""
    if not raw_priority:
        return "medium"
    normalized = raw_priority.strip().lower()
    valid = {"critical", "high", "medium", "low"}
    return normalized if normalized in valid else "medium"


def map_test_status_to_execution(legacy_status: str) -> str:
    """Map legacy test_status to TraceWell test_executions status."""
    mapping = {
        "Pass": "passed",
        "Fail": "failed",
        "Blocked": "blocked",
        "In Test": "in_progress",
        "Skipped": "blocked",
    }
    return mapping.get(legacy_status, "assigned")


def build_test_steps_jsonb(test_steps_text: str, expected_results: str = None) -> list:
    """
    Parse flat test_steps text into JSONB array for TraceWell schema.

    TraceWell format: [{ step_number, action, expected_result, notes? }]
    Legacy format: Free text (may have numbered lines or just paragraphs)
    """
    if not test_steps_text or not test_steps_text.strip():
        return []

    # For now, wrap the entire text as a single step.
    # Future enhancement: parse numbered lines into individual steps.
    return [{
        "step_number": 1,
        "action": test_steps_text.strip(),
        "expected_result": (expected_results or "").strip(),
    }]


# ---------------------------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------------------------

DEFAULT_DB_PATH = Path.home() / "projects" / "data" / "client_product_database.db"

# Programs whose test cases come from Notion (not SQLite)
NCCN_PROGRAM_ID = "e1061391-a8c8-4695-9c0e-f8e20dc64d47"
GRXP_PROGRAM_ID = "4eb63a88-96b9-45be-b1d3-7adb3cea0b67"
NOTION_EXCLUDED_PROGRAM_IDS = {NCCN_PROGRAM_ID, GRXP_PROGRAM_ID}

# Notion database IDs
NOTION_NCCN_DB = "74882519de814d81af7957793434cfe6"
NOTION_GRXP_DB = "892b60e9897c4fba8c7c5e3a9d68cc49"

# Batch size for Supabase upsert
BATCH_SIZE = 500


# ---------------------------------------------------------------------------
# SQLITE EXTRACTION
# ---------------------------------------------------------------------------

class SQLiteReader:
    """Reads and transforms data from the SQLite database."""

    def __init__(self, db_path: Path):
        self.db_path = db_path
        self.conn = None

    def connect(self):
        print(f"Connecting to SQLite: {self.db_path}")
        self.conn = sqlite3.connect(str(self.db_path))
        self.conn.row_factory = sqlite3.Row

    def close(self):
        if self.conn:
            self.conn.close()

    def count(self, table: str) -> int:
        return self.conn.execute(f"SELECT COUNT(*) FROM [{table}]").fetchone()[0]

    def read_all(self, table: str) -> list[dict]:
        """Read all rows from a table as list of dicts."""
        cursor = self.conn.execute(f"SELECT * FROM [{table}]")
        return [dict(row) for row in cursor.fetchall()]

    # --- Transformation methods per table group ---
    # NOTE: Methods for archived tables (audit_history, roadmap_*, user_access,
    #       user_training, story_reference, story_compliance_vetting,
    #       compliance_test_templates, compliance_gaps, traceability,
    #       import_batches, pre_uat_gate_items) have been removed.
    #       Those tables were archived by migration 018_archive_legacy_tables.sql.

    def get_clients(self) -> list[dict]:
        rows = self.read_all("clients")
        result = []
        for r in rows:
            result.append({
                "client_id": r.get("client_id"),
                "name": r.get("name"),
                "short_name": r.get("short_name"),
                "description": r.get("description"),
                "client_type": r.get("client_type"),
                "primary_contact_name": r.get("primary_contact_name") or r.get("primary_contact"),
                "primary_contact_email": r.get("primary_contact_email") or r.get("contact_email"),
                "primary_contact_phone": r.get("primary_contact_phone"),
                "contract_reference": r.get("contract_reference"),
                "contract_start_date": r.get("contract_start_date"),
                "contract_end_date": r.get("contract_end_date"),
                "source_document": r.get("source_document"),
                "status": r.get("status") or "Active",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_programs(self) -> list[dict]:
        rows = self.read_all("programs")
        result = []
        for r in rows:
            result.append({
                "program_id": r.get("program_id"),
                "client_id": r.get("client_id"),
                "name": r.get("name"),
                "prefix": r.get("prefix"),
                "description": r.get("description"),
                "program_type": r.get("program_type") or "clinic_based",
                "source_file": r.get("source_file"),
                "color_hex": r.get("color_hex"),
                "status": r.get("status") or "Active",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_program_relationships(self) -> list[dict]:
        rows = self.read_all("program_relationships")
        result = []
        for r in rows:
            result.append({
                "parent_program_id": r.get("parent_program_id"),
                "attached_program_id": r.get("attached_program_id"),
                "relationship_type": r.get("relationship_type") or "attached",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
            })
        return result

    def get_clinics(self) -> list[dict]:
        rows = self.read_all("clinics")
        result = []
        for r in rows:
            result.append({
                "clinic_id": r.get("clinic_id"),
                "program_id": r.get("program_id"),
                "name": r.get("name"),
                "code": r.get("code"),
                "description": r.get("description"),
                "status": r.get("status") or "Active",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_locations(self) -> list[dict]:
        rows = self.read_all("locations")
        result = []
        for r in rows:
            result.append({
                "location_id": r.get("location_id"),
                "clinic_id": r.get("clinic_id"),
                "name": r.get("name"),
                "code": r.get("code"),
                "address": r.get("address"),
                "city": r.get("city"),
                "state": r.get("state"),
                "zip": r.get("zip"),
                "phone": r.get("phone"),
                "fax": r.get("fax"),
                "epic_id": r.get("epic_id"),
                "status": r.get("status") or "Active",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_providers(self) -> list[dict]:
        rows = self.read_all("providers")
        result = []
        # Deduplicate by NPI — SQLite has 3 rows for "Christine Kemp, NP"
        # all sharing NPI 1215158639. Supabase has UNIQUE(npi), so the batch
        # insert fails if we send duplicates. Keep first occurrence only.
        seen_npis = set()
        skipped = 0
        for r in rows:
            npi = r.get("npi")
            if npi and npi in seen_npis:
                skipped += 1
                continue
            if npi:
                seen_npis.add(npi)
            # Don't send provider_id — Supabase uses SERIAL auto-increment.
            # We use NPI or name as the natural key for matching.
            result.append({
                "name": r.get("name"),
                "npi": r.get("npi"),
                "specialty": r.get("specialty"),
                "email": r.get("email"),
                "phone": r.get("phone"),
                "is_active": r.get("status", "Active") != "Inactive",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        if skipped:
            print(f"    Deduplicated providers: skipped {skipped} duplicate NPIs")
        # Store raw rows for provider_locations mapping
        self._provider_rows = rows
        return result

    def get_provider_locations_raw(self) -> list[dict]:
        """Return raw SQLite provider rows with location_id for later mapping."""
        rows = getattr(self, "_provider_rows", None) or self.read_all("providers")
        result = []
        # Same NPI dedup as get_providers() — only map locations for
        # the first occurrence of each NPI to stay consistent.
        seen_npis = set()
        for r in rows:
            npi = r.get("npi")
            if npi and npi in seen_npis:
                continue
            if npi:
                seen_npis.add(npi)
            if r.get("location_id"):
                result.append({
                    "npi": r.get("npi"),
                    "name": r.get("name"),
                    "location_id": r.get("location_id"),
                })
        return result

    def get_config_definitions(self) -> list[dict]:
        rows = self.read_all("config_definitions")
        result = []
        for r in rows:
            # Convert valid_values TEXT to JSONB if needed
            valid_values = r.get("valid_values")
            if valid_values:
                parsed = parse_json_or_default(valid_values)
                if parsed is not None:
                    valid_values = json.dumps(parsed)

            result.append({
                "config_key": r.get("config_key"),
                "display_name": r.get("display_name"),
                "description": r.get("description"),
                "category": r.get("category"),
                "data_type": r.get("data_type") or "text",
                "default_value": r.get("default_value"),
                "valid_values": valid_values,
                "is_required": convert_sqlite_bool(r.get("is_required")),
                "is_sensitive": convert_sqlite_bool(r.get("is_sensitive")),
                "applies_to": r.get("applies_to") or "all",
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
            })
        return result

    def get_config_values(self) -> list[dict]:
        rows = self.read_all("config_values")
        result = []
        for r in rows:
            result.append({
                "config_key": r.get("config_key"),
                "value": r.get("value"),
                "program_id": r.get("program_id"),
                "clinic_id": r.get("clinic_id"),
                "location_id": r.get("location_id"),
                "source": r.get("source") or "manual",
                "source_document": r.get("source_document"),
                "effective_date": r.get("effective_date"),
                "expiration_date": r.get("expiration_date"),
                "is_override": convert_sqlite_bool(r.get("is_override")),
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_requirements(self) -> list[dict]:
        rows = self.read_all("requirements")
        result = []
        for r in rows:
            # Parse context_json TEXT to JSONB
            context = parse_json_or_default(r.get("context_json"), default={})

            result.append({
                "requirement_id": r.get("requirement_id"),
                "program_id": r.get("program_id"),
                "source_file": r.get("source_file"),
                "source_row": r.get("source_row"),
                "raw_text": r.get("raw_text"),
                "title": r.get("title"),
                "description": r.get("description"),
                "priority": r.get("priority"),
                "source_status": r.get("source_status"),
                "requirement_type": r.get("requirement_type"),
                "context_json": json.dumps(context) if context else None,
                "import_batch": r.get("import_batch"),
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_users(self) -> list[dict]:
        rows = self.read_all("users")
        result = []
        for r in rows:
            result.append({
                "user_id": r.get("user_id"),
                "name": r.get("full_name") or r.get("name") or "",
                "email": r.get("email"),
                "organization": r.get("organization") or "Internal",
                "is_business_associate": convert_sqlite_bool(r.get("is_business_associate")),
                "status": r.get("status") or "Active",
                "notes": r.get("notes"),
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_user_stories(self) -> list[dict]:
        rows = self.read_all("user_stories")
        result = []
        for r in rows:
            # Convert TEXT fields to JSONB arrays
            related = parse_json_or_default(r.get("related_stories"), default=[])
            flags = parse_json_or_default(r.get("flags"), default=[])

            result.append({
                "story_id": r.get("story_id"),
                "requirement_id": r.get("requirement_id"),
                "program_id": r.get("program_id"),
                "title": r.get("title"),
                "user_story": r.get("user_story"),
                "role": r.get("role"),
                "capability": r.get("capability"),
                "benefit": r.get("benefit"),
                "acceptance_criteria": r.get("acceptance_criteria"),
                "success_metrics": r.get("success_metrics"),
                "priority": r.get("priority"),
                "category": r.get("category"),
                "category_full": r.get("category_full"),
                "is_technical": convert_sqlite_bool(r.get("is_technical")),
                "status": r.get("status") or "Draft",
                "story_type": "user_story",
                "internal_notes": r.get("internal_notes"),
                "meeting_context": r.get("meeting_context"),
                "client_feedback": r.get("client_feedback"),
                "related_stories": json.dumps(related) if related else "[]",
                "flags": json.dumps(flags) if flags else "[]",
                "roadmap_target": r.get("roadmap_target"),
                "parent_story_id": r.get("parent_story_id"),
                "version": r.get("version") or 1,
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
                "approved_at": safe_timestamp(r.get("approved_date")),
                "approved_by": r.get("approved_by"),
                "draft_date": safe_timestamp(r.get("draft_date")),
                "internal_review_date": safe_timestamp(r.get("internal_review_date")),
                "client_review_date": safe_timestamp(r.get("client_review_date")),
                "needs_discussion_date": safe_timestamp(r.get("needs_discussion_date")),
                "uat_date": safe_timestamp(r.get("uat_date")),
                "complete_date": safe_timestamp(r.get("complete_date")),
            })
        return result

    def get_uat_cycles(self) -> list[dict]:
        """
        Transform SQLite uat_cycles for the DEPLOYED Supabase schema.

        The deployed uat_cycles table was created by TraceWell's migration
        007_uat_tester_portal.sql, which has a different schema than
        requirements_toolkit's 001_schema.sql:
          - cycle_id is UUID (not TEXT)
          - program_id is NOT NULL
          - created_by is NOT NULL, REFERENCES users(user_id)
          - Columns like uat_type, clinical_pm, go_nogo_date don't exist

        We skip rows with NULL program_id and set created_by to "SYSTEM"
        (a synthetic user ensured to exist before this runs).
        """
        rows = self.read_all("uat_cycles")
        result = []
        # Deployed Supabase has cycle_id as UUID, but SQLite uses text IDs.
        # Generate deterministic UUIDs from text IDs so they're reproducible.
        self._cycle_id_map = {}  # text_id -> uuid_str, for downstream lookups
        skipped = 0
        for r in rows:
            # Skip cycles with NULL program_id — violates NOT NULL in deployed schema
            if not r.get("program_id"):
                skipped += 1
                text_id = r.get("cycle_id")
                # Still map the ID so downstream references don't break
                new_id = make_deterministic_uuid(text_id)
                self._cycle_id_map[text_id] = new_id
                continue

            text_id = r.get("cycle_id")
            new_id = make_deterministic_uuid(text_id)
            self._cycle_id_map[text_id] = new_id
            # Only send columns that exist in TraceWell's uat_cycles schema.
            # created_by must reference users(user_id) — use "SYSTEM" placeholder.
            result.append({
                "cycle_id": new_id,
                "program_id": r.get("program_id"),
                "name": r.get("name"),
                "description": r.get("description"),
                "status": r.get("status") or "planning",
                "created_by": "SYSTEM",
            })
        if skipped:
            print(f"    Skipped {skipped} UAT cycles with NULL program_id")
        return result

    def get_test_cases(self, exclude_program_ids: set = None) -> tuple[list[dict], list[dict]]:
        """
        Get test cases from SQLite uat_test_cases, transformed for TraceWell's
        test_cases schema.

        RETURNS: (test_cases, test_executions) — two lists of dicts.
            test_cases: Rows for the test_cases table (UUID PK, JSONB test_steps)
            test_executions: Rows for executed tests (only for non-"Not Run" status)

        PARAMETERS:
            exclude_program_ids: Set of program_ids whose tests come from Notion
        """
        rows = self.read_all("uat_test_cases")
        test_cases = []
        test_executions = []
        skipped = 0

        for r in rows:
            if exclude_program_ids and r.get("program_id") in exclude_program_ids:
                skipped += 1
                continue

            test_id = r.get("test_id")
            story_id = r.get("story_id")
            program_id = r.get("program_id")

            # Skip rows without required FK fields
            if not story_id or not program_id or not test_id:
                skipped += 1
                continue

            # Generate deterministic UUID from legacy text ID
            test_case_id = make_deterministic_uuid(test_id)

            # Convert patient_conditions to test_data string
            patient_conditions = parse_json_or_default(r.get("patient_conditions"), default=None)
            test_data = json.dumps(patient_conditions) if patient_conditions else None

            # Build test_steps JSONB array from flat text
            test_steps = build_test_steps_jsonb(
                r.get("test_steps"),
                r.get("expected_results")
            )

            test_cases.append({
                "test_case_id": test_case_id,
                "story_id": story_id,
                "program_id": program_id,
                "title": r.get("title") or f"Test {test_id}",
                "description": r.get("notes") or "",
                "preconditions": r.get("prerequisites"),
                "test_data": test_data,
                "test_steps": json.dumps(test_steps),
                "expected_results": r.get("expected_results"),
                "test_type": map_test_type(r.get("test_type")),
                "priority": map_priority(r.get("priority")),
                "status": "ready",
                "version": 1,
                "created_by": "SYSTEM",
                "is_ai_generated": False,
                "human_reviewed": False,
                "is_archived": False,
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })

            # Create test_execution for rows with actual execution data
            test_status = r.get("test_status") or "Not Run"
            if test_status not in ("Not Run", ""):
                # Build notes from execution_notes + defect info
                notes_parts = []
                if r.get("execution_notes"):
                    notes_parts.append(r["execution_notes"])
                if r.get("defect_description"):
                    notes_parts.append(f"Defect: {r['defect_description']}")
                exec_notes = "\n\n".join(notes_parts) if notes_parts else None

                test_executions.append({
                    "test_case_id": test_case_id,
                    "story_id": story_id,
                    # assigned_to/assigned_by are NOT NULL FK to users(user_id).
                    # Legacy values are free-text names, not valid user_ids.
                    "assigned_to": "SYSTEM",
                    "assigned_by": "SYSTEM",
                    "assigned_at": safe_timestamp(r.get("tested_date")) or safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                    "status": map_test_status_to_execution(test_status),
                    "step_results": "[]",
                    "completed_at": safe_timestamp(r.get("tested_date")) if test_status in ("Pass", "Fail") else None,
                    "notes": exec_notes,
                    "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                    "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
                })

        if skipped:
            print(f"    Skipped {skipped} tests (Notion-sourced or missing FKs)")
        return test_cases, test_executions

    def get_onboarding_projects(self) -> list[dict]:
        rows = self.read_all("onboarding_projects")
        result = []
        for r in rows:
            result.append({
                "project_id": r.get("project_id"),
                "program_id": r.get("program_id"),
                "clinic_id": r.get("clinic_id"),
                "project_name": r.get("project_name"),
                "clinic_name": r.get("clinic_name"),
                "status": r.get("status") or "INTAKE",
                "target_launch_date": r.get("target_launch_date"),
                "actual_launch_date": r.get("actual_launch_date"),
                "client_contact_name": r.get("client_contact_name"),
                "client_contact_email": r.get("client_contact_email"),
                "propel_lead": r.get("propel_lead"),
                "notes": r.get("notes"),
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "created_by": r.get("created_by") or "system",
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_onboarding_milestones(self) -> list[dict]:
        rows = self.read_all("onboarding_milestones")
        result = []
        for r in rows:
            result.append({
                "project_id": r.get("project_id"),
                "milestone_type": r.get("milestone_type"),
                "milestone_name": r.get("milestone_name"),
                "sequence_order": r.get("sequence_order"),
                "status": r.get("status") or "NOT_STARTED",
                "target_date": r.get("target_date"),
                "actual_completion_date": r.get("actual_completion_date"),
                "completed_by": r.get("completed_by"),
                "auto_verify_type": r.get("auto_verify_type"),
                "auto_verified_date": safe_timestamp(r.get("auto_verified_date")),
                "auto_verified_result": convert_sqlite_bool(r.get("auto_verified_result")),
                "notes": r.get("notes"),
                "blocker_reason": r.get("blocker_reason"),
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result

    def get_onboarding_dependencies(self) -> list[dict]:
        rows = self.read_all("onboarding_dependencies")
        result = []
        for r in rows:
            result.append({
                "project_id": r.get("project_id"),
                "milestone_id": r.get("milestone_id"),
                "dependency_type": r.get("dependency_type"),
                "description": r.get("description"),
                "external_reference": r.get("external_reference"),
                "external_system": r.get("external_system"),
                "owner": r.get("owner"),
                "owner_email": r.get("owner_email"),
                "status": r.get("status") or "PENDING",
                "due_date": r.get("due_date"),
                "resolved_date": r.get("resolved_date"),
                "resolved_by": r.get("resolved_by"),
                "resolution_notes": r.get("resolution_notes"),
                "created_at": safe_timestamp(r.get("created_date")) or datetime.now().isoformat(),
                "created_by": r.get("created_by") or "system",
                "updated_at": safe_timestamp(r.get("updated_date")) or datetime.now().isoformat(),
            })
        return result


# ---------------------------------------------------------------------------
# NOTION EXTRACTION
# ---------------------------------------------------------------------------

class NotionReader:
    """Fetches test case data from Notion databases using the Notion API."""

    def __init__(self, api_key: str):
        self.api_key = api_key
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Notion-Version": "2022-06-28",
        }

    def _query_database(self, database_id: str) -> list[dict]:
        """Query all pages from a Notion database with pagination."""
        import requests

        url = f"https://api.notion.com/v1/databases/{database_id}/query"
        all_results = []
        has_more = True
        start_cursor = None

        while has_more:
            body = {"page_size": 100}
            if start_cursor:
                body["start_cursor"] = start_cursor

            resp = requests.post(url, headers=self.headers, json=body)
            resp.raise_for_status()
            data = resp.json()

            all_results.extend(data.get("results", []))
            has_more = data.get("has_more", False)
            start_cursor = data.get("next_cursor")

            # Rate limit: Notion allows ~3 req/sec
            time.sleep(0.35)

        return all_results

    def _get_property(self, props: dict, name: str, prop_type: str = None) -> Any:
        """Extract a property value from a Notion page."""
        prop = props.get(name)
        if not prop:
            return None

        ptype = prop.get("type", "")

        if ptype == "title":
            parts = prop.get("title", [])
            return "".join(p.get("plain_text", "") for p in parts) if parts else None

        if ptype == "rich_text":
            parts = prop.get("rich_text", [])
            return "".join(p.get("plain_text", "") for p in parts) if parts else None

        if ptype == "select":
            sel = prop.get("select")
            return sel.get("name") if sel else None

        if ptype == "multi_select":
            sels = prop.get("multi_select", [])
            return [s.get("name") for s in sels] if sels else []

        if ptype == "number":
            return prop.get("number")

        if ptype == "checkbox":
            return prop.get("checkbox")

        if ptype == "date":
            d = prop.get("date")
            return d.get("start") if d else None

        if ptype == "people":
            people = prop.get("people", [])
            return ", ".join(p.get("name", "") for p in people) if people else None

        if ptype == "relation":
            rels = prop.get("relation", [])
            return [r.get("id") for r in rels] if rels else []

        return None

    def get_nccn_tests(self, cycle_id_map: dict = None) -> tuple[list[dict], list[dict]]:
        """
        Fetch NCCN test cases from Notion → TraceWell test_cases format.

        RETURNS: (test_cases, test_executions)

        PARAMETERS:
            cycle_id_map: Dict mapping cycle names to cycle_ids
                          e.g. {"NCCN Q4 2025": "cycle-id-xxx"}
        """
        print(f"  Fetching NCCN tests from Notion (DB: {NOTION_NCCN_DB})...")
        pages = self._query_database(NOTION_NCCN_DB)
        print(f"    Retrieved {len(pages)} pages")

        test_cases = []
        test_executions = []

        for page in pages:
            props = page.get("properties", {})

            test_id = self._get_property(props, "Test ID")
            if not test_id:
                continue

            story_id = self._get_property(props, "Story ID")
            if not story_id:
                continue  # test_cases.story_id is NOT NULL

            # Deterministic UUID from legacy text ID
            test_case_id = make_deterministic_uuid(test_id)

            # Parse patient conditions to test_data string
            patient_cond_raw = self._get_property(props, "Patient Conditions")
            test_data = None
            if patient_cond_raw:
                test_data = json.dumps(
                    convert_text_to_jsonb_array(patient_cond_raw, ",")
                )

            # Build test_steps JSONB
            raw_steps = self._get_property(props, "Test Steps")
            expected = self._get_property(props, "Expected Result")
            test_steps = build_test_steps_jsonb(raw_steps, expected)

            test_cases.append({
                "test_case_id": test_case_id,
                "story_id": story_id,
                "program_id": NCCN_PROGRAM_ID,
                "title": self._get_property(props, "Title") or f"NCCN Test {test_id}",
                "description": "",
                "preconditions": self._get_property(props, "Preconditions"),
                "test_data": test_data,
                "test_steps": json.dumps(test_steps),
                "expected_results": expected,
                "test_type": map_test_type(self._get_property(props, "Test Type")),
                "priority": "medium",
                "status": "ready",
                "version": 1,
                "created_by": "SYSTEM",
                "is_ai_generated": False,
                "human_reviewed": False,
                "is_archived": False,
                "created_at": page.get("created_time"),
                "updated_at": page.get("last_edited_time"),
            })

            # Create test_execution if test has been executed
            test_status = self._get_property(props, "Primary Status") or "Not Run"
            if test_status not in ("Not Run", ""):
                notes_parts = []
                actual_result = self._get_property(props, "Actual Result")
                defect_notes = self._get_property(props, "Defect Notes")
                if actual_result:
                    notes_parts.append(actual_result)
                if defect_notes:
                    notes_parts.append(f"Defect: {defect_notes}")

                test_executions.append({
                    "test_case_id": test_case_id,
                    "story_id": story_id,
                    "assigned_to": "SYSTEM",
                    "assigned_by": "SYSTEM",
                    "status": map_test_status_to_execution(test_status),
                    "step_results": "[]",
                    "notes": "\n\n".join(notes_parts) if notes_parts else None,
                    "created_at": page.get("created_time"),
                    "updated_at": page.get("last_edited_time"),
                })

        return test_cases, test_executions

    def get_grxp_tests(self, cycle_id_map: dict = None) -> tuple[list[dict], list[dict]]:
        """
        Fetch GRXP test cases from Notion → TraceWell test_cases format.

        RETURNS: (test_cases, test_executions)

        PARAMETERS:
            cycle_id_map: Dict mapping cycle names to cycle_ids
        """
        print(f"  Fetching GRXP tests from Notion (DB: {NOTION_GRXP_DB})...")
        pages = self._query_database(NOTION_GRXP_DB)
        print(f"    Retrieved {len(pages)} pages")

        test_cases = []
        test_executions = []

        for page in pages:
            props = page.get("properties", {})

            test_id = self._get_property(props, "Test ID")
            if not test_id:
                continue

            story_id = self._get_property(props, "Story ID")
            if not story_id:
                continue  # test_cases.story_id is NOT NULL

            test_case_id = make_deterministic_uuid(test_id)

            raw_steps = self._get_property(props, "Test Steps")
            expected = self._get_property(props, "Expected Result")
            test_steps = build_test_steps_jsonb(raw_steps, expected)

            test_cases.append({
                "test_case_id": test_case_id,
                "story_id": story_id,
                "program_id": GRXP_PROGRAM_ID,
                "title": self._get_property(props, "Title") or f"GRXP Test {test_id}",
                "description": "",
                "preconditions": self._get_property(props, "Preconditions"),
                "test_steps": json.dumps(test_steps),
                "expected_results": expected,
                "test_type": map_test_type(self._get_property(props, "Test Type")),
                "priority": map_priority(self._get_property(props, "Priority")),
                "status": "ready",
                "version": 1,
                "created_by": "SYSTEM",
                "is_ai_generated": False,
                "human_reviewed": False,
                "is_archived": False,
                "created_at": page.get("created_time"),
                "updated_at": page.get("last_edited_time"),
            })

            # Create test_execution if test has been executed
            test_status = self._get_property(props, "Primary Status") or "Not Run"
            if test_status not in ("Not Run", ""):
                notes_parts = []
                actual_result = self._get_property(props, "Actual Result")
                defect_notes = self._get_property(props, "Defect Notes")
                if actual_result:
                    notes_parts.append(actual_result)
                if defect_notes:
                    notes_parts.append(f"Defect: {defect_notes}")

                test_executions.append({
                    "test_case_id": test_case_id,
                    "story_id": story_id,
                    "assigned_to": "SYSTEM",
                    "assigned_by": "SYSTEM",
                    "status": map_test_status_to_execution(test_status),
                    "step_results": "[]",
                    "notes": "\n\n".join(notes_parts) if notes_parts else None,
                    "created_at": page.get("created_time"),
                    "updated_at": page.get("last_edited_time"),
                })

        return test_cases, test_executions


# ---------------------------------------------------------------------------
# SUPABASE UPSERTER
# ---------------------------------------------------------------------------

class SupabaseUpserter:
    """Handles batched upserts to Supabase."""

    def __init__(self, url: str, key: str, dry_run: bool = False):
        self.url = url
        self.key = key
        self.dry_run = dry_run
        self.client = None
        self.stats = {}

    def connect(self):
        from supabase import create_client
        print(f"Connecting to Supabase: {self.url}")
        self.client = create_client(self.url, self.key)

    def upsert_table(self, table: str, rows: list[dict], conflict_column: str = None):
        """
        Upsert rows into a Supabase table in batches.

        PARAMETERS:
            table: Table name
            rows: List of row dicts
            conflict_column: Column for ON CONFLICT (uses table PK by default)
        """
        count = len(rows)
        self.stats[table] = {"expected": count, "inserted": 0, "errors": []}

        if count == 0:
            print(f"  {table}: 0 rows (skipped)")
            return

        if self.dry_run:
            print(f"  {table}: {count} rows (preview — would upsert)")
            # Show sample in preview mode
            if count > 0:
                sample = rows[0]
                keys = list(sample.keys())[:5]
                print(f"    Sample keys: {keys}")
                print(f"    Sample values: {[sample[k] for k in keys]}")
            return

        print(f"  {table}: upserting {count} rows...", end="", flush=True)

        # Clean rows: remove None-valued keys for optional fields,
        # and convert remaining values to Supabase-compatible types
        cleaned_rows = []
        for row in rows:
            cleaned = {}
            for k, v in row.items():
                if v is None:
                    cleaned[k] = None
                elif isinstance(v, bool):
                    cleaned[k] = v
                else:
                    cleaned[k] = v
            cleaned_rows.append(cleaned)

        # Batch upsert
        for i in range(0, count, BATCH_SIZE):
            batch = cleaned_rows[i : i + BATCH_SIZE]
            try:
                if conflict_column:
                    self.client.table(table).upsert(
                        batch, on_conflict=conflict_column
                    ).execute()
                else:
                    self.client.table(table).upsert(batch).execute()
                self.stats[table]["inserted"] += len(batch)
                print(".", end="", flush=True)
            except Exception as e:
                error_msg = str(e)
                self.stats[table]["errors"].append(f"Batch {i//BATCH_SIZE}: {error_msg}")
                print(f"\n    ERROR at batch {i//BATCH_SIZE}: {error_msg[:200]}")

        inserted = self.stats[table]["inserted"]
        errors = len(self.stats[table]["errors"])
        status = "OK" if errors == 0 else f"{errors} errors"
        print(f" {inserted}/{count} ({status})")

    def insert_table(self, table: str, rows: list[dict]):
        """Insert rows (no upsert — for tables with auto-increment PKs)."""
        count = len(rows)
        self.stats[table] = {"expected": count, "inserted": 0, "errors": []}

        if count == 0:
            print(f"  {table}: 0 rows (skipped)")
            return

        if self.dry_run:
            print(f"  {table}: {count} rows (preview — would insert)")
            return

        print(f"  {table}: inserting {count} rows...", end="", flush=True)

        for i in range(0, count, BATCH_SIZE):
            batch = rows[i : i + BATCH_SIZE]
            try:
                self.client.table(table).insert(batch).execute()
                self.stats[table]["inserted"] += len(batch)
                print(".", end="", flush=True)
            except Exception as e:
                error_msg = str(e)
                self.stats[table]["errors"].append(f"Batch {i//BATCH_SIZE}: {error_msg}")
                print(f"\n    ERROR at batch {i//BATCH_SIZE}: {error_msg[:200]}")

        inserted = self.stats[table]["inserted"]
        print(f" {inserted}/{count}")

    def print_summary(self):
        """Print migration summary."""
        print("\n" + "=" * 60)
        print("MIGRATION SUMMARY")
        print("=" * 60)
        total_expected = 0
        total_inserted = 0
        total_errors = 0
        for table, s in self.stats.items():
            total_expected += s["expected"]
            total_inserted += s["inserted"]
            total_errors += len(s["errors"])
            status = "OK" if not s["errors"] else "ERRORS"
            print(f"  {table:40s} {s['inserted']:>6d} / {s['expected']:>6d}  {status}")

        print("-" * 60)
        print(f"  {'TOTAL':40s} {total_inserted:>6d} / {total_expected:>6d}")
        if total_errors:
            print(f"\n  WARNING: {total_errors} batch errors occurred. Check output above.")
        else:
            print(f"\n  All rows migrated successfully.")


# ---------------------------------------------------------------------------
# VERIFICATION
# ---------------------------------------------------------------------------

def verify_migration(url: str, key: str):
    """Run post-migration verification checks."""
    from supabase import create_client

    print("=" * 60)
    print("POST-MIGRATION VERIFICATION")
    print("=" * 60)

    client = create_client(url, key)

    # Expected counts (from SQLite)
    expected = {
        "clients": 6,
        "programs": 12,
        "user_stories": 196,
        "requirements": 18,
        "uat_cycles": 3,   # Was 4, minus 1 skipped (UAT-ONB-V1 has NULL program_id)
        "users": 167,      # 166 from SQLite + 1 SYSTEM user
    }

    print("\n--- Row Count Checks ---")
    all_ok = True
    for table, expected_count in expected.items():
        resp = client.table(table).select("*", count="exact").limit(0).execute()
        actual = resp.count
        status = "OK" if actual >= expected_count else "MISMATCH"
        if actual < expected_count:
            all_ok = False
        print(f"  {table:30s} expected>={expected_count:>6d}  actual={actual:>6d}  {status}")

    # Test cases: migrated from uat_test_cases + Notion
    resp = client.table("test_cases").select("*", count="exact").limit(0).execute()
    test_count = resp.count
    print(f"  {'test_cases':30s} actual={test_count:>6d}  (SQLite + Notion NCCN/GRXP)")

    # Test executions
    resp = client.table("test_executions").select("*", count="exact").limit(0).execute()
    exec_count = resp.count
    print(f"  {'test_executions':30s} actual={exec_count:>6d}  (from executed tests)")

    # --- FK Integrity Checks ---
    print("\n--- FK Integrity Checks ---")

    # Orphan stories (stories referencing non-existent programs)
    stories = client.table("user_stories").select("story_id, program_id").execute()
    programs = client.table("programs").select("program_id").execute()
    program_ids = {p["program_id"] for p in programs.data}
    orphan_stories = [s for s in stories.data if s["program_id"] not in program_ids]
    print(f"  Orphan stories (bad program_id): {len(orphan_stories)}")

    # Orphan test_cases (tests referencing non-existent stories)
    tests = client.table("test_cases").select("test_case_id, story_id").limit(1000).execute()
    story_ids = {s["story_id"] for s in stories.data}
    orphan_tests = [t for t in tests.data if t.get("story_id") and t["story_id"] not in story_ids]
    print(f"  Orphan test_cases (bad story_id): {len(orphan_tests)}")
    if orphan_tests:
        for t in orphan_tests[:5]:
            print(f"    - {t['test_case_id']} -> story_id={t['story_id']}")

    # --- Archived Tables Check ---
    print("\n--- Archive Schema Check ---")
    archived_tables = [
        "uat_test_cases", "uat_test_assignments", "audit_history",
        "roadmap_projects", "user_access", "user_training",
    ]
    for tbl in archived_tables:
        try:
            # This should fail if the table was properly archived from public
            client.table(tbl).select("*", count="exact").limit(0).execute()
            print(f"  {tbl:30s} WARNING — still in public schema!")
            all_ok = False
        except Exception:
            print(f"  {tbl:30s} OK — archived (not in public)")

    # --- JSONB Field Checks ---
    print("\n--- JSONB Field Spot-Checks ---")
    sample_stories = client.table("user_stories").select(
        "story_id, related_stories, flags"
    ).limit(5).execute()
    for s in sample_stories.data:
        rs = s.get("related_stories")
        fl = s.get("flags")
        rs_ok = isinstance(rs, (list, type(None)))
        fl_ok = isinstance(fl, (list, type(None)))
        print(f"  {s['story_id']}: related_stories={'OK' if rs_ok else 'BAD'}  flags={'OK' if fl_ok else 'BAD'}")

    # Check test_cases.test_steps JSONB
    sample_tests = client.table("test_cases").select(
        "test_case_id, test_steps"
    ).limit(3).execute()
    for t in sample_tests.data:
        ts = t.get("test_steps")
        ts_ok = isinstance(ts, (list, type(None)))
        print(f"  {t['test_case_id'][:12]}...: test_steps={'OK' if ts_ok else 'BAD'}")

    print("\n" + ("VERIFICATION PASSED" if all_ok else "VERIFICATION HAS ISSUES — review above"))


# ---------------------------------------------------------------------------
# MAIN ORCHESTRATION
# ---------------------------------------------------------------------------

def run_migration(args):
    """Execute the full migration pipeline."""

    # Load environment
    try:
        from dotenv import load_dotenv
        load_dotenv()
    except ImportError:
        pass

    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_KEY")

    if not url or not key:
        print("ERROR: Set SUPABASE_URL and SUPABASE_SERVICE_KEY environment variables.")
        print("  export SUPABASE_URL='https://royctwjkewpnrcqdyhzd.supabase.co'")
        print("  export SUPABASE_SERVICE_KEY='your-service-role-key'")
        sys.exit(1)

    if args.verify:
        verify_migration(url, key)
        return

    dry_run = args.preview
    skip_notion = args.skip_notion
    notion_only = args.notion_only

    # --- Phase 3a: SQLite Extraction ---
    if not notion_only:
        print("\n" + "=" * 60)
        print("PHASE 3a: SQLite → Supabase")
        print("=" * 60)

        db_path = Path(args.db) if args.db else DEFAULT_DB_PATH
        reader = SQLiteReader(db_path)
        reader.connect()

        upserter = SupabaseUpserter(url, key, dry_run=dry_run)
        if not dry_run:
            upserter.connect()

        # Auto-cleanup: delete rows from insert-only tables that have unique
        # constraints. Without this, re-running the script fails with duplicate
        # key errors unless you manually run 007_truncate_data.sql first.
        # NOTE: Archived tables removed — they no longer exist in public schema.
        if not dry_run:
            print("\n--- Cleaning insert-only tables for idempotent re-run ---")
            _insert_only_tables = [
                # (table_name, filter_column, col_type)
                # col_type: "int" for gte(0), "uuid" for neq(nil UUID), "text" for neq(sentinel)
                # Order: children before parents (FK safe deletion order).
                ("test_executions", "execution_id", "uuid"),
                ("onboarding_dependencies", "project_id", "text"),
                ("onboarding_milestones", "project_id", "text"),
                ("config_values", "config_key", "text"),
            ]
            for tbl, col, col_type in _insert_only_tables:
                try:
                    if col_type == "int":
                        upserter.client.table(tbl).delete().gte(col, 0).execute()
                    elif col_type == "uuid":
                        upserter.client.table(tbl).delete().neq(col, "00000000-0000-0000-0000-000000000000").execute()
                    else:
                        upserter.client.table(tbl).delete().neq(col, "__never_matches__").execute()
                    print(f"  Cleared {tbl}")
                except Exception as e:
                    print(f"  Note: {tbl} cleanup — {e}")

        # Insert order respects FK dependencies
        print("\n--- Core Tables ---")
        upserter.upsert_table("clients", reader.get_clients(), "client_id")
        upserter.upsert_table("programs", reader.get_programs(), "program_id")
        upserter.upsert_table("program_relationships", reader.get_program_relationships(),
                              "parent_program_id,attached_program_id")

        print("\n--- Location Hierarchy ---")
        upserter.upsert_table("clinics", reader.get_clinics(), "clinic_id")
        upserter.upsert_table("locations", reader.get_locations(), "location_id")
        providers = reader.get_providers()
        raw_provider_locs = reader.get_provider_locations_raw()
        # Clear stale providers from previous runs (SERIAL PK + unique NPI causes conflicts)
        if not upserter.dry_run:
            try:
                upserter.client.table("provider_locations").delete().gte("provider_id", 1).execute()
                upserter.client.table("providers").delete().gte("provider_id", 1).execute()
                print("  (cleared existing providers)")
            except Exception as e:
                print(f"  (provider cleanup note: {e})")
        upserter.insert_table("providers", providers)
        # Look up Supabase-generated provider_ids by NPI/name, then build provider_locations
        if not upserter.dry_run and raw_provider_locs:
            try:
                resp = upserter.client.table("providers").select("provider_id, npi, name").execute()
                npi_to_id = {p["npi"]: p["provider_id"] for p in resp.data if p.get("npi")}
                name_to_id = {p["name"]: p["provider_id"] for p in resp.data if p.get("name")}
                provider_locations = []
                for pl in raw_provider_locs:
                    pid = npi_to_id.get(pl["npi"]) or name_to_id.get(pl["name"])
                    if pid:
                        provider_locations.append({
                            "provider_id": pid,
                            "location_id": pl["location_id"],
                            "is_primary": True,
                        })
                upserter.insert_table("provider_locations", provider_locations)
            except Exception as e:
                print(f"  provider_locations: ERROR mapping IDs — {e}")
        elif upserter.dry_run:
            print(f"  provider_locations: {len(raw_provider_locs)} rows (preview — would insert)")

        print("\n--- Configuration ---")
        upserter.upsert_table("config_definitions", reader.get_config_definitions(), "config_key")
        upserter.insert_table("config_values", reader.get_config_values())

        print("\n--- Requirements & Stories ---")
        upserter.upsert_table("requirements", reader.get_requirements(), "requirement_id")
        upserter.upsert_table("users", reader.get_users(), "user_id")
        upserter.upsert_table("user_stories", reader.get_user_stories(), "story_id")

        print("\n--- UAT ---")
        # Ensure a "SYSTEM" user exists — uat_cycles.created_by and
        # test_cases.created_by reference users(user_id).
        if not upserter.dry_run:
            try:
                upserter.client.table("users").upsert({
                    "user_id": "SYSTEM",
                    "name": "System",
                    "email": "system@propelhealth.com",
                    "organization": "Internal",
                    "status": "Active",
                }, on_conflict="user_id").execute()
                print("  (ensured SYSTEM user exists)")
            except Exception as e:
                print(f"  (SYSTEM user note: {e})")
        upserter.upsert_table("uat_cycles", reader.get_uat_cycles(), "cycle_id")

        # Test cases → TraceWell's test_cases table (UUID PK, JSONB test_steps)
        sqlite_tests, sqlite_executions = reader.get_test_cases(
            exclude_program_ids=NOTION_EXCLUDED_PROGRAM_IDS
        )
        upserter.upsert_table("test_cases", sqlite_tests, "test_case_id")
        if sqlite_executions:
            upserter.insert_table("test_executions", sqlite_executions)

        print("\n--- Onboarding ---")
        upserter.upsert_table("onboarding_projects", reader.get_onboarding_projects(), "project_id")
        upserter.insert_table("onboarding_milestones", reader.get_onboarding_milestones())
        upserter.insert_table("onboarding_dependencies", reader.get_onboarding_dependencies())

        reader.close()
        upserter.print_summary()

    # --- Phase 3b: Notion Extraction ---
    if not skip_notion:
        notion_key = os.environ.get("NOTION_API_KEY")
        if not notion_key:
            print("\nNOTION_API_KEY not set — skipping Notion import.")
            print("  Set it to import NCCN/GRXP tests from Notion.")
            return

        print("\n" + "=" * 60)
        print("PHASE 3b: Notion → Supabase (test_cases)")
        print("=" * 60)

        notion = NotionReader(notion_key)
        upserter = SupabaseUpserter(url, key, dry_run=dry_run)
        if not dry_run:
            upserter.connect()

        # Build cycle name → ID map from Supabase (for future cycle_id mapping)
        if not dry_run:
            cycles_resp = upserter.client.table("uat_cycles").select("cycle_id, name").execute()
            cycle_id_map = {c["name"]: c["cycle_id"] for c in cycles_resp.data}
        else:
            cycle_id_map = {}

        # NCCN
        if not notion_only or notion_only == "nccn":
            nccn_tests, nccn_executions = notion.get_nccn_tests(cycle_id_map)
            upserter.upsert_table("test_cases", nccn_tests, "test_case_id")
            if nccn_executions:
                upserter.insert_table("test_executions", nccn_executions)

        # GRXP
        if not notion_only or notion_only == "grxp":
            grxp_tests, grxp_executions = notion.get_grxp_tests(cycle_id_map)
            upserter.upsert_table("test_cases", grxp_tests, "test_case_id")
            if grxp_executions:
                upserter.insert_table("test_executions", grxp_executions)

        upserter.print_summary()

    print("\nDone. Run with --verify to check data integrity.")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Consolidate SQLite + Notion data into Supabase"
    )
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--preview", action="store_true", help="Dry run — show what would be inserted")
    mode.add_argument("--execute", action="store_true", help="Execute full migration")
    mode.add_argument("--verify", action="store_true", help="Post-migration verification")

    parser.add_argument("--db", type=str, help="Path to SQLite database (default: ~/projects/data/client_product_database.db)")
    parser.add_argument("--skip-notion", action="store_true", help="Skip Notion import (SQLite only)")
    parser.add_argument("--notion-only", type=str, choices=["nccn", "grxp"],
                        help="Only import from a specific Notion database")

    args = parser.parse_args()
    run_migration(args)


if __name__ == "__main__":
    main()
