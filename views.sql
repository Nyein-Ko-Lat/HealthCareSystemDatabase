USE gh1043541_healthcare_db;

create definer = root@localhost view gh1043541_healthcare_db.v_appointments as
select `a`.`AppointmentID`   AS `Appointment ID`,
       `a`.`PatientID`       AS `Patient ID`,
       `a`.`DoctorID`        AS `Doctor ID`,
       `a`.`AppointmentDate` AS `Appointment Date`,
       `a`.`Reason`          AS `Reason`,
       `a`.`StatusCode`      AS `Status`,
       `a`.`CreatedBy`       AS `Created By`,
       `a`.`UpdatedBy`       AS `Updated By`,
       `a`.`CreatedAt`       AS `Created At`,
       `a`.`UpdatedAt`       AS `Updated At`
from `gh1043541_healthcare_db`.`appointments` `a`;

create definer = root@localhost view gh1043541_healthcare_db.v_doctor_schedules as
select `ds`.`DoctorScheduleID`                      AS `Schedule ID`,
       `ds`.`DoctorID`                              AS `Doctor ID`,
       concat(`d`.`FirstName`, ' ', `d`.`LastName`) AS `Doctor Name`,
       `ds`.`IsMon`                                 AS `Monday Flag`,
       `ds`.`IsTue`                                 AS `Tuesday Flag`,
       `ds`.`IsWed`                                 AS `Wednesday Flag`,
       `ds`.`IsThu`                                 AS `Thursday Flag`,
       `ds`.`IsFri`                                 AS `Friday Flag`,
       `ds`.`IsSat`                                 AS `Saturday Flag`,
       `ds`.`IsSun`                                 AS `Sunday Flag`,
       `ds`.`StartTime`                             AS `Start Time`,
       `ds`.`EndTime`                               AS `End Time`,
       `ds`.`StatusCode`                            AS `Status`,
       `ds`.`CreatedBy`                             AS `Created By`,
       `ds`.`UpdatedBy`                             AS `Updated By`,
       `ds`.`CreatedAt`                             AS `Created At`,
       `ds`.`UpdatedAt`                             AS `Updated At`
from (`gh1043541_healthcare_db`.`doctor_schedules` `ds` left join `gh1043541_healthcare_db`.`doctors` `d`
      on ((`ds`.`DoctorID` = `d`.`DoctorID`)));

create definer = root@localhost view gh1043541_healthcare_db.v_doctors as
select `d`.`DoctorID`                               AS `Doctor ID`,
       `d`.`FirstName`                              AS `First Name`,
       `d`.`LastName`                               AS `Last Name`,
       concat(`d`.`FirstName`, ' ', `d`.`LastName`) AS `Full Name`,
       `d`.`Specialty`                              AS `Specialty`,
       `d`.`PhoneNumber`                            AS `Phone Number`,
       `d`.`Email`                                  AS `Email`,
       `d`.`StatusCode`                             AS `Status`,
       `d`.`CreatedBy`                              AS `Created By`,
       `d`.`UpdatedBy`                              AS `Updated By`,
       `d`.`CreatedAt`                              AS `Created At`,
       `d`.`UpdatedAt`                              AS `Updated At`
from `gh1043541_healthcare_db`.`doctors` `d`
order by `d`.`Specialty`, `d`.`FirstName`;

create definer = root@localhost view gh1043541_healthcare_db.v_family_history as
select `fh`.`FamilyHistoryID`  AS `Family History ID`,
       `fh`.`PatientID`        AS `Patient ID`,
       `fh`.`MedicalCondition` AS `Condition`,
       `fh`.`Relationship`     AS `Relationship`,
       `fh`.`StatusCode`       AS `Status`,
       `fh`.`CreatedBy`        AS `Created By`,
       `fh`.`UpdatedBy`        AS `Updated By`,
       `fh`.`CreatedAt`        AS `Created At`,
       `fh`.`UpdatedAt`        AS `Updated At`
from `gh1043541_healthcare_db`.`family_history` `fh`;

create definer = root@localhost view gh1043541_healthcare_db.v_patient_conditions as
select `pc`.`ConditionID`   AS `Condition ID`,
       `pc`.`VisitID`       AS `Visit ID`,
       `pc`.`PatientID`     AS `Patient ID`,
       `pc`.`DoctorID`      AS `Doctor ID`,
       `pc`.`ConditionName` AS `Condition Name`,
       `pc`.`DoctorNote`    AS `Note`,
       `pc`.`DiagnosedDate` AS `Diagnosed Date`,
       `pc`.`StatusCode`    AS `Status`,
       `pc`.`CreatedBy`     AS `Created By`,
       `pc`.`UpdatedBy`     AS `Updated By`,
       `pc`.`CreatedAt`     AS `Created At`,
       `pc`.`UpdatedAt`     AS `Updated At`
from `gh1043541_healthcare_db`.`patient_conditions` `pc`;

create definer = root@localhost view gh1043541_healthcare_db.v_patient_visits as
select `pv`.`VisitID`       AS `Visit ID`,
       `pv`.`PatientID`     AS `Patient ID`,
       `pv`.`AppointmentID` AS `Appointment ID`,
       `pv`.`VisitDate`     AS `Visit Date`,
       `pv`.`VisitReason`   AS `Reason`,
       `pv`.`DoctorID`      AS `Doctor ID`,
       `pv`.`StatusCode`    AS `Status`,
       `pv`.`CreatedBy`     AS `Created By`,
       `pv`.`UpdatedBy`     AS `Updated By`,
       `pv`.`CreatedAt`     AS `Created At`,
       `pv`.`UpdatedAt`     AS `Updated At`
from `gh1043541_healthcare_db`.`patient_visits` `pv`;

create definer = root@localhost view gh1043541_healthcare_db.v_patients as
select `p`.`PatientID`                              AS `Patient ID`,
       `p`.`FirstName`                              AS `First Name`,
       `p`.`LastName`                               AS `Last Name`,
       concat(`p`.`FirstName`, ' ', `p`.`LastName`) AS `Full Name`,
       `p`.`DateOfBirth`                            AS `Date of Birth`,
       `p`.`Gender`                                 AS `Gender`,
       `p`.`BloodType`                              AS `Blood Type`,
       `p`.`StatusCode`                             AS `Status`,
       `p`.`CreatedBy`                              AS `Created By`,
       `p`.`UpdatedBy`                              AS `Updated By`,
       `p`.`CreatedAt`                              AS `Created At`,
       `p`.`UpdatedAt`                              AS `Updated At`
from `gh1043541_healthcare_db`.`patients` `p`;



