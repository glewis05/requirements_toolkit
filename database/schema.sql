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
