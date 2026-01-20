-- ============================================================================
-- Propel Health Database - Row Level Security (RLS) Policies
-- Version: 1.0.0
-- Generated: 2026-01-20
--
-- This file contains RLS policy templates for Supabase.
-- RLS is ENABLED on all tables in 001_schema.sql but policies are not yet defined.
--
-- IMPORTANT: These policies are COMMENTED OUT by default.
-- Review and customize based on your authentication setup before enabling.
--
-- ASSUMPTIONS:
--   1. Using Supabase Auth with JWT tokens
--   2. User ID stored in auth.uid()
--   3. Custom claims may include: organization, role, program_access
--   4. Service role bypasses RLS for backend operations
-- ============================================================================

-- ============================================================================
-- HELPER FUNCTIONS FOR RLS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Function: auth.user_id()
-- PURPOSE: Get the current authenticated user's ID
-- NOTE: Supabase provides auth.uid() by default, this is a convenience wrapper
-- ----------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION auth.user_id()
RETURNS TEXT AS $$
    SELECT COALESCE(
        current_setting('request.jwt.claims', true)::json->>'sub',
        (current_setting('request.jwt.claims', true)::json->>'user_id')::text
    );
$$ LANGUAGE sql STABLE;
*/

-- ----------------------------------------------------------------------------
-- Function: auth.user_role()
-- PURPOSE: Get the current user's role from JWT claims
-- ----------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION auth.user_role()
RETURNS TEXT AS $$
    SELECT COALESCE(
        current_setting('request.jwt.claims', true)::json->>'role',
        'user'
    );
$$ LANGUAGE sql STABLE;
*/

-- ----------------------------------------------------------------------------
-- Function: auth.user_organization()
-- PURPOSE: Get the current user's organization from JWT claims
-- ----------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION auth.user_organization()
RETURNS TEXT AS $$
    SELECT current_setting('request.jwt.claims', true)::json->>'organization';
$$ LANGUAGE sql STABLE;
*/

-- ----------------------------------------------------------------------------
-- Function: auth.user_program_access()
-- PURPOSE: Get the array of program IDs the user has access to
-- ----------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION auth.user_program_access()
RETURNS TEXT[] AS $$
    SELECT ARRAY(
        SELECT jsonb_array_elements_text(
            (current_setting('request.jwt.claims', true)::jsonb)->'program_access'
        )
    );
$$ LANGUAGE sql STABLE;
*/

-- ----------------------------------------------------------------------------
-- Function: has_program_access(program_id TEXT)
-- PURPOSE: Check if user has access to a specific program
-- This checks both JWT claims and the user_access table
-- ----------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION has_program_access(p_program_id TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    v_has_access BOOLEAN;
BEGIN
    -- Admin role has access to all programs
    IF auth.user_role() = 'admin' THEN
        RETURN TRUE;
    END IF;

    -- Check JWT claims first (faster)
    IF p_program_id = ANY(auth.user_program_access()) THEN
        RETURN TRUE;
    END IF;

    -- Fall back to database check
    SELECT EXISTS(
        SELECT 1
        FROM user_access ua
        WHERE ua.user_id = auth.user_id()
          AND ua.program_id = p_program_id
          AND ua.status = 'Active'
    ) INTO v_has_access;

    RETURN COALESCE(v_has_access, FALSE);
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;
*/


-- ============================================================================
-- RLS POLICIES BY TABLE
-- ============================================================================
-- Policies follow the principle of least privilege:
--   - Users can only see data they have explicit access to
--   - Write operations require appropriate roles
--   - Admin role has full access
--   - Service role (backend) bypasses RLS
-- ============================================================================


-- ============================================================================
-- CLIENTS TABLE
-- ============================================================================
-- Clients are visible if user has access to any program under the client
-- ============================================================================

/*
-- SELECT: Users can see clients they have program access to
CREATE POLICY clients_select_policy ON clients
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR client_id IN (
            SELECT DISTINCT p.client_id
            FROM programs p
            WHERE has_program_access(p.program_id)
        )
    );

-- INSERT: Admin only
CREATE POLICY clients_insert_policy ON clients
    FOR INSERT
    WITH CHECK (auth.user_role() = 'admin');

-- UPDATE: Admin only
CREATE POLICY clients_update_policy ON clients
    FOR UPDATE
    USING (auth.user_role() = 'admin')
    WITH CHECK (auth.user_role() = 'admin');

-- DELETE: Admin only (or disable entirely)
CREATE POLICY clients_delete_policy ON clients
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- PROGRAMS TABLE
-- ============================================================================
-- Programs filtered by user's program_access
-- ============================================================================

/*
CREATE POLICY programs_select_policy ON programs
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY programs_insert_policy ON programs
    FOR INSERT
    WITH CHECK (auth.user_role() = 'admin');

CREATE POLICY programs_update_policy ON programs
    FOR UPDATE
    USING (auth.user_role() = 'admin' OR has_program_access(program_id))
    WITH CHECK (auth.user_role() = 'admin' OR has_program_access(program_id));

CREATE POLICY programs_delete_policy ON programs
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- CLINICS TABLE
-- ============================================================================

/*
CREATE POLICY clinics_select_policy ON clinics
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY clinics_insert_policy ON clinics
    FOR INSERT
    WITH CHECK (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY clinics_update_policy ON clinics
    FOR UPDATE
    USING (auth.user_role() = 'admin' OR has_program_access(program_id))
    WITH CHECK (auth.user_role() = 'admin' OR has_program_access(program_id));

CREATE POLICY clinics_delete_policy ON clinics
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- LOCATIONS TABLE
-- ============================================================================

/*
CREATE POLICY locations_select_policy ON locations
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR clinic_id IN (
            SELECT clinic_id FROM clinics WHERE has_program_access(program_id)
        )
    );

CREATE POLICY locations_insert_policy ON locations
    FOR INSERT
    WITH CHECK (
        auth.user_role() = 'admin'
        OR clinic_id IN (
            SELECT clinic_id FROM clinics WHERE has_program_access(program_id)
        )
    );

CREATE POLICY locations_update_policy ON locations
    FOR UPDATE
    USING (
        auth.user_role() = 'admin'
        OR clinic_id IN (
            SELECT clinic_id FROM clinics WHERE has_program_access(program_id)
        )
    );

CREATE POLICY locations_delete_policy ON locations
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- PROVIDERS TABLE
-- ============================================================================

/*
CREATE POLICY providers_select_policy ON providers
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR provider_id IN (
            SELECT pl.provider_id
            FROM provider_locations pl
            JOIN locations l ON pl.location_id = l.location_id
            JOIN clinics c ON l.clinic_id = c.clinic_id
            WHERE has_program_access(c.program_id)
        )
    );

CREATE POLICY providers_insert_policy ON providers
    FOR INSERT
    WITH CHECK (auth.user_role() IN ('admin', 'manager'));

CREATE POLICY providers_update_policy ON providers
    FOR UPDATE
    USING (auth.user_role() IN ('admin', 'manager'));

CREATE POLICY providers_delete_policy ON providers
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- REQUIREMENTS TABLE
-- ============================================================================

/*
CREATE POLICY requirements_select_policy ON requirements
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY requirements_insert_policy ON requirements
    FOR INSERT
    WITH CHECK (has_program_access(program_id));

CREATE POLICY requirements_update_policy ON requirements
    FOR UPDATE
    USING (has_program_access(program_id));

CREATE POLICY requirements_delete_policy ON requirements
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- USER_STORIES TABLE
-- ============================================================================

/*
CREATE POLICY user_stories_select_policy ON user_stories
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY user_stories_insert_policy ON user_stories
    FOR INSERT
    WITH CHECK (has_program_access(program_id));

CREATE POLICY user_stories_update_policy ON user_stories
    FOR UPDATE
    USING (has_program_access(program_id));

-- Only allow status changes by specific roles
CREATE POLICY user_stories_approve_policy ON user_stories
    FOR UPDATE
    USING (
        auth.user_role() IN ('admin', 'manager', 'qa_lead')
        AND status != OLD.status
        AND NEW.status = 'Approved'
    );

CREATE POLICY user_stories_delete_policy ON user_stories
    FOR DELETE
    USING (auth.user_role() = 'admin' AND status = 'Draft');
*/


-- ============================================================================
-- UAT_TEST_CASES TABLE
-- ============================================================================

/*
CREATE POLICY uat_test_cases_select_policy ON uat_test_cases
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY uat_test_cases_insert_policy ON uat_test_cases
    FOR INSERT
    WITH CHECK (has_program_access(program_id));

-- Allow testers to update test status
CREATE POLICY uat_test_cases_update_policy ON uat_test_cases
    FOR UPDATE
    USING (has_program_access(program_id));

CREATE POLICY uat_test_cases_delete_policy ON uat_test_cases
    FOR DELETE
    USING (auth.user_role() IN ('admin', 'qa_lead'));
*/


-- ============================================================================
-- UAT_CYCLES TABLE
-- ============================================================================

/*
CREATE POLICY uat_cycles_select_policy ON uat_cycles
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR program_id IS NULL
        OR has_program_access(program_id)
    );

CREATE POLICY uat_cycles_insert_policy ON uat_cycles
    FOR INSERT
    WITH CHECK (auth.user_role() IN ('admin', 'qa_lead'));

CREATE POLICY uat_cycles_update_policy ON uat_cycles
    FOR UPDATE
    USING (auth.user_role() IN ('admin', 'qa_lead'));

CREATE POLICY uat_cycles_delete_policy ON uat_cycles
    FOR DELETE
    USING (auth.user_role() = 'admin' AND status = 'planning');
*/


-- ============================================================================
-- COMPLIANCE_GAPS TABLE
-- ============================================================================

/*
CREATE POLICY compliance_gaps_select_policy ON compliance_gaps
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR has_program_access(program_id)
    );

CREATE POLICY compliance_gaps_insert_policy ON compliance_gaps
    FOR INSERT
    WITH CHECK (has_program_access(program_id));

CREATE POLICY compliance_gaps_update_policy ON compliance_gaps
    FOR UPDATE
    USING (has_program_access(program_id));

CREATE POLICY compliance_gaps_delete_policy ON compliance_gaps
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- USERS TABLE
-- ============================================================================
-- Users can see themselves; admins can see all users
-- ============================================================================

/*
CREATE POLICY users_select_policy ON users
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR user_id = auth.user_id()
    );

CREATE POLICY users_insert_policy ON users
    FOR INSERT
    WITH CHECK (auth.user_role() = 'admin');

-- Users can update their own profile (limited fields)
CREATE POLICY users_self_update_policy ON users
    FOR UPDATE
    USING (user_id = auth.user_id())
    WITH CHECK (
        user_id = auth.user_id()
        -- Cannot change their own status
        AND NEW.status = OLD.status
    );

-- Admins can update any user
CREATE POLICY users_admin_update_policy ON users
    FOR UPDATE
    USING (auth.user_role() = 'admin');

CREATE POLICY users_delete_policy ON users
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- USER_ACCESS TABLE
-- ============================================================================

/*
CREATE POLICY user_access_select_policy ON user_access
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR user_id = auth.user_id()
    );

CREATE POLICY user_access_insert_policy ON user_access
    FOR INSERT
    WITH CHECK (auth.user_role() = 'admin');

CREATE POLICY user_access_update_policy ON user_access
    FOR UPDATE
    USING (auth.user_role() = 'admin');

CREATE POLICY user_access_delete_policy ON user_access
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- AUDIT_HISTORY TABLE
-- ============================================================================
-- Audit history is append-only; no updates or deletes allowed
-- ============================================================================

/*
CREATE POLICY audit_history_select_policy ON audit_history
    FOR SELECT
    USING (auth.user_role() = 'admin');

-- Anyone can insert (via triggers), but with restrictions
CREATE POLICY audit_history_insert_policy ON audit_history
    FOR INSERT
    WITH CHECK (
        changed_by = auth.user_id()
        OR auth.user_role() = 'admin'
    );

-- No updates allowed
CREATE POLICY audit_history_update_policy ON audit_history
    FOR UPDATE
    USING (FALSE);

-- No deletes allowed
CREATE POLICY audit_history_delete_policy ON audit_history
    FOR DELETE
    USING (FALSE);
*/


-- ============================================================================
-- ONBOARDING_SUBMISSIONS TABLE
-- ============================================================================
-- Special handling for public form submissions
-- ============================================================================

/*
-- Submitters can see their own submissions
CREATE POLICY submissions_select_own ON onboarding_submissions
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR submitter_email = (auth.jwt()->>'email')
    );

-- Anyone can create a draft submission
CREATE POLICY submissions_insert_policy ON onboarding_submissions
    FOR INSERT
    WITH CHECK (
        submission_status = 'draft'
        AND submitter_email = (auth.jwt()->>'email')
    );

-- Submitters can update their own drafts
CREATE POLICY submissions_update_own ON onboarding_submissions
    FOR UPDATE
    USING (
        submitter_email = (auth.jwt()->>'email')
        AND submission_status IN ('draft', 'submitted')
    );

-- Admins can update any submission (for review workflow)
CREATE POLICY submissions_admin_update ON onboarding_submissions
    FOR UPDATE
    USING (auth.user_role() = 'admin');

-- No deletes except by admin
CREATE POLICY submissions_delete_policy ON onboarding_submissions
    FOR DELETE
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- LOOKUP TABLES (Read-only for most users)
-- ============================================================================

/*
-- Priority levels - everyone can read
CREATE POLICY priority_levels_select ON priority_levels
    FOR SELECT
    USING (TRUE);

CREATE POLICY priority_levels_modify ON priority_levels
    FOR ALL
    USING (auth.user_role() = 'admin');

-- Story categories - everyone can read
CREATE POLICY story_categories_select ON story_categories
    FOR SELECT
    USING (TRUE);

CREATE POLICY story_categories_modify ON story_categories
    FOR ALL
    USING (auth.user_role() = 'admin');

-- Test types - everyone can read
CREATE POLICY test_types_select ON test_types
    FOR SELECT
    USING (TRUE);

CREATE POLICY test_types_modify ON test_types
    FOR ALL
    USING (auth.user_role() = 'admin');

-- Workflow sections - everyone can read
CREATE POLICY workflow_sections_select ON uat_workflow_sections
    FOR SELECT
    USING (TRUE);

CREATE POLICY workflow_sections_modify ON uat_workflow_sections
    FOR ALL
    USING (auth.user_role() = 'admin');

-- Compliance frameworks - everyone can read
CREATE POLICY compliance_frameworks_select ON compliance_frameworks
    FOR SELECT
    USING (TRUE);

CREATE POLICY compliance_frameworks_modify ON compliance_frameworks
    FOR ALL
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- CONFIG TABLES
-- ============================================================================

/*
-- Config definitions - everyone can read
CREATE POLICY config_definitions_select ON config_definitions
    FOR SELECT
    USING (TRUE);

CREATE POLICY config_definitions_modify ON config_definitions
    FOR ALL
    USING (auth.user_role() = 'admin');

-- Config values - filtered by program access
CREATE POLICY config_values_select ON config_values
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR (program_id IS NOT NULL AND has_program_access(program_id))
        OR (clinic_id IS NOT NULL AND clinic_id IN (
            SELECT clinic_id FROM clinics WHERE has_program_access(program_id)
        ))
        OR (location_id IS NOT NULL AND location_id IN (
            SELECT l.location_id FROM locations l
            JOIN clinics c ON l.clinic_id = c.clinic_id
            WHERE has_program_access(c.program_id)
        ))
    );

-- Sensitive config values hidden from non-admins
CREATE POLICY config_values_sensitive ON config_values
    FOR SELECT
    USING (
        auth.user_role() = 'admin'
        OR config_key NOT IN (
            SELECT config_key FROM config_definitions WHERE is_sensitive = TRUE
        )
    );

CREATE POLICY config_values_modify ON config_values
    FOR ALL
    USING (
        auth.user_role() = 'admin'
        OR (program_id IS NOT NULL AND has_program_access(program_id))
    );
*/


-- ============================================================================
-- ROADMAP TABLES
-- ============================================================================

/*
-- Roadmap projects - visible to authenticated users
CREATE POLICY roadmap_projects_select ON roadmap_projects
    FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY roadmap_projects_modify ON roadmap_projects
    FOR ALL
    USING (auth.user_role() IN ('admin', 'manager'));

-- Roadmap dependencies
CREATE POLICY roadmap_dependencies_select ON roadmap_dependencies
    FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY roadmap_dependencies_modify ON roadmap_dependencies
    FOR ALL
    USING (auth.user_role() IN ('admin', 'manager'));

-- Roadmap holidays - everyone can read
CREATE POLICY roadmap_holidays_select ON roadmap_holidays
    FOR SELECT
    USING (TRUE);

CREATE POLICY roadmap_holidays_modify ON roadmap_holidays
    FOR ALL
    USING (auth.user_role() = 'admin');

-- Roadmap config - everyone can read
CREATE POLICY roadmap_config_select ON roadmap_config
    FOR SELECT
    USING (TRUE);

CREATE POLICY roadmap_config_modify ON roadmap_config
    FOR ALL
    USING (auth.user_role() = 'admin');
*/


-- ============================================================================
-- ENABLE RLS ON ALL TABLES (Already done in 001_schema.sql)
-- ============================================================================
-- These statements are included for reference and to ensure RLS is enabled
-- if running this file independently.
-- ============================================================================

/*
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE program_relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinics ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE provider_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE config_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE config_values ENABLE ROW LEVEL SECURITY;
ALTER TABLE config_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointment_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE requirements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE story_reference ENABLE ROW LEVEL SECURITY;
ALTER TABLE story_compliance_vetting ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_frameworks ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_test_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_gaps ENABLE ROW LEVEL SECURITY;
ALTER TABLE uat_cycles ENABLE ROW LEVEL SECURITY;
ALTER TABLE uat_test_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE uat_test_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE uat_workflow_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE pre_uat_gate_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE traceability ENABLE ROW LEVEL SECURITY;
ALTER TABLE import_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_training ENABLE ROW LEVEL SECURITY;
ALTER TABLE role_conflicts ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_dependencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE roadmap_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE roadmap_project_clinics ENABLE ROW LEVEL SECURITY;
ALTER TABLE roadmap_dependencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE roadmap_holidays ENABLE ROW LEVEL SECURITY;
ALTER TABLE roadmap_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE roadmap_activity_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE priority_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE story_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_types ENABLE ROW LEVEL SECURITY;
*/


-- ============================================================================
-- TESTING RLS POLICIES
-- ============================================================================
-- Use these queries to test RLS policies after enabling them.
-- Run as different users to verify access control.
-- ============================================================================

/*
-- Test as a specific user
SET LOCAL request.jwt.claims = '{"sub": "user_123", "role": "user", "program_access": ["PROP"]}';

-- Should only see PROP program data
SELECT * FROM programs;
SELECT * FROM v_program_summary;

-- Reset
RESET request.jwt.claims;

-- Test as admin
SET LOCAL request.jwt.claims = '{"sub": "admin_001", "role": "admin"}';

-- Should see all data
SELECT * FROM programs;

RESET request.jwt.claims;
*/


-- ============================================================================
-- NOTES FOR IMPLEMENTATION
-- ============================================================================
/*

1. AUTHENTICATION SETUP:
   - Configure Supabase Auth with your preferred providers (email, Google, SAML, etc.)
   - Set up custom claims in JWT for role and program_access
   - Consider using Supabase Edge Functions for complex access logic

2. ROLE HIERARCHY (suggested):
   - admin: Full access to all data and operations
   - manager: Program-level admin, can manage clinics and users
   - qa_lead: Can manage test cases and cycles
   - tester: Can execute tests and update results
   - user: Read-only access to assigned programs
   - public: Limited access (onboarding form submissions)

3. PERFORMANCE CONSIDERATIONS:
   - The has_program_access() function uses SECURITY DEFINER to avoid RLS recursion
   - Consider caching program access in JWT claims for frequently accessed data
   - Use partial indexes on status columns to speed up filtered queries

4. AUDIT TRAIL:
   - Consider creating triggers to automatically log changes to audit_history
   - The audit_history table is append-only by design
   - Service role operations should still log to audit_history

5. TESTING:
   - Always test RLS policies in a development environment first
   - Use the SET LOCAL request.jwt.claims command to simulate different users
   - Verify both positive (can access) and negative (cannot access) cases

6. MIGRATION FROM SQLITE:
   - RLS is a PostgreSQL feature not available in SQLite
   - Existing data should work with RLS enabled
   - Test access patterns before going live

*/

-- ============================================================================
-- END OF RLS POLICIES
-- ============================================================================
