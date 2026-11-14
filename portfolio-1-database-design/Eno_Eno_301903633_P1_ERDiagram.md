# Hospital / Clinic System — ER diagram

```mermaid
erDiagram
    direction LR
    patient {
        bigint patient_id PK
        text synthetic_ref UK
        text display_name
        date birth_date "Optional"
        boolean active
    }
    clinician {
        bigint clinician_id PK
        text staff_code UK
        text display_name
        text specialty
        boolean active
    }
    appointment {
        bigint appointment_id PK
        bigint patient_id FK
        bigint clinician_id FK
        timestamptz starts_at
        timestamptz ends_at
        text status
        text reason
    }
    encounter {
        bigint encounter_id PK
        bigint appointment_id FK,UK
        timestamptz recorded_at
        text summary
        date follow_up_date "Optional"
    }
    patient ||--o{ appointment : "patient_id"
    clinician ||--o{ appointment : "clinician_id"
    appointment ||--o| encounter : "appointment_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Eno_Eno_301903633_ERDiagram.png)
