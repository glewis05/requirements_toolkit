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
# ============================================================================

from .db_manager import ClientProductDatabase, get_database
from . import queries

__all__ = [
    'ClientProductDatabase',
    'get_database',
    'queries',
]
