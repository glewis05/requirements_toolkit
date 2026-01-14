-- ============================================================================
-- CLIENT PRODUCT DATABASE SCHEMA
-- ============================================================================
-- Purpose: Central repository for client programs, requirements, user stories,
--          UAT test cases, and compliance tracking
--
-- Database: client_product_database.db
--
-- This schema supports:
--   - Multi-client, multi-program organization
--   - Requirements lifecycle tracking
--   - User story development and approval workflow
--   - UAT test case management
--   - Compliance gap tracking (Part 11, HIPAA, SOC 2)
--   - Full audit history for regulatory purposes
--
-- AVIATION ANALOGY:
--   Think of this as your master flight operations database:
--   - Clients = Airlines
--   - Programs = Routes/Missions
--   - Requirements = Mission objectives
--   - User Stories = Flight plans
--   - Test Cases = Checklists
--   - Audit History = Flight recorder (black box)
--
-- ============================================================================


-- ============================================================================
-- CLIENTS TABLE
-- ============================================================================
-- Top-level organization. Each client can have multiple programs.
-- Example: "Discover Health", "NCCN", "GenoRx"

CREATE TABLE IF NOT EXISTS clients (
    client_id TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    primary_contact TEXT,
    contact_email TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'Active'  -- Active, Inactive, Archived
);


-- ============================================================================
-- PROGRAMS TABLE
-- ============================================================================
-- Programs/Projects under each client. Each program has a unique prefix.
-- Example: "Propel Analytics" with prefix "PROP"

CREATE TABLE IF NOT EXISTS programs (
    program_id TEXT PRIMARY KEY,
    client_id TEXT NOT NULL,
    name TEXT NOT NULL,
    prefix TEXT NOT NULL UNIQUE,  -- PROP, GRX, NCCN, DIS, etc.
    description TEXT,
    program_type TEXT,  -- Analytics, Consent, Integration, Reporting, etc.
    source_file TEXT,   -- Original requirements file
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'Active',  -- Active, Completed, On Hold, Archived
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);


-- ============================================================================
-- REQUIREMENTS TABLE
-- ============================================================================
-- Raw requirements parsed from source files.
-- Preserves original data for traceability back to source.

CREATE TABLE IF NOT EXISTS requirements (
    requirement_id TEXT PRIMARY KEY,
    program_id TEXT NOT NULL,
    source_file TEXT,
    source_row INTEGER,
    raw_text TEXT,           -- Original requirement text
    title TEXT,
    description TEXT,
    priority TEXT,           -- Critical, High, Medium, Low
    source_status TEXT,      -- From source: Planned, In Progress, Completed, etc.
    requirement_type TEXT,   -- Technical, Workflow, Process, Integration
    context_json TEXT,       -- Store all context columns as JSON
    import_batch TEXT,       -- Batch ID for tracking imports
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);


-- ============================================================================
-- USER STORIES TABLE
-- ============================================================================
-- User stories generated from requirements.
-- Tracks full lifecycle: Draft → Review → Approval

CREATE TABLE IF NOT EXISTS user_stories (
    story_id TEXT PRIMARY KEY,
    requirement_id TEXT,
    program_id TEXT NOT NULL,
    title TEXT NOT NULL,
    user_story TEXT,         -- As a... I want... so that...
    role TEXT,               -- User role (analyst, coordinator, admin, etc.)
    capability TEXT,         -- The "I want to..." part
    benefit TEXT,            -- The "so that..." part
    acceptance_criteria TEXT,  -- Multi-line text with bullet points
    success_metrics TEXT,
    priority TEXT,           -- Critical, High, Medium, Low
    category TEXT,           -- RECRUIT, DASH, MSG, WF, etc.
    category_full TEXT,      -- Full category name

    -- Workflow status
    status TEXT DEFAULT 'Draft',
    -- Status values: Draft, Internal Review, Pending Client Review,
    --                Approved, Needs Discussion, Out of Scope

    is_technical BOOLEAN DEFAULT TRUE,  -- False for workflow/process changes

    -- Review fields
    internal_notes TEXT,     -- Internal team comments
    meeting_context TEXT,    -- Decisions from meetings
    client_feedback TEXT,    -- Client signoff comments

    -- Relationships
    related_stories TEXT,    -- Comma-separated related story IDs
    parent_story_id TEXT,    -- For epic/child relationships

    -- Version tracking
    version INTEGER DEFAULT 1,

    -- Timestamps
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_date TIMESTAMP,
    approved_by TEXT,

    -- Flags (stored as comma-separated values)
    flags TEXT,

    FOREIGN KEY (requirement_id) REFERENCES requirements(requirement_id),
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);


-- ============================================================================
-- UAT TEST CASES TABLE
-- ============================================================================
-- UAT test cases derived from user stories.
-- Supports both functional tests and compliance tests.

CREATE TABLE IF NOT EXISTS uat_test_cases (
    test_id TEXT PRIMARY KEY,
    story_id TEXT,
    program_id TEXT NOT NULL,
    title TEXT NOT NULL,
    category TEXT,           -- AUTH, DATA, EXPORT, etc.
    test_type TEXT,          -- happy_path, validation, negative, edge_case
    prerequisites TEXT,      -- Pre-conditions for test
    test_steps TEXT,         -- Numbered steps (multi-line)
    expected_results TEXT,   -- Expected outcomes (Gherkin format)

    -- Priority and estimation
    priority TEXT,           -- MoSCoW: Must Have, Should Have, Could Have, Won't Have
    estimated_time TEXT,     -- Estimated execution time

    -- Compliance
    compliance_framework TEXT,  -- NULL, Part11, HIPAA, SOC2
    control_id TEXT,         -- Specific control being tested

    -- Execution tracking
    test_status TEXT DEFAULT 'Not Run',  -- Not Run, Pass, Fail, Blocked, Skipped
    tested_by TEXT,
    tested_date TIMESTAMP,
    execution_notes TEXT,

    -- Defect tracking
    defect_id TEXT,          -- Link to defect if failed
    defect_description TEXT,

    -- Metadata
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (story_id) REFERENCES user_stories(story_id),
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);


-- ============================================================================
-- TRACEABILITY TABLE
-- ============================================================================
-- Links requirements → stories → test cases for full traceability.
-- Required for regulatory compliance (FDA, etc.)

CREATE TABLE IF NOT EXISTS traceability (
    trace_id INTEGER PRIMARY KEY AUTOINCREMENT,
    program_id TEXT NOT NULL,
    requirement_id TEXT,
    story_id TEXT,
    test_id TEXT,
    coverage_status TEXT,    -- Full, Partial, None
    gap_notes TEXT,          -- What's missing
    compliance_coverage TEXT, -- Comma-separated: Part11, HIPAA, SOC2
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (program_id) REFERENCES programs(program_id),
    FOREIGN KEY (requirement_id) REFERENCES requirements(requirement_id),
    FOREIGN KEY (story_id) REFERENCES user_stories(story_id),
    FOREIGN KEY (test_id) REFERENCES uat_test_cases(test_id)
);


-- ============================================================================
-- COMPLIANCE GAPS TABLE
-- ============================================================================
-- Tracks identified compliance gaps and remediation status.

CREATE TABLE IF NOT EXISTS compliance_gaps (
    gap_id INTEGER PRIMARY KEY AUTOINCREMENT,
    requirement_id TEXT,
    story_id TEXT,
    program_id TEXT NOT NULL,

    -- Gap details
    framework TEXT NOT NULL,  -- Part11, HIPAA, SOC2
    control_id TEXT,          -- Specific control (e.g., 11.10(a))
    category TEXT,            -- audit_trail, access_control, etc.
    gap_description TEXT NOT NULL,
    recommendation TEXT,      -- Suggested fix

    -- Severity and status
    severity TEXT,            -- Critical, High, Medium, Low
    status TEXT DEFAULT 'Open',  -- Open, In Progress, Mitigated, Accepted, Closed

    -- Remediation tracking
    mitigation_plan TEXT,
    owner TEXT,               -- Person responsible
    due_date DATE,
    closed_date TIMESTAMP,

    -- Metadata
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (program_id) REFERENCES programs(program_id),
    FOREIGN KEY (requirement_id) REFERENCES requirements(requirement_id),
    FOREIGN KEY (story_id) REFERENCES user_stories(story_id)
);


-- ============================================================================
-- AUDIT HISTORY TABLE
-- ============================================================================
-- Complete change history for regulatory compliance.
-- Records every create, update, delete, and status change.
-- AVIATION ANALOGY: This is your flight recorder (black box).

CREATE TABLE IF NOT EXISTS audit_history (
    audit_id INTEGER PRIMARY KEY AUTOINCREMENT,

    -- What was changed
    record_type TEXT NOT NULL,  -- client, program, requirement, user_story,
                                -- test_case, compliance_gap, traceability
    record_id TEXT NOT NULL,

    -- Change details
    action TEXT NOT NULL,       -- Created, Updated, Deleted, Status Changed,
                                -- Approved, Imported, Exported
    field_changed TEXT,         -- Which field was modified
    old_value TEXT,            -- Previous value
    new_value TEXT,            -- New value

    -- Who and when
    changed_by TEXT DEFAULT 'system',
    changed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Why (for compliance)
    change_reason TEXT,        -- Justification for change

    -- Context
    session_id TEXT,           -- Group related changes
    ip_address TEXT
);


-- ============================================================================
-- STORY REFERENCE LIBRARY TABLE
-- ============================================================================
-- Stores high-quality approved stories as templates for future use.
-- Helps generate better stories by learning from past successes.

CREATE TABLE IF NOT EXISTS story_reference (
    reference_id INTEGER PRIMARY KEY AUTOINCREMENT,
    story_id TEXT NOT NULL,

    -- Classification
    category TEXT,             -- RECRUIT, DASH, MSG, etc.
    keywords TEXT,             -- Comma-separated keywords for matching
    industry TEXT,             -- Healthcare, Finance, etc.

    -- Quality metrics
    quality_score INTEGER DEFAULT 3,  -- 1-5, manually set
    is_template BOOLEAN DEFAULT FALSE,  -- Mark as reusable template
    usage_count INTEGER DEFAULT 0,     -- How often referenced

    -- Metadata
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (story_id) REFERENCES user_stories(story_id)
);


-- ============================================================================
-- IMPORT BATCHES TABLE
-- ============================================================================
-- Tracks file imports for audit purposes.

CREATE TABLE IF NOT EXISTS import_batches (
    batch_id TEXT PRIMARY KEY,
    program_id TEXT NOT NULL,
    source_file TEXT NOT NULL,
    import_type TEXT,          -- requirements, stories, test_cases
    records_imported INTEGER,
    records_updated INTEGER,
    records_skipped INTEGER,
    import_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    imported_by TEXT DEFAULT 'system',
    notes TEXT,

    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);


-- ============================================================================
-- INDEXES
-- ============================================================================
-- Optimize common query patterns

-- Programs
CREATE INDEX IF NOT EXISTS idx_programs_client ON programs(client_id);
CREATE INDEX IF NOT EXISTS idx_programs_prefix ON programs(prefix);
CREATE INDEX IF NOT EXISTS idx_programs_status ON programs(status);

-- Requirements
CREATE INDEX IF NOT EXISTS idx_requirements_program ON requirements(program_id);
CREATE INDEX IF NOT EXISTS idx_requirements_type ON requirements(requirement_type);

-- User Stories
CREATE INDEX IF NOT EXISTS idx_stories_program ON user_stories(program_id);
CREATE INDEX IF NOT EXISTS idx_stories_requirement ON user_stories(requirement_id);
CREATE INDEX IF NOT EXISTS idx_stories_status ON user_stories(status);
CREATE INDEX IF NOT EXISTS idx_stories_category ON user_stories(category);
CREATE INDEX IF NOT EXISTS idx_stories_technical ON user_stories(is_technical);

-- UAT Test Cases
CREATE INDEX IF NOT EXISTS idx_tests_program ON uat_test_cases(program_id);
CREATE INDEX IF NOT EXISTS idx_tests_story ON uat_test_cases(story_id);
CREATE INDEX IF NOT EXISTS idx_tests_status ON uat_test_cases(test_status);
CREATE INDEX IF NOT EXISTS idx_tests_type ON uat_test_cases(test_type);
CREATE INDEX IF NOT EXISTS idx_tests_compliance ON uat_test_cases(compliance_framework);

-- Traceability
CREATE INDEX IF NOT EXISTS idx_trace_program ON traceability(program_id);
CREATE INDEX IF NOT EXISTS idx_trace_requirement ON traceability(requirement_id);
CREATE INDEX IF NOT EXISTS idx_trace_story ON traceability(story_id);
CREATE INDEX IF NOT EXISTS idx_trace_coverage ON traceability(coverage_status);

-- Compliance Gaps
CREATE INDEX IF NOT EXISTS idx_compliance_program ON compliance_gaps(program_id);
CREATE INDEX IF NOT EXISTS idx_compliance_framework ON compliance_gaps(framework);
CREATE INDEX IF NOT EXISTS idx_compliance_status ON compliance_gaps(status);
CREATE INDEX IF NOT EXISTS idx_compliance_severity ON compliance_gaps(severity);

-- Audit History
CREATE INDEX IF NOT EXISTS idx_audit_record ON audit_history(record_type, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_date ON audit_history(changed_date);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_history(action);
CREATE INDEX IF NOT EXISTS idx_audit_session ON audit_history(session_id);

-- Reference Library
CREATE INDEX IF NOT EXISTS idx_reference_category ON story_reference(category);
CREATE INDEX IF NOT EXISTS idx_reference_quality ON story_reference(quality_score);


-- ============================================================================
-- VIEWS
-- ============================================================================
-- Pre-built views for common reporting needs

-- Program summary view
CREATE VIEW IF NOT EXISTS v_program_summary AS
SELECT
    p.program_id,
    p.name AS program_name,
    p.prefix,
    c.name AS client_name,
    p.status AS program_status,
    COUNT(DISTINCT r.requirement_id) AS requirement_count,
    COUNT(DISTINCT s.story_id) AS story_count,
    COUNT(DISTINCT CASE WHEN s.status = 'Approved' THEN s.story_id END) AS approved_stories,
    COUNT(DISTINCT CASE WHEN s.status = 'Draft' THEN s.story_id END) AS draft_stories,
    COUNT(DISTINCT CASE WHEN s.status = 'Pending Client Review' THEN s.story_id END) AS pending_review,
    COUNT(DISTINCT t.test_id) AS test_count,
    COUNT(DISTINCT CASE WHEN t.test_status = 'Pass' THEN t.test_id END) AS tests_passed,
    COUNT(DISTINCT CASE WHEN t.test_status = 'Fail' THEN t.test_id END) AS tests_failed
FROM programs p
LEFT JOIN clients c ON p.client_id = c.client_id
LEFT JOIN requirements r ON p.program_id = r.program_id
LEFT JOIN user_stories s ON p.program_id = s.program_id
LEFT JOIN uat_test_cases t ON p.program_id = t.program_id
GROUP BY p.program_id;


-- Story workflow view
CREATE VIEW IF NOT EXISTS v_story_workflow AS
SELECT
    s.story_id,
    s.title,
    s.status,
    s.priority,
    s.category,
    s.is_technical,
    p.prefix,
    p.name AS program_name,
    c.name AS client_name,
    s.created_date,
    s.updated_date,
    s.approved_date,
    s.approved_by,
    COUNT(DISTINCT t.test_id) AS test_count
FROM user_stories s
JOIN programs p ON s.program_id = p.program_id
JOIN clients c ON p.client_id = c.client_id
LEFT JOIN uat_test_cases t ON s.story_id = t.story_id
GROUP BY s.story_id;


-- Compliance dashboard view
CREATE VIEW IF NOT EXISTS v_compliance_dashboard AS
SELECT
    p.program_id,
    p.prefix,
    p.name AS program_name,
    g.framework,
    g.severity,
    g.status AS gap_status,
    COUNT(*) AS gap_count
FROM compliance_gaps g
JOIN programs p ON g.program_id = p.program_id
GROUP BY p.program_id, g.framework, g.severity, g.status;


-- Test execution view
CREATE VIEW IF NOT EXISTS v_test_execution AS
SELECT
    p.program_id,
    p.prefix,
    p.name AS program_name,
    t.test_type,
    t.compliance_framework,
    t.test_status,
    COUNT(*) AS test_count
FROM uat_test_cases t
JOIN programs p ON t.program_id = p.program_id
GROUP BY p.program_id, t.test_type, t.compliance_framework, t.test_status;


-- ============================================================================
-- UAT CYCLES TABLE
-- ============================================================================
-- Tracks UAT packages/releases with phase dates and gate sign-offs.
-- Each cycle groups test cases for a specific release validation.
--
-- AVIATION ANALOGY:
--   Think of this as a mission package - defines the objectives,
--   timeline, checkpoints, and go/no-go criteria for a specific deployment.
--   The Pre-UAT Gate is your preflight checklist - must pass before wheels up.

CREATE TABLE IF NOT EXISTS uat_cycles (
    cycle_id TEXT PRIMARY KEY,  -- UUID format
    program_id TEXT,            -- Optional - can be cross-program
    name TEXT NOT NULL,         -- "NCCN Q4 2025", "GenoRx e-Consent v1"
    description TEXT,
    uat_type TEXT NOT NULL,     -- 'feature', 'rule_validation', 'regression'
    target_launch_date DATE,
    status TEXT DEFAULT 'planning',
    -- Status values: planning, validation, kickoff, testing, review,
    --                retesting, decision, complete, cancelled

    -- Ownership
    clinical_pm TEXT,           -- Who owns validation
    clinical_pm_email TEXT,

    -- Phase dates (all nullable, filled as phases progress)
    validation_start DATE,      -- Pre-UAT validation begins
    validation_end DATE,        -- Gate sign-off target
    kickoff_date DATE,          -- Kickoff meeting
    testing_start DATE,         -- Testing window opens
    testing_end DATE,           -- Testing window closes
    review_date DATE,           -- Issue review meeting
    retest_start DATE,          -- Retesting begins
    retest_end DATE,            -- Retesting ends
    go_nogo_date DATE,          -- Decision meeting

    -- Pre-UAT Gate (must pass before engaging testers)
    pre_uat_gate_passed INTEGER DEFAULT 0,  -- Boolean: 0 or 1
    pre_uat_gate_signed_by TEXT,
    pre_uat_gate_signed_date DATE,
    pre_uat_gate_notes TEXT,

    -- Go/No-Go Decision
    go_nogo_decision TEXT,      -- 'go', 'conditional_go', 'no_go', NULL
    go_nogo_signed_by TEXT,
    go_nogo_signed_date DATE,
    go_nogo_notes TEXT,

    -- Timestamps (matching existing convention)
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by TEXT DEFAULT 'system',

    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

-- Indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_uat_cycles_program ON uat_cycles(program_id);
CREATE INDEX IF NOT EXISTS idx_uat_cycles_status ON uat_cycles(status);
CREATE INDEX IF NOT EXISTS idx_uat_cycles_launch ON uat_cycles(target_launch_date);
CREATE INDEX IF NOT EXISTS idx_uat_cycles_type ON uat_cycles(uat_type);


-- ============================================================================
-- UAT TEST CASES EXTENSIONS
-- ============================================================================
-- Add new columns to support UAT cycle tracking, tester assignments,
-- persona-based testing (Feature UAT), and NCCN rule validation.
--
-- NOTE: Run these ALTER TABLE statements on existing databases.
-- For new databases, modify the uat_test_cases CREATE TABLE above.

-- UAT Cycle association
-- ALTER TABLE uat_test_cases ADD COLUMN uat_cycle_id TEXT;

-- Tester assignment (pre-execution)
-- ALTER TABLE uat_test_cases ADD COLUMN assigned_to TEXT;
-- ALTER TABLE uat_test_cases ADD COLUMN assignment_type TEXT;  -- 'primary', 'overlap', 'backup'

-- Feature UAT: Persona-based testing
-- ALTER TABLE uat_test_cases ADD COLUMN persona TEXT;
-- Values: 'provider_screening', 'patient', 'provider_dashboard', NULL

-- NCCN Rule Validation fields (all nullable for feature tests)
-- ALTER TABLE uat_test_cases ADD COLUMN profile_id TEXT;        -- TP-PROS007-POS-01-P4M
-- ALTER TABLE uat_test_cases ADD COLUMN platform TEXT;          -- 'P4M', 'Px4M'
-- ALTER TABLE uat_test_cases ADD COLUMN change_id TEXT;         -- 25Q4R-01 format
-- ALTER TABLE uat_test_cases ADD COLUMN target_rule TEXT;       -- NCCN-PROS-007
-- ALTER TABLE uat_test_cases ADD COLUMN change_type TEXT;       -- 'NEW', 'MODIFIED', 'DEPRECATED'
-- ALTER TABLE uat_test_cases ADD COLUMN patient_conditions TEXT;
-- ALTER TABLE uat_test_cases ADD COLUMN cross_trigger_check TEXT;

-- Retest tracking (separate from initial execution)
-- ALTER TABLE uat_test_cases ADD COLUMN retest_status TEXT;     -- Not Run, Pass, Fail, Blocked
-- ALTER TABLE uat_test_cases ADD COLUMN retest_date TIMESTAMP;
-- ALTER TABLE uat_test_cases ADD COLUMN retest_by TEXT;
-- ALTER TABLE uat_test_cases ADD COLUMN retest_notes TEXT;

-- Developer feedback (for failed tests requiring dev action)
-- ALTER TABLE uat_test_cases ADD COLUMN dev_notes TEXT;
-- ALTER TABLE uat_test_cases ADD COLUMN dev_status TEXT;
-- dev_status values: 'pending', 'investigating', 'fixed', 'wont_fix', 'not_a_bug'

-- New indexes for UAT queries
CREATE INDEX IF NOT EXISTS idx_tests_cycle ON uat_test_cases(uat_cycle_id);
CREATE INDEX IF NOT EXISTS idx_tests_platform ON uat_test_cases(platform);
CREATE INDEX IF NOT EXISTS idx_tests_assigned ON uat_test_cases(assigned_to);
CREATE INDEX IF NOT EXISTS idx_tests_change ON uat_test_cases(change_id);
CREATE INDEX IF NOT EXISTS idx_tests_persona ON uat_test_cases(persona);


-- ============================================================================
-- PRE-UAT GATE ITEMS TABLE
-- ============================================================================
-- Tracks individual validation checklist items for the Pre-UAT Gate.
-- Required for Part 11 compliance - documents who verified what and when.
--
-- AVIATION ANALOGY:
--   This is your preflight checklist. Each item must be verified
--   and signed off before the mission can proceed.

CREATE TABLE IF NOT EXISTS pre_uat_gate_items (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cycle_id TEXT NOT NULL,     -- FK to uat_cycles
    category TEXT NOT NULL,
    -- Categories: 'feature_deployment', 'critical_path', 'environment',
    --             'blocker_check', 'sign_off'
    sequence INTEGER DEFAULT 0,  -- Order within category
    item_text TEXT NOT NULL,     -- The checklist item description
    is_required INTEGER DEFAULT 1,  -- Boolean: 1 = must pass
    is_complete INTEGER DEFAULT 0,  -- Boolean: 1 = verified
    completed_by TEXT,           -- Who verified this item
    completed_date DATE,         -- When verified
    notes TEXT,                  -- Observations or issues
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (cycle_id) REFERENCES uat_cycles(cycle_id)
);

CREATE INDEX IF NOT EXISTS idx_gate_items_cycle ON pre_uat_gate_items(cycle_id);
CREATE INDEX IF NOT EXISTS idx_gate_items_category ON pre_uat_gate_items(category);
CREATE INDEX IF NOT EXISTS idx_gate_items_complete ON pre_uat_gate_items(is_complete);


-- ============================================================================
-- UAT CYCLE SUMMARY VIEW
-- ============================================================================
-- Provides progress metrics for UAT cycles.
-- Use for dashboards and status reporting.

CREATE VIEW IF NOT EXISTS v_uat_cycle_summary AS
SELECT
    c.cycle_id,
    c.name,
    c.uat_type,
    c.status,
    c.target_launch_date,
    c.clinical_pm,
    c.pre_uat_gate_passed,
    c.go_nogo_decision,
    p.prefix AS program_prefix,
    p.name AS program_name,
    -- Test counts
    COUNT(t.test_id) AS total_tests,
    SUM(CASE WHEN t.test_status = 'Pass' THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN t.test_status = 'Fail' THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN t.test_status = 'Blocked' THEN 1 ELSE 0 END) AS blocked,
    SUM(CASE WHEN t.test_status = 'Skipped' THEN 1 ELSE 0 END) AS skipped,
    SUM(CASE WHEN t.test_status = 'Not Run' THEN 1 ELSE 0 END) AS not_run,
    -- Calculated metrics
    ROUND(100.0 * SUM(CASE WHEN t.test_status != 'Not Run' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(t.test_id), 0), 1) AS execution_pct,
    ROUND(100.0 * SUM(CASE WHEN t.test_status = 'Pass' THEN 1 ELSE 0 END)
          / NULLIF(SUM(CASE WHEN t.test_status IN ('Pass', 'Fail') THEN 1 ELSE 0 END), 0), 1) AS pass_rate,
    -- Days remaining
    CAST(julianday(c.target_launch_date) - julianday('now') AS INTEGER) AS days_to_launch
FROM uat_cycles c
LEFT JOIN programs p ON c.program_id = p.program_id
LEFT JOIN uat_test_cases t ON c.cycle_id = t.uat_cycle_id
GROUP BY c.cycle_id;


-- ============================================================================
-- UAT TESTER PROGRESS VIEW
-- ============================================================================
-- Tracks test execution progress by tester within a cycle.

CREATE VIEW IF NOT EXISTS v_uat_tester_progress AS
SELECT
    c.cycle_id,
    c.name AS cycle_name,
    t.assigned_to,
    t.assignment_type,
    COUNT(t.test_id) AS assigned_tests,
    SUM(CASE WHEN t.test_status != 'Not Run' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN t.test_status = 'Pass' THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN t.test_status = 'Fail' THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN t.test_status = 'Blocked' THEN 1 ELSE 0 END) AS blocked,
    ROUND(100.0 * SUM(CASE WHEN t.test_status != 'Not Run' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(t.test_id), 0), 1) AS completion_pct
FROM uat_cycles c
JOIN uat_test_cases t ON c.cycle_id = t.uat_cycle_id
WHERE t.assigned_to IS NOT NULL
GROUP BY c.cycle_id, t.assigned_to, t.assignment_type
ORDER BY c.cycle_id, t.assigned_to;


-- ============================================================================
-- NCCN RULE COVERAGE VIEW
-- ============================================================================
-- NCCN-specific view for rule validation coverage.
-- Groups tests by Change ID and platform for coverage analysis.

CREATE VIEW IF NOT EXISTS v_nccn_rule_coverage AS
SELECT
    c.cycle_id,
    c.name AS cycle_name,
    t.change_id,
    t.target_rule,
    t.change_type,
    t.platform,
    COUNT(t.test_id) AS total_profiles,
    SUM(CASE WHEN t.test_type = 'positive' THEN 1 ELSE 0 END) AS pos_tests,
    SUM(CASE WHEN t.test_type = 'negative' THEN 1 ELSE 0 END) AS neg_tests,
    SUM(CASE WHEN t.test_type = 'deprecated' THEN 1 ELSE 0 END) AS dep_tests,
    SUM(CASE WHEN t.test_status = 'Pass' THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN t.test_status = 'Fail' THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN t.test_status = 'Not Run' THEN 1 ELSE 0 END) AS not_run
FROM uat_cycles c
JOIN uat_test_cases t ON c.cycle_id = t.uat_cycle_id
WHERE t.change_id IS NOT NULL
GROUP BY c.cycle_id, t.change_id, t.target_rule, t.change_type, t.platform
ORDER BY t.change_id, t.platform;


-- ============================================================================
-- RETEST QUEUE VIEW
-- ============================================================================
-- Shows tests that failed and need retesting.

CREATE VIEW IF NOT EXISTS v_retest_queue AS
SELECT
    c.cycle_id,
    c.name AS cycle_name,
    t.test_id,
    t.profile_id,
    t.title,
    t.platform,
    t.target_rule,
    t.test_status AS initial_status,
    t.tested_by AS initial_tester,
    t.tested_date AS initial_test_date,
    t.execution_notes,
    t.defect_id,
    t.dev_status,
    t.dev_notes,
    t.retest_status,
    t.retest_by,
    t.retest_date
FROM uat_cycles c
JOIN uat_test_cases t ON c.cycle_id = t.uat_cycle_id
WHERE t.test_status = 'Fail'
ORDER BY c.cycle_id, t.dev_status, t.test_id;
