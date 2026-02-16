-- ============================================================================
-- Propel Health Database - Truncate All Data for Fresh Migration
-- Version: 007
-- Date: 2026-02-13
--
-- PURPOSE: Wipe all existing data from Supabase while preserving:
--          - Schema (tables, columns, constraints)
--          - Triggers and functions
--          - RLS policies
--          - Lookup/seed data (re-seeded in 002_seed_lookups.sql)
--
-- RUN THIS: In Supabase SQL Editor AFTER 006_schema_alignment.sql
--           and BEFORE running the consolidation migration script.
--
-- WARNING: This is destructive! Back up data first if needed.
--          The SQLite database at ~/projects/data/client_product_database.db
--          serves as the read-only backup.
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: Disable triggers for faster truncation
-- ============================================================================

-- Data tables (in reverse FK dependency order)
ALTER TABLE audit_history DISABLE TRIGGER USER;
ALTER TABLE roadmap_dependencies DISABLE TRIGGER USER;
ALTER TABLE roadmap_project_clinics DISABLE TRIGGER USER;
ALTER TABLE roadmap_projects DISABLE TRIGGER USER;
ALTER TABLE onboarding_submissions DISABLE TRIGGER USER;
ALTER TABLE onboarding_dependencies DISABLE TRIGGER USER;
ALTER TABLE onboarding_milestones DISABLE TRIGGER USER;
ALTER TABLE onboarding_projects DISABLE TRIGGER USER;
ALTER TABLE user_training DISABLE TRIGGER USER;
ALTER TABLE access_reviews DISABLE TRIGGER USER;
ALTER TABLE user_access DISABLE TRIGGER USER;
ALTER TABLE users DISABLE TRIGGER USER;
ALTER TABLE compliance_gaps DISABLE TRIGGER USER;
ALTER TABLE traceability DISABLE TRIGGER USER;
ALTER TABLE uat_test_assignments DISABLE TRIGGER USER;
ALTER TABLE uat_test_cases DISABLE TRIGGER USER;
ALTER TABLE pre_uat_gate_items DISABLE TRIGGER USER;
ALTER TABLE uat_cycles DISABLE TRIGGER USER;
ALTER TABLE story_compliance_vetting DISABLE TRIGGER USER;
ALTER TABLE story_reference DISABLE TRIGGER USER;
ALTER TABLE user_stories DISABLE TRIGGER USER;
ALTER TABLE requirements DISABLE TRIGGER USER;
ALTER TABLE import_batches DISABLE TRIGGER USER;
ALTER TABLE config_history DISABLE TRIGGER USER;
ALTER TABLE config_values DISABLE TRIGGER USER;
ALTER TABLE config_definitions DISABLE TRIGGER USER;
ALTER TABLE appointment_types DISABLE TRIGGER USER;
ALTER TABLE provider_locations DISABLE TRIGGER USER;
ALTER TABLE providers DISABLE TRIGGER USER;
ALTER TABLE locations DISABLE TRIGGER USER;
ALTER TABLE clinics DISABLE TRIGGER USER;
ALTER TABLE program_relationships DISABLE TRIGGER USER;
ALTER TABLE programs DISABLE TRIGGER USER;
ALTER TABLE clients DISABLE TRIGGER USER;

-- ============================================================================
-- STEP 2: Truncate data tables (reverse FK order, CASCADE for safety)
-- ============================================================================
-- CASCADE ensures dependent rows are removed even if we miss an ordering edge.
-- We still order carefully to be explicit about the dependency chain.

-- Leaf tables (no dependents)
TRUNCATE TABLE audit_history CASCADE;
TRUNCATE TABLE roadmap_dependencies CASCADE;
TRUNCATE TABLE roadmap_project_clinics CASCADE;
TRUNCATE TABLE roadmap_projects CASCADE;
TRUNCATE TABLE onboarding_submissions CASCADE;
TRUNCATE TABLE onboarding_dependencies CASCADE;
TRUNCATE TABLE onboarding_milestones CASCADE;
TRUNCATE TABLE onboarding_projects CASCADE;
TRUNCATE TABLE user_training CASCADE;
TRUNCATE TABLE access_reviews CASCADE;
TRUNCATE TABLE user_access CASCADE;
TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE compliance_gaps CASCADE;
TRUNCATE TABLE traceability CASCADE;
TRUNCATE TABLE uat_test_assignments CASCADE;
TRUNCATE TABLE uat_test_cases CASCADE;
TRUNCATE TABLE pre_uat_gate_items CASCADE;
TRUNCATE TABLE uat_cycles CASCADE;
TRUNCATE TABLE story_compliance_vetting CASCADE;
TRUNCATE TABLE story_reference CASCADE;
TRUNCATE TABLE user_stories CASCADE;
TRUNCATE TABLE requirements CASCADE;
TRUNCATE TABLE import_batches CASCADE;
TRUNCATE TABLE config_history CASCADE;
TRUNCATE TABLE config_values CASCADE;
TRUNCATE TABLE config_definitions CASCADE;
TRUNCATE TABLE appointment_types CASCADE;
TRUNCATE TABLE provider_locations CASCADE;
TRUNCATE TABLE providers CASCADE;
TRUNCATE TABLE locations CASCADE;
TRUNCATE TABLE clinics CASCADE;
TRUNCATE TABLE program_relationships CASCADE;
TRUNCATE TABLE programs CASCADE;
TRUNCATE TABLE clients CASCADE;

-- ============================================================================
-- STEP 3: Reset auto-increment sequences
-- ============================================================================

-- Tables with SERIAL/BIGSERIAL columns need sequence resets
ALTER SEQUENCE IF EXISTS program_relationships_relationship_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS provider_locations_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS config_values_value_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS config_history_history_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS appointment_types_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS story_reference_reference_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS story_compliance_vetting_vetting_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS pre_uat_gate_items_item_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS uat_test_assignments_assignment_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS traceability_trace_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS compliance_gaps_gap_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS user_access_access_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS access_reviews_review_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS user_training_training_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS audit_history_audit_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS onboarding_milestones_milestone_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS onboarding_dependencies_dependency_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS roadmap_project_clinics_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS roadmap_dependencies_dependency_id_seq RESTART WITH 1;

-- ============================================================================
-- STEP 4: Re-enable triggers
-- ============================================================================

ALTER TABLE clients ENABLE TRIGGER USER;
ALTER TABLE programs ENABLE TRIGGER USER;
ALTER TABLE program_relationships ENABLE TRIGGER USER;
ALTER TABLE clinics ENABLE TRIGGER USER;
ALTER TABLE locations ENABLE TRIGGER USER;
ALTER TABLE providers ENABLE TRIGGER USER;
ALTER TABLE provider_locations ENABLE TRIGGER USER;
ALTER TABLE config_definitions ENABLE TRIGGER USER;
ALTER TABLE config_values ENABLE TRIGGER USER;
ALTER TABLE config_history ENABLE TRIGGER USER;
ALTER TABLE appointment_types ENABLE TRIGGER USER;
ALTER TABLE import_batches ENABLE TRIGGER USER;
ALTER TABLE requirements ENABLE TRIGGER USER;
ALTER TABLE user_stories ENABLE TRIGGER USER;
ALTER TABLE story_reference ENABLE TRIGGER USER;
ALTER TABLE story_compliance_vetting ENABLE TRIGGER USER;
ALTER TABLE uat_cycles ENABLE TRIGGER USER;
ALTER TABLE pre_uat_gate_items ENABLE TRIGGER USER;
ALTER TABLE uat_test_cases ENABLE TRIGGER USER;
ALTER TABLE uat_test_assignments ENABLE TRIGGER USER;
ALTER TABLE traceability ENABLE TRIGGER USER;
ALTER TABLE compliance_gaps ENABLE TRIGGER USER;
ALTER TABLE users ENABLE TRIGGER USER;
ALTER TABLE user_access ENABLE TRIGGER USER;
ALTER TABLE access_reviews ENABLE TRIGGER USER;
ALTER TABLE user_training ENABLE TRIGGER USER;
ALTER TABLE audit_history ENABLE TRIGGER USER;
ALTER TABLE onboarding_projects ENABLE TRIGGER USER;
ALTER TABLE onboarding_milestones ENABLE TRIGGER USER;
ALTER TABLE onboarding_dependencies ENABLE TRIGGER USER;
ALTER TABLE onboarding_submissions ENABLE TRIGGER USER;
ALTER TABLE roadmap_projects ENABLE TRIGGER USER;
ALTER TABLE roadmap_project_clinics ENABLE TRIGGER USER;
ALTER TABLE roadmap_dependencies ENABLE TRIGGER USER;

-- ============================================================================
-- STEP 5: Verify all data tables are empty
-- ============================================================================

DO $$
DECLARE
    v_count INTEGER;
    v_total INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count FROM clients; v_total := v_total + v_count;
    IF v_count > 0 THEN RAISE WARNING 'clients still has % rows', v_count; END IF;

    SELECT COUNT(*) INTO v_count FROM programs; v_total := v_total + v_count;
    IF v_count > 0 THEN RAISE WARNING 'programs still has % rows', v_count; END IF;

    SELECT COUNT(*) INTO v_count FROM user_stories; v_total := v_total + v_count;
    IF v_count > 0 THEN RAISE WARNING 'user_stories still has % rows', v_count; END IF;

    SELECT COUNT(*) INTO v_count FROM uat_test_cases; v_total := v_total + v_count;
    IF v_count > 0 THEN RAISE WARNING 'uat_test_cases still has % rows', v_count; END IF;

    SELECT COUNT(*) INTO v_count FROM users; v_total := v_total + v_count;
    IF v_count > 0 THEN RAISE WARNING 'users still has % rows', v_count; END IF;

    SELECT COUNT(*) INTO v_count FROM audit_history; v_total := v_total + v_count;
    IF v_count > 0 THEN RAISE WARNING 'audit_history still has % rows', v_count; END IF;

    IF v_total = 0 THEN
        RAISE NOTICE 'All data tables truncated successfully.';
    ELSE
        RAISE WARNING 'Total remaining rows across checked tables: %', v_total;
    END IF;

    -- Verify lookup tables still have data
    SELECT COUNT(*) INTO v_count FROM story_categories;
    RAISE NOTICE 'story_categories (preserved): % rows', v_count;

    SELECT COUNT(*) INTO v_count FROM compliance_frameworks;
    RAISE NOTICE 'compliance_frameworks (preserved): % rows', v_count;

    SELECT COUNT(*) INTO v_count FROM priority_levels;
    RAISE NOTICE 'priority_levels (preserved): % rows', v_count;
END $$;

COMMIT;
