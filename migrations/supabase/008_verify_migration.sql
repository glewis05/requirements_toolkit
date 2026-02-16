-- ============================================================================
-- Propel Health Database - Post-Migration Verification
-- Version: 008
-- Date: 2026-02-13
--
-- PURPOSE: Verify the data consolidation migration completed correctly.
--          Run this in Supabase SQL Editor AFTER the migration script.
--
-- CHECKS:
--   1. Row counts match expected values
--   2. FK integrity (no orphan records)
--   3. JSONB fields parsed correctly
--   4. Status values are valid (within CHECK constraints)
--   5. NCCN test cases reflect Notion data
-- ============================================================================

-- ============================================================================
-- 1. ROW COUNT CHECKS
-- ============================================================================

SELECT '=== ROW COUNT CHECKS ===' AS section;

SELECT
    'clients' AS table_name,
    COUNT(*) AS actual,
    6 AS expected,
    CASE WHEN COUNT(*) = 6 THEN 'OK' ELSE 'MISMATCH' END AS status
FROM clients

UNION ALL SELECT 'programs', COUNT(*), 12, CASE WHEN COUNT(*) = 12 THEN 'OK' ELSE 'MISMATCH' END FROM programs
UNION ALL SELECT 'user_stories', COUNT(*), 196, CASE WHEN COUNT(*) = 196 THEN 'OK' ELSE 'MISMATCH' END FROM user_stories
UNION ALL SELECT 'requirements', COUNT(*), 18, CASE WHEN COUNT(*) = 18 THEN 'OK' ELSE 'MISMATCH' END FROM requirements
UNION ALL SELECT 'uat_cycles', COUNT(*), 4, CASE WHEN COUNT(*) = 4 THEN 'OK' ELSE 'MISMATCH' END FROM uat_cycles
UNION ALL SELECT 'users', COUNT(*), 166, CASE WHEN COUNT(*) = 166 THEN 'OK' ELSE 'MISMATCH' END FROM users
UNION ALL SELECT 'audit_history', COUNT(*), 2750, CASE WHEN COUNT(*) = 2750 THEN 'OK' ELSE 'MISMATCH' END FROM audit_history
UNION ALL SELECT 'clinics', COUNT(*), 12, CASE WHEN COUNT(*) = 12 THEN 'OK' ELSE 'MISMATCH' END FROM clinics
UNION ALL SELECT 'locations', COUNT(*), 15, CASE WHEN COUNT(*) = 15 THEN 'OK' ELSE 'MISMATCH' END FROM locations
UNION ALL SELECT 'providers', COUNT(*), 10, CASE WHEN COUNT(*) = 10 THEN 'OK' ELSE 'MISMATCH' END FROM providers
UNION ALL SELECT 'config_definitions', COUNT(*), 42, CASE WHEN COUNT(*) = 42 THEN 'OK' ELSE 'MISMATCH' END FROM config_definitions
UNION ALL SELECT 'config_values', COUNT(*), 51, CASE WHEN COUNT(*) = 51 THEN 'OK' ELSE 'MISMATCH' END FROM config_values
UNION ALL SELECT 'traceability', COUNT(*), 8, CASE WHEN COUNT(*) = 8 THEN 'OK' ELSE 'MISMATCH' END FROM traceability
UNION ALL SELECT 'uat_test_assignments', COUNT(*), 92, CASE WHEN COUNT(*) = 92 THEN 'OK' ELSE 'MISMATCH' END FROM uat_test_assignments
UNION ALL SELECT 'onboarding_projects', COUNT(*), 1, CASE WHEN COUNT(*) = 1 THEN 'OK' ELSE 'MISMATCH' END FROM onboarding_projects
UNION ALL SELECT 'roadmap_projects', COUNT(*), 29, CASE WHEN COUNT(*) = 29 THEN 'OK' ELSE 'MISMATCH' END FROM roadmap_projects
UNION ALL SELECT 'story_compliance_vetting', COUNT(*), 136, CASE WHEN COUNT(*) = 136 THEN 'OK' ELSE 'MISMATCH' END FROM story_compliance_vetting
UNION ALL SELECT 'user_access', COUNT(*), 332, CASE WHEN COUNT(*) = 332 THEN 'OK' ELSE 'MISMATCH' END FROM user_access

ORDER BY table_name;


-- ============================================================================
-- 2. TEST CASE BREAKDOWN
-- ============================================================================
-- Expected: 417 SQLite + 204 NCCN (from Notion) + GRXP (when loaded)

SELECT '=== TEST CASE BREAKDOWN ===' AS section;

SELECT
    p.name AS program,
    p.prefix,
    COUNT(t.test_id) AS test_count
FROM programs p
LEFT JOIN uat_test_cases t ON p.program_id = t.program_id
GROUP BY p.program_id, p.name, p.prefix
HAVING COUNT(t.test_id) > 0
ORDER BY test_count DESC;

SELECT
    'uat_test_cases total' AS metric,
    COUNT(*) AS value
FROM uat_test_cases;


-- ============================================================================
-- 3. FK INTEGRITY CHECKS
-- ============================================================================

SELECT '=== FK INTEGRITY CHECKS ===' AS section;

-- Stories referencing non-existent programs
SELECT
    'orphan_stories (bad program_id)' AS check_name,
    COUNT(*) AS count,
    CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'FAIL' END AS status
FROM user_stories s
LEFT JOIN programs p ON s.program_id = p.program_id
WHERE p.program_id IS NULL

UNION ALL

-- Tests referencing non-existent stories
SELECT
    'orphan_tests (bad story_id)',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'WARNING' END
FROM uat_test_cases t
WHERE t.story_id IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM user_stories s WHERE s.story_id = t.story_id)

UNION ALL

-- Stories referencing non-existent categories
SELECT
    'orphan_stories (bad category)',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'FAIL' END
FROM user_stories s
WHERE s.category IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM story_categories c WHERE c.category_code = s.category)

UNION ALL

-- Tests referencing non-existent cycles
SELECT
    'orphan_tests (bad cycle_id)',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'WARNING' END
FROM uat_test_cases t
WHERE t.uat_cycle_id IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM uat_cycles c WHERE c.cycle_id = t.uat_cycle_id)

UNION ALL

-- Clinics referencing non-existent programs
SELECT
    'orphan_clinics (bad program_id)',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'FAIL' END
FROM clinics c
LEFT JOIN programs p ON c.program_id = p.program_id
WHERE p.program_id IS NULL;


-- ============================================================================
-- 4. STATUS VALUE VALIDATION
-- ============================================================================

SELECT '=== STATUS VALUE DISTRIBUTION ===' AS section;

-- Story status distribution
SELECT
    'user_stories.status' AS field,
    status AS value,
    COUNT(*) AS count
FROM user_stories
GROUP BY status
ORDER BY count DESC;

-- Test status distribution
SELECT
    'uat_test_cases.test_status' AS field,
    test_status AS value,
    COUNT(*) AS count
FROM uat_test_cases
GROUP BY test_status
ORDER BY count DESC;


-- ============================================================================
-- 5. JSONB FIELD SPOT-CHECKS
-- ============================================================================

SELECT '=== JSONB FIELD CHECKS ===' AS section;

-- Check related_stories is valid JSONB array
SELECT
    'stories with valid related_stories' AS check_name,
    COUNT(*) AS count,
    CASE
        WHEN COUNT(*) = (SELECT COUNT(*) FROM user_stories) THEN 'OK'
        ELSE 'SOME INVALID'
    END AS status
FROM user_stories
WHERE related_stories IS NULL
   OR jsonb_typeof(related_stories) = 'array';

-- Check flags is valid JSONB array
SELECT
    'stories with valid flags' AS check_name,
    COUNT(*) AS count,
    CASE
        WHEN COUNT(*) = (SELECT COUNT(*) FROM user_stories) THEN 'OK'
        ELSE 'SOME INVALID'
    END AS status
FROM user_stories
WHERE flags IS NULL
   OR jsonb_typeof(flags) = 'array';

-- Sample NCCN tests with patient_conditions
SELECT
    'NCCN tests with patient_conditions' AS check_name,
    COUNT(*) AS count
FROM uat_test_cases
WHERE program_id = 'e1061391-a8c8-4695-9c0e-f8e20dc64d47'
AND patient_conditions IS NOT NULL;


-- ============================================================================
-- 6. NCCN SPOT-CHECKS
-- ============================================================================

SELECT '=== NCCN SPOT-CHECKS ===' AS section;

-- Verify NCCN test count
SELECT
    'NCCN total tests' AS metric,
    COUNT(*) AS count
FROM uat_test_cases
WHERE program_id = 'e1061391-a8c8-4695-9c0e-f8e20dc64d47';

-- Sample 5 NCCN tests (to visually verify against Notion)
SELECT
    test_id,
    title,
    test_type,
    test_status,
    platform,
    target_rule
FROM uat_test_cases
WHERE program_id = 'e1061391-a8c8-4695-9c0e-f8e20dc64d47'
ORDER BY test_id
LIMIT 5;


-- ============================================================================
-- 7. DASHBOARD DATA CHECK
-- ============================================================================
-- Verify the data the dashboard needs is present

SELECT '=== DASHBOARD DATA CHECK ===' AS section;

-- Programs with stories (what the dashboard shows)
SELECT
    p.prefix,
    p.name,
    COUNT(s.story_id) AS story_count,
    SUM(CASE WHEN t.test_count > 0 THEN t.test_count ELSE 0 END) AS test_count
FROM programs p
JOIN user_stories s ON p.program_id = s.program_id
LEFT JOIN (
    SELECT story_id, COUNT(*) AS test_count
    FROM uat_test_cases
    WHERE is_compliance_test = FALSE OR is_compliance_test IS NULL
    GROUP BY story_id
) t ON s.story_id = t.story_id
WHERE p.prefix NOT IN ('TEST2', 'FRESH', 'IMPORT', 'P4ME')
GROUP BY p.prefix, p.name
ORDER BY story_count DESC;


-- ============================================================================
-- SUMMARY
-- ============================================================================

DO $$
DECLARE
    v_stories INTEGER;
    v_tests INTEGER;
    v_users INTEGER;
    v_programs INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_stories FROM user_stories;
    SELECT COUNT(*) INTO v_tests FROM uat_test_cases;
    SELECT COUNT(*) INTO v_users FROM users;
    SELECT COUNT(*) INTO v_programs FROM programs;

    RAISE NOTICE '';
    RAISE NOTICE '=== MIGRATION VERIFICATION SUMMARY ===';
    RAISE NOTICE 'Stories: %', v_stories;
    RAISE NOTICE 'Tests: %', v_tests;
    RAISE NOTICE 'Users: %', v_users;
    RAISE NOTICE 'Programs: %', v_programs;
    RAISE NOTICE '';

    IF v_stories = 196 AND v_users = 166 AND v_programs = 12 THEN
        RAISE NOTICE 'Core tables: PASS';
    ELSE
        RAISE WARNING 'Core tables: CHECK NEEDED';
    END IF;
END $$;
