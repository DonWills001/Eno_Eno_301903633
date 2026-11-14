-- Hospital / Clinic System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."patient" (
  "patient_id" bigint NOT NULL,
  "synthetic_ref" text NOT NULL,
  "display_name" text NOT NULL,
  "birth_date" date,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_patient" PRIMARY KEY ("patient_id"),
  CONSTRAINT "uq_patient_0" UNIQUE ("synthetic_ref")
);
CREATE TABLE portfolio."clinician" (
  "clinician_id" bigint NOT NULL,
  "staff_code" text NOT NULL,
  "display_name" text NOT NULL,
  "specialty" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_clinician" PRIMARY KEY ("clinician_id"),
  CONSTRAINT "uq_clinician_0" UNIQUE ("staff_code")
);
CREATE TABLE portfolio."appointment" (
  "appointment_id" bigint NOT NULL,
  "patient_id" bigint NOT NULL,
  "clinician_id" bigint NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "ends_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "reason" text NOT NULL,
  CONSTRAINT "pk_appointment" PRIMARY KEY ("appointment_id")
);
CREATE TABLE portfolio."encounter" (
  "encounter_id" bigint NOT NULL,
  "appointment_id" bigint NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  "summary" text NOT NULL,
  "follow_up_date" date,
  CONSTRAINT "pk_encounter" PRIMARY KEY ("encounter_id"),
  CONSTRAINT "uq_encounter_0" UNIQUE ("appointment_id")
);
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "fk_appointment_0" FOREIGN KEY ("patient_id") REFERENCES portfolio."patient" ("patient_id");
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "fk_appointment_1" FOREIGN KEY ("clinician_id") REFERENCES portfolio."clinician" ("clinician_id");
ALTER TABLE portfolio."encounter" ADD CONSTRAINT "fk_encounter_0" FOREIGN KEY ("appointment_id") REFERENCES portfolio."appointment" ("appointment_id");
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "appointment_time_order" CHECK ("ends_at" > "starts_at");
CREATE UNIQUE INDEX "active_clinician_slot" ON portfolio."appointment" ("clinician_id", "starts_at") WHERE (("status" = 'booked') OR ("status" = 'confirmed'));
COMMIT;
