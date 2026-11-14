# Hospital / Clinic System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| appointment_id | encounter records (list) |
| --- | --- |
| 3001 | [4001] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| encounter.encounter_id | encounter.appointment_id | encounter.summary | appointment.appointment_id | appointment.patient_id | appointment.clinician_id | appointment.status | patient.patient_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 3001 | Synthetic routine visit completed | 3001 | 1001 | 2001 | booked | 1001 |

Key: encounter_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## encounter_example

| encounter.encounter_id | encounter.appointment_id | encounter.summary | appointment.appointment_id | appointment.patient_id | appointment.clinician_id | appointment.status | patient.patient_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 3001 | Synthetic routine visit completed | 3001 | 1001 | 2001 | booked | 1001 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## patient

| patient_id | synthetic_ref | display_name | birth_date | active |
| --- | --- | --- | --- | --- |
| 1001 | SYN-P-1001 | Avery Example | 1988-04-12 | true |

## clinician

| clinician_id | staff_code | display_name | specialty | active |
| --- | --- | --- | --- | --- |
| 2001 | SYN-C-2001 | Jordan Example | Family medicine | true |

## appointment

| appointment_id | patient_id | clinician_id | starts_at | ends_at | status | reason |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 2026-12-01T09:00:00+00:00 | 2026-12-01T09:30:00+00:00 | booked | Routine synthetic visit |
| 3002 | 1001 | 2001 | 2026-12-01T10:00:00+00:00 | 2026-12-01T10:30:00+00:00 | cancelled | Synthetic schedule change |

## encounter

| encounter_id | appointment_id | recorded_at | summary | follow_up_date |
| --- | --- | --- | --- | --- |
| 4001 | 3001 | 2026-12-01T09:25:00+00:00 | Synthetic routine visit completed | NULL |

## Dependencies

- patient: (patient_id) → synthetic_ref, display_name, birth_date, active
- clinician: (clinician_id) → staff_code, display_name, specialty, active
- appointment: (appointment_id) → patient_id, clinician_id, starts_at, ends_at, status, reason
- encounter: (encounter_id) → appointment_id, recorded_at, summary, follow_up_date

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
