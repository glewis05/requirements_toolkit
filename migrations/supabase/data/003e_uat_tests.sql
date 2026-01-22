-- ==========================================================================
-- UAT CYCLES AND TEST CASES DATA
-- Exported: 2026-01-20T11:41:54.460653
-- ==========================================================================

ALTER TABLE uat_cycles DISABLE TRIGGER ALL;
ALTER TABLE uat_test_cases DISABLE TRIGGER ALL;

-- UAT CYCLES
INSERT INTO uat_cycles (
    cycle_id, program_id, name, description, uat_type, target_launch_date, status,
    clinical_pm, clinical_pm_email, pre_uat_gate_passed, created_at, updated_at, created_by
) VALUES (
    'UAT-ONB-853A06E9', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'ONB Questionnaire v1', 'GitHub Pages onboarding questionnaire - internal validation before client pilot. Tests cover auto-save/resume (SAVE), form steps (STEP), validation patterns (FORM), and gene selector (GENE).',
    'feature', '2025-05-02'::DATE, 'planning', 'Glen Lewis',
    NULL, FALSE,
    COALESCE('2026-01-12 22:26:33'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-12 22:26:33'::TIMESTAMPTZ, NOW()), 'system'
) ON CONFLICT (cycle_id) DO NOTHING;

INSERT INTO uat_cycles (
    cycle_id, program_id, name, description, uat_type, target_launch_date, status,
    clinical_pm, clinical_pm_email, pre_uat_gate_passed, created_at, updated_at, created_by
) VALUES (
    'UAT-ONB-V1', NULL, 'ONB Questionnaire v1', NULL,
    'feature', '2025-05-02'::DATE, 'planning', 'Glen Lewis',
    'glen.lewis@propelhealth.com', FALSE,
    COALESCE('2026-01-13 22:33:53'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 22:33:53'::TIMESTAMPTZ, NOW()), 'system'
) ON CONFLICT (cycle_id) DO NOTHING;

INSERT INTO uat_cycles (
    cycle_id, program_id, name, description, uat_type, target_launch_date, status,
    clinical_pm, clinical_pm_email, pre_uat_gate_passed, created_at, updated_at, created_by
) VALUES (
    'UAT-NCCN-A57B4A47', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'NCCN Q4 2025 Rule Updates', 'Quarterly NCCN rule engine validation. 180 test profiles across P4M and Px4M platforms covering 30 rule changes. Testing POS/NEG/DEP scenarios for each rule modification.',
    'rule_validation', '2026-02-03'::DATE, 'planning', 'Kim Childers',
    'Kim.Childers@providence.org', FALSE,
    COALESCE('2026-01-15 18:02:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:02:40'::TIMESTAMPTZ, NOW()), 'MCP:create_uat_cycle'
) ON CONFLICT (cycle_id) DO NOTHING;

INSERT INTO uat_cycles (
    cycle_id, program_id, name, description, uat_type, target_launch_date, status,
    clinical_pm, clinical_pm_email, pre_uat_gate_passed, created_at, updated_at, created_by
) VALUES (
    'UAT-PXME-85B6F1D6', '50405a41-4470-459e-8ec3-0dd223e98669', 'PXME Q1 2026 Feature UAT', 'Feature UAT for Precision4ME ordering module and consent validation workflows. Tests ORDER-002 and CONSENT-002 approved stories.',
    'feature', '2026-03-31'::DATE, 'planning', NULL,
    NULL, FALSE,
    COALESCE('2026-01-18 18:23:54'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-18 18:23:54'::TIMESTAMPTZ, NOW()), 'MCP:create_uat_cycle'
) ON CONFLICT (cycle_id) DO NOTHING;


-- UAT TEST CASES
INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-001', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Verify Number (N) Invited', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the track number (N) of patients who receive feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of invited patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Must Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-002', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of invited patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of invited patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of invited patients displays accurately', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-003', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-004', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-005', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-006', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-007', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-008', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-009', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-010', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-011', 'TEST2-RECRUIT-001', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-001',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-012', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Verify Program Recruitment Comparison', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the identify recruitment volume by program feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Should Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-013', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-014', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-015', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-016', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-017', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-018', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-019', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-020', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-021', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-022', 'TEST2-RECRUIT-002', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-002',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-023', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Verify Consent Flow Drop-off Tracking', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the see where users stop in the consent proc feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Should Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-024', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-025', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-026', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-027', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-028', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-029', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-030', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-031', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-032', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-033', 'TEST2-RECRUIT-003', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-003',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-034', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Verify Email Engagement Tracking', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the monitor if emails are opened or ignored feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Must Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-035', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-036', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-037', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-038', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-039', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-040', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-041', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-042', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-043', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-044', 'TEST2-RECRUIT-004', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-004',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-045', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Verify Reminder Email Opt-Out Tracking', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the monitor which users opt out of reminder  feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Must Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-046', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-047', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-048', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-049', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-050', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-051', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-052', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-053', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-054', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-055', 'TEST2-RECRUIT-005', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-005',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-056', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Verify On-demand Patient Lists', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the need to be able to pull list of patients feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of consented patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Must Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-057', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of consented patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of consented patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of consented patients displays accurately', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-058', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-059', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-060', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-061', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-062', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-063', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-064', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-065', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-066', 'TEST2-RECRUIT-006', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-006',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-067', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Verify Time on Consent Form', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the track amount of time spent on each conse feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Should Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-068', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-069', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-070', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-071', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-072', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-073', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-074', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-075', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-076', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-077', 'TEST2-RECRUIT-007', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-007',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-078', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Verify Saliva Kit Ordering', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the enables Discover Research team to order  feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Should Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-079', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-080', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-081', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-082', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-083', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-084', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-085', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-086', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-087', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-088', 'TEST2-RECRUIT-008', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-008',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-089', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Verify MyChart Recruitment Cross Validation', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the cross validate participants entering thr feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of enrolled patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Must Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-090', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of enrolled patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of enrolled patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of enrolled patients displays accurately', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-091', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-092', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-093', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-094', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-095', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-096', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-097', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-098', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-099', 'TEST2-RECRUIT-009', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-009',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-100', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Verify Multi-Study Dashboard', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the show a personalized list of available st feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of enrolled patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Should Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-101', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of enrolled patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of enrolled patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of enrolled patients displays accurately', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-102', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-103', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-104', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-105', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-106', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-107', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-108', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Should Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-109', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-110', 'TEST2-RECRUIT-010', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-010',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-111', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Verify SMS Outreach Reminders', 'RECRUIT', 'happy_path', 'User is logged in with appropriate permissions\nTest data is available in the system\nRecruitment analytics module is enabled',
    '1. Navigate to the relevant module/page\n2. Verify the feature is accessible\n3. Observe the dashboard/display loads\n4. Verify data is displayed correctly\n5. Test any filters or date range selectors\n6. Verify data accuracy against source', '**Expected Behavior (Gherkin):**\n  Given the user has appropriate permissions\n  When they access the allows for researchers to reach out to p feature\n  Then the feature works as expected\n\n**Specific Outcomes:**\n  ✓ Count of patients patients displays accurately\n  ✓ Metrics are segmented by program/channel\n  ✓ Funnel shows progression from invitation to enrollment\n  ✓ Aggregated view available (not patient-level by default)\n  ✓ Data exportable for offline analysis', 'Must Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates acceptance criteria for TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-112', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Count of patients patients displays accurately', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Count of patients patients displays accurately\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Count of patients patients displays accurately', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-113', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Metrics are segmented by program/channel', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Metrics are segmented by program/channel\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Metrics are segmented by program/channel', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-114', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Funnel shows progression from invitation to enrollment', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Funnel shows progression from invitation to enrollment\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Funnel shows progression from invitation to enrollment', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-115', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Aggregated view available (not patient-level by default)', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Aggregated view available (not patient-level by default)\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Aggregated view available (not patient-level by default)', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-116', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Validate: Data exportable for offline analysis', 'RECRUIT', 'validation', 'User is logged in\nFeature is accessible',
    '1. Navigate to the relevant feature\n2. Verify: Data exportable for offline analysis\n3. Document actual behavior\n4. Compare to expected behavior', '**Given** the feature is accessible\n**When** the validation is performed\n**Then** Data exportable for offline analysis', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Validates specific acceptance criterion from TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-117', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with insufficient permissions', 'RECRUIT', 'negative', 'User is logged in',
    '1. Log in as user without required permissions\n2. Attempt to access the feature\n3. Observe system response', '**Given** a user without permissions\n**When** they attempt to access the feature\n**Then** access is denied with appropriate message', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-118', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Verify dashboard with no data', 'RECRUIT', 'negative', 'User is logged in',
    '1. Access dashboard with empty dataset\n2. Observe display behavior', '**Then** empty state message is displayed\n**And** no errors occur', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-119', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Verify behavior with invalid/malformed input', 'RECRUIT', 'negative', 'User is logged in',
    '1. Enter invalid data in required fields\n2. Attempt to submit/save\n3. Observe validation messages', '**Given** invalid input is provided\n**When** the user submits\n**Then** clear validation errors are displayed\n**And** data is not saved', 'Must Have', '3-5 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Negative test for TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-120', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Verify with large dataset (10,000+ records)', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Load dashboard with 10,000+ records\n2. Observe load time and performance\n3. Test pagination/scrolling', '**Then** data loads within acceptable time (<10s)\n**And** pagination works correctly\n**And** no performance degradation', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'TEST2-RECRUIT-121', 'TEST2-RECRUIT-011', 'PRG-TEST2-8F48D903', NULL,
    'Verify with extreme date range', 'RECRUIT', 'edge_case', 'User is logged in',
    '1. Select date range spanning multiple years\n2. Observe data aggregation', '**Then** data aggregates correctly\n**And** display remains readable', 'Could Have', '5-10 min',
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, 'Edge case test for TEST2-RECRUIT-011',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC01', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'External Contractor can read patient records', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Patient exists with TC > threshold or NCCN met.',
    '1. Log in as External Contractor user\n2. Navigate to patient dashboard\n3. Click on a visible patient record\n4. Verify patient record opens and data is displayed', 'Patient record opens successfully and all data fields are readable', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:51:46'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:51:46'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC02', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'External Contractor can edit patient records', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Patient exists with TC > threshold or NCCN met.',
    '1. Log in as External Contractor user\n2. Navigate to patient dashboard\n3. Open a visible patient record\n4. Document current value of field to be edited\n5. Edit a field (e.g., add a note)\n6. Save the record\n7. Verify changes are saved successfully\n8. Query audit log for edit entry\n9. Verify audit entry contains user ID, timestamp, before/after values', '1. Patient record saves successfully with updated information\n2. Audit log contains entry with: user ID, timestamp, patient ID, field changed, previous value, new value', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:51:51'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:05:34'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC03', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'External Contractor can place lab orders', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Patient exists with TC > threshold or NCCN met. Lab ordering integration is configured.',
    '1. Log in as External Contractor user\n2. Navigate to patient dashboard\n3. Open a visible patient record\n4. Navigate to lab ordering section\n5. Create a new lab order\n6. Submit the lab order\n7. Verify order confirmation is received', 'Lab order is submitted successfully and confirmation is displayed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:51:56'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:51:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC04', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'External Contractor can view contact information', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Patient exists with TC > threshold or NCCN met and has contact information on file.',
    '1. Log in as External Contractor user\n2. Navigate to patient dashboard\n3. Open a visible patient record\n4. Navigate to contact information section\n5. Verify phone number is displayed\n6. Verify address is displayed\n7. Verify email is displayed (if on file)', 'Patient contact information (phone, address, email) is visible in the patient record', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:01'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:01'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC05', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'External Contractor can view full clinical summary', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Patient exists with TC > threshold or NCCN met and has completed clinical intake.',
    '1. Log in as External Contractor user\n2. Navigate to patient dashboard\n3. Open a visible patient record\n4. Navigate to clinical summary\n5. Verify medical history section is visible\n6. Verify questionnaire responses are visible\n7. Verify risk scores are displayed\n8. Verify clinical notes are accessible', 'Full clinical summary is displayed including medical history, questionnaire responses, risk scores, and clinical notes', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:06'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:06'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC06', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'External Contractor cannot export data', NULL, 'negative', 'User is assigned External Contractor role at Montana clinic. Patient data exists that would normally be exportable.',
    '1. Log in as External Contractor user\n2. Navigate to patient dashboard\n3. Open a visible patient record\n4. Attempt to export patient data\n5. Verify export is blocked with appropriate error message\n6. Query audit log for failed access entries\n7. Verify failed export attempt was logged with denial reason', '1. Export action is blocked with appropriate error message\n2. No data is exported\n3. Audit log contains entry with: user ID, timestamp, action attempted (export), denial reason', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:05:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC07', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Patient with TC above threshold is visible', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Test patient exists with TC score > threshold [TBD] and NCCN not met.',
    '1. Create or identify test patient with TC score > threshold and NCCN = not met\n2. Log in as External Contractor user\n3. Navigate to patient dashboard\n4. Verify test patient appears in patient list', 'Patient appears in the dashboard patient list', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:19'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:19'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC08', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Patient with NCCN met is visible', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Test patient exists with NCCN criteria = met and TC score below threshold.',
    '1. Create or identify test patient with NCCN = met and TC score below threshold\n2. Log in as External Contractor user\n3. Navigate to patient dashboard\n4. Verify test patient appears in patient list', 'Patient appears in the dashboard patient list', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:26'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:26'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC09', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Patient with BOTH conditions is visible', NULL, 'happy_path', 'User is assigned External Contractor role at Montana clinic. Test patient exists with TC score > threshold AND NCCN criteria = met.',
    '1. Create or identify test patient with TC score > threshold AND NCCN = met\n2. Log in as External Contractor user\n3. Navigate to patient dashboard\n4. Verify test patient appears in patient list (only once, not duplicated)', 'Patient appears in the dashboard patient list', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:31'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC10', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Patient with incomplete questionnaire is NOT visible', NULL, 'negative', 'User is assigned External Contractor role at Montana clinic. Test patient exists who has NOT completed the questionnaire.',
    '1. Create or identify test patient who has not completed questionnaire\n2. Log in as External Contractor user\n3. Navigate to patient dashboard\n4. Search/filter for test patient\n5. Verify test patient does NOT appear in patient list', 'Patient does NOT appear in the dashboard patient list', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:36'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:36'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC11', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Patient with low TC AND NCCN not met is NOT visible', NULL, 'negative', 'User is assigned External Contractor role at Montana clinic. Test patient exists with TC score below threshold AND NCCN criteria = not met.',
    '1. Create or identify test patient with low TC score AND NCCN = not met\n2. Log in as External Contractor user\n3. Navigate to patient dashboard\n4. Search/filter for test patient\n5. Verify test patient does NOT appear in patient list', 'Patient does NOT appear in the dashboard patient list', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC12', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Patient with TC exactly at threshold boundary', NULL, 'edge_case', 'User is assigned External Contractor role at Montana clinic. Test patient exists with TC score = exactly 20 and NCCN criteria = not met.',
    '1. Create or identify test patient with TC score = exactly 20 and NCCN = not met\n2. Log in as External Contractor user\n3. Navigate to patient dashboard\n4. Search/filter for test patient\n5. Verify whether patient appears or not based on threshold definition', '[TBD - depends on whether threshold is > 20 or ≥ 20] If ≥ 20: Patient appears in list. If > 20: Patient does NOT appear in list.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:52:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC13', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Role can be assigned to user at clinic level', NULL, 'happy_path', 'External Contractor role exists in system. Test user account exists. Montana clinic is configured in system.',
    '1. Log in as program administrator\n2. Navigate to user management\n3. Select test user account\n4. Assign External Contractor role at Montana clinic level\n5. Save changes\n6. Query audit log for role assignment entry\n7. Verify audit entry contains admin user, target user, role, and timestamp\n8. Log out and log in as test user\n9. Verify user has External Contractor permissions', '1. Role is successfully assigned and user can log in with External Contractor permissions\n2. Audit log contains entry with: administrator user ID, timestamp, action type (role_assignment), target user ID, role assigned, scope (clinic)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:52:56'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:06:03'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ROLE-001-TC14', 'P4M-ROLE-001', 'P4M-7EC35FEE', NULL,
    'Role can be assigned to multiple users', NULL, 'happy_path', 'External Contractor role exists in system. Two test user accounts exist. Montana clinic is configured in system.',
    '1. Log in as program administrator\n2. Assign External Contractor role to User A at Montana clinic\n3. Assign External Contractor role to User B at Montana clinic\n4. Save changes\n5. Log in as User A and verify External Contractor permissions\n6. Log in as User B and verify External Contractor permissions\n7. Verify both users see the same filtered patient list', 'Both users successfully have External Contractor role and can operate independently with appropriate permissions', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 13:53:02'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 13:53:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC01', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Hematologic/BMT Flag column is visible on dashboard', NULL, 'happy_path', 'User has access to Prevention4ME dashboard. Dashboard is configured for clinic.',
    '1. Log in as GC, GA, or Program Administrator\n2. Navigate to program dashboard\n3. Verify Hematologic/BMT Flag column is visible in the patient list', 'A new column labeled "Hematologic/BMT Flag" (or similar) is visible on the dashboard', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:17:45'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:17:45'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC02', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag appears for patient with hematologic malignancy only', NULL, 'happy_path', 'Test patient exists who reported hematologic malignancy (but NOT BMT) in clinical intake.',
    '1. Create or identify test patient with hematologic malignancy reported in intake\n2. Log in as GC\n3. Navigate to program dashboard\n4. Locate test patient in patient list\n5. Verify flag indicator appears in Hematologic/BMT Flag column', 'Visual indicator (✅ or colored icon) appears in the Hematologic/BMT Flag column for this patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:17:50'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:17:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC03', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag appears for patient with bone marrow transplant only', NULL, 'happy_path', 'Test patient exists who reported bone marrow transplant (but NOT hematologic malignancy) in clinical intake.',
    '1. Create or identify test patient with bone marrow transplant reported in intake\n2. Log in as GC\n3. Navigate to program dashboard\n4. Locate test patient in patient list\n5. Verify flag indicator appears in Hematologic/BMT Flag column', 'Visual indicator (✅ or colored icon) appears in the Hematologic/BMT Flag column for this patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:17:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:17:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC04', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag appears for patient with BOTH conditions', NULL, 'happy_path', 'Test patient exists who reported BOTH hematologic malignancy AND bone marrow transplant in clinical intake.',
    '1. Create or identify test patient with both conditions reported in intake\n2. Log in as GC\n3. Navigate to program dashboard\n4. Locate test patient in patient list\n5. Verify flag indicator appears in Hematologic/BMT Flag column\n6. Verify flag appears only once (not duplicated)', 'Visual indicator appears in the Hematologic/BMT Flag column (single flag, not duplicated)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:18:00'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC05', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Clicking flagged patient opens clinical summary', NULL, 'happy_path', 'Test patient exists with hematologic malignancy or BMT flag. User is logged in as GC.',
    '1. Log in as GC\n2. Navigate to program dashboard\n3. Locate flagged patient in patient list\n4. Click on the patient row or flag\n5. Verify clinical summary opens\n6. Verify detailed medical history is accessible for review', 'Patient''s clinical summary opens showing detailed medical history including hematologic malignancy/BMT information', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:18:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC06', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag does NOT appear for patient without either condition', NULL, 'negative', 'Test patient exists who has NOT reported hematologic malignancy or bone marrow transplant in clinical intake.',
    '1. Create or identify test patient with no hematologic malignancy or BMT reported\n2. Log in as GC\n3. Navigate to program dashboard\n4. Locate test patient in patient list\n5. Verify Hematologic/BMT Flag column is empty or shows no indicator for this patient', 'No flag indicator appears in the Hematologic/BMT Flag column for this patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:18:12'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:12'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC07', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag does NOT expose type of malignancy or BMT on dashboard (HIPAA)', NULL, 'validation', 'Test patient exists with hematologic malignancy or BMT flag.',
    '1. Log in as GC\n2. Navigate to program dashboard\n3. Locate flagged patient in patient list\n4. Inspect the Hematologic/BMT Flag column\n5. Verify only a generic flag/icon is shown\n6. Verify no specific diagnosis type or BMT type is displayed on the dashboard\n7. Hover over flag (if applicable) and verify no detailed clinical info appears', 'Dashboard shows only the flag indicator. No text describing type of malignancy (e.g., "leukemia", "lymphoma") or type of BMT (e.g., "allogenic", "autologous") is visible on the dashboard view.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-06 17:18:18'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC08', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag is visible to GA role', NULL, 'happy_path', 'User has GA role. Flagged patients exist in dashboard.',
    '1. Log in as GA (Genetic Assistant)\n2. Navigate to program dashboard\n3. Verify Hematologic/BMT Flag column is visible\n4. Verify flag indicators are visible for applicable patients', 'Flag column and flag indicators are visible to GA user', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:18:26'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:26'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC09', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag is visible to Program Administrator role', NULL, 'happy_path', 'User has Program Administrator role. Flagged patients exist in dashboard.',
    '1. Log in as Program Administrator\n2. Navigate to program dashboard\n3. Verify Hematologic/BMT Flag column is visible\n4. Verify flag indicators are visible for applicable patients', 'Flag column and flag indicators are visible to Program Administrator user', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:18:32'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:32'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC10', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag appears for allogenic bone marrow transplant', NULL, 'validation', 'Test patient exists who reported allogenic bone marrow transplant specifically in clinical intake.',
    '1. Create or identify test patient with allogenic BMT reported in intake\n2. Log in as GC\n3. Navigate to program dashboard\n4. Locate test patient in patient list\n5. Verify flag indicator appears in Hematologic/BMT Flag column', 'Visual indicator appears in the Hematologic/BMT Flag column for this patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-06 17:18:41'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-06 17:18:41'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-001-TC01', 'P4M-CONFIG-001', 'P4M-7EC35FEE', NULL,
    'TC Disabled Clinic Generates Clinical Summary with NCCN Only', NULL, 'happy_path', '1. Prevention4ME clinic exists with TC disabled at clinic level\n2. Patient has completed assessment with NCCN eligibility questions',
    '1. Navigate to completed patient assessment for TC-disabled clinic\n2. Generate clinical summary for patient\n3. Review clinical summary content', 'Clinical summary generates successfully and displays only NCCN eligibility status and related recommendations. No TC score, lifetime risk percentage, or TC-related content appears.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 12:27:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 12:27:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-001-TC04', 'P4M-CONFIG-001', 'P4M-7EC35FEE', NULL,
    'Verify TC Content Does NOT Appear When Disabled', NULL, 'negative', '1. Prevention4ME clinic exists with TC disabled at clinic level\n2. Patient has completed assessment\n3. Clinical summary has been generated',
    '1. Generate clinical summary for patient at TC-disabled clinic\n2. Search clinical summary document for "Tyrer-Cuzick"\n3. Search clinical summary document for "lifetime risk"\n4. Search clinical summary document for TC score percentage values\n5. Search clinical summary document for TC-specific recommendations', 'Clinical summary contains zero instances of: TC score, Tyrer-Cuzick, lifetime risk percentage, or any TC-specific recommendations. Search returns no matches.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 12:27:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 12:27:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-001-TC05', 'P4M-CONFIG-001', 'P4M-7EC35FEE', NULL,
    'TC Enabled Clinic Clinical Summary Functions Correctly (No Regression)', NULL, 'edge_case', '1. Prevention4ME clinic exists with TC enabled at clinic level\n2. Patient has completed full assessment including TC questions',
    '1. Complete patient assessment at TC-enabled clinic\n2. Generate clinical summary\n3. Verify TC score and lifetime risk percentage appear in clinical summary\n4. Verify TC-related recommendations appear in clinical summary\n5. Verify NCCN eligibility also appears in clinical summary', 'Clinical summary generates successfully with full TC content including: TC score, lifetime risk percentage, TC-related recommendations, and NCCN eligibility. No regression from TC toggle feature implementation.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 12:27:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:13:44'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC01', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Filter by Single Clinic Type Displays Correct Metrics', NULL, 'happy_path', '1. Prevention4ME analytics dashboard is accessible\n2. Multiple clinic types exist with patient data (mammography, OBGYN, endoscopy)\n3. User has dashboard access',
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate clinic type filter\n3. Select a single clinic type (e.g., "Mammography")\n4. Review all dashboard metrics and visualizations\n5. Verify data displayed corresponds to selected clinic type only', 'Dashboard displays metrics (assessment completions, high risk patients, NCCN eligible patients) only for the selected clinic type. All visualizations update to reflect the filtered data.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:34:20'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:34:20'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC02', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Filter by Multiple Clinic Types Displays Combined Metrics', NULL, 'happy_path', '1. Prevention4ME analytics dashboard is accessible\n2. Multiple clinic types exist with patient data (mammography, OBGYN, endoscopy)\n3. User has dashboard access',
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate clinic type filter\n3. Select multiple clinic types (e.g., "Mammography" and "OBGYN")\n4. Review all dashboard metrics and visualizations\n5. Verify data displayed includes both selected clinic types\n6. Verify color coding distinguishes between selected clinic types', 'Dashboard displays combined metrics for all selected clinic types. Visualizations show data aggregated across selected types with color coding distinguishing each clinic type.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:34:27'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:34:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC03', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'All Selection Displays Metrics for All Clinic Types', NULL, 'happy_path', '1. Prevention4ME analytics dashboard is accessible\n2. Multiple clinic types exist with patient data (mammography, OBGYN, endoscopy)\n3. User has dashboard access',
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate clinic type filter\n3. Select "All" clinic types option\n4. Review all dashboard metrics and visualizations\n5. Verify data displayed includes all clinic types\n6. Verify totals match sum of individual clinic type data', 'Dashboard displays metrics for all clinic types combined. All visualizations show complete program data with color coding distinguishing each clinic type.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:34:32'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:34:32'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC04', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Color Coding is Consistent Across All Visualizations', NULL, 'validation', '1. Prevention4ME analytics dashboard is accessible\n2. Multiple clinic types exist with patient data\n3. User has dashboard access',
    '1. Navigate to Prevention4ME analytics dashboard\n2. Select "All" clinic types to display all data\n3. Review bar charts and note color assigned to each clinic type\n4. Review any other visualizations (line charts, pie charts, etc.)\n5. Verify same color is used for same clinic type across all visualizations\n6. Verify colors are distinct and accessible (not relying solely on red/green)', 'Each clinic type uses the same assigned color across all charts, graphs, and visualizations on the dashboard. Colors are distinct and easily distinguishable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:34:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:34:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC05', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Adding New Clinic Type Appears in Filter Options', NULL, 'validation', '1. Prevention4ME analytics dashboard is accessible\n2. Existing clinic types are configured (mammography, OBGYN)\n3. A new clinic type is being onboarded (e.g., endoscopy)\n4. User has dashboard access',
    '1. Onboard new clinic type (e.g., endoscopy) with patient data\n2. Navigate to Prevention4ME analytics dashboard\n3. Open clinic type filter dropdown\n4. Verify new clinic type appears in the list\n5. Select new clinic type\n6. Verify dashboard displays metrics for new clinic type\n7. Verify new clinic type has distinct color assigned', 'New clinic type appears in the filter dropdown. New clinic type is assigned a distinct color. Selecting new clinic type displays its metrics correctly.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:34:56'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:34:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC06', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'No Data Displays Appropriately When Clinic Type Has No Patients', NULL, 'negative', '1. Prevention4ME analytics dashboard is accessible\n2. A clinic type exists with no patient data (newly onboarded or test clinic)\n3. User has dashboard access',
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate clinic type filter\n3. Select a clinic type with no patient data\n4. Review dashboard metrics and visualizations\n5. Verify no errors are displayed\n6. Verify appropriate empty state or zero values are shown', 'Dashboard displays appropriate empty state messaging (e.g., "No data available for selected clinic type"). No errors occur. Visualizations display gracefully with zero values or empty state indicators.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:35:10'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:35:10'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC07', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Dashboard Performance with Large Dataset Across Multiple Clinic Types', NULL, 'edge_case', '1. Prevention4ME analytics dashboard is accessible\n2. Large dataset exists across multiple clinic types (1000+ patients per clinic type)\n3. User has dashboard access',
    '1. Navigate to Prevention4ME analytics dashboard with large dataset\n2. Note initial load time\n3. Select "All" clinic types\n4. Note time to update visualizations\n5. Change filter to single clinic type\n6. Note time to update visualizations\n7. Rapidly toggle between different filter selections\n8. Verify no errors, timeouts, or significant lag', 'Dashboard loads within acceptable time threshold (e.g., under 5 seconds). Filter changes update visualizations without significant lag. No timeout errors or performance degradation.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-07 13:35:20'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 13:35:20'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC11', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Viewing flagged patient creates audit entry', NULL, 'validation', '1. Patient exists with hematologic/BMT flag active\n2. User has GA, GC, or Program Administrator role\n3. Audit system is accessible for verification',
    '1. Log in as GA user\n2. Navigate to program dashboard\n3. Identify patient with active hematologic/BMT flag\n4. Click on flagged patient to open clinical summary\n5. Query audit log for entries related to this patient', 'Audit log contains entry with: user ID who viewed record, timestamp of access, patient ID viewed. Entry is created at time of clinical summary access.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:01:51'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:01:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC12', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Hematologic/BMT data change creates audit entry with before/after', NULL, 'validation', '1. Patient exists with current hematologic/BMT data\n2. User has permission to edit patient records\n3. Audit system is accessible for verification',
    '1. Log in as authorized user\n2. Navigate to patient clinical summary\n3. Note current value of hematologic malignancy field\n4. Update hematologic malignancy field to new value\n5. Save changes\n6. Query audit log for entries related to this patient and field', 'Audit log contains entry showing: user who made change, timestamp, field changed (hematologic malignancy or BMT history), previous value, new value. Audit entry is immutable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:02:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:02:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC13', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag status change is logged with timestamp and triggering data', NULL, 'validation', '1. Patient exists without hematologic/BMT flag (no history reported)\n2. User has permission to edit patient records\n3. Dashboard is visible to verify flag status',
    '1. Verify patient does NOT have hematologic/BMT flag on dashboard\n2. Update patient record to add hematologic malignancy history\n3. Save changes\n4. Refresh dashboard\n5. Verify flag now appears for patient\n6. Query audit log for flag status change entry', '1. Dashboard flag updates from inactive to active\n2. Audit log contains entry showing: timestamp of flag status change, patient ID, triggering data change reference, new flag status', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:02:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:02:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC14', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Flag updates when underlying data changes (flag removed)', NULL, 'validation', '1. Patient exists WITH active hematologic/BMT flag\n2. Patient has ONLY hematologic malignancy OR ONLY BMT (not both)\n3. User has permission to edit patient records',
    '1. Verify patient HAS hematologic/BMT flag on dashboard\n2. Navigate to patient clinical summary\n3. Update record to remove hematologic malignancy/BMT history (change to "No")\n4. Save changes\n5. Refresh dashboard\n6. Verify flag no longer appears for patient', 'Dashboard flag changes from active to inactive for the patient. Flag accurately reflects current underlying data state.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:02:21'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:02:21'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC08', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Report export creates audit entry with filter parameters', NULL, 'validation', '1. User has permission to access analytics dashboard\n2. User has permission to export reports\n3. Clinic type filter has data available\n4. Audit system is accessible for verification',
    '1. Log in as authorized user\n2. Navigate to analytics dashboard\n3. Apply clinic type filter\n4. Export filtered report\n5. Query audit log for export entries', 'Audit log contains entry with: user ID who exported, timestamp, report type, filter parameters used, export format. Entry created at time of export request.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:02:29'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:02:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC09', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Exported report matches dashboard display (data integrity)', NULL, 'validation', '1. User has permission to access analytics dashboard\n2. User has permission to export reports\n3. Dashboard has data for multiple clinic types',
    '1. Navigate to analytics dashboard\n2. Apply clinic type filter (select single clinic type)\n3. Document on-screen metrics (record counts, percentages, totals)\n4. Export report to file\n5. Open exported file\n6. Compare exported values to documented on-screen values', 'Exported data matches on-screen display exactly. Record counts, metrics, and filter conditions are identical between dashboard view and export file.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:02:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:02:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-AUDIT-001-TC01', 'P4M-AUDIT-001', 'P4M-7EC35FEE', NULL,
    'Role assignment creates audit entry', NULL, 'validation', '1. Administrator user has permission to assign roles\n2. Target user account exists\n3. External Contractor role exists\n4. Audit system is accessible for verification',
    '1. Log in as Program Administrator\n2. Navigate to user management\n3. Select target user account\n4. Assign External Contractor role at clinic level\n5. Save changes\n6. Query audit log for role assignment entries\n7. Verify entry contains required fields', 'Audit log contains entry with: administrator user ID, timestamp, action type "role_assignment", target user ID, role assigned, scope (clinic/program). Entry is created immediately upon save.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:03:01'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:03:01'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-AUDIT-001-TC02', 'P4M-AUDIT-001', 'P4M-7EC35FEE', NULL,
    'Patient record edit creates audit entry with before/after values', NULL, 'validation', '1. User has permission to edit patient records\n2. Patient record exists with known field values\n3. Audit system is accessible for verification',
    '1. Log in as authorized user\n2. Navigate to patient record\n3. Document current value of field to be changed\n4. Edit field to new value\n5. Save changes\n6. Query audit log for this patient''s edit entries\n7. Verify before/after values are captured correctly', 'Audit log contains entry with: user ID, timestamp, patient ID, action type "record_edit", field name changed, previous value, new value. All changed fields are captured in single audit entry or linked entries.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:03:08'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:03:08'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-AUDIT-001-TC03', 'P4M-AUDIT-001', 'P4M-7EC35FEE', NULL,
    'Failed access attempt is logged', NULL, 'negative', '1. External Contractor user exists with restricted permissions\n2. Export functionality exists but is blocked for this role\n3. Audit system is accessible for verification',
    '1. Log in as External Contractor user\n2. Navigate to patient data or dashboard\n3. Attempt to export data (action should be blocked)\n4. Note error message displayed\n5. Query audit log for failed access entries\n6. Verify attempt was logged with denial reason', 'Audit log contains entry with: user ID who attempted action, timestamp, action attempted (export), denial reason (insufficient permissions), resource attempted to access. User receives appropriate error message.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:03:17'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:03:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-AUDIT-001-TC04', 'P4M-AUDIT-001', 'P4M-7EC35FEE', NULL,
    'Configuration change creates audit entry with who/when/what', NULL, 'validation', '1. Administrator has permission to change configuration\n2. Configuration setting exists with known current value\n3. Audit system is accessible for verification',
    '1. Log in as Program Administrator\n2. Navigate to configuration settings\n3. Document current value of setting to change\n4. Update configuration value\n5. Save changes\n6. Query audit log for configuration change entries\n7. Verify before/after values are captured', 'Audit log contains entry with: administrator user ID, timestamp, setting name changed, previous value, new value, scope (clinic/location if applicable). Entry created at time of save.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:03:29'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:03:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-AUDIT-001-TC05', 'P4M-AUDIT-001', 'P4M-7EC35FEE', NULL,
    'Audit records cannot be edited or deleted (immutability)', NULL, 'negative', '1. Audit entries exist in the system\n2. Database access available for testing (may require DBA support)\n3. Known audit entry ID to attempt modification',
    '1. Query audit log and document existing entry details\n2. Attempt to edit audit record via application UI (should have no edit option)\n3. Attempt to delete audit record via application UI (should have no delete option)\n4. Attempt direct database UPDATE on audit record (should fail)\n5. Attempt direct database DELETE on audit record (should fail)\n6. Verify original audit entry is unchanged', '1. Direct database UPDATE query fails or is blocked\n2. Direct database DELETE query fails or is blocked\n3. Application provides no UI to edit/delete audit records\n4. Original audit entry remains unchanged', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:03:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:03:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-AUDIT-001-TC06', 'P4M-AUDIT-001', 'P4M-7EC35FEE', NULL,
    'Audit trail includes computer-generated timestamp', NULL, 'validation', '1. System time is synchronized and verified\n2. User has permission to perform auditable actions\n3. Audit system is accessible for verification',
    '1. Note current system time (server time, not local)\n2. Perform auditable action (e.g., view patient record)\n3. Query audit log for the new entry\n4. Compare audit timestamp to noted system time\n5. Verify timestamp format includes timezone and milliseconds\n6. Perform multiple rapid actions and verify sequential timestamps', '1. Audit timestamp is within seconds of wall clock time\n2. Timestamp is in UTC format with millisecond precision\n3. Timestamp is consistent with server time (not client-submitted)\n4. Multiple rapid actions show sequential timestamps', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:03:52'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:03:52'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-RECORD-001-TC01', 'P4M-RECORD-001', 'P4M-7EC35FEE', NULL,
    'Clinical summary can be exported as human-readable PDF', NULL, 'happy_path', '1. Patient exists with completed clinical summary\n2. User has permission to export records\n3. PDF reader available for verification',
    '1. Log in as authorized user\n2. Navigate to patient clinical summary\n3. Click export/download option\n4. Select PDF format\n5. Download file\n6. Open PDF in standard reader\n7. Verify all content is readable and properly formatted', 'PDF file downloads successfully. PDF is human-readable with clear text, proper formatting, and all clinical data visible. PDF can be opened in standard PDF readers.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:04:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:04:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-RECORD-001-TC02', 'P4M-RECORD-001', 'P4M-7EC35FEE', NULL,
    'Exported record includes audit metadata', NULL, 'validation', '1. Patient exists with completed clinical summary\n2. User has permission to export records\n3. PDF reader with properties viewer available',
    '1. Log in as authorized user\n2. Navigate to patient clinical summary\n3. Export clinical summary as PDF\n4. Open exported PDF\n5. Check document header/footer for metadata\n6. Check PDF properties for embedded metadata\n7. Verify all required metadata fields are present', 'Exported PDF contains: generation timestamp, user ID/name who generated export, patient identifier (MRN or equivalent), system identifier/version. Metadata is visible in document header/footer or properties.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:04:31'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:04:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-RECORD-001-TC03', 'P4M-RECORD-001', 'P4M-7EC35FEE', NULL,
    'Record export creates audit entry', NULL, 'validation', '1. Patient exists with completed clinical summary\n2. User has permission to export records\n3. Audit system is accessible for verification',
    '1. Log in as authorized user\n2. Note current timestamp\n3. Navigate to patient clinical summary\n4. Export clinical summary as PDF\n5. Query audit log for export entries after noted timestamp\n6. Verify audit entry was created with required fields', 'Audit log contains entry with: user ID who exported, timestamp of export, patient ID exported, export type (PDF/print), and file identifier if applicable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:04:43'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:04:43'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-RECORD-001-TC04', 'P4M-RECORD-001', 'P4M-7EC35FEE', NULL,
    'Exported record matches on-screen display (data accuracy)', NULL, 'validation', '1. Patient exists with completed clinical summary containing multiple data fields\n2. User has permission to export records',
    '1. Log in as authorized user\n2. Navigate to patient clinical summary\n3. Document all on-screen values (screenshot or written record)\n4. Export clinical summary as PDF\n5. Open exported PDF\n6. Compare each data field in PDF to documented on-screen values\n7. Verify all fields match exactly', 'All data fields in exported PDF match exactly what is displayed on-screen, including: patient demographics, risk scores, clinical findings, recommendations, and dates. No data is omitted or altered in export.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:05:06'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:05:06'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-RECORD-001-TC05', 'P4M-RECORD-001', 'P4M-7EC35FEE', NULL,
    'Unauthorized user cannot export records', NULL, 'negative', '1. External Contractor user exists (export permission denied per P4M-ROLE-001)\n2. Patient record is visible to External Contractor\n3. Audit system is accessible for verification',
    '1. Log in as External Contractor user\n2. Navigate to patient clinical summary\n3. Look for export/download option\n4. Verify export option is not available OR is disabled\n5. (If technically possible) Attempt direct API call to export\n6. Verify request is denied\n7. Query audit log for failed export attempt', '1. Export button/option is not visible OR is disabled for unauthorized user\n2. If user attempts export via direct URL/API, request is denied\n3. No PDF is generated\n4. Failed attempt is logged in audit trail', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-07 15:05:14'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 15:05:14'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-001-TC02', 'ONB-SAVE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify auto-save indicator displays timestamp', 'SAVE', 'happy_path', 'Form loaded',
    '1. Open form in browser\n2. Select a program\n3. Navigate to Step 2\n4. Enter any field value\n5. Look at save status bar at top of form\n6. Verify auto-save indicator shows timestamp', '"Auto-saved at [current time]" indicator visible with green checkmark', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 1, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:55:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:55:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-001-TC01', 'ONB-FORM-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify questions render from JSON configuration', 'FORM', 'happy_path', 'Access to form-definition.json file',
    '1. Open form-definition.json\n2. Add a new text question to clinic_info step:\n   {"question_id": "test_field", "type": "text", "label": "Test Field", "required": false}\n3. Save file and refresh form\n4. Navigate to Step 2\n5. Verify "Test Field" appears in the form\n6. Remove test_field from JSON and verify it disappears', 'New question renders in Step 2 without any code changes', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 7, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:58:34'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:58:34'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-002-TC01', 'ONB-FORM-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify conditional field shows for P4M only', 'FORM', 'happy_path', 'Form loaded',
    '1. Select P4M program in Step 1\n2. Navigate to Lab Configuration step\n3. Verify "Indication" field is visible\n4. Navigate back to Step 1\n5. Change selection to GRX\n6. Navigate to Lab Configuration step\n7. Verify "Indication" field is NOT visible', 'Indication field visible for P4M, hidden for GRX', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 8, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:58:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:58:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC01', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify required field indicators display consistently', 'FORM', 'happy_path', 'Form loaded',
    '1. Navigate through all form steps\n2. Identify fields marked as required in form-definition.json\n3. Verify each required field has a red asterisk indicator\n4. Verify optional fields do NOT have an asterisk', 'Red asterisk (*) visible next to required field labels on all steps', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 9, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:58:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:58:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC02', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify required field prevents navigation when empty', 'FORM', 'negative', 'Form on Step 2 (Clinic Information)',
    '1. Navigate to Step 2\n2. Leave "Clinic Name" field empty (required field)\n3. Click "Next" button\n4. Verify form does NOT advance to Step 3\n5. Verify error message appears below Clinic Name field\n6. Verify field has red border', 'Form stays on current step, validation error shown below field, field highlighted in red', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 10, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:59:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:59:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC03', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify NPI pattern validation', 'FORM', 'validation', 'Form on Ordering Providers step',
    '1. Navigate to Ordering Providers step\n2. Enter provider name\n3. Enter invalid NPI: "123" (too short)\n4. Click away from field or click Next\n5. Verify validation error for NPI format\n6. Enter valid NPI: "1234567890"\n7. Verify error clears', 'Validation error shown: NPI must be 10 digits', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 11, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:59:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:59:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-004-TC01', 'ONB-FORM-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Add button creates new repeatable item', 'FORM', 'happy_path', 'Form on Satellite Locations step',
    '1. Navigate to Satellite Locations step\n2. Click "Add Satellite Location" button\n3. Verify new location form section appears\n4. Verify section titled "Location 1"\n5. Verify all location fields present\n6. Click Add again\n7. Verify "Location 2" appears', 'New location form appears with fields for name, Epic ID, address, phone, hours', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 17, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:59:53'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:59:53'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-004-TC02', 'ONB-FORM-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Remove button deletes item and renumbers', 'FORM', 'happy_path', 'Form on Satellite Locations step with 3 locations added',
    '1. Add 3 satellite locations with data\n2. Click Remove button on Location 2\n3. Confirm removal if prompted\n4. Verify Location 2 is removed\n5. Verify Location 3 data now shows as Location 2\n6. Verify Location 1 data unchanged', 'Location 2 removed, Location 3 renumbered to Location 2', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 18, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 10:59:59'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:59:59'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-005-TC01', 'ONB-FORM-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify address composite renders all subfields', 'FORM', 'happy_path', 'Form on Clinic Information step',
    '1. Navigate to Clinic Information step\n2. Locate clinic address section\n3. Verify Street Address field present\n4. Verify City field present\n5. Verify State is a dropdown with all US states\n6. Verify ZIP Code field present\n7. Enter valid address and verify data saved together', 'Address fields grouped together: Street, City, State dropdown, ZIP code', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 19, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:00:59'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:00:59'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-005-TC02', 'ONB-FORM-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify contact composite renders all subfields', 'FORM', 'happy_path', 'Form on Contacts step',
    '1. Navigate to Contacts step\n2. Locate Primary Contact section\n3. Verify all contact fields present\n4. Verify Preferred Channel has Email, Phone, Teams options\n5. Verify Preferred Time has Morning, Afternoon, Anytime options', 'Contact section shows: Name, Title, Email, Phone, Preferred Channel dropdown, Preferred Time dropdown', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 20, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:01:06'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:01:06'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-001-TC01', 'ONB-STEP-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify program options display correctly', 'STEP', 'happy_path', 'Form loaded at Step 1',
    '1. Open form\n2. Verify Step 1 "Program Selection" displayed\n3. Verify P4M option with "Prevention4ME" and description\n4. Verify PR4M option with "Precision4ME" and description\n5. Verify GRX option with "GenoRx" and description\n6. Select each option and verify radio button state changes', 'Three program options displayed with names and descriptions, radio buttons functional', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 1, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:01:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:01:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-002-TC01', 'ONB-STEP-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify clinic information fields present', 'STEP', 'happy_path', 'Program selected, navigated to Step 2',
    '1. Select P4M and navigate to Step 2\n2. Verify Clinic Name field (required)\n3. Verify Epic Department ID field\n4. Verify Address composite field\n5. Verify Timezone dropdown\n6. Verify Hours of Operation field\n7. Verify Website fields\n8. Fill all fields and proceed to Step 3', 'All clinic information fields present and functional', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 2, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:01:18'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:01:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-006-TC01', 'ONB-STEP-006', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify lab configuration varies by program', 'STEP', 'happy_path', 'P4M selected, navigated to Lab Configuration step',
    '1. With P4M selected, go to Lab Configuration\n2. Verify Lab Partner shows Ambry Genetics\n3. Verify Indication field is visible\n4. Verify Criteria for Testing field is visible\n5. Go back to Step 1, select GRX\n6. Return to Lab Configuration\n7. Verify Lab Partner shows Helix\n8. Verify Indication field is NOT visible', 'Lab partner shows Ambry for P4M, Helix for GRX; conditional fields show/hide correctly', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 24, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:01:25'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:01:25'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-007-TC01', 'ONB-STEP-007', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify test products filtered by program', 'STEP', 'happy_path', 'P4M selected, navigated to Test Products step',
    '1. With P4M selected, go to Test Products\n2. Click Add Test Product\n3. Open Test Name dropdown\n4. Verify only P4M-compatible tests shown\n5. Select a test and add modifications\n6. Add second test product\n7. Verify both saved correctly', 'Test products filtered to show only options valid for selected program', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 26, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:02:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:02:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-008-TC01', 'ONB-STEP-008', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify provider entry with valid NPI', 'STEP', 'happy_path', 'Navigated to Ordering Providers step',
    '1. Navigate to Ordering Providers step\n2. Enter Provider Name: "Dr. Jane Smith"\n3. Enter NPI: "1234567890"\n4. Select Specialty from dropdown\n5. Click Add Provider\n6. Add second provider\n7. Click Next\n8. Verify form proceeds with valid data', 'Provider added with valid NPI, form proceeds to next step', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 29, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:02:44'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:02:44'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-009-TC01', 'ONB-STEP-009', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify review displays all data with edit navigation', 'STEP', 'happy_path', 'All steps completed with test data',
    '1. Complete all form steps with test data\n2. Navigate to Review step\n3. Verify Program Selection section shows selected program\n4. Verify Clinic Information section shows entered data\n5. Verify each section has an Edit button\n6. Click Edit on Clinic Information\n7. Verify navigates back to Step 2', 'Review page shows all entered data organized by section with Edit buttons', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 33, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:04:06'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:04:06'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-EXPORT-001-TC01', 'ONB-EXPORT-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify JSON export structure matches schema', 'EXPORT', 'happy_path', 'Form completed, on Review step',
    '1. Complete form with test data\n2. Navigate to Review step\n3. Click "Download JSON" button\n4. Open downloaded file\n5. Verify valid JSON (parseable)\n6. Verify schema_version present\n7. Verify submitted_at timestamp\n8. Verify structure matches sample files', 'Valid JSON file downloaded with correct structure matching sample-p4m.json format', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 36, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:04:12'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:04:12'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-UI-001-TC01', 'ONB-UI-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify progress indicator shows correct step', 'UI', 'happy_path', 'Form navigated to Step 3',
    '1. Complete Steps 1-2\n2. Navigate to Step 3\n3. Verify progress shows "Step 3 of 9"\n4. Verify current step title displayed\n5. Verify steps 1-2 show as completed\n6. Verify step 3 highlighted as current\n7. Verify steps 4-9 shown but not active', 'Progress indicator shows "Step 3 of 9" with step title and visual progress', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 37, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:04:18'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:04:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-UI-002-TC01', 'ONB-UI-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Previous/Next navigation works correctly', 'UI', 'happy_path', 'Form loaded',
    '1. Open form at Step 1\n2. Verify Previous button NOT visible\n3. Select program and click Next\n4. Verify now on Step 2\n5. Verify Previous button now visible\n6. Click Previous\n7. Verify returned to Step 1\n8. Select program, complete form to Step 8\n9. Verify Next button says "Review"', 'Previous/Next buttons navigate correctly, Previous hidden on Step 1', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 38, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:04:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:04:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-UI-003-TC01', 'ONB-UI-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify branding consistency across form', 'UI', 'happy_path', 'Form loaded',
    '1. Open form\n2. Verify header displays "Propel Health"\n3. Verify headers use navy color (#1a365d)\n4. Verify buttons use teal color (#4a9aba)\n5. Navigate through all steps\n6. Verify consistent styling throughout\n7. Check for any visual bugs or misaligned elements', 'Consistent branding with navy headers, teal accents, professional appearance', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 39, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:05:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:05:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-001-TC03', 'ONB-SAVE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Auto-save triggers on field change', 'SAVE', 'happy_path', 'Browser localStorage is empty. Form is loaded at step 1.',
    '1. Select a program (e.g., P4M)\n2. Click Next to go to step 2\n3. Enter text in Clinic Name field\n4. Observe the save status bar', 'Save status bar displays "Auto-saved at [current time]" within 1-2 seconds of typing', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 2, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:07:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:07:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-001-TC04', 'ONB-SAVE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Auto-save stores correct data structure in localStorage', 'SAVE', 'validation', 'Form loaded. DevTools accessible.',
    '1. Fill out program selection and clinic name\n2. Open browser DevTools (F12)\n3. Go to Application tab > Local Storage\n4. Find the propel-onboarding-draft key\n5. Inspect the stored JSON value', 'Opening browser DevTools > Application > localStorage shows key "propel-onboarding-draft" with JSON containing formData, currentStep, savedAt, and version fields', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 3, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:07:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:07:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-001-TC05', 'ONB-SAVE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Auto-save captures current step position', 'SAVE', 'validation', 'Form loaded with empty localStorage.',
    '1. Complete steps 1-3 with valid data\n2. Navigate to step 4 (Contacts)\n3. Enter primary contact name\n4. Check localStorage value in DevTools\n5. Verify currentStep value', 'localStorage JSON shows currentStep matching the step number user navigated to (e.g., currentStep: 4 for Contacts)', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 4, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:07:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:07:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-002-TC04', 'ONB-SAVE-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Restore prompt appears when saved data exists', 'SAVE', 'happy_path', 'localStorage contains valid saved draft data from a previous session.',
    '1. Fill out form through step 3 with valid data\n2. Close the browser tab\n3. Open a new tab and navigate to the form URL\n4. Observe the page load', 'Modal appears with title "Resume Previous Session?", displays saved date/time, and shows "Resume Draft" and "Start Fresh" buttons', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 5, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:03'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:03'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-002-TC05', 'ONB-SAVE-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Resume Draft restores data and step position', 'SAVE', 'happy_path', 'Restore prompt is displayed after returning to form with saved data.',
    '1. With restore prompt displayed, click "Resume Draft"\n2. Verify the form data is restored (program, clinic name, etc.)\n3. Verify the current step matches where you left off', 'Form loads with all previously entered data populated and user is on step 3 (the step they were on when they left)', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 6, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-002-TC06', 'ONB-SAVE-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Start Fresh clears saved data', 'SAVE', 'happy_path', 'Restore prompt is displayed after returning to form with saved data.',
    '1. With restore prompt displayed, click "Start Fresh"\n2. Verify the form starts at step 1 with empty fields\n3. Refresh the page\n4. Verify no restore prompt appears', 'Form starts at step 1 with all fields empty. localStorage is cleared. No restore prompt appears on next page refresh.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 7, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:17'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-002-TC07', 'ONB-SAVE-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'No restore prompt when no saved data exists', 'SAVE', 'negative', 'Browser localStorage is empty (no saved draft). Use incognito mode or clear localStorage manually.',
    '1. Clear localStorage or open incognito window\n2. Navigate to the form URL\n3. Observe the page load', 'Form loads directly to step 1 with no modal prompt. User can immediately begin filling out the form.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 8, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:22'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:22'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-003-TC03', 'ONB-SAVE-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Save Draft downloads JSON file', 'SAVE', 'happy_path', 'Form has data entered in at least 2 steps.',
    '1. Fill out program selection (P4M)\n2. Fill out clinic information (name, address)\n3. Click "Save Draft" button in the status bar\n4. Observe the file download', 'JSON file downloads with filename "propel-onboarding-draft-YYYY-MM-DD.json" (e.g., propel-onboarding-draft-2025-01-08.json)', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 9, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:28'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:28'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-003-TC04', 'ONB-SAVE-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Downloaded file contains correct JSON structure', 'SAVE', 'validation', 'Downloaded draft file from Save Draft button.',
    '1. Download a draft file using Save Draft\n2. Open the downloaded .json file in a text editor\n3. Verify JSON structure contains required fields\n4. Verify formData contains the values entered in the form', 'JSON file contains: formData object with all entered values, currentStep number, savedAt ISO timestamp, version "1.0", isDraft: true', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 10, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:34'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:34'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-004-TC03', 'ONB-SAVE-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Load Draft restores form from file', 'SAVE', 'happy_path', 'Have a valid draft JSON file downloaded previously. Form is in a fresh state (different browser or cleared localStorage).',
    '1. Click "Load Draft" button in the status bar\n2. Select the previously downloaded draft JSON file\n3. Observe the form state after file loads', 'Form populates with all data from the draft file and navigates to the step that was saved in the file', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 11, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:41'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:41'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-004-TC04', 'ONB-SAVE-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Invalid file shows error message', 'SAVE', 'negative', 'Have an invalid JSON file or non-JSON file ready (e.g., a text file or malformed JSON).',
    '1. Click "Load Draft" button\n2. Select an invalid file (e.g., a .txt file or corrupted JSON)\n3. Observe the error handling', 'Alert message displays: "Unable to read file. Please select a valid Propel onboarding draft (.json)." Form remains unchanged.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 12, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-004-TC05', 'ONB-SAVE-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Load Draft works across different browsers', 'SAVE', 'edge_case', 'Draft file saved from Chrome browser. Firefox browser available.',
    '1. In Chrome, fill out form and click "Save Draft"\n2. Open Firefox browser\n3. Navigate to the form URL\n4. Click "Load Draft" and select the file saved from Chrome\n5. Verify form data is restored correctly', 'Draft file loads successfully and form is populated correctly in Firefox, even though the file was created in Chrome', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 13, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:08:54'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:08:54'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-005-TC03', 'ONB-SAVE-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Start Over shows confirmation modal', 'SAVE', 'happy_path', 'Form has data entered in multiple steps.',
    '1. Fill out form through step 3 with valid data\n2. Click "Start Over" button in the status bar\n3. Observe the confirmation modal', 'Confirmation modal appears with warning message and two buttons: "Cancel" and "Clear All"', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 14, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:09:02'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:09:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-005-TC04', 'ONB-SAVE-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Confirming Clear All resets form completely', 'SAVE', 'happy_path', 'Confirmation modal is displayed after clicking Start Over.',
    '1. With confirmation modal displayed, click "Clear All"\n2. Verify form returns to step 1\n3. Verify all fields are empty\n4. Check localStorage in DevTools to confirm it is cleared', 'Form resets to step 1 with all fields empty. localStorage is cleared. Auto-save indicator resets to "Your progress will be saved automatically"', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 15, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:09:09'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:09:09'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-005-TC05', 'ONB-SAVE-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Cancel returns to form without changes', 'SAVE', 'happy_path', 'Confirmation modal is displayed after clicking Start Over.',
    '1. With confirmation modal displayed, click "Cancel"\n2. Verify modal closes\n3. Verify form data is still present\n4. Verify user is still on the same step', 'Modal closes and form remains unchanged with all data intact. User stays on the same step.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'DRAFT', 16, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:09:17'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:09:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-006-TC02', 'ONB-SAVE-006', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Help icon expands informational panel', 'SAVE', 'happy_path', 'Form is loaded and status bar is visible.',
    '1. Locate the help icon (?) in the status bar\n2. Click the help icon\n3. Observe the expanded panel', 'Informational panel expands below the status bar with explanations of Auto-save, Save Draft, and Load Draft functionality', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'EDGE', 1, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:09:26'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:09:26'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-006-TC03', 'ONB-SAVE-006', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Help icon toggles panel closed', 'SAVE', 'happy_path', 'Help panel is currently expanded.',
    '1. With help panel expanded, click the help icon (?) again\n2. Observe the panel collapse', 'Panel collapses and is no longer visible. Help icon remains clickable.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'EDGE', 2, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:09:34'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:09:34'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-SAVE-006-TC04', 'ONB-SAVE-006', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Help content explains all save options and limitations', 'SAVE', 'validation', 'Help panel is expanded.',
    '1. Expand the help panel by clicking the (?) icon\n2. Read through the content\n3. Verify all three save methods are explained\n4. Verify the browser limitation note is present', 'Help panel contains: (1) Explanation that auto-save only works in same browser/device, (2) Description of Save Draft for cross-device access, (3) Description of Load Draft to restore from file, (4) Note about browser limitation clearly stated', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'EDGE', 3, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 11:09:42'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 11:09:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-004-TC01', 'ONB-STEP-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Genetic Counselor contact fields display', 'STEP', 'happy_path', 'Form loaded, navigated to Step 4 - Contacts',
    '1. Load the onboarding form\n2. Navigate to Step 4 - Contacts\n3. Locate the Genetic Counselor section\n4. Verify all three fields are present and marked required', 'Genetic Counselor section displays with Name, Email, and Phone fields, all marked as required with red asterisks', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 21, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:13:01'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:13:01'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-004-TC02', 'ONB-STEP-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Genetic Counselor field order in form', 'STEP', 'validation', 'Form loaded, navigated to Step 4 - Contacts',
    '1. Load the onboarding form\n2. Navigate to Step 4 - Contacts\n3. Review field order on the page\n4. Verify Genetic Counselor appears after Clinic Champion', 'Genetic Counselor section appears immediately after Clinic Champion section, before Primary Contact', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 22, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:13:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:13:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-007-TC02', 'ONB-STEP-007', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Ambry test options display in dropdown', 'STEP', 'happy_path', 'Form loaded, navigated to Step 7 - Test Products',
    '1. Load the onboarding form\n2. Navigate to Step 7 - Test Products\n3. Click on test panel dropdown\n4. Verify all 5 Ambry test options are listed', 'Dropdown displays all 5 Ambry test options: CustomNext-Cancer®, CancerNext-Expanded® +RNAinsight®, CancerNext-Expanded®, CancerNext-Expanded® + Limited Evidence Genes +RNAinsight®, CancerNext-Expanded® + Limited Evidence Genes', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 27, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:13:18'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:13:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-007-TC03', 'ONB-STEP-007', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify test code auto-populates on selection', 'STEP', 'happy_path', 'Form loaded, navigated to Step 7 - Test Products',
    '1. Navigate to Step 7 - Test Products\n2. Select "CancerNext-Expanded® +RNAinsight®" from dropdown\n3. Verify test code field auto-populates with "8875-R"\n4. Attempt to edit the test code field\n5. Verify field is read-only', 'Test code field displays "8875-R" and is read-only (not editable by user)', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 28, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:13:29'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:13:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC01', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify gene selector appears for CustomNext-Cancer selection', 'GENE', 'happy_path', 'Form loaded, navigated to Step 7 - Test Products',
    '1. Navigate to Step 7 - Test Products\n2. Select "CustomNext-Cancer®" from test panel dropdown\n3. Verify gene selector component appears\n4. Verify component contains: search input, gene checkbox list, selected genes area', 'Gene selector component appears below the test dropdown with search input, gene checkbox list, and selected genes area', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 1, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:13:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:13:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC02', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify gene selector hidden for non-CustomNext tests', 'GENE', 'negative', 'Form loaded, navigated to Step 7 - Test Products',
    '1. Navigate to Step 7 - Test Products\n2. Select "CancerNext-Expanded®" from dropdown\n3. Verify gene selector component is NOT visible\n4. Change selection to "CancerNext-Expanded® +RNAinsight®"\n5. Verify gene selector still not visible', 'Gene selector is not visible when non-CustomNext test is selected', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 2, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:13:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:13:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC03', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify search filter reduces gene list', 'GENE', 'happy_path', 'Gene selector visible after selecting CustomNext-Cancer®',
    '1. Select CustomNext-Cancer® to show gene selector\n2. Type "BRCA" in the search input field\n3. Verify gene list filters in real-time\n4. Verify only BRCA1 and BRCA2 are visible in the checkbox list', 'Gene list filters to show only BRCA1 and BRCA2, other genes are hidden', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 3, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:14:00'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:14:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC04', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Select All button functionality', 'GENE', 'happy_path', 'Gene selector visible, no genes currently selected',
    '1. Select CustomNext-Cancer® to show gene selector\n2. Verify count shows "0 of 90 genes selected"\n3. Click "Select All" button\n4. Verify count updates to "90 of 90 genes selected"\n5. Verify all gene chips appear in selected genes area', 'All 90 genes become selected, count shows "90 of 90 genes selected", all genes appear as chips in selected area', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 4, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:14:12'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:14:12'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC05', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Clear All button functionality', 'GENE', 'happy_path', 'Gene selector visible with multiple genes selected',
    '1. Select CustomNext-Cancer® to show gene selector\n2. Select several genes (BRCA1, BRCA2, ATM, CHEK2)\n3. Verify count shows "4 of 90 genes selected"\n4. Click "Clear All" button\n5. Verify count resets to "0 of 90 genes selected"\n6. Verify selected genes area is empty', 'All selections cleared, count shows "0 of 90 genes selected", selected genes area is empty', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 5, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:14:22'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:14:22'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC06', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify gene chip removal via X button', 'GENE', 'happy_path', 'Gene selector visible with BRCA1, BRCA2, ATM selected',
    '1. Select CustomNext-Cancer® and select BRCA1, BRCA2, ATM\n2. Verify count shows "3 of 90 genes selected"\n3. Locate BRCA1 chip in selected genes area\n4. Click the X button on the BRCA1 chip\n5. Verify BRCA1 chip is removed\n6. Verify count updates to "2 of 90 genes selected"\n7. Verify BRCA1 checkbox in the list is now unchecked', 'BRCA1 chip is removed, count updates to "2 of 90 genes selected", BRCA1 checkbox becomes unchecked in the list', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 6, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:14:35'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:14:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC07', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify validation requires at least one gene selected', 'GENE', 'negative', 'Gene selector visible with zero genes selected',
    '1. Select CustomNext-Cancer® to show gene selector\n2. Do not select any genes (count shows "0 of 90")\n3. Click "Next" button to proceed\n4. Verify validation error message appears\n5. Verify user cannot advance to next step', 'Form displays validation error "At least one gene must be selected", user cannot proceed to next step', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 7, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:14:50'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:14:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-GENE-001-TC08', 'ONB-GENE-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify JSON output includes selected genes array', 'GENE', 'validation', 'Form completed with CustomNext-Cancer® selected and 3 genes chosen (ATM, BRCA1, CHEK2)',
    '1. Complete form with CustomNext-Cancer® selected\n2. Select genes: ATM, BRCA1, CHEK2\n3. Navigate to Review step\n4. Download JSON output\n5. Open JSON file and verify test_panel structure\n6. Verify selected_genes array contains selected genes alphabetically\n7. Verify gene_count matches array length', 'JSON output contains test_panel object with: test_name="CustomNext-Cancer®", test_code="9511", selected_genes=["ATM","BRCA1","CHEK2"], gene_count=3', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'GRX', 8, NULL,
    FALSE, NULL,
    COALESCE('2026-01-08 13:15:02'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 13:15:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC01', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Invited Patient Count Displays Accurately', NULL, 'happy_path', '1. User logged in with dashboard access\n2. Test program has known number of invited patients in source system',
    '1. Navigate to Propel Analytics dashboard\n2. Select test program from program filter\n3. Locate "Number Invited" metric display\n4. Compare displayed count to source system count', 'Dashboard displays exact count matching source system with zero discrepancy. Count is clearly labeled as "Number (N) Invited".', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:20:58'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:20:58'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC02', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Metrics Segmented by Channel', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has invited patients across multiple channels',
    '1. Navigate to Propel Analytics dashboard\n2. Select test program with multi-channel invitations\n3. Review channel segmentation display\n4. Verify individual channel counts sum to total\n5. Apply channel filter and verify count updates', 'Dashboard displays separate counts for each channel (email, SMS, MyChart, etc.) that sum to the total invited count. Each channel segment is clearly labeled.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:21:04'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:04'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC03', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Data Loads Within 1 Second Performance', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has standard data volume (100-10000 patients)',
    '1. Clear browser cache\n2. Start timer/performance monitoring\n3. Navigate to Propel Analytics dashboard\n4. Select test program\n5. Record time until data fully renders\n6. Repeat 3 times and calculate average', 'Dashboard loads and displays data within 1 second as specified in acceptance criteria. No timeout or loading errors occur.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:21:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC04', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Unauthorized User Cannot Access Dashboard', NULL, 'negative', '1. Test user exists with NO dashboard access permission\n2. Test program has invited patient data',
    '1. Log in as user without dashboard access\n2. Attempt to navigate directly to dashboard URL\n3. Verify access is denied\n4. Attempt to access via API endpoint directly\n5. Verify API returns 403 Forbidden', 'User without dashboard permission cannot access the invited metrics. System displays access denied message or redirects to unauthorized page.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:21:17'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC05', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Dashboard Access Generates Audit Trail', NULL, 'validation', '1. Audit logging enabled for dashboard\n2. User logged in with dashboard access\n3. Access to audit log viewer or database',
    '1. Log in as authorized user\n2. Navigate to dashboard and view invited metrics\n3. Export data to CSV\n4. Access audit log system\n5. Locate entries for test user\n6. Verify view action logged with timestamp\n7. Verify export action logged with timestamp\n8. Verify log entries cannot be modified', 'Audit log contains entry with: user ID, timestamp, action type (view/export), data scope accessed, IP address. Entry is immutable and tamper-evident per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:21:26'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:26'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC06', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Data Accuracy Validation (Source vs Display)', NULL, 'validation', '1. Access to source system for comparison\n2. Known test data set with exact count\n3. Data pipeline has completed refresh',
    '1. Query source system for exact invited patient count\n2. Document source count with timestamp\n3. Navigate to dashboard\n4. Compare dashboard count to source count\n5. Verify counts match exactly (zero discrepancy)\n6. If discrepancy exists, check error/discrepancy log', 'Dashboard count matches source system exactly. Any discrepancy is logged with timestamp. Data integrity is maintained per 21 CFR 11.10(a) system validation requirements.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:21:33'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:33'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC07', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: Aggregated View Does Not Expose PHI', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has invited patient data',
    '1. Navigate to dashboard invited metrics\n2. Review default display for any patient identifiers\n3. Verify only aggregate counts are shown\n4. Check that MRN, name, DOB are NOT visible in default view\n5. Verify drill-down requires explicit action', 'Default view shows only aggregate counts (N=X) without exposing individual patient identifiers. No PHI visible until user explicitly drills down with proper authorization.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:21:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC08', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Empty State Shows Helpful Message', NULL, 'edge_case', '1. User logged in with dashboard access\n2. Test program exists with zero invited patients',
    '1. Navigate to dashboard\n2. Select program with no invitation data\n3. Observe empty state display\n4. Verify helpful message appears\n5. Verify no JavaScript errors in console', 'Dashboard displays helpful message like "No invitation data available for selected program" instead of errors, blank screen, or misleading zero counts.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:21:50'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC01', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'Email Open and Click Rates Display Accurately', NULL, 'happy_path', '1. User logged in with dashboard access\n2. Test program has known email engagement data\n3. Test emails sent with tracking pixels enabled',
    '1. Navigate to Email Engagement section of dashboard\n2. Select test program\n3. Review open/click/ignore metrics\n4. Compare displayed metrics to source email system\n5. Verify counts match with zero discrepancy', 'Dashboard displays email open rate, click rate, and ignore rate with accurate counts. Metrics refresh within 3 minutes of engagement activity.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:21:57'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:21:57'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC02', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'Email Metrics Filterable by Date Range', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has email data spanning multiple date ranges',
    '1. Navigate to Email Engagement dashboard\n2. Apply date range filter (e.g., last 7 days)\n3. Verify displayed data reflects only selected period\n4. Change to different date range (e.g., last 30 days)\n5. Verify metrics update accordingly\n6. Compare filtered counts to source system query with same date range', 'Dashboard filters to selected date range and displays engagement metrics only for that period. Totals update to reflect filtered data.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:22:03'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:22:03'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC03', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'Unauthorized User Cannot View Email Engagement', NULL, 'negative', '1. Test user exists with NO email engagement view permission\n2. Test program has email engagement data',
    '1. Log in as user without email engagement permission\n2. Attempt to navigate to email engagement dashboard\n3. Verify access is denied with appropriate message\n4. Attempt direct API access to email metrics endpoint\n5. Verify 403 Forbidden response', 'User without email engagement permission sees access denied. API returns 403 Forbidden for direct endpoint access.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:22:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:22:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC04', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'Historical Email Engagement Trends Display', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has at least 3 months of email engagement data',
    '1. Navigate to Email Engagement dashboard\n2. Locate historical trends visualization\n3. Verify trend shows data points over time\n4. Compare trend data points to source system\n5. Verify visual accurately represents underlying data', 'Dashboard displays historical trend line/chart showing email engagement over time. Trend data is accurate and allows comparison between periods.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:22:22'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:22:22'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC05', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Email Engagement Access Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. User logged in with dashboard access\n3. Access to audit log system',
    '1. Log in as authorized user\n2. Navigate to email engagement dashboard\n3. View and export email metrics\n4. Access audit log system\n5. Verify view action logged with timestamp and user ID\n6. Verify export action logged with timestamp\n7. Verify log entries cannot be modified or deleted', 'Audit log contains entry with user ID, timestamp, action (view email engagement), and data scope. Entry is immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:22:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:22:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC06', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Email Data Refresh Within 3 Minutes', NULL, 'validation', '1. Access to source email system\n2. Ability to trigger test email open event\n3. Dashboard access',
    '1. Record current dashboard email engagement count\n2. Trigger known test email open event in source system\n3. Start timer\n4. Refresh dashboard periodically\n5. Verify new engagement appears within 3 minutes\n6. Verify count incremented correctly', 'Dashboard updates within 3 minutes of source change. Data integrity maintained with zero discrepancy between source and display per 21 CFR 11.10(a).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:22:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:22:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-004-TC07', 'DIS-RECRUIT-004', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: Email Engagement Aggregated Without PHI', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has email engagement data',
    '1. Navigate to Email Engagement dashboard\n2. Review all visible data elements\n3. Verify no patient email addresses are displayed\n4. Verify no patient names or MRNs visible\n5. Confirm only aggregate metrics shown by default', 'Email engagement view shows only aggregate metrics (open rate %, click count). Individual patient email addresses and identifiers are not visible in default view.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:22:53'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:22:53'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC01', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'Opt-Out Count Displays Accurately', NULL, 'happy_path', '1. User logged in with dashboard access\n2. Test program has known opt-out data\n3. Source system accessible for comparison',
    '1. Navigate to Opt-Out Tracking dashboard\n2. Select test program\n3. Review opt-out count displayed\n4. Query source system for opt-out count\n5. Compare dashboard to source - verify zero discrepancy', 'Dashboard displays accurate count of users who opted out of reminder emails. Count matches source system with zero discrepancy.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:23:04'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:23:04'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC02', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'Opt-Out Data Segmented by Date Range', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has opt-out data spanning multiple date ranges',
    '1. Navigate to Opt-Out Tracking dashboard\n2. Apply date range filter (e.g., last 30 days)\n3. Verify data reflects selected period only\n4. Review historical trend visualization\n5. Compare trend to source data for accuracy', 'Opt-out data segmented by date range showing when opt-outs occurred. Historical trend visible for identifying patterns.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:23:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:23:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC03', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'Opt-Out Participant Can Change Mind and Opt Back In', NULL, 'happy_path', '1. User logged in with dashboard access\n2. Test participant who previously opted out\n3. Access to source system to trigger opt-in',
    '1. Verify test participant shows as opted-out in dashboard\n2. Process opt-back-in for test participant in source system\n3. Refresh dashboard\n4. Verify participant status updated\n5. Verify historical opt-out record preserved with timestamp\n6. Verify opt-in recorded with new timestamp', 'System maintains record of opt-out with timestamp. When user opts back in, historical opt-out record is preserved with clear status change timeline.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:23:32'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:23:32'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC04', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'Unauthorized User Cannot View Opt-Out Data', NULL, 'negative', '1. Test user exists with NO opt-out view permission\n2. Test program has opt-out data',
    '1. Log in as user without opt-out view permission\n2. Attempt to navigate to opt-out tracking dashboard\n3. Verify access denied message displayed\n4. Attempt direct API access to opt-out endpoint\n5. Verify 403 Forbidden response', 'User without opt-out data permission sees access denied message. API returns 403 Forbidden for direct endpoint access.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:23:41'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:23:41'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC05', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Opt-Out Preference Changes Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. Test participant with opt-out history\n3. Access to audit log system',
    '1. Access audit log system\n2. Query audit entries for test participant opt-out\n3. Verify original opt-out event logged with timestamp\n4. If participant opted back in, verify that event also logged\n5. Verify complete timeline of preference changes\n6. Verify log entries cannot be modified or deleted', 'Audit trail contains: original opt-out timestamp, user who processed opt-out, any status changes, and current status. All entries immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:23:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:23:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC06', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Opt-Out Data Access Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. User logged in with opt-out view permission\n3. Access to audit log system',
    '1. Log in as authorized user\n2. Navigate to opt-out tracking dashboard\n3. Export opt-out data to CSV\n4. Access audit log system\n5. Verify view action logged with timestamp\n6. Verify export action logged with timestamp and scope\n7. Verify log entries cannot be modified', 'Viewing opt-out data generates audit entry with user ID, timestamp, action, and scope accessed. Entry is immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:23:54'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:23:54'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-005-TC07', 'DIS-RECRUIT-005', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: Opt-Out View Aggregated Without PHI', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has opt-out data',
    '1. Navigate to opt-out tracking dashboard\n2. Review default display\n3. Verify only aggregate counts shown (N opted out)\n4. Verify no individual email addresses visible\n5. Verify no patient names or MRNs visible in default view\n6. Confirm drill-down to individual records requires explicit action', 'Default view shows aggregate opt-out counts only. Individual participant identifiers (email, name, MRN) not visible without explicit drill-down action with proper authorization.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:24:04'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:24:04'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC01', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Generate List of Declined Patients', NULL, 'happy_path', '1. User logged in with patient list access permission\n2. Test program has patients with various consent statuses\n3. Known count of declined patients in source system',
    '1. Navigate to On-demand Patient Lists feature\n2. Select test program\n3. Filter by consent status = "Declined"\n4. Generate patient list\n5. Verify count matches source system\n6. Verify list contains expected patient identifiers', 'System generates list of patients matching "Declined" consent status with accurate count matching source system. List includes required identifiers for cohort identification.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:24:29'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:24:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC02', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Generate List of Consented Patients', NULL, 'happy_path', '1. User logged in with patient list access permission\n2. Test program has consented patients\n3. Known count of consented patients in source system',
    '1. Navigate to On-demand Patient Lists feature\n2. Select test program\n3. Filter by consent status = "Consented"\n4. Generate patient list\n5. Verify count matches source system\n6. Verify list exportable for offline analysis', 'System generates list of consented patients. Count matches source system. List ready for future study cohort identification.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:24:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:24:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC03', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Generate List of Future Research Opt-In Patients', NULL, 'happy_path', '1. User logged in with patient list access permission\n2. Test program has future research opt-in data\n3. Known count of opted-in patients',
    '1. Navigate to On-demand Patient Lists feature\n2. Select test program\n3. Filter by "Opted-in for Future Research" = Yes\n4. Generate patient list\n5. Verify count matches source system\n6. Verify opt-in date visible for each patient', 'System generates list of patients who opted-in for future research. List includes consent date and scope of opt-in. Count matches source system.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:24:45'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:24:45'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC04', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Unauthorized User Cannot Generate Patient Lists', NULL, 'negative', '1. Test user exists with NO patient list access permission\n2. Test program has patient data',
    '1. Log in as user without patient list permission\n2. Attempt to navigate to On-demand Patient Lists\n3. Verify access denied message displayed\n4. Attempt direct API access to patient list endpoint\n5. Verify 403 Forbidden response\n6. Verify no patient data leaked in error response', 'User without patient list permission sees access denied message. API returns 403 Forbidden. No patient data exposed.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:24:56'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:24:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC05', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Patient List Generation Performance Under 1 Second', NULL, 'validation', '1. User logged in with patient list access\n2. Test program has 100-10000 patients',
    '1. Clear browser cache\n2. Start timer\n3. Navigate to On-demand Patient Lists\n4. Generate list with filters\n5. Record time to display results\n6. Repeat 3 times and calculate average\n7. Verify average under 1 second', 'Data loads within 1 second as specified in acceptance criteria. No timeout or performance issues with standard data volumes.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:25:23'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:25:23'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC06', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Patient List Query and Export Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. User logged in with patient list permission\n3. Access to audit log system',
    '1. Log in as authorized user\n2. Generate patient list with specific filters\n3. Export list to CSV\n4. Access audit log system\n5. Verify query action logged with filter parameters\n6. Verify export action logged with record count\n7. Verify entries immutable', 'Audit log contains: user ID, timestamp, query parameters used, number of records returned, export action if any. Entry immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:25:33'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:25:33'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC07', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Patient List Data Accuracy Validation', NULL, 'validation', '1. Access to source system for comparison\n2. Known test data set\n3. Patient list access permission',
    '1. Query source system for specific patient cohort\n2. Document source count and patient IDs\n3. Generate same cohort via On-demand Patient Lists\n4. Compare patient IDs between systems\n5. Verify zero discrepancy in count and content\n6. Verify patient data fields match source exactly', 'Patient list data matches source system exactly with zero discrepancy. Data integrity maintained per 21 CFR 11.10(a) validation requirements.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:25:51'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:25:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC08', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: Patient List Export Contains Minimum Necessary PHI', NULL, 'validation', '1. User logged in with patient list export permission\n2. Test program has patient data',
    '1. Generate patient list\n2. Export to CSV\n3. Review exported fields\n4. Verify only necessary identifiers included (MRN, name, DOB)\n5. Verify no SSN or full address exported\n6. Verify export logged for accounting of disclosures', 'Patient list export includes minimum necessary PHI for research purpose. No extraneous identifiers (SSN, full address) included. Export logged per HIPAA accounting of disclosures requirement.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:26:16'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:26:16'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-006-TC09', 'DIS-RECRUIT-006', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: Patient List Access Restricted by Program Scope', NULL, 'validation', '1. Test user with restricted program scope\n2. Multiple programs with patient data exist\n3. User only authorized for Program A, not Program B',
    '1. Log in as user with restricted scope (Program A only)\n2. Navigate to On-demand Patient Lists\n3. Verify only Program A visible in program selector\n4. Attempt to access Program B via URL manipulation\n5. Verify access denied\n6. Verify no Program B patient data leaked', 'User with restricted program scope only sees patients from their authorized programs. Cross-program patient data not accessible.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:26:23'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:26:23'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC01', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'New MyChart Patient Proceeds to Consent', NULL, 'happy_path', '1. New patient not in Propel system\n2. MyChart recruitment pathway active\n3. Patient has valid MyChart credentials',
    '1. Access Propel via MyChart recruitment pathway\n2. System performs cross-validation check against existing e-consent records\n3. Verify validation completes without finding existing consent\n4. Verify patient is allowed to proceed to consent form\n5. Verify consent workflow initiates correctly', 'System validates patient against existing records. No existing consent found. Patient proceeds to consent workflow successfully.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:26:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:26:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC02', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'Existing Consent Detected - Duplicate Prevented', NULL, 'happy_path', '1. Patient already has consent record in Propel (from different recruitment pathway)\n2. MyChart recruitment pathway active\n3. Patient attempts to enroll via MyChart',
    '1. Access Propel via MyChart with patient who already consented\n2. System performs cross-validation check\n3. Verify existing consent detected\n4. Verify patient sees "already enrolled" screen\n5. Verify consent form NOT presented\n6. Verify patient receives clear guidance on their enrollment status', 'System detects existing consent. Patient shown "already enrolled" message. Duplicate consent submission prevented. Clear guidance provided to patient.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:26:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:26:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC03', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'MyChart Validation Metrics Display Accurately', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has MyChart validation data\n3. Known counts in source system',
    '1. Navigate to MyChart Cross Validation dashboard\n2. Review validation metrics\n3. Verify count of new enrollments via MyChart\n4. Verify count of duplicates detected\n5. Compare counts to source system\n6. Verify zero discrepancy', 'Dashboard accurately displays count of patients validated through MyChart pathway. Segmentation by outcome (new enrollments vs duplicates detected) visible.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:26:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:26:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC04', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'Cross Validation Service Timeout Handled Gracefully', NULL, 'negative', '1. MyChart pathway active\n2. Ability to simulate validation service timeout',
    '1. Access Propel via MyChart pathway\n2. Simulate validation service timeout/failure\n3. Verify graceful error handling\n4. Verify patient sees appropriate error message\n5. Verify consent form NOT presented during error\n6. Verify patient can retry validation', 'System handles validation timeout gracefully. Patient informed of issue and advised to try again. No consent processed during error state.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:27:27'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:27:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC05', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'Cross Validation Handles Similar Patient Demographics', NULL, 'edge_case', '1. Test patients with similar demographics\n2. One patient has existing consent, one does not\n3. MyChart pathway active',
    '1. Access MyChart with new patient who has similar name to existing patient\n2. Verify system uses MRN as primary identifier\n3. Verify correct patient matched (not false positive)\n4. Access MyChart with existing patient\n5. Verify existing consent correctly detected\n6. Verify no false negatives occur', 'System correctly matches or differentiates patients based on validated identifiers (MRN, DOB, name). Clear matching criteria prevents false positives and false negatives.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:27:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:27:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC06', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Cross Validation Results Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. MyChart validation completed\n3. Access to audit log system',
    '1. Complete MyChart cross validation (both new and duplicate scenarios)\n2. Access audit log system\n3. Verify validation event logged with timestamp\n4. Verify result (new patient or duplicate detected) logged\n5. Verify subsequent action (proceed to consent or show enrolled message) logged\n6. Verify log entries immutable', 'Audit log contains: validation timestamp, patient identifier used, validation result (new/duplicate), subsequent action taken. Entry immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:28:00'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:28:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC07', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Cross Validation Data Refresh Within 3 Minutes', NULL, 'validation', '1. Dashboard access\n2. Ability to trigger validation event\n3. Access to source system for comparison',
    '1. Record current dashboard validation count\n2. Trigger new MyChart validation event\n3. Start timer\n4. Refresh dashboard periodically\n5. Verify new validation appears within 3 minutes\n6. Verify count incremented correctly', 'Dashboard metrics updated within 3 minutes of validation event. Data integrity maintained with zero discrepancy per 21 CFR 11.10(a).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:28:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:28:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-009-TC08', 'DIS-RECRUIT-009', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: Cross Validation Uses Minimum Necessary PHI', NULL, 'validation', '1. User logged in with dashboard access\n2. MyChart validation data exists',
    '1. Navigate to MyChart Cross Validation dashboard\n2. Review default display\n3. Verify only aggregate counts shown (N validated, N duplicates)\n4. Verify no individual patient identifiers visible\n5. Verify validation logic uses minimum necessary identifiers', 'Cross validation uses minimum necessary patient identifiers. Dashboard shows aggregate metrics without exposing individual patient details in default view.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:28:46'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:28:46'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC01', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'Send SMS Reminder Successfully', NULL, 'happy_path', '1. User logged in with SMS outreach permission\n2. Test patient with valid phone number\n3. SMS service configured and active',
    '1. Navigate to SMS Outreach feature\n2. Select test patient/cohort\n3. Compose and send SMS reminder\n4. Verify SMS delivery status\n5. Navigate to dashboard\n6. Verify SMS count incremented correctly', 'SMS successfully sent to patient. Delivery status tracked. Dashboard shows accurate count of SMS sent matching source system.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:28:53'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:28:53'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC02', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'SMS Metrics Display Accurately with Segmentation', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has SMS outreach data\n3. Source system accessible for comparison',
    '1. Navigate to SMS Outreach dashboard\n2. Review SMS sent metrics\n3. Verify channel segmentation visible\n4. Review historical trend visualization\n5. Verify conversion rates calculated correctly\n6. Compare metrics to source system', 'Dashboard displays SMS metrics segmented by channel. Historical trends visible. Conversion rates from SMS to enrollment calculated correctly.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:28:59'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:28:59'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC03', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'Unauthorized User Cannot Send SMS', NULL, 'negative', '1. Test user exists with NO SMS permission\n2. SMS service active',
    '1. Log in as user without SMS permission\n2. Attempt to navigate to SMS Outreach feature\n3. Verify access denied message\n4. Attempt to send SMS via API\n5. Verify 403 Forbidden response', 'User without SMS permission sees access denied. Cannot send SMS or view SMS metrics. API returns 403 Forbidden.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:29:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:29:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC04', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'SMS to Invalid Phone Number Handled Gracefully', NULL, 'negative', '1. User logged in with SMS permission\n2. Test patient with invalid phone number',
    '1. Navigate to SMS Outreach\n2. Select patient with invalid phone number\n3. Attempt to send SMS\n4. Verify phone number validation fails\n5. Verify clear error message displayed\n6. Verify delivery failure logged', 'System validates phone number before sending. Invalid numbers flagged. Delivery failure logged appropriately. User informed of failure with clear error message.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:29:27'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:29:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC05', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'SMS Dashboard Load and Refresh Performance', NULL, 'validation', '1. User logged in with dashboard access\n2. SMS activity occurred recently\n3. Standard data volume',
    '1. Clear browser cache\n2. Start timer\n3. Navigate to SMS Outreach dashboard\n4. Verify page loads within 2 seconds\n5. Send test SMS\n6. Verify dashboard updates within 2 minutes', 'Dashboard loads within 2 seconds as specified. Data refreshes within 2 minutes of SMS activity.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:30:17'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:30:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC06', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: SMS Send Actions Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. SMS sent through platform\n3. Access to audit log system',
    '1. Send SMS through platform\n2. Access audit log system\n3. Verify SMS send event logged with timestamp\n4. Verify sender user ID captured\n5. Verify recipient identifier logged\n6. Verify delivery status logged\n7. Verify log entries immutable', 'Audit log contains: SMS send timestamp, sender user ID, recipient identifier, message content summary, delivery status. Entry immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:30:25'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:30:25'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC07', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: SMS Metrics Access Audit Trail', NULL, 'validation', '1. Audit logging enabled\n2. User logged in with dashboard access\n3. Access to audit log system',
    '1. Log in as authorized user\n2. Navigate to SMS Outreach dashboard\n3. Export SMS data to CSV\n4. Access audit log system\n5. Verify view action logged\n6. Verify export action logged with record count\n7. Verify log entries immutable', 'Viewing SMS metrics generates audit entry with user ID, timestamp, action, and scope. Entry immutable per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:30:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:30:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC08', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: SMS Content Does Not Contain PHI', NULL, 'validation', '1. User logged in with SMS permission\n2. Test patient eligible for SMS\n3. Message templates available',
    '1. Navigate to SMS Outreach\n2. Review available message templates\n3. Compose SMS using template\n4. Review final SMS content before sending\n5. Verify no patient name in message\n6. Verify no health information in message\n7. Verify generic reminder text only', 'SMS content does not contain PHI. Message uses generic text without patient name or health information. Compliant with HIPAA minimum necessary standard.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:30:38'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:30:38'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-011-TC09', 'DIS-RECRUIT-011', 'PRG-DIS-A2C1AD11', NULL,
    'HIPAA: SMS Dashboard Aggregated Without PHI', NULL, 'validation', '1. User logged in with dashboard access\n2. SMS outreach data exists',
    '1. Navigate to SMS Outreach dashboard\n2. Review default display\n3. Verify only aggregate counts shown (N SMS sent)\n4. Verify no individual phone numbers visible\n5. Verify no patient names visible in default view\n6. Confirm drill-down requires explicit action', 'Default view shows aggregate SMS metrics only. Individual phone numbers and patient identifiers not visible without explicit drill-down with proper authorization.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:31:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:31:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC09', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Funnel Shows Progression from Invitation to Enrollment', NULL, 'happy_path', '1. User logged in with dashboard access\n2. Test program has patients at each funnel stage\n3. Known counts at each stage from source system',
    '1. Navigate to Propel Analytics dashboard\n2. Select test program\n3. Locate recruitment funnel visualization\n4. Verify all funnel stages displayed (Invited → Enrolled)\n5. Verify counts at each stage match source system\n6. Verify drop-off percentages calculated correctly between stages', 'Dashboard displays recruitment funnel visualization showing: Invited → Opened → Clicked → Consented → Enrolled. Each stage shows count and drop-off percentage to next stage.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:38:07'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:38:07'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC10', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Historical Trends Visible for Comparison', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has at least 3 months of invitation data\n3. Source system accessible for comparison',
    '1. Navigate to Propel Analytics dashboard\n2. Select test program\n3. Locate historical trends visualization\n4. Verify trend displays data over multiple time periods\n5. Compare trend data points to source system\n6. Verify week-over-week or month-over-month comparison available\n7. Verify trend accurately reflects invitation volume changes', 'Dashboard displays historical trend chart/graph showing invitation counts over time. Trend allows comparison between periods (week-over-week, month-over-month). Trend data points match source system records.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:38:15'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:38:15'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC11', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Conversion Rates Calculated Correctly Between Stages', NULL, 'validation', '1. User logged in with dashboard access\n2. Test program has known counts at each funnel stage\n3. Expected conversion rates pre-calculated for validation',
    '1. Navigate to Propel Analytics dashboard\n2. Select test program with known funnel data\n3. Locate conversion rate metrics between stages\n4. Manually calculate expected rates: Invited→Opened, Opened→Clicked, Clicked→Consented, Consented→Enrolled\n5. Compare displayed rates to manual calculations\n6. Verify all rates match with zero discrepancy\n7. Verify edge case: 0 in denominator shows appropriate handling (not error)', 'Conversion rates calculated correctly: (Next Stage Count / Current Stage Count) × 100. All rates mathematically accurate. Rates displayed with appropriate precision (e.g., 45.2%).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 10:38:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:38:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC12', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Display Updates Within 1 Minute of Data Change', NULL, 'validation', '1. User logged in with dashboard access\n2. Ability to add invitation record in source system\n3. Dashboard displaying current invitation count',
    '1. Navigate to dashboard and record current invited count\n2. Add new invitation record in source system\n3. Document timestamp of source change\n4. Start timer\n5. Refresh dashboard periodically (every 15 seconds)\n6. Record when dashboard count increments\n7. Verify update occurs within 1 minute of source change\n8. Verify new count is accurate (previous count + 1)', 'Dashboard displays updated count within 1 minute of source data change per success metrics. Data integrity maintained throughout refresh. No stale data displayed after refresh interval.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:38:35'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:38:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'DIS-RECRUIT-001-TC13', 'DIS-RECRUIT-001', 'PRG-DIS-A2C1AD11', NULL,
    'Part 11: Data Exportable for Offline Analysis', NULL, 'happy_path', '1. User logged in with dashboard and export permission\n2. Test program has invitation data\n3. Access to audit log system',
    '1. Navigate to Propel Analytics dashboard\n2. Select test program\n3. Locate and click export button/option\n4. Select export format (CSV or Excel)\n5. Download exported file\n6. Open file and verify data matches dashboard display\n7. Verify column headers are clear and descriptive\n8. Access audit log system\n9. Verify export action logged with timestamp and record count', 'Export generates downloadable file (CSV/Excel) containing invitation data. Exported data matches dashboard display exactly. Export logged in audit trail with user ID, timestamp, and record count per 21 CFR 11.10(e).', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-09 10:38:45'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 10:38:45'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-002-TC02', 'ONB-STEP-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify clinic phone field always visible and required', 'STEP', 'happy_path', 'Form loaded, navigated to Step 2 - Clinic Information',
    '1. Load onboarding form\n2. Navigate to Step 2 - Clinic Information\n3. Locate Clinic Office Phone Number field\n4. Verify field is visible and marked required', 'Clinic Office Phone Number field displays as required with red asterisk, positioned after clinic address', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 3, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:08:57'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:08:57'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-002-TC03', 'ONB-STEP-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify patient communication checkbox displays', 'STEP', 'happy_path', 'Form loaded, navigated to Step 2 - Clinic Information',
    '1. Navigate to Step 2 - Clinic Information\n2. Locate checkbox below clinic phone field\n3. Verify checkbox label reads "This number can be used on patient communications"\n4. Verify checkbox is unchecked by default', 'Checkbox displays below clinic phone field, unchecked by default', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 4, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:09:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:09:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-002-TC04', 'ONB-STEP-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify helpdesk fields appear when checkbox checked', 'STEP', 'happy_path', 'Form loaded, navigated to Step 2 - Clinic Information',
    '1. Navigate to Step 2 - Clinic Information\n2. Locate "Does this clinic have a separate patient-facing helpline?" checkbox\n3. Check the checkbox\n4. Verify two new fields appear: Helpline Phone Number and Helpline Hours of Operation', 'Helpline Phone Number and Helpline Hours fields appear below the checkbox', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 5, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:09:22'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:09:22'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-002-TC05', 'ONB-STEP-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify helpdesk fields hidden when checkbox unchecked', 'STEP', 'negative', 'Form loaded, navigated to Step 2 - Clinic Information, helpline checkbox unchecked',
    '1. Navigate to Step 2 - Clinic Information\n2. Verify "Does this clinic have a separate patient-facing helpline?" checkbox is unchecked\n3. Verify Helpline Phone Number field is NOT visible\n4. Verify Helpline Hours field is NOT visible', 'Helpline Phone Number and Helpline Hours fields are not visible on the page', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 6, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:09:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:09:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-005-TC01', 'ONB-STEP-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Program Champion fields are optional', 'STEP', 'happy_path', 'Form loaded, navigated to Step 5 - Key Stakeholders',
    '1. Navigate to Step 5 - Key Stakeholders\n2. Leave Program Champion fields blank (name, title, email)\n3. Click Next\n4. Verify form proceeds to Step 6', 'Form proceeds to next step without Program Champion information', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 23, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:09:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:09:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-006-TC02', 'ONB-STEP-006', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify sample type checkbox label is correctly worded', 'STEP', 'happy_path', 'Form loaded, navigated to Step 6 - Lab Configuration',
    '1. Navigate to Step 6 - Lab Configuration\n2. Locate the sample type section\n3. Verify checkbox exists with label "Offer additional sample type options"\n4. Verify checking the box reveals alternate specimen type dropdown', 'Checkbox displays with label "Offer additional sample type options"', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 25, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:10:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:10:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC04', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify email validation rejects invalid format', 'FORM', 'validation', 'Form loaded, navigated to any step with email input',
    '1. Navigate to Step 4 - Contacts\n2. In Primary Contact Email field, enter "invalid-email"\n3. Click out of the field (blur)\n4. Verify validation error appears', 'Error message displays: "Please enter a valid email address"', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 12, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:10:19'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:10:19'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC05', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify email validation accepts valid format', 'FORM', 'happy_path', 'Form loaded, navigated to any step with email input',
    '1. Navigate to Step 4 - Contacts\n2. In Primary Contact Email field, enter "jane.doe@clinic.org"\n3. Click out of the field (blur)\n4. Verify no validation error appears', 'Field accepts input, no validation error displayed', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 13, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:10:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:10:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC06', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify ZIP validation accepts 5-digit and ZIP+4', 'FORM', 'happy_path', 'Form loaded, navigated to any step with ZIP input',
    '1. Navigate to Step 2 - Clinic Information\n2. In clinic address ZIP field, enter "98101"\n3. Verify no validation error\n4. Clear field and enter "98101-1234"\n5. Verify no validation error', 'Both formats accepted: 5-digit (98101) and ZIP+4 (98101-1234)', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 14, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:10:53'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:10:53'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC07', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify ZIP validation rejects invalid formats', 'FORM', 'negative', 'Form loaded, navigated to any step with ZIP input',
    '1. Navigate to Step 2 - Clinic Information\n2. In clinic address ZIP field, enter "9810" (4 digits)\n3. Verify validation error appears\n4. Clear and enter "981011" (6 digits)\n5. Verify validation error appears\n6. Clear and enter "ABCDE" (letters)\n7. Verify validation error appears', 'Validation error displays for each invalid format', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 15, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:11:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:11:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-003-TC08', 'ONB-FORM-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify phone validation accepts multiple formats', 'FORM', 'happy_path', 'Form loaded, navigated to any step with phone input',
    '1. Navigate to Step 2 - Clinic Information\n2. In clinic phone field, enter "5551234567" (no separators)\n3. Verify no validation error\n4. Clear and enter "555-123-4567" (dashes)\n5. Verify no validation error\n6. Clear and enter "555.123.4567" (dots)\n7. Verify no validation error', 'All three formats accepted without validation error', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 16, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:11:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:11:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-010-TC01', 'ONB-STEP-010', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify provider filter fields appear when checkbox checked', 'STEP', 'happy_path', 'Form loaded, navigated to Step 9 - Extract Filtering',
    '1. Navigate to Step 9 - Extract Filtering\n2. Locate "Filter by provider" checkbox\n3. Check the checkbox\n4. Verify provider input section appears\n5. Verify First Name field is visible and required\n6. Verify Last Name field is visible and required', 'Repeatable provider section appears with First Name and Last Name fields, both marked required', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 30, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:11:51'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:11:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-010-TC02', 'ONB-STEP-010', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify provider list mandatory when filter checkbox checked', 'STEP', 'negative', 'Form loaded, navigated to Step 9 - Extract Filtering',
    '1. Navigate to Step 9 - Extract Filtering\n2. Check "Filter by provider" checkbox\n3. Leave First Name and Last Name fields empty\n4. Click Next\n5. Verify validation error prevents navigation', 'Validation error prevents navigation: "At least one provider is required when filtering by provider"', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 31, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:12:14'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:12:14'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-010-TC03', 'ONB-STEP-010', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Add Provider button creates additional entry', 'STEP', 'happy_path', 'Form loaded, navigated to Step 9 - Extract Filtering, provider filter checkbox checked',
    '1. Navigate to Step 9 - Extract Filtering\n2. Check "Filter by provider" checkbox\n3. Enter first provider: First Name = "Jane", Last Name = "Smith"\n4. Click "Add Provider" button\n5. Verify second provider entry appears', 'Second provider entry appears with First Name and Last Name fields', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 32, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:12:35'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:12:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-009-TC02', 'ONB-STEP-009', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Word document download button works', 'STEP', 'happy_path', 'Form completed through all steps, on Step 10 - Review and Download',
    '1. Complete form through all steps\n2. Navigate to Step 10 - Review and Download\n3. Click "Download Word Document" button\n4. Verify .docx file downloads\n5. Verify filename includes clinic name and date', 'Word document (.docx) downloads with filename format: {clinic-name}-onboarding-YYYY-MM-DD.docx', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 34, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:13:00'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:13:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-009-TC03', 'ONB-STEP-009', '9bcd1428-0bd4-487e-8b43-42563fee3b75', 'UAT-ONB-V1',
    'Verify Word document contains all form sections', 'STEP', 'validation', 'Word document downloaded from completed form',
    '1. Download Word document from completed form\n2. Open document in Microsoft Word\n3. Verify document contains Program Selection\n4. Verify document contains Clinic Information (name, address, phone)\n5. Verify document contains Contacts section\n6. Verify document contains Stakeholders section\n7. Verify document contains Lab Configuration\n8. Verify document contains Test Products\n9. Verify document contains Ordering Providers\n10. Verify document contains Extract Filtering settings\n11. Verify all data matches what was entered in the form', 'Word document contains all sections with accurate data from form entries', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, 'P4M', 35, NULL,
    FALSE, NULL,
    COALESCE('2026-01-09 14:13:23'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-09 14:13:23'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC10', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Filter by TC-Enabled Clinics Only', NULL, 'happy_path', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate TC status filter control\n3. Select "TC-Enabled Clinics Only"\n4. Verify dashboard updates to show only TC-enabled clinics\n5. Confirm TC-specific metrics are displayed', 'Dashboard displays only clinics with TC enabled; all TC-specific metrics (lifetime risk %, TC score) are populated and accurate', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:53:06'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:53:06'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC11', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Filter by TC-Disabled Clinics Only', NULL, 'happy_path', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Select "TC-Disabled Clinics Only" filter\n3. Verify only TC-disabled clinics appear\n4. Confirm TC-specific metrics are appropriately excluded or grayed out\n5. Confirm NCCN eligibility metrics are still displayed', 'Dashboard displays only TC-disabled clinics; TC-specific metrics (lifetime risk %, TC score) are grayed out or excluded; NCCN eligibility metrics remain visible', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:53:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:53:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC12', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'TC Data Availability Footnote Displays Correctly', NULL, 'validation', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate footnote/indicator showing TC data availability\n3. Verify footnote lists clinic types with TC enabled (e.g., "TC data included: Mammography, OBGYN")\n4. Verify footnote lists clinic types without TC (e.g., "TC data not included: Endoscopy")\n5. Change filter selections and confirm footnote updates accordingly\n6. Verify footnote is visible in both dashboard view and exported reports', 'Footnote or indicator clearly shows: (1) which clinic types have TC enabled, (2) which clinic types have TC disabled, (3) information updates when filters change', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:53:27'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:53:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC13', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Combined TC Status and Clinic Type Filter', NULL, 'happy_path', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Set TC status filter to "TC-Enabled Only"\n3. Set clinic type filter to "Mammography"\n4. Verify both filters are applied simultaneously\n5. Confirm metrics reflect only mammography clinics with TC enabled\n6. Verify patient counts match combined filter criteria', 'Dashboard correctly filters to show only mammography clinics with TC enabled; metrics reflect only that subset; footnote indicates current filter state', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:53:35'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:53:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC14', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'TC High-Risk Patient Percentage Comparison by Clinic', NULL, 'validation', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. View TC-enabled clinics\n3. Locate percentage comparison display showing TC high-risk patients by clinic\n4. Verify percentage is calculated as (TC high-risk patients / total assessed patients) per clinic\n5. Verify percentages are displayed for multiple clinics simultaneously for comparison\n6. Confirm percentages update when date range or other filters change', 'Dashboard displays percentage of TC high-risk patients (>20% lifetime risk) for each clinic/clinic type, allowing side-by-side comparison across the program', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:53:43'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:53:43'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-001-TC15', 'P4M-ANALYTICS-001', 'P4M-7EC35FEE', NULL,
    'Patient Seen in Both TC-Enabled and TC-Disabled Clinic Types', NULL, 'edge_case', NULL,
    '1. Identify a patient seen in both mammography (TC enabled) and endoscopy (TC disabled)\n2. Filter dashboard to mammography only\n3. Verify patient appears with TC metrics displayed\n4. Filter dashboard to endoscopy only\n5. Verify same patient appears without TC metrics (NCCN only)\n6. Filter to "All Clinics" and verify patient is counted appropriately without duplication\n7. Verify footnote correctly indicates TC availability by clinic type', 'Patient appears in mammography metrics with TC score displayed; same patient appears in endoscopy metrics without TC score (NCCN only); no duplicate counting when viewing "All Clinics" filter', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:53:51'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:53:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC01', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Positive Variant Counts Display Correctly', NULL, 'happy_path', NULL,
    '1. Navigate to analytics dashboard gene-level reporting section\n2. Verify display shows count of patients for each positive gene variant\n3. Verify BRCA1, BRCA2, and other common variants are listed\n4. Cross-reference displayed counts against lab results data source\n5. Confirm counts reflect unique patients (not duplicate tests)', 'Dashboard displays count for each positive variant type (e.g., BRCA1: 15, BRCA2: 8, PSS1: 3); counts are accurate based on lab results data', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:56:50'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:56:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC02', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Positive Variant Percentages Calculate Correctly', NULL, 'validation', NULL,
    '1. Navigate to analytics dashboard gene-level reporting section\n2. Locate percentage display for each positive variant\n3. Verify percentage is calculated correctly: (patients with variant / total tested patients) × 100\n4. Verify percentages sum appropriately (patient can have multiple variants)\n5. Confirm denominator reflects total tested patients, not total patients in system', 'Dashboard displays percentage for each variant (e.g., "BRCA1: 3% of tested patients"); percentage calculation is (positive patients / total tested patients) × 100', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:56:57'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:56:57'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC03', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Date/Month Filter for Monthly Reporting', NULL, 'happy_path', NULL,
    '1. Navigate to analytics dashboard gene-level reporting section\n2. Locate date/month filter control\n3. Select a specific month (e.g., January 2025)\n4. Verify all variant counts update to reflect only that month''s data\n5. Verify percentages recalculate based on filtered data\n6. Confirm filter can be cleared to return to all-time view', 'Dashboard filters to show only carriers identified in January 2025; counts and percentages update to reflect filtered time period only', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:57:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:57:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC04', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Total Positive Counts Per Month (Aggregate)', NULL, 'validation', NULL,
    '1. Navigate to analytics dashboard gene-level reporting section\n2. Locate monthly aggregate positive counts display\n3. Verify total positive variant counts are shown by month\n4. Confirm display shows aggregate totals (all genes combined), not individual gene trends\n5. Verify month-over-month data allows comparison of total carrier identification volume', 'Dashboard displays aggregate total positive counts by month (e.g., "Jan: 12 positives, Feb: 15 positives"); does NOT break down by individual gene per month', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:57:12'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:57:12'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC05', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Positive Variant Breakdown by Clinic', NULL, 'happy_path', NULL,
    '1. Navigate to analytics dashboard gene-level reporting section\n2. Locate clinic breakdown view\n3. Verify each clinic is listed with its positive variant counts\n4. Verify variant counts per clinic sum to total program counts\n5. Confirm clinics with zero positives display appropriately (zero or excluded based on UX design)', 'Dashboard displays breakdown showing each clinic with its positive variant counts (e.g., "Franz Clinic: BRCA1: 5, BRCA2: 2; Portland Clinic: BRCA1: 10, BRCA2: 4")', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:57:20'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:57:20'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC06', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Positive Variant Breakdown by Program', NULL, 'happy_path', NULL,
    '1. Navigate to analytics dashboard gene-level reporting section\n2. Locate program breakdown view\n3. Verify each program (Prevention4ME, Precision4ME, GenomeRx, etc.) is listed with its positive variant counts\n4. Verify variant counts per program sum to total platform counts\n5. Confirm programs with zero testing volume display appropriately', 'Dashboard displays breakdown showing each program with its positive variant counts (e.g., "Prevention4ME: BRCA1: 8, BRCA2: 3; Precision4ME: BRCA1: 12, BRCA2: 5")', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:57:31'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:57:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC07', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Redox Lab Results Integration (Ambry)', NULL, 'validation', NULL,
    '1. Confirm a new positive variant result is received via Redox from Ambry lab\n2. Note the timestamp of result receipt\n3. Navigate to analytics dashboard gene-level reporting section\n4. Verify new result appears in variant counts\n5. Confirm update occurred within expected near real-time window\n6. Verify patient is counted only once even if multiple results exist', 'New positive variant result from Ambry lab appears in dashboard within expected timeframe; patient count and percentage update accordingly', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:57:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:57:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC08', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'No Testing Data Available for Selected Filter', NULL, 'negative', NULL,
    '1. Filter to a clinic or program with no genetic testing data\n2. Navigate to gene-level reporting section\n3. Verify dashboard handles empty state gracefully\n4. Confirm no JavaScript errors or broken visualizations\n5. Verify percentage calculations don''t produce divide-by-zero errors', 'Dashboard displays "No data" or appropriate empty state message; no errors occur; percentage calculations handle zero denominator gracefully', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:57:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:57:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC09', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Patient with Multiple Positive Variants', NULL, 'edge_case', NULL,
    '1. Identify a patient with multiple positive variants (e.g., both BRCA1 and BRCA2 positive)\n2. Navigate to gene-level reporting section\n3. Verify patient is counted in BRCA1 count\n4. Verify patient is counted in BRCA2 count\n5. Verify patient is counted only ONCE in total positive patients count\n6. Confirm percentage calculation uses unique patient count as numerator', 'Patient is counted once in each variant category (BRCA1 count +1, BRCA2 count +1); patient is NOT double-counted in total patient count; percentages reflect correct calculation', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:58:00'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:58:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-ANALYTICS-001-TC10', 'PLAT-ANALYTICS-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Combined Clinic, Program, and Month Filters', NULL, 'happy_path', NULL,
    '1. Navigate to gene-level reporting section\n2. Apply clinic filter (e.g., "Franz Clinic")\n3. Apply program filter (e.g., "Prevention4ME")\n4. Apply month filter (e.g., "January 2025")\n5. Verify all three filters are applied simultaneously\n6. Confirm variant counts reflect only data matching all filter criteria\n7. Verify clearing one filter updates results appropriately', 'Dashboard correctly applies all three filters simultaneously; variant counts reflect only data matching all filter criteria', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 12:58:08'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 12:58:08'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-002-TC01', 'P4M-DASH-002', 'P4M-7EC35FEE', NULL,
    'CM-Enabled Clinic Shows Both TC Scores on Dashboard', NULL, 'happy_path', NULL,
    '1. Log in as GC at a CM-enabled clinic\n2. Navigate to patient dashboard\n3. Select a patient with TC score calculated\n4. Verify both standard TC score and CM-adjusted TC score are displayed\n5. Confirm labels clearly distinguish the two scores', 'Dashboard displays two clearly labeled TC scores for each patient: "Standard TC Score: X%" and "CM-Adjusted TC Score: Y%"', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:01:17'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:01:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-002-TC02', 'P4M-DASH-002', 'P4M-7EC35FEE', NULL,
    'CM-Disabled Clinic Shows Only Standard TC Score', NULL, 'happy_path', NULL,
    '1. Log in as GC at a CM-disabled clinic\n2. Navigate to patient dashboard\n3. Select a patient with TC score calculated\n4. Verify only standard TC score is displayed\n5. Confirm no CM-adjusted score or CM-related labels appear', 'Dashboard displays only the standard TC score; no CM-adjusted score is shown or referenced', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:01:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:01:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-002-TC04', 'P4M-DASH-002', 'P4M-7EC35FEE', NULL,
    'High-Risk Threshold Applied to Clinic Default Score', NULL, 'validation', NULL,
    '1. Identify a patient where standard TC >20% but CM-adjusted TC <20% (or vice versa)\n2. Log in as GC at a CM-enabled clinic\n3. Navigate to patient dashboard\n4. Verify high-risk threshold indicator is applied to CM-adjusted score (the clinic default)\n5. Confirm high-risk flag correctly reflects CM-adjusted score threshold', 'High-risk indicator (>20%) is applied to the CM-adjusted score (clinic default); patient flagged as high-risk if CM-adjusted score >20%, even if standard TC is below 20%', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:01:45'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:01:45'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-002-TC01', 'P4M-CONFIG-002', 'P4M-7EC35FEE', NULL,
    'CM-Enabled Clinic Clinical Summary Shows CM-Adjusted Score Only', NULL, 'happy_path', NULL,
    '1. Generate clinical summary for a patient at a CM-enabled clinic\n2. Locate TC score section of the clinical summary\n3. Verify only ONE TC score is displayed (CM-adjusted)\n4. Verify messaging includes "Competing Mortality is incorporated into the TC score"\n5. Confirm no reference to standard/baseline TC score', 'Clinical summary displays only the CM-adjusted TC score; messaging states "Competing Mortality is incorporated into the TC score"; no standard TC score shown', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:01:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:01:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-002-TC02', 'P4M-CONFIG-002', 'P4M-7EC35FEE', NULL,
    'CM-Disabled Clinic Clinical Summary Shows Standard TC Score', NULL, 'happy_path', NULL,
    '1. Generate clinical summary for a patient at a CM-disabled clinic\n2. Locate TC score section of the clinical summary\n3. Verify standard TC score is displayed\n4. Verify standard messaging is used (no CM reference)\n5. Confirm formatting matches existing clinical summary standards', 'Clinical summary displays standard TC score with standard messaging; no CM-related content or messaging appears', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:02:08'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:02:08'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-002-TC03', 'P4M-CONFIG-002', 'P4M-7EC35FEE', NULL,
    'Patient Record Stores CM Calculation Indicator', NULL, 'validation', NULL,
    '1. Generate clinical summary for a patient at a CM-enabled clinic\n2. Access the patient record in the database\n3. Verify a note/indicator field exists showing CM was used in calculation\n4. Repeat for a CM-disabled clinic patient\n5. Verify indicator shows CM was NOT used\n6. Confirm indicator is available for reporting queries', 'Patient record includes indicator/note showing "CM calculation used: Yes/No"; indicator is accessible for reporting and audit purposes', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:02:19'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:02:19'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-002-TC01', 'P4M-ANALYTICS-002', 'P4M-7EC35FEE', NULL,
    'Analytics Shows Both CM and Non-CM High-Risk Counts', NULL, 'happy_path', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate high-risk patient metrics section\n3. Verify both "TC >20% with CM" and "TC >20% without CM" counts are displayed\n4. Confirm both metrics are calculated for all clinics (not just those with CM enabled)\n5. Verify counts differ (CM scores are generally lower than standard TC)', 'Analytics shows two separate metrics: "TC >20% with CM: X patients" and "TC >20% without CM: Y patients"; both calculated for all clinics regardless of their CM setting', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:02:33'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:02:33'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-002-TC02', 'P4M-ANALYTICS-002', 'P4M-7EC35FEE', NULL,
    'Filter by CM-Enabled vs CM-Disabled Clinics', NULL, 'happy_path', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate CM configuration filter\n3. Select "Clinics with CM on" filter\n4. Verify dashboard shows only CM-enabled clinics\n5. Switch to "Clinics with CM off" filter\n6. Verify dashboard shows only CM-disabled clinics\n7. Confirm both high-risk metrics (with/without CM) remain visible for comparison', 'Dashboard filters to show only CM-enabled clinics with both high-risk metrics; filter can be switched to show CM-disabled clinics', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:02:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:02:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-002-TC03', 'P4M-ANALYTICS-002', 'P4M-7EC35FEE', NULL,
    'Master List Shows CM Configuration by Clinic', NULL, 'validation', NULL,
    '1. Navigate to Prevention4ME analytics dashboard\n2. Locate master list or indicator showing CM configuration by clinic\n3. Verify all clinics are listed with their CM status (Enabled/Disabled)\n4. Confirm list is current and matches actual clinic configurations\n5. Verify list can be referenced while viewing analytics metrics', 'Master list displays all clinics with their CM configuration status (Enabled/Disabled); list is accessible from analytics dashboard for reference', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:02:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:02:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-ANALYTICS-002-TC04', 'P4M-ANALYTICS-002', 'P4M-7EC35FEE', NULL,
    'Individual Site Can Compare CM Impact on Their Data', NULL, 'validation', NULL,
    '1. Navigate to analytics for a specific clinic/site\n2. Verify both CM and non-CM high-risk counts are displayed for that site\n3. Confirm site can see the difference between counts (CM impact)\n4. Verify this works for both CM-enabled and CM-disabled sites\n5. Confirm data helps site understand their CM configuration decision', 'Individual site analytics shows both "TC >20% with CM" and "TC >20% without CM" for that site, allowing site to compare impact of their CM decision', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:03:08'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:03:08'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-003-TC01', 'P4M-CONFIG-003', 'P4M-7EC35FEE', NULL,
    'CM Configuration Applied at Clinic Level', NULL, 'happy_path', NULL,
    '1. Submit request to enable CM for Clinic A (via dev team request process)\n2. Dev team applies CM configuration change for Clinic A\n3. Verify Clinic A now shows CM-adjusted scores as default\n4. Verify Clinic B (CM-disabled) is unaffected\n5. Confirm configuration is at clinic level, not program level', 'CM configuration is applied at clinic level; enabling CM for Clinic A does not affect Clinic B''s configuration', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:03:27'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:03:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-003-TC02', 'P4M-CONFIG-003', 'P4M-7EC35FEE', NULL,
    'CM Configuration Change Creates Audit Entry', NULL, 'validation', NULL,
    '1. Submit request to change CM configuration for a clinic\n2. Dev team applies the configuration change\n3. Access audit log for configuration changes\n4. Verify audit entry includes: requester, timestamp, clinic, previous state, new state\n5. Confirm audit entry is immutable and Part 11 compliant', 'Audit log shows: who requested the change, when change was made, previous configuration state, new configuration state', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-13 13:03:35'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:03:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-003-TC03', 'P4M-CONFIG-003', 'P4M-7EC35FEE', NULL,
    'CM Toggle Independent from TC Toggle', NULL, 'validation', NULL,
    '1. Configure Clinic A with TC enabled AND CM enabled\n2. Configure Clinic B with TC enabled AND CM disabled\n3. Verify Clinic A shows CM-adjusted scores\n4. Verify Clinic B shows standard TC scores only\n5. Confirm TC and CM toggles operate independently\n6. Verify a clinic cannot have CM enabled if TC is disabled (dependency)', 'Clinic has TC enabled and CM enabled simultaneously; another clinic has TC enabled but CM disabled; both configurations work correctly', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:03:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:03:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-CONFIG-003-TC04', 'P4M-CONFIG-003', 'P4M-7EC35FEE', NULL,
    'CM Configuration in Centralized Configuration List', NULL, 'validation', NULL,
    '1. Access centralized configuration list for a clinic\n2. Verify CM toggle configuration is listed alongside other configurations\n3. Confirm TC toggle and CM toggle are both visible in the list\n4. Verify configuration list can be exported for reporting\n5. Confirm list matches actual clinic behavior', 'CM configuration appears in the centralized configuration list alongside TC toggle and other per-site configurations; list is accessible for reporting', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:04:10'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:04:10'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-002-TC05', 'P4M-DASH-002', 'P4M-7EC35FEE', NULL,
    'GC Assessment Modification Recalculates Both TC and CM-Adjusted Scores', NULL, 'happy_path', NULL,
    '1. Log in as GC at a CM-enabled clinic\n2. Navigate to patient dashboard and select a patient\n3. Modify one or more patient assessment responses (e.g., family history, age)\n4. Trigger TC score recalculation\n5. Verify BOTH standard TC score and CM-adjusted TC score are recalculated\n6. Confirm both updated scores are displayed on the dashboard\n7. Verify scores reflect the modified assessment data', 'System recalculates and displays BOTH the updated standard TC score AND the updated CM-adjusted TC score based on the modified assessment responses', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:07:44'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:07:44'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC01', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'View Available Artifacts for Selected Patient', NULL, 'happy_path', NULL,
    '1. Log in as GC\n2. Navigate to patient dashboard\n3. Select a patient from the list\n4. Locate artifact/document menu or action button\n5. Verify list of available artifacts is displayed\n6. Confirm only artifacts that exist for the patient are shown', 'Artifact menu displays available documents for that patient (consent form, assessment form, clinical summary, etc.); list shows only artifacts that exist for the patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:06'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:06'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC02', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Download Individual Artifact as PDF', NULL, 'happy_path', NULL,
    '1. Select a patient from the dashboard\n2. Open artifact menu\n3. Select an artifact (e.g., consent form)\n4. Click download button\n5. Verify PDF file downloads to local machine\n6. Open PDF and verify content is correct for the patient\n7. Verify filename includes patient identifier', 'PDF file downloads successfully; file opens correctly; content matches patient data; filename includes patient identifier', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC03', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Print Individual Artifact Directly from Dashboard', NULL, 'happy_path', NULL,
    '1. Select a patient from the dashboard\n2. Open artifact menu\n3. Select an artifact (e.g., assessment form)\n4. Click print button\n5. Verify browser print dialog opens\n6. Confirm artifact content is displayed in print preview\n7. Complete print and verify output', 'Browser print dialog opens with artifact content; document prints correctly without requiring a separate download step', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:20'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:20'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC04', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Select Multiple Patients from Dashboard', NULL, 'happy_path', NULL,
    '1. Navigate to patient dashboard\n2. Locate multi-select controls (checkboxes or selection mode)\n3. Select first patient\n4. Select second patient\n5. Select third patient\n6. Verify all three patients show as selected\n7. Verify selection count is displayed (e.g., "3 patients selected")\n8. Confirm bulk action options are available', 'Multiple patients can be selected via checkboxes; selection count is displayed; bulk action options become available', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:26'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:26'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC05', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Bulk Download Artifacts for Multiple Patients', NULL, 'happy_path', NULL,
    '1. Select multiple patients (3+) from the dashboard\n2. Open bulk action menu\n3. Select artifact type to download (e.g., consent forms)\n4. Click bulk download button\n5. Verify download initiates (progress indicator if large)\n6. Verify ZIP file or combined PDF is downloaded\n7. Open downloaded file and confirm all selected patients'' artifacts are included\n8. Verify each patient''s documents are clearly identifiable', 'ZIP file or combined PDF downloads containing artifacts for all selected patients; each patient''s documents are identifiable; all requested artifacts are included', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:33'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:33'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC06', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Artifact Includes Patient Identification and Timestamp', NULL, 'validation', NULL,
    '1. Download an artifact for a patient\n2. Open the downloaded PDF\n3. Verify patient name appears on the document\n4. Verify patient ID or MRN appears on the document\n5. Verify generation timestamp is included\n6. Confirm identification information is clearly visible (header or footer)', 'Downloaded/printed artifact includes: patient name, patient ID/MRN, document generation timestamp; information is clearly visible on the document', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC07', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Artifact Download/Print Creates Audit Entry', NULL, 'validation', NULL,
    '1. Download or print an artifact for a patient\n2. Access audit log\n3. Verify audit entry was created for the download/print action\n4. Confirm entry includes: user who accessed, patient ID, artifact type, action type (download vs print), timestamp\n5. Verify audit entry is immutable (cannot be edited or deleted)\n6. Repeat for bulk download and verify all patient accesses are logged', 'Audit log contains entry showing: GC user ID, patient ID(s), artifact type(s) accessed, action (download/print), timestamp; entry is immutable', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-13 13:11:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC08', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'No Artifacts Available for Patient', NULL, 'negative', NULL,
    '1. Select a patient who has no generated artifacts (new patient, no assessment completed)\n2. Open artifact menu\n3. Verify appropriate message indicates no artifacts available\n4. Confirm download/print buttons are disabled or not shown\n5. Verify no errors occur', 'System displays appropriate message (e.g., "No artifacts available for this patient"); no error occurs; download/print buttons are disabled or hidden', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:11:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:11:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PLAT-DASH-001-TC09', 'PLAT-DASH-001', '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Bulk Download Large Patient Selection', NULL, 'edge_case', NULL,
    '1. Select a large number of patients (20+) from the dashboard\n2. Initiate bulk download of artifacts\n3. Verify progress indicator is displayed during download generation\n4. Confirm system completes download or displays limit warning if exceeded\n5. If downloaded, verify all selected patients'' artifacts are included\n6. Verify system remains responsive during bulk operation', 'System handles large selection gracefully; progress indicator shows download status; download completes successfully or system notifies if limit exceeded', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:12:02'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:12:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-001-TC01', 'P4M-REFERRAL-001', 'P4M-7EC35FEE', NULL,
    'FHIR Lookup Success Auto-Populates Demographics', NULL, 'happy_path', 'Active FHIR connection to EHR. Patient exists in EHR.',
    '1. Navigate to referral creation form\n2. Enter patient search criteria (name, DOB, MRN)\n3. Click Search\n4. Observe search results', 'System returns matching patient from EHR. Demographics (name, DOB, email, address) auto-populate in referral form.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:30:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:30:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-001-TC02', 'P4M-REFERRAL-001', 'P4M-7EC35FEE', NULL,
    'FHIR Lookup No Match Shows Fallback Fields', NULL, 'negative', 'Active FHIR connection. Patient does NOT exist in EHR.',
    '1. Navigate to referral creation form\n2. Enter search criteria for non-existent patient\n3. Click Search\n4. Observe form behavior when no match found\n5. Verify required fallback fields are displayed', 'System displays "No match found" message. Form presents required fallback fields: Name, DOB, Email, and Referring Provider. User can manually enter patient information.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:30:54'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:30:54'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-001-TC03', 'P4M-REFERRAL-001', 'P4M-7EC35FEE', NULL,
    'Referral Invitation Email Includes Provider Details', NULL, 'happy_path', 'Referral record created with valid patient email and referring provider details.',
    '1. Create referral record with patient email and referring provider\n2. Click Send Invitation\n3. Check patient''s email inbox\n4. Review email content for referral-specific template\n5. Verify referring provider name appears in email body', 'Patient receives "Referral Assessment Invitation" email with: distinct referral branding, personalized message including referring provider name (e.g., "Dr. Smith referred you to the Prevention4ME program"), and link to complete assessments.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:02'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-001-TC04', 'P4M-REFERRAL-001', 'P4M-7EC35FEE', NULL,
    'Audit Trail Captures Referral Creation and Invitation', NULL, 'validation', 'User logged in with valid credentials.',
    '1. Log in as authorized user\n2. Create new referral record with all fields\n3. Send invitation to patient\n4. Navigate to audit log\n5. Search for referral creation event\n6. Verify all required fields are captured', 'Audit log contains: user ID who created referral, all referral form inputs, invitation send timestamp, and patient identifier. Audit entry is immutable and timestamped.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-13 13:31:09'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:09'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-001-TC05', 'P4M-REFERRAL-001', 'P4M-7EC35FEE', NULL,
    'Referring Provider Not Automatically Notified on Invitation', NULL, 'negative', 'Referral record created with referring provider email on file.',
    '1. Create referral record with referring provider details including email\n2. Send patient invitation\n3. Check referring provider''s email inbox\n4. Verify no automatic notification was sent\n5. Check system email logs for referring provider address', 'Referring provider does NOT receive any automatic notification. No email sent to referring provider''s email address. System only sends invitation to patient.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:15'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:15'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-002-TC01', 'P4M-REFERRAL-002', 'P4M-7EC35FEE', NULL,
    'Referral Patient Routes to TC and NCCN Only', NULL, 'happy_path', 'Patient received referral invitation and clicked link to begin.',
    '1. Click referral invitation link in email\n2. Begin assessment flow\n3. Observe assessment sequence presented\n4. Complete TC assessment\n5. Verify NCCN assessment follows\n6. Verify no consent or care-plan screens appear', 'Patient is presented with TC assessment followed by NCCN assessment. No genetic testing consent form, e-consent module, or care-plan steps are displayed during the flow.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:23'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:23'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-002-TC02', 'P4M-REFERRAL-002', 'P4M-7EC35FEE', NULL,
    'Patient Views Risk Results After Assessment Completion', NULL, 'happy_path', 'Patient completed TC and NCCN assessments.',
    '1. Complete TC assessment\n2. Complete NCCN assessment\n3. Submit final assessment\n4. Observe results page\n5. Verify TC score and risk category displayed\n6. Verify NCCN eligibility status displayed', 'Patient sees results page displaying: TC score with risk category, NCCN eligibility status, and summary of key risk factors. Results are clearly presented and understandable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:31'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-002-TC03', 'P4M-REFERRAL-002', 'P4M-7EC35FEE', NULL,
    'Patient Downloads Clinical Summary PDF', NULL, 'happy_path', 'Patient completed assessments and viewing results page.',
    '1. Complete assessments and view results\n2. Click Download Clinical Summary button\n3. Open downloaded PDF\n4. Verify all required content is present\n5. Verify PDF formatting is correct', 'PDF downloads successfully. Clinical Summary contains: patient demographics, TC score and risk category, NCCN eligibility, assessment date, and referring provider information.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:41'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:41'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-002-TC04', 'P4M-REFERRAL-002', 'P4M-7EC35FEE', NULL,
    'Provider Sees Same Clinical Summary as Patient', NULL, 'validation', 'Patient completed assessments. Provider logged in with GC or GA role.',
    '1. Patient completes assessments and downloads Clinical Summary\n2. Log in as provider (GC or GA role)\n3. Navigate to Referral Patients tab\n4. Select completed patient record\n5. View/download Clinical Summary\n6. Compare provider version to patient version', 'Provider sees same Clinical Summary document in referral dashboard that patient downloaded. Content matches exactly between patient view and provider view.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-002-TC05', 'P4M-REFERRAL-002', 'P4M-7EC35FEE', NULL,
    'Accepted Referral Routes to Returning Patient Then Education and e-Consent', NULL, 'happy_path', 'Patient completed referral assessments. Provider accepted referral and scheduled appointment.',
    '1. Provider accepts referral and schedules appointment\n2. Patient receives appointment notification\n3. Patient clicks link to continue in portal\n4. Verify Returning Patient experience is presented\n5. Complete Returning Patient flow\n6. Verify Education module is presented\n7. Complete Education module\n8. Verify e-Consent module is presented', 'After provider accepts referral and schedules appointment, patient receives notification. When patient returns, they enter Returning Patient flow, then are routed to Education module followed by e-Consent module.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:31:56'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:31:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-002-TC06', 'P4M-REFERRAL-002', 'P4M-7EC35FEE', NULL,
    'Assessment Audit Data Captured for Referral Flow', NULL, 'validation', 'Patient completing referral assessment flow.',
    '1. Patient completes TC assessment\n2. Patient completes NCCN assessment\n3. Navigate to audit log\n4. Search for patient''s assessment records\n5. Verify all inputs are captured\n6. Verify assessment version is recorded\n7. Verify calculated outputs are logged', 'Audit log contains: all assessment inputs (responses), assessment version numbers, calculated outputs (TC score, NCCN eligibility), timestamps for each step, and patient identifier. Data is immutable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-13 13:32:08'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:32:08'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC01', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'Dashboard Displays Two Tabs for Scheduled and Referral Patients', NULL, 'happy_path', 'User logged in with GC or GA role. Both scheduled and referral patients exist in system.',
    '1. Log in as GC or GA user\n2. Navigate to patient dashboard\n3. Observe tab structure\n4. Click Scheduled Patients tab\n5. Verify only scheduled patients shown\n6. Click Referral Patients tab\n7. Verify only referral patients shown', 'Dashboard displays two distinct tabs: "Scheduled Patients" and "Referral Patients". Tabs are clearly labeled and clickable. Each tab shows only its respective patient population.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:32:16'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:32:16'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC02', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'Red Badge Appears When Referral Patient Completes Assessment', NULL, 'happy_path', 'User logged in with GC or GA role. Referral patient exists with pending assessment.',
    '1. Log in as GC or GA user\n2. Navigate to dashboard (any tab)\n3. Have referral patient complete their assessment\n4. Observe Referral Patients tab\n5. Verify red badge appears\n6. Verify badge count increments', 'Red badge appears on Referral Patients tab indicating new completion. Badge shows count of unviewed completions. Badge is visible from any tab.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:32:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:32:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC03', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'User Opts In to Email Alerts for Referral Completions', NULL, 'happy_path', 'User logged in with GC or GA role.',
    '1. Log in as GC or GA user\n2. Navigate to user settings/preferences\n3. Enable email alerts for referral completions\n4. Save settings\n5. Have referral patient complete assessment\n6. Check user''s email inbox\n7. Verify alert email received with patient details', 'User can access notification settings. Email alert toggle is available per user. When enabled, user receives email when referral patient completes assessment. Email contains patient identifier and completion timestamp.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:32:33'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:32:33'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC04', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'Filter Referral Patients by TC or NCCN Status', NULL, 'happy_path', 'User logged in with GC or GA role. Referral patients exist with various TC scores and NCCN statuses.',
    '1. Navigate to Referral Patients tab\n2. Locate filter controls\n3. Apply filter for Elevated TC\n4. Verify only patients with TC >20% shown\n5. Apply filter for NCCN Eligible\n6. Verify only NCCN eligible patients shown\n7. Clear filters\n8. Verify all referral patients shown', 'Filter options available for: Elevated TC (>20%), NCCN Eligible, All. When filter applied, list shows only matching patients. Filter persists during session.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:32:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:32:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC05', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'Sort Referral List by Risk Level for Triage', NULL, 'happy_path', 'User logged in with GC or GA role. Multiple referral patients with varying risk levels.',
    '1. Navigate to Referral Patients tab\n2. Locate sort controls\n3. Sort by highest risk first\n4. Verify patients with elevated TC/NCCN eligible appear at top\n5. Sort by lowest risk first\n6. Verify order reverses', 'Sort options available for risk level. When sorted by highest risk, patients with elevated TC and/or NCCN eligibility appear first. Sort order persists during session.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:32:56'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:32:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC06', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'Badge Resets When User Views Patient Record', NULL, 'happy_path', 'User logged in with GC or GA role. Red badge showing on Referral tab with count of 2+.',
    '1. Note current badge count on Referral tab\n2. Click into a newly completed patient record\n3. Return to Referral Patients list\n4. Verify badge count decremented by 1\n5. View remaining new patient records\n6. Verify badge disappears when all viewed', 'After viewing patient record, badge count decrements by one. When all new completions are viewed, badge disappears entirely.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:33:07'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:33:07'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-003-TC07', 'P4M-REFERRAL-003', 'P4M-7EC35FEE', NULL,
    'Only GC and GA Roles Can See Referral Tab', NULL, 'validation', 'Test users with different roles: GC, GA, Provider (non-GC), Admin.',
    '1. Log in as Genetic Counselor\n2. Verify Referral Patients tab is visible\n3. Log out, log in as Genetic Assistant\n4. Verify Referral Patients tab is visible\n5. Log out, log in as Provider (non-GC role)\n6. Verify Referral Patients tab is NOT visible\n7. Log out, log in as Admin\n8. Verify Referral Patients tab visibility per admin role config', 'Users with Genetic Counselor or Genetic Assistant roles see both tabs (Scheduled and Referral). Users without these roles see only Scheduled Patients tab; Referral tab is not visible.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:33:23'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:33:23'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-004-TC01', 'P4M-REFERRAL-004', 'P4M-7EC35FEE', NULL,
    'TC Score Writes to Epic Patient Record', NULL, 'happy_path', 'Epic integration configured and active. Patient exists in both P4M and Epic. Patient completed referral assessment.',
    '1. Patient completes referral assessment with TC score calculated\n2. Provider accepts referral\n3. System triggers Epic write-back\n4. Log into Epic EHR\n5. Navigate to patient record\n6. Verify TC score and risk category are present', 'TC score and risk category (e.g., "High Risk - 25%") are written to designated field in Epic patient record. Data is visible in Epic EHR.', 'Could Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:33:35'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:33:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-004-TC02', 'P4M-REFERRAL-004', 'P4M-7EC35FEE', NULL,
    'NCCN Eligibility Status Writes to Epic', NULL, 'happy_path', 'Epic integration configured and active. Patient completed NCCN assessment.',
    '1. Patient completes referral assessment including NCCN\n2. Provider accepts referral\n3. System triggers Epic write-back\n4. Log into Epic EHR\n5. Navigate to patient record\n6. Verify NCCN eligibility status is present', 'NCCN eligibility status (Eligible/Not Eligible) and criteria met are written to designated field in Epic patient record. Data is visible in Epic EHR.', 'Could Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:33:50'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:33:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-004-TC03', 'P4M-REFERRAL-004', 'P4M-7EC35FEE', NULL,
    'Referral Decision and Reason Write to Epic', NULL, 'happy_path', 'Epic integration configured. Provider has reviewed referral patient and made decision.',
    '1. Provider reviews completed referral assessment\n2. Provider selects Accept or Decline with reason\n3. System triggers Epic write-back\n4. Log into Epic EHR\n5. Navigate to patient record\n6. Verify referral decision and reason are present', 'Referral decision (Accepted or Declined), reason for decision, and decision date are written to Epic. Data is visible in Epic EHR clinical notes or designated field.', 'Could Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-13 13:34:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:34:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-REFERRAL-004-TC04', 'P4M-REFERRAL-004', 'P4M-7EC35FEE', NULL,
    'Epic Write-Back Creates Part 11 Compliant Audit Entry', NULL, 'validation', 'Epic integration configured. Write-back triggered.',
    '1. Trigger Epic write-back for patient\n2. Navigate to P4M audit log\n3. Search for Epic write-back events for patient\n4. Verify data payload is logged\n5. Verify destination system identifier logged\n6. Verify success/failure confirmation logged\n7. Verify timestamp present', 'Audit log contains: data sent (TC, NCCN, decision), destination (Epic system ID), timestamp, confirmation of successful write, and source system identifier. If write fails, error is logged with retry status.', 'Could Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-13 13:34:13'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-13 13:34:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC15', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Audit Entry on Flagged Patient Record View', NULL, 'validation', NULL,
    '1. Log in as GA user\n2. Navigate to program dashboard\n3. Click on a patient with the Hematologic/BMT flag\n4. View the clinical summary\n5. Query the audit log for this action', 'Audit log contains entry with: user ID, timestamp, patient ID, action type (view_flagged_patient)', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-14 13:52:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 13:52:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC16', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Audit Entry for Hematologic/BMT Data Changes', NULL, 'validation', NULL,
    '1. Navigate to patient clinical summary\n2. Modify the hematologic malignancy or BMT field\n3. Save changes\n4. Query audit log', 'Audit log contains: user ID, timestamp, patient ID, field changed, before value, after value', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-14 13:52:32'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 13:52:32'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC17', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'Audit Entry for Flag Status Changes', NULL, 'validation', NULL,
    '1. Update patient data that triggers flag status change (e.g., from unflagged to flagged)\n2. Query audit log', 'Audit log contains: timestamp, flag status change (from/to), triggering data change reference', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-14 13:52:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 13:52:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC18', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'HIPAA Minimum Necessary - Flag Display', NULL, 'validation', NULL,
    '1. Navigate to program dashboard\n2. View patient row with Hematologic/BMT flag\n3. Verify flag icon/indicator is visible\n4. Verify NO specific diagnosis type is shown on dashboard', 'Dashboard shows only generic flag indicator; specific malignancy type or BMT details are NOT visible until clinical summary is opened', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    TRUE, NULL,
    COALESCE('2026-01-14 13:52:52'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 13:52:52'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'P4M-DASH-001-TC19', 'P4M-DASH-001', 'P4M-7EC35FEE', NULL,
    'HITRUST Security Control Test', NULL, 'validation', NULL,
    '1. Verify security controls\n2. Document evidence', 'Security controls implemented and documented', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 14:10:15'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 14:10:15'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-ADMIN-001-TC01', 'ONB-ADMIN-001', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'List Form Questions Returns Complete Structure', NULL, 'happy_path', 'Form definition JSON file exists with multiple steps and question types',
    '1. Call list_form_questions() with no parameters\n2. Verify output shows all steps from form definition\n3. Verify each question displays: question_id, type, label, required\n4. Call list_form_questions(step_id="clinic_info") to filter by step\n5. Verify only questions from specified step are returned\n6. Verify conditional fields show their show_when conditions\n7. Verify select/radio fields show their options_ref', 'Tool returns formatted list of all questions organized by step, including question_id, type, label, required status, show_when conditions, and options_ref where applicable', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:55:29'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:55:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-ADMIN-002-TC01', 'ONB-ADMIN-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Add Form Question Creates New Field', NULL, 'happy_path', 'Form definition JSON file exists; user has MCP access',
    '1. Call add_form_question with step_id="clinic_info", question_id="test_field", question_type="text", label="Test Field"\n2. Verify confirmation message returned with question location\n3. Call list_form_questions(step_id="clinic_info")\n4. Verify new question appears at end of step\n5. Call add_form_question with insert_after parameter to place question after specific field\n6. Verify question inserted at correct position\n7. Verify form-definition.json file was updated', 'New question is added to the specified step, form-definition.json is updated, confirmation message shows new question location, and list_form_questions confirms the addition', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:55:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:55:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-ADMIN-002-TC02', 'ONB-ADMIN-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Add Form Question Validates Input', NULL, 'negative', 'Form definition JSON file exists',
    '1. Call add_form_question with missing required parameter (no label)\n2. Verify error message indicates missing required field\n3. Call add_form_question with invalid question_type\n4. Verify error message indicates invalid type\n5. Call add_form_question with duplicate question_id\n6. Verify error message indicates ID already exists\n7. Verify form-definition.json was NOT modified', 'Tool rejects invalid question definition with clear error message indicating what validation failed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:55:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:55:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-ADMIN-003-TC01', 'ONB-ADMIN-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Update Form Question Modifies Properties', NULL, 'happy_path', 'Form definition JSON file exists with questions to update',
    '1. Call update_form_question to change label on existing question\n2. Verify confirmation shows old label → new label\n3. Call update_form_question to change multiple fields (label, help_text, required)\n4. Verify all changed fields reflected in confirmation\n5. Call update_form_question with only one field\n6. Verify other fields remain unchanged (sparse update)\n7. Call list_form_questions to confirm changes persisted\n8. Verify form-definition.json was updated', 'Question properties are updated correctly, form-definition.json reflects changes, confirmation shows old and new values, and list_form_questions confirms the updates', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:56:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:56:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-ADMIN-004-TC01', 'ONB-ADMIN-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Remove Form Question Deletes Field', NULL, 'happy_path', 'Form definition JSON file exists with removable question (non-title type)',
    '1. Call list_form_questions to identify existing question\n2. Call remove_form_question with question_id and reason\n3. Verify confirmation shows removed question summary\n4. Call list_form_questions to verify question no longer appears\n5. Verify form-definition.json was updated\n6. Attempt to remove a title-type question\n7. Verify error message indicates title questions cannot be removed', 'Question is removed from form, confirmation shows removed question details, list_form_questions confirms removal, and form-definition.json no longer contains the question', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:56:22'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:56:22'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-ADMIN-005-TC01', 'ONB-ADMIN-005', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Reorder Form Questions Changes Sequence', NULL, 'happy_path', 'Form definition JSON file exists with step containing multiple questions',
    '1. Call list_form_questions(step_id="clinic_info") to see current order\n2. Call reorder_form_questions with question_id to move to "first"\n3. Verify confirmation shows new order\n4. Call list_form_questions to verify question is now first\n5. Call reorder_form_questions with move_to="after" and target_question_id\n6. Verify question moved to correct position\n7. Verify form-definition.json reflects new order', 'Questions are reordered within the step, confirmation shows new order, list_form_questions displays questions in new sequence, and form-definition.json reflects the new order', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:56:36'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:56:36'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-EXPORT-002-TC01', 'ONB-EXPORT-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Valid Form Data Exports Without Errors', NULL, 'happy_path', 'Onboarding form completed with all required fields; schema.json exists at src/data/schema.json',
    '1. Complete onboarding form with valid data for all required fields\n2. Click "Download JSON" button\n3. Verify no validation errors displayed\n4. Verify JSON file downloads successfully\n5. Open downloaded JSON and manually validate against schema.json\n6. Verify JSON structure matches schema requirements', 'Form with all required fields completed exports successfully without validation errors; exported JSON validates against schema.json', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:56:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:56:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-EXPORT-002-TC02', 'ONB-EXPORT-002', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Invalid Patterns Blocked on Export', NULL, 'validation', 'Onboarding form partially completed; schema.json with pattern validation rules exists',
    '1. Enter invalid email format (e.g., "not-an-email")\n2. Enter invalid NPI format (e.g., "123" instead of 10 digits)\n3. Enter invalid ZIP format (e.g., "ABCDE")\n4. Attempt to export by clicking "Download JSON"\n5. Verify validation error messages display for each invalid field\n6. Verify export is blocked\n7. Correct the invalid fields with valid data\n8. Verify export succeeds after corrections', 'Validation errors are displayed to user indicating which fields failed pattern validation; export is blocked until errors are corrected', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:57:05'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:57:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-FORM-006-TC01', 'ONB-FORM-006', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Default Plus Alternates Component Functions Correctly', NULL, 'happy_path', 'Form loaded with select_with_alternates field type (e.g., specimen type or test product selection)',
    '1. Navigate to form step with select_with_alternates field\n2. Select a default value from the dropdown\n3. Verify checkbox "Offer additional options" appears below\n4. Check the "Offer additional options" checkbox\n5. Verify remaining options appear as multi-select checkboxes\n6. Verify selected default is NOT in the alternates list\n7. Select one or more alternate options\n8. Export JSON and verify output contains: default value, alternates_enabled: true, alternates array\n9. Uncheck "Offer additional options"\n10. Verify alternates are cleared and hidden', 'Default selection works correctly, alternates checkbox toggles alternate options visibility, selecting alternates updates output correctly, and JSON export includes default, alternates_enabled, and alternates array', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:57:25'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:57:25'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-STEP-003-TC01', 'ONB-STEP-003', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Satellite Locations Repeatable Section Works', NULL, 'happy_path', 'Onboarding form loaded, user on Step 3 - Satellite Locations',
    '1. Navigate to Step 3 - Satellite Locations\n2. Verify step shows "Add Satellite Location" button with no locations initially\n3. Click "Add Satellite Location" button\n4. Verify Location 1 section appears with fields: name, Epic ID, address, phone, hours\n5. Enter required address field\n6. Click "Add Satellite Location" again\n7. Verify Location 2 appears numbered sequentially\n8. Click Remove button on Location 1\n9. Verify Location 1 is removed and remaining location is renumbered\n10. Clear all locations and click Next\n11. Verify user can proceed to Step 4 without any satellite locations', 'User can add multiple satellite locations, each location captures required fields, locations are numbered sequentially, remove function works, and step can be skipped if no satellites exist', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:57:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:57:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'ONB-UI-004-TC01', 'ONB-UI-004', '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Form Displays Correctly on Mobile Devices', NULL, 'happy_path', 'Mobile device or browser dev tools with mobile emulation; access to onboarding form URL',
    '1. Open onboarding form on iOS Safari (iPhone)\n2. Verify form fields stack vertically\n3. Verify text is readable without zooming\n4. Verify no horizontal scrolling is required\n5. Verify all buttons are accessible and tappable\n6. Navigate through all steps to verify responsiveness\n7. Verify progress indicator adapts to mobile width\n8. Repeat steps 1-7 on Android Chrome\n9. Complete form submission on mobile to verify full workflow', 'Form displays correctly on mobile device, all content readable without zooming, no horizontal scroll needed, buttons tappable, and progress indicator visible', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-14 16:58:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-14 16:58:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-001-TC01', 'NCCN-RULE-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Prostate Cancer, Gleason 8 (aggressive)... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-PROS007-POS-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Gleason Score: Gleason 8 (aggressive)\n4. Navigate to Results/Recommendations screen', 'Rule triggers Cross-check: NCCN-PROS-009 if FDR also aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:36:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-001-TC02', 'NCCN-RULE-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate Cancer, Gleason 8 (aggressive)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-PROS007-NEG-02-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason 8 (aggressive)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:37:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-001-TC03', 'NCCN-RULE-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Prostate Cancer, Gleason 5 (non-aggressive)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-PROS007-NEG-03-P4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason 5 (non-aggressive)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - not aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:39:09'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-001-TC04', 'NCCN-RULE-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Prostate Cancer, Gleason 8 (aggressive)... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-PROS007-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason 8 (aggressive)\n5. Navigate to Results/Recommendations screen', 'Rule triggers - SDR path (NEW)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:51:12'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-001-TC05', 'NCCN-RULE-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Prostate Cancer, Gleason 5 (non-aggressive)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-PROS007-NEG-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason 5 (non-aggressive)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - not aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:50:03'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-001-TC06', 'NCCN-RULE-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Prostate Cancer (no Gleason specified)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-PROS007-NEG-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: no Gleason specified\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - aggressive not specified', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:50:08'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-002-TC01', 'NCCN-RULE-002', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: TDR: Prostate, Gleason 8 AND FDR: Breast Cancer... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-BRCA008-POS-01-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason \n85. Family History > Add Relative: Mother (First Degree)\n6. Family History > Cancer Type: Breast Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule triggers - TDR prostate + FDR breast Cross-check: NCCN-BRCA-013 if breast ≤50', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:51:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-002-TC02', 'NCCN-RULE-002', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Prostate, Gleason 8 AND FDR: Breast Cancer... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-BRCA008-NEG-02-P4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason \n85. Family History > Add Relative: Mother (First Degree)\n6. Family History > Cancer Type: Breast Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - SDR prostate REMOVED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:51:34'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-002-TC03', 'NCCN-RULE-002', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate, Gleason 5 AND FDR: Breast Cancer... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-BRCA008-NEG-03-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason \n55. Family History > Add Relative: Mother (First Degree)\n6. Family History > Cancer Type: Breast Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - not aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:51:52'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-002-TC04', 'NCCN-RULE-002', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: TDR: Prostate, Gleason 9 AND SDR: Breast Cancer... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-BRCA008-POS-01-Px4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason \n95. Family History > Add Relative: Grandmother (Second Degree)\n6. Family History > Cancer Type: Breast Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule triggers - TDR prostate + SDR breast', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:51:57'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-002-TC05', 'NCCN-RULE-002', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Prostate, Gleason 8 AND SDR: Breast Cancer... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-BRCA008-NEG-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason \n85. Family History > Add Relative: Grandmother (Second Degree)\n6. Family History > Cancer Type: Breast Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - FDR prostate not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:52:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-002-TC06', 'NCCN-RULE-002', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate, Gleason 8 AND TDR: Breast Cancer... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-BRCA008-NEG-03-Px4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Gleason Score: Gleason \n85. Family History > Add Relative: Great-Uncle (Third Degree)\n6. Family History > Cancer Type: Breast Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR breast not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:52:17'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-003-TC01', 'NCCN-RULE-003', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Prostate (any) AND FDR: Prostate, Gleason 8... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-PROS009-POS-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Gleason Score: Gleason \n87. Navigate to Results/Recommendations screen', 'Rule triggers - PHX + FDR aggressive Cross-check: NCCN-PROS-007', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:52:29'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-003-TC02', 'NCCN-RULE-003', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Prostate (any) AND TDR: Prostate (non-aggress... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-PROS009-NEG-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Note: non-aggressive\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not aggressive enough', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:52:36'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-003-TC03', 'NCCN-RULE-003', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate only... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-PROS009-NEG-03-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Note: Single condition test\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs PHX/FDR/SDR first', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:52:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-003-TC04', 'NCCN-RULE-003', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Prostate (any) AND FDR: Prostate, Gleason 9... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-PROS009-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Mother (First Degree)\n5. Family History > Cancer Type: Prostate Cancer\n6. Family History > Age at Diagnosis: Any\n7. Family History > Gleason Score: Gleason \n98. Navigate to Results/Recommendations screen', 'Rule triggers - SDR + FDR aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:53:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-003-TC05', 'NCCN-RULE-003', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Prostate (any) AND TDR: Prostate, Gleason 8... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-PROS009-NEG-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Prostate Cancer\n6. Family History > Age at Diagnosis: Any\n7. Family History > Gleason Score: Gleason \n88. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR aggressive not sufficient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:53:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-003-TC06', 'NCCN-RULE-003', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Prostate only (no additional aggressive)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-PROS009-NEG-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (no additional aggressive)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs additional aggressive Cross-check: NCCN-PROS-007 if PHX aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:53:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-004-TC01', 'NCCN-RULE-004', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Triple Negative Breast Canc... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA010-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Triple Negative Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: None - rule removed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:53:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-004-TC02', 'NCCN-RULE-004', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Triple Negative Breast Canc... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA010-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Triple Negative Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: None - rule removed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:53:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-004-TC03', 'NCCN-RULE-004', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: FDR: Prostate AND TDR: Triple Negative Breast Canc... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA010-DEP-03-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Triple Negative Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: None - rule removed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:53:53'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-004-TC04', 'NCCN-RULE-004', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Triple Negative Breast Canc... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA010-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Triple Negative Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: None - rule removed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:54:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-004-TC05', 'NCCN-RULE-004', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: FDR: Prostate AND FDR: Triple Negative Breast Canc... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA010-DEP-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Triple Negative Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: None - rule removed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:54:25'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-004-TC06', 'NCCN-RULE-004', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND PHX: Triple Negative Breast (sam... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA010-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Triple Negative Breast Cancer\n4. Patient History > Age at Diagnosis: Any\n5. Note: same person\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: None - rule removed', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:54:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-005-TC01', 'NCCN-RULE-005', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Prostate AND FDR: Ovarian Cancer... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-OVAR011-POS-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Ovarian Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule triggers - PHX prostate + FDR ovarian Cross-check: NCCN-OVAR-049 deprecated', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:55:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-005-TC02', 'NCCN-RULE-005', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate AND FDR: Ovarian Cancer... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-OVAR011-NEG-02-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Mother (First Degree)\n5. Family History > Cancer Type: Ovarian Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR prostate not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:55:16'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-005-TC03', 'NCCN-RULE-005', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Prostate only (no ovarian)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-OVAR011-NEG-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (no ovarian)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs ovarian Cross-check: NCCN-PROS-007 if aggressive', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:55:43'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-005-TC04', 'NCCN-RULE-005', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Prostate AND SDR: Ovarian Cancer... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-OVAR011-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Ovarian Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule triggers - SDR prostate path (CHANGE)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:55:58'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-005-TC05', 'NCCN-RULE-005', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Prostate AND TDR: Ovarian Cancer... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-OVAR011-NEG-02-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Ovarian Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR ovarian not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:56:28'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-005-TC06', 'NCCN-RULE-005', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Prostate AND TDR: Ovarian (TDR not in rule)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-OVAR011-NEG-03-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Ovarian Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: TDR not in rule\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR ovarian not valid', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:56:44'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-006-TC01', 'NCCN-RULE-006', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Prostate AND FDR: Male Breast Cancer... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-BRCA012-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Male Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule triggers - FDR prostate + FDR male breast Cross-check: NCCN-BRCA-048 deprecated', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:57:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-006-TC02', 'NCCN-RULE-006', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate AND FDR: Male Breast... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-BRCA012-NEG-02-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Mother (First Degree)\n5. Family History > Cancer Type: Male Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR prostate not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:57:35'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-006-TC03', 'NCCN-RULE-006', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Prostate only (no male breast)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-BRCA012-NEG-03-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Note: Single condition test - (no male breast)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs male breast', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:58:14'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-006-TC04', 'NCCN-RULE-006', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Prostate AND SDR: Male Breast Cancer... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-BRCA012-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Male Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule triggers - SDR prostate path (CHANGE)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:58:32'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-006-TC05', 'NCCN-RULE-006', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Prostate AND TDR: Male Breast... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-BRCA012-NEG-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Male Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR male breast not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:59:15'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-006-TC06', 'NCCN-RULE-006', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Prostate AND TDR: Male Breast (TDR not valid)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-BRCA012-NEG-03-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Male Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: TDR not valid\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 15:59:36'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-007-TC01', 'NCCN-RULE-007', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Prostate AND FDR: Breast Cancer, age 45... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-BRCA013-POS-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n456. Navigate to Results/Recommendations screen', 'Rule triggers - PHX prostate + FDR breast ≤50 Cross-check: NCCN-BRCA-045 deprecated', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:00:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-007-TC02', 'NCCN-RULE-007', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Prostate AND FDR: Breast Cancer, age 55... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-BRCA013-NEG-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n556. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - breast >50y', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:00:46'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-007-TC03', 'NCCN-RULE-007', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Prostate AND FDR: Breast, age 48... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-BRCA013-NEG-03-P4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Mother (First Degree)\n5. Family History > Cancer Type: Breast Cancer\n6. Family History > Age at Diagnosis: \n487. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR prostate not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:01:41'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-007-TC04', 'NCCN-RULE-007', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Prostate AND SDR: Breast Cancer, age 50... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-BRCA013-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Breast Cancer\n6. Family History > Age at Diagnosis: \n507. Navigate to Results/Recommendations screen', 'Rule triggers - SDR prostate path (CHANGE)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:02:04'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-007-TC05', 'NCCN-RULE-007', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Prostate AND SDR: Breast Cancer, age 52... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-BRCA013-NEG-02-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Breast Cancer\n6. Family History > Age at Diagnosis: \n527. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - breast >50y', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:03:05'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-007-TC06', 'NCCN-RULE-007', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Prostate AND TDR: Breast, age 45... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-BRCA013-NEG-03-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Prostate Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Breast Cancer\n6. Family History > Age at Diagnosis: \n457. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR breast not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:03:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-008-TC01', 'NCCN-RULE-008', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Known pathogenic genomic mutation... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-MULT034-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Known Pathogenic Genomic Mutation\n3. Family History > Age at Diagnosis: Any\n4. Navigate to Results/Recommendations screen', 'Rule triggers - FDR mutation Cross-check: NCCN-PROS-043 deprecated', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 16:04:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-008-TC02', 'NCCN-RULE-008', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Known pathogenic genomic mutation only... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-MULT034-NEG-02-P4M',
    '1. Patient History > Cancer Type: Known Pathogenic Genomic Mutation\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - PHX REMOVED from rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-008-TC03', 'NCCN-RULE-008', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: No genomic mutation in family history... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-MULT034-NEG-03-P4M',
    '1. Family History > Genomic Testing: No known pathogenic mutation\n2. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - no mutation', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-008-TC04', 'NCCN-RULE-008', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Known pathogenic genomic mutation... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-MULT034-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Known Pathogenic Genomic Mutation\n3. Family History > Age at Diagnosis: Any\n4. Navigate to Results/Recommendations screen', 'Rule triggers - SDR mutation path', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-008-TC05', 'NCCN-RULE-008', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: BRCA1 mutation (PHX removed)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-MULT034-NEG-02-Px4M',
    '1. Patient History > Cancer Type: BRCA1 Mutation\n2. Patient History > Age at Diagnosis: Any\n3. Note: PHX removed\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - PHX REMOVED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-008-TC06', 'NCCN-RULE-008', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Possible mutation (not confirmed pathogenic)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-MULT034-NEG-03-Px4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Possible Mutation (not confirmed pathogenic)\n3. Family History > Age at Diagnosis: Any\n4. Note: not confirmed pathogenic\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - must be confirmed pathogenic', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-009-TC01', 'NCCN-RULE-009', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Colon Cancer AND PHX: Endometrial Cancer (sam... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-LYNX036-POS-01-P4M',
    '1. Patient History > Cancer Type: Colon Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Endometrial Cancer\n4. Patient History > Age at Diagnosis: Any\n5. Note: same person, 2 Lynch\n6. Navigate to Results/Recommendations screen', 'Rule triggers - 2 Lynch same person', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-009-TC02', 'NCCN-RULE-009', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Colon Cancer only (1 Lynch)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-LYNX036-NEG-02-P4M',
    '1. Patient History > Cancer Type: Colon Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (1 Lynch)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs 2+ Lynch', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-009-TC03', 'NCCN-RULE-009', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Colon AND FDR: Endometrial (not PHX)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-LYNX036-NEG-03-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Colon Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Endometrial Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: not PHX\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs PHX Cross-check: NCCN-LYNX-037', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-009-TC04', 'NCCN-RULE-009', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Colon Cancer AND PHX: Second Colon Cancer (2 ... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-LYNX036-POS-01-Px4M',
    '1. Patient History > Cancer Type: Colon Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Second Colon Cancer\n4. Patient History > Age at Diagnosis: Any\n5. Note: 2 same-type Lynch\n6. Navigate to Results/Recommendations screen', 'Rule triggers - 2 colon same person (CHANGE)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-009-TC05', 'NCCN-RULE-009', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Sebaceous Adenoma only (1 Lynch-type)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-LYNX036-NEG-02-Px4M',
    '1. Patient History > Cancer Type: Sebaceous Adenoma\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (1 Lynch-type)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs 2+', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-009-TC06', 'NCCN-RULE-009', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Colon AND SDR: Endometrial (different people)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-LYNX036-NEG-03-Px4M',
    '1. Patient History > Cancer Type: Colon Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Endometrial Cancer\n5. Family History > Age at Diagnosis: Any\n6. Note: different people\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - must be same person (PHX)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-010-TC01', 'NCCN-RULE-010', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Colon AND same FDR: Endometrial (same relativ... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-LYNX037-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Colon Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Mother (First Degree)\n5. Family History > Cancer Type: Endometrial Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: same relative, 2 Lynch\n8. Navigate to Results/Recommendations screen', 'Rule triggers - FDR with 2 Lynch', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-010-TC02', 'NCCN-RULE-010', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Colon only (1 Lynch)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-LYNX037-NEG-02-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Colon Cancer\n3. Family History > Age at Diagnosis: Any\n4. Note: Single condition test - (1 Lynch)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs 2+', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-010-TC03', 'NCCN-RULE-010', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Colon AND different SDR: Endometrial (differe... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-LYNX037-NEG-03-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Colon Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandmother (Second Degree)\n5. Family History > Cancer Type: Endometrial Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: different people\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - must be same person', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-010-TC04', 'NCCN-RULE-010', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: SDR: Colon AND same SDR: Second Colon (same relati... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-LYNX037-POS-01-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Colon Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Grandmother (Second Degree)\n5. Family History > Cancer Type: Second Colon Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: same relative, 2 colon\n8. Navigate to Results/Recommendations screen', 'Rule triggers - SDR with 2 same-type Lynch (CHANGE)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-010-TC05', 'NCCN-RULE-010', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Endometrial only (1 Lynch)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-LYNX037-NEG-02-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Endometrial Cancer\n3. Family History > Age at Diagnosis: Any\n4. Note: Single condition test - (1 Lynch)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs 2+', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-010-TC06', 'NCCN-RULE-010', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Colon AND TDR: Endometrial... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-LYNX037-NEG-03-Px4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Colon Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Uncle (Third Degree)\n5. Family History > Cancer Type: Endometrial Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-011-TC01', 'NCCN-RULE-011', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate, age 55... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS040-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n556. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-011-TC02', 'NCCN-RULE-011', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate, age 60... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS040-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n606. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-011-TC03', 'NCCN-RULE-011', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate, age 45... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS040-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n456. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-011-TC04', 'NCCN-RULE-011', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Prostate, age 58... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS040-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n586. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-011-TC05', 'NCCN-RULE-011', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate (age 70) AND FDR: Prostate, age 52... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS040-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n703. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n526. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-011-TC06', 'NCCN-RULE-011', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate, age 59... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS040-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n596. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-012-TC01', 'NCCN-RULE-012', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Breast AND SDR: Prostate... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA041-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Add Relative: Grandmother (Second Degree)\n7. Family History > Cancer Type: Prostate Cancer\n8. Family History > Age at Diagnosis: Any\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-012-TC02', 'NCCN-RULE-012', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Breast AND TDR: Breast... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA041-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Add Relative: Great-Aunt (Third Degree)\n7. Family History > Cancer Type: Breast Cancer\n8. Family History > Age at Diagnosis: Any\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-012-TC03', 'NCCN-RULE-012', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Breast AND SDR: Prostate... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA041-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Add Relative: Grandfather (Second Degree)\n7. Family History > Cancer Type: Prostate Cancer\n8. Family History > Age at Diagnosis: Any\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-012-TC04', 'NCCN-RULE-012', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate AND SDR: Breast... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA041-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Add Relative: Grandmother (Second Degree)\n7. Family History > Cancer Type: Breast Cancer\n8. Family History > Age at Diagnosis: Any\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-012-TC05', 'NCCN-RULE-012', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Breast AND TDR: Prostate... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA041-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Add Relative: Great-Uncle (Third Degree)\n7. Family History > Cancer Type: Prostate Cancer\n8. Family History > Age at Diagnosis: Any\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-012-TC06', 'NCCN-RULE-012', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Breast AND FDR: Prostate... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA041-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Add Relative: Father (First Degree)\n7. Family History > Cancer Type: Prostate Cancer\n8. Family History > Age at Diagnosis: Any\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-013-TC01', 'NCCN-RULE-013', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate Cancer AND Ashkenazi Jewish = Yes... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS042-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Demographics > Ethnicity: Ashkenazi Jewish = Yes\n4. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-013-TC02', 'NCCN-RULE-013', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 45 AND Ashkenazi Jewish = Yes... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS042-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n453. Demographics > Ethnicity: Ashkenazi Jewish = Yes\n4. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-013-TC03', 'NCCN-RULE-013', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, Gleason 6 AND Ashkenazi Jewish = Ye... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS042-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Gleason Score: Gleason \n64. Demographics > Ethnicity: Ashkenazi Jewish = Yes\n5. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-013-TC04', 'NCCN-RULE-013', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 70 AND Ashkenazi Jewish = Yes... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS042-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n703. Demographics > Ethnicity: Ashkenazi Jewish = Yes\n4. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-013-TC05', 'NCCN-RULE-013', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, Gleason 8 AND Ashkenazi Jewish = Ye... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS042-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Gleason Score: Gleason \n84. Demographics > Ethnicity: Ashkenazi Jewish = Yes\n5. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-013-TC06', 'NCCN-RULE-013', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate (metastatic) AND Ashkenazi Jewish = ... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS042-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: metastatic\n4. Demographics > Ethnicity: Ashkenazi Jewish = Yes\n5. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-014-TC01', 'NCCN-RULE-014', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: BRCA1 mutation... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS043-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: BRCA1 Mutation\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-MULT-034 may trigger (FDR mutation)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-014-TC02', 'NCCN-RULE-014', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: BRCA2 mutation... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS043-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: BRCA2 mutation\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-MULT-034 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-014-TC03', 'NCCN-RULE-014', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Lynch mutation... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS043-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Lynch mutation\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-MULT-034 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-014-TC04', 'NCCN-RULE-014', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 50 AND FDR: ATM mutation... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS043-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n503. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: ATM Mutation\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-MULT-034 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-014-TC05', 'NCCN-RULE-014', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: PALB2 mutation... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS043-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: PALB2 mutation\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-MULT-034 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-014-TC06', 'NCCN-RULE-014', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, Gleason 9 AND FDR: CHEK2 mutation... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS043-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Gleason Score: Gleason \n94. Family History > Add Relative: Mother (First Degree)\n5. Family History > Cancer Type: CHEK2 mutation\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-MULT-034 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-015-TC01', 'NCCN-RULE-015', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Colon + Endometrial + Gastr... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS044-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Colon Cancer\n5. Family History > Cancer Type: Endometrial Cancer\n6. Family History > Cancer Type: Gastric Cancer\n7. Family History > Age at Diagnosis: Any\n8. Note: 3 Lynch\n9. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-015-TC02', 'NCCN-RULE-015', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: 3 Lynch cancers same person... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS044-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: 3 Lynch cancers same person\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-LYNX-037 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-015-TC03', 'NCCN-RULE-015', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Colon + Colon + Ovarian... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS044-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Colon Cancer\n5. Family History > Cancer Type: Colon Cancer\n6. Family History > Cancer Type: Ovarian Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-015-TC04', 'NCCN-RULE-015', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Endometrial + Gastric + Seb... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS044-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Endometrial Cancer\n5. Family History > Cancer Type: Gastric Cancer\n6. Family History > Cancer Type: Sebaceous Adenoma\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-015-TC05', 'NCCN-RULE-015', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Colon + Endometrial + Colon... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS044-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Colon Cancer\n5. Family History > Cancer Type: Endometrial Cancer\n6. Family History > Cancer Type: Colon Cancer\n7. Family History > Age at Diagnosis: Any\n8. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-LYNX-037 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-015-TC06', 'NCCN-RULE-015', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: 3 Lynch cancers... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS044-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: 3 Lynch cancers\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-016-TC01', 'NCCN-RULE-016', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Breast, age 48... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA045-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n486. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-013 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-016-TC02', 'NCCN-RULE-016', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Breast, age 45... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA045-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n456. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-013 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-016-TC03', 'NCCN-RULE-016', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Breast, age 50... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA045-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n506. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-013 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-016-TC04', 'NCCN-RULE-016', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Breast, age 42... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA045-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n426. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-013 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-016-TC05', 'NCCN-RULE-016', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Breast, age 38... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA045-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n386. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-013 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-016-TC06', 'NCCN-RULE-016', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Breast, age 49... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA045-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Breast Cancer\n5. Family History > Age at Diagnosis: \n496. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-013 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-017-TC01', 'NCCN-RULE-017', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Colorectal Cancer, age 48... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS046-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Colorectal Cancer\n5. Family History > Age at Diagnosis: \n486. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-017-TC02', 'NCCN-RULE-017', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Colorectal Cancer, age 45... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS046-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Colorectal Cancer\n5. Family History > Age at Diagnosis: \n456. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-017-TC03', 'NCCN-RULE-017', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Colorectal Cancer, age 50... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS046-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Colorectal Cancer\n5. Family History > Age at Diagnosis: \n506. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-017-TC04', 'NCCN-RULE-017', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Colon Cancer, age 40... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS046-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Colon Cancer\n5. Family History > Age at Diagnosis: \n406. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-017-TC05', 'NCCN-RULE-017', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Rectal Cancer, age 42... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS046-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Rectal Cancer\n5. Family History > Age at Diagnosis: \n426. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-017-TC06', 'NCCN-RULE-017', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: CRC, age 49... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS046-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Colorectal Cancer\n5. Family History > Age at Diagnosis: \n496. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-018-TC01', 'NCCN-RULE-018', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Endometrial Cancer, age 48... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS047-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Endometrial Cancer\n5. Family History > Age at Diagnosis: \n486. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-018-TC02', 'NCCN-RULE-018', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Uterine Cancer, age 45... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS047-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Uterine Cancer\n5. Family History > Age at Diagnosis: \n456. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-018-TC03', 'NCCN-RULE-018', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Endometrial, age 50... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS047-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Endometrial Cancer\n5. Family History > Age at Diagnosis: \n506. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-018-TC04', 'NCCN-RULE-018', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Uterine Cancer, age 38... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS047-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Uterine Cancer\n5. Family History > Age at Diagnosis: \n386. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-018-TC05', 'NCCN-RULE-018', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Endometrial, age 44... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS047-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Endometrial Cancer\n5. Family History > Age at Diagnosis: \n446. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-018-TC06', 'NCCN-RULE-018', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Uterine, age 49... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS047-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Uterine\n5. Family History > Age at Diagnosis: \n496. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-019-TC01', 'NCCN-RULE-019', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Male Breast Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA048-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Male Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-012 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-019-TC02', 'NCCN-RULE-019', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Male Breast Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA048-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Male Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-012 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-019-TC03', 'NCCN-RULE-019', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Male Breast Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-BRCA048-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Male Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-012 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-019-TC04', 'NCCN-RULE-019', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 55 AND FDR: Male Breast... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA048-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n553. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Male Breast Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-012 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-019-TC05', 'NCCN-RULE-019', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, Gleason 7 AND SDR: Male Breast... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA048-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Gleason Score: Gleason \n74. Family History > Add Relative: Grandmother (Second Degree)\n5. Family History > Cancer Type: Male Breast Cancer\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-012 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-019-TC06', 'NCCN-RULE-019', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Male Breast, age 60... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-BRCA048-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Male Breast Cancer\n5. Family History > Age at Diagnosis: \n606. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-BRCA-012 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-020-TC01', 'NCCN-RULE-020', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Ovarian Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-OVAR049-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Ovarian Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-OVAR-011 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-020-TC02', 'NCCN-RULE-020', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Ovarian Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-OVAR049-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Ovarian Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-OVAR-011 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-020-TC03', 'NCCN-RULE-020', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Ovarian Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-OVAR049-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Ovarian Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-OVAR-011 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-020-TC04', 'NCCN-RULE-020', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 62 AND FDR: Ovarian... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-OVAR049-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n623. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Ovarian Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-OVAR-011 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-020-TC05', 'NCCN-RULE-020', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Ovarian, age 55... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-OVAR049-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Ovarian Cancer\n5. Family History > Age at Diagnosis: \n556. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-OVAR-011 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-020-TC06', 'NCCN-RULE-020', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Fallopian Tube Cancer... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-OVAR049-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Fallopian Tube Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-OVAR-011 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-021-TC01', 'NCCN-RULE-021', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Pancreatic Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS050-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Pancreatic Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-021-TC02', 'NCCN-RULE-021', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Pancreatic Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS050-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Pancreatic Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-021-TC03', 'NCCN-RULE-021', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Pancreatic Cancer... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS050-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Pancreatic Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-021-TC04', 'NCCN-RULE-021', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 58 AND FDR: Pancreatic... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS050-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n583. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Pancreatic Cancer\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-021-TC05', 'NCCN-RULE-021', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Pancreatic, age 65... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS050-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Pancreatic Cancer\n5. Family History > Age at Diagnosis: \n656. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-021-TC06', 'NCCN-RULE-021', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Pancreatic, age 50... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS050-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Pancreatic Cancer\n5. Family History > Age at Diagnosis: \n506. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-022-TC01', 'NCCN-RULE-022', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate, Gleason 8... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS051-DEP-01-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Gleason Score: Gleason \n87. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-PROS-009 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-022-TC02', 'NCCN-RULE-022', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Prostate, Gleason 9... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS051-DEP-02-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Gleason Score: Gleason \n97. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-PROS-009 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-022-TC03', 'NCCN-RULE-022', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND TDR: Prostate (metastatic)... (P4M)', NULL, 'validation', 'Platform: P4M | Profile: TP-PROS051-DEP-03-P4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Note: metastatic\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-PROS-009 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-022-TC04', 'NCCN-RULE-022', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate, age 55 AND FDR: Prostate, Gleason 1... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS051-DEP-01-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: \n553. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Family History > Gleason Score: Gleason \n107. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-PROS-009 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-022-TC05', 'NCCN-RULE-022', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND SDR: Prostate (aggressive, age 5... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS051-DEP-02-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: \n506. Note: aggressive\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-PROS-009 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-022-TC06', 'NCCN-RULE-022', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'DEP: PHX: Prostate AND FDR: Prostate (lethal)... (Px4M)', NULL, 'validation', 'Platform: Px4M | Profile: TP-PROS051-DEP-03-Px4M',
    '1. Patient History > Cancer Type: Prostate Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Prostate Cancer\n5. Family History > Age at Diagnosis: Any\n6. Note: lethal\n7. Navigate to Results/Recommendations screen', 'Rule should NOT appear - DEPRECATED Cross-check: NCCN-PROS-009 may trigger', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-023-TC01', 'NCCN-RULE-023', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Renal/Kidney Cancer AND PHX: Mesothelioma (sa... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL052-POS-01-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Mesothelioma\n4. Patient History > Age at Diagnosis: Any\n5. Note: same patient\n6. Navigate to Results/Recommendations screen', 'Rule triggers - both PHX same patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-023-TC02', 'NCCN-RULE-023', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal/Kidney Cancer only (no mesothelioma)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL052-NEG-02-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (no mesothelioma)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - missing mesothelioma', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-023-TC03', 'NCCN-RULE-023', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal AND FDR: Mesothelioma (meso not PHX)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL052-NEG-03-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Mesothelioma\n5. Family History > Age at Diagnosis: Any\n6. Note: meso not PHX\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - mesothelioma must be PHX Cross-check: NCCN-RENL-053', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-023-TC04', 'NCCN-RULE-023', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Kidney Cancer AND PHX: Mesothelioma (differen... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL052-POS-01-Px4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Mesothelioma\n4. Patient History > Age at Diagnosis: Any\n5. Note: different terminology\n6. Navigate to Results/Recommendations screen', 'Rule triggers - both PHX', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-023-TC05', 'NCCN-RULE-023', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Mesothelioma only (no renal)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL052-NEG-02-Px4M',
    '1. Patient History > Cancer Type: Mesothelioma\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (no renal)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - missing renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-023-TC06', 'NCCN-RULE-023', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND PHX: Mesothelioma (renal not PHX)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL052-NEG-03-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Patient History > Cancer Type: Mesothelioma\n5. Patient History > Age at Diagnosis: Any\n6. Note: renal not PHX\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - renal must be PHX', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-024-TC01', 'NCCN-RULE-024', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Renal/Kidney Cancer AND FDR: Mesothelioma... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL053-POS-01-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Mesothelioma\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule triggers - PHX renal + FDR meso', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-024-TC02', 'NCCN-RULE-024', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal AND TDR: Mesothelioma... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL053-NEG-02-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Mesothelioma\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-024-TC03', 'NCCN-RULE-024', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND FDR: Mesothelioma (no PHX renal)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL053-NEG-03-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: no PHX renal\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs PHX renal Cross-check: NCCN-RENL-056', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-024-TC04', 'NCCN-RULE-024', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Kidney Cancer AND SDR: Mesothelioma... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL053-POS-01-Px4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Mesothelioma\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule triggers - PHX renal + SDR meso', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-024-TC05', 'NCCN-RULE-024', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND SDR: Mesothelioma (no PHX)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL053-NEG-02-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: no PHX\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs PHX renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-024-TC06', 'NCCN-RULE-024', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal AND PHX: Mesothelioma (both PHX)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL053-NEG-03-Px4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Mesothelioma\n4. Patient History > Age at Diagnosis: Any\n5. Note: both PHX\n6. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - meso must be FDR/SDR Cross-check: NCCN-RENL-052', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-025-TC01', 'NCCN-RULE-025', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Renal Cancer AND PHX: Uveal Melanoma (same pa... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL054-POS-01-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Uveal Melanoma\n4. Patient History > Age at Diagnosis: Any\n5. Note: same patient\n6. Navigate to Results/Recommendations screen', 'Rule triggers - both PHX same patient', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-025-TC02', 'NCCN-RULE-025', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal only (no uveal melanoma)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL054-NEG-02-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (no uveal melanoma)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - missing uveal melanoma', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-025-TC03', 'NCCN-RULE-025', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal AND FDR: Uveal Melanoma (uveal not PHX)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL054-NEG-03-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Uveal Melanoma\n5. Family History > Age at Diagnosis: Any\n6. Note: uveal not PHX\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - uveal must be PHX Cross-check: NCCN-RENL-055', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-025-TC04', 'NCCN-RULE-025', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Kidney Cancer AND PHX: Melanoma of Eye... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL054-POS-01-Px4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Uveal Melanoma\n4. Patient History > Age at Diagnosis: Any\n5. Navigate to Results/Recommendations screen', 'Rule triggers - both PHX (alt terminology)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-025-TC05', 'NCCN-RULE-025', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Uveal Melanoma only (no renal)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL054-NEG-02-Px4M',
    '1. Patient History > Cancer Type: Uveal Melanoma\n2. Patient History > Age at Diagnosis: Any\n3. Note: Single condition test - (no renal)\n4. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - missing renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-025-TC06', 'NCCN-RULE-025', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND PHX: Uveal Melanoma (renal not PHX)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL054-NEG-03-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Patient History > Cancer Type: Uveal Melanoma\n5. Patient History > Age at Diagnosis: Any\n6. Note: renal not PHX\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - renal must be PHX', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-026-TC01', 'NCCN-RULE-026', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Renal Cancer AND FDR: Uveal Melanoma... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL055-POS-01-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Mother (First Degree)\n4. Family History > Cancer Type: Uveal Melanoma\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule triggers - PHX renal + FDR uveal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-026-TC02', 'NCCN-RULE-026', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal AND TDR: Uveal Melanoma... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL055-NEG-02-P4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Great-Aunt (Third Degree)\n4. Family History > Cancer Type: Uveal Melanoma\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-026-TC03', 'NCCN-RULE-026', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND FDR: Uveal Melanoma (no PHX renal)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL055-NEG-03-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: no PHX renal\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs PHX renal Cross-check: NCCN-RENL-059/060', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-026-TC04', 'NCCN-RULE-026', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: PHX: Kidney Cancer AND SDR: Uveal Melanoma... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL055-POS-01-Px4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Family History > Add Relative: Grandmother (Second Degree)\n4. Family History > Cancer Type: Uveal Melanoma\n5. Family History > Age at Diagnosis: Any\n6. Navigate to Results/Recommendations screen', 'Rule triggers - PHX renal + SDR uveal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-026-TC05', 'NCCN-RULE-026', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND SDR: Uveal Melanoma (no PHX)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL055-NEG-02-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: no PHX\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs PHX renal Cross-check: NCCN-RENL-060', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-026-TC06', 'NCCN-RULE-026', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: PHX: Renal AND PHX: Uveal Melanoma (both PHX)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL055-NEG-03-Px4M',
    '1. Patient History > Cancer Type: Renal/Kidney Cancer\n2. Patient History > Age at Diagnosis: Any\n3. Patient History > Cancer Type: Uveal Melanoma\n4. Patient History > Age at Diagnosis: Any\n5. Note: both PHX\n6. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - uveal must be FDR/SDR Cross-check: NCCN-RENL-054', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-027-TC01', 'NCCN-RULE-027', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Renal Cancer AND same FDR: Mesothelioma (same... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL056-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Mother (First Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: same relative\n8. Navigate to Results/Recommendations screen', 'Rule triggers - FDR with both cancers', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-027-TC02', 'NCCN-RULE-027', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND different SDR: Mesothelioma (differ... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL056-NEG-02-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandmother (Second Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: different people\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - must be same person', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-027-TC03', 'NCCN-RULE-027', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND SDR: Mesothelioma (no FDR)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL056-NEG-03-P4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: no FDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-027-TC04', 'NCCN-RULE-027', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Kidney Cancer AND same FDR: Mesothelioma (mot... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL056-POS-01-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Mother (First Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: mother has both\n8. Navigate to Results/Recommendations screen', 'Rule triggers - same relative has both', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-027-TC05', 'NCCN-RULE-027', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND TDR: Mesothelioma... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL056-NEG-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-027-TC06', 'NCCN-RULE-027', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Renal AND TDR: Mesothelioma (same TDR)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL056-NEG-03-Px4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Uncle (Third Degree)\n5. Family History > Cancer Type: Mesothelioma\n6. Family History > Age at Diagnosis: Any\n7. Note: same TDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-028-TC01', 'NCCN-RULE-028', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Renal Cancer AND SDR: Renal Cancer (2 relativ... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL058-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandmother (Second Degree)\n5. Family History > Cancer Type: Renal/Kidney Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: 2 relatives\n8. Navigate to Results/Recommendations screen', 'Rule triggers - FDR + SDR renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-028-TC02', 'NCCN-RULE-028', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal Cancer only (single relative)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL058-NEG-02-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Note: Single condition test - (single relative)\n5. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs 2+ relatives', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-028-TC03', 'NCCN-RULE-028', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND TDR: Renal (no FDR)... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL058-NEG-03-P4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Renal/Kidney Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: no FDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs at least one FDR', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-028-TC04', 'NCCN-RULE-028', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Kidney Cancer AND another FDR: Kidney Cancer ... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL058-POS-01-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Renal/Kidney Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: 2 FDRs\n8. Navigate to Results/Recommendations screen', 'Rule triggers - 2 FDRs with renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-028-TC05', 'NCCN-RULE-028', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND SDR: Renal (2 SDRs, no FDR)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL058-NEG-02-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Renal/Kidney Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: 2 SDRs, no FDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-028-TC06', 'NCCN-RULE-028', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND TDR: Renal (TDR not in rule)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL058-NEG-03-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Renal/Kidney Cancer\n6. Family History > Age at Diagnosis: Any\n7. Note: TDR not in rule\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not valid', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-029-TC01', 'NCCN-RULE-029', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Renal AND same FDR: Uveal Melanoma (same rela... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL059-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Mother (First Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: same relative\n8. Navigate to Results/Recommendations screen', 'Rule triggers - FDR with both', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-029-TC02', 'NCCN-RULE-029', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND different SDR: Uveal Melanoma (diff... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL059-NEG-02-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandmother (Second Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: different people\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - must be same person Cross-check: NCCN-RENL-060', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-029-TC03', 'NCCN-RULE-029', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND SDR: Uveal Melanoma (same SDR, no F... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL059-NEG-03-P4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandfather (Second Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: same SDR, no FDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-029-TC04', 'NCCN-RULE-029', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Kidney AND same FDR: Melanoma of Eye (father ... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL059-POS-01-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Mother (First Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: father has both\n8. Navigate to Results/Recommendations screen', 'Rule triggers - same FDR', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-029-TC05', 'NCCN-RULE-029', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND TDR: Uveal Melanoma... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL059-NEG-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-029-TC06', 'NCCN-RULE-029', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: TDR: Renal AND TDR: Uveal Melanoma (same TDR)... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL059-NEG-03-Px4M',
    '1. Family History > Add Relative: Great-Aunt (Third Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Uncle (Third Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: same TDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-030-TC01', 'NCCN-RULE-030', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Renal AND another SDR: Uveal Melanoma (differ... (P4M)', NULL, 'happy_path', 'Platform: P4M | Profile: TP-RENL060-POS-01-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Grandmother (Second Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: different relatives\n8. Navigate to Results/Recommendations screen', 'Rule triggers - FDR renal + SDR uveal (different people)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-030-TC02', 'NCCN-RULE-030', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND TDR: Uveal Melanoma... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL060-NEG-02-P4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Great-Aunt (Third Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - TDR uveal not in rule', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-030-TC03', 'NCCN-RULE-030', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal only AND SDR: Uveal Melanoma (no FDR re... (P4M)', NULL, 'negative', 'Platform: P4M | Profile: TP-RENL060-NEG-03-P4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Note: Single condition test\n5. Family History > Add Relative: Grandfather (Second Degree)\n6. Family History > Cancer Type: Uveal Melanoma\n7. Family History > Age at Diagnosis: Any\n8. Note: no FDR renal\n9. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-030-TC04', 'NCCN-RULE-030', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'POS: FDR: Kidney Cancer AND another FDR: Uveal Melanoma... (Px4M)', NULL, 'happy_path', 'Platform: Px4M | Profile: TP-RENL060-POS-01-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Father (First Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: different FDRs\n8. Navigate to Results/Recommendations screen', 'Rule triggers - different relatives', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-030-TC05', 'NCCN-RULE-030', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: FDR: Renal AND same FDR: Uveal Melanoma (same pers... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL060-NEG-02-Px4M',
    '1. Family History > Add Relative: Mother (First Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Same Relative: Add cancer to Mother (First Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: same person\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - must be different people Cross-check: NCCN-RENL-059', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-RULE-030-TC06', 'NCCN-RULE-030', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'NEG: SDR: Renal AND FDR: Uveal Melanoma (SDR renal, not... (Px4M)', NULL, 'negative', 'Platform: Px4M | Profile: TP-RENL060-NEG-03-Px4M',
    '1. Family History > Add Relative: Grandmother (Second Degree)\n2. Family History > Cancer Type: Renal/Kidney Cancer\n3. Family History > Age at Diagnosis: Any\n4. Family History > Add Relative: Mother (First Degree)\n5. Family History > Cancer Type: Uveal Melanoma\n6. Family History > Age at Diagnosis: Any\n7. Note: SDR renal, not FDR\n8. Navigate to Results/Recommendations screen', 'Rule does NOT trigger - needs FDR renal', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC01', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Type: Description... (Platform)', NULL, 'validation', 'Platform: Platform | Content ID: Content ID',
    '1. Log into Platform platform\n2. Navigate to: Location\n3. Locate: Type\n4. Verify content matches: Description', 'Content displays correctly: Description', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC02', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Help Text: Metastatic question - ''lymph node-positi... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-40',
    '1. Log into P4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Help Text\n4. Verify content matches: Metastatic question - ''lymph node-positive disease''', 'Content displays correctly: Metastatic question - ''lymph node-positive disease''', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC03', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Help Text: Metastatic question - ''lymph node-positi... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-40',
    '1. Log into Px4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Help Text\n4. Verify content matches: Metastatic question - ''lymph node-positive disease''', 'Content displays correctly: Metastatic question - ''lymph node-positive disease''', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC04', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Allow multiple same-cancer entries (Lync... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-41',
    '1. Log into P4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Question Text\n4. Verify content matches: Allow multiple same-cancer entries (Lynch)', 'Content displays correctly: Allow multiple same-cancer entries (Lynch)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC05', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Allow multiple same-cancer entries (Lync... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-41',
    '1. Log into Px4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Question Text\n4. Verify content matches: Allow multiple same-cancer entries (Lynch)', 'Content displays correctly: Allow multiple same-cancer entries (Lynch)', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC06', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Help Text: Sebaceous adenoma clarification... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-42',
    '1. Log into P4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Help Text\n4. Verify content matches: Sebaceous adenoma clarification', 'Content displays correctly: Sebaceous adenoma clarification', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC07', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Help Text: Sebaceous adenoma clarification... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-42',
    '1. Log into Px4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Help Text\n4. Verify content matches: Sebaceous adenoma clarification', 'Content displays correctly: Sebaceous adenoma clarification', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC08', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Updated question text for multiple rules... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-43',
    '1. Log into P4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Question Text\n4. Verify content matches: Updated question text for multiple rules', 'Content displays correctly: Updated question text for multiple rules', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC09', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Updated question text for multiple rules... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-43',
    '1. Log into Px4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Question Text\n4. Verify content matches: Updated question text for multiple rules', 'Content displays correctly: Updated question text for multiple rules', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC10', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Add Mesothelioma and Uveal Melanoma to d... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-44',
    '1. Log into P4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Question Text\n4. Verify content matches: Add Mesothelioma and Uveal Melanoma to dropdowns', 'Content displays correctly: Add Mesothelioma and Uveal Melanoma to dropdowns', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC11', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Add Mesothelioma and Uveal Melanoma to d... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-44',
    '1. Log into Px4M platform\n2. Navigate to: Risk Assessment\n3. Locate: Question Text\n4. Verify content matches: Add Mesothelioma and Uveal Melanoma to dropdowns', 'Content displays correctly: Add Mesothelioma and Uveal Melanoma to dropdowns', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC12', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Document: Updated disclaimers... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-45',
    '1. Log into P4M platform\n2. Navigate to: Clinical Summary\n3. Locate: Document\n4. Verify content matches: Updated disclaimers', 'Content displays correctly: Updated disclaimers', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC13', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Document: Updated disclaimers... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-45',
    '1. Log into Px4M platform\n2. Navigate to: Clinical Summary\n3. Locate: Document\n4. Verify content matches: Updated disclaimers', 'Content displays correctly: Updated disclaimers', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC14', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'FAQ: MRI Information content... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-46',
    '1. Log into P4M platform\n2. Navigate to: Info Pages\n3. Locate: FAQ\n4. Verify content matches: MRI Information content', 'Content displays correctly: MRI Information content', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC15', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'FAQ: MRI Information content... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-46',
    '1. Log into Px4M platform\n2. Navigate to: Info Pages\n3. Locate: FAQ\n4. Verify content matches: MRI Information content', 'Content displays correctly: MRI Information content', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC16', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Prevention4ME screening program explanat... (P4M)', NULL, 'validation', 'Platform: P4M | Content ID: 25Q4C-47',
    '1. Log into P4M platform\n2. Navigate to: End of Assessment\n3. Locate: Question Text\n4. Verify content matches: Prevention4ME screening program explanation', 'Content displays correctly: Prevention4ME screening program explanation', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-CONTENT-001-TC17', 'NCCN-CONTENT-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Question Text: Prevention4ME screening program explanat... (Px4M)', NULL, 'validation', 'Platform: Px4M | Content ID: 25Q4C-47',
    '1. Log into Px4M platform\n2. Navigate to: End of Assessment\n3. Locate: Question Text\n4. Verify content matches: Prevention4ME screening program explanation', 'Content displays correctly: Prevention4ME screening program explanation', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC01', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Cancer Type (Platform)', NULL, 'validation', 'Platform: Platform | Change ID: Change ID',
    '1. Log into Platform platform\n2. Navigate to Cancer Type rule area\n3. Verify version text displays as: New Version Text', 'Version text shows: New Version Text', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC02', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Breast (P4M)', NULL, 'validation', 'Platform: P4M | Change ID: 25Q4R-32',
    '1. Log into P4M platform\n2. Navigate to Breast rule area\n3. Verify version text displays as: Genetic/Familial High-Risk Assessment: Breast, Ovarian, Pancreatic Version 2.2026', 'Version text shows: Genetic/Familial High-Risk Assessment: Breast, Ovarian, Pancreatic Version 2.2026', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC03', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Breast (Px4M)', NULL, 'validation', 'Platform: Px4M | Change ID: 25Q4R-32',
    '1. Log into Px4M platform\n2. Navigate to Breast rule area\n3. Verify version text displays as: Genetic/Familial High-Risk Assessment: Breast, Ovarian, Pancreatic Version 2.2026', 'Version text shows: Genetic/Familial High-Risk Assessment: Breast, Ovarian, Pancreatic Version 2.2026', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC04', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Renal/Kidney (P4M)', NULL, 'validation', 'Platform: P4M | Change ID: 25Q4R-33',
    '1. Log into P4M platform\n2. Navigate to Renal/Kidney rule area\n3. Verify version text displays as: Genetic/Familial High-Risk Assessment: Renal/Kidney Version 1.2026', 'Version text shows: Genetic/Familial High-Risk Assessment: Renal/Kidney Version 1.2026', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC05', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Renal/Kidney (Px4M)', NULL, 'validation', 'Platform: Px4M | Change ID: 25Q4R-33',
    '1. Log into Px4M platform\n2. Navigate to Renal/Kidney rule area\n3. Verify version text displays as: Genetic/Familial High-Risk Assessment: Renal/Kidney Version 1.2026', 'Version text shows: Genetic/Familial High-Risk Assessment: Renal/Kidney Version 1.2026', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC06', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Colorectal/Gastric/Endometrial (P4M)', NULL, 'validation', 'Platform: P4M | Change ID: 25Q4R-34',
    '1. Log into P4M platform\n2. Navigate to Colorectal/Gastric/Endometrial rule area\n3. Verify version text displays as: Genetic/Familial High-Risk Assessment: CRC/Gastric/Endometrial Version 1.2025', 'Version text shows: Genetic/Familial High-Risk Assessment: CRC/Gastric/Endometrial Version 1.2025', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'NCCN-LANG-001-TC07', 'NCCN-LANG-001', 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', 'UAT-NCCN-A57B4A47',
    'Version: Colorectal/Gastric/Endometrial (Px4M)', NULL, 'validation', 'Platform: Px4M | Change ID: 25Q4R-34',
    '1. Log into Px4M platform\n2. Navigate to Colorectal/Gastric/Endometrial rule area\n3. Verify version text displays as: Genetic/Familial High-Risk Assessment: CRC/Gastric/Endometrial Version 1.2025', 'Version text shows: Genetic/Familial High-Risk Assessment: CRC/Gastric/Endometrial Version 1.2025', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-DASH-001-TC01', 'PXME-DASH-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify all status columns display in search results', NULL, 'happy_path', 'Provider is logged into Precision4ME dashboard. Test patients exist with various status values.',
    '1. Navigate to Provider Dashboard\n2. Click the Search tab\n3. Enter a valid patient name or MRN in the search field\n4. Click Search button\n5. Observe the results table columns', 'Results table displays the following columns: Invitation Status, Precision4ME Status, Activity Status, and Consent Status. Each column shows the appropriate status value for each patient row.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:41:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:41:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-DASH-001-TC02', 'PXME-DASH-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify status columns are sortable', NULL, 'validation', 'Provider is logged into Precision4ME dashboard. Search results are displayed with multiple patients having different status values.',
    '1. Perform a patient search that returns multiple results\n2. Click the Invitation Status column header\n3. Verify results sort by Invitation Status\n4. Click the column header again\n5. Verify sort order reverses\n6. Repeat for Precision4ME Status, Activity Status, and Consent Status columns', 'Clicking each column header sorts the results table by that column. First click sorts ascending, second click sorts descending. Sort indicator icon appears on the active sort column.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:41:54'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:41:54'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-DASH-001-TC03', 'PXME-DASH-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify table handles patients with null/missing status values', NULL, 'edge_case', 'Test patient exists with no invitation sent, no Precision4ME activity, and no consent recorded.',
    '1. Navigate to Provider Dashboard Search tab\n2. Search for a test patient with no recorded status values\n3. Observe how the status columns display for this patient', 'Table displays gracefully with appropriate placeholder (e.g., "--" or "N/A") for patients with null/missing status values. Table does not throw errors or display blank cells.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:42:02'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:42:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-DASH-001-TC04', 'PXME-DASH-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify role-based access to patient status data', NULL, 'validation', 'Multiple user accounts exist with different roles (Provider, Admin, Read-only).',
    '1. Log in as a user with Provider role\n2. Navigate to Search tab and perform a patient search\n3. Verify status columns are visible and display patient data\n4. Log out and log in as a user with Read-only role\n5. Attempt to access the same patient search\n6. Verify access is restricted or data is appropriately limited based on role', 'Patient status information (Invitation, Precision4ME, Activity, Consent) is only visible to authenticated providers with appropriate role-based access. Unauthorized users cannot view patient status data.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:42:10'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:42:10'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-DASH-001-TC05', 'PXME-DASH-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures patient search activity', NULL, 'validation', 'Audit logging is enabled. Provider account exists.',
    '1. Log in as Provider\n2. Navigate to Search tab\n3. Perform a patient search\n4. View the patient status columns in results\n5. Access the system audit log\n6. Verify the search action was recorded with appropriate details', 'Audit log captures: user ID, timestamp, patient MRN/ID searched, action performed (search), and IP address/session info. Log entry is immutable and timestamped.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:42:19'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:42:19'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC01', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify CustomNext-Cancer is default test type', NULL, 'happy_path', 'Provider is logged in. A patient is selected for ordering.',
    '1. Navigate to the Ordering Module\n2. Select a patient for a new order\n3. Observe the Test Type field default value\n4. Verify "CustomNext-Cancer" is selected by default', 'The Test Type field is pre-selected to "CustomNext-Cancer" when the order form loads. Provider can proceed with order using the default or change it.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:43:34'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:43:34'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC02', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify RNAInsight test option is available and selectable', NULL, 'happy_path', 'Provider is logged in. A patient is selected for ordering.',
    '1. Navigate to the Ordering Module\n2. Select a patient for a new order\n3. Click the Test Type dropdown\n4. Verify both test options are available\n5. Select "CustomNext-Cancer + RNAInsight"\n6. Verify the Sample Type options update appropriately', 'Dropdown displays two options: "CustomNext-Cancer" and "CustomNext-Cancer + RNAInsight". Provider can select "CustomNext-Cancer + RNAInsight" and the form updates to show appropriate sample type options.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:43:42'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:43:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC03', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify sample updates work for CustomNext-Cancer orders', NULL, 'validation', 'An order exists with "CustomNext-Cancer" test type. Sample has been collected.',
    '1. Locate an existing order with "CustomNext-Cancer" test type\n2. Navigate to the sample update interface\n3. Update the sample status\n4. Save the update\n5. Verify the sample tracking reflects the update', 'The sample update interface correctly associates with the CustomNext-Cancer test type. Sample status can be updated (received, processed, etc.). Sample tracking history is recorded.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:43:55'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:43:55'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC04', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify sample updates work for RNAInsight orders', NULL, 'validation', 'An order exists with "CustomNext-Cancer + RNAInsight" test type. Sample has been collected.',
    '1. Locate an existing order with "CustomNext-Cancer + RNAInsight" test type\n2. Navigate to the sample update interface\n3. Update the sample status\n4. Save the update\n5. Verify the sample tracking reflects the update', 'The sample update interface correctly associates with the RNAInsight test type. Sample status can be updated. Sample tracking history is recorded. RNA-specific sample handling is supported.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:44:09'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:44:09'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC05', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures test type selection', NULL, 'validation', 'Audit logging is enabled. Provider account exists.',
    '1. Log in as Provider\n2. Navigate to Ordering Module\n3. Create an order with CustomNext-Cancer test type\n4. Create another order with CustomNext-Cancer + RNAInsight test type\n5. Access the system audit log\n6. Verify both test type selections were recorded with timestamps and user info', 'Audit log captures: user ID, timestamp, patient ID, test type selected (CustomNext-Cancer or CustomNext-Cancer + RNAInsight), order ID. All test type selections and changes are traceable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:44:22'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:44:22'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC06', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures sample status updates', NULL, 'validation', 'Audit logging is enabled. Orders exist with both test types. Samples have been collected.',
    '1. Log in as authorized user\n2. Locate an order with CustomNext-Cancer test type\n3. Update the sample status (e.g., Received → Processing)\n4. Locate an order with CustomNext-Cancer + RNAInsight test type\n5. Update the sample status\n6. Access the system audit log\n7. Verify all sample status changes are recorded with complete details', 'Audit log captures: user ID, timestamp, sample ID, order ID, previous status, new status, test type. Complete chain of custody is traceable from collection through processing.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-16 15:44:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:44:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-003-TC01', 'PXME-ORDER-003', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ICD-10 dropdown includes all extract filter codes', NULL, 'happy_path', 'Provider is logged in. Extract filter is configured with specific ICD-10 codes. A patient is selected for ordering.',
    '1. Navigate to the Ordering Module\n2. Select a patient for a new order\n3. Click the ICD-10 code dropdown field\n4. Observe the list of available ICD-10 codes\n5. Compare against the extract filter configuration ICD-10 codes', 'The ICD-10 dropdown displays all codes from the extract filter configuration, including existing Z codes and any additional diagnosis codes. Each code shows code number and description.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:17:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:17:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-003-TC02', 'PXME-ORDER-003', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ICD-10 codes display with code number and description', NULL, 'validation', 'Provider is logged in. A patient is selected for ordering.',
    '1. Navigate to the Ordering Module\n2. Select a patient for a new order\n3. Click the ICD-10 code dropdown field\n4. Review each code entry for proper formatting\n5. Verify code number and description are both present for all entries', 'Each ICD-10 code in the dropdown displays both the code number and its full description. Format is consistent (e.g., "Z85.3 - Personal history of malignant neoplasm of breast").', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:17:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:17:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-003-TC03', 'PXME-ORDER-003', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures ICD-10 code selection', NULL, 'validation', 'Audit logging is enabled. Provider account exists.',
    '1. Log in as Provider\n2. Navigate to Ordering Module\n3. Select a patient for ordering\n4. Select an ICD-10 code from the dropdown\n5. Submit the order\n6. Access the system audit log\n7. Verify the ICD-10 code selection was recorded with timestamps and user info', 'Audit log captures: user ID, timestamp, patient ID, ICD-10 code selected, order ID. The code selection is traceable for compliance purposes.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:17:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:17:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-004-TC01', 'PXME-ORDER-004', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ICD-10 auto-populates from uncategorized patient record', NULL, 'happy_path', 'Provider is logged in. A patient exists on the Uncategorized Patient tab with an ICD-10 code in their record.',
    '1. Navigate to the Uncategorized Patient tab\n2. Select a patient who has an ICD-10 code in their record\n3. Initiate a new order for this patient\n4. Observe the ICD-10 code field in the ordering module\n5. Verify the code is pre-populated from the patient record', 'The ICD-10 field is pre-populated with the code from the patient''s record. The auto-populated code is visually indicated as sourced from patient record. Provider can keep or change the code using the dropdown.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:17:50'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:17:50'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-004-TC02', 'PXME-ORDER-004', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify provider can override auto-populated ICD-10 code', NULL, 'validation', 'Provider is logged in. A patient exists on the Uncategorized Patient tab with an ICD-10 code in their record.',
    '1. Navigate to the Uncategorized Patient tab\n2. Select a patient who has an ICD-10 code in their record\n3. Initiate a new order for this patient\n4. Observe the auto-populated ICD-10 code\n5. Click the dropdown and select a different code\n6. Submit the order\n7. Verify the order is saved with the manually selected code', 'Provider can click the dropdown and select a different ICD-10 code, replacing the auto-populated value. The new code is saved with the order.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:17:57'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:17:57'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-004-TC03', 'PXME-ORDER-004', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ordering handles patient without ICD-10 in record', NULL, 'edge_case', 'Provider is logged in. A patient exists on the Uncategorized Patient tab with NO ICD-10 code in their record.',
    '1. Navigate to the Uncategorized Patient tab\n2. Select a patient who does NOT have an ICD-10 code in their record\n3. Initiate a new order for this patient\n4. Observe the ICD-10 code field in the ordering module\n5. Verify the field is empty or prompts for selection\n6. Select a code from the dropdown', 'The ICD-10 field remains empty or displays a prompt to select a code. Provider can manually select a code from the curated dropdown list without error.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:18:04'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:18:04'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-004-TC04', 'PXME-ORDER-004', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures ICD-10 code changes', NULL, 'validation', 'Audit logging is enabled. Provider account exists. Patient record has an ICD-10 code.',
    '1. Log in as Provider\n2. Navigate to Ordering Module for a patient with ICD-10 in record\n3. Observe the auto-populated ICD-10 code\n4. Change the code to a different value from the dropdown\n5. Submit the order\n6. Access the system audit log\n7. Verify both original and final ICD-10 codes were recorded', 'Audit log captures: user ID, timestamp, patient ID, original auto-populated ICD-10 code, final selected ICD-10 code, and whether the code was changed from the auto-populated value. Complete traceability of code selection is maintained.', 'Should Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:18:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:18:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC07', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify CustomNext-Cancer order transmits to Redox correctly', NULL, 'validation', 'Redox integration is configured and active. Provider is logged in. A patient is selected for ordering.',
    '1. Navigate to the Ordering Module\n2. Select a patient for a new order\n3. Keep the default Test Type (CustomNext-Cancer)\n4. Complete all required order fields\n5. Submit the order\n6. Verify the order was transmitted to Redox\n7. Confirm the test type code in the Redox transmission is correct', 'Order is successfully transmitted to Redox with the correct test type code for CustomNext-Cancer. Confirmation of transmission is received and logged.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:18:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:18:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC08', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify RNAInsight order transmits to Redox correctly', NULL, 'validation', 'Redox integration is configured and active. Provider is logged in. A patient is selected for ordering.',
    '1. Navigate to the Ordering Module\n2. Select a patient for a new order\n3. Change the Test Type to "CustomNext-Cancer + RNAInsight"\n4. Complete all required order fields\n5. Submit the order\n6. Verify the order was transmitted to Redox\n7. Confirm the test type code in the Redox transmission is correct for RNAInsight', 'Order is successfully transmitted to Redox with the correct test type code for CustomNext-Cancer + RNAInsight. Confirmation of transmission is received and logged.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:18:37'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:18:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC09', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures Redox order transmission', NULL, 'validation', 'Audit logging is enabled. Redox integration is configured. Provider account exists.',
    '1. Log in as Provider\n2. Create and submit an order with CustomNext-Cancer test type\n3. Create and submit another order with CustomNext-Cancer + RNAInsight test type\n4. Access the system audit log\n5. Verify both orders have complete transmission records including Redox confirmation\n6. Confirm all required audit fields are populated', 'Audit log captures: user ID, timestamp, order ID, patient ID, test type, Redox transmission timestamp, Redox confirmation/acknowledgment, and transmission status. Complete chain of custody from order creation to lab transmission is traceable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:18:46'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:18:46'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-001-TC01', 'PXME-CONSENT-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify provider can manually consent a patient with pending consent', NULL, 'happy_path', 'Provider is logged in. Patient has completed assessment but consent status is "Pending".',
    '1. Navigate to a patient record with Consent Status = "Pending"\n2. Locate the consent status section\n3. Click the option to manually consent\n4. Enter the paper consent date\n5. Confirm the paper consent was obtained\n6. Submit the change\n7. Verify consent status is now "Manually Consented"', 'Provider can click a button/link to change consent status. A dialog appears requiring confirmation and paper consent date. After submitting, consent status changes to "Manually Consented".', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:19:10'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:19:10'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-001-TC02', 'PXME-CONSENT-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify manually consented patient becomes eligible for ordering', NULL, 'validation', 'Provider is logged in. Patient consent status has just been changed to "Manually Consented".',
    '1. Confirm patient consent status is "Manually Consented"\n2. Navigate to the Ordering Module\n3. Select this patient for a new order\n4. Complete all required order fields\n5. Submit the order\n6. Verify the order is created successfully', 'After consent status is changed to "Manually Consented", the provider can proceed to the Ordering Module and successfully create an order for this patient.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:19:20'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:19:20'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-001-TC03', 'PXME-CONSENT-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify manual consent requires confirmation and date', NULL, 'negative', 'Provider is logged in. Patient has consent status "Pending".',
    '1. Navigate to a patient record with Consent Status = "Pending"\n2. Click the option to manually consent\n3. Attempt to submit WITHOUT entering the paper consent date\n4. Observe the validation error\n5. Attempt to submit WITHOUT checking the confirmation box\n6. Observe the validation error', 'The system prevents submission and displays a validation error requiring both the confirmation checkbox and paper consent date before allowing the consent status change.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:19:31'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:19:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-001-TC04', 'PXME-CONSENT-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures manual consent status change', NULL, 'validation', 'Audit logging is enabled. Provider account exists. Patient has consent status "Pending".',
    '1. Log in as Provider\n2. Navigate to a patient with Consent Status = "Pending"\n3. Change consent status to "Manually Consented" with required details\n4. Access the system audit log\n5. Verify the consent status change is recorded with all required details\n6. Confirm timestamp, user ID, and patient ID are present', 'Audit log captures: user ID (provider who made change), timestamp, patient ID, previous consent status, new consent status ("Manually Consented"), paper consent date, and confirmation details. The consent change is fully traceable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:19:43'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:19:43'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-001-TC05', 'PXME-CONSENT-001', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify role-based access to manual consent function', NULL, 'validation', 'Multiple user accounts exist with different roles (Provider, Admin, Read-only).',
    '1. Log in as a user with Provider role\n2. Verify the manual consent option is available\n3. Log out and log in as a user with Read-only role\n4. Navigate to the same patient record\n5. Verify the manual consent option is NOT available or disabled\n6. Attempt to change consent status if accessible\n7. Verify access is denied', 'Only users with Provider role can change consent status. Users with read-only or lower privilege roles cannot access the manual consent function. Unauthorized access attempts are logged.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:19:57'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:19:57'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC01', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ordering allowed for electronically consented patient', NULL, 'happy_path', 'Provider is logged in. Patient has consent status "Consented" (electronic).',
    '1. Navigate to a patient with Consent Status = "Consented"\n2. Navigate to the Ordering Module\n3. Select this patient for a new order\n4. Complete all required order fields\n5. Submit the order\n6. Verify the order is created successfully', 'Order is created successfully and transmitted to Redox. No consent validation errors occur.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:20:28'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:20:28'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC02', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ordering allowed for manually consented patient', NULL, 'happy_path', 'Provider is logged in. Patient has consent status "Manually Consented" (paper consent recorded).',
    '1. Navigate to a patient with Consent Status = "Manually Consented"\n2. Navigate to the Ordering Module\n3. Select this patient for a new order\n4. Complete all required order fields\n5. Submit the order\n6. Verify the order is created successfully', 'Order is created successfully and transmitted to Redox. No consent validation errors occur.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:20:39'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:20:39'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC03', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ordering blocked for patient with Pending consent', NULL, 'negative', 'Provider is logged in. Patient has consent status "Pending".',
    '1. Navigate to a patient with Consent Status = "Pending"\n2. Navigate to the Ordering Module\n3. Select this patient for a new order\n4. Complete all required order fields\n5. Attempt to submit the order\n6. Observe the validation error message\n7. Verify the order was NOT created', 'Order submission is BLOCKED. System displays clear error message: "Order cannot be submitted. Patient consent is pending. Please obtain consent before ordering." Order is NOT transmitted to Redox.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:20:52'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:20:52'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC04', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify ordering blocked for patient with Declined consent', NULL, 'negative', 'Provider is logged in. Patient has consent status "Declined".',
    '1. Navigate to a patient with Consent Status = "Declined"\n2. Navigate to the Ordering Module\n3. Select this patient for a new order\n4. Complete all required order fields\n5. Attempt to submit the order\n6. Observe the validation error message\n7. Verify the order was NOT created', 'Order submission is BLOCKED. System displays clear error message: "Order cannot be submitted. Patient has declined consent." Order is NOT transmitted to Redox.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:21:12'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:21:12'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC05', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Verify consent validation cannot be bypassed by any role', NULL, 'validation', 'Admin user account exists. Patient has consent status "Pending".',
    '1. Log in as Admin user\n2. Navigate to a patient with Consent Status = "Pending"\n3. Navigate to the Ordering Module\n4. Select this patient for a new order\n5. Complete all required order fields\n6. Attempt to submit the order\n7. Verify the order is blocked with consent validation error\n8. Confirm no override option is available', 'Order submission is blocked for ALL user roles including Admin. No role can bypass the consent validation. The consent gate applies equally to all users.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:21:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:21:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC06', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Part 11 - Verify audit trail captures blocked order attempts', NULL, 'validation', 'Audit logging is enabled. Provider account exists. Patient has consent status "Pending".',
    '1. Log in as Provider\n2. Navigate to a patient with Consent Status = "Pending"\n3. Attempt to create an order (which will be blocked)\n4. Access the system audit log\n5. Verify the blocked order attempt is recorded\n6. Confirm all required audit fields are present', 'Audit log captures: user ID, timestamp, patient ID, consent status at time of attempt, reason for block, and order details that were attempted. All blocked order attempts are traceable.', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 12:21:48'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 12:21:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC07', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify role-based access to consent validation function', NULL, 'validation', 'Multiple user accounts with different roles configured; Patient with consent record exists',
    '1. Log in as authorized role (provider)\n2. Attempt to view patient consent status\n3. Verify access is granted\n4. Log out and log in as unauthorized role\n5. Attempt to view same patient consent status\n6. Verify access is denied', 'Only users with authorized roles (providers, clinical staff) can view consent status; unauthorized roles receive access denied', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 17:01:47'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 17:01:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-CONSENT-002-TC08', 'PXME-CONSENT-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify PHI transmission security during order submission', NULL, 'validation', 'Patient with valid consent; Test order ready to submit; Network monitoring enabled',
    '1. Create a test order for consented patient\n2. Submit order to Redox\n3. Verify transmission uses HTTPS/TLS encryption\n4. Review application logs for any exposed PHI\n5. Verify error messages do not contain patient identifiers', 'Order transmission to Redox uses encrypted connection (HTTPS/TLS); PHI is not exposed in logs or error messages', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 17:01:59'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 17:01:59'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC10', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify role-based access to ordering module', NULL, 'validation', 'Multiple user accounts with different roles; Patient eligible for ordering',
    '1. Log in as authorized ordering role (provider)\n2. Navigate to ordering module\n3. Verify access to test type selection\n4. Log out and log in as unauthorized role (e.g., front desk)\n5. Attempt to access ordering module\n6. Verify access is denied or test type options not visible', 'Only users with ordering privileges can access test type selection; unauthorized roles cannot view or modify test orders', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 17:02:11'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 17:02:11'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC11', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify minimum necessary PHI in ordering workflow', NULL, 'validation', 'Patient with full clinical record; Provider logged in with ordering access',
    '1. Log in as provider\n2. Navigate to patient ordering module\n3. Review patient information displayed during test type selection\n4. Verify only order-relevant PHI is shown (name, DOB, relevant diagnosis)\n5. Verify sensitive data not needed for ordering is not displayed', 'Ordering interface displays only necessary patient info for order creation; full medical history not exposed in ordering workflow', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 17:02:25'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 17:02:25'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;

INSERT INTO uat_test_cases (
    test_id, story_id, program_id, uat_cycle_id, title, category, test_type, prerequisites,
    test_steps, expected_results, priority, estimated_time, test_status, tested_by, tested_date,
    execution_notes, assigned_to, workflow_section, workflow_order, patient_conditions,
    is_compliance_test, notes, created_at, updated_at
) VALUES (
    'PXME-ORDER-002-TC12', 'PXME-ORDER-002', '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'HIPAA - Verify secure PHI transmission to Redox', NULL, 'validation', 'Test order ready to submit; Network monitoring tools available',
    '1. Submit CustomNext-Cancer order to Redox\n2. Verify HTTPS/TLS encryption on transmission\n3. Submit RNAInsight order to Redox\n4. Verify HTTPS/TLS encryption on transmission\n5. Review logs to confirm no PHI or credentials exposed\n6. Trigger a transmission error and verify error message does not contain PHI', 'All order transmissions to Redox use TLS encryption; API credentials are not logged; transmission errors do not expose PHI', 'Must Have', NULL,
    'Not Run', NULL, NULL::TIMESTAMPTZ, NULL,
    NULL, NULL, 0, NULL,
    FALSE, NULL,
    COALESCE('2026-01-17 17:02:40'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 17:02:40'::TIMESTAMPTZ, NOW())
) ON CONFLICT (test_id) DO NOTHING;


ALTER TABLE uat_cycles ENABLE TRIGGER ALL;
ALTER TABLE uat_test_cases ENABLE TRIGGER ALL;

SELECT 'uat_cycles' AS table_name, COUNT(*) AS row_count FROM uat_cycles
UNION ALL SELECT 'uat_test_cases', COUNT(*) FROM uat_test_cases;