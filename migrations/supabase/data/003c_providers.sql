-- ==========================================================================
-- PROVIDERS DATA (Normalized to many-to-many)
-- Exported: 2026-01-20T11:41:54.453247
-- ==========================================================================

ALTER TABLE providers DISABLE TRIGGER ALL;

-- PROVIDERS (deduplicated)
INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (1, 'Jessica Bautista, NP', '1184485492', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (2, 'Rachel Dise, PA', '1053077867', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (3, 'Christine Kemp, NP', '1215158639', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (4, 'Kristen Massimino, MD', '1720208556', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (5, 'Sarah Walcott-Sapp, MD', '1811263080', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (6, 'Nora Lersch, NP', '1639253115', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (7, 'Alex Conner, PA', '1417265075', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));

INSERT INTO providers (provider_id, name, npi, specialty, email, phone, is_active, created_at, updated_at)
VALUES (8, 'Janelle Yutzie, MD', '172020025', NULL, NULL, NULL, TRUE, COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()), COALESCE('2025-12-22 20:14:30'::TIMESTAMPTZ, NOW()));


-- PROVIDER_LOCATIONS (junction table)
INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (1, 'LOC-974B7894', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (2, 'LOC-974B7894', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (3, 'LOC-974B7894', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (4, 'LOC-974B7894', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (5, 'LOC-974B7894', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (3, 'LOC-AA07B2EF', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (6, 'LOC-AA07B2EF', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (7, 'LOC-B6790DB1', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (8, 'LOC-B6790DB1', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;

INSERT INTO provider_locations (provider_id, location_id, is_primary, created_at)
VALUES (3, 'LOC-B76B4670', TRUE, NOW())
ON CONFLICT (provider_id, location_id) DO NOTHING;


ALTER TABLE providers ENABLE TRIGGER ALL;

-- Reset sequence to next available ID
SELECT setval('providers_provider_id_seq', 9, false);

SELECT 'providers' AS table_name, COUNT(*) AS row_count FROM providers
UNION ALL SELECT 'provider_locations', COUNT(*) FROM provider_locations;