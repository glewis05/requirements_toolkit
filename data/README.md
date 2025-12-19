# Data Directory

This directory contains the SQLite database file(s) for the Requirements Toolkit.

## Files

- `client_product_database.db` - Main production database (created at runtime)
- `test_client_product_database.db` - Test database (created during testing)

## Database Purpose

The Client Product Database stores:

- **Clients** - Organizations (Discover Health, NCCN, GenoRx, etc.)
- **Programs** - Projects under each client with unique prefixes (PROP, GRX, DIS)
- **Requirements** - Raw requirements parsed from source files
- **User Stories** - Generated stories with full lifecycle tracking
- **UAT Test Cases** - Test cases with execution status
- **Compliance Gaps** - Identified gaps by framework (Part 11, HIPAA, SOC 2)
- **Audit History** - Complete change log for regulatory compliance

## Backup Recommendations

For production use:
1. Schedule regular backups of `client_product_database.db`
2. Store backups in a separate location
3. Test restore procedures periodically

## Schema

See `../database/schema.sql` for the complete database schema.
