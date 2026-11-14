# Hospital / Clinic System — SQL queries

## 1. Show related appointment, patient, clinician, encounter records (up to 20).

```sql
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
```

| appointment_appointment_id | appointment_starts_at | patient_patient_id | patient_synthetic_ref | clinician_clinician_id | clinician_staff_code | encounter_encounter_id | encounter_recorded_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2026-12-01T09:00:00+00:00 | 1001 | SYN-P-1001 | 2001 | SYN-C-2001 | 4001 | 2026-12-01T09:25:00+00:00 |

## 2. Find appointment records where starts_at matches "2026-12-01T09:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."appointment"
WHERE "starts_at" IS NOT DISTINCT FROM '2026-12-01T09:00:00Z'
ORDER BY "appointment_id"
LIMIT 20;
```

| appointment_id | patient_id | clinician_id | starts_at | ends_at | status | reason |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 2026-12-01T09:00:00+00:00 | 2026-12-01T09:30:00+00:00 | booked | Routine synthetic visit |

## 3. Count appointment records for each patient_id (up to 20 groups).

```sql
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;
```

| patient_id | record_count |
| --- | --- |
| 1001 | 2 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.042 | 1.042, 1.032, 1.128 | Sort → Seq Scan | 112 |
| After index | 0.179 | 0.315, 0.179, 0.174 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.042 ms to 0.179 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.017..1.018 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.015..0.983 rows=20 loops=1)
Planning Time: 0.345 ms
Execution Time: 1.042 ms
```

### Before index, run 2

```text
Sort (actual time=1.005..1.007 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.014..0.972 rows=20 loops=1)
Planning Time: 0.328 ms
Execution Time: 1.032 ms
```

### Before index, run 3

```text
Sort (actual time=1.103..1.104 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.017..0.989 rows=20 loops=1)
Planning Time: 0.323 ms
Execution Time: 1.128 ms
```

### After index, run 1

```text
Sort (actual time=0.241..0.243 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.039..0.123 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.021..0.022 rows=20 loops=1)
Planning Time: 1.35 ms
Execution Time: 0.315 ms
```

### After index, run 2

```text
Sort (actual time=0.126..0.128 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.026..0.091 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.541 ms
Execution Time: 0.179 ms
```

### After index, run 3

```text
Sort (actual time=0.122..0.123 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.026..0.086 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.531 ms
Execution Time: 0.174 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Eno_Eno_301903633_P2_Queries.sql, then Eno_Eno_301903633_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Eno_Eno_301903633_P2_QueryResults.png) · [Index comparison](screenshots/Eno_Eno_301903633_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

