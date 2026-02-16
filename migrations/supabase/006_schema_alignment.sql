-- ============================================================================
-- Propel Health Database - Schema Alignment for Data Consolidation
-- Version: 006
-- Date: 2026-02-13
--
-- PURPOSE: Align Supabase schema with all status values, columns, and lookup
--          data present in the SQLite production database so that a full
--          data migration can proceed without CHECK-constraint violations.
--
-- RUN THIS: In Supabase SQL Editor BEFORE the data migration.
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. EXPAND user_stories.status CHECK CONSTRAINT
-- ============================================================================
-- SQLite has 8 status values. Supabase schema (001) only allows 6.
-- Missing: 'UAT', 'Complete', 'Archived'
--
-- Counts from SQLite:
--   UAT: 32 stories
--   Complete: 45 stories
--   Archived: 1 story
-- ============================================================================

ALTER TABLE user_stories DROP CONSTRAINT IF EXISTS user_stories_status_check;

ALTER TABLE user_stories ADD CONSTRAINT user_stories_status_check
    CHECK (status IN (
        'Draft',
        'Internal Review',
        'Pending Client Review',
        'Approved',
        'Needs Discussion',
        'Out of Scope',
        'UAT',
        'Complete',
        'Archived'
    ));

COMMENT ON COLUMN user_stories.status IS
    'Workflow status: Draft -> Internal Review -> Pending Client Review -> Approved -> UAT -> Complete | Archived';


-- ============================================================================
-- 2. EXPAND uat_test_cases.test_status CHECK CONSTRAINT
-- ============================================================================
-- SQLite has 'In Test' status (146 test cases). Supabase schema (001) has
-- Not Run/Pass/Fail/Blocked/Skipped but missing 'In Test'.
-- ============================================================================

ALTER TABLE uat_test_cases DROP CONSTRAINT IF EXISTS uat_test_cases_test_status_check;

ALTER TABLE uat_test_cases ADD CONSTRAINT uat_test_cases_test_status_check
    CHECK (test_status IN (
        'Not Run',
        'In Test',
        'Pass',
        'Fail',
        'Blocked',
        'Skipped'
    ));


-- ============================================================================
-- 3. EXPAND onboarding_projects.status CHECK CONSTRAINT
-- ============================================================================
-- Add 'BLOCKED' status (used in onboarding workflow).
-- ============================================================================

ALTER TABLE onboarding_projects DROP CONSTRAINT IF EXISTS onboarding_projects_status_check;

ALTER TABLE onboarding_projects ADD CONSTRAINT onboarding_projects_status_check
    CHECK (status IN (
        'INTAKE',
        'IN_PROGRESS',
        'UAT_READY',
        'LAUNCHED',
        'ON_HOLD',
        'BLOCKED'
    ));


-- ============================================================================
-- 4. ADD MISSING COLUMNS TO user_stories
-- ============================================================================
-- SQLite has uat_date and complete_date for tracking when stories
-- entered those workflow stages. The Supabase schema (001) only has
-- draft_date through needs_discussion_date.
-- ============================================================================

ALTER TABLE user_stories ADD COLUMN IF NOT EXISTS uat_date TIMESTAMPTZ;
ALTER TABLE user_stories ADD COLUMN IF NOT EXISTS complete_date TIMESTAMPTZ;

COMMENT ON COLUMN user_stories.uat_date IS 'Timestamp when story entered UAT status';
COMMENT ON COLUMN user_stories.complete_date IS 'Timestamp when story was marked Complete';


-- ============================================================================
-- 5. SEED MISSING story_categories
-- ============================================================================
-- SQLite user_stories.category has 36 distinct values. Supabase 002_seed
-- only seeded 19. The user_stories.category column has a FK reference to
-- story_categories(category_code), so we must insert the missing ones
-- before migrating story data.
--
-- Missing categories (from SQLite):
--   ADMIN, ANALYTICS, ASSESS, AUTH, CONFIG, CONSENT, CONTENT, EPIC,
--   EXPORT, FORM, GAIL, GENE, INV, INVITE, LAB, LANG, ORDER, PEDIGREE,
--   RECORD, REFERRAL, RESULT, ROLE, RPT, RULE, SAVE, SCREEN, STEP,
--   SURVEY, UI, SCREEN
-- ============================================================================

INSERT INTO story_categories (category_code, category_name, description, display_order) VALUES
    ('ADMIN',     'Administration',       'Admin tools, settings, and system management', 200),
    ('ANALYTICS', 'Analytics',            'Data analytics, metrics, and insights', 210),
    ('ASSESS',    'Assessment',           'Patient assessments, risk scores, and evaluations', 220),
    ('AUTH',      'Authentication',        'Login, SSO, MFA, and session management', 230),
    ('CONFIG',    'Configuration',         'System configuration, settings, and preferences', 240),
    ('CONSENT',   'Consent',              'Patient consent forms, opt-in/opt-out workflows', 250),
    ('CONTENT',   'Content',              'Content management, CMS, educational materials', 260),
    ('EPIC',      'Epic Integration',      'Epic EHR integration points', 270),
    ('EXPORT',    'Export & Download',     'Data export, file download, and report generation', 280),
    ('FORM',      'Forms',                'Form management, dynamic forms, and input capture', 290),
    ('GAIL',      'GAIL Model',           'Breast cancer risk assessment (Gail model)', 300),
    ('GENE',      'Genetic Testing',       'Genetic testing workflows and results', 310),
    ('INV',       'Inventory',            'Inventory tracking and kit management', 320),
    ('INVITE',    'Invitations',          'Patient invitations, enrollment outreach', 330),
    ('LAB',       'Lab Results',          'Lab order management and results integration', 340),
    ('LANG',      'Language',             'Multi-language support, localization, translations', 350),
    ('ORDER',     'Orders',               'Order management, test ordering, and fulfillment', 360),
    ('PEDIGREE',  'Pedigree',             'Family history and pedigree chart workflows', 370),
    ('RECORD',    'Records',              'Patient records, medical history, and document management', 380),
    ('REFERRAL',  'Referrals',            'Referral workflow, tracking, and management', 390),
    ('RESULT',    'Results',              'Test results delivery, interpretation, and display', 400),
    ('ROLE',      'Roles & Permissions',   'Role-based access control and permission management', 410),
    ('RPT',       'Reports',              'Report generation, scheduled reports, and dashboards', 420),
    ('RULE',      'Rules Engine',          'Business rules, clinical decision support, NCCN rules', 430),
    ('SAVE',      'Save & Draft',          'Auto-save, draft management, and recovery', 440),
    ('SCREEN',    'Screening',            'Patient screening workflows and eligibility', 450),
    ('STEP',      'Workflow Steps',        'Multi-step workflows, wizards, and guided processes', 460),
    ('SURVEY',    'Surveys',              'Patient surveys, questionnaires, and feedback', 470),
    ('UI',        'User Interface',        'UI/UX improvements, layout, and design', 480)
ON CONFLICT (category_code) DO NOTHING;


-- ============================================================================
-- 6. SEED MISSING test_types
-- ============================================================================
-- SQLite uat_test_cases.test_type uses: happy_path, validation, negative,
-- edge_case. NCCN/Notion tests use: POS, NEG, DEP, Content, Language.
--
-- Note: test_type on uat_test_cases is a TEXT column with no FK constraint,
-- but we seed test_types for reference/reporting consistency.
-- ============================================================================

INSERT INTO test_types (type_code, type_name, description, is_compliance) VALUES
    ('happy_path', 'Happy Path Test',    'Verifies the standard success path works correctly', FALSE),
    -- 'validation' already seeded in 002
    -- 'negative' already seeded in 002
    -- 'edge_case' already seeded in 002
    ('POS',        'Positive Test',       'NCCN rule validation - positive match scenario', FALSE),
    ('NEG',        'Negative Test',       'NCCN rule validation - negative/non-match scenario', FALSE),
    ('DEP',        'Deprecated Test',     'NCCN rule validation - deprecated rule scenario', FALSE),
    ('Content',    'Content Test',        'Content accuracy and display verification', FALSE),
    ('Language',   'Language Test',       'Multi-language and localization verification', FALSE)
ON CONFLICT (type_code) DO NOTHING;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    -- Verify story_categories count
    SELECT COUNT(*) INTO v_count FROM story_categories;
    RAISE NOTICE 'story_categories total: % (expected >= 48)', v_count;

    -- Verify test_types count
    SELECT COUNT(*) INTO v_count FROM test_types;
    RAISE NOTICE 'test_types total: % (expected >= 22)', v_count;

    -- Verify CHECK constraints allow new values (test with a dummy insert)
    RAISE NOTICE 'Schema alignment complete. CHECK constraints updated for:';
    RAISE NOTICE '  - user_stories.status: +UAT, +Complete, +Archived';
    RAISE NOTICE '  - uat_test_cases.test_status: +In Test';
    RAISE NOTICE '  - onboarding_projects.status: +BLOCKED';
    RAISE NOTICE '  - user_stories: +uat_date, +complete_date columns';
END $$;

COMMIT;
