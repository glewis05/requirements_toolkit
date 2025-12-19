# database/__init__.py
# ============================================================================
# CLIENT PRODUCT DATABASE MODULE
# ============================================================================
# Central database for tracking client programs, requirements, user stories,
# UAT test cases, and compliance documentation.
#
# USAGE:
#     from database import ClientProductDatabase, get_database
#     from database import queries
#     from database import import_stories_from_excel
#
#     # Get database instance
#     db = get_database()
#
#     # Or specify custom path
#     db = ClientProductDatabase("path/to/custom.db")
#
#     # Create client and program
#     client_id = db.create_client("Acme Corp")
#     program_id = db.create_program(client_id, "Analytics", "ACME")
#
#     # Save requirements
#     db.save_requirements(program_id, requirements, "source.xlsx")
#
#     # Get dashboard summary
#     summary = db.get_program_summary(program_id)
#
#     # Use pre-built queries
#     tree = queries.get_client_program_tree(db)
#     health = queries.get_program_health_score(db, program_id)
#
#     # Direct import of refined stories
#     result = import_stories_from_excel(db, "stories.xlsx", "Client", "Program", "PROP")
#
# ============================================================================

from .db_manager import ClientProductDatabase, get_database
from . import queries
from .import_stories import import_stories_from_excel, quick_import
from . import audit_queries
from .audit_queries import (
    get_record_audit_trail,
    get_program_audit_report,
    get_recent_changes,
    format_audit_for_display,
    format_recent_changes_table,
    format_audit_summary,
    VALID_RECORD_TYPES
)

__all__ = [
    'ClientProductDatabase',
    'get_database',
    'queries',
    'import_stories_from_excel',
    'quick_import',
    'audit_queries',
    'get_record_audit_trail',
    'get_program_audit_report',
    'get_recent_changes',
    'format_audit_for_display',
    'format_recent_changes_table',
    'format_audit_summary',
    'VALID_RECORD_TYPES',
]
