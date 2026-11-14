-- Fictional sample records for Hospital / Clinic System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."patient" ("patient_id", "synthetic_ref", "display_name", "birth_date", "active") VALUES (1001, 'SYN-P-1001', 'Avery Example', '1988-04-12', TRUE);
INSERT INTO portfolio."clinician" ("clinician_id", "staff_code", "display_name", "specialty", "active") VALUES (2001, 'SYN-C-2001', 'Jordan Example', 'Family medicine', TRUE);
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason") VALUES (3001, 1001, 2001, '2026-12-01T09:00:00Z', '2026-12-01T09:30:00Z', 'booked', 'Routine synthetic visit');
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason") VALUES (3002, 1001, 2001, '2026-12-01T10:00:00Z', '2026-12-01T10:30:00Z', 'cancelled', 'Synthetic schedule change');
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "recorded_at", "summary", "follow_up_date") VALUES (4001, 3001, '2026-12-01T09:25:00Z', 'Synthetic routine visit completed', NULL);
COMMIT;
