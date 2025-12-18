USE gh1043541_healthcare_db;
SELECT * From status_codes;
UPDATE patients SET BloodType='A+', UpdatedBy=1, UpdatedAt=NOW()
WHERE PatientID=12;

UPDATE patients SET LastName='Smith', UpdatedBy=1, UpdatedAt=NOW()
WHERE PatientID=25;

UPDATE patients SET Gender='Female', UpdatedBy=1, UpdatedAt=NOW()
WHERE PatientID=48;

UPDATE patients SET DateOfBirth='1985-04-12', UpdatedBy=1, UpdatedAt=NOW()
WHERE PatientID=76;

UPDATE patients SET FirstName='Michael', UpdatedBy=1, UpdatedAt=NOW()
WHERE PatientID=140;

UPDATE doctors SET Specialty='Cardiology', UpdatedBy=1, UpdatedAt=NOW()
WHERE DoctorID=2;

UPDATE doctors SET PhoneNumber='0998765432', UpdatedBy=1, UpdatedAt=NOW()
WHERE DoctorID=4;

UPDATE doctors SET Specialty='Orthopedics', UpdatedBy=1, UpdatedAt=NOW()
WHERE DoctorID=6;

UPDATE doctors SET Email='doctor10@hospital.com', UpdatedBy=1, UpdatedAt=NOW()
WHERE DoctorID=10;

UPDATE doctors SET FirstName='Sarah', UpdatedBy=1, UpdatedAt=NOW()
WHERE DoctorID=18;

UPDATE appointments SET AppointmentDate='2025-01-15 09:00', UpdatedBy=1, UpdatedAt=NOW()
WHERE AppointmentID=5 AND StatusCode='APR';

UPDATE appointments SET Reason='Routine Checkup', UpdatedBy=1, UpdatedAt=NOW()
WHERE AppointmentID=18 AND StatusCode='APR';

UPDATE appointments SET StatusCode='INA', UpdatedBy=1, UpdatedAt=NOW()
WHERE AppointmentID=33;

UPDATE appointments SET AppointmentDate='2025-02-01 14:00', UpdatedBy=1, UpdatedAt=NOW()
WHERE AppointmentID=47 AND StatusCode='APR';

UPDATE appointments SET Reason='Lab Review', UpdatedBy=1, UpdatedAt=NOW()
WHERE AppointmentID=82 AND StatusCode='APR';


UPDATE patient_visits SET VisitReason='General Checkup', UpdatedBy=1, UpdatedAt=NOW()
WHERE VisitID=3;

UPDATE patient_visits SET AppointmentID=null, VisitReason='Transferred to Specialist', UpdatedBy=1, UpdatedAt=NOW()
WHERE VisitID=14;

UPDATE patient_visits SET AppointmentID=null, VisitReason='Emergency Observation', UpdatedBy=1, UpdatedAt=NOW()
WHERE VisitID=29;

UPDATE patient_visits SET AppointmentID=null, StatusCode='FIN', UpdatedBy=1, UpdatedAt=NOW()
WHERE VisitID=41;

UPDATE patient_visits SET AppointmentID=null, VisitReason='Follow-up Visit', UpdatedBy=1, UpdatedAt=NOW()
WHERE VisitID=73;


UPDATE patient_conditions SET ConditionName='General Checkup', UpdatedBy=1, UpdatedAt=NOW()
WHERE ConditionID=6;

UPDATE patient_conditions SET ConditionName='Hypertension', UpdatedBy=1, UpdatedAt=NOW()
WHERE ConditionID=21;

UPDATE patient_conditions SET ConditionName='Diabetes Type II', UpdatedBy=1, UpdatedAt=NOW()
WHERE ConditionID=37;

UPDATE patient_conditions SET ConditionName='Transferred to Specialist', UpdatedBy=1, UpdatedAt=NOW()
WHERE ConditionID=59;

UPDATE patient_conditions SET ConditionName='Post Surgery Review', UpdatedBy=1, UpdatedAt=NOW()
WHERE ConditionID=84;
