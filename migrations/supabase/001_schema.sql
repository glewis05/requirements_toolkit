-- ============================================================================
-- Propel Health Database Schema for Supabase (PostgreSQL)
-- Version: 1.0.0
-- Generated: 2026-01-20
--
-- This schema represents a normalized, production-ready database design
-- migrated from SQLite with the following improvements:
--   - UUID primary keys for new records
--   - JSONB for structured data storage
--   - CHECK constraints for all status fields
--   - Proper foreign key enforcement with ON DELETE actions
--   - Indexes on foreign keys and frequently filtered columns
--   - Row Level Security (RLS) enabled (policies in separate file)
--   - Automatic updated_at timestamp triggers
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- For uuid_generate_v4() (legacy)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";       -- For gen_random_uuid() (preferred)

-- ============================================================================
-- UTILITY: Automatic updated_at trigger function
-- ============================================================================
-- PURPOSE: Automatically updates the updated_at column on any row modification
-- USAGE: Apply this trigger to any table with an updated_at column
-- ============================================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION update_updated_at_column() IS
    'Trigger function to automatically set updated_at to current timestamp on UPDATE';

-- ============================================================================
-- SECTION 1: LOOKUP TABLES (No dependencies)
-- These tables provide controlled vocabularies for status fields, categories, etc.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: priority_levels
-- PURPOSE: Standardized priority values using MoSCoW method
-- ----------------------------------------------------------------------------
CREATE TABLE priority_levels (
    priority_code   TEXT PRIMARY KEY,
    priority_name   TEXT NOT NULL,
    display_order   INTEGER NOT NULL,
    color_hex       TEXT,
    description     TEXT
);

COMMENT ON TABLE priority_levels IS 'MoSCoW priority levels for requirements, stories, and test cases';

-- ----------------------------------------------------------------------------
-- Table: story_categories
-- PURPOSE: Categories for user stories (maps to story ID prefixes)
-- ----------------------------------------------------------------------------
CREATE TABLE story_categories (
    category_code   TEXT PRIMARY KEY,
    category_name   TEXT NOT NULL,
    description     TEXT,
    display_order   INTEGER DEFAULT 0
);

COMMENT ON TABLE story_categories IS 'User story categories that map to ID prefixes (e.g., RECRUIT, MSG, DASH)';

-- ----------------------------------------------------------------------------
-- Table: test_types
-- PURPOSE: Types of UAT test cases
-- ----------------------------------------------------------------------------
CREATE TABLE test_types (
    type_code       TEXT PRIMARY KEY,
    type_name       TEXT NOT NULL,
    description     TEXT,
    is_compliance   BOOLEAN DEFAULT FALSE
);

COMMENT ON TABLE test_types IS 'UAT test case types (functional, regression, compliance, etc.)';

-- ----------------------------------------------------------------------------
-- Table: uat_workflow_sections
-- PURPOSE: Sections for organizing UAT test execution workflow
-- ----------------------------------------------------------------------------
CREATE TABLE uat_workflow_sections (
    section_code        TEXT PRIMARY KEY,
    section_name        TEXT NOT NULL,
    section_description TEXT,
    guidance_text       TEXT,
    display_order       INTEGER DEFAULT 0
);

COMMENT ON TABLE uat_workflow_sections IS 'Workflow sections for organizing UAT test execution';

-- ----------------------------------------------------------------------------
-- Table: role_conflicts
-- PURPOSE: Defines conflicting roles for segregation of duties
-- ----------------------------------------------------------------------------
CREATE TABLE role_conflicts (
    conflict_id     SERIAL PRIMARY KEY,
    role_a          TEXT NOT NULL,
    role_b          TEXT NOT NULL,
    severity        TEXT DEFAULT 'Warning' CHECK (severity IN ('Warning', 'Critical', 'Informational')),
    description     TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE role_conflicts IS 'Segregation of duties - defines role combinations that should trigger review';

-- ----------------------------------------------------------------------------
-- Table: roadmap_holidays
-- PURPOSE: Company holidays for roadmap planning
-- ----------------------------------------------------------------------------
CREATE TABLE roadmap_holidays (
    holiday_id      SERIAL PRIMARY KEY,
    holiday_date    DATE NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    icon            TEXT NOT NULL
);

COMMENT ON TABLE roadmap_holidays IS 'Company holidays displayed on roadmap timeline';

-- ----------------------------------------------------------------------------
-- Table: roadmap_config
-- PURPOSE: Configuration settings for roadmap display
-- ----------------------------------------------------------------------------
CREATE TABLE roadmap_config (
    config_key      TEXT PRIMARY KEY,
    config_value    TEXT NOT NULL,
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE roadmap_config IS 'Roadmap display configuration settings';

-- ----------------------------------------------------------------------------
-- Table: roadmap_activity_types
-- PURPOSE: Types of activities shown on roadmap
-- ----------------------------------------------------------------------------
CREATE TABLE roadmap_activity_types (
    type_id         SERIAL PRIMARY KEY,
    type_code       TEXT UNIQUE NOT NULL,
    type_name       TEXT NOT NULL,
    default_color   TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE roadmap_activity_types IS 'Activity types for roadmap projects with default colors';


-- ============================================================================
-- SECTION 2: COMPLIANCE FRAMEWORK TABLES
-- These define regulatory frameworks and test templates
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: compliance_frameworks
-- PURPOSE: Regulatory frameworks (FDA Part 11, HIPAA, SOC 2, etc.)
-- ----------------------------------------------------------------------------
CREATE TABLE compliance_frameworks (
    framework_id    TEXT PRIMARY KEY,
    framework_name  TEXT NOT NULL,
    full_name       TEXT NOT NULL,
    description     TEXT,
    regulation_url  TEXT,
    applies_when    TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE compliance_frameworks IS 'Regulatory compliance frameworks (Part 11, HIPAA, SOC 2)';
COMMENT ON COLUMN compliance_frameworks.applies_when IS 'Conditions when this framework applies to a program';

-- ----------------------------------------------------------------------------
-- Table: compliance_test_templates
-- PURPOSE: Standard test templates for compliance testing
-- ----------------------------------------------------------------------------
CREATE TABLE compliance_test_templates (
    template_id             TEXT PRIMARY KEY,
    framework_id            TEXT NOT NULL REFERENCES compliance_frameworks(framework_id) ON DELETE CASCADE,
    template_name           TEXT NOT NULL,
    test_type               TEXT DEFAULT 'validation',
    description             TEXT,
    applies_when            TEXT,
    standard_test_steps     TEXT,
    standard_expected_result TEXT,
    is_active               BOOLEAN DEFAULT TRUE,
    created_at              TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE compliance_test_templates IS 'Standard test case templates for compliance frameworks';

CREATE INDEX idx_compliance_templates_framework ON compliance_test_templates(framework_id);


-- ============================================================================
-- SECTION 3: ORGANIZATION HIERARCHY
-- clients → programs → clinics → locations
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: clients
-- PURPOSE: Top-level client organizations
-- CHANGES FROM SQLITE:
--   - Removed duplicate columns: primary_contact, contact_email
--   - Changed contract dates from TEXT to DATE
--   - Added CHECK constraint on status
--   - Renamed timestamp columns to *_at
-- ----------------------------------------------------------------------------
CREATE TABLE clients (
    client_id               TEXT PRIMARY KEY,
    name                    TEXT NOT NULL UNIQUE,
    short_name              TEXT,
    description             TEXT,
    client_type             TEXT,
    -- Primary contact (consolidated from duplicate columns)
    primary_contact_name    TEXT,
    primary_contact_email   TEXT,
    primary_contact_phone   TEXT,
    -- Contract information
    contract_reference      TEXT,
    contract_start_date     DATE,
    contract_end_date       DATE,
    source_document         TEXT,
    -- Status and timestamps
    status                  TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE clients IS 'Top-level client organizations (e.g., Discover Health, Acme Corp)';
COMMENT ON COLUMN clients.client_id IS 'Unique identifier - can be UUID or human-readable code';
COMMENT ON COLUMN clients.short_name IS 'Abbreviated name for display in tight spaces';

CREATE INDEX idx_clients_status ON clients(status);
CREATE INDEX idx_clients_name ON clients(name);

-- Trigger for updated_at
CREATE TRIGGER trigger_clients_updated_at
    BEFORE UPDATE ON clients
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS (policies defined in 005_rls_policies.sql)
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: programs
-- PURPOSE: Programs under each client (P4M, Px4M, ONB, etc.)
-- NOTES: The prefix is unique and used for story ID generation
-- ----------------------------------------------------------------------------
CREATE TABLE programs (
    program_id      TEXT PRIMARY KEY,
    client_id       TEXT REFERENCES clients(client_id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    prefix          TEXT UNIQUE,
    description     TEXT,
    program_type    TEXT DEFAULT 'clinic_based',
    source_file     TEXT,
    color_hex       TEXT,
    status          TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Archived')),
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE programs IS 'Programs under clients - the central entity connecting requirements and configurations';
COMMENT ON COLUMN programs.prefix IS 'Unique prefix for story/test IDs (e.g., PROP, GRX, ACME)';
COMMENT ON COLUMN programs.program_type IS 'Type: clinic_based, enterprise, integration, etc.';

CREATE INDEX idx_programs_client ON programs(client_id);
CREATE INDEX idx_programs_status ON programs(status);
CREATE INDEX idx_programs_prefix ON programs(prefix);

CREATE TRIGGER trigger_programs_updated_at
    BEFORE UPDATE ON programs
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE programs ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: program_relationships
-- PURPOSE: Links between programs (parent/child, attached, etc.)
-- ----------------------------------------------------------------------------
CREATE TABLE program_relationships (
    relationship_id     SERIAL PRIMARY KEY,
    parent_program_id   TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    attached_program_id TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    relationship_type   TEXT DEFAULT 'attached',
    created_at          TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_program_relationship UNIQUE (parent_program_id, attached_program_id)
);

COMMENT ON TABLE program_relationships IS 'Defines relationships between programs (parent/child, attached)';

CREATE INDEX idx_program_rel_parent ON program_relationships(parent_program_id);
CREATE INDEX idx_program_rel_attached ON program_relationships(attached_program_id);

ALTER TABLE program_relationships ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: clinics
-- PURPOSE: Clinics under programs
-- CHANGES FROM SQLITE:
--   - Added missing contact fields (phone, fax, email)
--   - Added address fields
--   - Added manager fields
--   - Added epic_id
-- ----------------------------------------------------------------------------
CREATE TABLE clinics (
    clinic_id           TEXT PRIMARY KEY,
    program_id          TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    name                TEXT NOT NULL,
    code                TEXT,
    description         TEXT,
    -- Contact information (ADDED - was missing)
    phone               TEXT,
    fax                 TEXT,
    email               TEXT,
    -- Address (ADDED - was missing)
    address_street      TEXT,
    address_city        TEXT,
    address_state       TEXT,
    address_zip         TEXT,
    -- Manager (ADDED - was missing)
    manager_name        TEXT,
    manager_email       TEXT,
    -- Integration
    epic_id             TEXT,
    -- Status and timestamps
    status              TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Onboarding', 'Archived')),
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE clinics IS 'Clinics within programs - can have multiple locations';
COMMENT ON COLUMN clinics.code IS 'Short code for the clinic (used in reports)';
COMMENT ON COLUMN clinics.epic_id IS 'Epic EHR system identifier';

CREATE INDEX idx_clinics_program ON clinics(program_id);
CREATE INDEX idx_clinics_status ON clinics(status);
CREATE INDEX idx_clinics_epic ON clinics(epic_id) WHERE epic_id IS NOT NULL;

CREATE TRIGGER trigger_clinics_updated_at
    BEFORE UPDATE ON clinics
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE clinics ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: locations
-- PURPOSE: Physical locations under clinics
-- ----------------------------------------------------------------------------
CREATE TABLE locations (
    location_id     TEXT PRIMARY KEY,
    clinic_id       TEXT NOT NULL REFERENCES clinics(clinic_id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    code            TEXT,
    -- Address
    address         TEXT,
    city            TEXT,
    state           TEXT,
    zip             TEXT,
    -- Contact
    phone           TEXT,
    fax             TEXT,
    -- Integration
    epic_id         TEXT,
    -- Status and timestamps
    status          TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Onboarding', 'Archived')),
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE locations IS 'Physical locations within clinics';

CREATE INDEX idx_locations_clinic ON locations(clinic_id);
CREATE INDEX idx_locations_status ON locations(status);
CREATE INDEX idx_locations_epic ON locations(epic_id) WHERE epic_id IS NOT NULL;

CREATE TRIGGER trigger_locations_updated_at
    BEFORE UPDATE ON locations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE locations ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 4: PROVIDERS (Normalized many-to-many with locations)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: providers
-- PURPOSE: Healthcare providers (doctors, nurses, etc.)
-- CHANGES FROM SQLITE:
--   - Removed location_id (moved to junction table)
--   - Added UNIQUE constraint on NPI
--   - Changed is_active INTEGER to BOOLEAN
-- ----------------------------------------------------------------------------
CREATE TABLE providers (
    provider_id     SERIAL PRIMARY KEY,
    name            TEXT NOT NULL,
    npi             TEXT UNIQUE,
    specialty       TEXT,
    email           TEXT,
    phone           TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE providers IS 'Healthcare providers - linked to locations via provider_locations';
COMMENT ON COLUMN providers.npi IS 'National Provider Identifier (unique 10-digit number)';

CREATE INDEX idx_providers_npi ON providers(npi) WHERE npi IS NOT NULL;
CREATE INDEX idx_providers_active ON providers(is_active);
CREATE INDEX idx_providers_email ON providers(email) WHERE email IS NOT NULL;

CREATE TRIGGER trigger_providers_updated_at
    BEFORE UPDATE ON providers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE providers ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: provider_locations (NEW - Junction table)
-- PURPOSE: Many-to-many relationship between providers and locations
-- A provider can work at multiple locations
-- ----------------------------------------------------------------------------
CREATE TABLE provider_locations (
    provider_location_id    SERIAL PRIMARY KEY,
    provider_id             INTEGER NOT NULL REFERENCES providers(provider_id) ON DELETE CASCADE,
    location_id             TEXT NOT NULL REFERENCES locations(location_id) ON DELETE CASCADE,
    is_primary              BOOLEAN DEFAULT FALSE,
    start_date              DATE,
    end_date                DATE,
    notes                   TEXT,
    created_at              TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_provider_location UNIQUE (provider_id, location_id)
);

COMMENT ON TABLE provider_locations IS 'Junction table: providers can work at multiple locations';
COMMENT ON COLUMN provider_locations.is_primary IS 'Indicates the provider''s primary practice location';

CREATE INDEX idx_provider_loc_provider ON provider_locations(provider_id);
CREATE INDEX idx_provider_loc_location ON provider_locations(location_id);

ALTER TABLE provider_locations ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 5: CONFIGURATION MANAGEMENT
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: config_definitions
-- PURPOSE: Defines available configuration keys and their metadata
-- CHANGES FROM SQLITE:
--   - valid_values changed from TEXT to JSONB
-- ----------------------------------------------------------------------------
CREATE TABLE config_definitions (
    config_key      TEXT PRIMARY KEY,
    display_name    TEXT NOT NULL,
    description     TEXT,
    category        TEXT NOT NULL,
    data_type       TEXT DEFAULT 'text',
    default_value   TEXT,
    valid_values    JSONB,  -- Changed from TEXT to JSONB array
    is_required     BOOLEAN DEFAULT FALSE,
    is_sensitive    BOOLEAN DEFAULT FALSE,
    applies_to      TEXT DEFAULT 'all',
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE config_definitions IS 'Master list of configuration keys with metadata';
COMMENT ON COLUMN config_definitions.valid_values IS 'JSONB array of allowed values (for dropdowns)';
COMMENT ON COLUMN config_definitions.is_sensitive IS 'If true, value should be masked in UI';
COMMENT ON COLUMN config_definitions.applies_to IS 'Scope: all, program, clinic, location';

CREATE INDEX idx_config_def_category ON config_definitions(category);

ALTER TABLE config_definitions ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: config_values
-- PURPOSE: Actual configuration values at various hierarchy levels
-- ----------------------------------------------------------------------------
CREATE TABLE config_values (
    value_id        SERIAL PRIMARY KEY,
    config_key      TEXT NOT NULL REFERENCES config_definitions(config_key) ON DELETE CASCADE,
    value           TEXT,
    -- Hierarchy level (only one should be set)
    program_id      TEXT REFERENCES programs(program_id) ON DELETE CASCADE,
    clinic_id       TEXT REFERENCES clinics(clinic_id) ON DELETE CASCADE,
    location_id     TEXT REFERENCES locations(location_id) ON DELETE CASCADE,
    -- Metadata
    source          TEXT DEFAULT 'manual',
    source_document TEXT,
    effective_date  DATE,
    expiration_date DATE,
    is_override     BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE config_values IS 'Configuration values at program, clinic, or location level';
COMMENT ON COLUMN config_values.is_override IS 'True if this overrides a parent-level value';

CREATE INDEX idx_config_values_key ON config_values(config_key);
CREATE INDEX idx_config_values_program ON config_values(program_id) WHERE program_id IS NOT NULL;
CREATE INDEX idx_config_values_clinic ON config_values(clinic_id) WHERE clinic_id IS NOT NULL;
CREATE INDEX idx_config_values_location ON config_values(location_id) WHERE location_id IS NOT NULL;

CREATE TRIGGER trigger_config_values_updated_at
    BEFORE UPDATE ON config_values
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE config_values ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: config_history
-- PURPOSE: Audit trail for configuration changes
-- ----------------------------------------------------------------------------
CREATE TABLE config_history (
    history_id      SERIAL PRIMARY KEY,
    config_key      TEXT NOT NULL,
    program_id      TEXT,
    clinic_id       TEXT,
    location_id     TEXT,
    old_value       TEXT,
    new_value       TEXT,
    changed_by      TEXT DEFAULT 'system',
    changed_at      TIMESTAMPTZ DEFAULT NOW(),
    change_reason   TEXT,
    source_document TEXT
);

COMMENT ON TABLE config_history IS 'Audit trail for all configuration changes';

CREATE INDEX idx_config_history_key ON config_history(config_key);
CREATE INDEX idx_config_history_date ON config_history(changed_at);

ALTER TABLE config_history ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: appointment_types
-- PURPOSE: Appointment types available at each location
-- ----------------------------------------------------------------------------
CREATE TABLE appointment_types (
    type_id         SERIAL PRIMARY KEY,
    location_id     TEXT NOT NULL REFERENCES locations(location_id) ON DELETE CASCADE,
    type_name       TEXT NOT NULL,
    type_code       TEXT,
    is_included     BOOLEAN DEFAULT TRUE,
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE appointment_types IS 'Appointment types available at locations (for scheduling integration)';

CREATE INDEX idx_appt_types_location ON appointment_types(location_id);

ALTER TABLE appointment_types ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 6: REQUIREMENTS MANAGEMENT
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: import_batches
-- PURPOSE: Tracks file imports for traceability
-- ----------------------------------------------------------------------------
CREATE TABLE import_batches (
    batch_id        TEXT PRIMARY KEY,
    program_id      TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    source_file     TEXT NOT NULL,
    import_type     TEXT,
    records_imported INTEGER,
    records_updated  INTEGER,
    records_skipped  INTEGER,
    import_date     TIMESTAMPTZ DEFAULT NOW(),
    imported_by     TEXT DEFAULT 'system',
    notes           TEXT
);

COMMENT ON TABLE import_batches IS 'Tracks all file imports for audit and traceability';

CREATE INDEX idx_import_batches_program ON import_batches(program_id);
CREATE INDEX idx_import_batches_date ON import_batches(import_date);

ALTER TABLE import_batches ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: requirements
-- PURPOSE: Raw requirements from source documents
-- CHANGES FROM SQLITE:
--   - context_json changed from TEXT to JSONB
-- ----------------------------------------------------------------------------
CREATE TABLE requirements (
    requirement_id      TEXT PRIMARY KEY,
    program_id          TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    source_file         TEXT,
    source_row          INTEGER,
    raw_text            TEXT,
    title               TEXT,
    description         TEXT,
    priority            TEXT,
    source_status       TEXT,
    requirement_type    TEXT,
    context_json        JSONB,  -- Changed from TEXT to JSONB
    import_batch        TEXT REFERENCES import_batches(batch_id) ON DELETE SET NULL,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE requirements IS 'Raw requirements parsed from source documents (Excel, Visio, etc.)';
COMMENT ON COLUMN requirements.context_json IS 'JSONB: Additional context extracted during parsing';

CREATE INDEX idx_requirements_program ON requirements(program_id);
CREATE INDEX idx_requirements_batch ON requirements(import_batch) WHERE import_batch IS NOT NULL;
CREATE INDEX idx_requirements_type ON requirements(requirement_type) WHERE requirement_type IS NOT NULL;

CREATE TRIGGER trigger_requirements_updated_at
    BEFORE UPDATE ON requirements
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE requirements ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: user_stories
-- PURPOSE: User stories generated from requirements
-- CHANGES FROM SQLITE:
--   - related_stories changed from TEXT to JSONB
--   - flags changed from TEXT to JSONB
--   - Added CHECK constraint on status
-- ----------------------------------------------------------------------------
CREATE TABLE user_stories (
    story_id            TEXT PRIMARY KEY,
    requirement_id      TEXT REFERENCES requirements(requirement_id) ON DELETE SET NULL,
    program_id          TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    parent_story_id     TEXT REFERENCES user_stories(story_id) ON DELETE SET NULL,
    -- Story content
    title               TEXT NOT NULL,
    user_story          TEXT,
    role                TEXT,
    capability          TEXT,
    benefit             TEXT,
    acceptance_criteria TEXT,
    success_metrics     TEXT,
    -- Classification
    priority            TEXT,
    category            TEXT REFERENCES story_categories(category_code) ON DELETE SET NULL,
    category_full       TEXT,
    is_technical        BOOLEAN DEFAULT TRUE,
    -- Workflow status with CHECK constraint
    status              TEXT DEFAULT 'Draft' CHECK (status IN (
                            'Draft',
                            'Internal Review',
                            'Pending Client Review',
                            'Approved',
                            'Needs Discussion',
                            'Out of Scope'
                        )),
    -- Review fields
    internal_notes      TEXT,
    meeting_context     TEXT,
    client_feedback     TEXT,
    -- Relationships (JSONB arrays)
    related_stories     JSONB DEFAULT '[]',  -- Changed from TEXT
    flags               JSONB DEFAULT '[]',  -- Changed from TEXT
    -- Planning
    roadmap_target      TEXT,
    version             INTEGER DEFAULT 1,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW(),
    approved_at         TIMESTAMPTZ,
    approved_by         TEXT,
    -- Workflow timestamps
    draft_date              TIMESTAMPTZ,
    internal_review_date    TIMESTAMPTZ,
    client_review_date      TIMESTAMPTZ,
    needs_discussion_date   TIMESTAMPTZ
);

COMMENT ON TABLE user_stories IS 'User stories generated from requirements with full lifecycle tracking';
COMMENT ON COLUMN user_stories.status IS 'Workflow status: Draft → Internal Review → Pending Client Review → Approved';
COMMENT ON COLUMN user_stories.related_stories IS 'JSONB array of related story IDs';
COMMENT ON COLUMN user_stories.flags IS 'JSONB array of flag objects for review';

CREATE INDEX idx_stories_program ON user_stories(program_id);
CREATE INDEX idx_stories_requirement ON user_stories(requirement_id) WHERE requirement_id IS NOT NULL;
CREATE INDEX idx_stories_status ON user_stories(status);
CREATE INDEX idx_stories_category ON user_stories(category) WHERE category IS NOT NULL;
CREATE INDEX idx_stories_parent ON user_stories(parent_story_id) WHERE parent_story_id IS NOT NULL;

CREATE TRIGGER trigger_user_stories_updated_at
    BEFORE UPDATE ON user_stories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE user_stories ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: story_reference
-- PURPOSE: Reference library of high-quality approved stories
-- CHANGES FROM SQLITE:
--   - keywords changed from TEXT to JSONB
-- ----------------------------------------------------------------------------
CREATE TABLE story_reference (
    reference_id    SERIAL PRIMARY KEY,
    story_id        TEXT NOT NULL REFERENCES user_stories(story_id) ON DELETE CASCADE,
    category        TEXT,
    keywords        JSONB DEFAULT '[]',  -- Changed from TEXT to JSONB array
    industry        TEXT,
    quality_score   INTEGER DEFAULT 3 CHECK (quality_score BETWEEN 1 AND 5),
    is_template     BOOLEAN DEFAULT FALSE,
    usage_count     INTEGER DEFAULT 0,
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE story_reference IS 'Reference library of high-quality approved stories for reuse';
COMMENT ON COLUMN story_reference.quality_score IS 'Quality rating 1-5 for prioritizing in search results';
COMMENT ON COLUMN story_reference.keywords IS 'JSONB array of searchable keywords';

CREATE INDEX idx_story_ref_story ON story_reference(story_id);
CREATE INDEX idx_story_ref_category ON story_reference(category) WHERE category IS NOT NULL;
CREATE INDEX idx_story_ref_template ON story_reference(is_template) WHERE is_template = TRUE;

ALTER TABLE story_reference ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: story_compliance_vetting
-- PURPOSE: Track which compliance frameworks apply to each story
-- ----------------------------------------------------------------------------
CREATE TABLE story_compliance_vetting (
    vetting_id          SERIAL PRIMARY KEY,
    story_id            TEXT NOT NULL REFERENCES user_stories(story_id) ON DELETE CASCADE,
    framework_id        TEXT NOT NULL REFERENCES compliance_frameworks(framework_id) ON DELETE CASCADE,
    applies             BOOLEAN,
    rationale           TEXT,
    test_cases_required INTEGER DEFAULT 0,
    test_cases_created  INTEGER DEFAULT 0,
    vetted_by           TEXT,
    vetted_at           TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_story_framework UNIQUE (story_id, framework_id)
);

COMMENT ON TABLE story_compliance_vetting IS 'Tracks which compliance frameworks apply to each user story';

CREATE INDEX idx_vetting_story ON story_compliance_vetting(story_id);
CREATE INDEX idx_vetting_framework ON story_compliance_vetting(framework_id);

ALTER TABLE story_compliance_vetting ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 7: UAT (User Acceptance Testing)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: uat_cycles
-- PURPOSE: UAT testing cycles/rounds
-- CHANGES FROM SQLITE:
--   - Changed INTEGER booleans to BOOLEAN
--   - Added CHECK constraint on status
-- ----------------------------------------------------------------------------
CREATE TABLE uat_cycles (
    cycle_id            TEXT PRIMARY KEY,
    program_id          TEXT REFERENCES programs(program_id) ON DELETE CASCADE,
    name                TEXT NOT NULL,
    description         TEXT,
    uat_type            TEXT NOT NULL,
    target_launch_date  DATE,
    -- Status with CHECK constraint
    status              TEXT DEFAULT 'planning' CHECK (status IN (
                            'planning',
                            'validation',
                            'kickoff',
                            'testing',
                            'review',
                            'retesting',
                            'decision',
                            'complete',
                            'cancelled'
                        )),
    -- People
    clinical_pm         TEXT,
    clinical_pm_email   TEXT,
    -- Key dates
    validation_start    DATE,
    validation_end      DATE,
    kickoff_date        DATE,
    testing_start       DATE,
    testing_end         DATE,
    review_date         DATE,
    retest_start        DATE,
    retest_end          DATE,
    go_nogo_date        DATE,
    -- Pre-UAT Gate
    pre_uat_gate_passed     BOOLEAN DEFAULT FALSE,  -- Changed from INTEGER
    pre_uat_gate_signed_by  TEXT,
    pre_uat_gate_signed_date DATE,
    pre_uat_gate_notes      TEXT,
    -- Go/No-Go Decision
    go_nogo_decision    TEXT,
    go_nogo_signed_by   TEXT,
    go_nogo_signed_date DATE,
    go_nogo_notes       TEXT,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          TEXT DEFAULT 'system'
);

COMMENT ON TABLE uat_cycles IS 'UAT testing cycles with full lifecycle tracking';
COMMENT ON COLUMN uat_cycles.status IS 'Cycle status: planning → validation → kickoff → testing → review → retesting → decision → complete';

CREATE INDEX idx_uat_cycles_program ON uat_cycles(program_id) WHERE program_id IS NOT NULL;
CREATE INDEX idx_uat_cycles_status ON uat_cycles(status);
CREATE INDEX idx_uat_cycles_launch ON uat_cycles(target_launch_date);

CREATE TRIGGER trigger_uat_cycles_updated_at
    BEFORE UPDATE ON uat_cycles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE uat_cycles ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: pre_uat_gate_items
-- PURPOSE: Checklist items for pre-UAT gate approval
-- CHANGES FROM SQLITE:
--   - Changed INTEGER booleans to BOOLEAN
-- ----------------------------------------------------------------------------
CREATE TABLE pre_uat_gate_items (
    item_id         SERIAL PRIMARY KEY,
    cycle_id        TEXT NOT NULL REFERENCES uat_cycles(cycle_id) ON DELETE CASCADE,
    category        TEXT NOT NULL,
    sequence        INTEGER DEFAULT 0,
    item_text       TEXT NOT NULL,
    is_required     BOOLEAN DEFAULT TRUE,   -- Changed from INTEGER
    is_complete     BOOLEAN DEFAULT FALSE,  -- Changed from INTEGER
    completed_by    TEXT,
    completed_date  DATE,
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE pre_uat_gate_items IS 'Checklist items that must be completed before UAT can begin';

CREATE INDEX idx_gate_items_cycle ON pre_uat_gate_items(cycle_id);

ALTER TABLE pre_uat_gate_items ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: uat_test_cases
-- PURPOSE: Individual test cases for UAT
-- CHANGES FROM SQLITE:
--   - patient_conditions changed from TEXT to JSONB
--   - Added CHECK constraint on test_status
--   - Added foreign keys that were missing
-- ----------------------------------------------------------------------------
CREATE TABLE uat_test_cases (
    test_id             TEXT PRIMARY KEY,
    story_id            TEXT REFERENCES user_stories(story_id) ON DELETE SET NULL,
    program_id          TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    uat_cycle_id        TEXT REFERENCES uat_cycles(cycle_id) ON DELETE SET NULL,
    -- Test definition
    title               TEXT NOT NULL,
    category            TEXT,
    test_type           TEXT REFERENCES test_types(type_code) ON DELETE SET NULL,
    prerequisites       TEXT,
    test_steps          TEXT,
    expected_results    TEXT,
    priority            TEXT,
    estimated_time      TEXT,
    -- Compliance
    compliance_framework    TEXT REFERENCES compliance_frameworks(framework_id) ON DELETE SET NULL,
    control_id              TEXT,
    is_compliance_test      BOOLEAN DEFAULT FALSE,
    compliance_template_id  TEXT REFERENCES compliance_test_templates(template_id) ON DELETE SET NULL,
    -- Execution status with CHECK constraint
    test_status         TEXT DEFAULT 'Not Run' CHECK (test_status IN (
                            'Not Run',
                            'Pass',
                            'Fail',
                            'Blocked',
                            'Skipped'
                        )),
    tested_by           TEXT,
    tested_date         TIMESTAMPTZ,
    execution_notes     TEXT,
    -- Defect tracking
    defect_id           TEXT,
    defect_description  TEXT,
    -- Assignment
    assigned_to         TEXT,
    assignment_type     TEXT,
    persona             TEXT,
    profile_id          TEXT,
    platform            TEXT,
    -- Workflow organization
    workflow_section    TEXT REFERENCES uat_workflow_sections(section_code) ON DELETE SET NULL,
    workflow_order      INTEGER DEFAULT 0,
    -- Change tracking
    change_id           TEXT,
    target_rule         TEXT,
    change_type         TEXT,
    -- Test conditions (JSONB instead of TEXT)
    patient_conditions  JSONB,  -- Changed from TEXT
    cross_trigger_check TEXT,
    -- Retest tracking
    retest_status       TEXT,
    retest_date         DATE,
    retest_by           TEXT,
    retest_notes        TEXT,
    -- Dev handoff
    dev_notes           TEXT,
    dev_status          TEXT,
    -- General notes
    notes               TEXT,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE uat_test_cases IS 'UAT test cases with full execution tracking';
COMMENT ON COLUMN uat_test_cases.test_status IS 'Execution status: Not Run, Pass, Fail, Blocked, Skipped';
COMMENT ON COLUMN uat_test_cases.patient_conditions IS 'JSONB: Patient conditions required for test';

CREATE INDEX idx_test_cases_story ON uat_test_cases(story_id) WHERE story_id IS NOT NULL;
CREATE INDEX idx_test_cases_program ON uat_test_cases(program_id);
CREATE INDEX idx_test_cases_cycle ON uat_test_cases(uat_cycle_id) WHERE uat_cycle_id IS NOT NULL;
CREATE INDEX idx_test_cases_status ON uat_test_cases(test_status);
CREATE INDEX idx_test_cases_compliance ON uat_test_cases(compliance_framework) WHERE compliance_framework IS NOT NULL;
CREATE INDEX idx_test_cases_workflow ON uat_test_cases(workflow_section) WHERE workflow_section IS NOT NULL;
CREATE INDEX idx_test_cases_assigned ON uat_test_cases(assigned_to) WHERE assigned_to IS NOT NULL;

CREATE TRIGGER trigger_uat_test_cases_updated_at
    BEFORE UPDATE ON uat_test_cases
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE uat_test_cases ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: uat_test_assignments
-- PURPOSE: Track test case assignments to testers
-- ----------------------------------------------------------------------------
CREATE TABLE uat_test_assignments (
    assignment_id   SERIAL PRIMARY KEY,
    test_id         TEXT NOT NULL REFERENCES uat_test_cases(test_id) ON DELETE CASCADE,
    cycle_id        TEXT NOT NULL REFERENCES uat_cycles(cycle_id) ON DELETE CASCADE,
    assigned_to     TEXT NOT NULL,
    assignment_type TEXT DEFAULT 'primary',
    assigned_date   TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_test_cycle_assignment UNIQUE (test_id, cycle_id, assigned_to)
);

COMMENT ON TABLE uat_test_assignments IS 'Tracks which testers are assigned to which tests in each cycle';

CREATE INDEX idx_assignments_test ON uat_test_assignments(test_id);
CREATE INDEX idx_assignments_cycle ON uat_test_assignments(cycle_id);
CREATE INDEX idx_assignments_assigned ON uat_test_assignments(assigned_to);

ALTER TABLE uat_test_assignments ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 8: TRACEABILITY AND COMPLIANCE GAPS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: traceability
-- PURPOSE: Links requirements → stories → test cases
-- CHANGES FROM SQLITE:
--   - Added missing foreign key constraints with ON DELETE SET NULL
-- ----------------------------------------------------------------------------
CREATE TABLE traceability (
    trace_id            SERIAL PRIMARY KEY,
    program_id          TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    requirement_id      TEXT REFERENCES requirements(requirement_id) ON DELETE SET NULL,
    story_id            TEXT REFERENCES user_stories(story_id) ON DELETE SET NULL,
    test_id             TEXT REFERENCES uat_test_cases(test_id) ON DELETE SET NULL,
    coverage_status     TEXT,
    gap_notes           TEXT,
    compliance_coverage TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE traceability IS 'Links requirements to stories to test cases for coverage tracking';
COMMENT ON COLUMN traceability.coverage_status IS 'Coverage level: Full, Partial, None, Not Applicable';

CREATE INDEX idx_traceability_program ON traceability(program_id);
CREATE INDEX idx_traceability_req ON traceability(requirement_id) WHERE requirement_id IS NOT NULL;
CREATE INDEX idx_traceability_story ON traceability(story_id) WHERE story_id IS NOT NULL;
CREATE INDEX idx_traceability_test ON traceability(test_id) WHERE test_id IS NOT NULL;

CREATE TRIGGER trigger_traceability_updated_at
    BEFORE UPDATE ON traceability
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE traceability ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: compliance_gaps
-- PURPOSE: Track compliance gaps identified during analysis
-- CHANGES FROM SQLITE:
--   - Added missing foreign key constraints
-- ----------------------------------------------------------------------------
CREATE TABLE compliance_gaps (
    gap_id          SERIAL PRIMARY KEY,
    program_id      TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    requirement_id  TEXT REFERENCES requirements(requirement_id) ON DELETE SET NULL,
    story_id        TEXT REFERENCES user_stories(story_id) ON DELETE SET NULL,
    -- Gap details
    framework       TEXT NOT NULL REFERENCES compliance_frameworks(framework_id) ON DELETE RESTRICT,
    control_id      TEXT,
    category        TEXT,
    gap_description TEXT NOT NULL,
    recommendation  TEXT,
    severity        TEXT CHECK (severity IN ('Critical', 'High', 'Medium', 'Low')),
    -- Tracking
    status          TEXT DEFAULT 'Open' CHECK (status IN ('Open', 'In Progress', 'Resolved', 'Accepted', 'Deferred')),
    mitigation_plan TEXT,
    owner           TEXT,
    due_date        DATE,
    closed_date     TIMESTAMPTZ,
    notes           TEXT,
    -- Timestamps
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE compliance_gaps IS 'Compliance gaps identified during requirements analysis';

CREATE INDEX idx_gaps_program ON compliance_gaps(program_id);
CREATE INDEX idx_gaps_framework ON compliance_gaps(framework);
CREATE INDEX idx_gaps_status ON compliance_gaps(status);
CREATE INDEX idx_gaps_severity ON compliance_gaps(severity) WHERE severity IS NOT NULL;
CREATE INDEX idx_gaps_owner ON compliance_gaps(owner) WHERE owner IS NOT NULL;

CREATE TRIGGER trigger_compliance_gaps_updated_at
    BEFORE UPDATE ON compliance_gaps
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE compliance_gaps ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 9: USER AND ACCESS MANAGEMENT
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: users
-- PURPOSE: System users (internal and external)
-- ----------------------------------------------------------------------------
CREATE TABLE users (
    user_id                 TEXT PRIMARY KEY,
    name                    TEXT NOT NULL,
    email                   TEXT,
    organization            TEXT DEFAULT 'Internal',
    is_business_associate   BOOLEAN DEFAULT FALSE,
    status                  TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Terminated')),
    notes                   TEXT,
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE users IS 'System users for access control and audit trail';
COMMENT ON COLUMN users.is_business_associate IS 'True if user is an external business associate (for HIPAA)';

CREATE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_org ON users(organization);

CREATE TRIGGER trigger_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: user_access
-- PURPOSE: Access grants to programs/clinics/locations
-- CHANGES FROM SQLITE:
--   - Removed is_active (redundant with status)
--   - Clarified status meanings
-- ----------------------------------------------------------------------------
CREATE TABLE user_access (
    access_id       SERIAL PRIMARY KEY,
    user_id         TEXT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    -- Access scope (only one should typically be set)
    program_id      TEXT REFERENCES programs(program_id) ON DELETE CASCADE,
    clinic_id       TEXT REFERENCES clinics(clinic_id) ON DELETE CASCADE,
    location_id     TEXT REFERENCES locations(location_id) ON DELETE CASCADE,
    -- Role and status
    role            TEXT NOT NULL,
    status          TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Suspended', 'Revoked', 'Expired')),
    -- Grant tracking
    granted_by      TEXT,
    granted_date    TIMESTAMPTZ DEFAULT NOW(),
    -- Revocation tracking
    revoked_by      TEXT,
    revoked_date    TIMESTAMPTZ,
    revoke_reason   TEXT,
    -- Review tracking
    next_review_due DATE,
    notes           TEXT
);

COMMENT ON TABLE user_access IS 'Access grants linking users to programs, clinics, or locations';
COMMENT ON COLUMN user_access.status IS 'Active, Suspended (temporary), Revoked (permanent), Expired (time-based)';

CREATE INDEX idx_access_user ON user_access(user_id);
CREATE INDEX idx_access_program ON user_access(program_id) WHERE program_id IS NOT NULL;
CREATE INDEX idx_access_clinic ON user_access(clinic_id) WHERE clinic_id IS NOT NULL;
CREATE INDEX idx_access_location ON user_access(location_id) WHERE location_id IS NOT NULL;
CREATE INDEX idx_access_status ON user_access(status);
CREATE INDEX idx_access_review ON user_access(next_review_due) WHERE next_review_due IS NOT NULL;

ALTER TABLE user_access ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: access_reviews
-- PURPOSE: Periodic access review records
-- ----------------------------------------------------------------------------
CREATE TABLE access_reviews (
    review_id       SERIAL PRIMARY KEY,
    access_id       INTEGER NOT NULL REFERENCES user_access(access_id) ON DELETE CASCADE,
    reviewed_by     TEXT NOT NULL,
    review_date     TIMESTAMPTZ DEFAULT NOW(),
    review_status   TEXT NOT NULL CHECK (review_status IN ('Approved', 'Revoked', 'Modified', 'Deferred')),
    notes           TEXT,
    next_review_due DATE
);

COMMENT ON TABLE access_reviews IS 'Audit trail of periodic access reviews';

CREATE INDEX idx_reviews_access ON access_reviews(access_id);
CREATE INDEX idx_reviews_date ON access_reviews(review_date);

ALTER TABLE access_reviews ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: user_training
-- PURPOSE: Training assignments and completions
-- ----------------------------------------------------------------------------
CREATE TABLE user_training (
    training_id             SERIAL PRIMARY KEY,
    user_id                 TEXT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    training_type           TEXT NOT NULL,
    assigned_date           TIMESTAMPTZ DEFAULT NOW(),
    assigned_by             TEXT,
    completed_date          DATE,
    expiration_date         DATE,
    certificate_reference   TEXT,
    status                  TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Expired', 'Waived')),
    responsibility          TEXT DEFAULT 'Propel Health',
    notes                   TEXT
);

COMMENT ON TABLE user_training IS 'Training assignments and completion tracking';

CREATE INDEX idx_training_user ON user_training(user_id);
CREATE INDEX idx_training_status ON user_training(status);
CREATE INDEX idx_training_expiration ON user_training(expiration_date) WHERE expiration_date IS NOT NULL;

ALTER TABLE user_training ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 10: AUDIT HISTORY
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: audit_history
-- PURPOSE: Complete audit trail for all changes (FDA Part 11 compliant)
-- ----------------------------------------------------------------------------
CREATE TABLE audit_history (
    audit_id        SERIAL PRIMARY KEY,
    -- What was changed
    record_type     TEXT NOT NULL,
    record_id       TEXT NOT NULL,
    entity_type     TEXT,
    entity_id       TEXT,
    -- Change details
    action          TEXT NOT NULL,
    field_changed   TEXT,
    old_value       TEXT,
    new_value       TEXT,
    -- Who/when/why
    changed_by      TEXT DEFAULT 'system',
    changed_at      TIMESTAMPTZ DEFAULT NOW(),
    change_reason   TEXT,
    -- Session tracking
    session_id      TEXT,
    ip_address      INET  -- PostgreSQL native IP type
);

COMMENT ON TABLE audit_history IS 'Complete audit trail for FDA 21 CFR Part 11 compliance';
COMMENT ON COLUMN audit_history.action IS 'Action type: Created, Updated, Deleted, Status Changed, Approved, etc.';

CREATE INDEX idx_audit_record ON audit_history(record_type, record_id);
CREATE INDEX idx_audit_date ON audit_history(changed_at);
CREATE INDEX idx_audit_user ON audit_history(changed_by);
CREATE INDEX idx_audit_entity ON audit_history(entity_type, entity_id) WHERE entity_type IS NOT NULL;

ALTER TABLE audit_history ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 11: ONBOARDING PROJECTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: onboarding_projects
-- PURPOSE: Track clinic onboarding projects
-- ----------------------------------------------------------------------------
CREATE TABLE onboarding_projects (
    project_id          TEXT PRIMARY KEY,
    program_id          TEXT NOT NULL REFERENCES programs(program_id) ON DELETE CASCADE,
    clinic_id           TEXT REFERENCES clinics(clinic_id) ON DELETE SET NULL,
    project_name        TEXT NOT NULL,
    clinic_name         TEXT NOT NULL,
    -- Status with CHECK constraint
    status              TEXT DEFAULT 'INTAKE' CHECK (status IN (
                            'INTAKE',
                            'IN_PROGRESS',
                            'UAT_READY',
                            'LAUNCHED',
                            'ON_HOLD'
                        )),
    -- Dates
    target_launch_date  DATE,
    actual_launch_date  DATE,
    -- People
    client_contact_name     TEXT,
    client_contact_email    TEXT,
    propel_lead             TEXT,
    -- Notes
    notes               TEXT,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          TEXT DEFAULT 'system',
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE onboarding_projects IS 'Clinic onboarding project tracking';

CREATE INDEX idx_onb_projects_program ON onboarding_projects(program_id);
CREATE INDEX idx_onb_projects_clinic ON onboarding_projects(clinic_id) WHERE clinic_id IS NOT NULL;
CREATE INDEX idx_onb_projects_status ON onboarding_projects(status);
CREATE INDEX idx_onb_projects_launch ON onboarding_projects(target_launch_date);

CREATE TRIGGER trigger_onboarding_projects_updated_at
    BEFORE UPDATE ON onboarding_projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE onboarding_projects ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: onboarding_milestones
-- PURPOSE: Milestones within onboarding projects
-- ----------------------------------------------------------------------------
CREATE TABLE onboarding_milestones (
    milestone_id            SERIAL PRIMARY KEY,
    project_id              TEXT NOT NULL REFERENCES onboarding_projects(project_id) ON DELETE CASCADE,
    milestone_type          TEXT NOT NULL,
    milestone_name          TEXT NOT NULL,
    sequence_order          INTEGER NOT NULL,
    -- Status with CHECK constraint
    status                  TEXT DEFAULT 'NOT_STARTED' CHECK (status IN (
                                'NOT_STARTED',
                                'IN_PROGRESS',
                                'COMPLETE',
                                'BLOCKED'
                            )),
    -- Dates
    target_date             DATE,
    actual_completion_date  DATE,
    completed_by            TEXT,
    -- Auto-verification
    auto_verify_type        TEXT,
    auto_verified_date      TIMESTAMPTZ,
    auto_verified_result    BOOLEAN,
    -- Notes
    notes                   TEXT,
    blocker_reason          TEXT,
    -- Timestamps
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_project_milestone UNIQUE (project_id, milestone_type)
);

COMMENT ON TABLE onboarding_milestones IS 'Milestone tracking within onboarding projects';

CREATE INDEX idx_onb_milestones_project ON onboarding_milestones(project_id);
CREATE INDEX idx_onb_milestones_status ON onboarding_milestones(status);

CREATE TRIGGER trigger_onboarding_milestones_updated_at
    BEFORE UPDATE ON onboarding_milestones
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE onboarding_milestones ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: onboarding_dependencies
-- PURPOSE: External dependencies for onboarding projects
-- ----------------------------------------------------------------------------
CREATE TABLE onboarding_dependencies (
    dependency_id       SERIAL PRIMARY KEY,
    project_id          TEXT NOT NULL REFERENCES onboarding_projects(project_id) ON DELETE CASCADE,
    milestone_id        INTEGER REFERENCES onboarding_milestones(milestone_id) ON DELETE SET NULL,
    dependency_type     TEXT NOT NULL,
    description         TEXT NOT NULL,
    external_reference  TEXT,
    external_system     TEXT,
    -- Owner
    owner               TEXT,
    owner_email         TEXT,
    -- Status with CHECK constraint
    status              TEXT DEFAULT 'PENDING' CHECK (status IN (
                            'PENDING',
                            'IN_PROGRESS',
                            'RESOLVED',
                            'CANCELLED'
                        )),
    -- Dates
    due_date            DATE,
    resolved_date       DATE,
    resolved_by         TEXT,
    resolution_notes    TEXT,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          TEXT DEFAULT 'system',
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE onboarding_dependencies IS 'External dependencies blocking onboarding progress';

CREATE INDEX idx_onb_deps_project ON onboarding_dependencies(project_id);
CREATE INDEX idx_onb_deps_milestone ON onboarding_dependencies(milestone_id) WHERE milestone_id IS NOT NULL;
CREATE INDEX idx_onb_deps_status ON onboarding_dependencies(status);

CREATE TRIGGER trigger_onboarding_dependencies_updated_at
    BEFORE UPDATE ON onboarding_dependencies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE onboarding_dependencies ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: onboarding_submissions (NEW)
-- PURPOSE: Web-based onboarding form submissions
-- ----------------------------------------------------------------------------
CREATE TABLE onboarding_submissions (
    submission_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submitter_email     TEXT NOT NULL,
    submitter_name      TEXT,
    program_prefix      TEXT NOT NULL,
    -- Status with CHECK constraint
    submission_status   TEXT DEFAULT 'draft' CHECK (submission_status IN (
                            'draft',
                            'submitted',
                            'reviewed',
                            'approved',
                            'imported',
                            'rejected'
                        )),
    -- Form data
    form_data           JSONB NOT NULL DEFAULT '{}',
    current_step        INTEGER DEFAULT 1,
    completed_steps     INTEGER[] DEFAULT '{}',
    -- Review workflow
    submitted_at        TIMESTAMPTZ,
    reviewed_by         TEXT,
    reviewed_at         TIMESTAMPTZ,
    review_notes        TEXT,
    -- Import tracking
    imported_clinic_id  TEXT REFERENCES clinics(clinic_id) ON DELETE SET NULL,
    imported_at         TIMESTAMPTZ,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE onboarding_submissions IS 'Web form submissions for clinic onboarding';
COMMENT ON COLUMN onboarding_submissions.form_data IS 'JSONB: Complete form data from multi-step wizard';
COMMENT ON COLUMN onboarding_submissions.completed_steps IS 'Array of completed step numbers';

CREATE INDEX idx_submissions_email ON onboarding_submissions(submitter_email);
CREATE INDEX idx_submissions_status ON onboarding_submissions(submission_status);
CREATE INDEX idx_submissions_prefix ON onboarding_submissions(program_prefix);
CREATE INDEX idx_submissions_imported ON onboarding_submissions(imported_clinic_id) WHERE imported_clinic_id IS NOT NULL;

CREATE TRIGGER trigger_onboarding_submissions_updated_at
    BEFORE UPDATE ON onboarding_submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE onboarding_submissions ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- SECTION 12: ROADMAP AND PROJECT PLANNING
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: roadmap_projects
-- PURPOSE: Projects shown on the roadmap timeline
-- ----------------------------------------------------------------------------
CREATE TABLE roadmap_projects (
    project_id          TEXT PRIMARY KEY,
    name                TEXT NOT NULL,
    full_name           TEXT NOT NULL,
    program_prefix      TEXT,
    -- Type with CHECK constraint
    project_type        TEXT NOT NULL CHECK (project_type IN (
                            'onboarding',
                            'integration',
                            'feature',
                            'migration',
                            'nccn',
                            'maintenance',
                            'program_launch'
                        )),
    -- Dates
    start_date          DATE NOT NULL,
    end_date            DATE NOT NULL,
    -- Status with CHECK constraint
    status              TEXT NOT NULL DEFAULT 'planned' CHECK (status IN (
                            'planned',
                            'in_progress',
                            'completed',
                            'on_hold',
                            'at_risk'
                        )),
    priority            INTEGER CHECK (priority BETWEEN 1 AND 4),
    row_number          INTEGER NOT NULL CHECK (row_number BETWEEN 1 AND 20),
    notes               TEXT,
    -- Link to onboarding
    onboarding_project_id TEXT REFERENCES onboarding_projects(project_id) ON DELETE SET NULL,
    -- Timestamps
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE roadmap_projects IS 'Projects displayed on the roadmap timeline';

CREATE INDEX idx_roadmap_status ON roadmap_projects(status);
CREATE INDEX idx_roadmap_type ON roadmap_projects(project_type);
CREATE INDEX idx_roadmap_dates ON roadmap_projects(start_date, end_date);
CREATE INDEX idx_roadmap_onboarding ON roadmap_projects(onboarding_project_id) WHERE onboarding_project_id IS NOT NULL;

CREATE TRIGGER trigger_roadmap_projects_updated_at
    BEFORE UPDATE ON roadmap_projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE roadmap_projects ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: roadmap_project_clinics
-- PURPOSE: Link roadmap projects to clinics
-- ----------------------------------------------------------------------------
CREATE TABLE roadmap_project_clinics (
    id              SERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES roadmap_projects(project_id) ON DELETE CASCADE,
    clinic_id       TEXT NOT NULL REFERENCES clinics(clinic_id) ON DELETE CASCADE,

    CONSTRAINT unique_project_clinic UNIQUE (project_id, clinic_id)
);

COMMENT ON TABLE roadmap_project_clinics IS 'Links roadmap projects to involved clinics';

CREATE INDEX idx_rpc_project ON roadmap_project_clinics(project_id);
CREATE INDEX idx_rpc_clinic ON roadmap_project_clinics(clinic_id);

ALTER TABLE roadmap_project_clinics ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Table: roadmap_dependencies
-- PURPOSE: Dependencies between roadmap projects
-- ----------------------------------------------------------------------------
CREATE TABLE roadmap_dependencies (
    dependency_id       SERIAL PRIMARY KEY,
    blocked_project_id  TEXT NOT NULL REFERENCES roadmap_projects(project_id) ON DELETE CASCADE,
    blocking_project_id TEXT NOT NULL REFERENCES roadmap_projects(project_id) ON DELETE CASCADE,
    dependency_color    TEXT CHECK (dependency_color IN ('blue', 'green', 'purple', 'orange')),
    is_key_dependency   BOOLEAN DEFAULT FALSE,
    notes               TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE roadmap_dependencies IS 'Dependencies between roadmap projects for visualization';

CREATE INDEX idx_roadmap_deps_blocked ON roadmap_dependencies(blocked_project_id);
CREATE INDEX idx_roadmap_deps_blocking ON roadmap_dependencies(blocking_project_id);

ALTER TABLE roadmap_dependencies ENABLE ROW LEVEL SECURITY;


-- ============================================================================
-- VERIFICATION QUERIES (Run after migration to verify schema)
-- ============================================================================

-- List all tables with row counts (placeholder - run after data migration)
-- SELECT schemaname, tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- List all foreign keys
-- SELECT tc.table_name, kcu.column_name, ccu.table_name AS foreign_table
-- FROM information_schema.table_constraints AS tc
-- JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
-- JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
-- WHERE tc.constraint_type = 'FOREIGN KEY';

-- List all indexes
-- SELECT tablename, indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename;

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
