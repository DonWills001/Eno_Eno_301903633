-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject patient pk. Expected: pk_patient, SQLSTATE 23505.
INSERT INTO portfolio."patient" ("patient_id", "synthetic_ref", "display_name", "birth_date", "active")
VALUES (1001, 'SYN-P-5001', 'Case Patient', NULL, TRUE);

-- 2. reject patient unique. Expected: uq_patient_0, SQLSTATE 23505.
INSERT INTO portfolio."patient" ("patient_id", "synthetic_ref", "display_name", "birth_date", "active")
VALUES (5002, 'SYN-P-1001', 'Case Patient', NULL, TRUE);

-- 3. reject clinician pk. Expected: pk_clinician, SQLSTATE 23505.
INSERT INTO portfolio."clinician" ("clinician_id", "staff_code", "display_name", "specialty", "active")
VALUES (2001, 'SYN-C-5003', 'Case Clinician', 'Family medicine', TRUE);

-- 4. reject clinician unique. Expected: uq_clinician_0, SQLSTATE 23505.
INSERT INTO portfolio."clinician" ("clinician_id", "staff_code", "display_name", "specialty", "active")
VALUES (5004, 'SYN-C-2001', 'Case Clinician', 'Family medicine', TRUE);

-- 5. reject appointment pk. Expected: pk_appointment, SQLSTATE 23505.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason")
VALUES (3001, 1001, 2001, '2026-12-02T09:00:00Z', '2026-12-02T09:30:00Z', 'booked', 'Synthetic duplicate-key test');

-- 6. reject appointment patient fk. Expected: fk_appointment_0, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason")
VALUES (5006, 5999, 2001, '2026-12-03T09:00:00Z', '2026-12-03T09:30:00Z', 'booked', 'Synthetic foreign-key test');

-- 7. reject appointment clinician fk. Expected: fk_appointment_1, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason")
VALUES (5007, 1001, 5998, '2026-12-03T10:00:00Z', '2026-12-03T10:30:00Z', 'booked', 'Synthetic foreign-key test');

-- 8. reject encounter pk. Expected: pk_encounter, SQLSTATE 23505.
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "recorded_at", "summary", "follow_up_date")
VALUES (4001, 3002, '2026-12-01T10:25:00Z', 'Synthetic duplicate-key test', NULL);

-- 9. reject encounter unique. Expected: uq_encounter_0, SQLSTATE 23505.
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "recorded_at", "summary", "follow_up_date")
VALUES (5009, 3001, '2026-12-01T09:26:00Z', 'Synthetic unique-key test', NULL);

-- 10. reject encounter fk. Expected: fk_encounter_0, SQLSTATE 23503.
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "recorded_at", "summary", "follow_up_date")
VALUES (5010, 5997, '2026-12-03T10:25:00Z', 'Synthetic foreign-key test', NULL);

-- 11. reject appointment time order. Expected: appointment_time_order, SQLSTATE 23514.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason")
VALUES (5011, 1001, 2001, '2026-12-04T09:30:00Z', '2026-12-04T09:00:00Z', 'cancelled', 'Synthetic check test');

-- 12. reject active clinician slot. Expected: active_clinician_slot, SQLSTATE 23505.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "starts_at", "ends_at", "status", "reason")
VALUES (5012, 1001, 2001, '2026-12-01T09:00:00Z', '2026-12-01T09:20:00Z', 'confirmed', 'Synthetic partial-unique test');

-- 13. reject patient not null. Expected: synthetic_ref, SQLSTATE 23502.
INSERT INTO portfolio."patient" ("patient_id", "synthetic_ref", "display_name", "birth_date", "active")
VALUES (5013, NULL, 'Case Patient', NULL, TRUE);
