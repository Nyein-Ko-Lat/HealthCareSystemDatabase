USE gh1043541_healthcare_db;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllRoles` ()   BEGIN
    SELECT * FROM roles where StatusCode = 'USE' ORDER BY name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_appointment` (IN `p_AppointmentID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE appointments
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE AppointmentID = p_AppointmentID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_doctor` (IN `p_DoctorID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE doctors
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE DoctorID = p_DoctorID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_doctor_schedule` (IN `p_DoctorScheduleID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE doctor_schedules
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE DoctorScheduleID = p_DoctorScheduleID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_family_history` (IN `p_FamilyHistoryID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE family_history
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE FamilyHistoryID = p_FamilyHistoryID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_patient` (IN `p_PatientID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE patients
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE PatientID = p_PatientID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_patient_condition` (IN `p_ConditionID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE patient_conditions
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE ConditionID = p_ConditionID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_patient_visit` (IN `p_VisitID` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    UPDATE patient_visits
    SET StatusCode = 'DEL',
        UpdatedBy = p_UpdatedBy
    WHERE VisitID = p_VisitID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_appointment_by_id` (IN `p_AppointmentID` BIGINT)   BEGIN
    SELECT * FROM v_appointments where `Appointment ID` = p_AppointmentID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_approved_appointment_by_date` (IN `p_AppointmentDate` DATE)   BEGIN
    SELECT * FROM v_appointments where Status = 'APR' AND DATE(`Appointment Date`) = p_AppointmentDate;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_approved_patient_visit_by_date` (IN `p_VisitDate` DATE)   BEGIN
    SELECT * FROM v_patient_visits where Status = 'APR' AND DATE(`Visit Date`) = p_VisitDate;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_available_doctors_schedule` (IN `p_DaysOfTheWeek` VARCHAR(20))   BEGIN
    IF p_DaysOfTheWeek = 'MONDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Monday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'TUESDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Tuesday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'WEDNESDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Wednesday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'THURSDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Thursday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'FRIDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Friday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'SATURDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Saturday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;

    ELSE
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Sunday Flag` = 1
        ORDER BY `Doctor Name`, `Start Time`;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_available_doctors_schedule_by_sepciality` (IN `p_DaysOfTheWeek` VARCHAR(20))   BEGIN
    IF p_DaysOfTheWeek = 'MONDAY' THEN
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsMon = 1
        GROUP BY dr.Specialty;

    ELSEIF p_DaysOfTheWeek = 'TUESDAY' THEN
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsTue = 1
        GROUP BY dr.Specialty;

    ELSEIF p_DaysOfTheWeek = 'WEDNESDAY' THEN
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsWed = 1
        GROUP BY dr.Specialty;

    ELSEIF p_DaysOfTheWeek = 'THURSDAY' THEN
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsThu = 1
        GROUP BY dr.Specialty;

    ELSEIF p_DaysOfTheWeek = 'FRIDAY' THEN
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsFri = 1
        GROUP BY dr.Specialty;

    ELSEIF p_DaysOfTheWeek = 'SATURDAY' THEN
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsSat = 1
        GROUP BY dr.Specialty;

    ELSE
        SELECT dr.Specialty,
               count(dr.DoctorID) as DoctorCount
        FROM doctor_schedules drsch
        INNER JOIN doctors dr on drsch.DoctorID = dr.DoctorID
        WHERE drsch.StatusCode <> 'DEL'
          AND drsch.IsSun = 1
        GROUP BY dr.Specialty;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_available_slots` (IN `p_DoctorID` BIGINT, IN `p_DaysOfTheWeek` VARCHAR(20), IN `p_ScheduleTime` TIME)   BEGIN
    IF p_DaysOfTheWeek = 'MONDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Monday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'TUESDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Tuesday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'WEDNESDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Wednesday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'THURSDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Thursday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'FRIDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Friday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;

    ELSEIF p_DaysOfTheWeek = 'SATURDAY' THEN
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Saturday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;

    ELSE
        SELECT *
        FROM v_doctor_schedules
        WHERE Status <> 'DEL'
          AND `Doctor ID` = p_DoctorID
          AND `Sunday Flag` = 1
          AND `Start Time`<= p_ScheduleTime
          AND TIMEDIFF(`End Time`,'00:10') >=  p_ScheduleTime
        ORDER BY `Doctor Name`, `Start Time`;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_avg_arrival_by_speciality` ()   BEGIN
    SELECT
    DAYNAME(pv.VisitDate) AS VisitDateOnly,
    AVG(TIMESTAMPDIFF(MINUTE, ap.AppointmentDate, pv.VisitDate))AS AverageArrival,
    dr.Specialty
FROM patient_visits pv
LEFT JOIN appointments ap ON pv.AppointmentID = ap.AppointmentID
INNER JOIN doctors dr ON pv.DoctorID = dr.DoctorID
GROUP BY
    DAYNAME(pv.VisitDate),
    dr.Specialty;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_avg_waiting_by_doctor` ()   BEGIN
SELECT
    CONCAT(dr.FirstName,' ', dr.LastName) as Doctor,
    dr.Specialty,
    AVG(TIMESTAMPDIFF(MINUTE, pv.VisitDate, pc.DiagnosedDate))AS AverageWaiting
FROM patient_conditions pc
LEFT JOIN patient_visits pv ON pc.VisitID = pv.VisitID
INNER JOIN doctors dr ON pc.DoctorID = dr.DoctorID
WHERE MONTH(pc.DiagnosedDate) = MONTH(CURRENT_DATE)
GROUP BY
    CONCAT(dr.FirstName,' ', dr.LastName),
    dr.Specialty
ORDER BY
   AVG(TIMESTAMPDIFF(MINUTE, pv.VisitDate, pc.DiagnosedDate));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_avg_waiting_by_speciality` ()   BEGIN
    SELECT
    DAYNAME(pc.DiagnosedDate) AS DiagnosedDate,
    AVG(TIMESTAMPDIFF(MINUTE, pv.VisitDate, pc.DiagnosedDate))AS AverageWaiting,
    dr.Specialty
FROM patient_conditions pc
LEFT JOIN patient_visits pv ON pc.VisitID = pv.VisitID
INNER JOIN doctors dr ON pc.DoctorID = dr.DoctorID
GROUP BY
    DAYNAME(pc.DiagnosedDate),
    dr.Specialty;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_doctor_by_id` (IN `d_DoctorId` BIGINT)   BEGIN
    SELECT * FROM v_doctors where `Doctor ID`= d_DoctorId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_doctor_by_Speciality` (IN `p_Speciality` NVARCHAR(50))   BEGIN
    SELECT * FROM gh1043541_healthcare_db.v_doctors
         where `Specialty` = p_Speciality AND Status <> 'DEL';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_doctor_schedule_by_doctor_id` (IN `p_DoctorID` BIGINT)   BEGIN
    SELECT *
    FROM v_doctor_schedules
    WHERE `Doctor ID` = p_DoctorID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_doctor_schedule_by_id` (IN `p_ScheduleID` BIGINT)   BEGIN
    SELECT *
    FROM v_doctor_schedules
    WHERE `Schedule ID` = p_ScheduleID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_patient_by_id` (IN `p_PatientID` BIGINT)   BEGIN
    SELECT * FROM v_patients where `Patient ID` = p_PatientID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_patient_visit_by_id` (IN `p_VisitID` BIGINT)   BEGIN
    SELECT * FROM v_patient_visits where `Visit ID` = p_VisitID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_top_doctor` (IN `topLimit` INT)   BEGIN
SELECT
    concat(dr.FirstName,' ',dr.LastName) as Doctor,
    dr.Specialty,
    Count(pv.PatientID) as PatientCount
FROM patient_conditions pv
INNER JOIN doctors dr on pv.DoctorID = dr.DoctorID
GROUP BY
    concat(dr.FirstName,' ',dr.LastName),
    dr.Specialty
ORDER BY Count(pv.PatientID) desc
LIMIT topLimit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_top_patient_diagnosed` (IN `topLimit` INT)   BEGIN
SELECT
    pv.ConditionName,
    Count(pv.PatientID) as PatientCount
FROM patient_conditions pv
GROUP BY
    ConditionName
ORDER BY Count(pv.PatientID) desc
LIMIT topLimit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_appointments` ()   BEGIN
    SELECT * FROM v_appointments
     WHERE Status <> 'DEL'
     ORDER BY "Appointment Date";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_doctors` ()   BEGIN
    SELECT * FROM v_doctors
     WHERE Status <> 'DEL'
     ORDER BY Specialty;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_doctor_schedules` ()   BEGIN
    SELECT * FROM v_doctor_schedules
     WHERE Status <> 'DEL'
    ORDER BY "Doctor Name", "Start Time";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_family_history` ()   BEGIN
    SELECT * FROM v_family_history
     WHERE Status <> 'DEL'
     ORDER BY "Relationship";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_family_history_by_patientId` (IN `p_PatientID` BIGINT)   BEGIN
    SELECT * FROM v_family_history where `Patient ID` = p_PatientID AND Status <> 'DEL' ORDER BY "Relationship";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_patients` ()   BEGIN
    SELECT * FROM v_patients
     WHERE Status <> 'DEL'
     ORDER BY "Last Name", "First Name";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_patient_conditions` ()   BEGIN
    SELECT * FROM v_patient_conditions
     WHERE Status <> 'DEL'
     ORDER BY "Diagnosed Date" DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_patient_visits` ()   BEGIN
    SELECT * FROM v_patient_visits
     WHERE Status <> 'DEL'
     ORDER BY "Visit Date" DESC;
END$$


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_appointment` (IN `p_AppointmentID` BIGINT, IN `p_PatientID` BIGINT, IN `p_DoctorID` BIGINT, IN `p_AppointmentDate` DATETIME, IN `p_Reason` TEXT, IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    IF p_AppointmentID IS NULL OR p_AppointmentID = 0 THEN
        INSERT INTO appointments (
            PatientID, DoctorID, AppointmentDate, Reason,
            StatusCode, CreatedBy, UpdatedBy
        )
        VALUES (
            p_PatientID, p_DoctorID, p_AppointmentDate, p_Reason,
            p_StatusCode, p_CreatedBy, p_UpdatedBy
        );

        SELECT LAST_INSERT_ID() AS AppointmentID;
    ELSE
        UPDATE appointments
        SET
            PatientID = p_PatientID,
            DoctorID = p_DoctorID,
            AppointmentDate = p_AppointmentDate,
            Reason = p_Reason,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy
        WHERE AppointmentID = p_AppointmentID;
        SELECT p_AppointmentID AS AppointmentID;
    END IF;
END$$


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_doctor` (IN `p_DoctorID` BIGINT, IN `p_FirstName` VARCHAR(50), IN `p_LastName` VARCHAR(50), IN `p_Specialty` VARCHAR(100), IN `p_PhoneNumber` VARCHAR(20), IN `p_Email` VARCHAR(100), IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    IF p_DoctorID IS NULL OR p_DoctorID = 0 THEN
        INSERT INTO doctors (
            FirstName, LastName, Specialty, PhoneNumber, Email,
            StatusCode, CreatedBy, UpdatedBy
        )
        VALUES (
            p_FirstName, p_LastName, p_Specialty, p_PhoneNumber, p_Email,
            p_StatusCode, p_CreatedBy, p_UpdatedBy
        );

        SELECT LAST_INSERT_ID() AS DoctorID;
    ELSE
        UPDATE doctors
        SET
            FirstName = p_FirstName,
            LastName = p_LastName,
            Specialty = p_Specialty,
            PhoneNumber = p_PhoneNumber,
            Email = p_Email,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy
        WHERE DoctorID = p_DoctorID;

        SELECT p_DoctorID AS DoctorID;
    END IF;
END$$


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_doctor_schedule` (IN `p_DoctorScheduleID` BIGINT, IN `p_DoctorID` BIGINT, IN `p_IsMon` TINYINT, IN `p_IsTue` TINYINT, IN `p_IsWed` TINYINT, IN `p_IsThu` TINYINT, IN `p_IsFri` TINYINT, IN `p_IsSat` TINYINT, IN `p_IsSun` TINYINT, IN `p_StartTime` TIME, IN `p_EndTime` TIME, IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    IF p_DoctorScheduleID IS NULL OR p_DoctorScheduleID = 0 THEN
        INSERT INTO doctor_schedules(
            DoctorID, IsMon, IsTue, IsWed, IsThu, IsFri, IsSat, IsSun,
            StartTime, EndTime, StatusCode, CreatedBy, UpdatedBy
        )
        VALUES(
            p_DoctorID, p_IsMon, p_IsTue, p_IsWed, p_IsThu, p_IsFri, p_IsSat, p_IsSun,
            p_StartTime, p_EndTime, p_StatusCode, p_CreatedBy, p_UpdatedBy
        )
        ON DUPLICATE KEY UPDATE
            IsMon = p_IsMon,
            IsTue = p_IsTue,
            IsWed = p_IsWed,
            IsThu = p_IsThu,
            IsFri = p_IsFri,
            IsSat = p_IsSat,
            IsSun = p_IsSun,
            StartTime = p_StartTime,
            EndTime = p_EndTime,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy;

        SELECT LAST_INSERT_ID() AS DoctorScheduleID;
    ELSE
        UPDATE doctor_schedules
        SET
            DoctorID = p_DoctorID,
            IsMon = p_IsMon,
            IsTue = p_IsTue,
            IsWed = p_IsWed,
            IsThu = p_IsThu,
            IsFri = p_IsFri,
            IsSat = p_IsSat,
            IsSun = p_IsSun,
            StartTime = p_StartTime,
            EndTime = p_EndTime,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy
        WHERE DoctorScheduleID = p_DoctorScheduleID;
        SELECT p_DoctorScheduleID AS DoctorScheduleID;
    END IF;
END$$


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_family_history` (IN `p_FamilyHistoryID` BIGINT, IN `p_PatientID` BIGINT, IN `p_MedicalCondition` VARCHAR(100), IN `p_Relationship` VARCHAR(100), IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN

    -- Insert if new OR Upsert if (PatientID, MedicalCondition, Relationship) already exists
    IF p_FamilyHistoryID IS NULL OR p_FamilyHistoryID = 0 THEN

        INSERT INTO family_history (
            PatientID, MedicalCondition, Relationship,
            StatusCode, CreatedBy, UpdatedBy
        )
        VALUES (
            p_PatientID, p_MedicalCondition, p_Relationship,
            p_StatusCode, p_CreatedBy, p_UpdatedBy
        )
        ON DUPLICATE KEY UPDATE
            StatusCode = VALUES(StatusCode),
            UpdatedBy = p_UpdatedBy;

        SELECT LAST_INSERT_ID() AS FamilyHistoryID;

    ELSE
        UPDATE family_history
        SET
            PatientID        = p_PatientID,
            MedicalCondition = p_MedicalCondition,
            Relationship     = p_Relationship,
            StatusCode       = p_StatusCode,
            UpdatedBy        = p_UpdatedBy
        WHERE FamilyHistoryID = p_FamilyHistoryID;
        SELECT p_FamilyHistoryID AS FamilyHistoryID;
    END IF;

END$$

DROP PROCEDURE if exists sp_save_patient;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_patient` (IN `p_PatientID` BIGINT, IN `p_FirstName` VARCHAR(50), IN `p_LastName` VARCHAR(50), IN `p_DateOfBirth` DATE, IN `p_Gender` VARCHAR(10), IN `p_BloodType` VARCHAR(5), IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN
    IF p_PatientID IS NULL OR p_PatientID = 0 THEN
        INSERT INTO patients (
            FirstName, LastName, DateOfBirth, Gender, BloodType,
            StatusCode, CreatedBy, UpdatedBy
        )
        VALUES (
            p_FirstName, p_LastName, p_DateOfBirth, p_Gender, p_BloodType,
            p_StatusCode, p_CreatedBy, p_UpdatedBy
        );

        SELECT LAST_INSERT_ID() AS PatientID;
    ELSE
        UPDATE patients
        SET
            FirstName = p_FirstName,
            LastName = p_LastName,
            DateOfBirth = p_DateOfBirth,
            Gender = p_Gender,
            BloodType = p_BloodType,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy
        WHERE PatientID = p_PatientID;
        SELECT p_PatientID AS PatientID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_patient_condition` (IN `p_ConditionID` BIGINT, IN `p_PatientID` BIGINT, IN `p_DoctorID` BIGINT, IN `p_VisitID` BIGINT, IN `p_DiagnosedDate` DATETIME, IN `p_ConditionName` VARCHAR(100), IN `p_DoctorNote` VARCHAR(512), IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;

        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_ConditionID IS NULL OR p_ConditionID = 0 THEN
        INSERT INTO patient_conditions (
            PatientID, DoctorID, VisitID, ConditionName, DoctorNote, DiagnosedDate,
            StatusCode, CreatedBy, UpdatedBy
        )
        VALUES (
            p_PatientID, p_DoctorID, p_VisitID, p_ConditionName, p_DoctorNote, p_DiagnosedDate,
            p_StatusCode, p_CreatedBy, p_UpdatedBy
        );

        SELECT LAST_INSERT_ID() AS ConditionID;
    ELSE
        UPDATE patient_conditions
        SET
            PatientID = p_PatientID,
            DoctorID = p_DoctorID,
            VisitID = p_VisitID,
            ConditionName = p_ConditionName,
            DoctorNote = p_DoctorNote,
            DiagnosedDate = p_DiagnosedDate,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy
        WHERE ConditionID = p_ConditionID;
        SELECT p_ConditionID AS ConditionID;
    END IF;

    IF p_VisitID IS NOT NULL AND p_VisitID > 0 THEN
        UPDATE patient_visits
        SET
            StatusCode = 'FIN',
            UpdatedBy = p_UpdatedBy
        WHERE VisitID = p_VisitID;
    END IF;

    COMMIT;

END$$;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save_patient_visit` (IN `p_VisitID` BIGINT, IN `p_DoctorID` BIGINT, IN `p_PatientID` BIGINT, IN `p_AppointmentID` BIGINT, IN `p_VisitDate` DATETIME, IN `p_VisitReason` VARCHAR(255), IN `p_StatusCode` VARCHAR(3), IN `p_CreatedBy` BIGINT, IN `p_UpdatedBy` BIGINT)   BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    IF p_VisitID IS NULL OR p_VisitID = 0 THEN
        INSERT INTO patient_visits (
            PatientID, DoctorID, AppointmentID, VisitDate, VisitReason,
            StatusCode, CreatedBy, UpdatedBy
        )
        VALUES (
            p_PatientID, p_DoctorID, p_AppointmentID, p_VisitDate, p_VisitReason,
            p_StatusCode, p_CreatedBy, p_UpdatedBy
        );

        SELECT LAST_INSERT_ID() AS VisitID;
    ELSE
        UPDATE patient_visits
        SET
            PatientID = p_PatientID,
            DoctorID = p_DoctorID,
            AppointmentID = p_AppointmentID,
            VisitDate = p_VisitDate,
            VisitReason = p_VisitReason,
            StatusCode = p_StatusCode,
            UpdatedBy = p_UpdatedBy
        WHERE VisitID = p_VisitID;
        SELECT p_VisitID AS VisitID;
    END IF;

    IF p_AppointmentID IS NOT NULL AND p_AppointmentID > 0 THEN
        UPDATE appointments
        SET
            StatusCode = 'FIN', -- Set to Finished
            UpdatedBy = p_UpdatedBy
        WHERE AppointmentID = p_AppointmentID;
    END IF;
    COMMIT;
END$$

DELIMITER ;
