#!/usr/bin/env python3
"""
SQLite to CSV Exporter for Supabase
===================================
PURPOSE: Exports all tables from SQLite to CSV files that can be imported
         directly into Supabase using the dashboard or COPY command.

R EQUIVALENT: Like using write.csv() on each table from a database connection,
              but with transformations for PostgreSQL compatibility.

USAGE:
    python3 export_sqlite_to_csv.py
    python3 export_sqlite_to_csv.py --db /path/to/database.db
    python3 export_sqlite_to_csv.py --output-dir ./csv_exports

OUTPUT:
    migrations/supabase/csv/
    ├── 01_clients.csv
    ├── 02_programs.csv
    ├── 03_clinics.csv
    ├── 04_locations.csv
    ├── 05_providers.csv
    ├── 06_provider_locations.csv
    ├── 07_requirements.csv
    ├── 08_user_stories.csv
    ├── 09_uat_cycles.csv
    ├── 10_uat_test_cases.csv
    └── ... (all other tables)
"""

import sqlite3
import csv
import json
import os
import argparse
from datetime import datetime
from pathlib import Path
from typing import Any, Optional, List, Dict


# =============================================================================
# CONFIGURATION
# =============================================================================

DEFAULT_DB_PATH = Path.home() / "projects" / "data" / "client_product_database.db"
DEFAULT_OUTPUT_DIR = Path(__file__).parent / "csv"


# =============================================================================
# TRANSFORMATION FUNCTIONS
# =============================================================================

def convert_bool(value: Any) -> str:
    """Convert SQLite integer boolean to PostgreSQL boolean string."""
    if value is None:
        return ""
    if isinstance(value, bool):
        return "true" if value else "false"
    return "true" if value else "false"


def convert_json(value: Any) -> str:
    """
    Convert a value to JSON string for JSONB columns.
    Handles TEXT that contains JSON or comma-separated values.
    """
    if value is None or value == "":
        return ""

    # If it's already a dict or list, just serialize
    if isinstance(value, (dict, list)):
        return json.dumps(value)

    # Try to parse as JSON
    try:
        parsed = json.loads(value)
        return json.dumps(parsed)
    except (json.JSONDecodeError, TypeError):
        pass

    # If it looks like comma-separated values, convert to array
    if isinstance(value, str) and "," in value and not value.startswith("{"):
        items = [item.strip() for item in value.split(",") if item.strip()]
        return json.dumps(items)

    return str(value)


def clean_value(value: Any) -> str:
    """Clean a value for CSV output."""
    if value is None:
        return ""
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


class CSVExporter:
    """
    Exports SQLite tables to CSV files for Supabase import.

    Handles all necessary transformations:
    - Boolean conversion (0/1 → true/false)
    - JSON field formatting
    - Column renaming (created_date → created_at)
    - Provider normalization (creates junction table)
    """

    def __init__(self, db_path: Path, output_dir: Path):
        self.db_path = db_path
        self.output_dir = output_dir
        self.conn = None
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def connect(self):
        """Open database connection."""
        print(f"Connecting to: {self.db_path}")
        self.conn = sqlite3.connect(str(self.db_path))
        self.conn.row_factory = sqlite3.Row

    def close(self):
        """Close database connection."""
        if self.conn:
            self.conn.close()

    def table_exists(self, table: str) -> bool:
        """Check if a table exists."""
        cursor = self.conn.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
            (table,)
        )
        return cursor.fetchone() is not None

    def get_row_count(self, table: str) -> int:
        """Get row count for a table."""
        cursor = self.conn.execute(f"SELECT COUNT(*) FROM {table}")
        return cursor.fetchone()[0]

    def write_csv(self, filename: str, headers: List[str], rows: List[List[Any]]) -> int:
        """
        Write data to a CSV file.

        PARAMETERS:
            filename: Output filename
            headers: Column headers
            rows: List of row data

        RETURNS:
            Number of rows written
        """
        filepath = self.output_dir / filename

        with open(filepath, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
            writer.writerow(headers)
            writer.writerows(rows)

        print(f"  Written: {filename} ({len(rows)} rows)")
        return len(rows)

    # =========================================================================
    # TABLE EXPORT METHODS
    # =========================================================================

    def export_clients(self) -> int:
        """Export clients table with column consolidation."""
        if not self.table_exists("clients"):
            return 0

        headers = [
            "client_id", "name", "short_name", "description", "client_type",
            "primary_contact_name", "primary_contact_email", "primary_contact_phone",
            "contract_reference", "contract_start_date", "contract_end_date",
            "source_document", "status", "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM clients")

        for row in cursor:
            r = dict(row)
            # Consolidate duplicate contact columns
            contact_name = r.get("primary_contact_name") or r.get("primary_contact") or ""
            contact_email = r.get("primary_contact_email") or r.get("contact_email") or ""

            rows.append([
                clean_value(r.get("client_id")),
                clean_value(r.get("name")),
                clean_value(r.get("short_name")),
                clean_value(r.get("description")),
                clean_value(r.get("client_type")),
                clean_value(contact_name),
                clean_value(contact_email),
                clean_value(r.get("primary_contact_phone")),
                clean_value(r.get("contract_reference")),
                clean_value(r.get("contract_start_date")),
                clean_value(r.get("contract_end_date")),
                clean_value(r.get("source_document")),
                clean_value(r.get("status") or "Active"),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("01_clients.csv", headers, rows)

    def export_programs(self) -> int:
        """Export programs table."""
        if not self.table_exists("programs"):
            return 0

        headers = [
            "program_id", "client_id", "name", "prefix", "description",
            "program_type", "source_file", "color_hex", "status",
            "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM programs")

        for row in cursor:
            r = dict(row)
            rows.append([
                clean_value(r.get("program_id")),
                clean_value(r.get("client_id")),
                clean_value(r.get("name")),
                clean_value(r.get("prefix")),
                clean_value(r.get("description")),
                clean_value(r.get("program_type") or "clinic_based"),
                clean_value(r.get("source_file")),
                clean_value(r.get("color_hex")),
                clean_value(r.get("status") or "Active"),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("02_programs.csv", headers, rows)

    def export_clinics(self) -> int:
        """Export clinics table."""
        if not self.table_exists("clinics"):
            return 0

        headers = [
            "clinic_id", "program_id", "name", "code", "description",
            "phone", "fax", "email",
            "address_street", "address_city", "address_state", "address_zip",
            "manager_name", "manager_email", "epic_id",
            "status", "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM clinics")

        for row in cursor:
            r = dict(row)
            rows.append([
                clean_value(r.get("clinic_id")),
                clean_value(r.get("program_id")),
                clean_value(r.get("name")),
                clean_value(r.get("code")),
                clean_value(r.get("description")),
                "",  # phone (new column)
                "",  # fax (new column)
                "",  # email (new column)
                "",  # address_street (new column)
                "",  # address_city (new column)
                "",  # address_state (new column)
                "",  # address_zip (new column)
                "",  # manager_name (new column)
                "",  # manager_email (new column)
                "",  # epic_id (new column)
                clean_value(r.get("status") or "Active"),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("03_clinics.csv", headers, rows)

    def export_locations(self) -> int:
        """Export locations table."""
        if not self.table_exists("locations"):
            return 0

        headers = [
            "location_id", "clinic_id", "name", "code",
            "address", "city", "state", "zip",
            "phone", "fax", "epic_id",
            "status", "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM locations")

        for row in cursor:
            r = dict(row)
            rows.append([
                clean_value(r.get("location_id")),
                clean_value(r.get("clinic_id")),
                clean_value(r.get("name")),
                clean_value(r.get("code")),
                clean_value(r.get("address")),
                clean_value(r.get("city")),
                clean_value(r.get("state")),
                clean_value(r.get("zip")),
                clean_value(r.get("phone")),
                clean_value(r.get("fax")),
                clean_value(r.get("epic_id")),
                clean_value(r.get("status") or "Active"),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("04_locations.csv", headers, rows)

    def export_providers(self) -> tuple:
        """
        Export providers with deduplication and create provider_locations junction.

        RETURNS:
            Tuple of (providers_count, provider_locations_count)
        """
        if not self.table_exists("providers"):
            return (0, 0)

        # --- Deduplicate providers ---
        cursor = self.conn.execute("SELECT * FROM providers ORDER BY provider_id")

        seen_providers = {}  # key -> provider data
        provider_locations_data = []  # (provider_key, location_id)

        for row in cursor:
            r = dict(row)

            # Create unique key
            npi = r.get("npi")
            name = r.get("name", "")
            email = r.get("email", "")

            key = f"npi:{npi}" if npi else f"name:{name}|email:{email}"
            location_id = r.get("location_id")

            if key not in seen_providers:
                seen_providers[key] = r

            if location_id:
                provider_locations_data.append((key, location_id))

        # --- Write providers.csv ---
        provider_headers = [
            "provider_id", "name", "npi", "specialty", "email", "phone",
            "is_active", "created_at", "updated_at"
        ]

        provider_rows = []
        provider_id_map = {}
        new_id = 1

        for key, r in seen_providers.items():
            provider_id_map[key] = new_id
            provider_rows.append([
                new_id,
                clean_value(r.get("name")),
                clean_value(r.get("npi")),
                clean_value(r.get("specialty")),
                clean_value(r.get("email")),
                clean_value(r.get("phone")),
                convert_bool(r.get("is_active", 1)),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])
            new_id += 1

        providers_count = self.write_csv("05_providers.csv", provider_headers, provider_rows)

        # --- Write provider_locations.csv ---
        junction_headers = ["provider_id", "location_id", "is_primary", "created_at"]
        junction_rows = []
        seen_pairs = set()

        for key, location_id in provider_locations_data:
            provider_id = provider_id_map.get(key)
            if provider_id and location_id:
                pair = (provider_id, location_id)
                if pair not in seen_pairs:
                    seen_pairs.add(pair)
                    junction_rows.append([
                        provider_id,
                        location_id,
                        "true",  # is_primary
                        "",  # created_at (will default to NOW())
                    ])

        junction_count = self.write_csv("06_provider_locations.csv", junction_headers, junction_rows)

        return (providers_count, junction_count)

    def export_requirements(self) -> int:
        """Export requirements table with JSON conversion."""
        if not self.table_exists("requirements"):
            return 0

        headers = [
            "requirement_id", "program_id", "source_file", "source_row",
            "raw_text", "title", "description", "priority", "source_status",
            "requirement_type", "context_json", "import_batch",
            "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM requirements")

        for row in cursor:
            r = dict(row)
            rows.append([
                clean_value(r.get("requirement_id")),
                clean_value(r.get("program_id")),
                clean_value(r.get("source_file")),
                clean_value(r.get("source_row")),
                clean_value(r.get("raw_text")),
                clean_value(r.get("title")),
                clean_value(r.get("description")),
                clean_value(r.get("priority")),
                clean_value(r.get("source_status")),
                clean_value(r.get("requirement_type")),
                convert_json(r.get("context_json")),
                clean_value(r.get("import_batch")),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("07_requirements.csv", headers, rows)

    def export_user_stories(self) -> int:
        """Export user_stories table with JSON arrays and status validation."""
        if not self.table_exists("user_stories"):
            return 0

        valid_statuses = {
            "Draft", "Internal Review", "Pending Client Review",
            "Approved", "Needs Discussion", "Out of Scope"
        }

        headers = [
            "story_id", "requirement_id", "program_id", "parent_story_id",
            "title", "user_story", "role", "capability", "benefit",
            "acceptance_criteria", "success_metrics", "priority",
            "category", "category_full", "is_technical", "status",
            "internal_notes", "meeting_context", "client_feedback",
            "related_stories", "flags", "roadmap_target", "version",
            "created_at", "updated_at", "approved_at", "approved_by",
            "draft_date", "internal_review_date", "client_review_date", "needs_discussion_date"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM user_stories")

        for row in cursor:
            r = dict(row)

            # Validate status
            status = r.get("status") or "Draft"
            if status not in valid_statuses:
                status = "Draft"

            rows.append([
                clean_value(r.get("story_id")),
                clean_value(r.get("requirement_id")),
                clean_value(r.get("program_id")),
                clean_value(r.get("parent_story_id")),
                clean_value(r.get("title")),
                clean_value(r.get("user_story")),
                clean_value(r.get("role")),
                clean_value(r.get("capability")),
                clean_value(r.get("benefit")),
                clean_value(r.get("acceptance_criteria")),
                clean_value(r.get("success_metrics")),
                clean_value(r.get("priority")),
                clean_value(r.get("category")),
                clean_value(r.get("category_full")),
                convert_bool(r.get("is_technical", True)),
                status,
                clean_value(r.get("internal_notes")),
                clean_value(r.get("meeting_context")),
                clean_value(r.get("client_feedback")),
                convert_json(r.get("related_stories")),
                convert_json(r.get("flags")),
                clean_value(r.get("roadmap_target")),
                clean_value(r.get("version") or 1),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
                clean_value(r.get("approved_date")),
                clean_value(r.get("approved_by")),
                clean_value(r.get("draft_date")),
                clean_value(r.get("internal_review_date")),
                clean_value(r.get("client_review_date")),
                clean_value(r.get("needs_discussion_date")),
            ])

        return self.write_csv("08_user_stories.csv", headers, rows)

    def export_uat_cycles(self) -> int:
        """Export uat_cycles table."""
        if not self.table_exists("uat_cycles"):
            return 0

        valid_statuses = {
            "planning", "validation", "kickoff", "testing",
            "review", "retesting", "decision", "complete", "cancelled"
        }

        headers = [
            "cycle_id", "program_id", "name", "description", "uat_type",
            "target_launch_date", "status", "clinical_pm", "clinical_pm_email",
            "validation_start", "validation_end", "kickoff_date",
            "testing_start", "testing_end", "review_date",
            "retest_start", "retest_end", "go_nogo_date",
            "pre_uat_gate_passed", "pre_uat_gate_signed_by",
            "pre_uat_gate_signed_date", "pre_uat_gate_notes",
            "go_nogo_decision", "go_nogo_signed_by", "go_nogo_signed_date", "go_nogo_notes",
            "created_at", "updated_at", "created_by"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM uat_cycles")

        for row in cursor:
            r = dict(row)

            status = r.get("status") or "planning"
            if status not in valid_statuses:
                status = "planning"

            rows.append([
                clean_value(r.get("cycle_id")),
                clean_value(r.get("program_id")),
                clean_value(r.get("name")),
                clean_value(r.get("description")),
                clean_value(r.get("uat_type")),
                clean_value(r.get("target_launch_date")),
                status,
                clean_value(r.get("clinical_pm")),
                clean_value(r.get("clinical_pm_email")),
                clean_value(r.get("validation_start")),
                clean_value(r.get("validation_end")),
                clean_value(r.get("kickoff_date")),
                clean_value(r.get("testing_start")),
                clean_value(r.get("testing_end")),
                clean_value(r.get("review_date")),
                clean_value(r.get("retest_start")),
                clean_value(r.get("retest_end")),
                clean_value(r.get("go_nogo_date")),
                convert_bool(r.get("pre_uat_gate_passed", 0)),
                clean_value(r.get("pre_uat_gate_signed_by")),
                clean_value(r.get("pre_uat_gate_signed_date")),
                clean_value(r.get("pre_uat_gate_notes")),
                clean_value(r.get("go_nogo_decision")),
                clean_value(r.get("go_nogo_signed_by")),
                clean_value(r.get("go_nogo_signed_date")),
                clean_value(r.get("go_nogo_notes")),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
                clean_value(r.get("created_by") or "system"),
            ])

        return self.write_csv("09_uat_cycles.csv", headers, rows)

    def export_uat_test_cases(self) -> int:
        """Export uat_test_cases table with JSON conversion."""
        if not self.table_exists("uat_test_cases"):
            return 0

        valid_statuses = {"Not Run", "Pass", "Fail", "Blocked", "Skipped"}

        headers = [
            "test_id", "story_id", "program_id", "uat_cycle_id",
            "title", "category", "test_type", "prerequisites",
            "test_steps", "expected_results", "priority", "estimated_time",
            "compliance_framework", "control_id", "is_compliance_test", "compliance_template_id",
            "test_status", "tested_by", "tested_date", "execution_notes",
            "defect_id", "defect_description",
            "assigned_to", "assignment_type", "persona", "profile_id", "platform",
            "workflow_section", "workflow_order",
            "change_id", "target_rule", "change_type",
            "patient_conditions", "cross_trigger_check",
            "retest_status", "retest_date", "retest_by", "retest_notes",
            "dev_notes", "dev_status", "notes",
            "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM uat_test_cases")

        for row in cursor:
            r = dict(row)

            test_status = r.get("test_status") or "Not Run"
            if test_status not in valid_statuses:
                test_status = "Not Run"

            rows.append([
                clean_value(r.get("test_id")),
                clean_value(r.get("story_id")),
                clean_value(r.get("program_id")),
                clean_value(r.get("uat_cycle_id")),
                clean_value(r.get("title")),
                clean_value(r.get("category")),
                clean_value(r.get("test_type")),
                clean_value(r.get("prerequisites")),
                clean_value(r.get("test_steps")),
                clean_value(r.get("expected_results")),
                clean_value(r.get("priority")),
                clean_value(r.get("estimated_time")),
                clean_value(r.get("compliance_framework")),
                clean_value(r.get("control_id")),
                convert_bool(r.get("is_compliance_test", 0)),
                clean_value(r.get("compliance_template_id")),
                test_status,
                clean_value(r.get("tested_by")),
                clean_value(r.get("tested_date")),
                clean_value(r.get("execution_notes")),
                clean_value(r.get("defect_id")),
                clean_value(r.get("defect_description")),
                clean_value(r.get("assigned_to")),
                clean_value(r.get("assignment_type")),
                clean_value(r.get("persona")),
                clean_value(r.get("profile_id")),
                clean_value(r.get("platform")),
                clean_value(r.get("workflow_section")),
                clean_value(r.get("workflow_order") or 0),
                clean_value(r.get("change_id")),
                clean_value(r.get("target_rule")),
                clean_value(r.get("change_type")),
                convert_json(r.get("patient_conditions")),
                clean_value(r.get("cross_trigger_check")),
                clean_value(r.get("retest_status")),
                clean_value(r.get("retest_date")),
                clean_value(r.get("retest_by")),
                clean_value(r.get("retest_notes")),
                clean_value(r.get("dev_notes")),
                clean_value(r.get("dev_status")),
                clean_value(r.get("notes")),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("10_uat_test_cases.csv", headers, rows)

    def export_users(self) -> int:
        """Export users table."""
        if not self.table_exists("users"):
            return 0

        headers = [
            "user_id", "name", "email", "organization",
            "is_business_associate", "status", "notes",
            "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM users")

        for row in cursor:
            r = dict(row)

            status = r.get("status") or "Active"
            if status not in {"Active", "Inactive", "Terminated"}:
                status = "Active"

            rows.append([
                clean_value(r.get("user_id")),
                clean_value(r.get("name")),
                clean_value(r.get("email")),
                clean_value(r.get("organization") or "Internal"),
                convert_bool(r.get("is_business_associate", False)),
                status,
                clean_value(r.get("notes")),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("11_users.csv", headers, rows)

    def export_traceability(self) -> int:
        """Export traceability table."""
        if not self.table_exists("traceability"):
            return 0

        headers = [
            "program_id", "requirement_id", "story_id", "test_id",
            "coverage_status", "gap_notes", "compliance_coverage",
            "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM traceability")

        for row in cursor:
            r = dict(row)
            rows.append([
                clean_value(r.get("program_id")),
                clean_value(r.get("requirement_id")),
                clean_value(r.get("story_id")),
                clean_value(r.get("test_id")),
                clean_value(r.get("coverage_status")),
                clean_value(r.get("gap_notes")),
                clean_value(r.get("compliance_coverage")),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("12_traceability.csv", headers, rows)

    def export_compliance_gaps(self) -> int:
        """Export compliance_gaps table."""
        if not self.table_exists("compliance_gaps"):
            return 0

        headers = [
            "program_id", "requirement_id", "story_id",
            "framework", "control_id", "category", "gap_description",
            "recommendation", "severity", "status", "mitigation_plan",
            "owner", "due_date", "closed_date", "notes",
            "created_at", "updated_at"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM compliance_gaps")

        for row in cursor:
            r = dict(row)

            severity = r.get("severity")
            if severity not in {"Critical", "High", "Medium", "Low"}:
                severity = "Medium"

            status = r.get("status") or "Open"
            if status not in {"Open", "In Progress", "Resolved", "Accepted", "Deferred"}:
                status = "Open"

            rows.append([
                clean_value(r.get("program_id")),
                clean_value(r.get("requirement_id")),
                clean_value(r.get("story_id")),
                clean_value(r.get("framework")),
                clean_value(r.get("control_id")),
                clean_value(r.get("category")),
                clean_value(r.get("gap_description")),
                clean_value(r.get("recommendation")),
                severity,
                status,
                clean_value(r.get("mitigation_plan")),
                clean_value(r.get("owner")),
                clean_value(r.get("due_date")),
                clean_value(r.get("closed_date")),
                clean_value(r.get("notes")),
                clean_value(r.get("created_date")),
                clean_value(r.get("updated_date")),
            ])

        return self.write_csv("13_compliance_gaps.csv", headers, rows)

    def export_audit_history(self) -> int:
        """Export audit_history table."""
        if not self.table_exists("audit_history"):
            return 0

        headers = [
            "record_type", "record_id", "entity_type", "entity_id",
            "action", "field_changed", "old_value", "new_value",
            "changed_by", "changed_at", "change_reason",
            "session_id", "ip_address"
        ]

        rows = []
        cursor = self.conn.execute("SELECT * FROM audit_history")

        for row in cursor:
            r = dict(row)
            rows.append([
                clean_value(r.get("record_type")),
                clean_value(r.get("record_id")),
                clean_value(r.get("entity_type")),
                clean_value(r.get("entity_id")),
                clean_value(r.get("action")),
                clean_value(r.get("field_changed")),
                clean_value(r.get("old_value")),
                clean_value(r.get("new_value")),
                clean_value(r.get("changed_by") or "system"),
                clean_value(r.get("changed_date")),
                clean_value(r.get("change_reason")),
                clean_value(r.get("session_id")),
                clean_value(r.get("ip_address")),
            ])

        return self.write_csv("14_audit_history.csv", headers, rows)

    def export_all(self):
        """Export all tables to CSV files."""
        print(f"\n{'='*60}")
        print("SQLite to CSV Export for Supabase")
        print(f"{'='*60}")
        print(f"Database: {self.db_path}")
        print(f"Output: {self.output_dir}")
        print(f"{'='*60}\n")

        self.connect()

        try:
            totals = {}

            totals["clients"] = self.export_clients()
            totals["programs"] = self.export_programs()
            totals["clinics"] = self.export_clinics()
            totals["locations"] = self.export_locations()

            prov_counts = self.export_providers()
            totals["providers"] = prov_counts[0]
            totals["provider_locations"] = prov_counts[1]

            totals["requirements"] = self.export_requirements()
            totals["user_stories"] = self.export_user_stories()
            totals["uat_cycles"] = self.export_uat_cycles()
            totals["uat_test_cases"] = self.export_uat_test_cases()
            totals["users"] = self.export_users()
            totals["traceability"] = self.export_traceability()
            totals["compliance_gaps"] = self.export_compliance_gaps()
            totals["audit_history"] = self.export_audit_history()

            print(f"\n{'='*60}")
            print("Export Summary")
            print(f"{'='*60}")
            for table, count in totals.items():
                print(f"  {table}: {count} rows")
            print(f"{'='*60}")
            print(f"\nCSV files written to: {self.output_dir}")
            print("\nTo import into Supabase:")
            print("  1. Go to Table Editor → Import data")
            print("  2. Upload CSVs in numeric order (01, 02, 03...)")
            print("  3. Or use COPY command in SQL Editor")

        finally:
            self.close()


def main():
    parser = argparse.ArgumentParser(
        description="Export SQLite data to CSV for Supabase import"
    )
    parser.add_argument(
        "--db", type=Path, default=DEFAULT_DB_PATH,
        help=f"Path to SQLite database (default: {DEFAULT_DB_PATH})"
    )
    parser.add_argument(
        "--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR,
        help=f"Output directory for CSV files (default: {DEFAULT_OUTPUT_DIR})"
    )

    args = parser.parse_args()

    if not args.db.exists():
        print(f"Error: Database not found: {args.db}")
        return 1

    exporter = CSVExporter(args.db, args.output_dir)
    exporter.export_all()

    return 0


if __name__ == "__main__":
    exit(main())
