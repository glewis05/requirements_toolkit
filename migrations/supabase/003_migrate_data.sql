-- ============================================================================
-- Propel Health Database - Data Migration Script (SQLite → PostgreSQL)
-- Version: 1.0.0
-- Generated: 2026-01-20
--
-- This script migrates data from the existing SQLite database to PostgreSQL.
-- It handles data transformation, deduplication, and relationship mapping.
--
-- PREREQUISITES:
--   1. Run 001_schema.sql to create tables
--   2. Run 002_seed_lookups.sql to populate lookup tables
--   3. Export SQLite data to CSV or use direct INSERT statements
--
-- MIGRATION APPROACH:
--   This script uses a hybrid approach:
--   1. Direct INSERT statements for small tables
--   2. CSV COPY commands for large tables (placeholder paths)
--   3. Transformation queries where data cleanup is needed
-- ============================================================================

-- ============================================================================
-- STEP 0: PRE-MIGRATION SETUP
-- ============================================================================

-- Disable triggers temporarily for faster bulk inserts
ALTER TABLE clients DISABLE TRIGGER ALL;
ALTER TABLE programs DISABLE TRIGGER ALL;
ALTER TABLE clinics DISABLE TRIGGER ALL;
ALTER TABLE locations DISABLE TRIGGER ALL;
ALTER TABLE providers DISABLE TRIGGER ALL;
ALTER TABLE requirements DISABLE TRIGGER ALL;
ALTER TABLE user_stories DISABLE TRIGGER ALL;
ALTER TABLE uat_test_cases DISABLE TRIGGER ALL;
ALTER TABLE traceability DISABLE TRIGGER ALL;
ALTER TABLE compliance_gaps DISABLE TRIGGER ALL;
ALTER TABLE users DISABLE TRIGGER ALL;
ALTER TABLE user_access DISABLE TRIGGER ALL;

-- Create temporary staging tables for complex transformations
CREATE TEMP TABLE staging_providers (
    provider_id         INTEGER,
    location_id         TEXT,
    name                TEXT,
    npi                 TEXT,
    specialty           TEXT,
    email               TEXT,
    phone               TEXT,
    is_active           INTEGER,
    created_at          TIMESTAMP,
    updated_at          TIMESTAMP
);

-- ============================================================================
-- STEP 1: MIGRATE CLIENTS
-- ============================================================================
-- Transformation: Remove duplicate contact columns, convert dates to DATE type
-- ============================================================================

-- Option A: Direct INSERT (for small datasets)
-- Replace with your actual data from SQLite export
/*
INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
)
SELECT
    client_id,
    name,
    short_name,
    description,
    client_type,
    -- Use the preferred contact columns, fall back to duplicates if null
    COALESCE(primary_contact_name, primary_contact),
    COALESCE(primary_contact_email, contact_email),
    primary_contact_phone,
    contract_reference,
    -- Convert TEXT dates to DATE (handle various formats)
    CASE
        WHEN contract_start_date ~ '^\d{4}-\d{2}-\d{2}$' THEN contract_start_date::DATE
        WHEN contract_start_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(contract_start_date, 'MM/DD/YYYY')
        ELSE NULL
    END,
    CASE
        WHEN contract_end_date ~ '^\d{4}-\d{2}-\d{2}$' THEN contract_end_date::DATE
        WHEN contract_end_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(contract_end_date, 'MM/DD/YYYY')
        ELSE NULL
    END,
    source_document,
    COALESCE(status, 'Active'),
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.clients;
*/

-- Option B: COPY from CSV (for larger datasets)
-- Export from SQLite: sqlite3 -header -csv db.db "SELECT ... FROM clients" > clients.csv
-- Then upload to Supabase storage and use:
/*
COPY clients (client_id, name, short_name, description, client_type,
              primary_contact_name, primary_contact_email, primary_contact_phone,
              contract_reference, contract_start_date, contract_end_date,
              source_document, status, created_at, updated_at)
FROM '/path/to/clients_transformed.csv'
WITH (FORMAT csv, HEADER true, NULL '');
*/

-- PLACEHOLDER: Replace with your actual client data
-- Example insert for testing:
INSERT INTO clients (client_id, name, short_name, status)
VALUES ('PROPEL', 'Propel Health', 'Propel', 'Active')
ON CONFLICT (client_id) DO NOTHING;


-- ============================================================================
-- STEP 2: MIGRATE PROGRAMS
-- ============================================================================

/*
INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status,
    created_at, updated_at
)
SELECT
    program_id,
    client_id,
    name,
    prefix,
    description,
    COALESCE(program_type, 'clinic_based'),
    source_file,
    color_hex,
    COALESCE(status, 'Active'),
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.programs;
*/


-- ============================================================================
-- STEP 3: MIGRATE PROGRAM RELATIONSHIPS
-- ============================================================================

/*
INSERT INTO program_relationships (
    parent_program_id, attached_program_id, relationship_type, created_at
)
SELECT
    parent_program_id,
    attached_program_id,
    COALESCE(relationship_type, 'attached'),
    COALESCE(created_date, NOW())
FROM sqlite_export.program_relationships;
*/


-- ============================================================================
-- STEP 4: MIGRATE CLINICS (with new columns)
-- ============================================================================
-- Note: New columns (phone, fax, email, address_*, manager_*, epic_id) will be NULL
-- These can be populated from another source or manually later
-- ============================================================================

/*
INSERT INTO clinics (
    clinic_id, program_id, name, code, description,
    -- New columns default to NULL
    phone, fax, email,
    address_street, address_city, address_state, address_zip,
    manager_name, manager_email, epic_id,
    status, created_at, updated_at
)
SELECT
    clinic_id,
    program_id,
    name,
    code,
    description,
    NULL, NULL, NULL,           -- phone, fax, email
    NULL, NULL, NULL, NULL,     -- address fields
    NULL, NULL, NULL,           -- manager and epic
    COALESCE(status, 'Active'),
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.clinics;
*/


-- ============================================================================
-- STEP 5: MIGRATE LOCATIONS
-- ============================================================================

/*
INSERT INTO locations (
    location_id, clinic_id, name, code,
    address, city, state, zip,
    phone, fax, epic_id,
    status, created_at, updated_at
)
SELECT
    location_id,
    clinic_id,
    name,
    code,
    address, city, state, zip,
    phone, fax, epic_id,
    COALESCE(status, 'Active'),
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.locations;
*/


-- ============================================================================
-- STEP 6: MIGRATE PROVIDERS (Normalize to many-to-many)
-- ============================================================================
-- This is the most complex transformation:
-- 1. Insert unique providers (deduplicated by NPI where available)
-- 2. Create provider_locations junction records
-- ============================================================================

-- Step 6a: Load into staging table
/*
INSERT INTO staging_providers
SELECT * FROM sqlite_export.providers;
*/

-- Step 6b: Insert unique providers
-- If a provider has multiple locations in SQLite, they'll have duplicate rows
-- We deduplicate by NPI (if available) or by name+email combination
/*
INSERT INTO providers (
    provider_id, name, npi, specialty, email, phone,
    is_active, created_at, updated_at
)
SELECT DISTINCT ON (COALESCE(npi, name || COALESCE(email, '')))
    provider_id,
    name,
    npi,
    specialty,
    email,
    phone,
    CASE WHEN is_active = 1 THEN TRUE ELSE FALSE END,
    COALESCE(created_at, NOW()),
    COALESCE(updated_at, NOW())
FROM staging_providers
ORDER BY COALESCE(npi, name || COALESCE(email, '')), provider_id;
*/

-- Step 6c: Create provider_locations records
-- Maps each original provider row to the junction table
/*
INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
SELECT
    p.provider_id,
    sp.location_id,
    TRUE,  -- Mark the original location as primary
    NOW()
FROM staging_providers sp
JOIN providers p ON p.npi = sp.npi OR (p.name = sp.name AND COALESCE(p.email, '') = COALESCE(sp.email, ''));
*/


-- ============================================================================
-- STEP 7: MIGRATE CONFIG DEFINITIONS
-- ============================================================================
-- Transformation: Convert TEXT valid_values to JSONB array
-- ============================================================================

/*
INSERT INTO config_definitions (
    config_key, display_name, description, category,
    data_type, default_value, valid_values,
    is_required, is_sensitive, applies_to, created_at
)
SELECT
    config_key,
    display_name,
    description,
    category,
    COALESCE(data_type, 'text'),
    default_value,
    -- Convert comma-separated values to JSONB array
    CASE
        WHEN valid_values IS NOT NULL AND valid_values != '' THEN
            to_jsonb(string_to_array(valid_values, ','))
        ELSE NULL
    END,
    CASE WHEN is_required = 1 THEN TRUE ELSE FALSE END,
    CASE WHEN is_sensitive = 1 THEN TRUE ELSE FALSE END,
    COALESCE(applies_to, 'all'),
    COALESCE(created_date, NOW())
FROM sqlite_export.config_definitions;
*/


-- ============================================================================
-- STEP 8: MIGRATE CONFIG VALUES
-- ============================================================================

/*
INSERT INTO config_values (
    config_key, value, program_id, clinic_id, location_id,
    source, source_document, effective_date, expiration_date,
    is_override, created_at, updated_at
)
SELECT
    config_key,
    value,
    program_id,
    clinic_id,
    location_id,
    COALESCE(source, 'manual'),
    source_document,
    effective_date,
    expiration_date,
    COALESCE(is_override, FALSE),
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.config_values;
*/


-- ============================================================================
-- STEP 9: MIGRATE REQUIREMENTS
-- ============================================================================
-- Transformation: Convert TEXT context_json to JSONB
-- ============================================================================

/*
INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row,
    raw_text, title, description, priority, source_status,
    requirement_type, context_json, import_batch,
    created_at, updated_at
)
SELECT
    requirement_id,
    program_id,
    source_file,
    source_row,
    raw_text,
    title,
    description,
    priority,
    source_status,
    requirement_type,
    -- Parse TEXT to JSONB, handle invalid JSON gracefully
    CASE
        WHEN context_json IS NOT NULL AND context_json != '' THEN
            context_json::JSONB
        ELSE NULL
    END,
    import_batch,
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.requirements;
*/


-- ============================================================================
-- STEP 10: MIGRATE USER STORIES
-- ============================================================================
-- Transformations:
--   - Convert related_stories TEXT to JSONB array
--   - Convert flags TEXT to JSONB array
--   - Map category to story_categories lookup
-- ============================================================================

/*
INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id,
    title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics,
    priority, category, category_full, is_technical,
    status, internal_notes, meeting_context, client_feedback,
    related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by,
    draft_date, internal_review_date, client_review_date, needs_discussion_date
)
SELECT
    story_id,
    requirement_id,
    program_id,
    parent_story_id,
    title,
    user_story,
    role,
    capability,
    benefit,
    acceptance_criteria,
    success_metrics,
    priority,
    -- Map to lookup table, keep original if not found
    CASE
        WHEN category IN (SELECT category_code FROM story_categories) THEN category
        ELSE 'GEN'
    END,
    category_full,
    COALESCE(is_technical, TRUE),
    -- Validate status against CHECK constraint
    CASE
        WHEN status IN ('Draft', 'Internal Review', 'Pending Client Review', 'Approved', 'Needs Discussion', 'Out of Scope')
        THEN status
        ELSE 'Draft'
    END,
    internal_notes,
    meeting_context,
    client_feedback,
    -- Convert related_stories to JSONB array
    CASE
        WHEN related_stories IS NOT NULL AND related_stories != '' THEN
            to_jsonb(string_to_array(related_stories, ','))
        ELSE '[]'::JSONB
    END,
    -- Convert flags to JSONB array (assume comma-separated)
    CASE
        WHEN flags IS NOT NULL AND flags != '' THEN
            to_jsonb(string_to_array(flags, ','))
        ELSE '[]'::JSONB
    END,
    roadmap_target,
    COALESCE(version, 1),
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW()),
    approved_date,
    approved_by,
    draft_date,
    internal_review_date,
    client_review_date,
    needs_discussion_date
FROM sqlite_export.user_stories;
*/


-- ============================================================================
-- STEP 11: MIGRATE UAT CYCLES
-- ============================================================================

/*
INSERT INTO uat_cycles (
    cycle_id, program_id, name, description, uat_type,
    target_launch_date, status,
    clinical_pm, clinical_pm_email,
    validation_start, validation_end, kickoff_date,
    testing_start, testing_end, review_date,
    retest_start, retest_end, go_nogo_date,
    pre_uat_gate_passed, pre_uat_gate_signed_by,
    pre_uat_gate_signed_date, pre_uat_gate_notes,
    go_nogo_decision, go_nogo_signed_by,
    go_nogo_signed_date, go_nogo_notes,
    created_at, updated_at, created_by
)
SELECT
    cycle_id,
    program_id,
    name,
    description,
    uat_type,
    target_launch_date,
    -- Validate status against CHECK constraint
    CASE
        WHEN status IN ('planning', 'validation', 'kickoff', 'testing', 'review', 'retesting', 'decision', 'complete', 'cancelled')
        THEN status
        ELSE 'planning'
    END,
    clinical_pm,
    clinical_pm_email,
    validation_start, validation_end, kickoff_date,
    testing_start, testing_end, review_date,
    retest_start, retest_end, go_nogo_date,
    CASE WHEN pre_uat_gate_passed = 1 THEN TRUE ELSE FALSE END,
    pre_uat_gate_signed_by,
    pre_uat_gate_signed_date,
    pre_uat_gate_notes,
    go_nogo_decision,
    go_nogo_signed_by,
    go_nogo_signed_date,
    go_nogo_notes,
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW()),
    COALESCE(created_by, 'system')
FROM sqlite_export.uat_cycles;
*/


-- ============================================================================
-- STEP 12: MIGRATE UAT TEST CASES
-- ============================================================================
-- Transformation: Convert patient_conditions TEXT to JSONB
-- ============================================================================

/*
INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id,
    title, category, test_type, prerequisites, test_steps, expected_results,
    priority, estimated_time,
    compliance_framework, control_id, is_compliance_test, compliance_template_id,
    test_status, tested_by, tested_date, execution_notes,
    defect_id, defect_description,
    assigned_to, assignment_type, persona, profile_id, platform,
    workflow_section, workflow_order,
    change_id, target_rule, change_type,
    patient_conditions, cross_trigger_check,
    retest_status, retest_date, retest_by, retest_notes,
    dev_notes, dev_status, notes,
    created_at, updated_at
)
SELECT
    test_id,
    story_id,
    program_id,
    uat_cycle_id,
    title,
    category,
    test_type,
    prerequisites,
    test_steps,
    expected_results,
    priority,
    estimated_time,
    compliance_framework,
    control_id,
    COALESCE(is_compliance_test, FALSE),
    compliance_template_id,
    -- Validate test_status against CHECK constraint
    CASE
        WHEN test_status IN ('Not Run', 'Pass', 'Fail', 'Blocked', 'Skipped')
        THEN test_status
        ELSE 'Not Run'
    END,
    tested_by,
    tested_date,
    execution_notes,
    defect_id,
    defect_description,
    assigned_to,
    assignment_type,
    persona,
    profile_id,
    platform,
    workflow_section,
    COALESCE(workflow_order, 0),
    change_id,
    target_rule,
    change_type,
    -- Convert patient_conditions to JSONB
    CASE
        WHEN patient_conditions IS NOT NULL AND patient_conditions != '' THEN
            patient_conditions::JSONB
        ELSE NULL
    END,
    cross_trigger_check,
    retest_status,
    retest_date,
    retest_by,
    retest_notes,
    dev_notes,
    dev_status,
    notes,
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.uat_test_cases;
*/


-- ============================================================================
-- STEP 13: MIGRATE TRACEABILITY
-- ============================================================================

/*
INSERT INTO traceability (
    program_id, requirement_id, story_id, test_id,
    coverage_status, gap_notes, compliance_coverage,
    created_at, updated_at
)
SELECT
    program_id,
    requirement_id,
    story_id,
    test_id,
    coverage_status,
    gap_notes,
    compliance_coverage,
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.traceability;
*/


-- ============================================================================
-- STEP 14: MIGRATE COMPLIANCE GAPS
-- ============================================================================

/*
INSERT INTO compliance_gaps (
    program_id, requirement_id, story_id,
    framework, control_id, category, gap_description, recommendation,
    severity, status, mitigation_plan, owner, due_date, closed_date,
    notes, created_at, updated_at
)
SELECT
    program_id,
    requirement_id,
    story_id,
    -- Map framework to compliance_frameworks lookup
    CASE
        WHEN framework IN (SELECT framework_id FROM compliance_frameworks) THEN framework
        ELSE 'HIPAA'  -- Default to HIPAA if unknown
    END,
    control_id,
    category,
    gap_description,
    recommendation,
    -- Validate severity
    CASE
        WHEN severity IN ('Critical', 'High', 'Medium', 'Low') THEN severity
        ELSE 'Medium'
    END,
    -- Validate status
    CASE
        WHEN status IN ('Open', 'In Progress', 'Resolved', 'Accepted', 'Deferred') THEN status
        ELSE 'Open'
    END,
    mitigation_plan,
    owner,
    due_date,
    closed_date,
    notes,
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.compliance_gaps;
*/


-- ============================================================================
-- STEP 15: MIGRATE USERS
-- ============================================================================

/*
INSERT INTO users (
    user_id, name, email, organization,
    is_business_associate, status, notes,
    created_at, updated_at
)
SELECT
    user_id,
    name,
    email,
    COALESCE(organization, 'Internal'),
    COALESCE(is_business_associate, FALSE),
    -- Validate status
    CASE
        WHEN status IN ('Active', 'Inactive', 'Terminated') THEN status
        ELSE 'Active'
    END,
    notes,
    COALESCE(created_date, NOW()),
    COALESCE(updated_date, NOW())
FROM sqlite_export.users;
*/


-- ============================================================================
-- STEP 16: MIGRATE USER ACCESS
-- ============================================================================
-- Note: Removed is_active column (redundant with status)
-- ============================================================================

/*
INSERT INTO user_access (
    user_id, program_id, clinic_id, location_id,
    role, status, granted_by, granted_date,
    revoked_by, revoked_date, revoke_reason,
    next_review_due, notes
)
SELECT
    user_id,
    program_id,
    clinic_id,
    location_id,
    role,
    -- Map status, considering is_active
    CASE
        WHEN status = 'Active' AND (is_active IS NULL OR is_active = 1) THEN 'Active'
        WHEN status = 'Active' AND is_active = 0 THEN 'Suspended'
        WHEN status IN ('Suspended', 'Revoked', 'Expired') THEN status
        ELSE 'Active'
    END,
    granted_by,
    COALESCE(granted_date, NOW()),
    revoked_by,
    revoked_date,
    revoke_reason,
    next_review_due,
    notes
FROM sqlite_export.user_access;
*/


-- ============================================================================
-- STEP 17: MIGRATE REMAINING TABLES
-- ============================================================================
-- These tables have straightforward migrations with minimal transformation
-- ============================================================================

-- config_history
/*
INSERT INTO config_history (config_key, program_id, clinic_id, location_id,
                            old_value, new_value, changed_by, changed_at,
                            change_reason, source_document)
SELECT config_key, program_id, clinic_id, location_id,
       old_value, new_value, COALESCE(changed_by, 'system'),
       COALESCE(changed_date, NOW()), change_reason, source_document
FROM sqlite_export.config_history;
*/

-- appointment_types
/*
INSERT INTO appointment_types (location_id, type_name, type_code, is_included, notes, created_at)
SELECT location_id, type_name, type_code,
       CASE WHEN is_included = 1 THEN TRUE ELSE FALSE END,
       notes, COALESCE(created_date, NOW())
FROM sqlite_export.appointment_types;
*/

-- pre_uat_gate_items
/*
INSERT INTO pre_uat_gate_items (cycle_id, category, sequence, item_text,
                                 is_required, is_complete, completed_by,
                                 completed_date, notes, created_at)
SELECT cycle_id, category, COALESCE(sequence, 0), item_text,
       CASE WHEN is_required = 1 THEN TRUE ELSE FALSE END,
       CASE WHEN is_complete = 1 THEN TRUE ELSE FALSE END,
       completed_by, completed_date, notes, COALESCE(created_date, NOW())
FROM sqlite_export.pre_uat_gate_items;
*/

-- uat_test_assignments
/*
INSERT INTO uat_test_assignments (test_id, cycle_id, assigned_to, assignment_type, assigned_date)
SELECT test_id, cycle_id, assigned_to, COALESCE(assignment_type, 'primary'),
       COALESCE(assigned_date, NOW())
FROM sqlite_export.uat_test_assignments;
*/

-- story_reference (convert keywords TEXT to JSONB)
/*
INSERT INTO story_reference (story_id, category, keywords, industry,
                             quality_score, is_template, usage_count, notes, created_at)
SELECT story_id, category,
       CASE WHEN keywords IS NOT NULL AND keywords != ''
            THEN to_jsonb(string_to_array(keywords, ','))
            ELSE '[]'::JSONB
       END,
       industry, COALESCE(quality_score, 3),
       COALESCE(is_template, FALSE), COALESCE(usage_count, 0),
       notes, COALESCE(created_date, NOW())
FROM sqlite_export.story_reference;
*/

-- story_compliance_vetting
/*
INSERT INTO story_compliance_vetting (story_id, framework_id, applies, rationale,
                                       test_cases_required, test_cases_created,
                                       vetted_by, vetted_at)
SELECT story_id, framework_id, applies, rationale,
       COALESCE(test_cases_required, 0), COALESCE(test_cases_created, 0),
       vetted_by, COALESCE(vetted_at, NOW())
FROM sqlite_export.story_compliance_vetting;
*/

-- import_batches
/*
INSERT INTO import_batches (batch_id, program_id, source_file, import_type,
                            records_imported, records_updated, records_skipped,
                            import_date, imported_by, notes)
SELECT batch_id, program_id, source_file, import_type,
       records_imported, records_updated, records_skipped,
       COALESCE(import_date, NOW()), COALESCE(imported_by, 'system'), notes
FROM sqlite_export.import_batches;
*/

-- access_reviews
/*
INSERT INTO access_reviews (access_id, reviewed_by, review_date, review_status, notes, next_review_due)
SELECT access_id, reviewed_by, COALESCE(review_date, NOW()), review_status, notes, next_review_due
FROM sqlite_export.access_reviews;
*/

-- user_training
/*
INSERT INTO user_training (user_id, training_type, assigned_date, assigned_by,
                           completed_date, expiration_date, certificate_reference,
                           status, responsibility, notes)
SELECT user_id, training_type, COALESCE(assigned_date, NOW()), assigned_by,
       completed_date, expiration_date, certificate_reference,
       CASE WHEN status IN ('Pending', 'In Progress', 'Completed', 'Expired', 'Waived')
            THEN status ELSE 'Pending' END,
       COALESCE(responsibility, 'Propel Health'), notes
FROM sqlite_export.user_training;
*/

-- audit_history
/*
INSERT INTO audit_history (record_type, record_id, entity_type, entity_id,
                           action, field_changed, old_value, new_value,
                           changed_by, changed_at, change_reason, session_id, ip_address)
SELECT record_type, record_id, entity_type, entity_id,
       action, field_changed, old_value, new_value,
       COALESCE(changed_by, 'system'), COALESCE(changed_date, NOW()),
       change_reason, session_id,
       CASE WHEN ip_address ~ '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$'
            THEN ip_address::INET ELSE NULL END
FROM sqlite_export.audit_history;
*/

-- onboarding_projects
/*
INSERT INTO onboarding_projects (project_id, program_id, clinic_id, project_name, clinic_name,
                                  status, target_launch_date, actual_launch_date,
                                  client_contact_name, client_contact_email, propel_lead,
                                  notes, created_at, created_by, updated_at)
SELECT project_id, program_id, clinic_id, project_name, clinic_name,
       CASE WHEN status IN ('INTAKE', 'IN_PROGRESS', 'UAT_READY', 'LAUNCHED', 'ON_HOLD')
            THEN status ELSE 'INTAKE' END,
       target_launch_date, actual_launch_date,
       client_contact_name, client_contact_email, propel_lead,
       notes, COALESCE(created_date, NOW()), COALESCE(created_by, 'system'),
       COALESCE(updated_date, NOW())
FROM sqlite_export.onboarding_projects;
*/

-- onboarding_milestones
/*
INSERT INTO onboarding_milestones (project_id, milestone_type, milestone_name, sequence_order,
                                    status, target_date, actual_completion_date, completed_by,
                                    auto_verify_type, auto_verified_date, auto_verified_result,
                                    notes, blocker_reason, created_at, updated_at)
SELECT project_id, milestone_type, milestone_name, sequence_order,
       CASE WHEN status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETE', 'BLOCKED')
            THEN status ELSE 'NOT_STARTED' END,
       target_date, actual_completion_date, completed_by,
       auto_verify_type, auto_verified_date, auto_verified_result,
       notes, blocker_reason, COALESCE(created_date, NOW()), COALESCE(updated_date, NOW())
FROM sqlite_export.onboarding_milestones;
*/

-- onboarding_dependencies
/*
INSERT INTO onboarding_dependencies (project_id, milestone_id, dependency_type, description,
                                      external_reference, external_system, owner, owner_email,
                                      status, due_date, resolved_date, resolved_by,
                                      resolution_notes, created_at, created_by, updated_at)
SELECT project_id, milestone_id, dependency_type, description,
       external_reference, external_system, owner, owner_email,
       CASE WHEN status IN ('PENDING', 'IN_PROGRESS', 'RESOLVED', 'CANCELLED')
            THEN status ELSE 'PENDING' END,
       due_date, resolved_date, resolved_by, resolution_notes,
       COALESCE(created_date, NOW()), COALESCE(created_by, 'system'),
       COALESCE(updated_date, NOW())
FROM sqlite_export.onboarding_dependencies;
*/

-- roadmap_projects
/*
INSERT INTO roadmap_projects (project_id, name, full_name, program_prefix, project_type,
                               start_date, end_date, status, priority, row_number,
                               notes, onboarding_project_id, created_at, updated_at)
SELECT project_id, name, full_name, program_prefix, project_type,
       start_date, end_date, status, priority, row_number,
       notes, onboarding_project_id, COALESCE(created_at, NOW()), COALESCE(updated_at, NOW())
FROM sqlite_export.roadmap_projects;
*/

-- roadmap_project_clinics
/*
INSERT INTO roadmap_project_clinics (project_id, clinic_id)
SELECT project_id, clinic_id
FROM sqlite_export.roadmap_project_clinics;
*/

-- roadmap_dependencies
/*
INSERT INTO roadmap_dependencies (blocked_project_id, blocking_project_id,
                                   dependency_color, is_key_dependency, notes, created_at)
SELECT blocked_project_id, blocking_project_id,
       dependency_color, COALESCE(is_key_dependency, 0) = 1, notes,
       COALESCE(created_at, NOW())
FROM sqlite_export.roadmap_dependencies;
*/


-- ============================================================================
-- STEP 18: RE-ENABLE TRIGGERS
-- ============================================================================

ALTER TABLE clients ENABLE TRIGGER ALL;
ALTER TABLE programs ENABLE TRIGGER ALL;
ALTER TABLE clinics ENABLE TRIGGER ALL;
ALTER TABLE locations ENABLE TRIGGER ALL;
ALTER TABLE providers ENABLE TRIGGER ALL;
ALTER TABLE requirements ENABLE TRIGGER ALL;
ALTER TABLE user_stories ENABLE TRIGGER ALL;
ALTER TABLE uat_test_cases ENABLE TRIGGER ALL;
ALTER TABLE traceability ENABLE TRIGGER ALL;
ALTER TABLE compliance_gaps ENABLE TRIGGER ALL;
ALTER TABLE users ENABLE TRIGGER ALL;
ALTER TABLE user_access ENABLE TRIGGER ALL;


-- ============================================================================
-- STEP 19: RESET SEQUENCES
-- ============================================================================
-- After importing data with explicit IDs, reset serial sequences
-- ============================================================================

SELECT setval('program_relationships_relationship_id_seq',
              COALESCE((SELECT MAX(relationship_id) FROM program_relationships), 0) + 1, false);

SELECT setval('providers_provider_id_seq',
              COALESCE((SELECT MAX(provider_id) FROM providers), 0) + 1, false);

SELECT setval('provider_locations_provider_location_id_seq',
              COALESCE((SELECT MAX(provider_location_id) FROM provider_locations), 0) + 1, false);

SELECT setval('config_values_value_id_seq',
              COALESCE((SELECT MAX(value_id) FROM config_values), 0) + 1, false);

SELECT setval('config_history_history_id_seq',
              COALESCE((SELECT MAX(history_id) FROM config_history), 0) + 1, false);

SELECT setval('appointment_types_type_id_seq',
              COALESCE((SELECT MAX(type_id) FROM appointment_types), 0) + 1, false);

SELECT setval('pre_uat_gate_items_item_id_seq',
              COALESCE((SELECT MAX(item_id) FROM pre_uat_gate_items), 0) + 1, false);

SELECT setval('uat_test_assignments_assignment_id_seq',
              COALESCE((SELECT MAX(assignment_id) FROM uat_test_assignments), 0) + 1, false);

SELECT setval('traceability_trace_id_seq',
              COALESCE((SELECT MAX(trace_id) FROM traceability), 0) + 1, false);

SELECT setval('compliance_gaps_gap_id_seq',
              COALESCE((SELECT MAX(gap_id) FROM compliance_gaps), 0) + 1, false);

SELECT setval('story_reference_reference_id_seq',
              COALESCE((SELECT MAX(reference_id) FROM story_reference), 0) + 1, false);

SELECT setval('story_compliance_vetting_vetting_id_seq',
              COALESCE((SELECT MAX(vetting_id) FROM story_compliance_vetting), 0) + 1, false);

SELECT setval('user_access_access_id_seq',
              COALESCE((SELECT MAX(access_id) FROM user_access), 0) + 1, false);

SELECT setval('access_reviews_review_id_seq',
              COALESCE((SELECT MAX(review_id) FROM access_reviews), 0) + 1, false);

SELECT setval('user_training_training_id_seq',
              COALESCE((SELECT MAX(training_id) FROM user_training), 0) + 1, false);

SELECT setval('role_conflicts_conflict_id_seq',
              COALESCE((SELECT MAX(conflict_id) FROM role_conflicts), 0) + 1, false);

SELECT setval('audit_history_audit_id_seq',
              COALESCE((SELECT MAX(audit_id) FROM audit_history), 0) + 1, false);

SELECT setval('onboarding_milestones_milestone_id_seq',
              COALESCE((SELECT MAX(milestone_id) FROM onboarding_milestones), 0) + 1, false);

SELECT setval('onboarding_dependencies_dependency_id_seq',
              COALESCE((SELECT MAX(dependency_id) FROM onboarding_dependencies), 0) + 1, false);

SELECT setval('roadmap_project_clinics_id_seq',
              COALESCE((SELECT MAX(id) FROM roadmap_project_clinics), 0) + 1, false);

SELECT setval('roadmap_dependencies_dependency_id_seq',
              COALESCE((SELECT MAX(dependency_id) FROM roadmap_dependencies), 0) + 1, false);

SELECT setval('roadmap_holidays_holiday_id_seq',
              COALESCE((SELECT MAX(holiday_id) FROM roadmap_holidays), 0) + 1, false);

SELECT setval('roadmap_activity_types_type_id_seq',
              COALESCE((SELECT MAX(type_id) FROM roadmap_activity_types), 0) + 1, false);


-- ============================================================================
-- STEP 20: DATA INTEGRITY VALIDATION
-- ============================================================================

DO $$
DECLARE
    v_orphaned_count INTEGER;
    v_invalid_status INTEGER;
BEGIN
    -- Check for orphaned programs (no client)
    SELECT COUNT(*) INTO v_orphaned_count
    FROM programs WHERE client_id IS NOT NULL
    AND client_id NOT IN (SELECT client_id FROM clients);

    IF v_orphaned_count > 0 THEN
        RAISE WARNING 'Found % programs with invalid client_id', v_orphaned_count;
    END IF;

    -- Check for orphaned clinics (no program)
    SELECT COUNT(*) INTO v_orphaned_count
    FROM clinics WHERE program_id NOT IN (SELECT program_id FROM programs);

    IF v_orphaned_count > 0 THEN
        RAISE WARNING 'Found % clinics with invalid program_id', v_orphaned_count;
    END IF;

    -- Check for stories with invalid status (should be caught by CHECK constraint)
    SELECT COUNT(*) INTO v_invalid_status
    FROM user_stories WHERE status NOT IN
    ('Draft', 'Internal Review', 'Pending Client Review', 'Approved', 'Needs Discussion', 'Out of Scope');

    IF v_invalid_status > 0 THEN
        RAISE WARNING 'Found % stories with invalid status', v_invalid_status;
    END IF;

    -- Check for test cases with invalid status
    SELECT COUNT(*) INTO v_invalid_status
    FROM uat_test_cases WHERE test_status NOT IN
    ('Not Run', 'Pass', 'Fail', 'Blocked', 'Skipped');

    IF v_invalid_status > 0 THEN
        RAISE WARNING 'Found % test cases with invalid test_status', v_invalid_status;
    END IF;

    RAISE NOTICE 'Data integrity validation complete';
END $$;


-- ============================================================================
-- STEP 21: POST-MIGRATION STATISTICS
-- ============================================================================

SELECT 'Migration Statistics' AS report;
SELECT '===================' AS separator;
SELECT 'clients' AS table_name, COUNT(*) AS row_count FROM clients
UNION ALL SELECT 'programs', COUNT(*) FROM programs
UNION ALL SELECT 'clinics', COUNT(*) FROM clinics
UNION ALL SELECT 'locations', COUNT(*) FROM locations
UNION ALL SELECT 'providers', COUNT(*) FROM providers
UNION ALL SELECT 'provider_locations', COUNT(*) FROM provider_locations
UNION ALL SELECT 'requirements', COUNT(*) FROM requirements
UNION ALL SELECT 'user_stories', COUNT(*) FROM user_stories
UNION ALL SELECT 'uat_cycles', COUNT(*) FROM uat_cycles
UNION ALL SELECT 'uat_test_cases', COUNT(*) FROM uat_test_cases
UNION ALL SELECT 'traceability', COUNT(*) FROM traceability
UNION ALL SELECT 'compliance_gaps', COUNT(*) FROM compliance_gaps
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'user_access', COUNT(*) FROM user_access
UNION ALL SELECT 'audit_history', COUNT(*) FROM audit_history
ORDER BY table_name;


-- ============================================================================
-- END OF MIGRATION SCRIPT
-- ============================================================================
