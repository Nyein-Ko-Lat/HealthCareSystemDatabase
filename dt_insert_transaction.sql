use gh1043541_healthcare_db;


DELIMITER $$

-- 1. Define a temporary procedure to handle the loop and random generation
CREATE PROCEDURE temp_insert_random_schedules()
BEGIN
    -- Variables for the loop
    DECLARE current_doctor_id INT DEFAULT 1;
    DECLARE schedule_count INT DEFAULT 20;

    -- Variables for the schedule data
    DECLARE rand_start_time TIME;
    DECLARE rand_end_time TIME;
    DECLARE day_mask INT;

    -- Loop through Doctor IDs from 1 to 20
    WHILE current_doctor_id <= schedule_count DO

        -- Generate random StartTime: Between 08:00:00 and 10:00:00
        -- Time range: (10 - 8) hours * 3600 seconds/hr = 7200 seconds
        SET rand_start_time = ADDTIME('08:00:00', SEC_TO_TIME(FLOOR(RAND() * 7200)));

        -- Generate random EndTime: Between 16:00:00 and 18:00:00 (must be after StartTime)
        -- Time range: (18 - 16) hours * 3600 seconds/hr = 7200 seconds
        SET rand_end_time = ADDTIME('16:00:00', SEC_TO_TIME(FLOOR(RAND() * 7200)));

        -- Ensure EndTime is at least 6 hours after StartTime, or regenerate
        IF TIME_TO_SEC(TIMEDIFF(rand_end_time, rand_start_time)) < 21600 THEN -- 6 hours = 21600 seconds
             SET rand_end_time = ADDTIME(rand_start_time, SEC_TO_TIME(21600 + FLOOR(RAND() * 7200))); -- Set at least 6h later, up to 8h later
        END IF;


        -- Generate a random day mask (integer between 0 and 127) to select days
        -- Bit 0 = Sun, Bit 1 = Mon, ... Bit 6 = Sat. We will favor weekdays.
        -- We will generate 3-5 random days, mainly Mon-Fri (bits 1-5).
        SET day_mask = 0;

        -- Force selection of 3 to 5 random days from Mon-Fri (bits 1 to 5)
        SET @days_to_select = 3 + FLOOR(RAND() * 3); -- Select 3, 4, or 5 days

        WHILE @days_to_select > 0 DO
            -- Randomly pick a weekday bit (1=Mon to 5=Fri)
            SET @random_day_bit = 1 + FLOOR(RAND() * 5);

            -- If the bit isn't set, set it now (2^bit)
            IF (day_mask & POW(2, @random_day_bit)) = 0 THEN
                SET day_mask = day_mask | POW(2, @random_day_bit);
                SET @days_to_select = @days_to_select - 1;
            END IF;
        END WHILE;

        -- Optionally add Sat/Sun with a 20% chance
        IF RAND() < 0.2 THEN SET day_mask = day_mask | 64; END IF; -- Sat (2^6)
        IF RAND() < 0.2 THEN SET day_mask = day_mask | 1; END IF;  -- Sun (2^0)


        -- Call sp_save_doctor_schedule
        CALL gh1043541_healthcare_db.sp_save_doctor_schedule(
            NULL,                       -- p_DoctorScheduleID: NULL for new insert
            current_doctor_id,          -- p_DoctorID: 1 through 20
            (day_mask & 2) >> 1,        -- p_IsMon (Bit 1)
            (day_mask & 4) >> 2,        -- p_IsTue (Bit 2)
            (day_mask & 8) >> 3,        -- p_IsWed (Bit 3)
            (day_mask & 16) >> 4,       -- p_IsThu (Bit 4)
            (day_mask & 32) >> 5,       -- p_IsFri (Bit 5)
            (day_mask & 64) >> 6,       -- p_IsSat (Bit 6)
            (day_mask & 1),             -- p_IsSun (Bit 0)
            rand_start_time,            -- p_StartTime
            rand_end_time,              -- p_EndTime
            'APR',                      -- p_StatusCode: APRive
            1,                          -- p_CreatedBy: ID 1
            1                           -- p_UpdatedBy: ID 1
        );

        SET current_doctor_id = current_doctor_id + 1;
    END WHILE;
END$$

-- 2. Execute the temporary procedure
CALL temp_insert_random_schedules()$$

-- 3. Drop the temporary procedure immediately after execution
DROP PROCEDURE temp_insert_random_schedules$$

DELIMITER ;

#end of schedule

#start of Appointment
-- Set the current date for reference: 2025-12-11 (Thursday)

-- ----------------------------------------------------
-- 1. Appointments for Today: Thursday, 2025-12-11 (approx. 20 appointments)
-- ----------------------------------------------------

-- Doctor 1 (Available: IsThu=1). Schedule: 08:18:36 - 16:15:01
CALL sp_save_appointment(0, 53, 1, '2025-12-11 11:45:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 11, 1, '2025-12-11 14:10:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 39, 1, '2025-12-11 09:30:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 2 (Available: IsThu=1). Schedule: 09:53:52 - 16:47:31
CALL sp_save_appointment(0, 22, 2, '2025-12-11 15:05:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 7, 2, '2025-12-11 10:20:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 3 (Available: IsThu=1). Schedule: 08:31:49 - 16:42:57
CALL sp_save_appointment(0, 4, 3, '2025-12-11 13:50:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 31, 3, '2025-12-11 09:15:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 4 (Available: IsThu=1). Schedule: 08:37:52 - 16:15:18
CALL sp_save_appointment(0, 59, 4, '2025-12-11 15:30:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 6 (Available: IsThu=1). Schedule: 09:44:27 - 16:08:09
CALL sp_save_appointment(0, 2, 6, '2025-12-11 11:00:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 7 (Available: IsThu=1). Schedule: 08:20:16 - 16:51:29
CALL sp_save_appointment(0, 48, 7, '2025-12-11 14:35:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 8 (Available: IsThu=1). Schedule: 09:33:16 - 16:50:33
CALL sp_save_appointment(0, 15, 8, '2025-12-11 10:00:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 9 (Available: IsThu=1). Schedule: 08:38:22 - 16:40:01
CALL sp_save_appointment(0, 5, 9, '2025-12-11 12:05:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 10 (Available: IsThu=1). Schedule: 08:42:20 - 17:29:35
CALL sp_save_appointment(0, 27, 10, '2025-12-11 16:00:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 11 (Available: IsThu=1). Schedule: 09:11:35 - 16:07:50
CALL sp_save_appointment(0, 36, 11, '2025-12-11 13:40:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 12 (Available: IsThu=1). Schedule: 08:00:07 - 17:34:28
CALL sp_save_appointment(0, 19, 12, '2025-12-11 08:55:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 14 (Available: IsThu=1). Schedule: 08:05:59 - 16:07:00
CALL sp_save_appointment(0, 43, 14, '2025-12-11 15:50:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 15 (Available: IsThu=1). Schedule: 08:31:47 - 17:55:52
CALL sp_save_appointment(0, 51, 15, '2025-12-11 11:25:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 16 (Available: IsThu=1). Schedule: 08:49:55 - 17:54:31
CALL sp_save_appointment(0, 1, 16, '2025-12-11 16:45:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 17 (Available: IsThu=1). Schedule: 09:20:31 - 16:46:19
CALL sp_save_appointment(0, 58, 17, '2025-12-11 10:45:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 18 (Available: IsThu=1). Schedule: 08:34:55 - 17:04:26
CALL sp_save_appointment(0, 14, 18, '2025-12-11 12:30:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 20 (Available: IsThu=1). Schedule: 08:15:07 - 16:48:01
CALL sp_save_appointment(0, 33, 20, '2025-12-11 13:00:00', 'Routine Checkup', 'APR', 1, 1);

-- ----------------------------------------------------
-- 2. Appointments for Tomorrow: Friday, 2025-12-12 (approx. 20 appointments)
-- ----------------------------------------------------

-- Doctor 2 (Available: IsFri=1). Schedule: 09:53:52 - 16:47:31
CALL sp_save_appointment(0, 18, 2, '2025-12-12 11:15:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 45, 2, '2025-12-12 15:20:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 3 (Available: IsFri=1). Schedule: 08:31:49 - 16:42:57
CALL sp_save_appointment(0, 60, 3, '2025-12-12 09:40:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 24, 3, '2025-12-12 14:05:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 4 (Available: IsFri=1). Schedule: 08:37:52 - 16:15:18
CALL sp_save_appointment(0, 9, 4, '2025-12-12 10:50:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 6 (Available: IsFri=1). Schedule: 09:44:27 - 16:08:09
CALL sp_save_appointment(0, 41, 6, '2025-12-12 12:45:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 7 (Available: IsFri=1). Schedule: 08:20:16 - 16:51:29
CALL sp_save_appointment(0, 16, 7, '2025-12-12 16:10:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 8 (Available: IsFri=1). Schedule: 09:33:16 - 16:50:33
CALL sp_save_appointment(0, 37, 8, '2025-12-12 09:55:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 9 (Available: IsFri=1). Schedule: 08:38:22 - 16:40:01
CALL sp_save_appointment(0, 52, 9, '2025-12-12 11:35:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 10 (Available: IsFri=1). Schedule: 08:42:20 - 17:29:35
CALL sp_save_appointment(0, 8, 10, '2025-12-12 15:45:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 11 (Available: IsFri=1). Schedule: 09:11:35 - 16:07:50
CALL sp_save_appointment(0, 29, 11, '2025-12-12 10:10:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 12 (Available: IsFri=1). Schedule: 08:00:07 - 17:34:28
CALL sp_save_appointment(0, 55, 12, '2025-12-12 13:25:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 13 (Available: IsFri=1). Schedule: 09:35:26 - 17:00:19
CALL sp_save_appointment(0, 3, 13, '2025-12-12 16:30:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 17 (Available: IsFri=1). Schedule: 09:20:31 - 16:46:19
CALL sp_save_appointment(0, 49, 17, '2025-12-12 11:55:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 18 (Available: IsFri=1). Schedule: 08:34:55 - 17:04:26
CALL sp_save_appointment(0, 10, 18, '2025-12-12 15:10:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 19 (Available: IsFri=1). Schedule: 09:11:16 - 17:37:39
CALL sp_save_appointment(0, 26, 19, '2025-12-12 10:30:00', 'New Patient Consultation', 'APR', 1, 1);

-- Doctor 20 (Available: IsFri=1). Schedule: 08:15:07 - 16:48:01
CALL sp_save_appointment(0, 44, 20, '2025-12-12 12:20:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 17, 20, '2025-12-12 13:35:00', 'Routine Checkup', 'APR', 1, 1);

-- ----------------------------------------------------
-- 3. Appointments for Next Day: Saturday, 2025-12-13 (approx. 20 appointments)
-- ----------------------------------------------------

-- Doctor 1 (Available: IsSat=1). Schedule: 08:18:36 - 16:15:01
CALL sp_save_appointment(0, 21, 1, '2025-12-13 11:10:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 50, 1, '2025-12-13 14:00:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 2 (Available: IsSat=1). Schedule: 09:53:52 - 16:47:31
CALL sp_save_appointment(0, 34, 2, '2025-12-13 15:25:00', 'Routine Checkup', 'APR', 1, 1);

-- Doctor 6 (Available: IsSat=1). Schedule: 09:44:27 - 16:08:09
CALL sp_save_appointment(0, 6, 6, '2025-12-13 10:25:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 47, 6, '2025-12-13 12:55:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 15 (Available: IsSat=1). Schedule: 08:31:47 - 17:55:52
CALL sp_save_appointment(0, 12, 15, '2025-12-13 16:35:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 56, 15, '2025-12-13 09:05:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 28, 15, '2025-12-13 13:15:00', 'Follow-up Visit', 'APR', 1, 1);

-- Doctor 18 (Available: IsSat=1). Schedule: 08:34:55 - 17:04:26
CALL sp_save_appointment(0, 42, 18, '2025-12-13 11:40:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 13, 18, '2025-12-13 15:00:00', 'New Patient Consultation', 'APR', 1, 1);

-- Remaining appointments to reach 60, distributing them randomly across the 3 days.

-- Thursday (Dec 11)
CALL sp_save_appointment(0, 20, 3, '2025-12-11 12:15:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 35, 10, '2025-12-11 11:05:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 54, 18, '2025-12-11 09:25:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 40, 4, '2025-12-11 14:40:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 25, 12, '2025-12-11 17:15:00', 'Follow-up Visit', 'APR', 1, 1);

-- Friday (Dec 12)
CALL sp_save_appointment(0, 1, 17, '2025-12-12 14:55:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 30, 8, '2025-12-12 13:05:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 57, 10, '2025-12-12 17:00:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 23, 7, '2025-12-12 11:20:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 38, 4, '2025-12-12 09:10:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 14, 12, '2025-12-12 08:30:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 46, 11, '2025-12-12 14:30:00', 'Routine Checkup', 'APR', 1, 1);

-- Saturday (Dec 13)
CALL sp_save_appointment(0, 32, 15, '2025-12-13 14:25:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 17, 1, '2025-12-13 08:45:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 5, 18, '2025-12-13 16:05:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 2, 6, '2025-12-13 14:45:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 53, 2, '2025-12-13 10:40:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 19, 15, '2025-12-13 17:30:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 4, 18, '2025-12-13 09:40:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 43, 6, '2025-12-13 15:40:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 36, 15, '2025-12-13 11:55:00', 'Routine Checkup', 'APR', 1, 1);

-- Sunday (Dec 14)
CALL sp_save_appointment(0, 81, 15, '2025-12-14 15:25:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 75, 1, '2025-12-14 09:40:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 90, 18, '2025-12-14 15:15:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 105, 6, '2025-12-14 11:11:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 63, 2, '2025-12-14 9:30:00', 'New Patient Consultation', 'APR', 1, 1);
CALL sp_save_appointment(0, 66, 15, '2025-12-14 11:30:00', 'Routine Checkup', 'APR', 1, 1);
CALL sp_save_appointment(0, 1, 18, '2025-12-14 09:40:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 43, 6, '2025-12-14 08:40:00', 'Follow-up Visit', 'APR', 1, 1);
CALL sp_save_appointment(0, 68, 15, '2025-12-14 19:55:00', 'Routine Checkup', 'APR', 1, 1);

#end Appointment data
#start patient visit data
-- =========================
-- 70 Appointment-based Visits
-- =========================
CALL sp_save_patient_visit(0,1,53,1,'2025-12-11 11:43:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,1,11,2,'2025-12-11 14:12:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,1,39,3,'2025-12-11 09:32:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,2,22,4,'2025-12-11 15:07:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,2,7,5,'2025-12-11 10:18:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,3,4,6,'2025-12-11 13:53:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,3,31,7,'2025-12-11 09:14:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,4,59,8,'2025-12-11 15:28:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,6,2,9,'2025-12-11 11:03:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,7,48,10,'2025-12-11 14:37:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,8,15,11,'2025-12-11 10:02:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,9,5,12,'2025-12-11 12:03:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,10,27,13,'2025-12-11 15:59:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,11,36,14,'2025-12-11 13:42:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,12,19,15,'2025-12-11 08:53:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,14,43,16,'2025-12-11 15:52:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,15,51,17,'2025-12-11 11:27:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,16,1,18,'2025-12-11 16:47:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,17,58,19,'2025-12-11 10:44:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,18,14,20,'2025-12-11 12:32:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,3,60,24,'2025-12-12 09:41:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,3,24,25,'2025-12-12 14:06:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,4,9,26,'2025-12-12 10:52:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,6,41,27,'2025-12-12 12:44:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,7,16,28,'2025-12-12 16:08:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,8,37,29,'2025-12-12 09:57:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,9,52,30,'2025-12-12 11:36:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,10,8,31,'2025-12-12 15:46:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,11,29,32,'2025-12-12 10:09:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,12,55,33,'2025-12-12 13:26:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,13,3,34,'2025-12-12 16:31:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,17,49,35,'2025-12-12 11:57:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,20,17,39,'2025-12-12 13:36:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,1,21,40,'2025-12-13 11:12:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,1,50,41,'2025-12-13 14:02:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,2,34,42,'2025-12-13 15:27:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,6,6,43,'2025-12-13 10:27:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,6,47,44,'2025-12-13 12:56:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,15,12,45,'2025-12-13 16:36:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,15,56,46,'2025-12-13 09:07:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,15,28,47,'2025-12-13 13:17:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,18,42,48,'2025-12-13 11:42:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,18,13,49,'2025-12-13 15:02:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,3,20,50,'2025-12-11 12:16:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,10,35,51,'2025-12-11 11:06:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,18,54,52,'2025-12-11 09:27:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,4,40,53,'2025-12-11 14:42:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,12,25,54,'2025-12-11 17:16:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,17,1,55,'2025-12-12 14:57:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,8,30,56,'2025-12-12 13:07:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,10,57,57,'2025-12-12 17:02:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,7,23,58,'2025-12-12 11:22:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,4,38,59,'2025-12-12 09:12:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,12,14,60,'2025-12-12 08:32:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,11,46,61,'2025-12-12 14:31:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,15,32,62,'2025-12-13 14:28:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,1,17,63,'2025-12-13 08:48:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,18,5,64,'2025-12-13 16:07:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,6,2,65,'2025-12-13 14:47:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,2,53,66,'2025-12-13 10:42:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,15,19,67,'2025-12-13 17:32:00','Routine Checkup','APR',1,1);
CALL sp_save_patient_visit(0,18,4,68,'2025-12-13 09:42:00','New Patient Consultation','APR',1,1);
CALL sp_save_patient_visit(0,6,43,69,'2025-12-13 15:42:00','Follow-up Visit','APR',1,1);
CALL sp_save_patient_visit(0,15,36,70,'2025-12-13 11:57:00','Routine Checkup','APR',1,1);

-- =========================
-- 30 Emergency Visits (AppointmentID = NULL)
-- =========================
CALL sp_save_patient_visit(0,1,70,NULL,'2025-12-11 08:50:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,2,71,NULL,'2025-12-11 09:10:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,3,72,NULL,'2025-12-11 10:25:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,4,73,NULL,'2025-12-11 11:15:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,5,74,NULL,'2025-12-11 12:40:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,6,75,NULL,'2025-12-11 13:05:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,7,76,NULL,'2025-12-11 14:22:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,8,77,NULL,'2025-12-11 15:10:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,9,78,NULL,'2025-12-11 16:00:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,10,79,NULL,'2025-12-12 08:40:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,11,80,NULL,'2025-12-12 09:30:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,12,81,NULL,'2025-12-12 10:15:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,13,82,NULL,'2025-12-12 11:50:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,14,83,NULL,'2025-12-12 12:25:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,15,84,NULL,'2025-12-12 13:05:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,16,85,NULL,'2025-12-12 14:40:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,17,86,NULL,'2025-12-12 15:10:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,18,87,NULL,'2025-12-12 16:20:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,19,88,NULL,'2025-12-13 08:50:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,20,89,NULL,'2025-12-13 09:35:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,1,90,NULL,'2025-12-13 10:25:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,2,91,NULL,'2025-12-13 11:15:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,3,92,NULL,'2025-12-13 12:05:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,4,93,NULL,'2025-12-13 13:20:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,5,94,NULL,'2025-12-13 14:05:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,6,95,NULL,'2025-12-13 15:10:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,7,96,NULL,'2025-12-13 16:00:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,8,97,NULL,'2025-12-13 16:45:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,9,98,NULL,'2025-12-13 17:20:00','Emergency Visit','APR',1,1);
CALL sp_save_patient_visit(0,10,99,NULL,'2025-12-13 17:50:00','Emergency Visit','APR',1,1);

#end patient visit

#start patient condition
-- Procedure Definition: sp_save_patient_condition (MySQL/MariaDB)

-- VisitID 1: Routine Checkup
CALL sp_save_patient_condition(NULL, 53, 1, 1, '2025-12-11 11:43:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 2: Follow-up Visit
CALL sp_save_patient_condition(NULL, 11, 1, 2, '2025-12-11 14:20:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 3: New Patient Consultation
CALL sp_save_patient_condition(NULL, 39, 1, 3, '2025-12-11 09:39:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 4: Routine Checkup
CALL sp_save_patient_condition(NULL, 22, 2, 4, '2025-12-11 15:15:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 5: Follow-up Visit
CALL sp_save_patient_condition(NULL, 7, 2, 5, '2025-12-11 10:28:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 6: New Patient Consultation
CALL sp_save_patient_condition(NULL, 4, 3, 6, '2025-12-11 13:54:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 7: Routine Checkup
CALL sp_save_patient_condition(NULL, 31, 3, 7, '2025-12-11 09:15:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 8: Follow-up Visit
CALL sp_save_patient_condition(NULL, 59, 4, 8, '2025-12-11 15:38:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 9: Routine Checkup
CALL sp_save_patient_condition(NULL, 2, 6, 9, '2025-12-11 11:04:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 10: New Patient Consultation
CALL sp_save_patient_condition(NULL, 48, 7, 10, '2025-12-11 14:39:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 11: Follow-up Visit
CALL sp_save_patient_condition(NULL, 15, 8, 11, '2025-12-11 10:05:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 12: Routine Checkup
CALL sp_save_patient_condition(NULL, 5, 9, 12, '2025-12-11 12:06:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 13: New Patient Consultation
CALL sp_save_patient_condition(NULL, 27, 10, 13, '2025-12-11 16:03:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 14: Follow-up Visit
CALL sp_save_patient_condition(NULL, 36, 11, 14, '2025-12-11 13:47:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 15: Routine Checkup
CALL sp_save_patient_condition(NULL, 19, 12, 15, '2025-12-11 09:03:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 16: New Patient Consultation
CALL sp_save_patient_condition(NULL, 43, 14, 16, '2025-12-11 15:55:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 17: Follow-up Visit
CALL sp_save_patient_condition(NULL, 51, 15, 17, '2025-12-11 11:36:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 18: Routine Checkup
CALL sp_save_patient_condition(NULL, 1, 16, 18, '2025-12-11 16:51:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 19: New Patient Consultation
CALL sp_save_patient_condition(NULL, 58, 17, 19, '2025-12-11 10:48:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 20: Follow-up Visit
CALL sp_save_patient_condition(NULL, 14, 18, 20, '2025-12-11 12:33:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 21: Routine Checkup
CALL sp_save_patient_condition(NULL, 60, 3, 21, '2025-12-12 09:45:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 22: New Patient Consultation
CALL sp_save_patient_condition(NULL, 24, 3, 22, '2025-12-12 14:08:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 23: Follow-up Visit
CALL sp_save_patient_condition(NULL, 9, 4, 23, '2025-12-12 10:57:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 24: Routine Checkup
CALL sp_save_patient_condition(NULL, 41, 6, 24, '2025-12-12 12:48:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 25: New Patient Consultation
CALL sp_save_patient_condition(NULL, 16, 7, 25, '2025-12-12 16:18:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 26: Follow-up Visit
CALL sp_save_patient_condition(NULL, 37, 8, 26, '2025-12-12 10:02:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 27: Routine Checkup
CALL sp_save_patient_condition(NULL, 52, 9, 27, '2025-12-12 11:39:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 28: New Patient Consultation
CALL sp_save_patient_condition(NULL, 8, 10, 28, '2025-12-12 15:50:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 29: Follow-up Visit
CALL sp_save_patient_condition(NULL, 29, 11, 29, '2025-12-12 10:19:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 30: Routine Checkup
CALL sp_save_patient_condition(NULL, 55, 12, 30, '2025-12-12 13:36:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 31: New Patient Consultation
CALL sp_save_patient_condition(NULL, 3, 13, 31, '2025-12-12 16:35:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 32: Follow-up Visit
CALL sp_save_patient_condition(NULL, 49, 17, 32, '2025-12-12 12:05:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 33: Routine Checkup
CALL sp_save_patient_condition(NULL, 17, 20, 33, '2025-12-12 13:39:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 34: New Patient Consultation
CALL sp_save_patient_condition(NULL, 21, 1, 34, '2025-12-13 11:18:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 35: Follow-up Visit
CALL sp_save_patient_condition(NULL, 50, 1, 35, '2025-12-13 14:04:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 36: Routine Checkup
CALL sp_save_patient_condition(NULL, 34, 2, 36, '2025-12-13 15:30:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 37: New Patient Consultation
CALL sp_save_patient_condition(NULL, 6, 6, 37, '2025-12-13 10:35:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 38: Follow-up Visit
CALL sp_save_patient_condition(NULL, 47, 6, 38, '2025-12-13 13:01:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 39: Routine Checkup
CALL sp_save_patient_condition(NULL, 12, 15, 39, '2025-12-13 16:40:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 40: New Patient Consultation
CALL sp_save_patient_condition(NULL, 56, 15, 40, '2025-12-13 09:12:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 41: Follow-up Visit
CALL sp_save_patient_condition(NULL, 28, 15, 41, '2025-12-13 13:25:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 42: Routine Checkup
CALL sp_save_patient_condition(NULL, 42, 18, 42, '2025-12-13 11:45:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 43: New Patient Consultation
CALL sp_save_patient_condition(NULL, 13, 18, 43, '2025-12-13 15:03:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 44: Follow-up Visit
CALL sp_save_patient_condition(NULL, 20, 3, 44, '2025-12-11 12:25:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 45: Routine Checkup
CALL sp_save_patient_condition(NULL, 35, 10, 45, '2025-12-11 11:15:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 46: New Patient Consultation
CALL sp_save_patient_condition(NULL, 54, 18, 46, '2025-12-11 09:30:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 47: Routine Checkup
CALL sp_save_patient_condition(NULL, 40, 4, 47, '2025-12-11 14:44:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 48: Follow-up Visit
CALL sp_save_patient_condition(NULL, 25, 12, 48, '2025-12-11 17:19:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 49: Routine Checkup
CALL sp_save_patient_condition(NULL, 1, 17, 49, '2025-12-12 15:07:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 50: New Patient Consultation
CALL sp_save_patient_condition(NULL, 30, 8, 50, '2025-12-12 13:14:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 51: Follow-up Visit
CALL sp_save_patient_condition(NULL, 57, 10, 51, '2025-12-12 17:05:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 52: Routine Checkup
CALL sp_save_patient_condition(NULL, 23, 7, 52, '2025-12-12 11:29:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 53: New Patient Consultation
CALL sp_save_patient_condition(NULL, 38, 4, 53, '2025-12-12 09:22:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 54: Follow-up Visit
CALL sp_save_patient_condition(NULL, 14, 12, 54, '2025-12-12 08:35:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 55: Routine Checkup
CALL sp_save_patient_condition(NULL, 46, 11, 55, '2025-12-12 14:33:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 56: New Patient Consultation
CALL sp_save_patient_condition(NULL, 32, 15, 56, '2025-12-13 14:29:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 57: Follow-up Visit
CALL sp_save_patient_condition(NULL, 17, 1, 57, '2025-12-13 08:52:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 58: Routine Checkup
CALL sp_save_patient_condition(NULL, 5, 18, 58, '2025-12-13 16:15:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 59: New Patient Consultation
CALL sp_save_patient_condition(NULL, 2, 6, 59, '2025-12-13 14:50:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 60: Follow-up Visit
CALL sp_save_patient_condition(NULL, 53, 2, 60, '2025-12-13 10:48:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 61: Routine Checkup
CALL sp_save_patient_condition(NULL, 19, 15, 61, '2025-12-13 17:39:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 62: New Patient Consultation
CALL sp_save_patient_condition(NULL, 4, 18, 62, '2025-12-13 09:54:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 63: Follow-up Visit
CALL sp_save_patient_condition(NULL, 43, 6, 63, '2025-12-13 15:55:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 64: Routine Checkup
CALL sp_save_patient_condition(NULL, 36, 15, 64, '2025-12-13 12:05:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 65: Emergency Visit
CALL sp_save_patient_condition(NULL, 70, 1, 65, '2025-12-11 08:57:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 66: Emergency Visit
CALL sp_save_patient_condition(NULL, 71, 2, 66, '2025-12-11 09:16:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 67: Emergency Visit
CALL sp_save_patient_condition(NULL, 72, 3, 67, '2025-12-11 10:40:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 68: Emergency Visit
CALL sp_save_patient_condition(NULL, 73, 4, 68, '2025-12-11 11:35:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 69: Emergency Visit
CALL sp_save_patient_condition(NULL, 74, 5, 69, '2025-12-11 12:45:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 70: Emergency Visit
CALL sp_save_patient_condition(NULL, 75, 6, 70, '2025-12-11 13:20:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 71: Emergency Visit
CALL sp_save_patient_condition(NULL, 76, 7, 71, '2025-12-11 14:25:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 72: Emergency Visit
CALL sp_save_patient_condition(NULL, 77, 8, 72, '2025-12-11 15:15:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 73: Emergency Visit
CALL sp_save_patient_condition(NULL, 78, 9, 73, '2025-12-11 16:08:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 74: Emergency Visit
CALL sp_save_patient_condition(NULL, 79, 10, 74, '2025-12-12 08:42:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 75: Emergency Visit
CALL sp_save_patient_condition(NULL, 80, 11, 75, '2025-12-12 09:55:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 76: Emergency Visit
CALL sp_save_patient_condition(NULL, 81, 12, 76, '2025-12-12 10:25:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 77: Emergency Visit
CALL sp_save_patient_condition(NULL, 82, 13, 77, '2025-12-12 11:59:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 78: Emergency Visit
CALL sp_save_patient_condition(NULL, 83, 14, 78, '2025-12-12 12:35:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 79: Emergency Visit
CALL sp_save_patient_condition(NULL, 84, 15, 79, '2025-12-12 13:15:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 80: Emergency Visit
CALL sp_save_patient_condition(NULL, 85, 16, 80, '2025-12-12 14:48:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 81: Emergency Visit
CALL sp_save_patient_condition(NULL, 86, 17, 81, '2025-12-12 15:15:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 82: Emergency Visit
CALL sp_save_patient_condition(NULL, 87, 18, 82, '2025-12-12 16:25:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 83: Emergency Visit
CALL sp_save_patient_condition(NULL, 88, 19, 83, '2025-12-13 09:05:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 84: Emergency Visit
CALL sp_save_patient_condition(NULL, 89, 20, 84, '2025-12-13 09:42:00', 'Emergency Visit', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 85: Emergency Visit
CALL sp_save_patient_condition(NULL, 90, 1, 85, '2025-12-13 10:30:00', 'Medication Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 86: Emergency Visit
CALL sp_save_patient_condition(NULL, 91, 2, 86, '2025-12-13 11:25:00', 'Lab Test Required', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 87: Emergency Visit
CALL sp_save_patient_condition(NULL, 92, 3, 87, '2025-12-13 12:15:00', 'Imaging Required (X-ray, MRI, USG)', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 88: Emergency Visit
CALL sp_save_patient_condition(NULL, 93, 4, 88, '2025-12-13 13:25:00', 'Chronic Disease Management', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 89: Emergency Visit
CALL sp_save_patient_condition(NULL, 94, 5, 89, '2025-12-13 14:15:00', 'Post-Procedure Review', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 90: Emergency Visit
CALL sp_save_patient_condition(NULL, 95, 6, 90, '2025-12-13 15:15:00', 'Vaccination / Immunization', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 91: Emergency Visit
CALL sp_save_patient_condition(NULL, 96, 7, 91, '2025-12-13 16:08:00', 'Others', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 92: Emergency Visit
CALL sp_save_patient_condition(NULL, 97, 8, 92, '2025-12-13 16:55:00', 'General Checkup', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 93: Emergency Visit
CALL sp_save_patient_condition(NULL, 98, 9, 93, '2025-12-13 17:25:00', 'Follow-Up', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
-- VisitID 94: Emergency Visit
CALL sp_save_patient_condition(NULL, 99, 10, 94, '2025-12-13 18:00:00', 'Transfer to Specialist', 'Patient condition saved for analysis. Doctor note placeholder.', 'APR', 1, 1);
