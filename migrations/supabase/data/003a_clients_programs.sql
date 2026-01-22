-- ==========================================================================
-- CLIENTS AND PROGRAMS DATA
-- Exported: 2026-01-20T11:41:54.448181
-- ==========================================================================

-- Disable triggers for bulk insert
ALTER TABLE clients DISABLE TRIGGER ALL;
ALTER TABLE programs DISABLE TRIGGER ALL;
ALTER TABLE program_relationships DISABLE TRIGGER ALL;

-- CLIENTS
INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    'CLI-2DE20EE4', 'Discover Health', NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Active', COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;

INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    'CLI-D440DAFF', 'Test Client', NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Active', COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;

INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    'CLI-B3A197E9', 'Import Test Client', NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Active', COALESCE('2025-12-19 17:30:56'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 17:30:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;

INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    'CLI-55E98063', 'Fresh Import Client', NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Active', COALESCE('2025-12-19 17:31:02'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 17:31:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;

INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    '12816025-f3bc-4eac-9c19-71087c50455e', 'Propel Health', NULL, 'Platform-wide features and internal capabilities that span across all Propel Health programs', NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Active', COALESCE('2026-01-07 14:05:53'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 14:05:53'::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;

INSERT INTO clients (
    client_id, name, short_name, description, client_type,
    primary_contact_name, primary_contact_email, primary_contact_phone,
    contract_reference, contract_start_date, contract_end_date,
    source_document, status, created_at, updated_at
) VALUES (
    'ce5dfb87-d3bc-432d-bb39-62c67b9e122d', 'Providence Health & Services', 'Providence', 'Health system partner - breast cancer prevention, precision oncology, pharmacogenomics, and analytics programs', 'External',
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Active', COALESCE('2026-01-17 14:29:43'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 14:29:43'::TIMESTAMPTZ, NOW())
) ON CONFLICT (client_id) DO NOTHING;


-- PROGRAMS
INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'P4M-7EC35FEE', 'CLI-2DE20EE4', 'Prevention4ME', 'P4M', NULL,
    'clinic_based', NULL, '#4A90E2', 'Active',
    COALESCE('2025-12-19T12:37:47.730703'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 20:37:47'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'P4ME-B38EA8DC', 'CLI-2DE20EE4', 'Precision4ME', 'P4ME', NULL,
    'clinic_based', NULL, '#9013FE', 'Active',
    COALESCE('2025-12-24T12:51:09.272954'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:09'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'PRG-DIS-A2C1AD11', 'CLI-2DE20EE4', 'Propel Analytics', 'DIS', NULL,
    'clinic_based', 'Propel Functionalities Request.xlsx', '#9013FE', 'Active',
    COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:42'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'PRG-TEST2-8F48D903', 'CLI-D440DAFF', 'TEST2 Program', 'TEST2', NULL,
    'clinic_based', 'Propel Functionalities Request.xlsx', '#6B7280', 'Active',
    COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 00:50:48'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'PRG-IMPORT-159CB698', 'CLI-B3A197E9', 'Import Test Program', 'IMPORT', NULL,
    'clinic_based', 'DIS_draft_user_stories_20251218_1650.xlsx', '#6B7280', 'Active',
    COALESCE('2025-12-19 17:30:56'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 17:30:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'PRG-FRESH-EEC45038', 'CLI-55E98063', 'FRESH Program', 'FRESH', NULL,
    'clinic_based', 'DIS_draft_user_stories_20251218_1650.xlsx', '#6B7280', 'Active',
    COALESCE('2025-12-19 17:31:02'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-19 17:31:02'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    '215befe9-f8f7-4371-9df4-ff7afe18af84', '12816025-f3bc-4eac-9c19-71087c50455e', 'Propel Platform', 'PLAT', 'Platform-wide features and capabilities that span across all Propel Health programs (Prevention4ME, Precision4ME, GenomeRx, etc.)',
    'clinic_based', NULL, '#9013FE', 'Active',
    COALESCE('2026-01-07 14:06:00'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-07 14:06:00'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    '9bcd1428-0bd4-487e-8b43-42563fee3b75', '12816025-f3bc-4eac-9c19-71087c50455e', 'Onboarding Questionnaire', 'ONB', 'Client-facing onboarding questionnaire for clinic setup. GitHub Pages static site that outputs JSON for MCP import.',
    'clinic_based', NULL, '#10B981', 'Active',
    COALESCE('2026-01-08 10:48:24'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-08 10:48:24'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    'e1061391-a8c8-4695-9c0e-f8e20dc64d47', '12816025-f3bc-4eac-9c19-71087c50455e', 'NCCN Rule Validation', 'NCCN', 'NCCN guideline rule engine validation for P4M and Px4M platforms. Validates rule trigger logic for quarterly NCCN updates.',
    'clinic_based', NULL, '#F5A623', 'Active',
    COALESCE('2026-01-15 09:53:30'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-15 09:53:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    '50405a41-4470-459e-8ec3-0dd223e98669', 'CLI-2DE20EE4', 'Precision4ME (PxME)', 'PXME', 'Precision4ME - Precision oncology program for tumor profiling and treatment guidance using CustomNext-Cancer testing',
    'clinic_based', NULL, '#9013FE', 'Active',
    COALESCE('2026-01-16 15:41:31'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-16 15:41:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    '50ef9567-742d-428c-ae9f-217e03bf5eba', 'CLI-2DE20EE4', 'GenoRx Population', 'GRX', 'Population health pharmacogenomics (PGx) testing program for Providence. Patient-initiated proactive PGx testing via bulk invitations with self-pay model. Enables patients to understand how their genes affect medication response.',
    'clinic_based', NULL, '#E24A4A', 'Active',
    COALESCE('2026-01-17 14:28:25'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 14:28:25'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;

INSERT INTO programs (
    program_id, client_id, name, prefix, description,
    program_type, source_file, color_hex, status, created_at, updated_at
) VALUES (
    '4eb63a88-96b9-45be-b1d3-7adb3cea0b67', 'ce5dfb87-d3bc-432d-bb39-62c67b9e122d', 'GenoRx Population', 'GRXP', 'Population health pharmacogenomics (PGx) testing program for Providence. Patient-initiated proactive PGx testing via bulk invitations with self-pay model. Enables patients to understand how their genes affect medication response.',
    'clinic_based', NULL, '#E24A4A', 'Active',
    COALESCE('2026-01-17 14:30:54'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-17 14:30:54'::TIMESTAMPTZ, NOW())
) ON CONFLICT (program_id) DO NOTHING;


-- PROGRAM RELATIONSHIPS

-- Re-enable triggers
ALTER TABLE clients ENABLE TRIGGER ALL;
ALTER TABLE programs ENABLE TRIGGER ALL;
ALTER TABLE program_relationships ENABLE TRIGGER ALL;

-- Verify counts
SELECT 'clients' AS table_name, COUNT(*) AS row_count FROM clients
UNION ALL SELECT 'programs', COUNT(*) FROM programs
UNION ALL SELECT 'program_relationships', COUNT(*) FROM program_relationships;