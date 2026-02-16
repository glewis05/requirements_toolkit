# Propel Health Database - Supabase Migration

This directory contains the migration package for syncing data from the local SQLite database to the shared Supabase (PostgreSQL) instance.

## Architecture

Three apps share a single Supabase project (`royctwjkewpnrcqdyhzd`, us-west-2):

| App | Role | Key Tables |
|-----|------|------------|
| **TraceWell** | Primary schema owner | stories, UAT, compliance, risk, notifications |
| **Onboarding Form** | Collects clinic data | `onboarding_submissions`, `manual_login_codes` |
| **requirements_toolkit** | Migrates SQLite + Notion data | Organization hierarchy, config, test cases |

TraceWell's `supabase/migrations/` directory is the **single source of truth** for all schema migrations.

## Migration Files

### Original Schema (in this directory)

| File | Purpose | Notes |
|------|---------|-------|
| `001_schema.sql` | Complete normalized PostgreSQL schema | Run once during initial setup |
| `002_seed_lookups.sql` | Initial data for lookup/reference tables | Run once |
| `003_migrate_data.sql` | Data migration templates | Superseded by `consolidate_to_supabase.py` |
| `004_create_views.sql` | Legacy dashboard views | 13 of 16 views archived in migration 018 |
| `005_rls_policies.sql` | RLS policy templates (commented out) | Superseded by migration 019 |

### Data Sync Script

| File | Purpose |
|------|---------|
| `consolidate_to_supabase.py` | Automated SQLite → Supabase sync + Notion test import |

### TraceWell Migrations (in propel-requirements-dashboard/supabase/migrations/)

| File | Purpose |
|------|---------|
| `001-014` | Core TraceWell schema (stories, UAT, compliance, risk, security) |
| `015_risk_assessment_schema.sql` | Risk assessment module (7 tables, 3 enums) |
| `017_migrate_test_cases.sql` | Transform legacy `uat_test_cases` → TraceWell `test_cases` |
| `018_archive_legacy_tables.sql` | Archive ~19 legacy tables to `_archive` schema |
| `019_organization_rls_policies.sql` | RLS policies for shared organization tables |

## consolidate_to_supabase.py

The primary data sync tool. Reads from SQLite and Notion, writes to Supabase.

### Commands

```bash
# Full sync: SQLite → Supabase (skipping Notion)
python3 consolidate_to_supabase.py --execute --skip-notion

# Notion NCCN tests only
python3 consolidate_to_supabase.py --execute --notion-only nccn

# Notion GRXP tests only
python3 consolidate_to_supabase.py --execute --notion-only grxp

# Full sync: SQLite + all Notion databases
python3 consolidate_to_supabase.py --execute

# Dry run (show what would happen, no writes)
python3 consolidate_to_supabase.py

# Verify migration integrity
python3 consolidate_to_supabase.py --verify
```

### Environment Variables

```bash
export SUPABASE_URL="https://royctwjkewpnrcqdyhzd.supabase.co"
export SUPABASE_SERVICE_KEY="your-service-role-key"
export NOTION_API_KEY="your-notion-integration-token"  # Required for Notion sync
```

### Tables Written (Post-Restructuring)

| Table | Source | Method |
|-------|--------|--------|
| `clients` | SQLite | Upsert |
| `programs` | SQLite | Upsert |
| `clinics`, `locations` | SQLite | Upsert |
| `providers`, `provider_locations` | SQLite | Insert (cleared first) |
| `config_definitions` | SQLite | Upsert |
| `config_values` | SQLite | Insert (cleared first) |
| `requirements` | SQLite | Upsert |
| `users` | SQLite | Upsert |
| `user_stories` | SQLite | Upsert |
| `uat_cycles` | SQLite | Upsert |
| `test_cases` | SQLite + Notion | Upsert (deterministic UUID from legacy text ID) |
| `test_executions` | SQLite + Notion | Insert (cleared first) |
| `onboarding_projects` | SQLite | Upsert |
| `onboarding_milestones` | SQLite | Insert (cleared first) |
| `onboarding_dependencies` | SQLite | Insert (cleared first) |

### Test Case ID Mapping

Legacy `uat_test_cases` used TEXT primary keys (e.g., `NCCN-TC-001`). TraceWell's `test_cases` uses UUID primary keys.

The script generates **deterministic UUIDs** using `uuid5(NAMESPACE_DNS, text_id)`:
- Python: `uuid.uuid5(uuid.NAMESPACE_DNS, "NCCN-TC-001")`
- SQL equivalent: `uuid_generate_v5('6ba7b810-9dad-11d1-80b4-00c04fd430c8'::uuid, 'NCCN-TC-001')`

Both produce the same UUID, ensuring consistency between SQL migration 017 and the Python script.

### Notion Database IDs

| Database | Notion ID |
|----------|-----------|
| NCCN Tests | `74882519de814d81af7957793434cfe6` |
| GRXP Tests | `892b60e9897c4fba8c7c5e3a9d68cc49` |

## Archived Tables (Migration 018)

The following tables were moved to `_archive` schema and dropped from `public`. Data is preserved and queryable via SQL but invisible to the PostgREST API.

| Table | Rows | Replaced By |
|-------|------|-------------|
| `uat_test_cases` | ~620 | `test_cases` (TraceWell schema) |
| `uat_test_assignments` | ~92 | `test_executions` (TraceWell schema) |
| `story_compliance_vetting` | ~136 | `story_compliance_mappings` |
| `compliance_test_templates` | ~12 | AI test generation |
| `compliance_gaps` | 0 | `compliance_gap_analysis` view |
| `traceability` | ~8 | `traceability_matrix` view |
| `audit_history` | ~2750 | Domain-specific audit tables |
| `story_reference` | varies | Dormant feature |
| `import_batches` | ~2 | Migration complete |
| `user_access` | ~332 | TraceWell RBAC |
| `user_training` | ~9 | Archive for future use |
| `pre_uat_gate_items` | ~13 | Cycle management |
| `roadmap_projects` | ~29 | Separate app planned |
| `roadmap_project_clinics` | ~2 | Goes with roadmap |
| `roadmap_dependencies` | ~9 | Goes with roadmap |
| `roadmap_holidays` | varies | Goes with roadmap |
| `roadmap_config` | varies | Goes with roadmap |
| `roadmap_activity_types` | varies | Goes with roadmap |

### Archived Views (dropped in migration 018)

`v_program_summary`, `v_story_workflow`, `v_stories_needing_attention`, `v_test_execution`,
`v_test_execution_by_workflow`, `v_test_assignments_summary`, `v_compliance_dashboard`,
`v_compliance_by_story`, `v_user_access_summary`, `v_access_reviews_due`,
`v_role_conflict_check`, `v_requirements_traceability`, `v_coverage_gaps`

### Surviving Views

| View | Purpose |
|------|---------|
| `v_client_program_tree` | Hierarchical client/program listing |
| `v_onboarding_status` | Onboarding project progress |
| `v_onboarding_submissions_pending` | Form submissions awaiting review |

## Row Level Security (RLS)

### Organization Tables (Migration 019)

RLS policies are now active on all shared organization tables:

| Table | SELECT | INSERT/UPDATE/DELETE |
|-------|--------|---------------------|
| `clients` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `clinics` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `locations` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `providers` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `provider_locations` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `config_definitions` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `config_values` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `config_history` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `onboarding_projects` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `onboarding_milestones` | All authenticated | Admin, Portfolio Mgr, Program Mgr |
| `onboarding_dependencies` | All authenticated | Admin, Portfolio Mgr, Program Mgr |

**Service role bypass**: The onboarding form and migration scripts use the `service_role` key, which bypasses RLS entirely. These policies only affect authenticated users (TraceWell dashboard, anon key access).

## Key Improvements Over SQLite Schema

### Normalization
- **Providers**: Many-to-many with locations via `provider_locations` junction table
- **JSONB for structured data**: `context_json`, `related_stories`, `flags`, `patient_conditions`

### PostgreSQL Features
- **UUID primary keys** for new tables (using `gen_random_uuid()`)
- **TIMESTAMPTZ** for all timestamps (timezone-aware)
- **CHECK constraints** on all status fields
- **Proper foreign keys** with `ON DELETE` actions
- **Indexes** on all foreign keys and frequently filtered columns
- **Trigger-based** `updated_at` column management

### Status Field Constraints

| Table | Status Values |
|-------|---------------|
| `clients` | Active, Inactive |
| `programs` | Active, Inactive, Archived |
| `clinics/locations` | Active, Inactive, Onboarding, Archived |
| `user_stories` | Draft, Internal Review, Pending Client Review, Approved, Needs Discussion, Out of Scope |
| `test_cases` | draft, ready, in_progress, completed, deprecated |
| `test_executions` | assigned, in_progress, passed, failed, blocked, verified |
| `uat_cycles` | planning, validation, kickoff, testing, review, retesting, decision, complete, cancelled |
| `onboarding_projects` | INTAKE, IN_PROGRESS, UAT_READY, LAUNCHED, ON_HOLD |
| `onboarding_milestones` | NOT_STARTED, IN_PROGRESS, COMPLETE, BLOCKED |
| `users` | Active, Inactive, Terminated |

## Supabase-Specific Features

### Real-time Subscriptions
Tables that benefit from real-time updates:
- `onboarding_submissions` - Form submission status
- `test_cases` / `test_executions` - Test execution updates
- `user_stories` - Story status changes

Enable in Supabase Dashboard → Database → Replication.

## Rollback

1. The SQLite database is unchanged by any migration
2. Archived data is preserved in `_archive` schema — restore with:
   ```sql
   INSERT INTO public.{table} SELECT * FROM _archive.{table};
   ```
3. For full rollback, re-run the original schema migrations (001-005)

## Support

- Supabase Docs: https://supabase.com/docs
- PostgreSQL Docs: https://www.postgresql.org/docs/

*Last updated: February 2026*
