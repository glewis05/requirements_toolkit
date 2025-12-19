# database/audit_queries.py
# ============================================================================
# AUDIT HISTORY QUERIES
# ============================================================================
# Purpose: Query and format audit history data from the Client Product Database.
#          Provides functions for compliance reviews, change tracking, and
#          regulatory documentation.
#
# AVIATION ANALOGY:
#   This is like pulling data from the Flight Data Recorder (black box).
#   Every action, every change, every decision is logged and can be
#   retrieved for analysis, incident investigation, or regulatory audits.
#
# REGULATORY CONTEXT:
#   FDA 21 CFR Part 11 requires:
#   - Computer-generated, time-stamped audit trails
#   - Record of operator entries and actions
#   - Secure, computer-generated records
#   - Ability to generate accurate and complete copies of records
#
# ============================================================================

from datetime import datetime, timedelta
from typing import Optional, Dict, List, Any


# ============================================================================
# VALID RECORD TYPES
# ============================================================================
# These are the record types tracked in the audit_history table

VALID_RECORD_TYPES = [
    'client',
    'program',
    'requirement',
    'user_story',
    'test_case',
    'compliance_gap',
    'traceability'
]

# Human-readable names for record types
RECORD_TYPE_NAMES = {
    'client': 'Client',
    'program': 'Program',
    'requirement': 'Requirement',
    'user_story': 'User Story',
    'test_case': 'Test Case',
    'compliance_gap': 'Compliance Gap',
    'traceability': 'Traceability'
}


# ============================================================================
# AUDIT QUERY FUNCTIONS
# ============================================================================

def get_record_audit_trail(
    db,
    record_type: str,
    record_id: str
) -> List[Dict]:
    """
    PURPOSE:
        Get full change history for a specific record.
        Returns all audit entries for a single record, newest first.

    PARAMETERS:
        db: ClientProductDatabase instance
        record_type (str): Type of record - one of:
            'client', 'program', 'requirement', 'user_story',
            'test_case', 'compliance_gap', 'traceability'
        record_id (str): The ID of the record (e.g., 'PROP-RECRUIT-001')

    RETURNS:
        List of audit entries, newest first:
        [
            {
                'audit_id': 1,
                'action': 'Status Changed',
                'field_changed': 'status',
                'old_value': 'Draft',
                'new_value': 'Approved',
                'changed_by': 'system',
                'changed_date': '2024-12-19 10:30:00',
                'change_reason': 'Client approved in meeting',
                'session_id': 'abc123'
            },
            ...
        ]

    R EQUIVALENT:
        get_record_audit <- function(db, record_type, record_id) {
            query <- "SELECT * FROM audit_history
                      WHERE record_type = ? AND record_id = ?
                      ORDER BY changed_date DESC"
            dbGetQuery(db, query, params = list(record_type, record_id))
        }

    WHY THIS APPROACH:
        Provides complete transparency into all changes made to a record.
        Essential for regulatory compliance and debugging.
    """
    conn = db.get_connection()

    cursor = conn.execute("""
        SELECT
            audit_id,
            record_type,
            record_id,
            action,
            field_changed,
            old_value,
            new_value,
            changed_by,
            changed_date,
            change_reason,
            session_id
        FROM audit_history
        WHERE record_type = ? AND record_id = ?
        ORDER BY changed_date DESC, audit_id DESC
    """, (record_type, record_id))

    return [dict(row) for row in cursor.fetchall()]


def get_program_audit_report(
    db,
    program_id: str,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None
) -> Dict[str, Any]:
    """
    PURPOSE:
        Get all changes for a program within a date range.
        Includes changes to all related records (requirements, stories, tests).

    PARAMETERS:
        db: ClientProductDatabase instance
        program_id (str): Program ID or prefix
        start_date (str, optional): Start of date range (YYYY-MM-DD)
        end_date (str, optional): End of date range (YYYY-MM-DD)

    RETURNS:
        Dict with structured audit data:
        {
            'program': {...},  # Program details
            'date_range': {'start': '...', 'end': '...'},
            'summary': {
                'total_changes': 150,
                'by_type': {'user_story': 80, 'test_case': 50, ...},
                'by_action': {'Created': 30, 'Updated': 100, ...}
            },
            'entries': [...]  # All audit entries
        }

    WHY THIS APPROACH:
        Provides a comprehensive view of all program activity for
        compliance reviews and regulatory audits.
    """
    conn = db.get_connection()

    # Get program info
    program = db.get_program(program_id)
    if not program:
        # Try by prefix
        program = db.get_program_by_prefix(program_id)

    if not program:
        return {
            'program': None,
            'error': f"Program not found: {program_id}",
            'entries': []
        }

    program_id = program['program_id']

    # Default date range: last 30 days
    if not end_date:
        end_date = datetime.now().strftime('%Y-%m-%d')
    if not start_date:
        start_date = (datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d')

    # Get all related record IDs
    # Requirements
    req_cursor = conn.execute(
        "SELECT requirement_id FROM requirements WHERE program_id = ?",
        (program_id,)
    )
    req_ids = [row[0] for row in req_cursor.fetchall()]

    # User stories
    story_cursor = conn.execute(
        "SELECT story_id FROM user_stories WHERE program_id = ?",
        (program_id,)
    )
    story_ids = [row[0] for row in story_cursor.fetchall()]

    # Test cases
    test_cursor = conn.execute(
        "SELECT test_id FROM uat_test_cases WHERE program_id = ?",
        (program_id,)
    )
    test_ids = [row[0] for row in test_cursor.fetchall()]

    # Compliance gaps
    gap_cursor = conn.execute(
        "SELECT gap_id FROM compliance_gaps WHERE program_id = ?",
        (program_id,)
    )
    gap_ids = [str(row[0]) for row in gap_cursor.fetchall()]

    # Collect all IDs
    all_ids = [program_id] + req_ids + story_ids + test_ids + gap_ids

    # Build query
    if not all_ids:
        return {
            'program': program,
            'date_range': {'start': start_date, 'end': end_date},
            'summary': {'total_changes': 0, 'by_type': {}, 'by_action': {}},
            'entries': []
        }

    placeholders = ','.join(['?' for _ in all_ids])

    cursor = conn.execute(f"""
        SELECT *
        FROM audit_history
        WHERE record_id IN ({placeholders})
        AND date(changed_date) BETWEEN ? AND ?
        ORDER BY changed_date DESC, audit_id DESC
    """, all_ids + [start_date, end_date])

    entries = [dict(row) for row in cursor.fetchall()]

    # Build summary
    summary = {
        'total_changes': len(entries),
        'by_type': {},
        'by_action': {}
    }

    for entry in entries:
        rec_type = entry.get('record_type', 'unknown')
        action = entry.get('action', 'unknown')

        summary['by_type'][rec_type] = summary['by_type'].get(rec_type, 0) + 1
        summary['by_action'][action] = summary['by_action'].get(action, 0) + 1

    return {
        'program': program,
        'date_range': {'start': start_date, 'end': end_date},
        'summary': summary,
        'entries': entries
    }


def get_recent_changes(
    db,
    days: int = 7,
    record_type: Optional[str] = None,
    limit: int = 100
) -> List[Dict]:
    """
    PURPOSE:
        Get recent changes across all programs.
        Useful for activity feeds and monitoring.

    PARAMETERS:
        db: ClientProductDatabase instance
        days (int): Number of days to look back (default: 7)
        record_type (str, optional): Filter by record type
        limit (int): Maximum entries to return (default: 100)

    RETURNS:
        List of recent audit entries with program context:
        [
            {
                'audit_id': 1,
                'record_type': 'user_story',
                'record_id': 'PROP-RECRUIT-001',
                'action': 'Status Changed',
                'field_changed': 'status',
                'old_value': 'Draft',
                'new_value': 'Approved',
                'changed_by': 'system',
                'changed_date': '2024-12-19 10:30:00',
                'record_name': 'Number (N) Invited',  # Human-readable name
                'program_prefix': 'PROP'  # If available
            },
            ...
        ]

    R EQUIVALENT:
        get_recent_changes <- function(db, days = 7) {
            cutoff <- Sys.Date() - days
            query <- "SELECT * FROM audit_history
                      WHERE changed_date >= ?
                      ORDER BY changed_date DESC
                      LIMIT 100"
            dbGetQuery(db, query, params = list(cutoff))
        }
    """
    conn = db.get_connection()

    cutoff = (datetime.now() - timedelta(days=days)).strftime('%Y-%m-%d')

    # Build query with optional type filter
    if record_type:
        cursor = conn.execute("""
            SELECT *
            FROM audit_history
            WHERE date(changed_date) >= ?
            AND record_type = ?
            ORDER BY changed_date DESC, audit_id DESC
            LIMIT ?
        """, (cutoff, record_type, limit))
    else:
        cursor = conn.execute("""
            SELECT *
            FROM audit_history
            WHERE date(changed_date) >= ?
            ORDER BY changed_date DESC, audit_id DESC
            LIMIT ?
        """, (cutoff, limit))

    entries = [dict(row) for row in cursor.fetchall()]

    # Enrich entries with human-readable names
    for entry in entries:
        entry['record_name'] = _get_record_name(conn, entry['record_type'], entry['record_id'])
        entry['program_prefix'] = _extract_prefix(entry['record_id'])

    return entries


def _get_record_name(conn, record_type: str, record_id: str) -> str:
    """
    PURPOSE:
        Get a human-readable name for a record.

    PARAMETERS:
        conn: Database connection
        record_type: Type of record
        record_id: ID of the record

    RETURNS:
        str: Human-readable name or the ID if not found
    """
    try:
        if record_type == 'user_story':
            cursor = conn.execute(
                "SELECT title FROM user_stories WHERE story_id = ?",
                (record_id,)
            )
            row = cursor.fetchone()
            if row:
                return row[0]

        elif record_type == 'test_case':
            cursor = conn.execute(
                "SELECT title FROM uat_test_cases WHERE test_id = ?",
                (record_id,)
            )
            row = cursor.fetchone()
            if row:
                return row[0]

        elif record_type == 'program':
            cursor = conn.execute(
                "SELECT name FROM programs WHERE program_id = ?",
                (record_id,)
            )
            row = cursor.fetchone()
            if row:
                return row[0]

        elif record_type == 'client':
            cursor = conn.execute(
                "SELECT name FROM clients WHERE client_id = ?",
                (record_id,)
            )
            row = cursor.fetchone()
            if row:
                return row[0]

        elif record_type == 'requirement':
            cursor = conn.execute(
                "SELECT title FROM requirements WHERE requirement_id = ?",
                (record_id,)
            )
            row = cursor.fetchone()
            if row and row[0]:
                return row[0]

    except Exception:
        pass

    return record_id


def _extract_prefix(record_id: str) -> str:
    """
    PURPOSE:
        Extract program prefix from a record ID.

    PARAMETERS:
        record_id: ID like 'PROP-RECRUIT-001'

    RETURNS:
        str: Prefix like 'PROP' or empty string if not found
    """
    if not record_id:
        return ''

    parts = str(record_id).split('-')
    if len(parts) >= 1:
        # Check if first part looks like a prefix (all caps, short)
        first = parts[0]
        if first.isupper() and len(first) <= 10:
            return first

    return ''


# ============================================================================
# FORMATTING FUNCTIONS
# ============================================================================

def format_audit_for_display(
    audit_entries: List[Dict],
    title: str = "AUDIT TRAIL",
    max_value_length: int = 50
) -> str:
    """
    PURPOSE:
        Format audit entries for terminal display.
        Creates a nicely formatted table for console output.

    PARAMETERS:
        audit_entries (list): List of audit entry dicts
        title (str): Title to display at top
        max_value_length (int): Truncate values longer than this

    RETURNS:
        str: Formatted string for terminal display

    EXAMPLE OUTPUT:
        ┌─────────────────────────────────────────────────────────────────┐
        │ AUDIT TRAIL: PROP-RECRUIT-001                                   │
        ├─────────────────────────────────────────────────────────────────┤
        │ 2024-12-19 10:30  │ Status Changed                              │
        │                   │ status: Draft → Approved                    │
        │                   │ By: system                                  │
        │                   │ Reason: Client approved in meeting          │
        ├─────────────────────────────────────────────────────────────────┤
        │ 2024-12-18 14:15  │ Updated                                     │
        │                   │ title: [old] → [new]                        │
        │                   │ By: system                                  │
        └─────────────────────────────────────────────────────────────────┘
    """
    if not audit_entries:
        return f"No audit entries found for: {title}"

    # Calculate width
    width = 70

    lines = []

    # Top border
    lines.append("┌" + "─" * (width - 2) + "┐")

    # Title
    title_line = f"│ {title}"
    title_line = title_line + " " * (width - len(title_line) - 1) + "│"
    lines.append(title_line)

    # Header separator
    lines.append("├" + "─" * (width - 2) + "┤")

    # Entries
    for i, entry in enumerate(audit_entries):
        # Date and action line
        date_str = entry.get('changed_date', 'Unknown')[:16]  # Trim to YYYY-MM-DD HH:MM
        action = entry.get('action', 'Unknown')

        line1 = f"│ {date_str}  │ {action}"
        line1 = line1 + " " * (width - len(line1) - 1) + "│"
        lines.append(line1)

        # Field change line (if applicable)
        field = entry.get('field_changed')
        old_val = entry.get('old_value', '')
        new_val = entry.get('new_value', '')

        if field:
            # Truncate long values
            if old_val and len(str(old_val)) > max_value_length:
                old_val = str(old_val)[:max_value_length] + "..."
            if new_val and len(str(new_val)) > max_value_length:
                new_val = str(new_val)[:max_value_length] + "..."

            change_text = f"{field}: {old_val} → {new_val}"
            line2 = f"│                   │ {change_text}"
            if len(line2) > width - 1:
                line2 = line2[:width - 4] + "...│"
            else:
                line2 = line2 + " " * (width - len(line2) - 1) + "│"
            lines.append(line2)

        # Changed by line
        changed_by = entry.get('changed_by', 'system')
        line3 = f"│                   │ By: {changed_by}"
        line3 = line3 + " " * (width - len(line3) - 1) + "│"
        lines.append(line3)

        # Reason line (if present)
        reason = entry.get('change_reason')
        if reason:
            reason_text = f"Reason: {reason}"
            if len(reason_text) > 45:
                reason_text = reason_text[:42] + "..."
            line4 = f"│                   │ {reason_text}"
            line4 = line4 + " " * (width - len(line4) - 1) + "│"
            lines.append(line4)

        # Separator between entries (except last)
        if i < len(audit_entries) - 1:
            lines.append("├" + "─" * (width - 2) + "┤")

    # Bottom border
    lines.append("└" + "─" * (width - 2) + "┘")

    return "\n".join(lines)


def format_recent_changes_table(
    entries: List[Dict],
    max_entries: int = 20
) -> str:
    """
    PURPOSE:
        Format recent changes as a simple table for terminal display.

    PARAMETERS:
        entries (list): List of audit entries
        max_entries (int): Maximum entries to show

    RETURNS:
        str: Formatted table string
    """
    if not entries:
        return "No recent changes found."

    lines = []

    # Header
    lines.append("")
    lines.append("  Date/Time          │ Type        │ Record ID              │ Action")
    lines.append("  " + "─" * 70)

    # Entries
    for entry in entries[:max_entries]:
        date_str = entry.get('changed_date', '')[:16]
        rec_type = RECORD_TYPE_NAMES.get(entry.get('record_type', ''), entry.get('record_type', ''))[:11]
        record_id = str(entry.get('record_id', ''))[:22]
        action = entry.get('action', '')[:20]

        line = f"  {date_str:<18} │ {rec_type:<11} │ {record_id:<22} │ {action}"
        lines.append(line)

    if len(entries) > max_entries:
        lines.append(f"  ... and {len(entries) - max_entries} more entries")

    lines.append("")

    return "\n".join(lines)


def format_audit_summary(summary: Dict) -> str:
    """
    PURPOSE:
        Format audit summary statistics for display.

    PARAMETERS:
        summary (dict): Summary dict with by_type, by_action counts

    RETURNS:
        str: Formatted summary string
    """
    lines = []

    lines.append("")
    lines.append(f"  Total Changes: {summary.get('total_changes', 0)}")
    lines.append("")

    # By record type
    by_type = summary.get('by_type', {})
    if by_type:
        lines.append("  By Record Type:")
        for rec_type, count in sorted(by_type.items(), key=lambda x: -x[1]):
            type_name = RECORD_TYPE_NAMES.get(rec_type, rec_type)
            lines.append(f"    • {type_name}: {count}")
        lines.append("")

    # By action
    by_action = summary.get('by_action', {})
    if by_action:
        lines.append("  By Action:")
        for action, count in sorted(by_action.items(), key=lambda x: -x[1]):
            lines.append(f"    • {action}: {count}")
        lines.append("")

    return "\n".join(lines)


# ============================================================================
# MODULE EXPORTS
# ============================================================================

__all__ = [
    'VALID_RECORD_TYPES',
    'RECORD_TYPE_NAMES',
    'get_record_audit_trail',
    'get_program_audit_report',
    'get_recent_changes',
    'format_audit_for_display',
    'format_recent_changes_table',
    'format_audit_summary',
]
