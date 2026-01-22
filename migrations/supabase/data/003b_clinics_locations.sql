-- ==========================================================================
-- CLINICS AND LOCATIONS DATA
-- Exported: 2026-01-20T11:41:54.452409
-- ==========================================================================

ALTER TABLE clinics DISABLE TRIGGER ALL;
ALTER TABLE locations DISABLE TRIGGER ALL;

-- CLINICS
INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'PORT-28E246', 'P4M-7EC35FEE', 'Portland', NULL, NULL,
    'Active', COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'KADLEC-055381', 'P4M-7EC35FEE', 'Kadlec Mammography Center', 'KADLEC', NULL,
    'Active', COALESCE('2025-12-23 01:10:01'::TIMESTAMPTZ, NOW()), COALESCE('2026-01-05 20:58:56'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'EVERETT-ADC335', 'P4M-7EC35FEE', 'Everett Breast Center', 'EVERETT', NULL,
    'Active', COALESCE('2025-12-23 01:34:31'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:34:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'MILLCREEK-9A3D98', 'P4M-7EC35FEE', 'Mill Creek Satellite Clinic', 'MILLCREEK', NULL,
    'Active', COALESCE('2025-12-23 01:34:31'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:34:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'MONROE-9479B0', 'P4M-7EC35FEE', 'Monroe Satellite Clinic', 'MONROE', NULL,
    'Active', COALESCE('2025-12-23 01:34:31'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:34:31'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'FRANZ-24AB46', 'P4M-7EC35FEE', 'Franz Clinic', 'FRANZ', NULL,
    'Active', COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'BSW-1DAD27', 'P4M-7EC35FEE', 'Breast Specialty of the West', 'BSW', NULL,
    'Active', COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'NEWBERG-558619', 'P4M-7EC35FEE', 'Newberg Clinic', 'NEWBERG', NULL,
    'Active', COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'WFALLS-FCF291', 'P4M-7EC35FEE', 'Willamette Falls Clinic', 'WFALLS', NULL,
    'Active', COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:18'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'MISSION-6D4CA5', 'P4ME-B38EA8DC', 'Mission Hospital', 'MISSION', NULL,
    'Active', COALESCE('2025-12-24 20:51:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'STJOSEPH-83AE15', 'P4ME-B38EA8DC', 'St. Joseph Hospital Orange', 'STJOSEPH', NULL,
    'Active', COALESCE('2025-12-24 20:51:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;

INSERT INTO clinics (
    clinic_id, program_id, name, code, description, status, created_at, updated_at
) VALUES (
    'STJUDE-A0FD20', 'P4ME-B38EA8DC', 'St. Jude Medical Center Fullerton', 'STJUDE', NULL,
    'Active', COALESCE('2025-12-24 20:51:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (clinic_id) DO NOTHING;


-- LOCATIONS
INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-974B7894', 'PORT-28E246', 'PCI BREAST SURGERY WEST (Includes PCI BREAST CARE CLINIC WEST)', NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-B76B4670', 'PORT-28E246', 'PCI WF BREAST SURGERY', NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-AA07B2EF', 'PORT-28E246', 'PCI FRANZ BREAST CARE', NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-B6790DB1', 'PORT-28E246', 'PCI NEWBERG BREAST SURGERY CLINIC', NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-A0515EFA', 'KADLEC-055381', 'Richland, Washington', 'RICHLAND',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:10:13'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:10:13'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-3CE3EC16', 'EVERETT-ADC335', 'Everett, Washington', 'EVERETT-WA',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:34:37'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:34:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-ECA6EBCF', 'MILLCREEK-9A3D98', 'Mill Creek, Washington', 'MILLCREEK-WA',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:34:37'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:34:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-DF7FA923', 'MONROE-9479B0', 'Monroe, Washington', 'MONROE-WA',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:34:37'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:34:37'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-15BA7CDB', 'FRANZ-24AB46', 'Portland, Oregon', 'FRANZ-PDX',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-D7823C8B', 'BSW-1DAD27', 'Portland, Oregon', 'BSW-PDX',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-A593DD9F', 'NEWBERG-558619', 'Newberg, Oregon', 'NEWBERG-OR',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-246ED005', 'WFALLS-FCF291', 'Oregon City, Oregon', 'WFALLS-OC',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-23 01:51:27'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-AEAE55D0', 'MISSION-6D4CA5', 'Mission Viejo, California', 'MISSIONVIEJO',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-24 20:51:51'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-F0243BEC', 'STJOSEPH-83AE15', 'Orange, California', 'ORANGE',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-24 20:51:51'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;

INSERT INTO locations (
    location_id, clinic_id, name, code, address, city, state, zip, phone, fax, epic_id, status, created_at, updated_at
) VALUES (
    'LOC-31C1F425', 'STJUDE-A0FD20', 'Fullerton, California', 'FULLERTON',
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, 'Active',
    COALESCE('2025-12-24 20:51:51'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-24 20:51:51'::TIMESTAMPTZ, NOW())
) ON CONFLICT (location_id) DO NOTHING;


ALTER TABLE clinics ENABLE TRIGGER ALL;
ALTER TABLE locations ENABLE TRIGGER ALL;

SELECT 'clinics' AS table_name, COUNT(*) AS row_count FROM clinics
UNION ALL SELECT 'locations', COUNT(*) FROM locations;