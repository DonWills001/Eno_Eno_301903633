# Hospital / Clinic System — database design

My case study records patient, clinician, appointment, encounter.

## Users

- Synthetic scheduling staff
- Synthetic clinicians
- Synthetic database students

## Main operations

- Book and manage clinic appointments
- Record an encounter for an appointment
- Review appointment and encounter reports
- Benchmark appointment date filtering on synthetic rows

## Entities

| Entity | Information stored |
| --- | --- |
| patient | Stores a synthetic patient identity and basic exercise attributes. |
| clinician | Stores synthetic clinic staff identities and specialties. |
| appointment | Records a patient booking with one assigned clinician, schedule, status, and reason. |
| encounter | Stores synthetic clinical encounter details for a completed appointment. |

## patient

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| patient_id | BIGINT | PK | Yes |
| synthetic_ref | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| birth_date | DATE |  | No |
| active | BOOLEAN |  | Yes |
- Unique key: (synthetic_ref).

## clinician

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| clinician_id | BIGINT | PK | Yes |
| staff_code | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| specialty | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (staff_code).

## appointment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| appointment_id | BIGINT | PK | Yes |
| patient_id | BIGINT | FK | Yes |
| clinician_id | BIGINT | FK | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| ends_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| reason | TEXT |  | Yes |
- patient_id → patient.patient_id
- clinician_id → clinician.clinician_id

## encounter

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| encounter_id | BIGINT | PK | Yes |
| appointment_id | BIGINT | FK, Unique | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
| summary | TEXT |  | Yes |
| follow_up_date | DATE |  | No |
- appointment_id → appointment.appointment_id
- Unique key: (appointment_id).

## Relationships and business rules

- Each synthetic patient reference identifies at most one patient.
- Each staff code identifies at most one clinician.
- Every appointment must reference an existing patient.
- Every appointment must reference an existing clinician.
- A scheduled appointment must end after it starts.
- For booked or confirmed appointments, a clinician may have only one appointment at a given start time; cancelled appointments are excluded by the partial unique rule.
- Every encounter must reference an existing appointment.
- An appointment can have at most one encounter.

## Assumptions

- All records and values used in exercises are synthetic and contain no real patient information.
- Each appointment has one patient and one clinician; a clinician cannot have two active appointments starting at the same time.
- An appointment has at most one encounter, and an encounter references its appointment rather than duplicating patient or clinician relationships.
- Appointment timestamps are stored in UTC; ends_at must be later than starts_at.
- The active appointment statuses for the clinician-slot rule are booked and confirmed; cancelled appointments do not reserve a slot.

