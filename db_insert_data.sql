use gh1043541_healthcare_db;
-- --------------------------------------------------------

#reset all tables except User table leave admin account
DELETE from patient_conditions;
ALTER TABLE patient_conditions AUTO_INCREMENT = 1;
DELETE from patient_visits;
ALTER TABLE patient_visits AUTO_INCREMENT = 1;
DELETE from doctor_schedules;
ALTER TABLE doctor_schedules AUTO_INCREMENT = 1;
DELETE from appointments;
ALTER TABLE appointments AUTO_INCREMENT = 1;
delete from family_history;
ALTER TABLE family_history AUTO_INCREMENT = 1;
DELETE from patients;
ALTER TABLE patients AUTO_INCREMENT = 1;
DELETE from doctors;
ALTER TABLE doctors AUTO_INCREMENT = 1;
DELETE from users where UserName <>'Admin';
ALTER TABLE users AUTO_INCREMENT = 2;

#clear audit_log table
DELETE From audit_log;
ALTER TABLE audit_log AUTO_INCREMENT = 1;


#start Doctor Insert
#insert 20 doctors
DELIMITER $$

-- 1. Define a temporary procedure to handle the loop and random generation
CREATE PROCEDURE temp_insert_20_doctors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_first_name VARCHAR(50);
    DECLARE random_last_name VARCHAR(50);
    DECLARE random_specialty VARCHAR(100);
    DECLARE random_phone VARCHAR(20);
    DECLARE random_email VARCHAR(100);

    -- Arrays of possible values
    DECLARE first_names_list VARCHAR(1000) DEFAULT 'Alice,Bob,Charlie,Diana,Ethan,Fiona,George,Hannah,Isaac,Julia';
    DECLARE last_names_list VARCHAR(1000) DEFAULT 'Clark,Adams,Baker,Foster,Hayes,Jenkins,King,Lee,Moore,Nelson';
    DECLARE specialties_list VARCHAR(1000) DEFAULT 'General Practice,Pediatric,Cardiology,Surgery,Neurology,Gastroenterology,Dermatology,Ophthalmology,Endocrinology,Pulmonology,Nephrology';

    -- Loop 10 times to insert 10 doctors
    WHILE i <= 20 DO
        -- Helper logic to select a random item from the list
        -- (This logic ensures a random selection based on comma count)
        SET random_first_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(first_names_list, ',', CAST(1 + RAND() * (LENGTH(first_names_list) - LENGTH(REPLACE(first_names_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));
        SET random_last_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(last_names_list, ',', CAST(1 + RAND() * (LENGTH(last_names_list) - LENGTH(REPLACE(last_names_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));
        SET random_specialty = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(specialties_list, ',', CAST(1 + RAND() * (LENGTH(specialties_list) - LENGTH(REPLACE(specialties_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));

        -- Generate random phone number and email
        SET random_phone = CONCAT('555-', LPAD(FLOOR(RAND() * 10000000), 7, '0'));
        SET random_email = LOWER(CONCAT(random_first_name, '.', random_last_name, i, '@gismaclinic.com'));

        -- Call your existing stored procedure: sp_save_doctor
        CALL sp_save_doctor(
            NULL,
            random_first_name,          -- p_FirstName
            random_last_name,           -- p_LastName
            random_specialty,           -- p_Specialty
            random_phone,           -- p_PhoneNumber
            random_email,                   -- p_Email
            'APR',                    -- p_StatusCode: APRive
            1,                          -- p_CreatedBy: ID 1
            1                           -- p_UpdatedBy: ID 1
        );

        SET i = i + 1;
    END WHILE;
END$$

# 2. Execute the temporary procedure
CALL temp_insert_20_doctors()$$

# 3. Drop the temporary procedure immediately after execution
DROP PROCEDURE temp_insert_20_doctors$$

DELIMITER ;

##--------------------------------------------end of doctors-----------------------------

##-------------------------------------Start of Patient ---------------------------------

DELIMITER $$

-- 1. Define a temporary procedure to handle the insertion logic
CREATE PROCEDURE temp_insert_healthcare_data()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT;
    DECLARE new_patient_id BIGINT;

    -- Patient Variables
    DECLARE random_p_first_name VARCHAR(50);
    DECLARE random_p_last_name VARCHAR(50);
    DECLARE random_p_dob DATE;
    DECLARE random_p_gender VARCHAR(10);
    DECLARE random_p_blood_type VARCHAR(5);

    -- Family History Variables
    DECLARE random_fh_condition VARCHAR(100);
    DECLARE random_fh_relationship VARCHAR(100);

    -- Arrays of possible values
    DECLARE first_names_list VARCHAR(500) DEFAULT 'Leo,Mia,Noah,Olive,Paul,Quinn,Ruby,Sam,Tess,Victor,Martin,Michel';
    DECLARE last_names_list VARCHAR(500) DEFAULT 'Wade,Xing,Young,Zane,Allen,Baker,Cain,Day,Earl,Fox,Baker,Lin';
    DECLARE blood_types_list VARCHAR(100) DEFAULT 'A+,B+,O+,AB+,A-,B-,O-,AB-';
    DECLARE genders_list VARCHAR(20) DEFAULT 'Male,Female';

    DECLARE conditions_list VARCHAR(1000) DEFAULT 'Diabetes,Hypertension,Asthma,Heart Disease,Cancer,Chronic Kidney Disease,Liver Disease,Stroke,Arthritis,Thyroid Disorder';
    DECLARE relationships_list VARCHAR(100) DEFAULT 'Father,Mother,Brother,Sister,Son,Daughter,Spouse,Grandparent,Other Relative';

    -- Helper function to select a random item from a comma-separated list
    -- This uses a simplified but common random selection logic
    SET max_sp_recursion_depth = 255;

    -- Outer Loop: Insert 5 Patients
    WHILE i <= 150 DO
        -- Generate random patient data
        SET random_p_first_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(first_names_list, ',', CAST(1 + RAND() * (LENGTH(first_names_list) - LENGTH(REPLACE(first_names_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));
        SET random_p_last_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(last_names_list, ',', CAST(1 + RAND() * (LENGTH(last_names_list) - LENGTH(REPLACE(last_names_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));
        SET random_p_gender = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genders_list, ',', CAST(1 + RAND() * (LENGTH(genders_list) - LENGTH(REPLACE(genders_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));
        SET random_p_blood_type = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(blood_types_list, ',', CAST(1 + RAND() * (LENGTH(blood_types_list) - LENGTH(REPLACE(blood_types_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));

        -- Generate random DOB (between 1950 and 2000)
        SET random_p_dob = DATE_ADD('1950-01-01', INTERVAL FLOOR(RAND() * 18262) DAY); -- 18262 days is approx 50 years

        -- Call sp_save_patient to insert the new patient
        CALL gh1043541_healthcare_db.sp_save_patient(
            NULL,                       -- p_PatientID: NULL for new insert
            random_p_first_name,        -- p_FirstName
            random_p_last_name,         -- p_LastName
            random_p_dob,               -- p_DateOfBirth
            random_p_gender,            -- p_Gender
            random_p_blood_type,        -- p_BloodType
            'APR',                      -- p_StatusCode: APRive
            1,                          -- p_CreatedBy: ID 1
            1                           -- p_UpdatedBy: ID 1
        );

        -- Retrieve the LAST_INSERT_ID() which was set inside sp_save_patient
        SET new_patient_id = LAST_INSERT_ID();

        -- Inner Loop: Insert 2 Family History records for the new patient
        SET j = 1;
        WHILE j <= 3 DO
            -- Generate random family history data
            SET random_fh_condition = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(conditions_list, ',', CAST(1 + RAND() * (LENGTH(conditions_list) - LENGTH(REPLACE(conditions_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));
            SET random_fh_relationship = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(relationships_list, ',', CAST(1 + RAND() * (LENGTH(relationships_list) - LENGTH(REPLACE(relationships_list, ',', '')) + 1) AS UNSIGNED)), ',', -1));

            -- Call sp_save_family_history
            CALL gh1043541_healthcare_db.sp_save_family_history(
                NULL,                       -- p_FamilyHistoryID: NULL for new insert
                new_patient_id,             -- p_PatientID: Use the ID from the patient just created
                random_fh_condition,        -- p_MedicalCondition
                random_fh_relationship,     -- p_Relationship
                'APR',                      -- p_StatusCode
                1,                          -- p_CreatedBy
                1                           -- p_UpdatedBy
            );

            SET j = j + 1;
        END WHILE;

        SET i = i + 1;
    END WHILE;
END$$

-- 2. Execute the temporary procedure
CALL temp_insert_healthcare_data();$$
-- --------------------------------------------------------
-- 3. Drop the temporary procedure immediately after execution
DROP PROCEDURE temp_insert_healthcare_data$$
DELIMITER ;
#end of Patient