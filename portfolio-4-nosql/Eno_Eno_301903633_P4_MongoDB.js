// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("care_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("care_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "appointment_booked",
                    "appointment_rescheduled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "encounter"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "encounter_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("care_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "appointment_booked",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "encounter",
            "key": {
                "encounter_id": 4001
            },
            "snapshot": {
                "encounter_id": 4001,
                "appointment_id": 3001,
                "recorded_at": "2026-12-01T09:25:00Z",
                "summary": "Synthetic routine visit completed",
                "follow_up_date": null
            }
        },
        "embedded": {
            "patient": [
                {
                    "key": {
                        "patient_id": 1001
                    },
                    "snapshot": {
                        "patient_id": 1001,
                        "synthetic_ref": "SYN-P-1001",
                        "display_name": "Avery Example",
                        "birth_date": "1988-04-12",
                        "active": true
                    },
                    "via": [
                        "encounter.appointment_id → appointment.patient_id → patient"
                    ]
                }
            ],
            "clinician": [
                {
                    "key": {
                        "clinician_id": 2001
                    },
                    "snapshot": {
                        "clinician_id": 2001,
                        "staff_code": "SYN-C-2001",
                        "display_name": "Jordan Example",
                        "specialty": "Family medicine",
                        "active": true
                    },
                    "via": [
                        "encounter.appointment_id → appointment.clinician_id → clinician"
                    ]
                }
            ],
            "appointment": [
                {
                    "key": {
                        "appointment_id": 3001
                    },
                    "snapshot": {
                        "appointment_id": 3001,
                        "patient_id": 1001,
                        "clinician_id": 2001,
                        "starts_at": "2026-12-01T09:00:00Z",
                        "ends_at": "2026-12-01T09:30:00Z",
                        "status": "booked",
                        "reason": "Routine synthetic visit"
                    },
                    "via": [
                        "encounter.appointment_id → appointment"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "appointment_rescheduled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "encounter",
            "key": {
                "encounter_id": 4001
            },
            "snapshot": {
                "encounter_id": 4001,
                "appointment_id": 3001,
                "recorded_at": "2026-12-01T09:25:00Z",
                "summary": "Synthetic routine visit completed",
                "follow_up_date": null
            }
        },
        "embedded": {
            "patient": [
                {
                    "key": {
                        "patient_id": 1001
                    },
                    "snapshot": {
                        "patient_id": 1001,
                        "synthetic_ref": "SYN-P-1001",
                        "display_name": "Avery Example",
                        "birth_date": "1988-04-12",
                        "active": true
                    },
                    "via": [
                        "encounter.appointment_id → appointment.patient_id → patient"
                    ]
                }
            ],
            "clinician": [
                {
                    "key": {
                        "clinician_id": 2001
                    },
                    "snapshot": {
                        "clinician_id": 2001,
                        "staff_code": "SYN-C-2001",
                        "display_name": "Jordan Example",
                        "specialty": "Family medicine",
                        "active": true
                    },
                    "via": [
                        "encounter.appointment_id → appointment.clinician_id → clinician"
                    ]
                }
            ],
            "appointment": [
                {
                    "key": {
                        "appointment_id": 3001
                    },
                    "snapshot": {
                        "appointment_id": 3001,
                        "patient_id": 1001,
                        "clinician_id": 2001,
                        "starts_at": "2026-12-01T09:00:00Z",
                        "ends_at": "2026-12-01T09:30:00Z",
                        "status": "booked",
                        "reason": "Routine synthetic visit"
                    },
                    "via": [
                        "encounter.appointment_id → appointment"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "appointment",
                    "key": {
                        "appointment_id": 3001
                    },
                    "field": "reason",
                    "value": "Routine synthetic visit"
                },
                {
                    "entity": "encounter",
                    "key": {
                        "encounter_id": 4001
                    },
                    "field": "summary",
                    "value": "Synthetic routine visit completed"
                },
                {
                    "entity": "encounter",
                    "key": {
                        "encounter_id": 4001
                    },
                    "field": "follow_up_date",
                    "value": null
                }
            ],
            "examples": {
                "cancellation_code": "illustrative cancellation_code"
            }
        }
    }
]));
  await db.getCollection("care_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("care_events").find({"eventType":"appointment_booked"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("care_events").find({"source.key.encounter_id":4001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("care_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("care_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("care_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "appointment_booked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "encounter",
        "key": {
            "encounter_id": 4001
        },
        "snapshot": {
            "encounter_id": 4001,
            "appointment_id": 3001,
            "recorded_at": "2026-12-01T09:25:00Z",
            "summary": "Synthetic routine visit completed",
            "follow_up_date": null
        }
    },
    "embedded": {
        "patient": [
            {
                "key": {
                    "patient_id": 1001
                },
                "snapshot": {
                    "patient_id": 1001,
                    "synthetic_ref": "SYN-P-1001",
                    "display_name": "Avery Example",
                    "birth_date": "1988-04-12",
                    "active": true
                },
                "via": [
                    "encounter.appointment_id → appointment.patient_id → patient"
                ]
            }
        ],
        "clinician": [
            {
                "key": {
                    "clinician_id": 2001
                },
                "snapshot": {
                    "clinician_id": 2001,
                    "staff_code": "SYN-C-2001",
                    "display_name": "Jordan Example",
                    "specialty": "Family medicine",
                    "active": true
                },
                "via": [
                    "encounter.appointment_id → appointment.clinician_id → clinician"
                ]
            }
        ],
        "appointment": [
            {
                "key": {
                    "appointment_id": 3001
                },
                "snapshot": {
                    "appointment_id": 3001,
                    "patient_id": 1001,
                    "clinician_id": 2001,
                    "starts_at": "2026-12-01T09:00:00Z",
                    "ends_at": "2026-12-01T09:30:00Z",
                    "status": "booked",
                    "reason": "Routine synthetic visit"
                },
                "via": [
                    "encounter.appointment_id → appointment"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("care_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "appointment_booked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "encounter",
        "key": {
            "encounter_id": 4001
        },
        "snapshot": {
            "encounter_id": 4001,
            "appointment_id": 3001,
            "recorded_at": "2026-12-01T09:25:00Z",
            "summary": "Synthetic routine visit completed",
            "follow_up_date": null
        }
    },
    "embedded": {
        "patient": [
            {
                "key": {
                    "patient_id": 1001
                },
                "snapshot": {
                    "patient_id": 1001,
                    "synthetic_ref": "SYN-P-1001",
                    "display_name": "Avery Example",
                    "birth_date": "1988-04-12",
                    "active": true
                },
                "via": [
                    "encounter.appointment_id → appointment.patient_id → patient"
                ]
            }
        ],
        "clinician": [
            {
                "key": {
                    "clinician_id": 2001
                },
                "snapshot": {
                    "clinician_id": 2001,
                    "staff_code": "SYN-C-2001",
                    "display_name": "Jordan Example",
                    "specialty": "Family medicine",
                    "active": true
                },
                "via": [
                    "encounter.appointment_id → appointment.clinician_id → clinician"
                ]
            }
        ],
        "appointment": [
            {
                "key": {
                    "appointment_id": 3001
                },
                "snapshot": {
                    "appointment_id": 3001,
                    "patient_id": 1001,
                    "clinician_id": 2001,
                    "starts_at": "2026-12-01T09:00:00Z",
                    "ends_at": "2026-12-01T09:30:00Z",
                    "status": "booked",
                    "reason": "Routine synthetic visit"
                },
                "via": [
                    "encounter.appointment_id → appointment"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("care_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
