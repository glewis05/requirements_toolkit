-- ============================================================================
-- Propel Health Database - Seed Data for Lookup Tables
-- Version: 1.0.0
-- Generated: 2026-01-20
--
-- This file populates the lookup/reference tables with initial values.
-- Run this AFTER 001_schema.sql and BEFORE migrating production data.
-- ============================================================================

-- ============================================================================
-- PRIORITY LEVELS (MoSCoW Method)
-- ============================================================================
-- These are the standard priority levels used across requirements, stories,
-- and test cases. Based on MoSCoW prioritization method.
-- ============================================================================

INSERT INTO priority_levels (priority_code, priority_name, display_order, color_hex, description) VALUES
    ('Must Have',    'Must Have',    1, '#DC2626', 'Critical requirements that must be delivered. Without these, the solution is not viable.'),
    ('Should Have',  'Should Have',  2, '#F59E0B', 'Important requirements that should be included if possible. High value but not critical.'),
    ('Could Have',   'Could Have',   3, '#3B82F6', 'Desirable requirements that could be included if time and resources permit.'),
    ('Won''t Have',  'Won''t Have',  4, '#6B7280', 'Requirements explicitly agreed to be out of scope for this release/phase.')
ON CONFLICT (priority_code) DO NOTHING;

-- Legacy/alternate priority codes (map to standard)
INSERT INTO priority_levels (priority_code, priority_name, display_order, color_hex, description) VALUES
    ('Critical', 'Critical',  1, '#DC2626', 'Alias for Must Have - highest priority'),
    ('High',     'High',      2, '#F59E0B', 'Alias for Should Have - important but not blocking'),
    ('Medium',   'Medium',    3, '#3B82F6', 'Alias for Could Have - nice to have'),
    ('Low',      'Low',       4, '#6B7280', 'Alias for Won''t Have - future consideration')
ON CONFLICT (priority_code) DO NOTHING;


-- ============================================================================
-- STORY CATEGORIES
-- ============================================================================
-- Categories used for user story classification and ID generation.
-- The category_code becomes part of the story ID: PREFIX-CATEGORY-SEQ
-- ============================================================================

INSERT INTO story_categories (category_code, category_name, description, display_order) VALUES
    -- Core functional categories
    ('RECRUIT',  'Recruitment',          'Patient recruitment, enrollment, consent, and outreach', 10),
    ('MSG',      'Messaging',            'Email, SMS, notifications, reminders, and communication', 20),
    ('DASH',     'Dashboard',            'Data visualization, metrics display, and analytics dashboards', 30),
    ('REPORT',   'Reporting',            'Reports, exports, and scheduled report delivery', 40),
    ('DATA',     'Data Entry',           'Forms, input validation, and data capture', 50),
    ('WF',       'Workflow',             'Process changes, workflow automation, and business rules', 60),
    ('INT',      'Integration',          'API integrations, data sync, and cross-system communication', 70),
    ('ACCESS',   'Access Control',       'Authentication, authorization, and permissions', 80),
    ('AUDIT',    'Audit & Compliance',   'Audit trail, compliance logging, and regulatory features', 90),

    -- Healthcare-specific categories
    ('PAT',      'Patient Management',   'Patient records, demographics, and care coordination', 100),
    ('PROV',     'Provider Management',  'Provider information, credentials, and scheduling', 110),
    ('APPT',     'Appointments',         'Appointment scheduling, availability, and confirmations', 120),
    ('ELIG',     'Eligibility',          'Insurance eligibility, coverage verification, and benefits', 130),
    ('BILL',     'Billing',              'Claims, payments, and financial transactions', 140),

    -- Technical categories
    ('PERF',     'Performance',          'Performance optimization, caching, and scalability', 150),
    ('SEC',      'Security',             'Security enhancements, encryption, and vulnerability fixes', 160),
    ('MAINT',    'Maintenance',          'Bug fixes, tech debt, and maintenance tasks', 170),
    ('INFRA',    'Infrastructure',       'DevOps, deployment, and infrastructure changes', 180),

    -- General/fallback
    ('GEN',      'General',              'General requirements that don''t fit other categories', 999)
ON CONFLICT (category_code) DO NOTHING;


-- ============================================================================
-- TEST TYPES
-- ============================================================================
-- Types of UAT test cases for categorization and reporting.
-- ============================================================================

INSERT INTO test_types (type_code, type_name, description, is_compliance) VALUES
    -- Functional testing
    ('functional',    'Functional Test',      'Verifies feature works as specified', FALSE),
    ('validation',    'Validation Test',      'Validates data entry and business rules', FALSE),
    ('integration',   'Integration Test',     'Tests cross-system data flow and APIs', FALSE),
    ('regression',    'Regression Test',      'Ensures existing functionality not broken', FALSE),
    ('edge_case',     'Edge Case Test',       'Tests boundary conditions and unusual scenarios', FALSE),
    ('negative',      'Negative Test',        'Tests error handling and invalid inputs', FALSE),

    -- User experience testing
    ('usability',     'Usability Test',       'Evaluates user experience and workflow efficiency', FALSE),
    ('accessibility', 'Accessibility Test',   'WCAG compliance and assistive technology support', FALSE),

    -- Performance testing
    ('performance',   'Performance Test',     'Load testing, response times, and scalability', FALSE),

    -- Compliance testing
    ('hipaa',         'HIPAA Compliance',     'HIPAA privacy and security rule compliance', TRUE),
    ('part11',        'FDA Part 11',          '21 CFR Part 11 electronic records compliance', TRUE),
    ('soc2',          'SOC 2 Control',        'SOC 2 Type II control testing', TRUE),
    ('audit_trail',   'Audit Trail Test',     'Verifies audit logging requirements', TRUE),
    ('access_control','Access Control Test',  'Tests RBAC and permission enforcement', TRUE),

    -- Specialized testing
    ('data_migration','Data Migration Test',  'Validates data integrity after migration', FALSE),
    ('backup_restore','Backup/Restore Test',  'Tests backup and recovery procedures', FALSE)
ON CONFLICT (type_code) DO NOTHING;


-- ============================================================================
-- UAT WORKFLOW SECTIONS
-- ============================================================================
-- Sections for organizing test execution in a logical workflow.
-- Testers progress through these sections in order.
-- ============================================================================

INSERT INTO uat_workflow_sections (section_code, section_name, section_description, guidance_text, display_order) VALUES
    ('SETUP',     'Test Setup',           'Prerequisites and environment preparation',
        'Complete all setup steps before beginning functional testing. Verify test accounts, data, and access.', 10),

    ('LOGIN',     'Authentication',       'Login, logout, and session management tests',
        'Test all authentication scenarios including valid login, invalid credentials, session timeout, and logout.', 20),

    ('NAV',       'Navigation',           'Menu navigation and page access tests',
        'Verify all menu items are accessible based on user role and navigate to correct pages.', 30),

    ('DATA',      'Data Entry',           'Form submission and data validation tests',
        'Test all data entry forms with valid data, invalid data, required fields, and boundary values.', 40),

    ('DISPLAY',   'Data Display',         'Screen display and data visualization tests',
        'Verify data displays correctly, formatting is proper, and calculations are accurate.', 50),

    ('WORKFLOW',  'Workflow Actions',     'Business process and workflow tests',
        'Test complete business workflows from start to finish, including all branches and decision points.', 60),

    ('REPORT',    'Reports & Exports',    'Report generation and data export tests',
        'Test all reports generate correctly, exports contain expected data, and formats are correct.', 70),

    ('NOTIFY',    'Notifications',        'Email, SMS, and in-app notification tests',
        'Verify notifications are sent at correct times, to correct recipients, with correct content.', 80),

    ('INTEG',     'Integration',          'External system integration tests',
        'Test data flows to/from external systems, API responses, and sync accuracy.', 90),

    ('SECURITY',  'Security & Access',    'Access control and security tests',
        'Verify role-based access, permission restrictions, and security controls.', 100),

    ('AUDIT',     'Audit Trail',          'Audit logging verification tests',
        'Verify all required actions are logged with correct details for compliance.', 110),

    ('CLEANUP',   'Test Cleanup',         'Data cleanup and environment reset',
        'Remove test data and reset environment for next test cycle.', 999)
ON CONFLICT (section_code) DO NOTHING;


-- ============================================================================
-- COMPLIANCE FRAMEWORKS
-- ============================================================================
-- Regulatory frameworks applicable to healthcare technology.
-- ============================================================================

INSERT INTO compliance_frameworks (framework_id, framework_name, full_name, description, regulation_url, applies_when, is_active) VALUES
    ('HIPAA',   'HIPAA',    'Health Insurance Portability and Accountability Act',
        'Federal law protecting patient health information (PHI) privacy and security.',
        'https://www.hhs.gov/hipaa/index.html',
        'Always applies when handling Protected Health Information (PHI)', TRUE),

    ('PART11',  'Part 11',  'FDA 21 CFR Part 11',
        'FDA regulations for electronic records and electronic signatures in FDA-regulated industries.',
        'https://www.ecfr.gov/current/title-21/chapter-I/subchapter-A/part-11',
        'Applies when electronic records are used for FDA submissions or regulated activities', TRUE),

    ('SOC2',    'SOC 2',    'SOC 2 Type II',
        'AICPA auditing standard for service organization controls (Security, Availability, Processing Integrity, Confidentiality, Privacy).',
        'https://www.aicpa.org/interestareas/frc/assuranceadvisoryservices/aaborgsocs.html',
        'Required by enterprise clients and when handling sensitive data', TRUE),

    ('HITECH',  'HITECH',   'Health Information Technology for Economic and Clinical Health Act',
        'Expands HIPAA requirements, increases penalties, and promotes health IT adoption.',
        'https://www.hhs.gov/hipaa/for-professionals/special-topics/hitech-act-enforcement-interim-final-rule/index.html',
        'Applies alongside HIPAA for breach notification and increased penalties', TRUE),

    ('GDPR',    'GDPR',     'General Data Protection Regulation',
        'European Union regulation on data protection and privacy.',
        'https://gdpr.eu/',
        'Applies when processing data of EU residents', FALSE),

    ('CCPA',    'CCPA',     'California Consumer Privacy Act',
        'California state law giving consumers control over personal information.',
        'https://oag.ca.gov/privacy/ccpa',
        'Applies when processing data of California residents', FALSE),

    ('HITRUST', 'HITRUST',  'HITRUST CSF',
        'Healthcare industry security framework combining multiple standards.',
        'https://hitrustalliance.net/',
        'Optional certification demonstrating comprehensive security controls', FALSE)
ON CONFLICT (framework_id) DO NOTHING;


-- ============================================================================
-- COMPLIANCE TEST TEMPLATES
-- ============================================================================
-- Standard test templates for compliance testing.
-- These provide consistent test procedures across projects.
-- ============================================================================

-- HIPAA Test Templates
INSERT INTO compliance_test_templates (template_id, framework_id, template_name, test_type, description, applies_when, standard_test_steps, standard_expected_result, is_active) VALUES
    ('HIPAA-ACCESS-001', 'HIPAA', 'Minimum Necessary Access', 'access_control',
        'Verify users only have access to PHI necessary for their job function.',
        'Any feature that displays or processes PHI',
        '1. Login as user with limited role
2. Attempt to access patient records
3. Verify only authorized data is visible
4. Document any excess access',
        'User can only view/modify PHI required for their specific job function. No excess access to patient records.', TRUE),

    ('HIPAA-AUDIT-001', 'HIPAA', 'PHI Access Audit Trail', 'audit_trail',
        'Verify all PHI access is logged with required details.',
        'Any feature that accesses PHI',
        '1. Access patient record
2. View, create, update, or delete PHI
3. Query audit log
4. Verify log contains: user, timestamp, action, record accessed',
        'All PHI access logged with user ID, timestamp, action type, and record identifier.', TRUE),

    ('HIPAA-ENCRYPT-001', 'HIPAA', 'PHI Encryption at Rest', 'security',
        'Verify PHI is encrypted when stored.',
        'Any storage of PHI (database, files, backups)',
        '1. Identify PHI storage locations
2. Verify encryption is enabled
3. Attempt to read raw data without decryption
4. Document encryption method used',
        'PHI is encrypted at rest using AES-256 or equivalent. Raw data is unreadable without proper decryption.', TRUE),

-- Part 11 Test Templates
    ('PART11-ESIG-001', 'PART11', 'Electronic Signature Validation', 'validation',
        'Verify electronic signatures meet Part 11 requirements.',
        'Any feature requiring approval or sign-off',
        '1. Navigate to approval workflow
2. Submit for approval
3. Verify signature captures: user ID, date/time, meaning
4. Attempt to modify signed record
5. Verify modification is prevented or creates new version',
        'Electronic signature includes user identification, date/time, and meaning of signature. Signed records are protected from modification.', TRUE),

    ('PART11-AUDIT-001', 'PART11', 'Complete Audit Trail', 'audit_trail',
        'Verify audit trail captures all required information.',
        'All electronic records subject to Part 11',
        '1. Create new record
2. Modify record multiple times
3. Query audit trail
4. Verify trail shows: who, what, when, old values, new values',
        'Audit trail captures operator ID, timestamp, old value, new value for every change. Trail cannot be modified.', TRUE),

    ('PART11-ACCESS-001', 'PART11', 'Authority Checks', 'access_control',
        'Verify system limits access to authorized individuals.',
        'All system functions',
        '1. Attempt access without login
2. Attempt access with wrong role
3. Verify access denied appropriately
4. Test with correct credentials and role',
        'System requires authentication and authorization. Access denied for unauthorized users. Authorized users can access only permitted functions.', TRUE),

-- SOC 2 Test Templates
    ('SOC2-CHANGE-001', 'SOC2', 'Change Management Process', 'validation',
        'Verify changes follow documented change management process.',
        'Any system changes (code, config, infrastructure)',
        '1. Review change request documentation
2. Verify approval workflow was followed
3. Confirm testing was completed
4. Verify deployment followed procedures',
        'Change has documented request, appropriate approvals, test results, and deployment confirmation.', TRUE),

    ('SOC2-INCIDENT-001', 'SOC2', 'Incident Response', 'validation',
        'Verify incident response procedures are documented and tested.',
        'Security incidents and system failures',
        '1. Review incident response plan
2. Verify escalation procedures are documented
3. Confirm communication templates exist
4. Verify post-incident review process',
        'Incident response plan exists with clear escalation paths, communication templates, and post-incident review procedures.', TRUE),

    ('SOC2-BACKUP-001', 'SOC2', 'Backup and Recovery', 'backup_restore',
        'Verify backup and recovery procedures are tested.',
        'All critical data and systems',
        '1. Verify backup schedule is documented
2. Confirm backups are encrypted
3. Test restore from backup
4. Document recovery time',
        'Backups run on schedule, are encrypted, and can be restored within documented RTO.', TRUE)
ON CONFLICT (template_id) DO NOTHING;


-- ============================================================================
-- ROLE CONFLICTS (Segregation of Duties)
-- ============================================================================
-- Define role combinations that require review or are prohibited.
-- ============================================================================

INSERT INTO role_conflicts (role_a, role_b, severity, description) VALUES
    ('Developer',     'Production Admin',  'Critical',  'Developer should not have production admin access - risk of unauthorized changes'),
    ('Developer',     'Approver',          'Critical',  'Developer cannot approve their own code changes'),
    ('Submitter',     'Approver',          'Critical',  'Person submitting request cannot approve it'),
    ('Data Admin',    'Audit Reviewer',    'Warning',   'Data admin reviewing their own audit logs creates conflict'),
    ('Test Lead',     'Test Executor',     'Warning',   'Test lead executing their own test cases reduces oversight'),
    ('Billing Admin', 'Payment Approver',  'Critical',  'Same person cannot manage billing and approve payments')
ON CONFLICT DO NOTHING;


-- ============================================================================
-- ROADMAP ACTIVITY TYPES
-- ============================================================================
-- Types of activities that can appear on the roadmap.
-- ============================================================================

INSERT INTO roadmap_activity_types (type_code, type_name, default_color) VALUES
    ('onboarding',     'Clinic Onboarding',     '#10B981'),  -- Green
    ('integration',    'Integration',           '#3B82F6'),  -- Blue
    ('feature',        'New Feature',           '#8B5CF6'),  -- Purple
    ('migration',      'Data Migration',        '#F59E0B'),  -- Amber
    ('nccn',           'NCCN Update',           '#EF4444'),  -- Red
    ('maintenance',    'Maintenance',           '#6B7280'),  -- Gray
    ('program_launch', 'Program Launch',        '#EC4899'),  -- Pink
    ('uat',            'UAT Cycle',             '#14B8A6'),  -- Teal
    ('training',       'Training',              '#F97316'),  -- Orange
    ('go_live',        'Go-Live',               '#22C55E')   -- Bright Green
ON CONFLICT (type_code) DO NOTHING;


-- ============================================================================
-- ROADMAP DEFAULT CONFIG
-- ============================================================================
-- Default configuration for roadmap display.
-- ============================================================================

INSERT INTO roadmap_config (config_key, config_value) VALUES
    ('default_view',         'quarter'),
    ('show_dependencies',    'true'),
    ('show_milestones',      'true'),
    ('row_height',           '40'),
    ('weekend_shading',      'true'),
    ('today_marker',         'true'),
    ('color_by',             'project_type'),
    ('start_date_offset',    '-30'),
    ('end_date_offset',      '180')
ON CONFLICT (config_key) DO UPDATE SET
    config_value = EXCLUDED.config_value,
    updated_at = NOW();


-- ============================================================================
-- COMPANY HOLIDAYS (Example - adjust for your organization)
-- ============================================================================
-- Standard US holidays for 2025-2026. Update annually.
-- ============================================================================

INSERT INTO roadmap_holidays (holiday_date, name, icon) VALUES
    -- 2025 Holidays
    ('2025-01-01', 'New Year''s Day',          '🎆'),
    ('2025-01-20', 'MLK Day',                  '✊'),
    ('2025-02-17', 'Presidents Day',           '🏛️'),
    ('2025-05-26', 'Memorial Day',             '🎖️'),
    ('2025-06-19', 'Juneteenth',               '✊'),
    ('2025-07-04', 'Independence Day',         '🇺🇸'),
    ('2025-09-01', 'Labor Day',                '👷'),
    ('2025-10-13', 'Columbus Day',             '⛵'),
    ('2025-11-11', 'Veterans Day',             '🎖️'),
    ('2025-11-27', 'Thanksgiving',             '🦃'),
    ('2025-11-28', 'Day After Thanksgiving',   '🛒'),
    ('2025-12-24', 'Christmas Eve',            '🎄'),
    ('2025-12-25', 'Christmas Day',            '🎁'),
    ('2025-12-31', 'New Year''s Eve',          '🎊'),

    -- 2026 Holidays
    ('2026-01-01', 'New Year''s Day',          '🎆'),
    ('2026-01-19', 'MLK Day',                  '✊'),
    ('2026-02-16', 'Presidents Day',           '🏛️'),
    ('2026-05-25', 'Memorial Day',             '🎖️'),
    ('2026-06-19', 'Juneteenth',               '✊'),
    ('2026-07-03', 'Independence Day (Observed)', '🇺🇸'),
    ('2026-09-07', 'Labor Day',                '👷'),
    ('2026-10-12', 'Columbus Day',             '⛵'),
    ('2026-11-11', 'Veterans Day',             '🎖️'),
    ('2026-11-26', 'Thanksgiving',             '🦃'),
    ('2026-11-27', 'Day After Thanksgiving',   '🛒'),
    ('2026-12-24', 'Christmas Eve',            '🎄'),
    ('2026-12-25', 'Christmas Day',            '🎁'),
    ('2026-12-31', 'New Year''s Eve',          '🎊')
ON CONFLICT (holiday_date) DO UPDATE SET
    name = EXCLUDED.name,
    icon = EXCLUDED.icon;


-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Run these to verify seed data was loaded correctly.
-- ============================================================================

-- Verify counts
DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM priority_levels;
    RAISE NOTICE 'Priority levels: %', v_count;

    SELECT COUNT(*) INTO v_count FROM story_categories;
    RAISE NOTICE 'Story categories: %', v_count;

    SELECT COUNT(*) INTO v_count FROM test_types;
    RAISE NOTICE 'Test types: %', v_count;

    SELECT COUNT(*) INTO v_count FROM uat_workflow_sections;
    RAISE NOTICE 'Workflow sections: %', v_count;

    SELECT COUNT(*) INTO v_count FROM compliance_frameworks;
    RAISE NOTICE 'Compliance frameworks: %', v_count;

    SELECT COUNT(*) INTO v_count FROM compliance_test_templates;
    RAISE NOTICE 'Compliance templates: %', v_count;

    SELECT COUNT(*) INTO v_count FROM role_conflicts;
    RAISE NOTICE 'Role conflicts: %', v_count;

    SELECT COUNT(*) INTO v_count FROM roadmap_holidays;
    RAISE NOTICE 'Roadmap holidays: %', v_count;
END $$;

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================
