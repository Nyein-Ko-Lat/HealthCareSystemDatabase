USE gh1043541_healthcare_db;

DELETE FROM patient_conditions
    WHERE PatientID = 15 OR PatientID=39 OR PatientID=72 OR PatientID=101 OR PatientID=145;
DELETE FROM patient_conditions
    WHERE DoctorID = 18 OR DoctorID = 16;

DELETE FROM patient_visits
    WHERE PatientID = 15 OR PatientID=39 OR PatientID=72 OR PatientID=101 OR PatientID=145;
DELETE FROM patient_visits
    WHERE DoctorID = 18 OR DoctorID = 16;

DELETE FROM appointments
    WHERE PatientID = 15 OR PatientID=39 OR PatientID=72 OR PatientID=101 OR PatientID=145;
DELETE FROM patient_visits
    WHERE DoctorID = 18 OR DoctorID = 16;


DELETE FROM family_history
    WHERE PatientID = 15 OR PatientID=39 OR PatientID=72 OR PatientID=101 OR PatientID=145;

DELETE FROM patients WHERE PatientID=15;
DELETE FROM patients WHERE PatientID=39;
DELETE FROM patients WHERE PatientID=72;
DELETE FROM patients WHERE PatientID=101;
DELETE FROM patients WHERE PatientID=145;

DELETE FROM doctor_schedules where DoctorID = 18 AND StatusCode = 'APR';
DELETE FROM doctor_schedules where DoctorID = 16 AND StatusCode = 'APR';

DELETE FROM doctors where DoctorID = 18;
DELETE FROM doctors where DoctorID = 16;