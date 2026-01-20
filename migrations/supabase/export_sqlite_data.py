#!/usr/bin/env python3
"""
SQLite to Supabase Data Exporter
================================
PURPOSE: Exports data from the SQLite database and generates PostgreSQL-compatible
         INSERT statements for importing into Supabase.

R EQUIVALENT: Similar to using DBI::dbReadTable() to read data, then generating
              SQL statements - but here we handle type conversions and transformations.

USAGE:
    python3 export_sqlite_data.py                    # Uses default database path
    python3 export_sqlite_data.py --db /path/to.db  # Specify database
    python3 export_sqlite_data.py --output-dir ./   # Specify output directory
    python3 export_sqlite_data.py --format csv      # Export as CSV instead of SQL

OUTPUT:
    - migrations/supabase/data/003a_clients_programs.sql
    - migrations/supabase/data/003b_clinics_locations.sql
    - migrations/supabase/data/003c_providers.sql
    - migrations/supabase/data/003d_requirements_stories.sql
    - migrations/supabase/data/003e_uat_tests.sql
    - migrations/supabase/data/003f_users_access.sql
    - migrations/supabase/data/003g_onboarding_roadmap.sql
    - migrations/supabase/data/003h_audit_history.sql
"""

import sqlite3
import json
import os
import argparse
from datetime import datetime
from pathlib import Path
from typing import Any, Optional


# =============================================================================
# CONFIGURATION
# =============================================================================

# Default database path (symlink to unified database)
DEFAULT_DB_PATH = Path.home() / "projects" / "data" / "client_product_database.db"

# Output directory for generated SQL files
DEFAULT_OUTPUT_DIR = Path(__file__).parent / "data"


# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

def escape_sql_string(value: Any) -> str:
    """
    Escape a value for safe inclusion in SQL statements.

    PURPOSE: Prevent SQL injection and handle special characters.
    R EQUIVALENT: DBI::dbQuoteLiteral() or sqlInterpolate()

    PARAMETERS:
        value: Any Python value to escape

    RETURNS:
        SQL-safe string representation
    """
    if value is None:
        return "NULL"

    if isinstance(value, bool):
        return "TRUE" if value else "FALSE"

    if isinstance(value, (int, float)):
        return str(value)

    if isinstance(value, str):
        # Escape single quotes by doubling them
        escaped = value.replace("'", "''")
        # Handle newlines and other special chars
        escaped = escaped.replace("\n", "\\n").replace("\r", "\\r")
        return f"'{escaped}'"

    if isinstance(value, (dict, list)):
        # Convert to JSON string for JSONB columns
        json_str = json.dumps(value).replace("'", "''")
        return f"'{json_str}'::JSONB"

    # Fallback: convert to string
    return f"'{str(value)}'"


def convert_sqlite_bool(value: Any) -> Optional[bool]:
    """
    Convert SQLite integer boolean to Python bool.

    WHY THIS APPROACH: SQLite stores booleans as 0/1 integers.
                       PostgreSQL has native BOOLEAN type.
    """
    if value is None:
        return None
    if isinstance(value, bool):
        return value
    return bool(value)


def convert_text_to_jsonb_array(value: str, delimiter: str = ",") -> list:
    """
    Convert a comma-separated TEXT field to a JSONB array.

    PURPOSE: SQLite stored arrays as comma-separated text.
             PostgreSQL/Supabase uses native JSONB arrays.

    PARAMETERS:
        value: Comma-separated string (e.g., "item1,item2,item3")
        delimiter: Character used to separate items (default: comma)

    RETURNS:
        List of strings, suitable for JSONB conversion
    """
    if not value or not value.strip():
        return []

    return [item.strip() for item in value.split(delimiter) if item.strip()]


def parse_json_or_default(value: str, default: Any = None) -> Any:
    """
    Safely parse a JSON string, returning default if invalid.

    WHY THIS APPROACH: Some TEXT fields contain JSON that may be malformed.
                       We need to handle gracefully without crashing.
    """
    if not value or not value.strip():
        return default

    try:
        return json.loads(value)
    except json.JSONDecodeError:
        # If it looks like comma-separated values, convert to array
        if "," in value and not value.startswith("{"):
            return convert_text_to_jsonb_array(value)
        return default


class SQLiteExporter:
    """
    Exports SQLite data to PostgreSQL-compatible INSERT statements.

    PURPOSE: Read data from SQLite, transform as needed, and generate
             SQL that can be run in Supabase's SQL Editor.

    R EQUIVALENT: Like creating a custom export function using DBI
                  that generates SQL statements from data frames.
    """

    def __init__(self, db_path: Path, output_dir: Path):
        """
        Initialize the exporter.

        PARAMETERS:
            db_path: Path to SQLite database file
            output_dir: Directory to write output SQL files
        """
        self.db_path = db_path
        self.output_dir = output_dir
        self.conn = None

        # Create output directory if it doesn't exist
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def connect(self):
        """Open database connection."""
        print(f"Connecting to: {self.db_path}")
        self.conn = sqlite3.connect(str(self.db_path))
        # Enable dictionary-style row access
        self.conn.row_factory = sqlite3.Row

    def close(self):
        """Close database connection."""
        if self.conn:
            self.conn.close()

    def get_table_count(self, table: str) -> int:
        """Get row count for a table."""
        cursor = self.conn.execute(f"SELECT COUNT(*) FROM {table}")
        return cursor.fetchone()[0]

    def table_exists(self, table: str) -> bool:
        """Check if a table exists in the database."""
        cursor = self.conn.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
            (table,)
        )
        return cursor.fetchone() is not None

    def write_sql_file(self, filename: str, content: str):
        """Write SQL content to a file."""
        filepath = self.output_dir / filename
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"  Written: {filepath}")

    # =========================================================================
    # EXPORT METHODS - One per logical group of tables
    # =========================================================================

    def export_clients_programs(self) -> str:
        """
        Export clients, programs, and program_relationships tables.

        TRANSFORMATIONS:
            - Remove duplicate contact columns from clients
            - Convert TEXT dates to DATE format
            - Rename timestamp columns (_date → _at)
        """
        lines = [
            "-- ==========================================================================",
            "-- CLIENTS AND PROGRAMS DATA",
            f"-- Exported: {datetime.now().isoformat()}",
            "-- ==========================================================================",
            "",
            "-- Disable triggers for bulk insert",
            "ALTER TABLE clients DISABLE TRIGGER ALL;",
            "ALTER TABLE programs DISABLE TRIGGER ALL;",
            "ALTER TABLE program_relationships DISABLE TRIGGER ALL;",
            "",
        ]

        # --- CLIENTS ---
        if self.table_exists("clients"):
            count = self.get_table_count("clients")
            print(f"  Exporting clients: {count} rows")

            lines.append("-- CLIENTS")
            cursor = self.conn.execute("SELECT * FROM clients")

            for row in cursor:
                row_dict = dict(row)

                # Use preferred contact columns, fall back to duplicates
                contact_name = row_dict.get("primary_contact_name") or row_dict.get("primary_contact")
                contact_email = row_dict.get("primary_contact_email") or row_dict.get("contact_email")
                contact_phone = row_dict.get("primary_contact_phone")

                values = {
                    "client_id": escape_sql_string(row_dict.get("client_id")),
                    "name": escape_sql_string(row_dict.get("name")),
                    "short_name": escape_sql_string(row_dict.get("short_name")),
                    "description": escape_sql_string(row_dict.get("description")),
                    "client_type": escape_sql_string(row_dict.get("client_type")),
                    "primary_contact_name": escape_sql_string(contact_name),
                    "primary_contact_email": escape_sql_string(contact_email),
                    "primary_contact_phone": escape_sql_string(contact_phone),
                    "contract_reference": escape_sql_string(row_dict.get("contract_reference")),
                    "contract_start_date": escape_sql_string(row_dict.get("contract_start_date")),
                    "contract_end_date": escape_sql_string(row_dict.get("contract_end_date")),
                    "source_document": escape_sql_string(row_dict.get("source_document")),
                    "status": escape_sql_string(row_dict.get("status") or "Active"),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                }

                lines.append(f"""INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    {values['client_id']}, {values['name']}, {values['short_name']}, {values['description']}, {values['client_type']},
    {values['primary_contact_name']}, {values['primary_contact_email']}, {values['primary_contact_phone']},
    {values['contract_reference']}, {values['contract_start_date']}, {values['contract_end_date']},
    {values['source_document']}, {values['status']}, COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;
""")
            lines.append("")

        # --- PROGRAMS ---
        if self.table_exists("programs"):
            count = self.get_table_count("programs")
            print(f"  Exporting programs: {count} rows")

            lines.append("-- PROGRAMS")
            cursor = self.conn.execute("SELECT * FROM programs")

            for row in cursor:
                row_dict = dict(row)

                values = {
                    "program_id": escape_sql_string(row_dict.get("program_id")),
                    "client_id": escape_sql_string(row_dict.get("client_id")),
                    "name": escape_sql_string(row_dict.get("name")),
                    "prefix": escape_sql_string(row_dict.get("prefix")),
                    "description": escape_sql_string(row_dict.get("description")),
                    "program_type": escape_sql_string(row_dict.get("program_type") or "clinic_based"),
                    "source_file": escape_sql_string(row_dict.get("source_file")),
                    "color_hex": escape_sql_string(row_dict.get("color_hex")),
                    "status": escape_sql_string(row_dict.get("status") or "Active"),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                }

                lines.append(f"""INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    {values['program_id']}, {values['client_id']}, {values['name']}, {values['prefix']}, {values['description']},
    {values['program_type']}, {values['source_file']}, {values['color_hex']}, {values['status']},
    COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;
""")
            lines.append("")

        # --- PROGRAM RELATIONSHIPS ---
        if self.table_exists("program_relationships"):
            count = self.get_table_count("program_relationships")
            print(f"  Exporting program_relationships: {count} rows")

            lines.append("-- PROGRAM RELATIONSHIPS")
            cursor = self.conn.execute("SELECT * FROM program_relationships")

            for row in cursor:
                row_dict = dict(row)

                values = {
                    "parent_program_id": escape_sql_string(row_dict.get("parent_program_id")),
                    "attached_program_id": escape_sql_string(row_dict.get("attached_program_id")),
                    "relationship_type": escape_sql_string(row_dict.get("relationship_type") or "attached"),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                }

                lines.append(f"""INSERT INTO program_relationships (parent_program_id, attached_program_id, relationship_type, created_at)
VALUES ({values['parent_program_id']}, {values['attached_program_id']}, {values['relationship_type']}, COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()))
ON CONFLICT (parent_program_id, attached_program_id) DO NOTHING;
""")
            lines.append("")

        # Re-enable triggers
        lines.extend([
            "-- Re-enable triggers",
            "ALTER TABLE clients ENABLE TRIGGER ALL;",
            "ALTER TABLE programs ENABLE TRIGGER ALL;",
            "ALTER TABLE program_relationships ENABLE TRIGGER ALL;",
            "",
            "-- Verify counts",
            "SELECT 'clients' AS table_name, COUNT(*) AS row_count FROM clients",
            "UNION ALL SELECT 'programs', COUNT(*) FROM programs",
            "UNION ALL SELECT 'program_relationships', COUNT(*) FROM program_relationships;",
        ])

        return "\n".join(lines)

    def export_clinics_locations(self) -> str:
        """
        Export clinics and locations tables.

        TRANSFORMATIONS:
            - Add placeholder NULLs for new columns (phone, fax, email, address, manager)
        """
        lines = [
            "-- ==========================================================================",
            "-- CLINICS AND LOCATIONS DATA",
            f"-- Exported: {datetime.now().isoformat()}",
            "-- ==========================================================================",
            "",
            "ALTER TABLE clinics DISABLE TRIGGER ALL;",
            "ALTER TABLE locations DISABLE TRIGGER ALL;",
            "",
        ]

        # --- CLINICS ---
        if self.table_exists("clinics"):
            count = self.get_table_count("clinics")
            print(f"  Exporting clinics: {count} rows")

            lines.append("-- CLINICS")
            cursor = self.conn.execute("SELECT * FROM clinics")

            for row in cursor:
                row_dict = dict(row)

                values = {
                    "clinic_id": escape_sql_string(row_dict.get("clinic_id")),
                    "program_id": escape_sql_string(row_dict.get("program_id")),
                    "name": escape_sql_string(row_dict.get("name")),
                    "code": escape_sql_string(row_dict.get("code")),
                    "description": escape_sql_string(row_dict.get("description")),
                    "status": escape_sql_string(row_dict.get("status") or "Active"),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                }

                lines.append(f"""INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    {values['clinic_id']}, {values['program_id']}, {values['name']}, {values['code']}, {values['description']},
    {values['status']}, COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;
""")
            lines.append("")

        # --- LOCATIONS ---
        if self.table_exists("locations"):
            count = self.get_table_count("locations")
            print(f"  Exporting locations: {count} rows")

            lines.append("-- LOCATIONS")
            cursor = self.conn.execute("SELECT * FROM locations")

            for row in cursor:
                row_dict = dict(row)

                values = {
                    "location_id": escape_sql_string(row_dict.get("location_id")),
                    "clinic_id": escape_sql_string(row_dict.get("clinic_id")),
                    "name": escape_sql_string(row_dict.get("name")),
                    "code": escape_sql_string(row_dict.get("code")),
                    "address": escape_sql_string(row_dict.get("address")),
                    "city": escape_sql_string(row_dict.get("city")),
                    "state": escape_sql_string(row_dict.get("state")),
                    "zip": escape_sql_string(row_dict.get("zip")),
                    "phone": escape_sql_string(row_dict.get("phone")),
                    "fax": escape_sql_string(row_dict.get("fax")),
                    "epic_id": escape_sql_string(row_dict.get("epic_id")),
                    "status": escape_sql_string(row_dict.get("status") or "Active"),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                }

                lines.append(f"""INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    {values['location_id']}, {values['clinic_id']}, {values['name']}, {values['code']},
    {values['address']}, {values['city']}, {values['state']}, {values['zip']},
    {values['phone']}, {values['fax']}, {values['epic_id']}, {values['status']},
    COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;
""")
            lines.append("")

        lines.extend([
            "ALTER TABLE clinics ENABLE TRIGGER ALL;",
            "ALTER TABLE locations ENABLE TRIGGER ALL;",
            "",
            "SELECT 'clinics' AS table_name, COUNT(*) AS row_count FROM clinics",
            "UNION ALL SELECT 'locations', COUNT(*) FROM locations;",
        ])

        return "\n".join(lines)

    def export_providers(self) -> str:
        """
        Export providers and create provider_locations junction records.

        TRANSFORMATIONS:
            - Deduplicate providers by NPI (or name+email)
            - Create provider_locations records from original location_id
            - Convert is_active INTEGER to BOOLEAN
        """
        lines = [
            "-- ==========================================================================",
            "-- PROVIDERS DATA (Normalized to many-to-many)",
            f"-- Exported: {datetime.now().isoformat()}",
            "-- ==========================================================================",
            "",
            "ALTER TABLE providers DISABLE TRIGGER ALL;",
            "",
        ]

        if not self.table_exists("providers"):
            lines.append("-- No providers table found in source database")
            return "\n".join(lines)

        count = self.get_table_count("providers")
        print(f"  Exporting providers: {count} rows")

        # First, deduplicate providers and track which locations they belong to
        cursor = self.conn.execute("SELECT * FROM providers ORDER BY provider_id")

        # Track unique providers and their locations
        seen_providers = {}  # key: (npi or name+email) -> provider data
        provider_locations = []  # list of (provider_key, location_id)

        for row in cursor:
            row_dict = dict(row)

            # Create a unique key for deduplication
            npi = row_dict.get("npi")
            name = row_dict.get("name", "")
            email = row_dict.get("email", "")

            if npi:
                key = f"npi:{npi}"
            else:
                key = f"name:{name}|email:{email}"

            location_id = row_dict.get("location_id")

            if key not in seen_providers:
                # First time seeing this provider
                seen_providers[key] = row_dict

            # Track the location mapping
            if location_id:
                provider_locations.append((key, location_id))

        print(f"    Deduplicated to {len(seen_providers)} unique providers")
        print(f"    Creating {len(provider_locations)} provider_locations records")

        # Export unique providers
        lines.append("-- PROVIDERS (deduplicated)")
        provider_id_map = {}  # key -> new provider_id
        new_provider_id = 1

        for key, row_dict in seen_providers.items():
            provider_id_map[key] = new_provider_id

            is_active = convert_sqlite_bool(row_dict.get("is_active", 1))

            values = {
                "provider_id": new_provider_id,
                "name": escape_sql_string(row_dict.get("name")),
                "npi": escape_sql_string(row_dict.get("npi")),
                "specialty": escape_sql_string(row_dict.get("specialty")),
                "email": escape_sql_string(row_dict.get("email")),
                "phone": escape_sql_string(row_dict.get("phone")),
                "is_active": "TRUE" if is_active else "FALSE",
                "created_at": escape_sql_string(row_dict.get("created_date")),
                "updated_at": escape_sql_string(row_dict.get("updated_date")),
            }

            lines.append(f"""INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES ({values['provider_id']}, {values['name']}, {values['npi']}, {values['specialty']}, {values['email']}, {values['phone']}, {values['is_active']}, COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW()));
""")
            new_provider_id += 1

        lines.append("")
        lines.append("-- PROVIDER_LOCATIONS (junction table)")

        # Track which provider-location pairs we've seen to avoid duplicates
        seen_pairs = set()

        for key, location_id in provider_locations:
            provider_id = provider_id_map.get(key)
            if provider_id and location_id:
                pair = (provider_id, location_id)
                if pair not in seen_pairs:
                    seen_pairs.add(pair)
                    lines.append(f"""INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES ({provider_id}, {escape_sql_string(location_id)}, TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;
""")

        lines.extend([
            "",
            "ALTER TABLE providers ENABLE TRIGGER ALL;",
            "",
            f"-- Reset sequence to next available ID",
            f"SELECT setval('providers_provider_id_seq', {new_provider_id}, false);",
            "",
            "SELECT 'providers' AS table_name, COUNT(*) AS row_count FROM providers",
            "UNION ALL SELECT 'provider_locations', COUNT(*) FROM provider_locations;",
        ])

        return "\n".join(lines)

    def export_requirements_stories(self) -> str:
        """
        Export requirements and user_stories tables.

        TRANSFORMATIONS:
            - Convert context_json TEXT to JSONB
            - Convert related_stories TEXT to JSONB array
            - Convert flags TEXT to JSONB array
            - Validate status values against CHECK constraints
        """
        lines = [
            "-- ==========================================================================",
            "-- REQUIREMENTS AND USER STORIES DATA",
            f"-- Exported: {datetime.now().isoformat()}",
            "-- ==========================================================================",
            "",
            "ALTER TABLE requirements DISABLE TRIGGER ALL;",
            "ALTER TABLE user_stories DISABLE TRIGGER ALL;",
            "",
        ]

        # Valid status values for user_stories
        valid_statuses = {
            "Draft", "Internal Review", "Pending Client Review",
            "Approved", "Needs Discussion", "Out of Scope"
        }

        # --- REQUIREMENTS ---
        if self.table_exists("requirements"):
            count = self.get_table_count("requirements")
            print(f"  Exporting requirements: {count} rows")

            lines.append("-- REQUIREMENTS")
            cursor = self.conn.execute("SELECT * FROM requirements")

            for row in cursor:
                row_dict = dict(row)

                # Parse context_json
                context_json = parse_json_or_default(row_dict.get("context_json"), {})

                values = {
                    "requirement_id": escape_sql_string(row_dict.get("requirement_id")),
                    "program_id": escape_sql_string(row_dict.get("program_id")),
                    "source_file": escape_sql_string(row_dict.get("source_file")),
                    "source_row": row_dict.get("source_row") or "NULL",
                    "raw_text": escape_sql_string(row_dict.get("raw_text")),
                    "title": escape_sql_string(row_dict.get("title")),
                    "description": escape_sql_string(row_dict.get("description")),
                    "priority": escape_sql_string(row_dict.get("priority")),
                    "source_status": escape_sql_string(row_dict.get("source_status")),
                    "requirement_type": escape_sql_string(row_dict.get("requirement_type")),
                    "context_json": escape_sql_string(context_json),
                    "import_batch": escape_sql_string(row_dict.get("import_batch")),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                }

                lines.append(f"""INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    {values['requirement_id']}, {values['program_id']}, {values['source_file']}, {values['source_row']},
    {values['raw_text']}, {values['title']}, {values['description']}, {values['priority']},
    {values['source_status']}, {values['requirement_type']}, {values['context_json']},
    {values['import_batch']}, COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;
""")
            lines.append("")

        # --- USER STORIES ---
        if self.table_exists("user_stories"):
            count = self.get_table_count("user_stories")
            print(f"  Exporting user_stories: {count} rows")

            lines.append("-- USER STORIES")
            cursor = self.conn.execute("SELECT * FROM user_stories")

            for row in cursor:
                row_dict = dict(row)

                # Convert related_stories and flags to JSONB arrays
                related_stories = parse_json_or_default(row_dict.get("related_stories"), [])
                flags = parse_json_or_default(row_dict.get("flags"), [])

                # Validate status
                status = row_dict.get("status") or "Draft"
                if status not in valid_statuses:
                    status = "Draft"

                # Convert is_technical
                is_technical = convert_sqlite_bool(row_dict.get("is_technical", True))

                values = {
                    "story_id": escape_sql_string(row_dict.get("story_id")),
                    "requirement_id": escape_sql_string(row_dict.get("requirement_id")),
                    "program_id": escape_sql_string(row_dict.get("program_id")),
                    "parent_story_id": escape_sql_string(row_dict.get("parent_story_id")),
                    "title": escape_sql_string(row_dict.get("title")),
                    "user_story": escape_sql_string(row_dict.get("user_story")),
                    "role": escape_sql_string(row_dict.get("role")),
                    "capability": escape_sql_string(row_dict.get("capability")),
                    "benefit": escape_sql_string(row_dict.get("benefit")),
                    "acceptance_criteria": escape_sql_string(row_dict.get("acceptance_criteria")),
                    "success_metrics": escape_sql_string(row_dict.get("success_metrics")),
                    "priority": escape_sql_string(row_dict.get("priority")),
                    "category": escape_sql_string(row_dict.get("category")),
                    "category_full": escape_sql_string(row_dict.get("category_full")),
                    "is_technical": "TRUE" if is_technical else "FALSE",
                    "status": escape_sql_string(status),
                    "internal_notes": escape_sql_string(row_dict.get("internal_notes")),
                    "meeting_context": escape_sql_string(row_dict.get("meeting_context")),
                    "client_feedback": escape_sql_string(row_dict.get("client_feedback")),
                    "related_stories": escape_sql_string(related_stories),
                    "flags": escape_sql_string(flags),
                    "roadmap_target": escape_sql_string(row_dict.get("roadmap_target")),
                    "version": row_dict.get("version") or 1,
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                    "approved_at": escape_sql_string(row_dict.get("approved_date")),
                    "approved_by": escape_sql_string(row_dict.get("approved_by")),
                    "draft_date": escape_sql_string(row_dict.get("draft_date")),
                    "internal_review_date": escape_sql_string(row_dict.get("internal_review_date")),
                    "client_review_date": escape_sql_string(row_dict.get("client_review_date")),
                    "needs_discussion_date": escape_sql_string(row_dict.get("needs_discussion_date")),
                }

                lines.append(f"""INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    {values['story_id']}, {values['requirement_id']}, {values['program_id']}, {values['parent_story_id']},
    {values['title']}, {values['user_story']}, {values['role']}, {values['capability']}, {values['benefit']},
    {values['acceptance_criteria']}, {values['success_metrics']}, {values['priority']}, {values['category']},
    {values['category_full']}, {values['is_technical']}, {values['status']}, {values['internal_notes']},
    {values['meeting_context']}, {values['client_feedback']}, {values['related_stories']}, {values['flags']},
    {values['roadmap_target']}, {values['version']}, COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()),
    COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW()), {values['approved_at']}::TIMESTAMPTZ, {values['approved_by']},
    {values['draft_date']}::TIMESTAMPTZ, {values['internal_review_date']}::TIMESTAMPTZ,
    {values['client_review_date']}::TIMESTAMPTZ, {values['needs_discussion_date']}::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;
""")
            lines.append("")

        lines.extend([
            "ALTER TABLE requirements ENABLE TRIGGER ALL;",
            "ALTER TABLE user_stories ENABLE TRIGGER ALL;",
            "",
            "SELECT 'requirements' AS table_name, COUNT(*) AS row_count FROM requirements",
            "UNION ALL SELECT 'user_stories', COUNT(*) FROM user_stories;",
        ])

        return "\n".join(lines)

    def export_uat_tests(self) -> str:
        """
        Export UAT cycles, test cases, and assignments.

        TRANSFORMATIONS:
            - Convert patient_conditions TEXT to JSONB
            - Validate test_status and cycle status against CHECK constraints
            - Convert INTEGER booleans to BOOLEAN
        """
        lines = [
            "-- ==========================================================================",
            "-- UAT CYCLES AND TEST CASES DATA",
            f"-- Exported: {datetime.now().isoformat()}",
            "-- ==========================================================================",
            "",
            "ALTER TABLE uat_cycles DISABLE TRIGGER ALL;",
            "ALTER TABLE uat_test_cases DISABLE TRIGGER ALL;",
            "",
        ]

        valid_cycle_statuses = {
            "planning", "validation", "kickoff", "testing",
            "review", "retesting", "decision", "complete", "cancelled"
        }

        valid_test_statuses = {"Not Run", "Pass", "Fail", "Blocked", "Skipped"}

        # --- UAT CYCLES ---
        if self.table_exists("uat_cycles"):
            count = self.get_table_count("uat_cycles")
            print(f"  Exporting uat_cycles: {count} rows")

            lines.append("-- UAT CYCLES")
            cursor = self.conn.execute("SELECT * FROM uat_cycles")

            for row in cursor:
                row_dict = dict(row)

                status = row_dict.get("status") or "planning"
                if status not in valid_cycle_statuses:
                    status = "planning"

                pre_uat_gate_passed = convert_sqlite_bool(row_dict.get("pre_uat_gate_passed", 0))

                values = {
                    "cycle_id": escape_sql_string(row_dict.get("cycle_id")),
                    "program_id": escape_sql_string(row_dict.get("program_id")),
                    "name": escape_sql_string(row_dict.get("name")),
                    "description": escape_sql_string(row_dict.get("description")),
                    "uat_type": escape_sql_string(row_dict.get("uat_type")),
                    "target_launch_date": escape_sql_string(row_dict.get("target_launch_date")),
                    "status": escape_sql_string(status),
                    "clinical_pm": escape_sql_string(row_dict.get("clinical_pm")),
                    "clinical_pm_email": escape_sql_string(row_dict.get("clinical_pm_email")),
                    "pre_uat_gate_passed": "TRUE" if pre_uat_gate_passed else "FALSE",
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                    "created_by": escape_sql_string(row_dict.get("created_by") or "system"),
                }

                lines.append(f"""INSERT INTO uat_cycles (
    cycle_id, program_id, name, description, uat_type, target_launch_date, status,
    clinical_pm, clinical_pm_email, pre_uat_gate_passed, created_at, updated_at, created_by
) VALUES (
    {values['cycle_id']}, {values['program_id']}, {values['name']}, {values['description']},
    {values['uat_type']}, {values['target_launch_date']}::DATE, {values['status']}, {values['clinical_pm']},
    {values['clinical_pm_email']}, {values['pre_uat_gate_passed']},
    COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW()), {values['created_by']}
) ON CONFLICT (cycle_id) DO NOTHING;
""")
            lines.append("")

        # --- UAT TEST CASES ---
        if self.table_exists("uat_test_cases"):
            count = self.get_table_count("uat_test_cases")
            print(f"  Exporting uat_test_cases: {count} rows")

            lines.append("-- UAT TEST CASES")
            cursor = self.conn.execute("SELECT * FROM uat_test_cases")

            for row in cursor:
                row_dict = dict(row)

                test_status = row_dict.get("test_status") or "Not Run"
                if test_status not in valid_test_statuses:
                    test_status = "Not Run"

                patient_conditions = parse_json_or_default(row_dict.get("patient_conditions"), None)
                is_compliance_test = convert_sqlite_bool(row_dict.get("is_compliance_test", 0))

                values = {
                    "test_id": escape_sql_string(row_dict.get("test_id")),
                    "story_id": escape_sql_string(row_dict.get("story_id")),
                    "program_id": escape_sql_string(row_dict.get("program_id")),
                    "uat_cycle_id": escape_sql_string(row_dict.get("uat_cycle_id")),
                    "title": escape_sql_string(row_dict.get("title")),
                    "category": escape_sql_string(row_dict.get("category")),
                    "test_type": escape_sql_string(row_dict.get("test_type")),
                    "prerequisites": escape_sql_string(row_dict.get("prerequisites")),
                    "test_steps": escape_sql_string(row_dict.get("test_steps")),
                    "expected_results": escape_sql_string(row_dict.get("expected_results")),
                    "priority": escape_sql_string(row_dict.get("priority")),
                    "estimated_time": escape_sql_string(row_dict.get("estimated_time")),
                    "test_status": escape_sql_string(test_status),
                    "tested_by": escape_sql_string(row_dict.get("tested_by")),
                    "tested_date": escape_sql_string(row_dict.get("tested_date")),
                    "execution_notes": escape_sql_string(row_dict.get("execution_notes")),
                    "assigned_to": escape_sql_string(row_dict.get("assigned_to")),
                    "workflow_section": escape_sql_string(row_dict.get("workflow_section")),
                    "workflow_order": row_dict.get("workflow_order") or 0,
                    "patient_conditions": escape_sql_string(patient_conditions) if patient_conditions else "NULL",
                    "is_compliance_test": "TRUE" if is_compliance_test else "FALSE",
                    "notes": escape_sql_string(row_dict.get("notes")),
                    "created_at": escape_sql_string(row_dict.get("created_date")),
                    "updated_at": escape_sql_string(row_dict.get("updated_date")),
                }

                lines.append(f"""INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    {values['test_id']}, {values['story_id']}, {values['program_id']}, {values['uat_cycle_id']},
    {values['title']}, {values['category']}, {values['test_type']}, {values['prerequisites']},
    {values['test_steps']}, {values['expected_results']}, {values['priority']}, {values['estimated_time']},
    {values['test_status']}, {values['tested_by']}, {values['tested_date']}::TIMESTAMPTZ, {values['execution_notes']},
    {values['assigned_to']}, {values['workflow_section']}, {values['workflow_order']}, {values['patient_conditions']},
    {values['is_compliance_test']}, {values['notes']},
    COALESCE({values['created_at']}::TIMESTAMPTZ, NOW()), COALESCE({values['updated_at']}::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;
""")
            lines.append("")

        lines.extend([
            "ALTER TABLE uat_cycles ENABLE TRIGGER ALL;",
            "ALTER TABLE uat_test_cases ENABLE TRIGGER ALL;",
            "",
            "SELECT 'uat_cycles' AS table_name, COUNT(*) AS row_count FROM uat_cycles",
            "UNION ALL SELECT 'uat_test_cases', COUNT(*) FROM uat_test_cases;",
        ])

        return "\n".join(lines)

    def export_all(self):
        """
        Export all tables to separate SQL files.

        PURPOSE: Main entry point for the export process.
        """
        print(f"\n{'='*60}")
        print("SQLite to Supabase Data Export")
        print(f"{'='*60}")
        print(f"Database: {self.db_path}")
        print(f"Output: {self.output_dir}")
        print(f"{'='*60}\n")

        self.connect()

        try:
            # Export each group of tables
            print("Exporting clients and programs...")
            self.write_sql_file("003a_clients_programs.sql", self.export_clients_programs())

            print("\nExporting clinics and locations...")
            self.write_sql_file("003b_clinics_locations.sql", self.export_clinics_locations())

            print("\nExporting providers...")
            self.write_sql_file("003c_providers.sql", self.export_providers())

            print("\nExporting requirements and user stories...")
            self.write_sql_file("003d_requirements_stories.sql", self.export_requirements_stories())

            print("\nExporting UAT cycles and test cases...")
            self.write_sql_file("003e_uat_tests.sql", self.export_uat_tests())

            print(f"\n{'='*60}")
            print("Export complete!")
            print(f"{'='*60}")
            print(f"\nFiles written to: {self.output_dir}")
            print("\nTo import into Supabase:")
            print("  1. Open Supabase SQL Editor")
            print("  2. Run each file in order (003a, 003b, 003c, etc.)")
            print("  3. Verify row counts match expected values")

        finally:
            self.close()


# =============================================================================
# MAIN ENTRY POINT
# =============================================================================

def main():
    """
    Main entry point for the export script.

    USAGE:
        python3 export_sqlite_data.py
        python3 export_sqlite_data.py --db /path/to/database.db
        python3 export_sqlite_data.py --output-dir ./exports
    """
    parser = argparse.ArgumentParser(
        description="Export SQLite data to PostgreSQL-compatible SQL for Supabase"
    )
    parser.add_argument(
        "--db",
        type=Path,
        default=DEFAULT_DB_PATH,
        help=f"Path to SQLite database (default: {DEFAULT_DB_PATH})"
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help=f"Output directory for SQL files (default: {DEFAULT_OUTPUT_DIR})"
    )

    args = parser.parse_args()

    # Verify database exists
    if not args.db.exists():
        print(f"Error: Database not found: {args.db}")
        print("\nTry specifying the database path:")
        print(f"  python3 {__file__} --db /path/to/your/database.db")
        return 1

    # Run the export
    exporter = SQLiteExporter(args.db, args.output_dir)
    exporter.export_all()

    return 0


if __name__ == "__main__":
    exit(main())
