-- Show related appointment, patient, clinician, encounter records (up to 20).
SELECT t0."appointment_id" AS "appointment_appointment_id",
       t0."starts_at" AS "appointment_starts_at",
       t2."patient_id" AS "patient_patient_id",
       t2."synthetic_ref" AS "patient_synthetic_ref",
       t3."clinician_id" AS "clinician_clinician_id",
       t3."staff_code" AS "clinician_staff_code",
       t1."encounter_id" AS "encounter_encounter_id",
       t1."recorded_at" AS "encounter_recorded_at"
FROM portfolio."appointment" t0
JOIN portfolio."encounter" t1 ON t1."appointment_id" = t0."appointment_id"
JOIN portfolio."patient" t2 ON t0."patient_id" = t2."patient_id"
JOIN portfolio."clinician" t3 ON t0."clinician_id" = t3."clinician_id"
ORDER BY t0."appointment_id", t2."patient_id", t3."clinician_id", t1."encounter_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."appointment_id" AS "appointment_appointment_id",
       t0."starts_at" AS "appointment_starts_at",
       t2."patient_id" AS "patient_patient_id",
       t2."synthetic_ref" AS "patient_synthetic_ref",
       t3."clinician_id" AS "clinician_clinician_id",
       t3."staff_code" AS "clinician_staff_code",
       t1."encounter_id" AS "encounter_encounter_id",
       t1."recorded_at" AS "encounter_recorded_at"
FROM portfolio."appointment" t0
JOIN portfolio."encounter" t1 ON t1."appointment_id" = t0."appointment_id"
JOIN portfolio."patient" t2 ON t0."patient_id" = t2."patient_id"
JOIN portfolio."clinician" t3 ON t0."clinician_id" = t3."clinician_id"
ORDER BY t0."appointment_id", t2."patient_id", t3."clinician_id", t1."encounter_id"
LIMIT 20;

-- Find appointment records where starts_at matches "2026-12-01T09:00:00Z" (up to 20).
SELECT * FROM portfolio."appointment"
WHERE "starts_at" IS NOT DISTINCT FROM '2026-12-01T09:00:00Z'
ORDER BY "appointment_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."appointment"
WHERE "starts_at" IS NOT DISTINCT FROM '2026-12-01T09:00:00Z'
ORDER BY "appointment_id"
LIMIT 20;

-- Count appointment records for each patient_id (up to 20 groups).
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;
