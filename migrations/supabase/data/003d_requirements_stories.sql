-- ==========================================================================
-- REQUIREMENTS AND USER STORIES DATA
-- Exported: 2026-01-20T11:41:54.453503
-- ==========================================================================

ALTER TABLE requirements DISABLE TRIGGER ALL;
ALTER TABLE user_stories DISABLE TRIGGER ALL;

-- REQUIREMENTS
INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'Reviewed Option C, okay to proceed once final confirmation is received on viability. For 3a, can you clarify if through assessment/appropriate channel means that the patient would be linked to where they left off after completing their clinical program assessment (I.e., they get to the accordion to see the intro about Discover and navigate away/close the window and then receive a reminder.)', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 2,
    'Track number (N) of patients who received invitations', 'Number (N) Invited', 'Track number (N) of patients who received invitations', 'High',
    'Planned', 'Recruitment Analytics', '{"Impact": "Core metric for outreach effectiveness", "Dependencies": "Should be part of analytics dashboard in a section where we are able to track enrollment metrics (e.g., consented, declined, how many invites were sent out, etc.)", "Timelines": "2025 Q4", "Notes": "Updated Clarifying Question for meeting:\n\nWhen you say ''number of invited patients,'' which point in the funnel are you trying to measure?\n\nOption A: Gross invitations sent (total emails dispatched)\nOption B: Patients who started the assessment (actual engagement) \nOption C: Patients who completed the assessment and are eligible for Discover\n\nOptions B or C would give you a more actionable number since they reflect real patient engagement, not just email volume.", "Supplemental notes": "1. Option B \u2013 Not Viable\nRequirement to enter Discover is based on the patient being enrolled in the program. If they don''t complete the assessment, they''re not enrolled\u2014so Option B doesn''t work.\n\n2. Option C \u2013 Preferred\nAppears to be the preferred approach, but needs final confirmation.\n\n3. New Requirement (Potential)\nIf a patient does not opt out of the invitation/reminder for their primary/entry program but doesn''t start or complete the assessment, send them a Discover reminder as well.\n\n3.a. Follow-up Question:\nWould the Discover reminder be:\nA standalone message directing them to the Discover website? OR\nA message encouraging them to enter through the assessment/appropriate channel?\n\n4. Analytics Request\nThey would like the ability to analyze by program channel.", "Discover Review": "Reviewed Option C, okay to proceed once final confirmation is received on viability. For 3a, can you clarify if through assessment/appropriate channel means that the patient would be linked to where they left off after completing their clinical program assessment (I.e., they get to the accordion to see the intro about Discover and navigate away/close the window and then receive a reminder.)"}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-A2C1AD11-004', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 4,
    'Identify recruitment volume by program', 'Program Recruitment Comparison', 'Identify recruitment volume by program', 'Medium',
    'Planned', 'Recruitment Analytics', '{"Impact": "Reveals geographic or operational biases", "Dependencies": "This is tracked under Channel Enrollment but will be essential for us to split this out as we integrate with more genomics programs (i.e., GenoRX, etc.)", "Timelines": "2026 Q1"}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-A2C1AD11-005', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 5,
    'See where users stop in the consent process', 'Consent Flow Drop-off Tracking', 'See where users stop in the consent process', 'Medium',
    'Planned', 'Recruitment Analytics', '{"Impact": "Improves UX and conversion", "Dependencies": "Needs event tracking and funnel analytics", "Timelines": "2026 Q1"}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'Agree to move forward with rejected email tracking with long-term intergration into the analytics dashboard. Advise that we integrate it as an actionable metric that project coordinators can click on to use an alternative pathway to contact the patient (e.g., email kicked back, project coordinator reviews kickbacks via analytics dashboard and can click to send SMS messages to those patients.', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 6,
    'Monitor if emails are opened or ignored', 'Email Engagement Tracking', 'Monitor if emails are opened or ignored', 'High',
    'Planned', 'Recruitment Analytics', '{"Impact": "Optimizes communication strategy", "Dependencies": "Requires integration with email platform and privacy compliance", "Timelines": "2025 Q4", "Notes": "I''d caution against using email opens as a meaningful metric. Palbox tracks opens by detecting when the email client requests images. If a patient''s email client or browser blocks images by default \u2014 which is increasingly common \u2014 they can read the entire email but it won''t register as opened. This means open rates will consistently under-report actual engagement.\nThat''s why I recommend measuring from assessment started or assessment completed \u2014 those are definitive actions we can track with confidence.", "Supplemental notes": "Email Open Tracking: Stakeholder concurs \u2014 Paubox method is unreliable. Removed from scope.\n\nNew Request \u2014 Rejected Email Tracking:\n\u2022 Short-term: Manual pull on a monthly basis, present in recurring monthly meeting\n\u2022 Long-term: Potentially integrate into the analytics dashboard\n\u2022 Dependency: Check with Brett if dashboard integration is supportable", "Discover Review": "Agree to move forward with rejected email tracking with long-term intergration into the analytics dashboard. Advise that we integrate it as an actionable metric that project coordinators can click on to use an alternative pathway to contact the patient (e.g., email kicked back, project coordinator reviews kickbacks via analytics dashboard and can click to send SMS messages to those patients."}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'Reviewed and okay to proceed with no additional notes.', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 7,
    'Monitor which users opt out of reminder emails', 'Reminder Email Opt-Out Tracking', 'Monitor which users opt out of reminder emails', 'High',
    'Planned', 'Recruitment Analytics', '{"Impact": "Ensures effective tracking should a participant want to change their mind in the future+C9I7C7", "Dependencies": "Requires tracking individual and aggregated filter options", "Timelines": "2025 Q4", "Notes": "For reminder email opt-out tracking, which scope are you looking for?\n\nOption A: Discover-specific reminder opt-outs only (patients who reached Discover and opted out of its reminders) \nOption B: All reminder opt-outs across upstream programs (Prevention4ME, Precision4ME, GenoRX) that feed into Discover\nOption C: Both \u2014 a combined view showing opt-outs at each program stage\n\nKeep in mind: With Option B or C, a patient may opt out of upstream reminders before they ever know Discover is part of the journey. Do you want visibility into that, or only patients who explicitly opted out of Discover communications?", "Supplemental notes": "Updated Requirement:\n\nReminder Email Opt-Out Tracking\n\n\u2022 Scope: Discover-specific reminders only (not upstream programs)\n\u2022 Format: Aggregated visualization (chart), not patient-level data\n\u2022 Metric: Reminders Received vs. Opted Out", "Discover Review": "Reviewed and okay to proceed with no additional notes."}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'Reviewed requirements and no further notes. Okay to move forward.', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 9,
    'Need to be able to pull list of patients who have declined to participate in the registry, consented, opted-in for future research, etc.', 'On-demand Patient Lists', 'Need to be able to pull list of patients who have declined to participate in the registry, consented, opted-in for future research, etc.', 'High',
    'Planned', 'Recruitment Analytics', '{"Impact": "Applicable for future studies that we want to identify cohorts for", "Dependencies": "Would need to include different filtering for identifying cohorts based on current metadata", "Timelines": "2025 Q4", "Notes": "Currently you can filter by patient status and download lists. Can you help me understand where the gap is?\n\nAccess Issue: Do you need someone without full system access to pull these reports?\nUsability Issue: Is the current filter/download process too cumbersome or slow?\nFormat Issue: Do you need the data in a different format or with additional fields?\nAutomation Issue: Are you looking for scheduled/automated reports instead of manual pulls?\n\nUnderstanding what''s friction today will help us scope the right solution.", "Supplemental notes": "Updated Requirement:\n\nOn-Demand Patient Lists\n\n\u2022 Status: Deferred to review session\n\u2022 Action: Add to agenda for 1:1 with Nick (next Monday)\n\u2022 Goal: Understand the gap between current filter/download capability and what they''re envisioning", "Discover Review": "Reviewed requirements and no further notes. Okay to move forward."}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-A2C1AD11-010', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 10,
    'Track amount of time spent on each consent form page', 'Time on Consent Form', 'Track amount of time spent on each consent form page', 'Medium',
    'Planned', 'Recruitment Analytics', '{"Impact": "Indicates how patients are interacting with the content of the consent form", "Dependencies": "How do we facilitate a patient''s time completing the consent and how we add it to different programs/flow/experience", "Timelines": "2026 Q1"}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-A2C1AD11-012', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 12,
    'Enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol', 'Saliva Kit Ordering', 'Enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol', 'Medium',
    'Planned', 'Operational Logistics', '{"Impact": "Reduces manual workflows and increases effiency for large-scale population sequencing across broad and program-specific recruitment pathways", "Dependencies": "Requires integration with Genotek", "Timelines": "2026 Q1"}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-A2C1AD11-013', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 13,
    'Cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways. Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists', 'MyChart Recruitment Cross Validation', 'Cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways. Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists', 'High',
    'Planned', 'Data Integrity/Recruitment Workflow', '{"Impact": "Prevents redundant consent submission, and reduces confusion for participants recruited from other recruitment pathways", "Dependencies": "Requires cross-validation logic to identify matches based on MRN, name or unique hashed identifiers", "Timelines": "2025 Q4", "Notes": "Enage with Brett on."}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-A2C1AD11-014', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 14,
    'Show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action', 'Multi-Study Dashboard', 'Show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action', 'Medium',
    'Planned', 'Participant Experience/Recruitment UX', '{"Impact": "Centralizes options, reduces navigation friction, and increases conversion by surfacing all eligible studies in one place with quick-scan information", "Dependencies": "Requires incorporation of IRB-approved study materials, appropriate navigation for entering/returning/exiting materials to ensure clear division of which study belongs to which collapsible accordion, notation of participant status (e.g., enrolled, withdrawn, not yet enrolled)", "Timelines": "2026 Q1"}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'Nick to reach out to Andrew for template. Draft language in process with Discover Team.', 'PRG-DIS-A2C1AD11', 'Propel Functionalities Request.xlsx', 16,
    'Allows for researchers to reach out to patients via SMS through the platform', 'SMS Outreach Reminders', 'Allows for researchers to reach out to patients via SMS through the platform', 'High',
    'Planned', 'Participant Experience/Recruitment UX', '{"Impact": "Increases multichannel outreach to potential participants", "Dependencies": "Should go out at the same time as email reminders", "Timelines": "2026 Q1", "Notes": "For SMS outreach reminders, here''s what we need from you:\n\nCoordinate with Andrew \u2014 he''ll work with you to gather the required campaign information for Amazon approval\nTimeline Expectation: Typically ~2 weeks for approval, but could extend if iterations are needed\nReference: Precision4ME had some friction but still resolved within 2 weeks\n\nWhat we need to kick this off: The sooner you connect with Andrew, the sooner we can submit. What''s your availability to start that conversation?", "Supplemental notes": "Updated Requirement:\n\nSMS Outreach Reminders\n\n\u2022 Stakeholder needs to provide: 2 invitation samples + 2 reminder samples\n\u2022 Andrew will send: Current SMS templates as a baseline to start from\n\u2022 Then: Submit to Amazon for campaign approval (~2 weeks)", "Discover Review": "Nick to reach out to Andrew for template. Draft language in process with Discover Team."}'::JSONB,
    'f124f937', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-8F48D903-004', 'PRG-TEST2-8F48D903', 'Propel Functionalities Request.xlsx', 4,
    'Identify recruitment volume by program', 'Program Recruitment Comparison', 'Identify recruitment volume by program', 'Medium',
    'Planned', 'Recruitment Analytics', '{"Impact": "Reveals geographic or operational biases", "Dependencies": "This is tracked under Channel Enrollment but will be essential for us to split this out as we integrate with more genomics programs (i.e., GenoRX, etc.)", "Timelines": "2026 Q1"}'::JSONB,
    '052b3981', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-8F48D903-005', 'PRG-TEST2-8F48D903', 'Propel Functionalities Request.xlsx', 5,
    'See where users stop in the consent process', 'Consent Flow Drop-off Tracking', 'See where users stop in the consent process', 'Medium',
    'Planned', 'Recruitment Analytics', '{"Impact": "Improves UX and conversion", "Dependencies": "Needs event tracking and funnel analytics", "Timelines": "2026 Q1"}'::JSONB,
    '052b3981', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-8F48D903-010', 'PRG-TEST2-8F48D903', 'Propel Functionalities Request.xlsx', 10,
    'Track amount of time spent on each consent form page', 'Time on Consent Form', 'Track amount of time spent on each consent form page', 'Medium',
    'Planned', 'Recruitment Analytics', '{"Impact": "Indicates how patients are interacting with the content of the consent form", "Dependencies": "How do we facilitate a patient''s time completing the consent and how we add it to different programs/flow/experience", "Timelines": "2026 Q1"}'::JSONB,
    '052b3981', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-8F48D903-012', 'PRG-TEST2-8F48D903', 'Propel Functionalities Request.xlsx', 12,
    'Enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol', 'Saliva Kit Ordering', 'Enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol', 'Medium',
    'Planned', 'Operational Logistics', '{"Impact": "Reduces manual workflows and increases effiency for large-scale population sequencing across broad and program-specific recruitment pathways", "Dependencies": "Requires integration with Genotek", "Timelines": "2026 Q1"}'::JSONB,
    '052b3981', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-8F48D903-013', 'PRG-TEST2-8F48D903', 'Propel Functionalities Request.xlsx', 13,
    'Cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways. Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists', 'MyChart Recruitment Cross Validation', 'Cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways. Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists', 'High',
    'Planned', 'Data Integrity/Recruitment Workflow', '{"Impact": "Prevents redundant consent submission, and reduces confusion for participants recruited from other recruitment pathways", "Dependencies": "Requires cross-validation logic to identify matches based on MRN, name or unique hashed identifiers", "Timelines": "2025 Q4", "Notes": "Enage with Brett on."}'::JSONB,
    '052b3981', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'REQ-8F48D903-014', 'PRG-TEST2-8F48D903', 'Propel Functionalities Request.xlsx', 14,
    'Show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action', 'Multi-Study Dashboard', 'Show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action', 'Medium',
    'Planned', 'Participant Experience/Recruitment UX', '{"Impact": "Centralizes options, reduces navigation friction, and increases conversion by surfacing all eligible studies in one place with quick-scan information", "Dependencies": "Requires incorporation of IRB-approved study materials, appropriate navigation for entering/returning/exiting materials to ensure clear division of which study belongs to which collapsible accordion, notation of participant status (e.g., enrolled, withdrawn, not yet enrolled)", "Timelines": "2026 Q1"}'::JSONB,
    '052b3981', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;

INSERT INTO requirements (
    requirement_id, program_id, source_file, source_row, raw_text, title, description,
    priority, source_status, requirement_type, context_json, import_batch, created_at, updated_at
) VALUES (
    'P4M-REQ-001', 'P4M-7EC35FEE', 'Teams Discussion - Exhibit E Requirements Review #4 - January 2026', NULL,
    'Enable Prevention4ME assessments to be conducted on-demand without requiring a pre-scheduled appointment or pre-loaded patient data. Supports multiple use cases including health fairs/community outreach, established patients without scheduled appointments, one-off provider-initiated sends, and non-Providence patients at partner clinics.', 'Encounterless On-Demand Assessment', 'Enable Prevention4ME assessments to be conducted on-demand without requiring a pre-scheduled appointment or pre-loaded patient data. Supports multiple use cases including health fairs/community outreach, established patients without scheduled appointments, one-off provider-initiated sends, and non-Providence patients at partner clinics.', 'High',
    NULL, 'Workflow', '{}'::JSONB,
    NULL, COALESCE('2026-01-20 10:15:46'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-20 10:15:46'::TIMESTAMPTZ, NOW())
) ON CONFLICT (requirement_id) DO NOTHING;


-- USER STORIES
INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-001', 'Reviewed Option C, okay to proceed once final confirmation is received on viability. For 3a, can you clarify if through assessment/appropriate channel means that the patient would be linked to where they left off after completing their clinical program assessment (I.e., they get to the accordion to see the intro about Discover and navigate away/close the window and then receive a reminder.)', 'PRG-DIS-A2C1AD11', NULL,
    'Number (N) Invited', 'As a research coordinator, I want to track number (N) of patients who received invitations, so that I can measure outreach effectiveness.', 'research coordinator', '', '',
    '1. Count of invited patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 1 second\n9. Visual displays Number (N) Invited with clear labels\n10. Data is segmented/filterable by channel\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 1 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Must Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:27:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-002', NULL, 'PRG-DIS-A2C1AD11', NULL,
    'Program Recruitment Comparison', 'As a research coordinator, I want to identify recruitment volume by program, so that I can reveal geographic or operational biases.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Program Recruitment Comparison with clear labels\n10. Data is segmented/filterable by channel\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Should Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 10, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:27:54'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2025-10-15'::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-003', NULL, 'PRG-DIS-A2C1AD11', NULL,
    'Consent Flow Drop-off Tracking', 'As a research coordinator, I want to see where users stop in the consent process, so that I can improve UX and conversion rates.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Consent Flow Drop-off Tracking with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Should Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:28:00'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-004', 'Agree to move forward with rejected email tracking with long-term intergration into the analytics dashboard. Advise that we integrate it as an actionable metric that project coordinators can click on to use an alternative pathway to contact the patient (e.g., email kicked back, project coordinator reviews kickbacks via analytics dashboard and can click to send SMS messages to those patients.', 'PRG-DIS-A2C1AD11', NULL,
    'Email Engagement Tracking', 'As a research coordinator, I want to monitor if emails are opened or ignored, so that I can optimize communication strategy.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Email Engagement Tracking with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Must Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:28:06'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-005', 'Reviewed and okay to proceed with no additional notes.', 'PRG-DIS-A2C1AD11', NULL,
    'Reminder Email Opt-Out Tracking', 'As a research coordinator, I want to monitor which users opt out of reminder emails, so that I can track participants who may want to change their mind in the future.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Reminder Email Opt-Out Tracking with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Must Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:28:23'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-006', 'Reviewed requirements and no further notes. Okay to move forward.', 'PRG-DIS-A2C1AD11', NULL,
    'On-demand Patient Lists', 'As a research coordinator, I want to pull lists of patients who have declined, consented, or opted-in for future research, so that I can identify cohorts for future studies.', 'research coordinator', '', '',
    '1. Count of consented patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 1 second\n9. Visual displays On-demand Patient Lists with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 1 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Must Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:28:40'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-007', NULL, 'PRG-DIS-A2C1AD11', NULL,
    'Time on Consent Form', 'As a research coordinator, I want to track amount of time spent on each consent form page, so that I can understand how patients interact with consent content.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Time on Consent Form with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Should Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:28:56'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-008', NULL, 'PRG-DIS-A2C1AD11', NULL,
    'Saliva Kit Ordering', 'As a research coordinator, I want to order saliva kits via the Propel dashboard for participants who opted-in for population sequencing, so that I can reduce manual workflows and increase efficiency for large-scale sequencing.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Saliva Kit Ordering with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Should Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:29:16'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-009', NULL, 'PRG-DIS-A2C1AD11', NULL,
    'MyChart Recruitment Cross Validation', 'As a research coordinator, I want to cross-validate MyChart participants against existing e-consent records in Propel, so that I can prevent duplicate enrollment and reduce confusion for participants from other recruitment pathways.', 'research coordinator', '', '',
    '1. Count of enrolled patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays MyChart Recruitment Cross Validation with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Must Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:29:35'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-010', NULL, 'PRG-DIS-A2C1AD11', NULL,
    'Multi-Study Dashboard', 'As a research coordinator, I want patients to see a personalized list of available studies on their dashboard, so that I can centralize options, reduce navigation friction, and increase conversion.', 'research coordinator', '', '',
    '1. Count of enrolled patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 3 seconds\n9. Visual displays Multi-Study Dashboard with clear labels\n10. Data is segmented/filterable by date range\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Should Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:29:56'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'DIS-RECRUIT-011', 'Nick to reach out to Andrew for template. Draft language in process with Discover Team.', 'PRG-DIS-A2C1AD11', NULL,
    'SMS Outreach Reminders', 'As a research coordinator, I want to reach out to patients via SMS through the platform, so that I can increase multichannel outreach to potential participants.', 'research coordinator', '', '',
    '1. Count of patients displays accurately\n2. Metrics are segmented by program/channel\n3. Funnel shows progression from invitation to enrollment\n4. Aggregated view available (not patient-level by default)\n5. Data exportable for offline analysis\n6. Historical trends visible for comparison\n7. Conversion rates calculated correctly between stages\n8. Data loads within 2 seconds\n9. Visual displays SMS Outreach Reminders with clear labels\n10. Data is segmented/filterable by channel\n11. Display updates when underlying data changes\n12. User can only view data they have permission to access\n13. Empty state shows helpful message when no data exists', '• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 2 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', 'Must Have', 'RECRUIT',
    '', TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 9, COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:30:16'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2025-12-05'::TIMESTAMPTZ,
    '2026-01-05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-001', 'Reviewed Option C, okay to proceed once final confirmation is received on viability. For 3a, can you clarify if through assessment/appropriate channel means that the patient would be linked to where they left off after completing their clinical program assessment (I.e., they get to the accordion to see the intro about Discover and navigate away/close the window and then receive a reminder.)', 'PRG-TEST2-8F48D903', NULL,
    'Number (N) Invited', 'As a research coordinator, I want to track number (N) of patients who received invitations, so that Core metric for outreach effectiveness', 'research coordinator', 'track number (N) of patients who received invitations', 'Core metric for outreach effectiveness',
    'ACCEPTANCE CRITERIA:\n• Count of invited patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 1 seconds\n• Visual displays Number (N) Invited with clear labels\n• Data is segmented/filterable by channel\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 1 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Must Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '["vague_language", "needs_clarification"]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-002', NULL, 'PRG-TEST2-8F48D903', NULL,
    'Program Recruitment Comparison', 'As a research coordinator, I want to identify recruitment volume by program, so that Reveals geographic or operational biases', 'research coordinator', 'identify recruitment volume by program', 'Reveals geographic or operational biases',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Program Recruitment Comparison with clear labels\n• Data is segmented/filterable by channel\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Should Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-003', NULL, 'PRG-TEST2-8F48D903', NULL,
    'Consent Flow Drop-off Tracking', 'As a research coordinator, I want to see where users stop in the consent process, so that Improves UX and conversion', 'research coordinator', 'see where users stop in the consent process', 'Improves UX and conversion',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Consent Flow Drop-off Tracking with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Should Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-004', 'Agree to move forward with rejected email tracking with long-term intergration into the analytics dashboard. Advise that we integrate it as an actionable metric that project coordinators can click on to use an alternative pathway to contact the patient (e.g., email kicked back, project coordinator reviews kickbacks via analytics dashboard and can click to send SMS messages to those patients.', 'PRG-TEST2-8F48D903', NULL,
    'Email Engagement Tracking', 'As a research coordinator, I want to monitor if emails are opened or ignored, so that Optimizes communication strategy', 'research coordinator', 'monitor if emails are opened or ignored', 'Optimizes communication strategy',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Email Engagement Tracking with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Must Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-005', 'Reviewed and okay to proceed with no additional notes.', 'PRG-TEST2-8F48D903', NULL,
    'Reminder Email Opt-Out Tracking', 'As a research coordinator, I want to monitor which users opt out of reminder emails, so that Ensures effective tracking should a participant want to change their mind in the future+C9I7C7', 'research coordinator', 'monitor which users opt out of reminder emails', 'Ensures effective tracking should a participant want to change their mind in the future+C9I7C7',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Reminder Email Opt-Out Tracking with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Must Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-006', 'Reviewed requirements and no further notes. Okay to move forward.', 'PRG-TEST2-8F48D903', NULL,
    'On-demand Patient Lists', 'As a research coordinator, I want to need to be able to pull list of patients who have declined to participate in the registry, consented, opted-in for future research, etc., so that Applicable for future studies that we want to identify cohorts for', 'research coordinator', 'need to be able to pull list of patients who have declined to participate in the registry, consented, opted-in for future research, etc.', 'Applicable for future studies that we want to identify cohorts for',
    'ACCEPTANCE CRITERIA:\n• Count of consented patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 1 seconds\n• Visual displays On-demand Patient Lists with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 1 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Must Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '["vague_language", "needs_clarification"]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-007', NULL, 'PRG-TEST2-8F48D903', NULL,
    'Time on Consent Form', 'As a research coordinator, I want to track amount of time spent on each consent form page, so that Indicates how patients are interacting with the content of the consent form', 'research coordinator', 'track amount of time spent on each consent form page', 'Indicates how patients are interacting with the content of the consent form',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Time on Consent Form with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Should Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-008', NULL, 'PRG-TEST2-8F48D903', NULL,
    'Saliva Kit Ordering', 'As a research coordinator, I want to enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol, so that Reduces manual workflows and increases effiency for large-scale population sequencing across broad and program-specific recruitment pathways', 'research coordinator', 'enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol', 'Reduces manual workflows and increases effiency for large-scale population sequencing across broad and program-specific recruitment pathways',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Saliva Kit Ordering with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Should Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-009', NULL, 'PRG-TEST2-8F48D903', NULL,
    'MyChart Recruitment Cross Validation', 'As a research coordinator, I want to cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways. Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists, so that Prevents redundant consent submission, and reduces confusion for participants recruited from other recruitment pathways', 'research coordinator', 'cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways. Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists', 'Prevents redundant consent submission, and reduces confusion for participants recruited from other recruitment pathways',
    'ACCEPTANCE CRITERIA:\n• Count of enrolled patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays MyChart Recruitment Cross Validation with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Must Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-010', NULL, 'PRG-TEST2-8F48D903', NULL,
    'Multi-Study Dashboard', 'As a research coordinator, I want to show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action, so that Centralizes options, reduces navigation friction, and increases conversion by surfacing all eligible studies in one place with quick-scan information', 'research coordinator', 'show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action', 'Centralizes options, reduces navigation friction, and increases conversion by surfacing all eligible studies in one place with quick-scan information',
    'ACCEPTANCE CRITERIA:\n• Count of enrolled patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 3 seconds\n• Visual displays Multi-Study Dashboard with clear labels\n• Data is segmented/filterable by date range\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 3 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Should Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'TEST2-RECRUIT-011', 'Nick to reach out to Andrew for template. Draft language in process with Discover Team.', 'PRG-TEST2-8F48D903', NULL,
    'SMS Outreach Reminders', 'As a research coordinator, I want to allows for researchers to reach out to patients via SMS through the platform, so that Increases multichannel outreach to potential participants', 'research coordinator', 'allows for researchers to reach out to patients via SMS through the platform', 'Increases multichannel outreach to potential participants',
    'ACCEPTANCE CRITERIA:\n• Count of patients patients displays accurately\n• Metrics are segmented by program/channel\n• Funnel shows progression from invitation to enrollment\n• Aggregated view available (not patient-level by default)\n• Data exportable for offline analysis\n• Historical trends visible for comparison\n• Conversion rates calculated correctly between stages\n• Data loads within 2 seconds\n• Visual displays SMS Outreach Reminders with clear labels\n• Data is segmented/filterable by channel\n• Display updates when underlying data changes\n• User can only view data they have permission to access\n• Empty state shows helpful message when no data exists\n\nSUCCESS METRICS:\n• Zero discrepancy between source consent records and dashboard\n• All consent status changes reflected within 2 minutes\n• Data refresh completes within 15 minutes of source update\n• 100% data accuracy between source and display\n• Dashboard available 99.9% of uptime\n• Page load time under 3 seconds for 95th percentile', '', 'Must Have', 'RECRUIT',
    '', TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ROLE-001', NULL, 'P4M-7EC35FEE', NULL,
    'External Contractor Role with Risk-Based Patient Filter', 'As a program administrator, I want to create an External Contractor role with restricted patient visibility, so that outside contractors can only view and work with high-risk patients while maintaining compliance requirements for non-employee access.', 'Program Administrator', NULL, NULL,
    '1. External Contractor role inherits Genetic Counselor permissions (read, write, lab ordering)\n2. External Contractor can view patient contact information\n3. External Contractor can view full clinical summary\n4. External Contractor cannot export data\n5. External Contractor can see patients where TC Score > 20\n6. External Contractor can see patients where NCCN criteria = met\n7. External Contractor can see patients where BOTH conditions are true\n8. External Contractor cannot see patients who did not complete the questionnaire\n9. External Contractor cannot see patients with TC ≤ 20 AND NCCN not met\n10. Role can be assigned to users at the clinic level (starting with Montana)\n11. Role is reusable for future external contractors', NULL, 'Must Have', 'ROLE',
    NULL, TRUE, 'Internal Review', 'Requested by: Providence Montana\nInitiating user: Michelle (external contractor)\nCompliance sponsor: Lois\n\nOpen Items:\n- TC Threshold: Is it > 20 or ≥ 20? (TBD - follow up needed)\n\nFuture Considerations (Out of Scope):\n- Organization-based filtering for joint venture clinics (Providence patients only)',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-06 13:48:14'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:49:15'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-14 12:25:59'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-DASH-001', NULL, 'P4M-7EC35FEE', NULL,
    'Dashboard Flag for Hematologic Malignancy or Bone Marrow Transplant', 'As a genetic counselor (GC), GA, or program administrator, I want the program dashboard to display a visual flag for patients who report a history of hematologic malignancy or bone marrow transplant, so that I can easily identify these patients, flag for GC review as needed, and remove appropriate patients from the standard workflow without manually reviewing each clinical summary.', 'Genetic Counselor', NULL, NULL,
    'A new column ("Hematologic/BMT Flag") is visible on the program dashboard\nColumn auto-populates with a visual indicator (e.g., ✅ or colored icon) when patient reports hematologic malignancy OR bone marrow transplant in clinical intake\nFlag is visible to GA, GC, and Program Administrator roles\nFlag is derived from patient responses in the clinical summary/medical history already captured in the system\nFlag triggers when EITHER condition is reported (hematologic malignancy OR BMT — including allogenic or other types)\nIf underlying hematologic/BMT data is updated, flag status updates accordingly\nClicking the flag or patient row opens the clinical summary for detailed review\nGA/GC determines appropriate next steps after reviewing clinical summary (some patients may continue in standard workflow, others may be removed)\nFlag does not expose type of malignancy or BMT details on the dashboard (HIPAA minimum necessary)\nDetailed clinical information only visible within the clinical summary view', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Internal Review', 'Requested by: Providence (Kim)\nClinical rationale: Type of malignancy isn''t straightforward - clinicians often need to review Epic and recent labs to determine if patient can continue in standard workflow. Simple flag is sufficient to alert staff to investigate.\n\nKim''s confirmation (email): "Option A is totally good. Just something to alert the GA/GC to look at the summary and figure it out."\n\nNice-to-Have (future consideration):\n- Tooltip showing which condition(s) apply — not needed for initial release per Kim',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 5, COALESCE('2026-01-06 17:17:33'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:14:26'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-14 13:42:57'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-CONFIG-001', NULL, 'P4M-7EC35FEE', NULL,
    'Clinical Summary Excludes Tyrer-Cuzick When Model Disabled', 'As a Prevention4ME clinic with Tyrer-Cuzick disabled, I need the clinical summary to exclude all TC score references and only display NCCN eligibility information, so that patients receive accurate, relevant documentation that reflects the risk model(s) actually used in their assessment.', 'Prevention4ME clinic', NULL, NULL,
    'When TC is disabled for a clinic, the clinical summary does not include any Tyrer-Cuzick score, lifetime risk percentage, or TC-related recommendations\nWhen TC is disabled, the clinical summary displays NCCN eligibility status and related recommendations only\nThe clinical summary generates without errors when TC is disabled', NULL, 'Must Have', 'CONFIG',
    NULL, TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 6, COALESCE('2026-01-07 12:26:19'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:24'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-15'::TIMESTAMPTZ,
    '2026-01-15 11:48:24'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ANALYTICS-001', NULL, 'P4M-7EC35FEE', NULL,
    'Analytics Dashboard TC Status Filtering with Clinic Type Indicator', 'As a Prevention4ME program administrator, I need the analytics dashboard to filter by TC-enabled vs TC-disabled clinics and clearly indicate which clinic types have TC data, so that I can accurately compare performance metrics and understand data completeness across the program.', 'Prevention4ME program administrator', NULL, NULL,
    'Dashboard includes filter/toggle to view by TC-enabled clinics, TC-disabled clinics, or all clinics\nDashboard displays footnote or indicator showing which specific clinic types do/don''t include TC data (per Kate''s Option B+C recommendation)\nKey metrics (assessment completions, high risk patients >20% TC score, NCCN eligible patients) update based on TC status filter selection\nWhen filtering to TC-disabled clinics only, TC-specific metrics (lifetime risk %, TC score) are appropriately excluded or grayed out\nClinic type filter (mammography, OBGYN, endoscopy, etc.) works in combination with TC status filter\nDashboard clearly shows percentage of TC high-risk patients by clinic/clinic type for comparison (per Kim''s request)\nFilter selections are maintained during session and can be exported with reports', NULL, 'Should Have', 'ANALYTICS',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 3, COALESCE('2026-01-07 13:33:14'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:16:19'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-AUDIT-001', NULL, 'P4M-7EC35FEE', NULL,
    'Audit Trail Requirements for Part 11 Compliance', 'As a Compliance Officer, I want all system actions to be captured in an immutable audit trail with user identification and timestamps, so that I can demonstrate regulatory compliance and investigate any access or data integrity concerns.', 'Compliance Officer', NULL, NULL,
    'All patient record views create audit entries with user ID, timestamp, and patient ID\nAll patient record edits create audit entries with user ID, timestamp, before/after values\nAll failed access attempts create audit entries with user ID, timestamp, attempted action, and denial reason\nAll role assignments/changes create audit entries with user ID, timestamp, role changed, and target user\nAll configuration changes create audit entries with user ID, timestamp, setting changed, before/after values\nAll data exports create audit entries with user ID, timestamp, export type, and parameters\nAll audit entries include computer-generated timestamp (not user-editable)\nAll audit entries include unique sequential identifier\nTimestamps use consistent timezone (UTC) with millisecond precision\nAudit records cannot be edited after creation\nAudit records cannot be deleted\nAudit table/log is protected from unauthorized access\nAudit data is backed up with same frequency as production data\nAuthorized users can query audit log by date range\nAuthorized users can query audit log by user ID\nAuthorized users can query audit log by patient ID\nAuthorized users can query audit log by action type\nAudit log can be exported for compliance reporting', NULL, 'Must Have', 'AUDIT',
    NULL, TRUE, 'Draft', 'Part 11 compliance requirement. This story captures audit trail requirements that apply across all Prevention4ME functionality. Individual feature stories should reference this for audit expectations.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 2, COALESCE('2026-01-07 15:02:50'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:18:35'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-RECORD-001', NULL, 'P4M-7EC35FEE', NULL,
    'Electronic Records Requirements for Part 11 Compliance', 'As a Compliance Officer, I want electronic records to be exportable in accurate, human-readable formats with appropriate metadata and integrity protection, so that I can provide complete records for regulatory review and ensure data integrity throughout the record lifecycle.', 'Compliance Officer', NULL, NULL,
    'Human Readable Copies:\n1. Clinical summary can be exported as human-readable PDF\n2. Clinical summary can be printed directly from the application\n3. Exported/printed clinical summary matches on-screen display\n4. Patient demographics are included in exported record\n\nExport Metadata:\n5. Exported record includes generation timestamp\n6. Exported record includes user who generated the export\n7. Exported record includes patient identifier\n8. Exported record includes system version/identifier\n\nRecord Integrity:\n9. Exported records cannot be modified after generation (PDF security)\n10. Export includes checksum or digital signature for integrity verification\n11. Export audit entry is created when record is generated\n\nRecord Protection:\n12. Exported records containing PHI are appropriately marked\n13. Export functionality is restricted to authorized roles\n14. Bulk export requires additional authorization', NULL, 'Must Have', 'RECORD',
    NULL, TRUE, 'Draft', 'Part 11 compliance requirement for electronic records. §11.10(b) requires accurate and complete copies in human-readable form.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-07 15:04:05'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-07 15:04:05'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-SAVE-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Auto-Save Progress to Browser', 'As a clinic administrator filling out the onboarding form, I want my progress to be automatically saved as I type, so that I don''t lose my work if I accidentally close the browser or need to step away.', 'Clinic Administrator', NULL, NULL,
    '1. Form data saves to localStorage automatically on every field change\n2. Current step position is saved along with form data\n3. Save timestamp is recorded\n4. Auto-save occurs without user action or clicking a button\n5. "Auto-saved at [time]" indicator displays in the save status bar\n6. Save does not interfere with form performance or cause lag', NULL, 'Could Have', 'SAVE',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:48:34'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:08:53'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:03'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-SAVE-002', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Resume Session Prompt', 'As a clinic administrator returning to the onboarding form, I want to be prompted to resume my previous session, so that I can continue where I left off without searching for my place.', 'Clinic Administrator', NULL, NULL,
    '1. When user returns to the form URL with saved data present, a modal prompt appears\n2. Modal displays the date/time of the saved draft\n3. Modal offers two clear options: "Resume Draft" and "Start Fresh"\n4. Clicking "Resume Draft" restores form data AND returns user to their last step\n5. Clicking "Start Fresh" clears saved data and starts at step 1\n6. Modal blocks interaction with the form until user makes a choice', NULL, 'Could Have', 'SAVE',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:48:41'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:09:03'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:10'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-SAVE-003', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Download Draft File', 'As a clinic administrator, I want to download my in-progress form as a file, so that I can continue on a different computer or share with a colleague to complete.', 'Clinic Administrator', NULL, NULL,
    '1. "Save Draft" button is visible in the save status bar\n2. Clicking "Save Draft" downloads a JSON file to the user''s computer\n3. File is named "propel-onboarding-draft-YYYY-MM-DD.json"\n4. Downloaded file contains all form data, current step, timestamp, and version\n5. Download works in Chrome, Firefox, Safari, and Edge\n6. Button tooltip explains: "Download your progress as a file"', NULL, 'Could Have', 'SAVE',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:48:48'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:09:13'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:16'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-SAVE-004', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Upload Draft File', 'As a clinic administrator, I want to upload a previously saved draft file, so that I can resume my progress on any computer or browser.', 'Clinic Administrator', NULL, NULL,
    '1. "Load Draft" button is visible in the save status bar\n2. Clicking "Load Draft" opens a file picker dialog\n3. Only .json files are selectable\n4. Valid draft file restores form data and navigates to saved step\n5. Invalid file shows user-friendly error message\n6. After loading, auto-save continues from the restored state\n7. Button tooltip explains: "Upload a previously saved draft"', NULL, 'Could Have', 'SAVE',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:48:54'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:09:24'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:24'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-SAVE-005', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Clear Form and Start Over', 'As a clinic administrator, I want to clear all my progress and start fresh, so that I can begin again if I made significant errors or am filling out for a different clinic.', 'Clinic Administrator', NULL, NULL,
    '1. "Start Over" button is visible in the save status bar\n2. Clicking "Start Over" shows a confirmation modal before clearing\n3. Confirmation modal warns that action cannot be undone\n4. Confirmation modal suggests using "Save Draft" first as a backup\n5. Confirming clears all form data, localStorage, and returns to step 1\n6. Canceling returns to the form with no changes', NULL, 'Could Have', 'SAVE',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:49:00'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:09:41'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:30'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-SAVE-006', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Save Options Help Text', 'As a clinic administrator, I want to understand how the different save options work, so that I can choose the right approach for my situation.', 'Clinic Administrator', NULL, NULL,
    '1. Help icon (?) button is visible in the save status bar\n2. Clicking help icon expands an informational panel\n3. Panel explains auto-save works only in same browser/device\n4. Panel explains Save Draft for cross-device access\n5. Panel explains Load Draft to restore from file\n6. Clicking help icon again collapses the panel\n7. Language is clear and non-technical for clinic staff', NULL, 'Could Have', 'SAVE',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:49:07'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:09:50'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:39'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-FORM-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Form-Driven Question Rendering', 'As a Propel administrator, I want form questions to be rendered from a JSON configuration file, so that I can add, modify, or remove questions without changing React code.', 'Propel Administrator', NULL, NULL,
    'All questions are defined in form-definition.json, not hardcoded in React\nQuestionRenderer component reads question type and renders appropriate input\nSupported types: text, textarea, select, radio, checkbox\nQuestion labels, placeholders, and help text come from configuration\nAdding a new question to JSON displays it in the form without code changes\nRemoving a question from JSON removes it from the form', NULL, 'Could Have', 'FORM',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:51:16'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:32:00'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:26'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-FORM-002', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Conditional Field Visibility', 'As a clinic administrator, I want to only see questions relevant to my selected program, so that I''m not confused by fields that don''t apply to my situation.', 'Clinic Administrator', NULL, NULL,
    'Questions support "show_when" condition in configuration\nConditions can check equality (equals), inclusion (in), and not-equals\nHidden fields do not display in the form\nHidden fields are excluded from validation\nWhen condition becomes true, field appears smoothly\nWhen condition becomes false, field hides and value is cleared\nNested conditions are supported (field depends on another conditional field)', NULL, 'Could Have', 'FORM',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:51:24'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:33:24'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:31'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-FORM-003', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Field Validation', 'As a clinic administrator, I want to see clear validation errors when I enter invalid data, so that I can correct mistakes before submitting.', 'Clinic Administrator', NULL, NULL,
    'Required fields show red asterisk (*) indicator\nRequired fields cannot be empty to proceed to next step\nEmail validation: pattern ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$\nZIP code validation: 5 digits or ZIP+4 format (^[0-9]{5}(-[0-9]{4})?$)\nPhone validation: 10-digit US format (^[0-9]{3}[-.]?[0-9]{3}[-.]?[0-9]{4}$)\nNPI validation: exactly 10 digits (^[0-9]{10}$)\nValidation errors display below the field in red text\nInvalid fields have red border highlighting\nValidation runs on blur (leaving field) and on Next click\nFirst invalid field receives focus when validation fails\nAll email inputs across all steps use email validation\nAll ZIP inputs across all steps use ZIP validation\nAll phone inputs across all steps use phone validation', NULL, 'Could Have', 'FORM',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 5, COALESCE('2026-01-08 10:51:31'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:34:16'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:36'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-FORM-004', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Repeatable Sections', 'As a clinic administrator, I want to add multiple satellite locations, test products, and providers, so that I can fully describe my clinic''s configuration.', 'Clinic Administrator', NULL, NULL,
    'Steps marked as "repeatable" show Add button\nClicking Add creates a new item with all step questions\nEach item displays with a title (e.g., "Location 1", "Location 2")\nEach item has a Remove button\nRemove button shows confirmation before deleting\nMinimum items enforced (cannot remove below min_items)\nMaximum items enforced (Add button disabled at max_items)\nItems can be added and removed without losing other form data', NULL, 'Could Have', 'FORM',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:51:39'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:35:16'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:40'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-FORM-005', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Composite Field Types', 'As a clinic administrator, I want address, contact, and stakeholder fields to be grouped logically, so that I can efficiently enter related information together.', 'Clinic Administrator', NULL, NULL,
    'Address type renders: street, city, state dropdown, ZIP code fields as a group\nContact type renders: name, title, email, phone, preferred channel, preferred time\nStakeholder type renders: name, title, email\nComposite types defined in form-definition.json under "composite_types"\nEach sub-field within composite validates independently\nComposite field values stored as nested objects in form data\nState dropdown populated from reference-data.json us_states', NULL, 'Could Have', 'FORM',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:51:46'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:36:15'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:46'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-FORM-006', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Default Plus Alternates Field Type', 'As a clinic administrator, I want to select a default option while also enabling additional alternatives, so that my clinic can have flexibility while maintaining a standard workflow.', 'Clinic Administrator', NULL, NULL,
    'Select with alternates type shows default value dropdown\nCheckbox below asks "Offer additional options to patients/staff"\nWhen checkbox checked, shows remaining options as multi-select checkboxes\nSelected default is excluded from alternate options list\nUnchecking "offer alternates" clears selected alternates\nOutput includes: default value, alternates_enabled flag, alternates array\nHelp text explains the purpose of offering alternatives', NULL, 'Could Have', 'FORM',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:51:55'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:37:21'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:51'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 1 - Program Selection', 'As a clinic administrator, I want to select which Propel Health program my clinic is enrolling in, so that the form shows only relevant questions for that program.', 'Clinic Administrator', NULL, NULL,
    'Step 1 displays three program options: P4M, PR4M, GRX\nEach option shows program name and description\nRadio button selection required before proceeding\nSelected program stored in form state\nProgram selection determines conditional fields in later steps\nChanging program selection warns if data will be lost', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:52:02'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:38:32'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:47'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-002', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 2 - Clinic Information', 'As a clinic administrator, I want to enter my clinic''s basic information, so that Propel Health can configure our account correctly.', 'Clinic Administrator', NULL, NULL,
    'Captures clinic name (required)\nCaptures Epic Department ID (optional)\nCaptures clinic address using address composite type with ZIP validation\nCaptures timezone from dropdown (required)\nCaptures hours of operation (required)\nCaptures clinic office phone number (required)\nCheckbox: "This number can be used on patient communications"\nCheckbox: "Does this clinic have a separate patient-facing helpline?"\nIf helpline checkbox checked, shows Helpline Phone Number field (required when visible)\nIf helpline checkbox checked, shows Helpline Hours of Operation field (optional)\nPhone fields validate 10-digit US format\nAll fields validate appropriately before Next', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 5, COALESCE('2026-01-08 10:52:08'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:39:56'::TIMESTAMPTZ, NOW()), '2026-01-13 14:52:56'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-003', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 3 - Satellite Locations', 'As a clinic administrator, I want to add information about additional clinic locations, so that Propel Health knows all sites where our program will operate.', 'Clinic Administrator', NULL, NULL,
    'Step displays as repeatable section (0-20 locations)\nEach location captures: name, Epic ID, address, phone, hours\n"Add Satellite Location" button creates new location\nLocations numbered sequentially (Location 1, Location 2, etc.)\nRemove button available for each location\nStep can be skipped if clinic has no satellite locations\nAt least address is required for each added location', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:52:15'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:41:31'::TIMESTAMPTZ, NOW()), '2026-01-13 14:53:04'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-004', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 4 - Contacts', 'As a clinic administrator, I want to provide contact information for key people, so that Propel Health can reach the right person for implementation and support.', 'Clinic Administrator', NULL, NULL,
    '1. Clinic Champion required: name, email, phone\n2. Genetic Counselor required: name, email, phone\n3. Primary contact required: name, title, email, phone, preferred channel, preferred time\n4. Secondary contact optional with same fields as primary\n5. IT contact optional with same fields as primary\n6. Lab contact optional with same fields as primary\n7. Email fields validate email format\n8. Phone fields accept standard formats\n9. Preferred channel options: Email, Phone, Microsoft Teams\n10. Preferred time options: Morning, Afternoon, Anytime\n11. Contact composite type used for consistent rendering across all contact fields', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:52:23'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:10:49'::TIMESTAMPTZ, NOW()), '2026-01-13 14:53:16'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-005', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 5 - Key Stakeholders', 'As a clinic administrator, I want to identify our program champion and leadership sponsors, so that Propel Health knows who is driving adoption at our clinic.', 'Clinic Administrator', NULL, NULL,
    '1. Program Champion optional: name, title, email\n2. Executive Sponsor optional: name, title, email\n3. IT Director optional: name, title, email\n4. Help text explains role of each stakeholder type\n5. Email fields validate email format\n6. Stakeholder composite type used for consistent rendering\n7. At least one stakeholder entry recommended but not required', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:52:31'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:11:12'::TIMESTAMPTZ, NOW()), '2026-01-13 14:53:24'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-006', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 6 - Lab Configuration', 'As a clinic administrator, I want to configure how genetic testing and specimen collection will work, so that Propel Health can set up the correct lab integrations.', 'Clinic Administrator', NULL, NULL,
    '1. Lab partner dropdown shows: Ambry for P4M/PR4M, Helix for GRX\n2. Default specimen type dropdown (Saliva, Blood)\n3. Checkbox: "Offer additional sample type options" - when checked, shows alternate specimen type dropdown\n4. Billing method dropdown (Bill insurance, Patient self-pay)\n5. Send kit to patient radio (Yes, No, Situation dependent)\n6. Indication dropdown shows only for P4M (Diagnostic, Prevention, etc.)\n7. Criteria for testing dropdown shows for P4M and PR4M only\n8. Conditional fields hide/show based on program selection in Step 1', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:52:39'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:11:23'::TIMESTAMPTZ, NOW()), '2026-01-13 14:53:38'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-007', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 7 - Test Products', 'As a clinic administrator, I want to select which genetic tests my clinic will offer, so that Propel Health configures the correct test ordering options.', 'Clinic Administrator', NULL, NULL,
    '1. Test panel dropdown displays Ambry Genetics test options\n2. Test options include: CustomNext-Cancer®, CancerNext-Expanded® +RNAinsight®, CancerNext-Expanded®, CancerNext-Expanded® + Limited Evidence Genes +RNAinsight®, CancerNext-Expanded® + Limited Evidence Genes\n3. Selecting a test auto-populates the test_code field (9511, 8875-R, 8875, 8875-R-LEG, 8875-LEG)\n4. Test code is read-only and displayed for reference\n5. If CustomNext-Cancer® selected, gene selector component appears (see ONB-GENE-001)\n6. Modifications/notes textarea available for customizations\n7. At least one test product required\n8. JSON output includes test_name, test_code, selected_genes (if applicable), gene_count', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-08 10:52:50'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:11:48'::TIMESTAMPTZ, NOW()), '2026-01-13 14:53:46'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-008', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 8 - Ordering Providers', 'As a clinic administrator, I want to list the healthcare providers who will order genetic tests, so that Propel Health can configure provider access and lab credentials.', 'Clinic Administrator', NULL, NULL,
    '1. Step displays as repeatable section (1-50 providers)\n2. Provider name required\n3. NPI required, validated as 10 digits\n4. Specialty dropdown optional\n5. At least one provider required\n6. "Add Provider" button creates new entry\n7. Remove button available for each provider (if more than minimum)\n8. NPI format validated before proceeding', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:00'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:12:01'::TIMESTAMPTZ, NOW()), '2026-01-13 14:54:01'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-009', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 9 - Review and Download', 'As a clinic administrator, I want to review all my answers before downloading, so that I can verify accuracy and make corrections if needed.', 'Clinic Administrator', NULL, NULL,
    '1. Displays all entered data organized by section\n2. Each section has an "Edit" button to jump back to that step\n3. Required fields that are empty highlighted as incomplete\n4. "Download JSON" button generates and downloads JSON file\n5. "Download Word Document" button generates human-readable .docx file\n6. Word document formatted for clinic records with all sections and responses\n7. Word document includes: Program, Clinic Info, Contacts, Stakeholders, Lab Config, Test Products, Ordering Providers, Extract Filtering\n8. JSON filename includes clinic and date: {clinic-name}-onboarding-YYYY-MM-DD.json\n9. Word filename includes clinic and date: {clinic-name}-onboarding-YYYY-MM-DD.docx\n10. Confirmation message shown after successful download\n11. Form can be re-downloaded multiple times', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 5, COALESCE('2026-01-08 10:53:07'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:55:09'::TIMESTAMPTZ, NOW()), '2026-01-13 14:54:10'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-EXPORT-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Generate JSON Output', 'As a Propel administrator, I want the form to generate properly structured JSON output, so that I can import it into our database using MCP tools.', 'Propel Administrator', NULL, NULL,
    '1. JSON output matches structure in src/samples/sample-p4m.json\n2. Includes schema_version field\n3. Includes submitted_at timestamp in ISO format\n4. Includes selected program\n5. All form data nested in appropriate sections (clinic_information, contacts, etc.)\n6. Repeatable items stored as arrays\n7. Empty optional fields excluded or set to null\n8. Output is valid JSON (parseable)', NULL, 'Could Have', 'EXPORT',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:14'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:07:45'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:18'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-EXPORT-002', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Schema Validation on Export', 'As a Propel administrator, I want exported JSON to be validated against our schema, so that I know the data will import correctly without errors.', 'Propel Administrator', NULL, NULL,
    '1. JSON output validated against src/data/schema.json before download\n2. Validation errors displayed to user if schema fails\n3. Schema uses JSON Schema draft-07 format\n4. Required fields enforced by schema\n5. Pattern validation (email, NPI, ZIP) enforced by schema\n6. Valid output generates without errors', NULL, 'Could Have', 'EXPORT',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:25'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:07:51'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:21'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-UI-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Progress Indicator', 'As a clinic administrator, I want to see my progress through the form, so that I know how much is left to complete.', 'Clinic Administrator', NULL, NULL,
    '1. Progress indicator shows "Step X of Y"\n2. Current step title displayed\n3. Completed steps visually distinguished (checkmark or different color)\n4. Current step highlighted\n5. Future steps shown but not clickable\n6. Progress indicator visible on all steps except review\n7. Responsive - works on mobile and desktop', NULL, 'Could Have', 'UI',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:37'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:12:50'::TIMESTAMPTZ, NOW()), '2026-01-13 14:54:38'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-UI-002', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step Navigation Buttons', 'As a clinic administrator, I want Previous and Next buttons to move between form steps, so that I can navigate the questionnaire easily.', 'Clinic Administrator', NULL, NULL,
    '1. Previous button navigates to prior step\n2. Next button validates current step then advances\n3. Previous button hidden on Step 1\n4. Next button changes to "Review" on second-to-last step\n5. Buttons disabled during navigation/validation\n6. Keyboard Enter key triggers Next\n7. Navigation preserves all entered data', NULL, 'Could Have', 'UI',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:43'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:13:29'::TIMESTAMPTZ, NOW()), '2026-01-13 14:55:01'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-UI-003', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Branding and Styling', 'As a clinic administrator, I want the form to look professional and match Propel Health branding, so that I feel confident in the organization I''m working with.', 'Clinic Administrator', NULL, NULL,
    '1. Header displays "Propel Health" with logo/text\n2. Navy (#1a365d) used for headers and primary elements\n3. Teal (#4a9aba) used for buttons and accents\n4. Clean, professional appearance\n5. Consistent styling across all steps\n6. Tailwind CSS used for styling\n7. No visual bugs or layout issues', NULL, 'Could Have', 'UI',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:13:35'::TIMESTAMPTZ, NOW()), '2026-01-13 14:55:08'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-UI-004', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Mobile Responsive Design', 'As a clinic administrator, I want to fill out the form on my phone or tablet, so that I can complete onboarding when I''m away from my desk.', 'Clinic Administrator', NULL, NULL,
    '1. Form usable on mobile devices (phones, tablets)\n2. Form fields stack vertically on small screens\n3. Buttons remain accessible and tappable\n4. Text readable without zooming\n5. No horizontal scrolling required\n6. Progress indicator adapts to mobile\n7. Tested on iOS Safari and Android Chrome', NULL, 'Could Have', 'UI',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:53:56'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:13:42'::TIMESTAMPTZ, NOW()), '2026-01-13 14:55:34'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-ADMIN-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'MCP Tool - List Form Questions', 'As a Propel administrator, I want to view all questions in the onboarding form via MCP, so that I can see the current form structure without opening JSON files.', 'Propel Administrator', NULL, NULL,
    '1. MCP tool list_form_questions(form_id) exists\n2. Returns all questions grouped by step\n3. Shows question_id, type, label, required status\n4. Shows show_when conditions if present\n5. Shows options_ref for select/radio fields\n6. Output formatted for easy reading', NULL, 'Could Have', 'ADMIN',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:54:14'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:06:59'::TIMESTAMPTZ, NOW()), '2026-01-13 14:50:56'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-ADMIN-002', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'MCP Tool - Add Form Question', 'As a Propel administrator, I want to add new questions to the onboarding form via MCP, so that I can expand the questionnaire without editing JSON manually.', 'Propel Administrator', NULL, NULL,
    '1. MCP tool add_form_question(form_id, step_id, question_def) exists\n2. Question added to specified step\n3. Question inserted at end of step by default\n4. Optional after_question parameter for placement\n5. Question definition validated before adding\n6. form-definition.json updated\n7. Audit trail recorded\n8. Returns confirmation with new question location', NULL, 'Could Have', 'ADMIN',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:54:24'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:07:06'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:00'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-ADMIN-003', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'MCP Tool - Update Form Question', 'As a Propel administrator, I want to modify existing questions in the onboarding form via MCP, so that I can refine question wording or requirements without editing JSON manually.', 'Propel Administrator', NULL, NULL,
    '1. MCP tool update_form_question(form_id, question_id, updates) exists\n2. Can update label, help_text, required, placeholder\n3. Can update validation (pattern, max_length)\n4. Can update show_when conditions\n5. Can update options_ref\n6. Only provided fields are updated (sparse update)\n7. form-definition.json updated\n8. Audit trail recorded with old and new values', NULL, 'Could Have', 'ADMIN',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:54:30'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:07:16'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:03'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-ADMIN-004', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'MCP Tool - Remove Form Question', 'As a Propel administrator, I want to remove questions from the onboarding form via MCP, so that I can simplify the questionnaire when fields are no longer needed.', 'Propel Administrator', NULL, NULL,
    '1. MCP tool remove_form_question(form_id, question_id, reason) exists\n2. Question removed from form-definition.json\n3. Reason parameter required for audit trail\n4. Full question definition captured in audit before deletion\n5. Warning if question has dependent conditions\n6. Cannot remove questions with type "title" (required)\n7. Returns confirmation with removed question summary', NULL, 'Could Have', 'ADMIN',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:54:35'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:07:25'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:10'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-ADMIN-005', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'MCP Tool - Reorder Form Questions', 'As a Propel administrator, I want to change the order of questions within a step via MCP, so that I can improve the logical flow of the questionnaire.', 'Propel Administrator', NULL, NULL,
    '1. MCP tool reorder_form_questions(form_id, step_id, question_order) exists\n2. question_order is array of question_ids in desired order\n3. All questions in step must be included\n4. form-definition.json updated with new order\n5. Audit trail recorded\n6. Returns confirmation with new question order', NULL, 'Could Have', 'ADMIN',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 10:54:41'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:07:36'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:14'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-GENE-001', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'CustomNext-Cancer Gene Selector Component', 'As a clinic administrator, I want to select specific genes for a CustomNext-Cancer panel, so that I can configure a custom genetic test with only the genes relevant to my clinic''s patient population.', 'clinic administrator', NULL, NULL,
    '1. Gene selector only appears when CustomNext-Cancer® is selected in test panel dropdown\n2. Searchable text input filters the gene list in real-time\n3. Checkbox list displays all 90 CustomNext-Cancer genes in alphabetical order\n4. Selected genes appear as removable chips/tags in a "Selected Genes" area\n5. Running count displays "X of 90 genes selected"\n6. "Select All" button selects all 90 genes\n7. "Clear All" button removes all selections\n8. Clicking X on a gene chip removes that gene from selection\n9. Gene list scrolls if too long (max-height with overflow)\n10. At least one gene must be selected when CustomNext-Cancer® is chosen\n11. Mobile responsive: gene chips wrap appropriately on small screens\n12. JSON output includes selected_genes array and gene_count', NULL, 'Could Have', 'GENE',
    NULL, TRUE, 'Approved', 'Complex UI component. 90 genes from Ambry: AIP, ALK, APC, ATM, ATRIP, AXIN2, BAP1, BARD1, BMPR1A, BRCA1, BRCA2, BRIP1, CDC73, CDH1, CDK4, CDKN1B, CDKN2A, CEBPA, CFTR, CHEK2, CPA1, CTNNA1, CTRC, DDX41, DICER1, EGFR, EGLN1, EPCAM, ETV6, FH, FLCN, GATA2, GREM1, HOXB13, KIF1B, KIT, LZTR1, MAX, MBD4, MEN1, MET, MITF, MLH1, MLH3, MSH2, MSH3, MSH6, MUTYH, NF1, NF2, NTHL1, PALB2, PALLD, PDGFRA, PHOX2B, PMS2, POLD1, POLE, POT1, PRKAR1A, PRSS1, PTCH1, PTEN, RAD51B, RAD51C, RAD51D, RB1, RET, RNF43, RPS20, RUNX1, SDHA, SDHAF2, SDHB, SDHC, SDHD, SMAD4, SMARCA4, SMARCB1, SMARCE1, SPINK1, STK11, SUFU, TERT, TMEM127, TP53, TSC1, TSC2, VHL, WT1',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-08 13:12:39'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:08:44'::TIMESTAMPTZ, NOW()), '2026-01-13 14:51:57'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'ONB-STEP-010', NULL, '9bcd1428-0bd4-487e-8b43-42563fee3b75', NULL,
    'Step 10 - Extract Filtering', 'As a clinic administrator, I want to configure how patient data is extracted from our EHR, so that only relevant patients are included in the program workflow.', 'clinic administrator', NULL, NULL,
    '1. Extract patient status dropdown (New patients only, All patients)\n2. Extract procedure type dropdown (Screening only, All procedures)\n3. Checkbox: "Filter by provider" \n4. When filter by provider checked, shows repeatable provider section (required, min 1)\n5. Provider section has First Name field (required)\n6. Provider section has Last Name field (required)\n7. "Add Provider" button to add additional providers (max 20)\n8. Remove button available for each provider (if more than 1)\n9. Provider list is mandatory when filter checkbox is checked - cannot proceed without at least one provider\n10. JSON output includes extract_filter_providers array with first_name and last_name for each', NULL, 'Could Have', 'STEP',
    NULL, TRUE, 'Approved', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-09 14:08:35'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 16:55:13'::TIMESTAMPTZ, NOW()), '2026-01-13 14:54:28'::TIMESTAMPTZ, 'MCP:update_story',
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-ANALYTICS-001', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Gene-Level Positive Variant Reporting in Analytics Dashboard', 'As a program administrator, I need to track and report on positive gene variants (BRCA1, BRCA2, PSS1, etc.) in the analytics dashboard across all programs, so that I can monitor carrier identification rates, compare performance across clinics and programs, and generate monthly reporting metrics.', 'Program Administrator', NULL, NULL,
    '1. Dashboard displays count of patients with each positive gene variant (BRCA1, BRCA2, PSS1, etc.) across all tested patients\n2. Dashboard displays percentage of tested patients with each positive variant (e.g., "3% of tested patients have BRCA1 variant")\n3. Dashboard supports date/month filter to view carrier counts for a specific time period (for monthly reporting, not trending charts)\n4. Dashboard displays total positive variant counts per month (aggregate, not broken down by individual gene per month)\n5. Dashboard displays breakdown of positive variants by clinic (e.g., "Clinic A: 5 BRCA1, Clinic B: 10 BRCA1")\n6. Dashboard displays breakdown of positive variants by program (e.g., "Prevention4ME: 8 BRCA1, Precision4ME: 12 BRCA1")\n7. Data source integrates positive variant results from lab via Redox (Ambry currently, Helix future)\n8. Metrics update in near real-time as new lab results are received', NULL, 'Should Have', 'ANALYTICS',
    NULL, TRUE, 'Internal Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 2, COALESCE('2026-01-13 12:56:40'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 13:41:26'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-14 13:41:26'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-DASH-002', NULL, 'P4M-7EC35FEE', NULL,
    'Clinician Dashboard Displays Both Standard and CM-Adjusted TC Scores', 'As a genetic counselor at a CM-enabled clinic, I need to see both the standard Tyrer-Cuzick score and the Competing Mortality-adjusted TC score on the patient dashboard, so that I can understand both risk calculations and help patients make informed decisions.', 'Genetic Counselor', NULL, NULL,
    'When Competing Mortality (CM) is enabled for a clinic, the clinician dashboard displays BOTH the standard TC score AND the CM-adjusted TC score for each patient\nBoth scores are clearly labeled to distinguish standard TC from CM-adjusted TC\nWhen CM is disabled for a clinic, only the standard TC score is displayed (no CM-adjusted score)\nWhen a GC modifies patient assessment responses and triggers recalculation, the system calculates and displays BOTH the standard TC score and the CM-adjusted TC score\nHigh-risk threshold indicator (>20%) applies to the clinic''s configured default score (CM-adjusted if enabled, standard if not)\nScore display updates in real-time as patient data changes', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 5, COALESCE('2026-01-13 13:00:36'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:37'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-15'::TIMESTAMPTZ,
    '2026-01-15 11:48:37'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-CONFIG-002', NULL, 'P4M-7EC35FEE', NULL,
    'Clinical Summary Displays CM-Adjusted TC Score with Updated Messaging', 'As a patient at a CM-enabled clinic, I need my clinical summary to show my Competing Mortality-adjusted Tyrer-Cuzick score with clear messaging that CM is incorporated, so that I receive accurate risk information without confusion from multiple scores.', 'Patient', NULL, NULL,
    'When CM is enabled for a clinic, the clinical summary displays ONLY the CM-adjusted TC score (not both scores)\nClinical summary messaging indicates "Competing Mortality is incorporated into the TC score" when CM is enabled\nWhen CM is disabled, the clinical summary displays the standard TC score with standard messaging\nThe clinical summary does NOT show both scores to avoid patient confusion\nScore presentation follows existing clinical summary formatting standards\nA note or indicator is stored in the patient record indicating whether CM was used in the calculation', NULL, 'Must Have', 'CONFIG',
    NULL, TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 5, COALESCE('2026-01-13 13:00:45'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:28'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-15'::TIMESTAMPTZ,
    '2026-01-15 11:48:28'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ANALYTICS-002', NULL, 'P4M-7EC35FEE', NULL,
    'Analytics Dashboard Shows TC High-Risk Counts With and Without CM', 'As a program administrator, I need the analytics dashboard to show high-risk patient counts (TC >20%) calculated BOTH with and without Competing Mortality for all clinics, so that I can understand the impact of CM on risk categorization and help sites evaluate their CM configuration decisions.', 'Program Administrator', NULL, NULL,
    'Analytics dashboard displays TC >20% count WITH CM applied (background calculated for all clinics, regardless of clinic CM setting)\nAnalytics dashboard displays TC >20% count WITHOUT CM applied (standard TC, background calculated for all clinics)\nBoth metrics are shown simultaneously to allow comparison of CM impact on high-risk categorization\nFilter/toggle allows viewing "clinics with CM on" versus "clinics with CM off" based on their configuration\nMaster list or indicator shows which clinics have CM enabled vs disabled for reference\nEach site can see both CM on/off analytics to understand the CM decision and its impact\nTotal program analytics shows aggregate on/off metrics across all sites', NULL, 'Must Have', 'ANALYTICS',
    NULL, TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 4, COALESCE('2026-01-13 13:00:56'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:43'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-15'::TIMESTAMPTZ,
    '2026-01-15 11:48:43'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-CONFIG-003', NULL, 'P4M-7EC35FEE', NULL,
    'Clinic-Level Competing Mortality Toggle Configuration', 'As a program administrator, I need Competing Mortality (CM) to be configurable at the clinic level through dev team requests, so that each clinic can choose whether to incorporate age-based competing mortality into their Tyrer-Cuzick risk calculations.', 'Program Administrator', NULL, NULL,
    'Competing Mortality (CM) is controlled at the clinic level - each clinic either has CM enabled or disabled\nCM toggle is managed by dev team via submitted requests (Option B control model, same as TC toggle)\nCM configuration becomes part of the centralized configuration list maintained per site\nWhen CM is enabled for a clinic, CM-adjusted TC becomes the default score for that clinic\nCM toggle is independent from TC toggle - a clinic can have TC enabled with or without CM\nConfiguration change creates audit entry documenting who requested, when changed, and previous state\nConfiguration is stored and retrievable for reporting on which clinics use CM', NULL, 'Must Have', 'CONFIG',
    NULL, TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 5, COALESCE('2026-01-13 13:01:06'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:33'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-15'::TIMESTAMPTZ,
    '2026-01-15 11:48:33'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-DASH-001', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Download and Print Patient Artifacts from Dashboard', 'As a genetic counselor, I need to download and print patient artifacts (consent forms, assessment forms, clinical summaries) directly from the dashboard, including the ability to select multiple patients for bulk download, so that I can efficiently prepare documentation for patient visits and records.', 'Genetic Counselor', NULL, NULL,
    '1. From the patient dashboard, GC can select a patient and view available artifacts (consent form, assessment form, clinical summary, etc.)\n2. GC can download individual artifacts as PDF for the selected patient\n3. GC can print individual artifacts directly from the dashboard without downloading first\n4. GC can select multiple patients from the dashboard using checkboxes or multi-select\n5. GC can bulk download artifacts for multiple selected patients in a single action (e.g., ZIP file or combined PDF)\n6. Downloaded/printed artifacts include patient identification and generation timestamp\n7. Artifact download/print creates audit entry documenting who accessed which patient documents and when', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Pending Client Review', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 4, COALESCE('2026-01-13 13:11:00'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:47'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, '2026-01-15'::TIMESTAMPTZ,
    '2026-01-15 11:48:47'::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-REFERRAL-001', NULL, 'P4M-7EC35FEE', NULL,
    'Manual Referral Entry & Patient Invitation', 'As a user (provider, genetic assistant, or referral coordinator), I want to manually create a referred patient record in the provider portal and send an invitation so the patient can complete risk assessments to determine referral eligibility.', 'User', NULL, NULL,
    '1. User can search EHR via live FHIR for patient; if match found, demographics auto-populate\n2. If no FHIR data, required fallback fields are: Name, DOB, Email, and Referring Provider\n3. User enters referring provider details during referral creation\n4. System sends "Referral Assessment Invitation" email using distinct template with referral-specific branding and language (e.g., "XXX referred you to the YYY program. Please complete this assessment...")\n5. Referring provider details are included in the patient invitation to build trust\n6. Referring provider is NOT automatically notified; notification occurs manually after genetics staff reviews and decides on referral\n7. System logs audit trail: user ID, referral form inputs, invitation timestamp (Part 11 compliant)', NULL, 'Must Have', 'REFERRAL',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-13 13:30:16'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-13 13:30:16'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-REFERRAL-002', NULL, 'P4M-7EC35FEE', NULL,
    'Referral-Limited Assessment Flow', 'As a referred patient, I want to complete only the TC and NCCN assessments, view my risk results, and download the clinical summary—without being asked for e-consent unless a provider decides to proceed with scheduling.', 'Referred Patient', NULL, NULL,
    '1. Patient is routed directly to TC → NCCN assessments; no genetic-testing consent or care-plan steps presented\n2. Patient can view risk results after completing assessments\n3. Patient can download Clinical Summary as PDF\n4. Provider sees same Clinical Summary document in referral dashboard\n5. If referral is accepted and appointment scheduled, patient follows Returning Patient experience then routes to Education + e-Consent\n6. Assessments capture full audit data (inputs, version, outputs) per Part 11 requirements', NULL, 'Must Have', 'REFERRAL',
    NULL, TRUE, 'Draft', 'Constraint: No Epic write-back in MVP (see P4M-REFERRAL-004 for future capability)',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-13 13:30:22'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-13 13:30:22'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-REFERRAL-003', NULL, 'P4M-7EC35FEE', NULL,
    'Referral Dashboard Tab & Notifications', 'As a user with Genetic Counselor or Genetic Assistant role, I want a dedicated dashboard tab listing only referral patients with alerts when new results arrive, so I can prioritize them over routine scheduled cases.', 'User', NULL, NULL,
    '1. Dashboard displays two tabs: "Scheduled Patients" and "Referral Patients"\n2. Referral Patients tab displays same columns as current provider dashboard\n3. When a referral patient completes assessment, system displays red badge on Referral tab\n4. User can opt-in to email alerts for new referral completions (per-user setting)\n5. User can filter referral patients by elevated TC or NCCN eligibility status\n6. User can sort referral list to triage highest-risk patients first\n7. Badge resets when user views the patient record\n8. Only users with Genetic Counselor or Genetic Assistant roles can see Referral tab', NULL, 'Must Have', 'REFERRAL',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-13 13:30:28'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-13 13:30:28'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-REFERRAL-004', NULL, 'P4M-7EC35FEE', NULL,
    'Epic Write-Back for Referral Assessment Results', 'As a provider, I want referral assessment results written back to Epic so that the patient''s EHR reflects their TC score, NCCN eligibility, and referral outcome without manual data entry.', 'Provider', NULL, NULL,
    '1. System writes TC score and risk category to Epic patient record\n2. System writes NCCN eligibility status to Epic\n3. System writes referral decision (accepted/declined) and reason to Epic\n4. Write-back includes timestamp and source system identifier\n5. Write-back creates audit entry documenting data sent, destination, and confirmation (Part 11)', NULL, 'Could Have', 'REFERRAL',
    NULL, TRUE, 'Draft', 'Constraints: Requires Epic integration buildout beyond MVP scope. Dependent on clinic''s Epic configuration and approval.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-13 13:30:35'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-13 13:30:35'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-RPT-001', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Generate UAT Sign-Off Package', 'As a Program Manager, I want to generate a formal UAT sign-off document that rolls up user stories, test case results, and compliance information, so that clients can review and formally accept the validated functionality.', 'Program Manager', NULL, NULL,
    '1. Tool accepts UAT cycle ID and client information (name, title)\n2. Document includes cover page with program name, cycle name, date range, and prepared by/for\n3. Executive summary shows total stories tested, test case pass/fail/blocked counts, overall pass rate, and Go/No-Go recommendation\n4. Each user story has its own sign-off section with: story ID, title, full user story text, acceptance criteria, linked test cases with execution results (Pass/Fail/Blocked), and initial/date/notes line for client sign-off\n5. Appendix A contains defect log with defect ID, description, linked test case, resolution status, and dev notes\n6. Appendix B contains compliance matrix showing Part11/HIPAA/SOC2 tagged test cases and their results\n7. Final page includes full signature block for overall UAT acceptance\n8. Output format supports Word (.docx) and PDF\n9. Document saves to specified output directory (default: ~/Downloads)', NULL, 'Should Have', 'RPT',
    NULL, TRUE, 'Draft', 'Timing: Build after ONB UAT completion, before NCCN UAT. Tool name: generate_uat_signoff_package. Lives in propel-health MCP alongside other export/report tools.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-13 15:10:24'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 12:25:54'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-GAIL-001', NULL, 'P4M-7EC35FEE', NULL,
    'Clinic-Level GAIL Model Toggle Configuration', 'As a program administrator, I need to enable or disable the GAIL risk model at the clinic level, so that each clinic can choose whether to include GAIL-based risk calculations in their patient assessments.', 'program administrator', NULL, NULL,
    '1. GAIL model can be enabled or disabled per clinic through configuration\n2. GAIL toggle is independent of Tyrer-Cuzick toggle (clinics can run TC only, GAIL only, both, or neither)\n3. GAIL configuration changes take effect for new assessments only (existing assessments retain their original calculation)\n4. Default state for new clinics is GAIL disabled\n5. Configuration change is logged with who changed it, when, and the before/after values', NULL, 'Should Have', 'GAIL',
    NULL, TRUE, 'Draft', 'Pending Kim''s input from Jan 28 community sync. Key question: Should GAIL and TC be toggleable independently or as a single risk model toggle?',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:18:07'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:18:07'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:18:07'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-GAIL-002', NULL, 'P4M-7EC35FEE', NULL,
    'Clinical Summary Displays GAIL Risk Score When Enabled', 'As a genetic counselor at a GAIL-enabled clinic, I need the clinical summary to include the patient''s GAIL risk score, so that I can discuss their 5-year breast cancer risk based on this model during counseling sessions.', 'genetic counselor at a GAIL-enabled clinic', NULL, NULL,
    '1. When GAIL is enabled for a clinic, the clinical summary includes the GAIL 5-year risk score\n2. GAIL score is clearly labeled to distinguish it from Tyrer-Cuzick lifetime risk score\n3. When GAIL is disabled, no GAIL-related content appears in the clinical summary\n4. If both GAIL and TC are enabled, clinical summary displays both scores in clearly labeled sections\n5. GAIL-specific recommendations (if any) are included when GAIL is enabled\n6. Clinical summary generates without errors regardless of GAIL enable/disable state', NULL, 'Should Have', 'GAIL',
    NULL, TRUE, 'Draft', 'Need to confirm with clinical team: What GAIL-specific recommendations or thresholds should be displayed? Is there a high-risk threshold for GAIL like the 20% for TC?',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:18:17'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:18:17'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:18:17'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-GAIL-003', NULL, 'P4M-7EC35FEE', NULL,
    'Clinician Dashboard Displays GAIL Risk Score', 'As a genetic counselor at a GAIL-enabled clinic, I need to see the GAIL risk score on the patient dashboard, so that I can quickly identify patients'' 5-year risk levels without opening each clinical summary.', 'genetic counselor at a GAIL-enabled clinic', NULL, NULL,
    '1. When GAIL is enabled for a clinic, the clinician dashboard displays the GAIL 5-year risk score for each patient\n2. GAIL score column is clearly labeled and distinguished from TC score column\n3. When GAIL is disabled, the GAIL score column is hidden from the dashboard\n4. If both GAIL and TC are enabled, both scores are visible on the dashboard\n5. High-risk indicator applies based on GAIL threshold (to be defined by clinical team)\n6. Score display updates as patient data changes', NULL, 'Should Have', 'GAIL',
    NULL, TRUE, 'Draft', 'Need clinical input: What is the high-risk threshold for GAIL? Is it the same 20% as TC or different?',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:18:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:18:42'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:18:42'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-GAIL-004', NULL, 'P4M-7EC35FEE', NULL,
    'Patient Assessment Captures GAIL Model Inputs', 'As a patient completing my risk assessment at a GAIL-enabled clinic, I need the assessment to collect the information required for GAIL risk calculation, so that my 5-year breast cancer risk can be accurately calculated using this model.', 'patient completing my risk assessment at a GAIL-enabled clinic', NULL, NULL,
    '1. When GAIL is enabled, the patient assessment collects all required GAIL model inputs: age, age at menarche, age at first live birth, number of first-degree relatives with breast cancer, number of previous breast biopsies, and presence of atypical hyperplasia\n2. GAIL-specific questions are clearly presented and validated for required formats\n3. When GAIL is disabled, GAIL-specific questions that are not shared with other models are hidden from the assessment\n4. If patient skips optional GAIL questions, system handles gracefully (uses defaults or indicates score cannot be calculated)\n5. GAIL calculation executes upon assessment completion when GAIL is enabled\n6. GAIL score is stored with the assessment record for audit trail', NULL, 'Should Have', 'GAIL',
    NULL, TRUE, 'Draft', 'GAIL model inputs: Current age, age at menarche, age at first live birth (nulliparous = 0), number of 1st degree relatives with breast cancer, number of previous biopsies, atypical hyperplasia. Some inputs may overlap with TC assessment questions.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:18:56'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:18:56'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:18:56'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-GAIL-005', NULL, 'P4M-7EC35FEE', NULL,
    'Analytics Dashboard GAIL Status Filtering', 'As a program administrator, I need to filter the analytics dashboard by GAIL-enabled clinics, so that I can compare risk assessment outcomes between clinics using GAIL and those not using GAIL.', 'program administrator', NULL, NULL,
    '1. Analytics dashboard can filter by GAIL-enabled vs GAIL-disabled clinics\n2. When filtering by GAIL-enabled clinics, GAIL high-risk patient counts are displayed\n3. Analytics can compare GAIL high-risk rates across clinics\n4. Data availability footnotes indicate when GAIL data is not available for certain clinics\n5. Combined filtering supported: GAIL status + TC status + clinic type\n6. Export functionality includes GAIL metrics when applicable', NULL, 'Could Have', 'GAIL',
    NULL, TRUE, 'Draft', 'Similar pattern to P4M-ANALYTICS-001 and P4M-ANALYTICS-002 for TC. Allows program administrators to see GAIL adoption and outcomes across clinics.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:19:05'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:19:05'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:19:05'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-PEDIGREE-001', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Auto-Generate Pedigree from Patient Assessment Data', 'As a genetic counselor, I need the system to automatically generate a pedigree diagram from the patient''s family history responses, so that I can quickly visualize their hereditary cancer risk without manually creating the pedigree.', 'genetic counselor', NULL, NULL,
    '1. System automatically generates a pedigree diagram from patient family history responses collected during assessment\n2. Pedigree includes: patient (proband), parents, siblings, children, grandparents, aunts/uncles, and first cousins as reported\n3. Cancer diagnoses are represented with standard pedigree symbols (filled shapes for affected individuals)\n4. Age at diagnosis and cancer type are displayed for affected family members\n5. Deceased family members are indicated with standard notation\n6. Pedigree updates automatically if patient modifies family history responses\n7. Generation works for both Prevention4ME and Precision4ME assessments', NULL, 'Should Have', 'PEDIGREE',
    NULL, TRUE, 'Draft', 'Existing Node.js work in progress. Pedigree data comes from patient assessment family history questions. Standard pedigree notation: squares=male, circles=female, filled=affected, diagonal line=deceased.\n\n[2026-01-14 15:38:46]\nCURRENT STATE: Basic pedigree generation from patient responses already works - can generate standard pedigree with appropriate linkages. This story formalizes that existing capability. Node.js implementation exists. OPEN QUESTION: Standard file format for export TBD - needs team input (PED, BOADICEA, HL7 FHIR?). Platform feature affecting P4M and Precision4ME simultaneously.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 2, COALESCE('2026-01-14 15:36:14'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:38:46'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:36:14'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-PEDIGREE-002', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Interactive Pedigree Editor for Genetic Counselors', 'As a genetic counselor, I need to view and manipulate the pedigree diagram interactively, so that I can add missing family members, correct errors, and refine the family history during the counseling session.', 'genetic counselor', NULL, NULL,
    '1. Pedigree displays as an interactive visual diagram on screen\n2. GC can add family members not captured in patient assessment\n3. GC can edit existing family member details (cancer type, age at diagnosis, current age, deceased status)\n4. GC can remove incorrectly added family members\n5. GC can reposition/rearrange family members for visual clarity\n6. Changes made by GC are saved and attributed to the GC in audit trail\n7. Original patient-reported data is preserved separately from GC modifications\n8. Undo/redo functionality for editing actions', NULL, 'Should Have', 'PEDIGREE',
    NULL, TRUE, 'Draft', 'Node.js implementation in progress. GC edits should be tracked separately from patient-reported data for audit purposes. Consider using a canvas or SVG-based editor.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:36:23'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:36:23'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:36:23'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-PEDIGREE-003', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Patient-Friendly Pedigree View in Clinical Summary', 'As a patient, I need to see a simplified, easy-to-understand version of my family history diagram in my clinical summary, so that I can understand my family cancer history without needing to interpret clinical pedigree notation.', 'patient', NULL, NULL,
    '1. Patient-friendly pedigree uses simplified, non-clinical visual representation\n2. Patient-friendly version excludes detailed clinical notation that may confuse patients\n3. Patient-friendly pedigree is included in the clinical summary document\n4. Legend or key explains what the symbols mean in plain language\n5. Patient can view their family history representation in patient-facing materials\n6. Patient-friendly version reflects same data as clinical pedigree (but presented differently)', NULL, 'Should Have', 'PEDIGREE',
    NULL, TRUE, 'Draft', 'Patient version should be easy to understand without medical training. Consider using color-coding or simple icons instead of standard pedigree notation. Must sync with clinical pedigree data.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:36:32'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:36:32'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:36:32'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-PEDIGREE-004', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Pedigree Download, Print, and Export', 'As a genetic counselor, I need to download, print, and export the pedigree in standard formats, so that I can include it in patient records, share with other providers, or use with genetic analysis tools.', 'genetic counselor', NULL, NULL,
    '1. GC can download pedigree as a printable PDF document\n2. GC can print pedigree directly from the application\n3. PDF includes patient identifier, date generated, and legend\n4. GC can export pedigree in standard file format (PED or compatible format for genetic analysis tools)\n5. Export includes all family member data in structured format\n6. Downloaded/exported files are logged in audit trail (who, when, which patient)', NULL, 'Should Have', 'PEDIGREE',
    NULL, TRUE, 'Draft', 'Standard pedigree file formats: PED (PLINK), BOADICEA format, HL7 FHIR FamilyMemberHistory. Need to confirm which format(s) are needed for interoperability with other genetic tools.\n\n[2026-01-14 15:38:52]\nOPEN QUESTION: Standard file format for export TBD - needs team input. Options: PED (PLINK), BOADICEA format, HL7 FHIR FamilyMemberHistory. Need to determine which format(s) are needed for interoperability with other genetic tools. Platform feature affecting P4M and Precision4ME simultaneously.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 2, COALESCE('2026-01-14 15:36:42'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:38:52'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:36:42'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PLAT-PEDIGREE-005', NULL, '215befe9-f8f7-4371-9df4-ff7afe18af84', NULL,
    'Access Pedigree from Clinician Dashboard', 'As a genetic counselor, I need to access the patient''s pedigree directly from the clinician dashboard, so that I can quickly review family history without navigating away from my workflow.', 'genetic counselor', NULL, NULL,
    '1. Pedigree is accessible from the patient record on the clinician dashboard\n2. GC can open pedigree view with one click from patient row\n3. Pedigree indicator shows on dashboard if family history data exists for patient\n4. Pedigree view opens in a modal or dedicated panel without leaving the dashboard\n5. GC can navigate between pedigree, clinical summary, and other patient artifacts seamlessly', NULL, 'Should Have', 'PEDIGREE',
    NULL, TRUE, 'Draft', 'Integration point with existing dashboard. Consider where the pedigree icon/link appears in the patient row. May need a family history indicator column.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:36:52'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:36:52'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:36:52'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-EPIC-001', NULL, 'P4M-7EC35FEE', NULL,
    'Epic Write-Back for Non-Mammography Providers', 'As a non-mammography provider (primary care, OBGYN, endoscopy, or high-risk genetics clinic), I need my patient''s assessment results written back to Epic outside of the Radiant module, so that I can access and review the results in my standard workflow without needing mammography system access.', 'non-mammography provider (primary care', NULL, NULL,
    '1. Assessment results can be written back to Epic outside of the Radiant mammography module\n2. Results are stored in a location accessible to non-mammography providers (primary care, OBGYN, endoscopy, high-risk genetics)\n3. Clinical summary document is attached or linked in the Epic record\n4. Write-back includes: risk scores, NCCN eligibility status, genetic testing recommendations\n5. Provider who ordered the assessment can view results in their standard Epic workflow\n6. Write-back is logged with timestamp and destination for audit trail', NULL, 'Should Have', 'EPIC',
    NULL, TRUE, 'Draft', 'PENDING PROVIDENCE INPUT. Use case: A general practitioner or non-mammography provider orders an assessment. Results need to be stored somewhere they can access - NOT in the Radiant mammography module they don''t have access to. Need to determine: What Epic module/location? What format? What triggers the write-back?',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:43:26'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:43:26'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:43:26'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-LANG-001', NULL, 'P4M-7EC35FEE', NULL,
    'Patient Language Selection', 'As a patient, I need to select my preferred language when starting my assessment, so that I can complete the assessment in a language I understand.', 'patient', NULL, NULL,
    '1. Patient can select their preferred language at the start of assessment\n2. Language selection is saved to patient profile for future sessions\n3. System supports a configurable list of available languages per program\n4. Language preference can be changed mid-assessment if needed\n5. Default language can be configured at the clinic level\n6. Language selection is logged for analytics and audit purposes', NULL, 'Should Have', 'LANG',
    NULL, TRUE, 'Draft', '2026 contractual requirement. FIRST LANGUAGE: Spanish. Translation validation vendor: Dynamic Language. Foundation story - language selection must work before translation can be implemented.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:51:20'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:51:20'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:51:20'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-LANG-002', NULL, 'P4M-7EC35FEE', NULL,
    'Assessment Questions in Multiple Languages', 'As a patient who selected a non-English language, I need all assessment questions and answer options displayed in my selected language, so that I can accurately understand and respond to each question.', 'patient who selected a non-English language', NULL, NULL,
    '1. All assessment questions display in the patient''s selected language\n2. Answer options and help text are translated\n3. Medical terminology is accurately translated with clinical review\n4. Translations are stored in a maintainable format (not hardcoded)\n5. Missing translations fall back to English with indicator\n6. Translation updates can be deployed without code changes', NULL, 'Should Have', 'LANG',
    NULL, TRUE, 'Draft', 'Critical for patient comprehension. TRANSLATION VENDOR: Dynamic Language - will validate medical terminology translations. Spanish first. Translations stored in maintainable format (not hardcoded).',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:51:29'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:51:29'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:51:29'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-LANG-003', NULL, 'P4M-7EC35FEE', NULL,
    'Patient-Facing UI in Multiple Languages', 'As a patient who selected a non-English language, I need all buttons, navigation, and interface elements displayed in my selected language, so that I can navigate the application without language barriers.', 'patient who selected a non-English language', NULL, NULL,
    '1. Patient-facing UI elements (buttons, navigation, labels) display in selected language\n2. Error messages and validation text are translated\n3. Progress indicators and instructions are translated\n4. UI layout accommodates text expansion for longer translations\n5. Consistent terminology across all UI elements', NULL, 'Should Have', 'LANG',
    NULL, TRUE, 'Draft', 'UI chrome translation - separate from assessment content. Some languages (German, Spanish) have longer text than English - UI must accommodate without breaking layout.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:51:37'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:51:37'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:51:37'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-LANG-004', NULL, 'P4M-7EC35FEE', NULL,
    'Clinical Summary in Multiple Languages', 'As a patient who selected a non-English language, I need my clinical summary document generated in my selected language, so that I can understand my results and recommendations when I take it home.', 'patient who selected a non-English language', NULL, NULL,
    '1. Clinical summary document is generated in the patient''s selected language\n2. Risk scores, recommendations, and next steps are translated\n3. Medical terminology is accurately translated with clinical validation\n4. GC can generate clinical summary in English regardless of patient''s language selection (for their records)\n5. Language used for clinical summary is indicated on the document\n6. PDF generation works correctly with translated content', NULL, 'Should Have', 'LANG',
    NULL, TRUE, 'Draft', 'Patient takes clinical summary home - must be in their language. TRANSLATION VENDOR: Dynamic Language for clinical validation. Spanish first. GC may need English version for their documentation.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:51:46'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:51:46'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:51:46'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-LANG-005', NULL, 'P4M-7EC35FEE', NULL,
    'Non-Western Language Support (Character Sets and Rendering)', 'As a patient who speaks a non-western language (Chinese, Vietnamese, Korean, Arabic, etc.), I need the system to correctly display and generate documents in my language''s character set, so that I can read and understand all content without character corruption or display issues.', 'patient who speaks a non-western language (Chinese', NULL, NULL,
    '1. System supports non-Latin character sets (Chinese, Japanese, Korean, Vietnamese, Arabic, etc.)\n2. Fonts render correctly for all supported non-western languages\n3. Right-to-left (RTL) languages display correctly if supported (Arabic, Hebrew)\n4. PDF generation handles non-western characters without corruption\n5. Database stores non-western characters correctly (UTF-8 encoding)\n6. Search and filtering work correctly with non-western text input', NULL, 'Should Have', 'LANG',
    NULL, TRUE, 'Draft', 'Exhibit E specifically called out non-western languages. Technical considerations: UTF-8 encoding throughout, font support, RTL layout support, PDF library compatibility with CJK characters. May need specific fonts embedded in PDFs.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:51:57'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:51:57'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:51:57'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-LANG-006', NULL, 'P4M-7EC35FEE', NULL,
    'Translation Management and Administration', 'As a program administrator, I need to manage and track translations across languages, so that I can ensure complete language coverage and maintain translations over time as content changes.', 'program administrator', NULL, NULL,
    '1. Program administrator can view translation coverage by language (% complete)\n2. Missing translations are identifiable by language and content area\n3. New languages can be added to the system without code deployment\n4. Translation files can be exported for external translation services\n5. Translated content can be imported and validated\n6. Translation changes are logged in audit trail with who/when/what', NULL, 'Should Have', 'LANG',
    NULL, TRUE, 'Draft', 'Administrative capability for managing translations. TRANSLATION VENDOR: Dynamic Language for clinical validation. Spanish first, then expand. Export/import workflow should accommodate Dynamic Language''s process.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    NULL, 1, COALESCE('2026-01-14 15:52:07'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-14 15:52:07'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-14 15:52:07'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-001', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-007 Prostate Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-PROS-007 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-01 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:27:46'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.426922'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-002', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-008 Breast Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-BRCA-008 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-02 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:27:51'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.430263'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-003', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-009 Prostate Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-PROS-009 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-03 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:27:56'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.430398'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-004', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-010 Breast Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-BRCA-010 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-04 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:00'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.430562'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-005', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-OVAR-011 Ovarian Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-OVAR-011 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-05 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:08'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.430682'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-006', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-012 Breast Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-BRCA-012 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-06 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:13'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431101'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-007', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-013 Breast Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-BRCA-013 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-07 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:18'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431236'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-008', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-MULT-034 Multiple Cancer Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-MULT-034 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-08 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:23'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431369'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-009', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-LYNX-036 Lynch Syndrome Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-LYNX-036 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-09 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:27'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431522'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-010', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-LYNX-037 Lynch Syndrome Rule Modified', 'As a clinical team member, I want to validate that the modified rule NCCN-LYNX-037 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-10 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:32'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431748'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-011', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-040 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-040 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-12 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:38'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431867'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-012', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-041 Breast Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-BRCA-041 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-13 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:43'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.431984'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-013', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-042 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-042 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-14 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:49'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432100'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-014', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-043 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-043 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-15 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:28:56'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432220'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-015', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-044 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-044 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-16 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:02'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432354'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-016', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-045 Breast Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-BRCA-045 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-17 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:07'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432483'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-017', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-046 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-046 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-18 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:16'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432610'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-018', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-047 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-047 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-19 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:23'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432739'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-019', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-BRCA-048 Breast Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-BRCA-048 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-20 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:30'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.432884'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-020', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-OVAR-049 Ovarian Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-OVAR-049 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-21 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:40'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433012'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-021', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-050 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-050 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-22 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:47'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433143'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-022', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-PROS-051 Prostate Rule Deprecated', 'As a clinical team member, I want to validate that the deprecated rule NCCN-PROS-051 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-23 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:29:56'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433278'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-023', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-052 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-052 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-24 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:30:07'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433410'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-024', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-053 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-053 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-25 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:30:16'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433594'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-025', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-054 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-054 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-26 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:30:29'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433749'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-026', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-055 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-055 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-27 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:32:42'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.433879'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-027', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-056 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-056 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-28 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:32:58'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.434004'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-028', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-058 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-058 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-29 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:33:14'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.434148'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-029', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-059 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-059 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-30 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:33:31'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.434272'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-RULE-030', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN-RENL-060 Renal/Kidney Rule New', 'As a clinical team member, I want to validate that the new rule NCCN-RENL-060 triggers correctly based on Q4 2025 guideline updates, so that patients receive accurate genetic testing recommendations.', NULL, NULL, NULL,
    '1. POS scenarios trigger the rule when conditions match\n2. NEG scenarios do NOT trigger when conditions fall outside parameters\n3. Rule behaves consistently on both P4M and Px4M platforms', NULL, 'Must Have', 'RULE',
    NULL, TRUE, 'Approved', 'Change ID: 25Q4R-31 | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:32:06'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.434400'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-CONTENT-001', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN Q4 2025 Content Updates Verification', 'As a clinical team member, I want to verify that all UI text and content updates for Q4 2025 display correctly, so that patients and providers see accurate information.', NULL, NULL, NULL,
    '1. All help text updates display correctly\n2. All question text updates display correctly\n3. Document updates (disclaimers) are accurate\n4. Content appears consistently on both platforms', NULL, 'Must Have', 'CONTENT',
    NULL, TRUE, 'Approved', 'Change ID: N/A | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:33:55'::TIMESTAMPTZ, NOW()), '2025-12-08'::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.434530'::TIMESTAMPTZ, '2025-12-01'::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'NCCN-LANG-001', NULL, 'e1061391-a8c8-4695-9c0e-f8e20dc64d47', NULL,
    'NCCN Q4 2025 Version Language Updates', 'As a clinical team member, I want to verify that all NCCN guideline version references are updated to the correct 2025/2026 versions, so that clinical documentation is accurate.', NULL, NULL, NULL,
    '1. All version text updates display correctly\n2. Version strings match official NCCN guideline naming\n3. Updates appear consistently on both platforms', NULL, 'Must Have', 'LANG',
    NULL, TRUE, 'Approved', 'Change ID: N/A | UAT Cycle: UAT-NCCN-A57B4A47',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-15 18:16:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-15 11:48:53'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-15T10:16:49.434979'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-001', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Provider Dashboard Search Tab - Patient Status Columns', 'As a Provider, I want to see patient status columns (Invitation Status, Precision4ME Status, Activity Status, and Consent Status) in the search results table view, so that I can quickly assess a patient''s program engagement without navigating to their detail record.', 'Provider', NULL, NULL,
    '1. After performing a patient search, the results table displays the following additional columns: Invitation Status, Precision4ME Status, Activity Status, and Consent Status\n\n2. Invitation Status displays values such as: Not Sent, Sent, Opened, Clicked\n\n3. Precision4ME Status displays values such as: Not Started, In Progress, Completed\n\n4. Activity Status displays values such as: Active, Inactive\n\n5. Consent Status displays values such as: Pending, Consented, Declined\n\n6. Column values are pulled from the patient''s current record data\n\n7. Columns are sortable by clicking the column header\n\n8. Column widths are appropriate to display status values without truncation\n\n9. Table remains responsive and scrollable on smaller screens', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Approved', '[2026-01-17 12:51:44]\nGap identified during UAT',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-16 15:41:40'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 09:33:19'::TIMESTAMPTZ, NOW()), '2026-01-20 09:33:19'::TIMESTAMPTZ, 'MCP:update_story',
    '2026-01-16 15:41:40'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-ORDER-002', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Ordering Module - Test Type Defaults and Options', 'As a Provider, I want the ordering module to default to CustomNext-Cancer and offer CustomNext-Cancer + RNAInsight as an alternative, so that I can select the appropriate genetic test for the patient''s clinical needs.', 'Provider', NULL, NULL,
    '1. The Test Type field in the ordering module defaults to "CustomNext-Cancer" when creating a new order\n\n2. The Test Type dropdown includes two options: CustomNext-Cancer (default) and CustomNext-Cancer + RNAInsight\n\n3. When "CustomNext-Cancer" is selected, appropriate sample types are available for selection and sample update workflows support this test type\n\n4. When "CustomNext-Cancer + RNAInsight" is selected, appropriate sample types for RNA testing are available and sample update workflows support this test type\n\n5. Lab orders are transmitted to Redox with the correct test type code\n\n6. Sample tracking and updates function correctly for both test types', NULL, 'Must Have', 'ORDER',
    NULL, TRUE, 'Approved', '[2026-01-17 12:51:51]\nGap identified during UAT',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-16 15:43:23'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 16:55:01'::TIMESTAMPTZ, NOW()), '2026-01-17 16:55:01'::TIMESTAMPTZ, 'MCP:update_story',
    '2026-01-16 15:43:23'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-ORDER-003', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Ordering Module - ICD-10 Code Dropdown with Typeahead', 'As a Provider, I want the ICD-10 code dropdown in the ordering module to include all codes used in the extract filter, so that I can select the most appropriate diagnosis code for the genetic test order.', 'Provider', NULL, NULL,
    '1. The ICD-10 code dropdown in the ordering module is updated to display the ICD-10 codes that are used in the extract filter configuration, replacing the current Z codes\n\n2. Codes are displayed with their code number and description (e.g., "C50.911 - Malignant neoplasm of unspecified site of right female breast")\n\n3. The dropdown supports typeahead filtering: when provider types a letter or number, the list automatically filters to show only codes that contain the typed characters\n\n4. Typeahead filtering works on both the code number and description text\n\n5. Provider can select any code from the filtered dropdown list when creating an order', NULL, 'Won''t Have', 'ORDER',
    NULL, TRUE, 'Approved', '[2026-01-17 12:51:59]\nGap identified during UAT. Current dropdown has Z codes which need to be replaced with the ICD-10 codes used in extract filtering.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 3, COALESCE('2026-01-17 12:17:17'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 09:33:36'::TIMESTAMPTZ, NOW()), '2026-01-20 09:33:36'::TIMESTAMPTZ, 'MCP:update_story',
    '2026-01-17 12:17:17'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-ORDER-004', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Ordering Module - ICD-10 Auto-Populate from Patient Record', 'As a Provider, I want the ICD-10 code from the patient''s record to auto-populate when ordering from the Uncategorized Patient tab, so that I can save time and reduce manual data entry errors.', 'Provider', NULL, NULL,
    '1. When a patient from the Uncategorized Patient tab is selected for ordering, the ICD-10 code from their patient record auto-populates into the order ICD-10 field\n\n2. Provider can accept the auto-populated code or select a different code from the curated dropdown list\n\n3. The auto-populated code is clearly indicated as coming from the patient record\n\n4. If the patient record does not contain an ICD-10 code, the field remains empty and provider can manually select a code', NULL, 'Won''t Have', 'ORDER',
    NULL, TRUE, 'Approved', '[2026-01-17 12:54:17]\nGap identified during UAT. Nice-to-have enhancement - not blocking for launch.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 4, COALESCE('2026-01-17 12:17:44'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 09:33:46'::TIMESTAMPTZ, NOW()), '2026-01-20 09:33:46'::TIMESTAMPTZ, 'MCP:update_story',
    '2026-01-17 12:17:44'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-CONSENT-001', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Manual Consent Override for Paper Consent Forms', 'As a Provider, I want to manually update a patient''s consent status to "Manually Consented" when they complete a paper consent form, so that I can order a test for patients who completed the assessment but did not complete the electronic consent.', 'Provider', NULL, NULL,
    '1. Provider can view a patient''s consent status in the patient record\n\n2. When consent status is "Pending" or "Not Consented", provider can change the status to "Manually Consented"\n\n3. When changing to "Manually Consented", the system requires confirmation that a paper consent form was obtained\n\n4. The consent status change is recorded with the provider''s ID, timestamp, and reason\n\n5. After changing to "Manually Consented", the patient becomes eligible for test ordering\n\n6. The paper consent workflow does not bypass any other ordering requirements', NULL, 'Must Have', 'CONSENT',
    NULL, TRUE, 'Approved', '[2026-01-17 12:53:33]\nGap identified during UAT',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 4, COALESCE('2026-01-17 12:18:59'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 09:33:51'::TIMESTAMPTZ, NOW()), '2026-01-20 09:33:51'::TIMESTAMPTZ, 'MCP:update_story',
    '2026-01-17 12:18:59'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-CONSENT-002', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Consent Validation Gate for Test Ordering', 'As a System, I must prevent test orders from being created unless the patient''s consent status is "Consented" or "Manually Consented", so that orders are only placed for patients who have provided valid consent.', 'System', NULL, NULL,
    '1. The system checks consent status before allowing a test order to be created\n\n2. Orders are ALLOWED when consent status is "Consented" (electronic consent completed)\n\n3. Orders are ALLOWED when consent status is "Manually Consented" (paper consent recorded)\n\n4. Orders are BLOCKED when consent status is "Pending", "Not Consented", "Declined", or any other status not explicitly approved for ordering\n\n5. When ordering is blocked, the system displays a clear message explaining why and what action is needed\n\n6. The consent validation occurs at order submission, preventing incomplete orders from being transmitted to Redox\n\n7. Consent validation cannot be bypassed by any user role', NULL, 'Must Have', 'CONSENT',
    NULL, TRUE, 'Approved', '[2026-01-17 12:53:52]\nGap identified during UAT',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 3, COALESCE('2026-01-17 12:20:11'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 16:55:10'::TIMESTAMPTZ, NOW()), '2026-01-17 16:55:10'::TIMESTAMPTZ, 'MCP:update_story',
    '2026-01-17 12:20:11'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-DATA-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Bulk Patient Upload for Testing Eligibility', 'As a healthcare provider, I want to upload an Excel file of patients eligible for PGx participation, so that I can efficiently initiate the invitation process for large patient populations.', 'healthcare provider', NULL, NULL,
    '1. Provider can upload Excel file containing patient list for testing eligibility\n2. Upload accepts required fields: patient demographics, MRN, contact information\n3. System validates uploaded data format and completeness\n4. System processes wave-based incremental uploads (typically several thousand records per wave)\n5. Upload status and processing results are displayed to provider\n6. Failed records are identified with specific error reasons', NULL, 'Must Have', 'DATA',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:31:19'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:31:19'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:31:19'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-INV-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'SMS Invitation to Patients', 'As an eligible patient, I want to receive an SMS invitation for PGx testing, so that I can conveniently learn about and access the testing opportunity.', 'eligible patient', NULL, NULL,
    '1. SMS invitation is sent to eligible patients from uploaded population\n2. SMS content includes personalized greeting with patient first name\n3. SMS describes PGx testing benefit ("help personalize your medications based on your DNA")\n4. SMS includes link to PopPGx landing page\n5. SMS includes opt-out instructions ("Reply STOP to opt out of texts")\n6. SMS is sent from recognized Providence sender\n7. System tracks SMS delivery status', NULL, 'Must Have', 'INV',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:31:26'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:31:26'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:31:26'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-INV-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Email Invitation to Patients', 'As an eligible patient, I want to receive an email invitation for PGx testing, so that I have detailed information about the program and how to participate.', 'eligible patient', NULL, NULL,
    '1. Email invitation is sent to eligible patients from uploaded population\n2. Email content includes personalized greeting with patient name\n3. Email explains PGx testing purpose and benefits\n4. Email includes link to PopPGx landing page\n5. Email includes contact information for technical assistance and clinical support\n6. Email displays Providence GenoRx program branding/logo\n7. System tracks email delivery and open status', NULL, 'Must Have', 'INV',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:31:33'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:31:33'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:31:33'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-INV-003', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'SMS Invitation Reminder', 'As an eligible patient who has not yet enrolled, I want to receive a reminder SMS about PGx testing, so that I have another opportunity to participate if I missed or forgot about the initial invitation.', 'eligible patient who has not yet enrolled', NULL, NULL,
    '1. SMS reminder is sent 1 week after initial invitation\n2. SMS is only sent to patients who have not yet completed enrollment\n3. SMS content includes personalized greeting with patient first name\n4. SMS reminds patient about the PGx testing opportunity\n5. SMS includes link to PopPGx landing page\n6. SMS includes opt-out instructions ("Reply STOP to opt out of texts")\n7. System tracks reminder delivery status', NULL, 'Must Have', 'INV',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:31:39'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:31:39'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:31:39'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-INV-004', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Invitation Reminder Cadence', 'As a system, I want to send a reminder invitation one week after the initial invitation, so that patients who haven''t responded receive a follow-up prompt to enroll.', 'program administrator', NULL, NULL,
    '1. System sends one reminder invitation one week after the initial invitation\n2. Both SMS and email channels are sent together per invitation batch\n3. Invitation batches are processed automatically per configured schedule\n4. Cadence settings are managed at the developer level (not user-configurable)\n5. System logs all invitation batch executions', NULL, 'Should Have', 'INV',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:31:47'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:28:10'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:31:47'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-AUTH-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'MyChart Login Authentication', 'As a patient, I want to authenticate via MyChart login, so that my identity is verified securely before accessing the PGx consent process.', 'patient', NULL, NULL,
    '1. Patient clicks invitation link and is directed to MyChart login page\n2. Patient authenticates using existing MyChart credentials\n3. Successful authentication redirects patient to invitation verification screen\n4. Failed authentication displays appropriate error message\n5. MyChart login validates patient identity for HIPAA compliance\n6. Session is established upon successful authentication', NULL, 'Must Have', 'AUTH',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:31:55'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:31:55'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:31:55'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-AUTH-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Invitation Verification Screen', 'As a patient, I want the system to verify that I have been invited to participate, so that only eligible patients can proceed with the PGx consent process.', 'patient', NULL, NULL,
    '1. System verifies authenticated patient exists in the invited population list\n2. System checks if patient already exists in GenoRx (Clinical or Population)\n3. If patient was invited and not already enrolled, proceed to pre-consent screening\n4. If patient was NOT invited, display message that they were not invited and provide contact information\n5. If patient is already enrolled in Clinical GenoRx, block Population enrollment and display appropriate message\n6. Verification step prevents unauthorized access to consent flow', NULL, 'Must Have', 'AUTH',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:32:03'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:32:03'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:32:03'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SCREEN-005', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Self-Pay vs Insurance Decision Logic', 'As a patient, I want the system to present appropriate options based on my current medications, so that I can make an informed decision about whether to proceed with self-pay testing or explore insurance coverage.', 'patient', NULL, NULL,
    '1. If patient answered "No" to ALL four medication screens, display two options: "Proceed with self-pay" OR "Not interested at this time"\n2. If patient answered "Yes" to ANY medication screen, display insurance coverage information explaining their insurance might cover the test\n3. If patient answered "Yes" to ANY medication screen, display three options: "Speak with provider about insurance", "Proceed with self-pay", OR "Not interested at this time"\n4. "Proceed with self-pay" routes patient to clinical PGx e-consent\n5. "Speak with provider" routes to confirmation screen with downloadable PGx letter for provider\n6. "Not interested" routes to opt-out confirmation screen with contact information\n7. Decision logic is clearly documented and auditable', NULL, 'Must Have', 'SCREEN',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:32:49'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:44:37'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:32:49'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SCREEN-006', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Provider Letter Download for Insurance Option', 'As a patient who wants to explore insurance coverage, I want to download a letter about PGx testing to take to my provider, so that I can discuss having them order the test through my insurance.', 'patient who wants to explore insurance coverage', NULL, NULL,
    '1. Patient can download a PGx information letter to share with their provider\n2. Letter is in PDF format suitable for printing\n3. Download link is provided on the confirmation screen\n4. Letter includes Providence GenoRx program contact information\n5. System tracks letter downloads', NULL, 'Must Have', 'SCREEN',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:32:57'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:44:41'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:32:57'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-CONSENT-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'E-Consent Signature Capture', 'As a patient, I want to electronically sign my consent for PGx testing, so that I can complete the enrollment process digitally without needing paper forms.', 'patient', NULL, NULL,
    '1. Consent content clearly articulates what the patient is consenting to (Part 11 requirement)\n2. Patient can electronically sign the consent form\n3. Signature captures: Patient Name, Signing Date, Patient Date of Birth\n4. Signature is legally binding and compliant with e-signature regulations\n5. System timestamps the signature with date and time\n6. Patient receives confirmation that consent was successfully submitted\n7. Signed consent is stored securely and associated with patient record\n8. Patient is considered "enrolled" immediately once required consents are signed', NULL, 'Must Have', 'CONSENT',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:33:15'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:27:34'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:33:15'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SCREEN-007', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Patient Opt-Out Flow', 'As a patient, I want to decline participation in PGx testing, so that I can opt out gracefully and not receive further invitations.', 'patient', NULL, NULL,
    '1. Patient can select "I am not interested in PGx testing at this time"\n2. System records patient opt-out decision\n3. Confirmation screen displays thank you message\n4. Confirmation screen provides contact information for future inquiries\n5. Patient is not sent additional reminders after opting out\n6. Opt-out status is tracked in the system', NULL, 'Must Have', 'SCREEN',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:33:32'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:33:32'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:33:32'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-CONSENT-003', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Population Research Consent Education', 'As a patient, I want to learn about the optional research program, so that I can make an informed decision about whether to participate in research in addition to clinical testing.', 'patient', NULL, NULL,
    '1. After clinical consent, patient is presented with optional research consent opportunity\n2. Educational content explains the research program and its purpose\n3. Patient can proceed to research consent or skip/opt-out', NULL, 'Should Have', 'CONSENT',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 2, COALESCE('2026-01-17 14:33:41'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:27:42'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:33:41'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-CONSENT-004', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Research Consent Form and Signature', 'As a patient, I want to consent to participate in the research program, so that my genetic data can contribute to advancing pharmacogenomics research.', 'patient', NULL, NULL,
    '1. Research consent content clearly articulates what the patient is consenting to (Part 11 requirement)\n2. Patient can electronically sign the research consent form\n3. Signature captures: Patient Name, Signing Date, Patient Date of Birth\n4. Signature is legally binding and compliant with e-signature regulations\n5. System timestamps the signature with date and time\n6. Patient receives confirmation that research consent was successfully submitted\n7. Signed research consent is stored securely and associated with patient record\n8. Research consent is optional and does not affect clinical testing', NULL, 'Should Have', 'CONSENT',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 2, COALESCE('2026-01-17 14:33:50'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:27:53'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:33:50'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-DASH-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Patient Dashboard', 'As an enrolled patient, I want to access my GenoRx dashboard, so that I can view my consent status, download documents, and access educational content.', 'enrolled patient', NULL, NULL,
    '1. Patient can access dashboard after completing enrollment\n2. Dashboard displays: PGx Test status, Research Consent status (if applicable), HIPAA Consent status\n3. Dashboard provides access to view/download signed consent documents\n4. Dashboard displays "Discover" section with educational content\n5. Dashboard is accessible via URL provided in welcome email\n6. Dashboard requires MyChart authentication to access\n7. Dashboard content is owned/managed by PGx Team', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:34:07'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:34:07'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:34:07'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-MSG-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Welcome Email with Dashboard Link', 'As a newly enrolled patient, I want to receive a welcome email with my dashboard link, so that I can easily access my GenoRx program information.', 'newly enrolled patient', NULL, NULL,
    '1. Welcome email is sent immediately after patient completes enrollment\n2. Email thanks patient for completing PGx testing consent\n3. Email includes link to patient''s GenoRx dashboard\n4. Email explains what patient can do on the dashboard (download consent, learn about PGx)\n5. Email is from Providence GenoRx Team with appropriate branding\n6. System tracks email delivery status', NULL, 'Must Have', 'MSG',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:34:20'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:34:20'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:34:20'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-DASH-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Provider Dashboard - Patient List View', 'As a provider, I want to view a dashboard of my enrolled GenoRx Population patients, so that I can monitor program participation and patient status.', 'provider', NULL, NULL,
    '1. Provider can view list of enrolled patients in GenoRx Population program\n2. Dashboard displays patient status (enrolled, test ordered, results pending, etc.)\n3. Provider can search and filter patient list\n4. Dashboard displays key patient information (name, MRN, enrollment date, test status)\n5. Dashboard displays when reminder was sent to patient\n6. Provider can access individual patient details\n7. Dashboard supports role-based access control', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:34:30'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:27:29'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:34:30'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-ORDER-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Provider Test Order from Dashboard', 'As a provider, I want to order a PGx test for an enrolled patient, so that the patient receives their at-home collection kit and testing can proceed.', 'provider', NULL, NULL,
    '1. Provider can initiate PGx test order for enrolled patient from dashboard\n2. Test order uses default lab configuration: Lab = Helix, Collection = At Home, Sample = Buccal\n3. E-consent is always required before test can be ordered\n4. Test order is submitted to laboratory system\n5. System tracks test order status\n6. Provider receives confirmation of successful test order', NULL, 'Must Have', 'ORDER',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:34:56'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:28:22'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:34:56'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SURVEY-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    '1-Month Post-Consent Automated Survey', 'As a program administrator, I want enrolled patients to receive an automated survey 1 month after consent, so that we can gather feedback on their early program experience.', 'program administrator', NULL, NULL,
    '1. System automatically sends survey 1 month after patient signs PGx consent\n2. Survey is sent via email or notification to patient dashboard\n3. Survey content is pending IRB review (survey TBD)\n4. Patient can complete survey from dashboard\n5. Survey responses are captured and stored\n6. System tracks survey completion status', NULL, 'Should Have', 'SURVEY',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-17 14:35:06'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:35:06'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:35:06'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SURVEY-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    '12-Month Post-Consent Automated Survey', 'As a program administrator, I want enrolled patients to receive an automated survey 12 months after consent, so that we can gather long-term feedback on their program experience and outcomes.', 'program administrator', NULL, NULL,
    '1. System automatically sends survey 12 months after patient signs PGx consent\n2. 12-month anchor date is the date patient signs the POP PGx test consent\n3. Survey is sent via email or notification to patient dashboard\n4. Survey content is pending IRB review (survey TBD)\n5. Patient can complete survey from dashboard\n6. Survey responses are captured and stored\n7. System tracks survey completion status', NULL, 'Should Have', 'SURVEY',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-17 14:35:13'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:35:13'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:35:13'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-CONFIG-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Dual Enrollment Prevention Between Clinical and Population', 'As a program administrator, I want to prevent patients from enrolling in both Clinical GenoRx and Population GenoRx, so that we avoid duplicate testing and maintain clean program data.', 'program administrator', NULL, NULL,
    '1. System checks if patient is already enrolled in Clinical GenoRx before allowing Population enrollment\n2. If patient exists in Clinical GenoRx, Population enrollment is blocked\n3. Blocked patient receives clear message explaining they cannot enroll in Population program\n4. For routing discussion purposes, patients are blocked programmatically to prevent double enrollment\n5. Check occurs during invitation verification step\n6. Dual enrollment prevention applies to both programs (Clinical blocks Population, Population blocks Clinical)', NULL, 'Must Have', 'CONFIG',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:35:29'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:35:29'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:35:29'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-DASH-003', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Cross-Program Patient Visibility', 'As a GenoRx team member, I want to view patients from both Clinical and Population GenoRx programs together, so that I can analyze and manage the overall GenoRx patient population.', 'GenoRx team member', NULL, NULL,
    '1. GenoRx team has ability to view patients from both Clinical and Population programs together\n2. Combined view supports searching and filtering across both programs\n3. View clearly indicates which program each patient belongs to\n4. Flexibility provided for team to analyze data across both programs\n5. Cross-program view respects existing role-based access controls\n6. Feature can be enabled/disabled per user role', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-17 14:36:02'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:36:02'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:36:02'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-CONTENT-001', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Self-Pay Educational Content Display', 'As a patient, I want to view educational content about PGx testing before consenting, so that I understand the value and process of pharmacogenomics testing.', 'patient', NULL, NULL,
    '1. Content displays GenoRx brochure information about PGx testing\n2. Content explains what PGx testing is and its benefits\n3. Content explains the self-pay cost ($249)\n4. Content is displayed as part of the pre-consent education flow', NULL, 'Must Have', 'CONTENT',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:36:10'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:27:58'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:36:10'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-CONTENT-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Opt-Out Confirmation Content', 'As a patient who declines participation, I want to see a confirmation screen with contact information, so that I know my opt-out was recorded and can reach out if I change my mind.', 'patient who declines participation', NULL, NULL,
    '1. Opt-out content is displayed after patient selects "Not interested" option\n2. Content thanks patient for their time\n3. Content provides Providence GenoRx program contact information\n4. Content allows patient to close/exit the flow gracefully', NULL, 'Must Have', 'CONTENT',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 14:36:18'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:28:04'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:36:18'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-DASH-004', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Consent Document Download from Dashboard', 'As an enrolled patient, I want to download a copy of my signed consent document, so that I can retain a record of what I agreed to.', 'enrolled patient', NULL, NULL,
    '1. Patient can download their signed consent document from the dashboard\n2. Download is available in PDF format\n3. Document includes all consent content and signature/date information\n4. Clinical consent and research consent (if applicable) are downloadable separately\n5. Download is available immediately after consent is signed\n6. Document retains legal validity when downloaded', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:37:04'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:37:04'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:37:04'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SURVEY-003', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Survey Display and Submission on Dashboard', 'As an enrolled patient, I want to view and complete surveys from my dashboard, so that I can provide feedback on my program experience.', 'enrolled patient', NULL, NULL,
    '1. Survey notification appears on patient dashboard when survey is due\n2. Patient can access and complete survey directly from dashboard\n3. Survey submission is confirmed to patient\n4. Completed survey status is tracked on dashboard\n5. Survey completion is optional and does not affect program participation\n6. Survey request action goes to dashboard (not direct submission)', NULL, 'Should Have', 'SURVEY',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-17 14:37:14'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:37:14'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:37:14'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-INV-005', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Stop Reminders Upon Enrollment', 'As an enrolled patient, I want to stop receiving invitation reminders after I complete enrollment, so that I am not bothered by unnecessary messages.', 'enrolled patient', NULL, NULL,
    '1. System stops sending invitation reminders once patient signs required consents\n2. Enrollment definition: patient is considered enrolled immediately once required consents are signed\n3. Enrollment status is updated in real-time\n4. No further invitation or reminder messages are sent to enrolled patients\n5. Enrollment status is reflected in provider dashboard', NULL, 'Must Have', 'INV',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 14:37:25'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:37:25'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:37:25'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-SURVEY-004', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'Survey Completion Status Tracking', 'As a program administrator, I want to track survey completion status on dashboards, so that I can monitor patient engagement without requiring additional notifications.', 'program administrator', NULL, NULL,
    '1. System tracks completion status for all post-consent surveys\n2. Completion status is visible on patient dashboard and provider dashboard\n3. No additional system notification is needed when survey is completed (per question #8)\n4. Status tracking includes: Not Due, Due, Completed, Skipped\n5. Survey completion does not block other program functionality', NULL, 'Should Have', 'SURVEY',
    NULL, TRUE, 'Draft', NULL,
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-17 14:39:09'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 14:39:09'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 14:39:09'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-002', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Provider Assessment Update Capability', 'As a provider, I want to update a patient''s submitted assessment, so that I can correct errors or add new information the patient provides during counseling.', 'provider', NULL, NULL,
    '1. Provider can access and edit any submitted patient assessment from the dashboard\n2. Updates can be made regardless of the patient''s close-out status (before or after patient editing is locked)\n3. There are no time limits on when a provider can make updates\n4. All changes are logged with: who made the change, when the change was made, and what was changed (before/after values)\n5. Provider can save updates directly without additional approval workflow', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Draft', 'Triggered by patient feedback during counseling - patient may notice mistakes or remember new information. Audit trail is compliance-critical.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 2, COALESCE('2026-01-17 16:58:39'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 16:59:35'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 16:58:39'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'GRXP-ORDER-002', NULL, '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', NULL,
    'At-Home Test Order Without Collection Date', 'As a provider, I want to order a Helix at-home test without entering a collection date, so that I can complete the order even though the patient''s home collection date is unknown.', 'provider', NULL, NULL,
    '1. Provider can submit a Helix at-home test order without entering a collection date\n2. Collection date field is optional (not required) for at-home test orders\n3. System accepts and processes the order with null/empty collection date\n4. Order transmits successfully to Helix without collection date\n5. Collection date can be updated later when known', NULL, 'Must Have', 'ORDER',
    NULL, TRUE, 'Draft', 'At-home collection date is unknown at time of ordering since patient collects sample at home on their own schedule.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q1 2026', 1, COALESCE('2026-01-17 17:29:54'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-17 17:29:54'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-17 17:29:54'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ASSESS-001', NULL, 'P4M-7EC35FEE', NULL,
    'Health Fair QR Code Assessment Entry', 'As a community outreach coordinator, I want patients at health fairs to complete a P4M assessment by scanning a QR code, so that we can capture risk assessments for patients who may not yet be established in our system.', 'community outreach coordinator', NULL, NULL,
    '1. System generates a unique QR code or shareable link for the P4M assessment\n2. QR code/link can be printed for health fair materials or displayed on signage\n3. Patient scanning QR code is directed to assessment without requiring prior registration\n4. Assessment can be completed on patient''s mobile device or provided tablet\n5. Completed assessment is stored in the P4M dashboard with status "Pending Epic Link"\n6. Assessment data is associated with patient-provided identifiers (name, DOB, contact info) for later matching\n7. No Epic integration occurs at time of completion (deferred sync)', NULL, 'Should Have', 'ASSESS',
    NULL, TRUE, 'Draft', 'Health fair / community outreach use case. Part 11 identity verification handled by onsite provider. Epic sync is deferred - handled by separate FHIR story.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:16:01'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:16:01'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:16:01'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ASSESS-002', NULL, 'P4M-7EC35FEE', NULL,
    'Provider-Initiated Assessment for Established Patient', 'As a provider, I want to send a P4M assessment to an established patient who is not currently scheduled for a P4M appointment, so that I can offer risk assessment to patients I encounter during routine visits.', 'provider', NULL, NULL,
    '1. Provider can initiate an on-demand assessment for any patient visible in the dashboard\n2. Assessment can be initiated regardless of whether patient has a scheduled P4M appointment\n3. Patient receives assessment invitation via their preferred contact method (email/SMS)\n4. Assessment link is tied to the patient''s existing MRN\n5. Completed assessment flows to Epic immediately (standard integration path)\n6. Dashboard reflects assessment status in real-time\n7. No changes to existing extract or scheduling workflows required', NULL, 'Should Have', 'ASSESS',
    NULL, TRUE, 'Draft', 'Use case: Provider sees established patient in clinic (not on P4M schedule) and wants to offer assessment. Patient already has MRN so standard Epic integration applies.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:16:11'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:16:11'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:16:11'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ASSESS-003', NULL, 'P4M-7EC35FEE', NULL,
    'One-Off Assessment Send for Specific Patient', 'As a clinic staff member, I want to manually send a P4M assessment invitation to a specific patient, so that I can reach patients who don''t meet auto-invite criteria but would benefit from risk assessment.', 'clinic staff member', NULL, NULL,
    '1. Authorized staff can search for a patient by MRN, name, or DOB\n2. Staff can send assessment invitation to a specific patient outside of auto-invite logic\n3. One-off send bypasses normal extract eligibility filters\n4. Patient receives assessment invitation via email and/or SMS\n5. Assessment completion follows standard Epic integration path\n6. One-off sends are logged with initiating user and reason\n7. One-off send does not affect patient''s eligibility for future auto-invites', NULL, 'Should Have', 'ASSESS',
    NULL, TRUE, 'Draft', 'Portland use case - ability to send assessment to specific patients who may not meet normal auto-invite criteria. Different from provider-initiated in that this is staff-driven batch capability.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:16:20'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:16:20'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:16:20'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-ASSESS-004', NULL, 'P4M-7EC35FEE', NULL,
    'Assessment for Non-Providence Patients (Partner Clinics)', 'As a partner clinic provider, I want to offer P4M assessments to my patients even though we don''t chart in Epic, so that patients at community partner sites can access breast cancer risk assessment.', 'partner clinic provider', NULL, NULL,
    '1. System supports clinics that do not chart in Epic\n2. Patient completes assessment through QR code or direct link\n3. Assessment data is stored in P4M dashboard only (no Epic integration)\n4. Patient record is created with patient-provided demographics\n5. Risk results are viewable in dashboard by authorized clinic staff\n6. Clinical summary can be generated and printed/downloaded for patient\n7. Data remains in P4M system with no expectation of EHR sync', NULL, 'Could Have', 'ASSESS',
    NULL, TRUE, 'Draft', 'Use case for partner clinics (community partners) that don''t use Epic. Assessment stays in P4M dashboard only. Consider future state where these could be linked if patient later becomes Providence patient.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:16:31'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:16:31'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:16:31'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-AUTH-001', NULL, 'P4M-7EC35FEE', NULL,
    'Patient Identity Verification via MyChart Login', 'As a patient, I want to verify my identity by logging into MyChart before completing my assessment, so that my assessment results can be securely linked to my medical record.', 'patient', NULL, NULL,
    '1. Patient can authenticate via MyChart login before starting assessment\n2. MyChart login satisfies Part 11 identity verification requirements\n3. Upon successful MyChart authentication, patient identity is verified and MRN is captured\n4. Assessment is automatically linked to patient''s Epic record via MRN\n5. If MyChart login fails or is unavailable, patient is informed they need onsite verification\n6. System logs authentication method used for each assessment (audit trail)', NULL, 'Must Have', 'AUTH',
    NULL, TRUE, 'Draft', 'Part 11 requires positive patient identification. MyChart login is one accepted method. Works for remote/unattended assessment completion.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:16:41'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:16:41'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:16:41'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-AUTH-002', NULL, 'P4M-7EC35FEE', NULL,
    'Patient Identity Verification via Onsite Provider Attestation', 'As a provider at a health fair or clinic, I want to verify a patient''s identity in person and attest to that verification, so that assessments completed without MyChart login still meet Part 11 requirements.', 'provider at a health fair or clinic', NULL, NULL,
    '1. Provider can verify patient identity onsite using government-issued ID or known patient relationship\n2. Provider attestation confirms patient identity was verified in person\n3. Provider enters patient identifiers (name, DOB) and attestation is recorded\n4. Attestation includes provider ID, timestamp, and verification method\n5. Onsite verification satisfies Part 11 identity verification requirements\n6. Assessment is marked as "Provider Verified" with attestation audit trail\n7. Verification can occur before or after assessment completion', NULL, 'Must Have', 'AUTH',
    NULL, TRUE, 'Draft', 'Part 11 identity verification method for health fairs and onsite scenarios where MyChart isn''t feasible. Provider takes responsibility for identity verification.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:16:51'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:16:51'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:16:51'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-DASH-003', NULL, 'P4M-7EC35FEE', NULL,
    'Dashboard Notification for New Assessment Completion', 'As a clinic staff member, I want to receive a notification when a new on-demand assessment is completed, so that I know when to follow up with patients who completed assessments outside the normal scheduled flow.', 'clinic staff member', NULL, NULL,
    '1. Dashboard displays notification when new on-demand assessment is completed\n2. Notification includes patient name, completion timestamp, and verification status\n3. Notifications are visible to authorized clinic staff based on role\n4. Staff can acknowledge/dismiss notifications\n5. Notification distinguishes between assessments pending Epic link vs. already linked\n6. Notification count badge shows unacknowledged new assessments\n7. Email/SMS notification option available for designated clinic contacts', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Draft', 'Kim raised this need in Teams thread - clinics need to know when new assessments come in, especially for on-demand/encounterless flow where there''s no scheduled appointment trigger.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:17:00'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:17:00'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:17:00'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'P4M-INT-001', NULL, 'P4M-7EC35FEE', NULL,
    'Deferred Epic Link via FHIR Patient Lookup', 'As a clinic staff member, I want to link a completed health fair assessment to a patient''s Epic record using FHIR lookup, so that assessment data collected without an MRN can be synced to the patient''s chart after the event.', 'clinic staff member', NULL, NULL,
    '1. Staff can initiate Epic link for assessments with "Pending Epic Link" status\n2. System performs FHIR patient lookup using patient-provided identifiers (name, DOB)\n3. If single match found, system presents patient record for staff confirmation\n4. If multiple matches found, staff can select correct patient from results\n5. If no match found, staff is informed patient may not exist in Epic\n6. Upon confirmation, assessment data syncs to Epic via standard integration\n7. Assessment status updates from "Pending Epic Link" to linked with MRN\n8. FHIR lookup and link actions are logged for audit trail', NULL, 'Should Have', 'INT',
    NULL, TRUE, 'Draft', 'Deferred Epic sync for health fair scenario. FHIR call looks up patient, staff confirms match, then standard Epic integration occurs. Addresses gap between assessment completion and Epic linkage.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:17:10'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:17:10'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:17:10'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-003', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Uncategorized Tab - Add Patient Age Column', 'As a provider, I want to see patient age displayed next to DOB in the Uncategorized tab, so that I can quickly assess patient age without calculating it manually.', 'provider', NULL, NULL,
    '1. Patient Age column is added to the Uncategorized tab patient list\n2. Age column displays next to the DOB column\n3. Age is calculated from patient''s date of birth\n4. Age displays as whole number in years\n5. Age updates dynamically (not static at time of data load)', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Draft', 'Must have but do not delay launch - pilot period goal. Enhancement request from client review.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-20 10:32:44'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:32:44'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:32:44'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-004', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Standardize DOB Display Format to MM/DD/YYYY', 'As a provider, I want dates of birth displayed in standard MM/DD/YYYY numerical format, so that date information is consistent with clinical workflows and easier to read.', 'provider', NULL, NULL,
    '1. All DOB fields display in MM/DD/YYYY numerical format\n2. Format change applies across all dashboard views and tabs\n3. Format is consistent throughout the application\n4. No functional changes to date handling or storage (display only)', NULL, 'Must Have', 'DASH',
    NULL, TRUE, 'Draft', 'Must have but do not delay launch - pilot period goal. Current format MMM D, YYYY is non-standard per client feedback.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-20 10:32:53'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:32:53'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:32:53'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-CONTENT-001', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Improve Pathology Narrative Readability', 'As a provider, I want the pathology narrative to be more user-friendly and easier to understand, so that I can quickly interpret and communicate pathology information to patients.', 'provider', NULL, NULL,
    '1. Pathology narrative text is reviewed and revised for clarity\n2. Medical terminology is explained or simplified where appropriate\n3. Narrative is structured in a logical, easy-to-follow format\n4. Key findings are highlighted or emphasized\n5. Content remains clinically accurate while being more accessible', NULL, 'Must Have', 'CONTENT',
    NULL, TRUE, 'Draft', 'Must have but do not delay launch - pilot period goal. Specific improvements TBD - may need follow-up with clinical team on what "user friendly" means in this context.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Q2 2026', 1, COALESCE('2026-01-20 10:33:02'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:33:02'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:33:02'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-005', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Uncategorized Tab - Display Patient Age', 'As a provider, I want to see the patient''s age displayed next to their DOB in the Uncategorized tab, so that I can quickly assess patient age without calculating it manually.', 'provider', NULL, NULL,
    '1. Patient age is displayed in the Uncategorized tab patient list\n2. Age column is positioned next to the DOB column\n3. Age is calculated from DOB and displayed in years\n4. Age updates automatically based on current date', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Draft', 'Pilot period goal - must have but do not delay launch',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:41:32'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:41:32'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:41:32'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-006', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Standardize DOB Date Format to MM/DD/YYYY', 'As a provider, I want DOB displayed in standard numerical format (MM/DD/YYYY), so that dates are consistent and easier to read quickly.', 'provider', NULL, NULL,
    '1. All DOB fields display in MM/DD/YYYY numerical format\n2. Format change applies across all dashboard tabs and views\n3. No change to underlying data storage format', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Draft', 'Pilot period goal - must have but do not delay launch. Current format MMM D, YYYY is non-standard.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:41:38'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:41:38'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:41:38'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-007', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Improve Pathology Narrative Readability', 'As a provider, I want the pathology narrative to be presented in a more user-friendly format, so that I can quickly understand the pathology findings without parsing dense clinical text.', 'provider', NULL, NULL,
    '1. Pathology narrative is formatted for improved readability\n2. Key findings are clearly highlighted or structured\n3. Clinical accuracy is maintained', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Draft', 'Pilot period goal - must have but do not delay launch. Need to define specific formatting improvements with clinical team.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:41:44'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:41:44'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:41:44'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;

INSERT INTO user_stories (
    story_id, requirement_id, program_id, parent_story_id, title, user_story, role, capability, benefit,
    acceptance_criteria, success_metrics, priority, category, category_full, is_technical, status,
    internal_notes, meeting_context, client_feedback, related_stories, flags, roadmap_target, version,
    created_at, updated_at, approved_at, approved_by, draft_date, internal_review_date, client_review_date, needs_discussion_date
) VALUES (
    'PXME-DASH-008', NULL, '50405a41-4470-459e-8ec3-0dd223e98669', NULL,
    'Triaged Tab - Add Referral Status Dropdown', 'As a provider, I want a referral status dropdown in the Triaged patient columns, so that I can track and update referral status directly from the patient list.', 'provider', NULL, NULL,
    '1. Referral status dropdown is displayed in Triaged tab patient columns\n2. Dropdown includes appropriate referral status options\n3. Provider can update referral status directly from the dropdown\n4. Status changes are saved immediately\n5. Status changes are logged in audit trail', NULL, 'Should Have', 'DASH',
    NULL, TRUE, 'Draft', 'Pilot period goal - must have but do not delay launch. Need to define referral status options with clinical team.',
    NULL, NULL, '[]'::JSONB, '[]'::JSONB,
    'Backlog', 1, COALESCE('2026-01-20 10:41:51'::TIMESTAMPTZ, NOW()),
    COALESCE('2026-01-20 10:41:51'::TIMESTAMPTZ, NOW()), NULL::TIMESTAMPTZ, NULL,
    '2026-01-20 10:41:51'::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
    NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ
) ON CONFLICT (story_id) DO NOTHING;


ALTER TABLE requirements ENABLE TRIGGER ALL;
ALTER TABLE user_stories ENABLE TRIGGER ALL;

SELECT 'requirements' AS table_name, COUNT(*) AS row_count FROM requirements
UNION ALL SELECT 'user_stories', COUNT(*) FROM user_stories;