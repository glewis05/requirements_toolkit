-- ============================================================================
-- Propel Health Database - Views for Supabase (PostgreSQL)
-- Version: 1.0.0
-- Generated: 2026-01-20
--
-- This file creates views for common queries and dashboards.
-- Run this AFTER completing data migration (003_migrate_data.sql).
--
-- Views are organized by functional area:
--   1. Program/Client Summary Views
--   2. Story Workflow Views
--   3. Test Execution Views
--   4. Compliance Views
--   5. Onboarding Views
--   6. Access Management Views
-- ============================================================================

-- ============================================================================
-- SECTION 1: PROGRAM/CLIENT SUMMARY VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_program_summary
-- PURPOSE: Dashboard-ready summary of each program's status
-- ORIGINAL: Updated from SQLite version with improved aggregations
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_program_summary AS
SELECT
    p.program_id,
    p.name AS program_name,
    p.prefix,
    p.status AS program_status,
    c.client_id,
    c.name AS client_name,

    -- Requirement counts
    COALESCE(req.total_requirements, 0) AS total_requirements,

    -- Story counts by status
    COALESCE(st.total_stories, 0) AS total_stories,
    COALESCE(st.draft_stories, 0) AS draft_stories,
    COALESCE(st.approved_stories, 0) AS approved_stories,
    COALESCE(st.pending_review_stories, 0) AS pending_review_stories,
    COALESCE(st.needs_discussion_stories, 0) AS needs_discussion_stories,

    -- Test counts by status
    COALESCE(tc.total_tests, 0) AS total_tests,
    COALESCE(tc.passed_tests, 0) AS passed_tests,
    COALESCE(tc.failed_tests, 0) AS failed_tests,
    COALESCE(tc.blocked_tests, 0) AS blocked_tests,
    COALESCE(tc.not_run_tests, 0) AS not_run_tests,

    -- Coverage percentage
    CASE
        WHEN COALESCE(st.total_stories, 0) > 0
        THEN ROUND((COALESCE(tc.total_tests, 0)::NUMERIC / st.total_stories) * 100, 1)
        ELSE 0
    END AS test_coverage_pct,

    -- Pass rate (of executed tests)
    CASE
        WHEN (COALESCE(tc.passed_tests, 0) + COALESCE(tc.failed_tests, 0)) > 0
        THEN ROUND(
            (COALESCE(tc.passed_tests, 0)::NUMERIC /
            (COALESCE(tc.passed_tests, 0) + COALESCE(tc.failed_tests, 0))) * 100, 1)
        ELSE NULL
    END AS test_pass_rate,

    -- Compliance gap counts
    COALESCE(cg.open_gaps, 0) AS open_compliance_gaps,
    COALESCE(cg.critical_gaps, 0) AS critical_compliance_gaps,

    -- Timestamps
    p.created_at,
    p.updated_at

FROM programs p
LEFT JOIN clients c ON p.client_id = c.client_id

-- Requirement counts
LEFT JOIN (
    SELECT program_id, COUNT(*) AS total_requirements
    FROM requirements
    GROUP BY program_id
) req ON p.program_id = req.program_id

-- Story counts
LEFT JOIN (
    SELECT
        program_id,
        COUNT(*) AS total_stories,
        COUNT(*) FILTER (WHERE status = 'Draft') AS draft_stories,
        COUNT(*) FILTER (WHERE status = 'Approved') AS approved_stories,
        COUNT(*) FILTER (WHERE status = 'Pending Client Review') AS pending_review_stories,
        COUNT(*) FILTER (WHERE status = 'Needs Discussion') AS needs_discussion_stories
    FROM user_stories
    GROUP BY program_id
) st ON p.program_id = st.program_id

-- Test counts
LEFT JOIN (
    SELECT
        program_id,
        COUNT(*) AS total_tests,
        COUNT(*) FILTER (WHERE test_status = 'Pass') AS passed_tests,
        COUNT(*) FILTER (WHERE test_status = 'Fail') AS failed_tests,
        COUNT(*) FILTER (WHERE test_status = 'Blocked') AS blocked_tests,
        COUNT(*) FILTER (WHERE test_status = 'Not Run') AS not_run_tests
    FROM uat_test_cases
    GROUP BY program_id
) tc ON p.program_id = tc.program_id

-- Compliance gap counts
LEFT JOIN (
    SELECT
        program_id,
        COUNT(*) FILTER (WHERE status IN ('Open', 'In Progress')) AS open_gaps,
        COUNT(*) FILTER (WHERE status IN ('Open', 'In Progress') AND severity = 'Critical') AS critical_gaps
    FROM compliance_gaps
    GROUP BY program_id
) cg ON p.program_id = cg.program_id;

COMMENT ON VIEW v_program_summary IS 'Dashboard summary of program status with story, test, and compliance counts';


-- ----------------------------------------------------------------------------
-- View: v_client_program_tree
-- PURPOSE: Hierarchical view of clients and their programs
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_client_program_tree AS
SELECT
    c.client_id,
    c.name AS client_name,
    c.short_name AS client_short_name,
    c.status AS client_status,
    p.program_id,
    p.name AS program_name,
    p.prefix AS program_prefix,
    p.program_type,
    p.status AS program_status,
    (SELECT COUNT(*) FROM clinics cl WHERE cl.program_id = p.program_id) AS clinic_count,
    (SELECT COUNT(*) FROM user_stories us WHERE us.program_id = p.program_id) AS story_count
FROM clients c
LEFT JOIN programs p ON c.client_id = p.client_id
ORDER BY c.name, p.name;

COMMENT ON VIEW v_client_program_tree IS 'Hierarchical listing of clients with their programs';


-- ============================================================================
-- SECTION 2: STORY WORKFLOW VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_story_workflow
-- PURPOSE: Story status with test case counts for workflow tracking
-- ORIGINAL: Updated from SQLite version
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_story_workflow AS
SELECT
    us.story_id,
    us.title,
    us.status,
    us.priority,
    us.category,
    us.is_technical,
    us.program_id,
    p.name AS program_name,
    p.prefix AS program_prefix,

    -- Workflow timestamps
    us.draft_date,
    us.internal_review_date,
    us.client_review_date,
    us.approved_at,
    us.approved_by,

    -- Test case counts
    COALESCE(tc.total_tests, 0) AS total_tests,
    COALESCE(tc.passed_tests, 0) AS passed_tests,
    COALESCE(tc.failed_tests, 0) AS failed_tests,
    COALESCE(tc.not_run_tests, 0) AS not_run_tests,

    -- Calculated fields
    CASE
        WHEN COALESCE(tc.total_tests, 0) = 0 THEN 'No Tests'
        WHEN COALESCE(tc.failed_tests, 0) > 0 THEN 'Has Failures'
        WHEN COALESCE(tc.not_run_tests, 0) > 0 THEN 'Tests Pending'
        ELSE 'All Passed'
    END AS test_summary,

    -- Days in current status
    CASE
        WHEN us.status = 'Draft' THEN EXTRACT(DAY FROM NOW() - COALESCE(us.draft_date, us.created_at))
        WHEN us.status = 'Internal Review' THEN EXTRACT(DAY FROM NOW() - us.internal_review_date)
        WHEN us.status = 'Pending Client Review' THEN EXTRACT(DAY FROM NOW() - us.client_review_date)
        WHEN us.status = 'Needs Discussion' THEN EXTRACT(DAY FROM NOW() - us.needs_discussion_date)
        ELSE NULL
    END AS days_in_status,

    us.created_at,
    us.updated_at

FROM user_stories us
JOIN programs p ON us.program_id = p.program_id
LEFT JOIN (
    SELECT
        story_id,
        COUNT(*) AS total_tests,
        COUNT(*) FILTER (WHERE test_status = 'Pass') AS passed_tests,
        COUNT(*) FILTER (WHERE test_status = 'Fail') AS failed_tests,
        COUNT(*) FILTER (WHERE test_status = 'Not Run') AS not_run_tests
    FROM uat_test_cases
    WHERE story_id IS NOT NULL
    GROUP BY story_id
) tc ON us.story_id = tc.story_id;

COMMENT ON VIEW v_story_workflow IS 'Story workflow status with test case summaries and time tracking';


-- ----------------------------------------------------------------------------
-- View: v_stories_needing_attention
-- PURPOSE: Stories that need action (stuck, no tests, or failing)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_stories_needing_attention AS
SELECT
    *,
    CASE
        WHEN days_in_status > 14 AND status IN ('Pending Client Review', 'Needs Discussion') THEN 'Stale - needs follow-up'
        WHEN days_in_status > 7 AND status = 'Draft' THEN 'Draft lingering'
        WHEN total_tests = 0 AND status = 'Approved' AND is_technical THEN 'Approved but no tests'
        WHEN failed_tests > 0 THEN 'Has failing tests'
        ELSE 'OK'
    END AS attention_reason
FROM v_story_workflow
WHERE
    (days_in_status > 14 AND status IN ('Pending Client Review', 'Needs Discussion'))
    OR (days_in_status > 7 AND status = 'Draft')
    OR (total_tests = 0 AND status = 'Approved' AND is_technical)
    OR failed_tests > 0
ORDER BY
    CASE
        WHEN failed_tests > 0 THEN 1
        WHEN total_tests = 0 AND status = 'Approved' THEN 2
        WHEN days_in_status > 14 THEN 3
        ELSE 4
    END,
    days_in_status DESC NULLS LAST;

COMMENT ON VIEW v_stories_needing_attention IS 'Stories requiring action due to status, testing, or age';


-- ============================================================================
-- SECTION 3: TEST EXECUTION VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_test_execution
-- PURPOSE: Test status counts by type for execution dashboards
-- ORIGINAL: Updated from SQLite version
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_test_execution AS
SELECT
    tc.program_id,
    p.name AS program_name,
    tc.uat_cycle_id,
    uc.name AS cycle_name,
    tc.test_type,
    COUNT(*) AS total_tests,
    COUNT(*) FILTER (WHERE tc.test_status = 'Pass') AS passed,
    COUNT(*) FILTER (WHERE tc.test_status = 'Fail') AS failed,
    COUNT(*) FILTER (WHERE tc.test_status = 'Blocked') AS blocked,
    COUNT(*) FILTER (WHERE tc.test_status = 'Skipped') AS skipped,
    COUNT(*) FILTER (WHERE tc.test_status = 'Not Run') AS not_run,
    -- Pass rate calculation
    ROUND(
        COUNT(*) FILTER (WHERE tc.test_status = 'Pass')::NUMERIC /
        NULLIF(COUNT(*) FILTER (WHERE tc.test_status IN ('Pass', 'Fail')), 0) * 100,
        1
    ) AS pass_rate,
    -- Execution progress
    ROUND(
        COUNT(*) FILTER (WHERE tc.test_status != 'Not Run')::NUMERIC /
        NULLIF(COUNT(*), 0) * 100,
        1
    ) AS execution_progress
FROM uat_test_cases tc
JOIN programs p ON tc.program_id = p.program_id
LEFT JOIN uat_cycles uc ON tc.uat_cycle_id = uc.cycle_id
GROUP BY tc.program_id, p.name, tc.uat_cycle_id, uc.name, tc.test_type;

COMMENT ON VIEW v_test_execution IS 'Test execution statistics by program, cycle, and test type';


-- ----------------------------------------------------------------------------
-- View: v_test_execution_by_workflow
-- PURPOSE: Test execution organized by workflow section
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_test_execution_by_workflow AS
SELECT
    tc.uat_cycle_id,
    uc.name AS cycle_name,
    ws.section_code,
    ws.section_name,
    ws.display_order,
    COUNT(*) AS total_tests,
    COUNT(*) FILTER (WHERE tc.test_status = 'Pass') AS passed,
    COUNT(*) FILTER (WHERE tc.test_status = 'Fail') AS failed,
    COUNT(*) FILTER (WHERE tc.test_status = 'Blocked') AS blocked,
    COUNT(*) FILTER (WHERE tc.test_status = 'Not Run') AS not_run,
    ROUND(
        COUNT(*) FILTER (WHERE tc.test_status != 'Not Run')::NUMERIC /
        NULLIF(COUNT(*), 0) * 100,
        1
    ) AS section_progress
FROM uat_test_cases tc
LEFT JOIN uat_cycles uc ON tc.uat_cycle_id = uc.cycle_id
LEFT JOIN uat_workflow_sections ws ON tc.workflow_section = ws.section_code
WHERE tc.uat_cycle_id IS NOT NULL
GROUP BY tc.uat_cycle_id, uc.name, ws.section_code, ws.section_name, ws.display_order
ORDER BY tc.uat_cycle_id, ws.display_order;

COMMENT ON VIEW v_test_execution_by_workflow IS 'Test execution progress by workflow section';


-- ----------------------------------------------------------------------------
-- View: v_test_assignments_summary
-- PURPOSE: Summary of test assignments by tester
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_test_assignments_summary AS
SELECT
    ta.cycle_id,
    uc.name AS cycle_name,
    ta.assigned_to,
    COUNT(*) AS total_assigned,
    COUNT(*) FILTER (WHERE tc.test_status = 'Pass') AS passed,
    COUNT(*) FILTER (WHERE tc.test_status = 'Fail') AS failed,
    COUNT(*) FILTER (WHERE tc.test_status = 'Blocked') AS blocked,
    COUNT(*) FILTER (WHERE tc.test_status = 'Not Run') AS not_run,
    ROUND(
        COUNT(*) FILTER (WHERE tc.test_status != 'Not Run')::NUMERIC /
        NULLIF(COUNT(*), 0) * 100,
        1
    ) AS completion_pct
FROM uat_test_assignments ta
JOIN uat_cycles uc ON ta.cycle_id = uc.cycle_id
JOIN uat_test_cases tc ON ta.test_id = tc.test_id
GROUP BY ta.cycle_id, uc.name, ta.assigned_to
ORDER BY ta.cycle_id, ta.assigned_to;

COMMENT ON VIEW v_test_assignments_summary IS 'Test execution progress by assigned tester';


-- ============================================================================
-- SECTION 4: COMPLIANCE VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_compliance_dashboard
-- PURPOSE: Gap counts by framework and severity for compliance tracking
-- ORIGINAL: Updated from SQLite version
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_compliance_dashboard AS
SELECT
    cg.program_id,
    p.name AS program_name,
    cg.framework,
    cf.framework_name,
    cf.full_name AS framework_full_name,
    cg.severity,
    cg.status AS gap_status,
    COUNT(*) AS gap_count
FROM compliance_gaps cg
JOIN programs p ON cg.program_id = p.program_id
JOIN compliance_frameworks cf ON cg.framework = cf.framework_id
GROUP BY
    cg.program_id, p.name,
    cg.framework, cf.framework_name, cf.full_name,
    cg.severity, cg.status
ORDER BY
    p.name,
    cg.framework,
    CASE cg.severity WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 ELSE 4 END,
    CASE cg.status WHEN 'Open' THEN 1 WHEN 'In Progress' THEN 2 ELSE 3 END;

COMMENT ON VIEW v_compliance_dashboard IS 'Compliance gap summary by framework and severity';


-- ----------------------------------------------------------------------------
-- View: v_compliance_by_story
-- PURPOSE: Compliance vetting status for each story
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_compliance_by_story AS
SELECT
    us.story_id,
    us.title AS story_title,
    us.status AS story_status,
    us.program_id,
    p.name AS program_name,
    cf.framework_id,
    cf.framework_name,
    scv.applies,
    scv.rationale,
    scv.test_cases_required,
    scv.test_cases_created,
    CASE
        WHEN scv.vetting_id IS NULL THEN 'Not Vetted'
        WHEN scv.applies = FALSE THEN 'Does Not Apply'
        WHEN scv.test_cases_created >= scv.test_cases_required THEN 'Complete'
        WHEN scv.test_cases_created > 0 THEN 'In Progress'
        ELSE 'Needs Tests'
    END AS compliance_status,
    scv.vetted_by,
    scv.vetted_at
FROM user_stories us
JOIN programs p ON us.program_id = p.program_id
CROSS JOIN compliance_frameworks cf
LEFT JOIN story_compliance_vetting scv
    ON us.story_id = scv.story_id
    AND cf.framework_id = scv.framework_id
WHERE cf.is_active = TRUE
ORDER BY us.story_id, cf.framework_id;

COMMENT ON VIEW v_compliance_by_story IS 'Compliance vetting status for each story across all active frameworks';


-- ============================================================================
-- SECTION 5: ONBOARDING VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_onboarding_status
-- PURPOSE: Current status of all onboarding projects
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_onboarding_status AS
SELECT
    op.project_id,
    op.project_name,
    op.clinic_name,
    op.status,
    op.target_launch_date,
    op.actual_launch_date,
    op.propel_lead,
    op.client_contact_name,
    p.program_id,
    p.name AS program_name,
    c.name AS client_name,

    -- Milestone progress
    COALESCE(m.total_milestones, 0) AS total_milestones,
    COALESCE(m.completed_milestones, 0) AS completed_milestones,
    COALESCE(m.blocked_milestones, 0) AS blocked_milestones,
    ROUND(
        COALESCE(m.completed_milestones, 0)::NUMERIC /
        NULLIF(COALESCE(m.total_milestones, 0), 0) * 100,
        1
    ) AS milestone_progress_pct,

    -- Dependency status
    COALESCE(d.total_dependencies, 0) AS total_dependencies,
    COALESCE(d.pending_dependencies, 0) AS pending_dependencies,
    COALESCE(d.resolved_dependencies, 0) AS resolved_dependencies,

    -- Days to launch
    op.target_launch_date - CURRENT_DATE AS days_to_launch,

    -- Risk indicator
    CASE
        WHEN op.status = 'ON_HOLD' THEN 'On Hold'
        WHEN COALESCE(m.blocked_milestones, 0) > 0 THEN 'Blocked'
        WHEN op.target_launch_date < CURRENT_DATE AND op.actual_launch_date IS NULL THEN 'Overdue'
        WHEN op.target_launch_date - CURRENT_DATE < 14 AND COALESCE(m.completed_milestones, 0) < COALESCE(m.total_milestones, 0) THEN 'At Risk'
        ELSE 'On Track'
    END AS risk_status,

    op.created_at,
    op.updated_at

FROM onboarding_projects op
JOIN programs p ON op.program_id = p.program_id
LEFT JOIN clients c ON p.client_id = c.client_id

LEFT JOIN (
    SELECT
        project_id,
        COUNT(*) AS total_milestones,
        COUNT(*) FILTER (WHERE status = 'COMPLETE') AS completed_milestones,
        COUNT(*) FILTER (WHERE status = 'BLOCKED') AS blocked_milestones
    FROM onboarding_milestones
    GROUP BY project_id
) m ON op.project_id = m.project_id

LEFT JOIN (
    SELECT
        project_id,
        COUNT(*) AS total_dependencies,
        COUNT(*) FILTER (WHERE status = 'PENDING') AS pending_dependencies,
        COUNT(*) FILTER (WHERE status = 'RESOLVED') AS resolved_dependencies
    FROM onboarding_dependencies
    GROUP BY project_id
) d ON op.project_id = d.project_id;

COMMENT ON VIEW v_onboarding_status IS 'Onboarding project status with milestone and dependency progress';


-- ----------------------------------------------------------------------------
-- View: v_onboarding_submissions_pending
-- PURPOSE: Pending onboarding submissions needing review
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_onboarding_submissions_pending AS
SELECT
    os.submission_id,
    os.submitter_email,
    os.submitter_name,
    os.program_prefix,
    os.submission_status,
    os.current_step,
    os.submitted_at,
    os.created_at,
    EXTRACT(DAY FROM NOW() - os.submitted_at) AS days_since_submission,
    -- Extract key fields from form_data
    os.form_data->>'clinic_name' AS clinic_name,
    os.form_data->>'clinic_code' AS clinic_code,
    os.form_data->>'target_launch_date' AS target_launch_date
FROM onboarding_submissions os
WHERE os.submission_status IN ('submitted', 'reviewed')
ORDER BY os.submitted_at;

COMMENT ON VIEW v_onboarding_submissions_pending IS 'Onboarding submissions awaiting review or approval';


-- ============================================================================
-- SECTION 6: ACCESS MANAGEMENT VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_user_access_summary
-- PURPOSE: User access overview with expiration tracking
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_user_access_summary AS
SELECT
    u.user_id,
    u.name AS user_name,
    u.email,
    u.organization,
    u.is_business_associate,
    u.status AS user_status,

    -- Access counts
    COUNT(DISTINCT ua.access_id) FILTER (WHERE ua.status = 'Active') AS active_access_count,
    COUNT(DISTINCT ua.program_id) FILTER (WHERE ua.status = 'Active') AS programs_with_access,
    COUNT(DISTINCT ua.clinic_id) FILTER (WHERE ua.status = 'Active') AS clinics_with_access,

    -- Roles (aggregated)
    ARRAY_AGG(DISTINCT ua.role) FILTER (WHERE ua.status = 'Active') AS active_roles,

    -- Access review status
    MIN(ua.next_review_due) FILTER (WHERE ua.status = 'Active') AS next_review_due,
    CASE
        WHEN MIN(ua.next_review_due) FILTER (WHERE ua.status = 'Active') < CURRENT_DATE THEN 'Overdue'
        WHEN MIN(ua.next_review_due) FILTER (WHERE ua.status = 'Active') < CURRENT_DATE + INTERVAL '30 days' THEN 'Due Soon'
        ELSE 'Current'
    END AS review_status,

    -- Training status
    COUNT(DISTINCT ut.training_id) FILTER (WHERE ut.status = 'Pending') AS pending_trainings,
    COUNT(DISTINCT ut.training_id) FILTER (WHERE ut.status = 'Expired') AS expired_trainings

FROM users u
LEFT JOIN user_access ua ON u.user_id = ua.user_id
LEFT JOIN user_training ut ON u.user_id = ut.user_id
WHERE u.status != 'Terminated'
GROUP BY u.user_id, u.name, u.email, u.organization, u.is_business_associate, u.status;

COMMENT ON VIEW v_user_access_summary IS 'User access overview with review and training status';


-- ----------------------------------------------------------------------------
-- View: v_access_reviews_due
-- PURPOSE: Access records due for periodic review
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_access_reviews_due AS
SELECT
    ua.access_id,
    u.user_id,
    u.name AS user_name,
    u.email,
    u.organization,
    ua.role,
    ua.status AS access_status,
    ua.next_review_due,
    ua.granted_by,
    ua.granted_date,
    COALESCE(p.name, cl.name, l.name) AS resource_name,
    CASE
        WHEN ua.program_id IS NOT NULL THEN 'Program'
        WHEN ua.clinic_id IS NOT NULL THEN 'Clinic'
        WHEN ua.location_id IS NOT NULL THEN 'Location'
    END AS resource_type,
    CASE
        WHEN ua.next_review_due < CURRENT_DATE THEN 'Overdue'
        WHEN ua.next_review_due < CURRENT_DATE + INTERVAL '7 days' THEN 'Due This Week'
        WHEN ua.next_review_due < CURRENT_DATE + INTERVAL '30 days' THEN 'Due This Month'
        ELSE 'Upcoming'
    END AS urgency,
    CURRENT_DATE - ua.next_review_due AS days_overdue
FROM user_access ua
JOIN users u ON ua.user_id = u.user_id
LEFT JOIN programs p ON ua.program_id = p.program_id
LEFT JOIN clinics cl ON ua.clinic_id = cl.clinic_id
LEFT JOIN locations l ON ua.location_id = l.location_id
WHERE ua.status = 'Active'
  AND ua.next_review_due <= CURRENT_DATE + INTERVAL '30 days'
ORDER BY ua.next_review_due;

COMMENT ON VIEW v_access_reviews_due IS 'Access records requiring periodic review';


-- ----------------------------------------------------------------------------
-- View: v_role_conflict_check
-- PURPOSE: Detect users with potentially conflicting role assignments
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_role_conflict_check AS
SELECT
    u.user_id,
    u.name AS user_name,
    u.email,
    ua1.role AS role_a,
    ua2.role AS role_b,
    rc.severity,
    rc.description AS conflict_description,
    COALESCE(p1.name, cl1.name, l1.name) AS resource_a,
    COALESCE(p2.name, cl2.name, l2.name) AS resource_b
FROM users u
JOIN user_access ua1 ON u.user_id = ua1.user_id AND ua1.status = 'Active'
JOIN user_access ua2 ON u.user_id = ua2.user_id AND ua2.status = 'Active' AND ua1.access_id < ua2.access_id
JOIN role_conflicts rc ON
    (ua1.role = rc.role_a AND ua2.role = rc.role_b) OR
    (ua1.role = rc.role_b AND ua2.role = rc.role_a)
LEFT JOIN programs p1 ON ua1.program_id = p1.program_id
LEFT JOIN programs p2 ON ua2.program_id = p2.program_id
LEFT JOIN clinics cl1 ON ua1.clinic_id = cl1.clinic_id
LEFT JOIN clinics cl2 ON ua2.clinic_id = cl2.clinic_id
LEFT JOIN locations l1 ON ua1.location_id = l1.location_id
LEFT JOIN locations l2 ON ua2.location_id = l2.location_id
ORDER BY rc.severity DESC, u.name;

COMMENT ON VIEW v_role_conflict_check IS 'Detects users with potentially conflicting role assignments';


-- ============================================================================
-- SECTION 7: TRACEABILITY VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: v_requirements_traceability
-- PURPOSE: Full traceability from requirement through test execution
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_requirements_traceability AS
SELECT
    r.requirement_id,
    r.title AS requirement_title,
    r.requirement_type,
    r.priority AS requirement_priority,
    r.program_id,
    p.name AS program_name,

    us.story_id,
    us.title AS story_title,
    us.status AS story_status,

    tc.test_id,
    tc.title AS test_title,
    tc.test_status,
    tc.tested_date,

    -- Coverage assessment
    CASE
        WHEN us.story_id IS NULL THEN 'No Story'
        WHEN tc.test_id IS NULL AND us.is_technical THEN 'No Tests'
        WHEN tc.test_status = 'Pass' THEN 'Covered & Passed'
        WHEN tc.test_status = 'Fail' THEN 'Covered - Failing'
        WHEN tc.test_status = 'Not Run' THEN 'Covered - Not Tested'
        ELSE 'Partial Coverage'
    END AS coverage_status

FROM requirements r
JOIN programs p ON r.program_id = p.program_id
LEFT JOIN user_stories us ON r.requirement_id = us.requirement_id
LEFT JOIN uat_test_cases tc ON us.story_id = tc.story_id
ORDER BY r.program_id, r.requirement_id, us.story_id, tc.test_id;

COMMENT ON VIEW v_requirements_traceability IS 'Full requirements traceability: requirement → story → test';


-- ----------------------------------------------------------------------------
-- View: v_coverage_gaps
-- PURPOSE: Identify requirements and stories without adequate test coverage
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_coverage_gaps AS
SELECT
    'Requirement' AS item_type,
    r.requirement_id AS item_id,
    r.title AS item_title,
    r.program_id,
    p.name AS program_name,
    'No user story' AS gap_reason
FROM requirements r
JOIN programs p ON r.program_id = p.program_id
LEFT JOIN user_stories us ON r.requirement_id = us.requirement_id
WHERE us.story_id IS NULL

UNION ALL

SELECT
    'Story' AS item_type,
    us.story_id AS item_id,
    us.title AS item_title,
    us.program_id,
    p.name AS program_name,
    'No test cases' AS gap_reason
FROM user_stories us
JOIN programs p ON us.program_id = p.program_id
LEFT JOIN uat_test_cases tc ON us.story_id = tc.story_id
WHERE tc.test_id IS NULL
  AND us.is_technical = TRUE
  AND us.status = 'Approved'

ORDER BY program_name, item_type, item_id;

COMMENT ON VIEW v_coverage_gaps IS 'Identifies requirements and stories lacking coverage';


-- ============================================================================
-- SECTION 8: HELPER FUNCTIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Function: get_program_health_score
-- PURPOSE: Calculate a health score (0-100) for a program
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_program_health_score(p_program_id TEXT)
RETURNS INTEGER AS $$
DECLARE
    v_score INTEGER := 100;
    v_approved_pct NUMERIC;
    v_test_coverage_pct NUMERIC;
    v_pass_rate NUMERIC;
    v_open_gaps INTEGER;
BEGIN
    -- Get metrics from v_program_summary
    SELECT
        CASE WHEN total_stories > 0 THEN (approved_stories::NUMERIC / total_stories * 100) ELSE 0 END,
        COALESCE(test_coverage_pct, 0),
        COALESCE(test_pass_rate, 100),
        COALESCE(open_compliance_gaps, 0)
    INTO v_approved_pct, v_test_coverage_pct, v_pass_rate, v_open_gaps
    FROM v_program_summary
    WHERE program_id = p_program_id;

    IF NOT FOUND THEN
        RETURN 0;
    END IF;

    -- Deduct for low approval rate
    IF v_approved_pct < 50 THEN
        v_score := v_score - 20;
    ELSIF v_approved_pct < 80 THEN
        v_score := v_score - 10;
    END IF;

    -- Deduct for low test coverage
    IF v_test_coverage_pct < 50 THEN
        v_score := v_score - 25;
    ELSIF v_test_coverage_pct < 80 THEN
        v_score := v_score - 10;
    END IF;

    -- Deduct for low pass rate
    IF v_pass_rate < 70 THEN
        v_score := v_score - 25;
    ELSIF v_pass_rate < 90 THEN
        v_score := v_score - 10;
    END IF;

    -- Deduct for open compliance gaps
    v_score := v_score - LEAST(v_open_gaps * 5, 20);

    RETURN GREATEST(v_score, 0);
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_program_health_score(TEXT) IS 'Calculate health score (0-100) for a program based on coverage and compliance';


-- ============================================================================
-- GRANT PERMISSIONS (For Supabase authenticated users)
-- ============================================================================
-- Note: Adjust these based on your RLS policies

GRANT SELECT ON v_program_summary TO authenticated;
GRANT SELECT ON v_client_program_tree TO authenticated;
GRANT SELECT ON v_story_workflow TO authenticated;
GRANT SELECT ON v_stories_needing_attention TO authenticated;
GRANT SELECT ON v_test_execution TO authenticated;
GRANT SELECT ON v_test_execution_by_workflow TO authenticated;
GRANT SELECT ON v_test_assignments_summary TO authenticated;
GRANT SELECT ON v_compliance_dashboard TO authenticated;
GRANT SELECT ON v_compliance_by_story TO authenticated;
GRANT SELECT ON v_onboarding_status TO authenticated;
GRANT SELECT ON v_onboarding_submissions_pending TO authenticated;
GRANT SELECT ON v_user_access_summary TO authenticated;
GRANT SELECT ON v_access_reviews_due TO authenticated;
GRANT SELECT ON v_role_conflict_check TO authenticated;
GRANT SELECT ON v_requirements_traceability TO authenticated;
GRANT SELECT ON v_coverage_gaps TO authenticated;

GRANT EXECUTE ON FUNCTION get_program_health_score(TEXT) TO authenticated;


-- ============================================================================
-- END OF VIEWS
-- ============================================================================
