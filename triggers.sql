USE gh1043541_healthcare_db;

--
-- Triggers `appointments`
--
DELIMITER $$
CREATE TRIGGER `trg_appointments_delete` AFTER DELETE ON `appointments` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, ChangedBy)
    VALUES(
        'appointments',
        OLD.AppointmentID,
        'DELETE',
        JSON_OBJECT(
            'PatientID', OLD.PatientID,
            'DoctorID', OLD.DoctorID,
            'AppointmentDate', OLD.AppointmentDate,
            'Reason', OLD.Reason,
            'StatusCode', OLD.StatusCode,
            'UpdatedBy', OLD.UpdatedBy,
            'UpdatedAt', OLD.UpdatedAt
        ),
        OLD.UpdatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_appointments_insert` AFTER INSERT ON `appointments` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, NewData, ChangedBy)
    VALUES(
        'appointments',
        NEW.AppointmentID,
        'INSERT',
        JSON_OBJECT(
            'PatientID', NEW.PatientID,
            'DoctorID', NEW.DoctorID,
            'AppointmentDate', NEW.AppointmentDate,
            'Reason', NEW.Reason,
            'StatusCode', NEW.StatusCode,
            'CreatedBy', NEW.CreatedBy,
            'CreatedAt', NEW.CreatedAt
        ),
        NEW.CreatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_appointments_update` AFTER UPDATE ON `appointments` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
    VALUES(
        'appointments',
        NEW.AppointmentID,
        'UPDATE',
        JSON_OBJECT(
            'PatientID', OLD.PatientID,
            'DoctorID', OLD.DoctorID,
            'AppointmentDate', OLD.AppointmentDate,
            'Reason', OLD.Reason,
            'StatusCode', OLD.StatusCode,
            'UpdatedBy', OLD.UpdatedBy,
            'CreatedBy', OLD.CreatedBy
        ),
        JSON_OBJECT(
            'PatientID', NEW.PatientID,
            'DoctorID', NEW.DoctorID,
            'AppointmentDate', NEW.AppointmentDate,
            'Reason', NEW.Reason,
            'StatusCode', NEW.StatusCode,
            'UpdatedBy', NEW.UpdatedBy,
            'UpdatedAt', NEW.UpdatedAt
        ),
        NEW.UpdatedBy
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Triggers `doctors`
--
DELIMITER $$
CREATE TRIGGER `trg_doctors_delete` AFTER DELETE ON `doctors` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, ChangedBy)
    VALUES(
        'doctors',
        OLD.DoctorID,
        'DELETE',
        JSON_OBJECT(
            'FirstName', OLD.FirstName,
            'LastName', OLD.LastName,
            'Specialty', OLD.Specialty,
            'PhoneNumber', OLD.PhoneNumber,
            'Email', OLD.Email,
            'StatusCode', OLD.StatusCode,
            'UpdatedBy', OLD.UpdatedBy,
            'UpdatedAt', OLD.UpdatedAt
        ),
        OLD.UpdatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_doctors_insert` AFTER INSERT ON `doctors` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, NewData, ChangedBy)
    VALUES(
        'doctors',
        NEW.DoctorID,
        'INSERT',
        JSON_OBJECT(
            'FirstName', NEW.FirstName,
            'LastName', NEW.LastName,
            'Specialty', NEW.Specialty,
            'PhoneNumber', NEW.PhoneNumber,
            'Email', NEW.Email,
            'StatusCode', NEW.StatusCode,
            'CreatedBy', NEW.CreatedBy,
            'CreatedAt', NEW.CreatedAt
        ),
        NEW.CreatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_doctors_update` AFTER UPDATE ON `doctors` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
    VALUES(
        'doctors',
        NEW.DoctorID,
        'UPDATE',
        JSON_OBJECT(
            'FirstName', OLD.FirstName,
            'LastName', OLD.LastName,
            'Specialty', OLD.Specialty,
            'PhoneNumber', OLD.PhoneNumber,
            'Email', OLD.Email,
            'StatusCode', OLD.StatusCode,
            'UpdatedBy', OLD.UpdatedBy,
            'CreatedBy', OLD.CreatedBy
        ),
        JSON_OBJECT(
            'FirstName', NEW.FirstName,
            'LastName', NEW.LastName,
            'Specialty', NEW.Specialty,
            'PhoneNumber', NEW.PhoneNumber,
            'Email', NEW.Email,
            'StatusCode', NEW.StatusCode,
            'UpdatedBy', NEW.UpdatedBy,
            'UpdatedAt', NEW.UpdatedAt
        ),
        NEW.UpdatedBy
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Triggers `doctor_schedules`
--
DELIMITER $$
CREATE TRIGGER `trg_doctor_schedules_delete` AFTER DELETE ON `doctor_schedules` FOR EACH ROW INSERT INTO audit_log (TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
VALUES (
    'doctor_schedules',
    OLD.DoctorScheduleID,
    'DELETE',
    JSON_OBJECT(
        'ScheduleID', OLD.DoctorScheduleID,
        'DoctorID', OLD.DoctorID,
        'IsMon', OLD.IsMon,
        'IsTue', OLD.IsTue,
        'IsWed', OLD.IsWed,
        'IsThu', OLD.IsThu,
        'IsFri', OLD.IsFri,
        'IsSat', OLD.IsSat,
        'IsSun', OLD.IsSun,
        'StartTime', OLD.StartTime,
        'EndTime', OLD.EndTime,
        'StatusCode', OLD.StatusCode,
        'CreatedBy', OLD.CreatedBy,
        'UpdatedBy', OLD.UpdatedBy,
        'CreatedAt', OLD.CreatedAt,
        'UpdatedAt', OLD.UpdatedAt
    ),
    NULL,
    OLD.UpdatedBy
)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_doctor_schedules_insert` AFTER INSERT ON `doctor_schedules` FOR EACH ROW INSERT INTO audit_log (TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
VALUES (
    'doctor_schedules',
    NEW.DoctorScheduleID,
    'INSERT',
    NULL,
    JSON_OBJECT(
        'ScheduleID', NEW.DoctorScheduleID,
        'DoctorID', NEW.DoctorID,
        'IsMon', NEW.IsMon,
        'IsTue', NEW.IsTue,
        'IsWed', NEW.IsWed,
        'IsThu', NEW.IsThu,
        'IsFri', NEW.IsFri,
        'IsSat', NEW.IsSat,
        'IsSun', NEW.IsSun,
        'StartTime', NEW.StartTime,
        'EndTime', NEW.EndTime,
        'StatusCode', NEW.StatusCode,
        'CreatedBy', NEW.CreatedBy,
        'UpdatedBy', NEW.UpdatedBy,
        'CreatedAt', NEW.CreatedAt,
        'UpdatedAt', NEW.UpdatedAt
    ),
    NEW.CreatedBy
)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_doctor_schedules_update` AFTER UPDATE ON `doctor_schedules` FOR EACH ROW INSERT INTO audit_log (TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
VALUES (
    'doctor_schedules',
    NEW.DoctorScheduleID,
    'UPDATE',
    JSON_OBJECT(
        'ScheduleID', OLD.DoctorScheduleID,
        'DoctorID', OLD.DoctorID,
        'IsMon', OLD.IsMon,
        'IsTue', OLD.IsTue,
        'IsWed', OLD.IsWed,
        'IsThu', OLD.IsThu,
        'IsFri', OLD.IsFri,
        'IsSat', OLD.IsSat,
        'IsSun', OLD.IsSun,
        'StartTime', OLD.StartTime,
        'EndTime', OLD.EndTime,
        'StatusCode', OLD.StatusCode,
        'CreatedBy', OLD.CreatedBy,
        'UpdatedBy', OLD.UpdatedBy,
        'CreatedAt', OLD.CreatedAt,
        'UpdatedAt', OLD.UpdatedAt
    ),
    JSON_OBJECT(
        'ScheduleID', NEW.DoctorScheduleID,
        'DoctorID', NEW.DoctorID,
        'IsMon', NEW.IsMon,
        'IsTue', NEW.IsTue,
        'IsWed', NEW.IsWed,
        'IsThu', NEW.IsThu,
        'IsFri', NEW.IsFri,
        'IsSat', NEW.IsSat,
        'IsSun', NEW.IsSun,
        'StartTime', NEW.StartTime,
        'EndTime', NEW.EndTime,
        'StatusCode', NEW.StatusCode,
        'CreatedBy', NEW.CreatedBy,
        'UpdatedBy', NEW.UpdatedBy,
        'CreatedAt', NEW.CreatedAt,
        'UpdatedAt', NEW.UpdatedAt
    ),
    NEW.UpdatedBy
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Triggers `family_history`
--
DELIMITER $$
CREATE TRIGGER `trg_family_history_delete` AFTER DELETE ON `family_history` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, ChangedBy)
    VALUES(
        'family_history',
        OLD.FamilyHistoryID,
        'DELETE',
        JSON_OBJECT(
            'PatientID', OLD.PatientID,
            'MedicalCondition', OLD.MedicalCondition,
            'Relationship', OLD.Relationship,
            'StatusCode', OLD.StatusCode,
            'UpdatedBy', OLD.UpdatedBy,
            'UpdatedAt', OLD.UpdatedAt
        ),
        OLD.UpdatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_family_history_insert` AFTER INSERT ON `family_history` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, NewData, ChangedBy)
    VALUES(
        'family_history',
        NEW.FamilyHistoryID,
        'INSERT',
        JSON_OBJECT(
            'PatientID', NEW.PatientID,
            'MedicalCondition', NEW.MedicalCondition,
            'Relationship', NEW.Relationship,
            'StatusCode', NEW.StatusCode,
            'CreatedBy', NEW.CreatedBy,
            'CreatedAt', NEW.CreatedAt
        ),
        NEW.CreatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_family_history_update` AFTER UPDATE ON `family_history` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
    VALUES(
        'family_history',
        NEW.FamilyHistoryID,
        'UPDATE',
        JSON_OBJECT(
            'PatientID', OLD.PatientID,
            'MedicalCondition', OLD.MedicalCondition,
            'Relationship', OLD.Relationship,
            'StatusCode', OLD.StatusCode,
            'UpdatedBy', OLD.UpdatedBy,
            'CreatedBy', OLD.CreatedBy
        ),
        JSON_OBJECT(
            'PatientID', NEW.PatientID,
            'MedicalCondition', NEW.MedicalCondition,
            'Relationship', NEW.Relationship,
            'StatusCode', NEW.StatusCode,
            'UpdatedBy', NEW.UpdatedBy,
            'UpdatedAt', NEW.UpdatedAt
        ),
        NEW.UpdatedBy
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Triggers `patients`
--
DELIMITER $$
CREATE TRIGGER `trg_patient_family_update` AFTER UPDATE ON `patients` FOR EACH ROW begin
    UPDATE family_history set
                              StatusCode = 'DEL'
    Where PatientID = New.PatientID;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_patients_delete` AFTER DELETE ON `patients` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, ChangedBy)
    VALUES(
        'patients',
        OLD.PatientID,
        'DELETE',
        JSON_OBJECT(
            'first_name', OLD.FirstName,
            'last_name', OLD.LastName,
            'gender', OLD.gender,
            'date_of_birth', OLD.DateOfBirth,
            'updated_by', OLD.UpdatedBy,
            'updated_at', OLD.UpdatedAt
        ),
        OLD.UpdatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_patients_insert` AFTER INSERT ON `patients` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, NewData, ChangedBy)
    VALUES(
        'patients',
        NEW.PatientID,
        'INSERT',
        JSON_OBJECT(
            'FirstName', NEW.FirstName,
            'LastName', NEW.LastName,
            'Gender', NEW.Gender,
            'DateOfBirth', NEW.DateOfBirth,
            'CreatedBy', NEW.CreatedBy,
            'CreatedAt', NEW.CreatedAt
        ),
        NEW.CreatedBy
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_patients_update` AFTER UPDATE ON `patients` FOR EACH ROW BEGIN
    INSERT INTO audit_log(TableName, RecordID, ActionType, OldData, NewData, ChangedBy)
    VALUES(
        'patients',
        NEW.PatientID,
        'UPDATE',
        JSON_OBJECT(
            'FirstName', OLD.FirstName,
            'LastName', OLD.LastName,
            'Gender', OLD.Gender,
            'DateOfBirth', OLD.DateOfBirth,
            'UpdatedBy', OLD.UpdatedBy,
            'CreatedBy', OLD.CreatedBy
        ),
        JSON_OBJECT(
            'FirstName', NEW.FirstName,
            'LastName', NEW.LastName,
            'Gender', NEW.Gender,
            'DateOfBirth', NEW.DateOfBirth,
            'UpdatedBy', NEW.UpdatedBy,
            'UpdatedAt', NEW.UpdatedAt
        ),
        NEW.UpdatedBy
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------
