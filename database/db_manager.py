# database/db_manager.py
# ============================================================================
# CLIENT PRODUCT DATABASE MANAGER
# ============================================================================
# Purpose: Central database manager for the Client Product Database.
#          Handles all CRUD operations with full audit logging.
#
# This database stores:
#   - Client organizations and programs
#   - Requirements parsed from source files
#   - User stories (draft through approval)
#   - UAT test cases and execution results
#   - Compliance gaps and remediation tracking
#   - Full audit history for regulatory compliance
#
# AVIATION ANALOGY:
#   Think of this as your master flight operations database:
#   - Clients = Airlines
#   - Programs = Routes/Missions
#   - Requirements = Mission objectives
#   - User Stories = Flight plans
#   - Test Cases = Checklists
#   - Audit History = Flight recorder (black box)
#
# ============================================================================

import os
import sqlite3
import json
import uuid
from datetime import datetime
from typing import Optional, Dict, List, Any, Tuple


class ClientProductDatabase:
    """
    PURPOSE:
        Central database manager for the Client Product Database.

    KEY FEATURES:
        - Multi-client, multi-program organization
        - Full CRUD operations for all entities
        - Automatic audit logging for regulatory compliance
        - Version tracking for user stories
        - Compliance gap tracking

    USAGE:
        db = ClientProductDatabase()
        db.create_client("Discover Health", "Healthcare analytics client")
        db.create_program(client_id, "Propel", "PROP", "Patient recruitment analytics")

    R EQUIVALENT:
        # In R, you'd use DBI package:
        # con <- dbConnect(RSQLite::SQLite(), "database.db")
        # dbExecute(con, "INSERT INTO clients ...")
    """

    # Default database path
    DEFAULT_DB_PATH = "data/client_product_database.db"

    def __init__(self, db_path: Optional[str] = None):
        """
        PURPOSE:
            Initialize database connection and ensure schema exists.

        PARAMETERS:
            db_path (str, optional): Path to database file.
                                    Default: data/client_product_database.db

        WHY THIS APPROACH:
            Lazy initialization - database is only created when first accessed.
            Schema is auto-created if database is new.
        """
        self.db_path = db_path or self.DEFAULT_DB_PATH
        self._connection = None
        self._session_id = str(uuid.uuid4())[:8]  # For grouping audit entries

        # Ensure data directory exists
        os.makedirs(os.path.dirname(self.db_path), exist_ok=True)

        # Initialize schema on first use
        self._ensure_schema()

    def _ensure_schema(self):
        """Create database schema if it doesn't exist."""
        schema_path = os.path.join(os.path.dirname(__file__), 'schema.sql')

        if os.path.exists(schema_path):
            with open(schema_path, 'r') as f:
                schema_sql = f.read()

            conn = self.get_connection()
            conn.executescript(schema_sql)
            conn.commit()

    def get_connection(self) -> sqlite3.Connection:
        """
        PURPOSE:
            Get database connection (creates if needed).

        RETURNS:
            sqlite3.Connection: Database connection object

        WHY THIS APPROACH:
            Single connection per instance for consistency.
            Row factory enables dict-like access to results.
        """
        if self._connection is None:
            self._connection = sqlite3.connect(self.db_path)
            self._connection.row_factory = sqlite3.Row
            # Enable foreign keys
            self._connection.execute("PRAGMA foreign_keys = ON")

        return self._connection

    def close(self):
        """Close database connection."""
        if self._connection:
            self._connection.close()
            self._connection = None

    def __enter__(self):
        """Context manager entry."""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit - close connection."""
        self.close()

    # ========================================================================
    # AUDIT LOGGING
    # ========================================================================

    def log_audit(
        self,
        record_type: str,
        record_id: str,
        action: str,
        field: Optional[str] = None,
        old_val: Optional[str] = None,
        new_val: Optional[str] = None,
        changed_by: str = 'system',
        reason: Optional[str] = None
    ):
        """
        PURPOSE:
            Log a change to the audit history.

        PARAMETERS:
            record_type: client, program, requirement, user_story, etc.
            record_id: ID of the record changed
            action: Created, Updated, Deleted, Status Changed, etc.
            field: Which field was changed (for updates)
            old_val: Previous value
            new_val: New value
            changed_by: Who made the change
            reason: Why the change was made (for compliance)

        WHY THIS APPROACH:
            Comprehensive audit trail required for FDA 21 CFR Part 11
            and other regulatory frameworks.
        """
        conn = self.get_connection()
        conn.execute("""
            INSERT INTO audit_history
            (record_type, record_id, action, field_changed, old_value,
             new_value, changed_by, change_reason, session_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (record_type, record_id, action, field, old_val, new_val,
              changed_by, reason, self._session_id))
        conn.commit()

    def get_audit_trail(
        self,
        record_type: str,
        record_id: str
    ) -> List[Dict]:
        """Get full change history for a record."""
        conn = self.get_connection()
        cursor = conn.execute("""
            SELECT * FROM audit_history
            WHERE record_type = ? AND record_id = ?
            ORDER BY changed_date DESC
        """, (record_type, record_id))

        return [dict(row) for row in cursor.fetchall()]

    def get_audit_report(
        self,
        start_date: str,
        end_date: str,
        record_type: Optional[str] = None
    ) -> List[Dict]:
        """
        PURPOSE:
            Generate audit report for compliance reviews.

        PARAMETERS:
            start_date: Start of date range (YYYY-MM-DD)
            end_date: End of date range (YYYY-MM-DD)
            record_type: Optional filter by record type
        """
        conn = self.get_connection()

        if record_type:
            cursor = conn.execute("""
                SELECT * FROM audit_history
                WHERE changed_date BETWEEN ? AND ?
                AND record_type = ?
                ORDER BY changed_date DESC
            """, (start_date, end_date, record_type))
        else:
            cursor = conn.execute("""
                SELECT * FROM audit_history
                WHERE changed_date BETWEEN ? AND ?
                ORDER BY changed_date DESC
            """, (start_date, end_date))

        return [dict(row) for row in cursor.fetchall()]

    # ========================================================================
    # CLIENT OPERATIONS
    # ========================================================================

    def create_client(
        self,
        name: str,
        description: Optional[str] = None,
        primary_contact: Optional[str] = None,
        contact_email: Optional[str] = None
    ) -> str:
        """
        PURPOSE:
            Create a new client organization.

        PARAMETERS:
            name: Client name (must be unique)
            description: Client description
            primary_contact: Main contact person
            contact_email: Contact email

        RETURNS:
            str: Generated client_id

        RAISES:
            sqlite3.IntegrityError: If client name already exists
        """
        client_id = f"CLI-{str(uuid.uuid4())[:8].upper()}"

        conn = self.get_connection()
        conn.execute("""
            INSERT INTO clients
            (client_id, name, description, primary_contact, contact_email)
            VALUES (?, ?, ?, ?, ?)
        """, (client_id, name, description, primary_contact, contact_email))
        conn.commit()

        # Audit log
        self.log_audit('client', client_id, 'Created',
                      new_val=f"Client: {name}")

        return client_id

    def get_client(self, client_id: str) -> Optional[Dict]:
        """Get client by ID."""
        conn = self.get_connection()
        cursor = conn.execute(
            "SELECT * FROM clients WHERE client_id = ?",
            (client_id,)
        )
        row = cursor.fetchone()
        return dict(row) if row else None

    def get_client_by_name(self, name: str) -> Optional[Dict]:
        """Get client by name."""
        conn = self.get_connection()
        cursor = conn.execute(
            "SELECT * FROM clients WHERE name = ?",
            (name,)
        )
        row = cursor.fetchone()
        return dict(row) if row else None

    def list_clients(self, status_filter: str = 'Active') -> List[Dict]:
        """List all clients, optionally filtered by status."""
        conn = self.get_connection()

        if status_filter:
            cursor = conn.execute(
                "SELECT * FROM clients WHERE status = ? ORDER BY name",
                (status_filter,)
            )
        else:
            cursor = conn.execute("SELECT * FROM clients ORDER BY name")

        return [dict(row) for row in cursor.fetchall()]

    def update_client(
        self,
        client_id: str,
        updates: Dict,
        changed_by: str = 'system'
    ):
        """Update client fields."""
        conn = self.get_connection()

        # Get current values for audit
        current = self.get_client(client_id)
        if not current:
            raise ValueError(f"Client not found: {client_id}")

        # Build update query
        set_parts = []
        values = []
        for field, new_val in updates.items():
            if field not in ['client_id', 'created_date']:
                set_parts.append(f"{field} = ?")
                values.append(new_val)

                # Log each field change
                old_val = current.get(field)
                if old_val != new_val:
                    self.log_audit('client', client_id, 'Updated',
                                  field=field, old_val=str(old_val),
                                  new_val=str(new_val), changed_by=changed_by)

        if set_parts:
            set_parts.append("updated_date = CURRENT_TIMESTAMP")
            values.append(client_id)

            query = f"UPDATE clients SET {', '.join(set_parts)} WHERE client_id = ?"
            conn.execute(query, values)
            conn.commit()

    # ========================================================================
    # PROGRAM OPERATIONS
    # ========================================================================

    def create_program(
        self,
        client_id: str,
        name: str,
        prefix: str,
        description: Optional[str] = None,
        program_type: Optional[str] = None,
        source_file: Optional[str] = None
    ) -> str:
        """
        PURPOSE:
            Create a new program under a client.

        PARAMETERS:
            client_id: Parent client ID
            name: Program name
            prefix: Unique prefix (PROP, GRX, etc.)
            description: Program description
            program_type: Type (Analytics, Consent, etc.)
            source_file: Original requirements file

        RETURNS:
            str: Generated program_id

        RAISES:
            sqlite3.IntegrityError: If prefix already exists
        """
        program_id = f"PRG-{prefix}-{str(uuid.uuid4())[:8].upper()}"

        conn = self.get_connection()
        conn.execute("""
            INSERT INTO programs
            (program_id, client_id, name, prefix, description,
             program_type, source_file)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (program_id, client_id, name, prefix, description,
              program_type, source_file))
        conn.commit()

        # Audit log
        self.log_audit('program', program_id, 'Created',
                      new_val=f"Program: {name} ({prefix})")

        return program_id

    def get_program(self, program_id: str) -> Optional[Dict]:
        """Get program by ID."""
        conn = self.get_connection()
        cursor = conn.execute(
            "SELECT * FROM programs WHERE program_id = ?",
            (program_id,)
        )
        row = cursor.fetchone()
        return dict(row) if row else None

    def get_program_by_prefix(self, prefix: str) -> Optional[Dict]:
        """
        PURPOSE:
            Find program by its unique prefix.

        PARAMETERS:
            prefix: Program prefix (PROP, GRX, etc.)

        RETURNS:
            dict or None: Program data if found
        """
        conn = self.get_connection()
        cursor = conn.execute(
            "SELECT * FROM programs WHERE prefix = ?",
            (prefix.upper(),)
        )
        row = cursor.fetchone()
        return dict(row) if row else None

    def list_programs(
        self,
        client_id: Optional[str] = None,
        status_filter: str = 'Active'
    ) -> List[Dict]:
        """List programs, optionally filtered by client and/or status."""
        conn = self.get_connection()

        query = "SELECT * FROM programs WHERE 1=1"
        params = []

        if client_id:
            query += " AND client_id = ?"
            params.append(client_id)

        if status_filter:
            query += " AND status = ?"
            params.append(status_filter)

        query += " ORDER BY name"

        cursor = conn.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]

    def update_program(
        self,
        program_id: str,
        updates: Dict,
        changed_by: str = 'system'
    ):
        """Update program fields."""
        conn = self.get_connection()

        current = self.get_program(program_id)
        if not current:
            raise ValueError(f"Program not found: {program_id}")

        set_parts = []
        values = []
        for field, new_val in updates.items():
            if field not in ['program_id', 'created_date', 'prefix']:
                set_parts.append(f"{field} = ?")
                values.append(new_val)

                old_val = current.get(field)
                if old_val != new_val:
                    self.log_audit('program', program_id, 'Updated',
                                  field=field, old_val=str(old_val),
                                  new_val=str(new_val), changed_by=changed_by)

        if set_parts:
            set_parts.append("updated_date = CURRENT_TIMESTAMP")
            values.append(program_id)

            query = f"UPDATE programs SET {', '.join(set_parts)} WHERE program_id = ?"
            conn.execute(query, values)
            conn.commit()

    # ========================================================================
    # REQUIREMENT OPERATIONS
    # ========================================================================

    def save_requirements(
        self,
        program_id: str,
        requirements: List[Dict],
        source_file: Optional[str] = None,
        batch_id: Optional[str] = None
    ) -> Tuple[int, int]:
        """
        PURPOSE:
            Bulk save requirements from parser output.

        PARAMETERS:
            program_id: Program to save requirements under
            requirements: List of requirement dicts from parser
            source_file: Original file name
            batch_id: Optional batch ID for grouping

        RETURNS:
            Tuple[int, int]: (inserted_count, updated_count)
        """
        conn = self.get_connection()
        batch_id = batch_id or str(uuid.uuid4())[:8]
        inserted = 0
        updated = 0

        for req in requirements:
            # Generate requirement ID if not present
            req_id = req.get('requirement_id')
            if not req_id:
                row_num = req.get('row_number', 0)
                req_id = f"REQ-{program_id[-8:]}-{row_num:03d}"

            # Check if exists
            cursor = conn.execute(
                "SELECT requirement_id FROM requirements WHERE requirement_id = ?",
                (req_id,)
            )
            exists = cursor.fetchone() is not None

            # Prepare context JSON
            context_json = json.dumps(req.get('context_columns', {}))

            if exists:
                # Update existing
                conn.execute("""
                    UPDATE requirements SET
                        raw_text = ?,
                        title = ?,
                        description = ?,
                        priority = ?,
                        source_status = ?,
                        requirement_type = ?,
                        context_json = ?,
                        updated_date = CURRENT_TIMESTAMP
                    WHERE requirement_id = ?
                """, (
                    req.get('raw_text', req.get('description', '')),
                    req.get('title', ''),
                    req.get('description', ''),
                    req.get('priority', 'Medium'),
                    req.get('status', ''),
                    req.get('type', req.get('requirement_type', '')),
                    context_json,
                    req_id
                ))
                updated += 1
                self.log_audit('requirement', req_id, 'Updated',
                              new_val=f"Re-imported from {source_file}")
            else:
                # Insert new
                conn.execute("""
                    INSERT INTO requirements
                    (requirement_id, program_id, source_file, source_row,
                     raw_text, title, description, priority, source_status,
                     requirement_type, context_json, import_batch)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    req_id,
                    program_id,
                    source_file,
                    req.get('row_number', 0),
                    req.get('raw_text', req.get('description', '')),
                    req.get('title', ''),
                    req.get('description', ''),
                    req.get('priority', 'Medium'),
                    req.get('status', ''),
                    req.get('type', req.get('requirement_type', '')),
                    context_json,
                    batch_id
                ))
                inserted += 1
                self.log_audit('requirement', req_id, 'Created',
                              new_val=f"Imported from {source_file}")

        conn.commit()

        # Log import batch
        conn.execute("""
            INSERT INTO import_batches
            (batch_id, program_id, source_file, import_type,
             records_imported, records_updated)
            VALUES (?, ?, ?, 'requirements', ?, ?)
        """, (batch_id, program_id, source_file, inserted, updated))
        conn.commit()

        return inserted, updated

    def get_requirements(
        self,
        program_id: str,
        requirement_type: Optional[str] = None
    ) -> List[Dict]:
        """Get requirements for a program."""
        conn = self.get_connection()

        query = "SELECT * FROM requirements WHERE program_id = ?"
        params = [program_id]

        if requirement_type:
            query += " AND requirement_type = ?"
            params.append(requirement_type)

        query += " ORDER BY source_row"

        cursor = conn.execute(query, params)
        results = []
        for row in cursor.fetchall():
            req = dict(row)
            # Parse context JSON
            if req.get('context_json'):
                req['context_columns'] = json.loads(req['context_json'])
            results.append(req)

        return results

    # ========================================================================
    # USER STORY OPERATIONS
    # ========================================================================

    def save_user_stories(
        self,
        program_id: str,
        stories: List[Dict],
        batch_id: Optional[str] = None
    ) -> Tuple[int, int]:
        """
        PURPOSE:
            Insert or update user stories.

        PARAMETERS:
            program_id: Program ID
            stories: List of story dicts from generator
            batch_id: Optional batch ID

        RETURNS:
            Tuple[int, int]: (inserted_count, updated_count)
        """
        conn = self.get_connection()
        batch_id = batch_id or str(uuid.uuid4())[:8]
        inserted = 0
        updated = 0

        for story in stories:
            story_id = story.get('story_id', story.get('generated_id'))

            # Check if exists
            cursor = conn.execute(
                "SELECT story_id, version FROM user_stories WHERE story_id = ?",
                (story_id,)
            )
            existing = cursor.fetchone()

            # Prepare acceptance criteria (join list to text)
            ac = story.get('acceptance_criteria', [])
            ac_text = '\n'.join(ac) if isinstance(ac, list) else str(ac)

            # Prepare flags (join list to text)
            flags = story.get('flags', [])
            flags_text = ','.join(flags) if isinstance(flags, list) else str(flags)

            # Get source requirement ID
            source_req = story.get('source_requirement', {})
            req_id = None
            if isinstance(source_req, dict):
                req_id = source_req.get('requirement_id')

            if existing:
                # Update existing - increment version
                new_version = existing['version'] + 1

                conn.execute("""
                    UPDATE user_stories SET
                        title = ?,
                        user_story = ?,
                        role = ?,
                        capability = ?,
                        benefit = ?,
                        acceptance_criteria = ?,
                        success_metrics = ?,
                        priority = ?,
                        category = ?,
                        category_full = ?,
                        is_technical = ?,
                        flags = ?,
                        version = ?,
                        updated_date = CURRENT_TIMESTAMP
                    WHERE story_id = ?
                """, (
                    story.get('title', ''),
                    story.get('user_story', ''),
                    story.get('role', ''),
                    story.get('capability', ''),
                    story.get('benefit', ''),
                    ac_text,
                    story.get('success_metrics', ''),
                    story.get('priority', 'Medium'),
                    story.get('category_abbrev', story.get('category', '')),
                    story.get('category_full', ''),
                    1 if story.get('is_technical', True) else 0,
                    flags_text,
                    new_version,
                    story_id
                ))
                updated += 1
                self.log_audit('user_story', story_id, 'Updated',
                              field='version', old_val=str(existing['version']),
                              new_val=str(new_version))
            else:
                # Insert new
                conn.execute("""
                    INSERT INTO user_stories
                    (story_id, requirement_id, program_id, title, user_story,
                     role, capability, benefit, acceptance_criteria,
                     success_metrics, priority, category, category_full,
                     status, is_technical, flags)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Draft', ?, ?)
                """, (
                    story_id,
                    req_id,
                    program_id,
                    story.get('title', ''),
                    story.get('user_story', ''),
                    story.get('role', ''),
                    story.get('capability', ''),
                    story.get('benefit', ''),
                    ac_text,
                    story.get('success_metrics', ''),
                    story.get('priority', 'Medium'),
                    story.get('category_abbrev', story.get('category', '')),
                    story.get('category_full', ''),
                    1 if story.get('is_technical', True) else 0,
                    flags_text
                ))
                inserted += 1
                self.log_audit('user_story', story_id, 'Created',
                              new_val=f"Story: {story.get('title', '')[:50]}")

        conn.commit()
        return inserted, updated

    def update_story(
        self,
        story_id: str,
        updates: Dict,
        changed_by: str = 'system',
        change_reason: Optional[str] = None
    ):
        """
        PURPOSE:
            Update a user story with audit logging.

        PARAMETERS:
            story_id: Story to update
            updates: Dict of field:value updates
            changed_by: Who made the change
            change_reason: Why (for compliance)
        """
        conn = self.get_connection()

        # Get current values
        cursor = conn.execute(
            "SELECT * FROM user_stories WHERE story_id = ?",
            (story_id,)
        )
        current = cursor.fetchone()
        if not current:
            raise ValueError(f"Story not found: {story_id}")

        current = dict(current)

        # Increment version
        new_version = current['version'] + 1
        updates['version'] = new_version

        # Build update
        set_parts = []
        values = []
        for field, new_val in updates.items():
            if field not in ['story_id', 'created_date']:
                set_parts.append(f"{field} = ?")
                values.append(new_val)

                old_val = current.get(field)
                if str(old_val) != str(new_val):
                    self.log_audit('user_story', story_id, 'Updated',
                                  field=field, old_val=str(old_val),
                                  new_val=str(new_val), changed_by=changed_by,
                                  reason=change_reason)

        if set_parts:
            set_parts.append("updated_date = CURRENT_TIMESTAMP")
            values.append(story_id)

            query = f"UPDATE user_stories SET {', '.join(set_parts)} WHERE story_id = ?"
            conn.execute(query, values)
            conn.commit()

    def update_story_status(
        self,
        story_id: str,
        new_status: str,
        changed_by: str = 'system',
        change_reason: Optional[str] = None
    ):
        """
        PURPOSE:
            Update story workflow status with special handling for Approved.

        PARAMETERS:
            story_id: Story to update
            new_status: New status value
            changed_by: Who made the change
            change_reason: Why (for compliance)
        """
        conn = self.get_connection()

        # Get current status
        cursor = conn.execute(
            "SELECT status, version FROM user_stories WHERE story_id = ?",
            (story_id,)
        )
        current = cursor.fetchone()
        if not current:
            raise ValueError(f"Story not found: {story_id}")

        old_status = current['status']
        new_version = current['version'] + 1

        # Handle approval
        if new_status == 'Approved':
            conn.execute("""
                UPDATE user_stories SET
                    status = ?,
                    version = ?,
                    approved_date = CURRENT_TIMESTAMP,
                    approved_by = ?,
                    updated_date = CURRENT_TIMESTAMP
                WHERE story_id = ?
            """, (new_status, new_version, changed_by, story_id))
        else:
            conn.execute("""
                UPDATE user_stories SET
                    status = ?,
                    version = ?,
                    updated_date = CURRENT_TIMESTAMP
                WHERE story_id = ?
            """, (new_status, new_version, story_id))

        conn.commit()

        self.log_audit('user_story', story_id, 'Status Changed',
                      field='status', old_val=old_status, new_val=new_status,
                      changed_by=changed_by, reason=change_reason)

    def get_stories(
        self,
        program_id: str,
        status_filter: Optional[str] = None,
        category_filter: Optional[str] = None,
        include_non_technical: bool = True
    ) -> List[Dict]:
        """Get stories with optional filters."""
        conn = self.get_connection()

        query = "SELECT * FROM user_stories WHERE program_id = ?"
        params = [program_id]

        if status_filter:
            query += " AND status = ?"
            params.append(status_filter)

        if category_filter:
            query += " AND category = ?"
            params.append(category_filter)

        if not include_non_technical:
            query += " AND is_technical = 1"

        query += " ORDER BY story_id"

        cursor = conn.execute(query, params)
        results = []
        for row in cursor.fetchall():
            story = dict(row)
            # Convert acceptance criteria back to list
            if story.get('acceptance_criteria'):
                story['acceptance_criteria'] = story['acceptance_criteria'].split('\n')
            # Convert flags back to list
            if story.get('flags'):
                story['flags'] = story['flags'].split(',')
            else:
                story['flags'] = []
            results.append(story)

        return results

    def get_stories_for_review(self, program_id: str) -> List[Dict]:
        """Get stories pending internal or client review."""
        conn = self.get_connection()
        cursor = conn.execute("""
            SELECT * FROM user_stories
            WHERE program_id = ?
            AND status IN ('Draft', 'Internal Review', 'Pending Client Review', 'Needs Discussion')
            ORDER BY story_id
        """, (program_id,))

        return [dict(row) for row in cursor.fetchall()]

    def get_approved_stories(
        self,
        program_id: Optional[str] = None,
        category: Optional[str] = None
    ) -> List[Dict]:
        """
        PURPOSE:
            Get approved stories for UAT generation or reference.

        PARAMETERS:
            program_id: Filter by program (None = all programs)
            category: Filter by category
        """
        conn = self.get_connection()

        query = "SELECT * FROM user_stories WHERE status = 'Approved'"
        params = []

        if program_id:
            query += " AND program_id = ?"
            params.append(program_id)

        if category:
            query += " AND category = ?"
            params.append(category)

        query += " ORDER BY approved_date DESC"

        cursor = conn.execute(query, params)
        results = []
        for row in cursor.fetchall():
            story = dict(row)
            if story.get('acceptance_criteria'):
                story['acceptance_criteria'] = story['acceptance_criteria'].split('\n')
            if story.get('flags'):
                story['flags'] = story['flags'].split(',')
            else:
                story['flags'] = []
            results.append(story)

        return results

    # ========================================================================
    # UAT TEST CASE OPERATIONS
    # ========================================================================

    def save_test_cases(
        self,
        program_id: str,
        test_cases: List[Dict],
        batch_id: Optional[str] = None
    ) -> Tuple[int, int]:
        """
        PURPOSE:
            Bulk save UAT test cases.

        PARAMETERS:
            program_id: Program ID
            test_cases: List of test case dicts from generator
            batch_id: Optional batch ID

        RETURNS:
            Tuple[int, int]: (inserted_count, updated_count)
        """
        conn = self.get_connection()
        batch_id = batch_id or str(uuid.uuid4())[:8]
        inserted = 0
        updated = 0

        for test in test_cases:
            test_id = test.get('test_id')

            # Check if exists
            cursor = conn.execute(
                "SELECT test_id FROM uat_test_cases WHERE test_id = ?",
                (test_id,)
            )
            exists = cursor.fetchone() is not None

            # Prepare multi-line fields
            prereqs = test.get('prerequisites', [])
            prereqs_text = '\n'.join(prereqs) if isinstance(prereqs, list) else str(prereqs)

            steps = test.get('test_steps', [])
            steps_text = '\n'.join(steps) if isinstance(steps, list) else str(steps)

            results = test.get('expected_results', [])
            results_text = '\n'.join(results) if isinstance(results, list) else str(results)

            if exists:
                conn.execute("""
                    UPDATE uat_test_cases SET
                        title = ?,
                        category = ?,
                        test_type = ?,
                        prerequisites = ?,
                        test_steps = ?,
                        expected_results = ?,
                        priority = ?,
                        estimated_time = ?,
                        compliance_framework = ?,
                        notes = ?,
                        updated_date = CURRENT_TIMESTAMP
                    WHERE test_id = ?
                """, (
                    test.get('title', ''),
                    test.get('category', ''),
                    test.get('test_type', ''),
                    prereqs_text,
                    steps_text,
                    results_text,
                    test.get('moscow', test.get('priority', '')),
                    test.get('est_time', test.get('estimated_time', '')),
                    test.get('compliance_framework'),
                    test.get('notes', ''),
                    test_id
                ))
                updated += 1
            else:
                conn.execute("""
                    INSERT INTO uat_test_cases
                    (test_id, story_id, program_id, title, category, test_type,
                     prerequisites, test_steps, expected_results, priority,
                     estimated_time, compliance_framework, notes)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    test_id,
                    test.get('source_story_id'),
                    program_id,
                    test.get('title', ''),
                    test.get('category', ''),
                    test.get('test_type', ''),
                    prereqs_text,
                    steps_text,
                    results_text,
                    test.get('moscow', test.get('priority', '')),
                    test.get('est_time', test.get('estimated_time', '')),
                    test.get('compliance_framework'),
                    test.get('notes', '')
                ))
                inserted += 1
                self.log_audit('test_case', test_id, 'Created',
                              new_val=f"Test: {test.get('title', '')[:50]}")

        conn.commit()
        return inserted, updated

    def update_test_result(
        self,
        test_id: str,
        status: str,
        tested_by: str,
        notes: Optional[str] = None,
        defect_id: Optional[str] = None
    ):
        """
        PURPOSE:
            Record test execution result.

        PARAMETERS:
            test_id: Test case ID
            status: Pass, Fail, Blocked, Skipped
            tested_by: Who ran the test
            notes: Execution notes
            defect_id: Link to defect if failed
        """
        conn = self.get_connection()

        # Get current status
        cursor = conn.execute(
            "SELECT test_status FROM uat_test_cases WHERE test_id = ?",
            (test_id,)
        )
        current = cursor.fetchone()
        if not current:
            raise ValueError(f"Test case not found: {test_id}")

        old_status = current['test_status']

        conn.execute("""
            UPDATE uat_test_cases SET
                test_status = ?,
                tested_by = ?,
                tested_date = CURRENT_TIMESTAMP,
                execution_notes = ?,
                defect_id = ?,
                updated_date = CURRENT_TIMESTAMP
            WHERE test_id = ?
        """, (status, tested_by, notes, defect_id, test_id))
        conn.commit()

        self.log_audit('test_case', test_id, 'Test Executed',
                      field='test_status', old_val=old_status, new_val=status,
                      changed_by=tested_by)

    def get_test_cases(
        self,
        program_id: Optional[str] = None,
        story_id: Optional[str] = None,
        status_filter: Optional[str] = None,
        test_type: Optional[str] = None
    ) -> List[Dict]:
        """Get test cases with optional filters."""
        conn = self.get_connection()

        query = "SELECT * FROM uat_test_cases WHERE 1=1"
        params = []

        if program_id:
            query += " AND program_id = ?"
            params.append(program_id)

        if story_id:
            query += " AND story_id = ?"
            params.append(story_id)

        if status_filter:
            query += " AND test_status = ?"
            params.append(status_filter)

        if test_type:
            query += " AND test_type = ?"
            params.append(test_type)

        query += " ORDER BY test_id"

        cursor = conn.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]

    # ========================================================================
    # COMPLIANCE OPERATIONS
    # ========================================================================

    def save_compliance_gaps(
        self,
        program_id: str,
        gaps: List[Dict]
    ) -> int:
        """
        PURPOSE:
            Save identified compliance gaps.

        PARAMETERS:
            program_id: Program ID
            gaps: List of gap dicts from compliance validator

        RETURNS:
            int: Number of gaps inserted
        """
        conn = self.get_connection()
        inserted = 0

        for gap in gaps:
            conn.execute("""
                INSERT INTO compliance_gaps
                (requirement_id, story_id, program_id, framework, control_id,
                 category, gap_description, recommendation, severity)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                gap.get('requirement_id'),
                gap.get('story_id'),
                program_id,
                gap.get('framework', ''),
                gap.get('control_id', ''),
                gap.get('category', ''),
                gap.get('description', gap.get('gap_description', '')),
                gap.get('recommendation', ''),
                gap.get('severity', 'Medium')
            ))
            inserted += 1

        conn.commit()
        return inserted

    def update_gap_status(
        self,
        gap_id: int,
        new_status: str,
        mitigation_plan: Optional[str] = None,
        notes: Optional[str] = None,
        changed_by: str = 'system'
    ):
        """Update compliance gap status."""
        conn = self.get_connection()

        # Get current
        cursor = conn.execute(
            "SELECT status FROM compliance_gaps WHERE gap_id = ?",
            (gap_id,)
        )
        current = cursor.fetchone()
        if not current:
            raise ValueError(f"Gap not found: {gap_id}")

        old_status = current['status']

        # Handle closed status
        if new_status == 'Closed':
            conn.execute("""
                UPDATE compliance_gaps SET
                    status = ?,
                    mitigation_plan = COALESCE(?, mitigation_plan),
                    notes = COALESCE(?, notes),
                    closed_date = CURRENT_TIMESTAMP,
                    updated_date = CURRENT_TIMESTAMP
                WHERE gap_id = ?
            """, (new_status, mitigation_plan, notes, gap_id))
        else:
            conn.execute("""
                UPDATE compliance_gaps SET
                    status = ?,
                    mitigation_plan = COALESCE(?, mitigation_plan),
                    notes = COALESCE(?, notes),
                    updated_date = CURRENT_TIMESTAMP
                WHERE gap_id = ?
            """, (new_status, mitigation_plan, notes, gap_id))

        conn.commit()

        self.log_audit('compliance_gap', str(gap_id), 'Status Changed',
                      field='status', old_val=old_status, new_val=new_status,
                      changed_by=changed_by)

    def get_compliance_summary(self, program_id: str) -> Dict:
        """
        PURPOSE:
            Get summary of compliance gaps by framework and status.

        RETURNS:
            Dict with counts by framework, severity, and status
        """
        conn = self.get_connection()

        summary = {
            'by_framework': {},
            'by_severity': {},
            'by_status': {},
            'total': 0
        }

        # By framework
        cursor = conn.execute("""
            SELECT framework, COUNT(*) as count
            FROM compliance_gaps WHERE program_id = ?
            GROUP BY framework
        """, (program_id,))
        for row in cursor.fetchall():
            summary['by_framework'][row['framework']] = row['count']
            summary['total'] += row['count']

        # By severity
        cursor = conn.execute("""
            SELECT severity, COUNT(*) as count
            FROM compliance_gaps WHERE program_id = ?
            GROUP BY severity
        """, (program_id,))
        for row in cursor.fetchall():
            summary['by_severity'][row['severity']] = row['count']

        # By status
        cursor = conn.execute("""
            SELECT status, COUNT(*) as count
            FROM compliance_gaps WHERE program_id = ?
            GROUP BY status
        """, (program_id,))
        for row in cursor.fetchall():
            summary['by_status'][row['status']] = row['count']

        return summary

    # ========================================================================
    # TRACEABILITY OPERATIONS
    # ========================================================================

    def save_traceability(
        self,
        program_id: str,
        traceability_matrix: Dict
    ) -> int:
        """
        PURPOSE:
            Save traceability matrix to database.

        PARAMETERS:
            program_id: Program ID
            traceability_matrix: Matrix dict from TraceabilityGenerator

        RETURNS:
            int: Number of records inserted
        """
        conn = self.get_connection()

        # Clear existing traceability for this program
        conn.execute(
            "DELETE FROM traceability WHERE program_id = ?",
            (program_id,)
        )

        inserted = 0
        matrix = traceability_matrix.get('matrix', [])

        for entry in matrix:
            # Get test IDs
            test_ids = entry.get('test_case_ids', [])
            compliance = entry.get('compliance_coverage', [])

            conn.execute("""
                INSERT INTO traceability
                (program_id, requirement_id, story_id, coverage_status,
                 gap_notes, compliance_coverage)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                program_id,
                entry.get('requirement_id'),
                entry.get('user_story_id'),
                entry.get('coverage_status', 'None'),
                '\n'.join(entry.get('gaps', [])),
                ','.join(compliance)
            ))
            inserted += 1

        conn.commit()

        self.log_audit('traceability', program_id, 'Updated',
                      new_val=f"Saved {inserted} traceability records")

        return inserted

    def get_traceability_matrix(self, program_id: str) -> List[Dict]:
        """Get full traceability matrix for a program."""
        conn = self.get_connection()
        cursor = conn.execute("""
            SELECT
                t.*,
                r.title as req_title,
                r.description as req_description,
                s.title as story_title,
                s.status as story_status
            FROM traceability t
            LEFT JOIN requirements r ON t.requirement_id = r.requirement_id
            LEFT JOIN user_stories s ON t.story_id = s.story_id
            WHERE t.program_id = ?
            ORDER BY t.requirement_id
        """, (program_id,))

        return [dict(row) for row in cursor.fetchall()]

    def get_coverage_summary(self, program_id: str) -> Dict:
        """Get coverage summary for a program."""
        conn = self.get_connection()
        cursor = conn.execute("""
            SELECT
                coverage_status,
                COUNT(*) as count
            FROM traceability
            WHERE program_id = ?
            GROUP BY coverage_status
        """, (program_id,))

        summary = {'Full': 0, 'Partial': 0, 'None': 0, 'total': 0}
        for row in cursor.fetchall():
            summary[row['coverage_status']] = row['count']
            summary['total'] += row['count']

        # Calculate percentages
        if summary['total'] > 0:
            summary['full_pct'] = round(100 * summary['Full'] / summary['total'], 1)
            summary['partial_pct'] = round(100 * summary['Partial'] / summary['total'], 1)
            summary['none_pct'] = round(100 * summary['None'] / summary['total'], 1)
        else:
            summary['full_pct'] = summary['partial_pct'] = summary['none_pct'] = 0

        return summary

    # ========================================================================
    # REPORTING OPERATIONS
    # ========================================================================

    def get_program_summary(self, program_id: str) -> Dict:
        """
        PURPOSE:
            Get dashboard summary for a program.

        RETURNS:
            Dict with counts and metrics:
            - requirement_count
            - stories_by_status
            - tests_by_status
            - compliance_gaps_by_severity
            - coverage_percentage
        """
        conn = self.get_connection()
        summary = {}

        # Requirements count
        cursor = conn.execute(
            "SELECT COUNT(*) FROM requirements WHERE program_id = ?",
            (program_id,)
        )
        summary['requirement_count'] = cursor.fetchone()[0]

        # Stories by status
        cursor = conn.execute("""
            SELECT status, COUNT(*) as count
            FROM user_stories WHERE program_id = ?
            GROUP BY status
        """, (program_id,))
        summary['stories_by_status'] = {row['status']: row['count']
                                        for row in cursor.fetchall()}
        summary['story_count'] = sum(summary['stories_by_status'].values())

        # Tests by status
        cursor = conn.execute("""
            SELECT test_status, COUNT(*) as count
            FROM uat_test_cases WHERE program_id = ?
            GROUP BY test_status
        """, (program_id,))
        summary['tests_by_status'] = {row['test_status']: row['count']
                                      for row in cursor.fetchall()}
        summary['test_count'] = sum(summary['tests_by_status'].values())

        # Compliance gaps by severity
        cursor = conn.execute("""
            SELECT severity, COUNT(*) as count
            FROM compliance_gaps
            WHERE program_id = ? AND status != 'Closed'
            GROUP BY severity
        """, (program_id,))
        summary['open_gaps_by_severity'] = {row['severity']: row['count']
                                            for row in cursor.fetchall()}

        # Coverage
        summary['coverage'] = self.get_coverage_summary(program_id)

        return summary

    def get_client_summary(self, client_id: str) -> Dict:
        """Get summary across all programs for a client."""
        programs = self.list_programs(client_id=client_id, status_filter=None)

        summary = {
            'client_id': client_id,
            'program_count': len(programs),
            'programs': [],
            'totals': {
                'requirements': 0,
                'stories': 0,
                'tests': 0,
                'open_gaps': 0
            }
        }

        for prog in programs:
            prog_summary = self.get_program_summary(prog['program_id'])
            summary['programs'].append({
                'program_id': prog['program_id'],
                'name': prog['name'],
                'prefix': prog['prefix'],
                'status': prog['status'],
                **prog_summary
            })

            summary['totals']['requirements'] += prog_summary['requirement_count']
            summary['totals']['stories'] += prog_summary['story_count']
            summary['totals']['tests'] += prog_summary['test_count']
            summary['totals']['open_gaps'] += sum(
                prog_summary['open_gaps_by_severity'].values()
            )

        return summary

    # ========================================================================
    # REFERENCE LIBRARY OPERATIONS
    # ========================================================================

    def add_to_reference_library(
        self,
        story_id: str,
        keywords: str,
        quality_score: int = 3,
        is_template: bool = False
    ):
        """Add an approved story to the reference library."""
        conn = self.get_connection()

        # Get story category
        cursor = conn.execute(
            "SELECT category FROM user_stories WHERE story_id = ?",
            (story_id,)
        )
        story = cursor.fetchone()
        if not story:
            raise ValueError(f"Story not found: {story_id}")

        conn.execute("""
            INSERT INTO story_reference
            (story_id, category, keywords, quality_score, is_template)
            VALUES (?, ?, ?, ?, ?)
        """, (story_id, story['category'], keywords, quality_score,
              1 if is_template else 0))
        conn.commit()

    def search_reference_library(
        self,
        category: Optional[str] = None,
        keywords: Optional[str] = None,
        limit: int = 5
    ) -> List[Dict]:
        """Search for reference stories by category or keywords."""
        conn = self.get_connection()

        query = """
            SELECT r.*, s.title, s.user_story, s.acceptance_criteria
            FROM story_reference r
            JOIN user_stories s ON r.story_id = s.story_id
            WHERE 1=1
        """
        params = []

        if category:
            query += " AND r.category = ?"
            params.append(category)

        if keywords:
            # Simple keyword search
            query += " AND r.keywords LIKE ?"
            params.append(f"%{keywords}%")

        query += " ORDER BY r.quality_score DESC, r.usage_count DESC LIMIT ?"
        params.append(limit)

        cursor = conn.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]


# ============================================================================
# CONVENIENCE FUNCTIONS
# ============================================================================

def get_database(db_path: Optional[str] = None) -> ClientProductDatabase:
    """
    PURPOSE:
        Get a database instance with default path.

    USAGE:
        db = get_database()
        client_id = db.create_client("Acme Corp")
    """
    return ClientProductDatabase(db_path)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("CLIENT PRODUCT DATABASE TEST")
    print("=" * 70)

    # Use test database
    test_db_path = "data/test_client_product_database.db"

    # Remove existing test db
    if os.path.exists(test_db_path):
        os.remove(test_db_path)

    # Initialize database
    db = ClientProductDatabase(test_db_path)

    print("\n1. Creating client...")
    client_id = db.create_client(
        name="Test Healthcare Corp",
        description="Test client for database validation",
        primary_contact="John Doe",
        contact_email="john@test.com"
    )
    print(f"   Created client: {client_id}")

    print("\n2. Creating program...")
    program_id = db.create_program(
        client_id=client_id,
        name="Test Analytics",
        prefix="TEST",
        description="Test program for validation",
        program_type="Analytics"
    )
    print(f"   Created program: {program_id}")

    print("\n3. Saving requirements...")
    test_reqs = [
        {'row_number': 1, 'title': 'Dashboard', 'description': 'User dashboard', 'priority': 'High'},
        {'row_number': 2, 'title': 'Reports', 'description': 'Generate reports', 'priority': 'Medium'},
    ]
    inserted, updated = db.save_requirements(program_id, test_reqs, "test.xlsx")
    print(f"   Saved {inserted} requirements ({updated} updated)")

    print("\n4. Saving user stories...")
    test_stories = [
        {
            'generated_id': 'TEST-DASH-001',
            'title': 'View Dashboard',
            'user_story': 'As a user, I want to view the dashboard, so that I can see metrics',
            'role': 'user',
            'priority': 'High',
            'category_abbrev': 'DASH',
            'is_technical': True,
            'acceptance_criteria': ['Dashboard loads in < 3 seconds', 'All widgets display'],
            'flags': []
        }
    ]
    inserted, updated = db.save_user_stories(program_id, test_stories)
    print(f"   Saved {inserted} stories ({updated} updated)")

    print("\n5. Updating story status...")
    db.update_story_status('TEST-DASH-001', 'Approved', changed_by='test_user')
    print("   Story approved")

    print("\n6. Saving test cases...")
    test_cases = [
        {
            'test_id': 'TEST-DASH-001-TC01',
            'source_story_id': 'TEST-DASH-001',
            'title': 'Verify dashboard loads',
            'test_type': 'happy_path',
            'category': 'DASH',
            'test_steps': ['Navigate to dashboard', 'Verify widgets load'],
            'expected_results': ['Dashboard displays within 3 seconds'],
            'moscow': 'Must Have'
        }
    ]
    inserted, updated = db.save_test_cases(program_id, test_cases)
    print(f"   Saved {inserted} test cases ({updated} updated)")

    print("\n7. Getting program summary...")
    summary = db.get_program_summary(program_id)
    print(f"   Requirements: {summary['requirement_count']}")
    print(f"   Stories: {summary['story_count']}")
    print(f"   Tests: {summary['test_count']}")

    print("\n8. Checking audit trail...")
    audit = db.get_audit_trail('user_story', 'TEST-DASH-001')
    print(f"   Found {len(audit)} audit entries for TEST-DASH-001")
    for entry in audit[:3]:
        print(f"      • {entry['action']}: {entry.get('field_changed', '')} "
              f"({entry['changed_date']})")

    print("\n" + "=" * 70)
    print("DATABASE TEST COMPLETE")
    print(f"Database file: {test_db_path}")
    print("=" * 70)

    db.close()
