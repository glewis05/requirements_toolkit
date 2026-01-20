# Propel Health Database - Supabase Migration

This directory contains the complete migration package for moving from SQLite to Supabase (PostgreSQL).

## Migration Files

| File | Purpose | Run Order |
|------|---------|-----------|
| `001_schema.sql` | Complete normalized PostgreSQL schema with all tables, indexes, triggers | 1st |
| `002_seed_lookups.sql` | Initial data for lookup/reference tables | 2nd |
| `003_migrate_data.sql` | Data migration templates (customize with your data) | 3rd |
| `004_create_views.sql` | Dashboard views and helper functions | 4th |
| `005_rls_policies.sql` | Row Level Security policy templates (commented out) | 5th (optional) |

## Quick Start

### 1. Create Supabase Project
1. Go to [supabase.com](https://supabase.com) and create a new project
2. Wait for the database to be provisioned
3. Go to SQL Editor

### 2. Run Migration Scripts
Run each script in order in the Supabase SQL Editor:

```sql
-- Step 1: Create schema
-- Paste contents of 001_schema.sql and run

-- Step 2: Seed lookup tables
-- Paste contents of 002_seed_lookups.sql and run

-- Step 3: Migrate data (customize first!)
-- Edit 003_migrate_data.sql with your actual data
-- Paste and run

-- Step 4: Create views
-- Paste contents of 004_create_views.sql and run

-- Step 5: Enable RLS (optional, customize first)
-- Uncomment desired policies in 005_rls_policies.sql
-- Paste and run
```

## Key Improvements Over SQLite Schema

### Normalization
- **Providers**: Now many-to-many with locations via `provider_locations` junction table
- **Duplicate columns removed**: `clients.primary_contact` / `contact_email` consolidated
- **JSONB for structured data**: `context_json`, `related_stories`, `flags`, `patient_conditions`, `keywords`, `valid_values`

### PostgreSQL Features
- **UUID primary keys** for new tables (using `gen_random_uuid()`)
- **TIMESTAMPTZ** for all timestamps (timezone-aware)
- **CHECK constraints** on all status fields
- **Proper foreign keys** with `ON DELETE` actions
- **Indexes** on all foreign keys and frequently filtered columns
- **Trigger-based** `updated_at` column management

### New Tables
- `provider_locations` - Junction table for provider ↔ location many-to-many
- `priority_levels` - MoSCoW priority lookup
- `story_categories` - User story category lookup
- `test_types` - Test case type lookup
- `onboarding_submissions` - Web form submissions with JSONB form data

### Status Field Constraints

| Table | Status Values |
|-------|---------------|
| `clients` | Active, Inactive |
| `programs` | Active, Inactive, Archived |
| `clinics/locations` | Active, Inactive, Onboarding, Archived |
| `user_stories` | Draft, Internal Review, Pending Client Review, Approved, Needs Discussion, Out of Scope |
| `uat_test_cases` | Not Run, Pass, Fail, Blocked, Skipped |
| `uat_cycles` | planning, validation, kickoff, testing, review, retesting, decision, complete, cancelled |
| `onboarding_projects` | INTAKE, IN_PROGRESS, UAT_READY, LAUNCHED, ON_HOLD |
| `onboarding_milestones` | NOT_STARTED, IN_PROGRESS, COMPLETE, BLOCKED |
| `compliance_gaps` | Open, In Progress, Resolved, Accepted, Deferred |
| `users` | Active, Inactive, Terminated |
| `user_access` | Active, Suspended, Revoked, Expired |

## Data Migration Notes

### Before Migration
1. **Backup your SQLite database**
2. **Export data to CSV** or generate INSERT statements
3. **Review data transformations** in `003_migrate_data.sql`

### Key Transformations

**Providers (Many-to-Many)**
```sql
-- Old: provider.location_id (one location per provider)
-- New: provider_locations table (many locations per provider)

-- Migration creates provider_locations records from original location_id
```

**TEXT → JSONB**
```sql
-- Convert comma-separated TEXT to JSONB array
CASE
    WHEN keywords IS NOT NULL AND keywords != ''
    THEN to_jsonb(string_to_array(keywords, ','))
    ELSE '[]'::JSONB
END
```

**INTEGER → BOOLEAN**
```sql
-- Convert SQLite integer booleans to PostgreSQL BOOLEAN
CASE WHEN is_active = 1 THEN TRUE ELSE FALSE END
```

**Timestamp Columns**
- SQLite: `created_date`, `updated_date`
- PostgreSQL: `created_at`, `updated_at` (with automatic trigger)

### After Migration
1. Run the verification queries at the end of `003_migrate_data.sql`
2. Check row counts match expectations
3. Test a few queries to verify data integrity
4. Create views (`004_create_views.sql`)

## Row Level Security (RLS)

RLS is **enabled** on all tables but policies are **not defined** by default.

### Enabling RLS
1. Review `005_rls_policies.sql`
2. Customize helper functions for your auth setup
3. Uncomment desired policies
4. Test thoroughly before production use

### Policy Structure
- **SELECT**: Users see data they have access to
- **INSERT**: Requires appropriate role/access
- **UPDATE**: Requires access to the resource
- **DELETE**: Usually admin-only

### Testing RLS
```sql
-- Simulate a user
SET LOCAL request.jwt.claims = '{"sub": "user_123", "role": "user", "program_access": ["PROP"]}';

-- Run queries
SELECT * FROM programs;  -- Should only see PROP

-- Reset
RESET request.jwt.claims;
```

## Views

| View | Purpose |
|------|---------|
| `v_program_summary` | Dashboard stats per program |
| `v_client_program_tree` | Hierarchical client/program listing |
| `v_story_workflow` | Story status with test counts |
| `v_stories_needing_attention` | Stories requiring action |
| `v_test_execution` | Test execution by type |
| `v_test_execution_by_workflow` | Test execution by workflow section |
| `v_test_assignments_summary` | Progress by tester |
| `v_compliance_dashboard` | Compliance gaps by framework |
| `v_compliance_by_story` | Story compliance vetting status |
| `v_onboarding_status` | Onboarding project progress |
| `v_onboarding_submissions_pending` | Form submissions awaiting review |
| `v_user_access_summary` | User access overview |
| `v_access_reviews_due` | Access reviews needed |
| `v_role_conflict_check` | Segregation of duties violations |
| `v_requirements_traceability` | Full requirement → story → test tracing |
| `v_coverage_gaps` | Items lacking test coverage |

## Supabase-Specific Features

### Real-time Subscriptions
Tables that benefit from real-time updates:
- `onboarding_submissions` - Form submission status
- `uat_test_cases` - Test execution updates
- `user_stories` - Story status changes

Enable in Supabase Dashboard → Database → Replication.

### Edge Functions
Consider creating Edge Functions for:
- Complex access control logic
- Data transformation on insert
- Webhook integrations

### Storage
Use Supabase Storage for:
- Source requirement documents
- Exported reports
- Form attachments

## Rollback

If you need to rollback:

1. The SQLite database is unchanged by this migration
2. Drop the PostgreSQL schema:
   ```sql
   DROP SCHEMA public CASCADE;
   CREATE SCHEMA public;
   GRANT ALL ON SCHEMA public TO postgres;
   GRANT ALL ON SCHEMA public TO public;
   ```
3. Re-run migration scripts

## Support

- Supabase Docs: https://supabase.com/docs
- PostgreSQL Docs: https://www.postgresql.org/docs/
- Migration issues: Check the `audit_history` table for data integrity
