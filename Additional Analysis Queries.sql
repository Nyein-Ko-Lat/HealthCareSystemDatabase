USE gh1043541_healthcare_db;

### Query for Patient make appointment however not visit without cancel.
SELECT
    a.AppointmentID,
    concat(p.FirstName,' ',p.LastName) AS "Patient Name",
    concat(d.FirstName,' ',d.LastName) AS "Doctor Name",
    DATE (a.AppointmentDate) AS "Appointment Date"
FROM appointments a
LEFT OUTER JOIN patient_visits v ON a.AppointmentID = v.AppointmentID
INNER JOIN patients p ON a.PatientID = p.PatientID
INNER JOIN doctors d on a.DoctorID = d.DoctorID
WHERE v.AppointmentID IS NULL
  AND a.StatusCode <> 'DEL'
    AND DATE(a.AppointmentDate) < current_date;

### Top patient coming to clinic by their condition and dr's specialty
CALL sp_get_top_patient_diagnosed(10);

SELECT
    dr.Specialty,
    Count(pv.PatientID) as PatientCount
FROM patient_conditions pv
INNER JOIN doctors dr on pv.DoctorID = dr.DoctorID
GROUP BY
    dr.Specialty
ORDER BY Count(pv.PatientID) desc
LIMIT 5;

##Which dr has more appointment
SELECT
    d.DoctorID,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(CASE WHEN a.AppointmentDate >= CURRENT_DATE THEN 1 ELSE 0 END) AS UpcomingAppointments,
    SUM(CASE WHEN a.AppointmentDate < CURRENT_DATE THEN 1 ELSE 0 END) AS PastAppointments
FROM doctors d
LEFT JOIN appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, DoctorName
ORDER BY TotalAppointments DESC;


##Patient that make appointment and not visit
SELECT
    CONCAT(p.FirstName, ' ', p.LastName) AS "Patient Name",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Doctor Name",
    COUNT(a.AppointmentID) "Appointment Count"
FROM appointments a
LEFT JOIN patient_visits v ON a.AppointmentID = v.AppointmentID
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
WHERE v.VisitID IS NULL
  AND a.AppointmentDate < CURRENT_DATE
GROUP BY
    p.FirstName, p.LastName,"Patient Name",
    d.FirstName, d.LastName,"Doctor Name"
ORDER BY "Appointment Count" DESC;

#Most common reason that come to each doctor
SELECT
    d.DoctorID,
    CONCAT(d.FirstName, ' ', d.LastName) AS "Doctor Name",
    pc.ConditionName,
    COUNT(pc.ConditionID) AS "Condition Count"
FROM patient_conditions pc
JOIN doctors d ON pc.DoctorID = d.DoctorID
GROUP BY d.DoctorID, "Doctor Name", pc.ConditionName
ORDER BY d.DoctorID, "Condition Count" DESC;