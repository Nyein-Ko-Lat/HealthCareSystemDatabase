drop schema if exists gh1043541_healthcare_db;
CREATE DATABASE gh1043541_healthcare_db;

USE  gh1043541_healthcare_db;

create table audit_log
(
    LogID      bigint auto_increment
        primary key,
    TableName  varchar(100)                        null,
    RecordID   bigint                              null,
    ActionType enum ('INSERT', 'UPDATE', 'DELETE') null,
    OldData    json                                null,
    NewData    json                                null,
    ChangedBy  bigint                              null,
    ChangedAt  datetime default CURRENT_TIMESTAMP  null
);

create table spring_session
(
    PRIMARY_ID            char(36)     not null
        primary key,
    SESSION_ID            char(36)     not null,
    CREATION_TIME         bigint       not null,
    LAST_ACCESS_TIME      bigint       not null,
    MAX_INACTIVE_INTERVAL int          not null,
    EXPIRY_TIME           bigint       not null,
    PRINCIPAL_NAME        varchar(100) null,
    constraint SPRING_SESSION_IX1
        unique (SESSION_ID)
);

create index SPRING_SESSION_IX2
    on spring_session (EXPIRY_TIME);

create index SPRING_SESSION_IX3
    on spring_session (PRINCIPAL_NAME);

create table spring_session_attributes
(
    SESSION_PRIMARY_ID char(36)     not null,
    ATTRIBUTE_NAME     varchar(200) not null,
    ATTRIBUTE_BYTES    blob         not null,
    primary key (SESSION_PRIMARY_ID, ATTRIBUTE_NAME),
    constraint spring_session_attributes_ibfk_1
        foreign key (SESSION_PRIMARY_ID) references spring_session (PRIMARY_ID)
            on delete cascade
);

create table status_codes
(
    code        varchar(3)  not null
        primary key,
    description varchar(20) null
);

create table doctors
(
    DoctorID    bigint auto_increment
        primary key,
    FirstName   varchar(50)                          not null,
    LastName    varchar(50)                          not null,
    Specialty   varchar(100)                         null,
    PhoneNumber varchar(20)                          null,
    Email       varchar(50)                          null,
    StatusCode  varchar(3) default 'USE'             null,
    CreatedBy   bigint                               null,
    UpdatedBy   bigint                               null,
    CreatedAt   datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt   datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint doctors_ibfk_1
        foreign key (StatusCode) references status_codes (code)
);

create table doctor_schedules
(
    DoctorScheduleID bigint auto_increment
        primary key,
    DoctorID         bigint                               not null,
    IsMon            tinyint(1) default 0                 null,
    IsTue            tinyint(1) default 0                 null,
    IsWed            tinyint(1) default 0                 null,
    IsThu            tinyint(1) default 0                 null,
    IsFri            tinyint(1) default 0                 null,
    IsSat            tinyint(1) default 0                 null,
    IsSun            tinyint(1) default 0                 null,
    StartTime        time                                 null,
    EndTime          time                                 null,
    StatusCode       varchar(3) default 'USE'             null,
    CreatedBy        bigint                               null,
    UpdatedBy        bigint                               null,
    CreatedAt        datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt        datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint doctor_schedules_pk
        unique (DoctorID),
    constraint doctor_schedules_doctors_DoctorID_fk
        foreign key (DoctorID) references doctors (DoctorID),
    constraint doctor_schedules_ibfk_2
        foreign key (StatusCode) references status_codes (code)
);

create index StatusCode
    on doctor_schedules (StatusCode);

create index StatusCode
    on doctors (StatusCode);

create table patients
(
    PatientID   bigint auto_increment
        primary key,
    FirstName   varchar(50)                          not null,
    LastName    varchar(50)                          not null,
    DateOfBirth date                                 null,
    Gender      varchar(10)                          null,
    BloodType   varchar(5)                           null,
    StatusCode  varchar(3) default 'USE'             null,
    CreatedBy   bigint                               null,
    UpdatedBy   bigint                               null,
    CreatedAt   datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt   datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint patients_ibfk_1
        foreign key (StatusCode) references status_codes (code)
);

create table appointments
(
    AppointmentID   bigint auto_increment
        primary key,
    PatientID       bigint                               not null,
    DoctorID        bigint                               not null,
    AppointmentDate datetime                             null,
    Reason          varchar(255)                         null,
    StatusCode      varchar(3) default 'USE'             null,
    CreatedBy       bigint                               null,
    UpdatedBy       bigint                               null,
    CreatedAt       datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt       datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint appointments_patients_PatientID_fk
        foreign key (PatientID) references patients (PatientID),
    constraint appointments_status_codes_Code_fk
        foreign key (StatusCode) references status_codes (code)
);

create index appointments_doctors_DoctorID_fk
    on appointments (DoctorID);

create table family_history
(
    FamilyHistoryID  bigint auto_increment
        primary key,
    PatientID        bigint                               not null,
    MedicalCondition varchar(255)                         null,
    Relationship     varchar(50)                          null,
    StatusCode       varchar(3) default 'USE'             null,
    CreatedBy        bigint                               null,
    UpdatedBy        bigint                               null,
    CreatedAt        datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt        datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint family_history_pk
        unique (PatientID, Relationship, MedicalCondition),
    constraint family_history_ibfk_2
        foreign key (StatusCode) references status_codes (code),
    constraint family_history_patients_PatientID_fk
        foreign key (PatientID) references patients (PatientID)
);

create index StatusCode
    on family_history (StatusCode);

create index family_history_PatientID_Relationship_MedicalCondition_index
    on family_history (PatientID, Relationship, MedicalCondition);

create table patient_visits
(
    VisitID       bigint auto_increment
        primary key,
    PatientID     bigint                               not null,
    DoctorID      bigint                               not null,
    AppointmentID bigint                               null,
    VisitDate     datetime                             null,
    VisitReason   text                                 null,
    StatusCode    varchar(3) default 'USE'             null,
    CreatedBy     bigint                               null,
    UpdatedBy     bigint                               null,
    CreatedAt     datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt     datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint patient_visits_pk
        unique (AppointmentID),
    constraint patient_visits_appointments_AppointmentID_fk
        foreign key (AppointmentID) references appointments (AppointmentID),
    constraint patient_visits_doctors_DoctorID_fk
        foreign key (DoctorID) references doctors (DoctorID),
    constraint patient_visits_ibfk_3
        foreign key (StatusCode) references status_codes (code),
    constraint patient_visits_patients_PatientID_fk
        foreign key (PatientID) references patients (PatientID)
);

create table patient_conditions
(
    ConditionID   bigint auto_increment
        primary key,
    VisitID       bigint                               not null,
    PatientID     bigint                               not null,
    DoctorID      bigint                               not null,
    ConditionName varchar(255)                         null,
    DoctorNote    varchar(512)                         null,
    DiagnosedDate datetime                             null,
    StatusCode    varchar(3) default 'USE'             null,
    CreatedBy     bigint                               null,
    UpdatedBy     bigint                               null,
    CreatedAt     datetime   default CURRENT_TIMESTAMP null,
    UpdatedAt     datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint patient_conditions_pk
        unique (VisitID),
    constraint patient_conditions_ibfk_1
        foreign key (PatientID) references patients (PatientID),
    constraint patient_conditions_ibfk_2
        foreign key (DoctorID) references doctors (DoctorID)
            on delete cascade,
    constraint patient_conditions_ibfk_3
        foreign key (StatusCode) references status_codes (code),
    constraint patient_conditions_patient_visits_VisitID_fk
        foreign key (VisitID) references patient_visits (VisitID)
);

create index DoctorID
    on patient_conditions (DoctorID);

create index PatientID
    on patient_conditions (PatientID);

create index StatusCode
    on patient_conditions (StatusCode);

create index StatusCode
    on patient_visits (StatusCode);

create index StatusCode
    on patients (StatusCode);

create table roles
(
    id          bigint auto_increment
        primary key,
    name        varchar(50)                          not null,
    StatusCode  varchar(3) default 'USE'             null comment 'USE=Active / In Use, INA=Inactive, DEL=Deleted',
    CreatedBy   bigint                               null,
    CreatedAt   datetime   default CURRENT_TIMESTAMP null,
    UpdatedBy   bigint                               null,
    UpdatedAt   datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    status_code varchar(255)                         null,
    constraint name
        unique (name),
    constraint roles_status_codes_code_fk
        foreign key (StatusCode) references status_codes (code)
);

create index created_by
    on roles (CreatedBy);

create index updated_by
    on roles (UpdatedBy);

create table users
(
    id             bigint auto_increment
        primary key,
    UserName       varchar(255)                         null,
    email          varchar(255)                         null,
    Password       varchar(255)                         not null,
    Enabled        tinyint(1) default 1                 null,
    account_locked tinyint(1) default 0                 null,
    session_token  varchar(255)                         null,
    StatusCode     varchar(3) default 'PEN'             null comment 'PEN=Pending, APR=Approved,REJ=Rejected, BLK=Blocked,INA=Inactive, DEL=Deleted',
    FirstName      varchar(255)                         null,
    LastName       varchar(255)                         null,
    RoleId         bigint                               null,
    CreatedBy      bigint                               null,
    CreatedAt      datetime   default CURRENT_TIMESTAMP null,
    UpdatedBy      bigint                               null,
    UpdatedAt      datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint roleID
        unique (RoleId),
    constraint username
        unique (UserName),
    constraint users_roles_id_fk
        foreign key (RoleId) references roles (id),
    constraint users_status_codes_code_fk
        foreign key (StatusCode) references status_codes (code)
);

create table login_sessions
(
    id          bigint auto_increment
        primary key,
    session_id  varchar(100)                       null,
    user_id     bigint                             not null,
    login_time  datetime default CURRENT_TIMESTAMP null,
    logout_time datetime                           null,
    ip_address  varchar(50)                        null,
    constraint login_sessions_ibfk_1
        foreign key (user_id) references users (id)
            on delete cascade
);

create index user_id
    on login_sessions (user_id);

create table user_roles
(
    user_id     bigint                             not null,
    role_id     bigint                             not null,
    CreatedBy   bigint                             null,
    UpdatedBy   bigint                             null,
    CreatedAt   datetime default CURRENT_TIMESTAMP null,
    UpdatedAt   datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    created_at  datetime(6)                        null,
    created_by  bigint                             null,
    updated_at  datetime(6)                        null,
    updated_by  bigint                             null,
    status_code varchar(255)                       null,
    primary key (user_id, role_id),
    constraint user_roles_ibfk_1
        foreign key (user_id) references users (id)
            on delete cascade,
    constraint user_roles_ibfk_2
        foreign key (role_id) references roles (id)
            on delete cascade,
    constraint user_roles_ibfk_3
        foreign key (CreatedBy) references users (id)
            on delete cascade,
    constraint user_roles_ibfk_4
        foreign key (UpdatedBy) references users (id)
            on delete cascade
);

create index created_by
    on user_roles (CreatedBy);

create index role_id
    on user_roles (role_id);

create index updated_by
    on user_roles (UpdatedBy);

#initial data for user, roles, and status_code insert

INSERT INTO `status_codes` (`code`, `description`) VALUES
('APR', 'Approved'),
('DEL', 'Deleted'),
('FIN', 'Complete/ Finished'),
('INA', 'Inactive'),
('PEN', 'Pending Approval'),
('REJ', 'Rejected'),
('USE', 'Active / In Use');


INSERT INTO `roles` (`id`, `name`, `StatusCode`, `CreatedBy`, `CreatedAt`, `UpdatedBy`, `UpdatedAt`, `status_code`) VALUES
(1, 'Admin', 'APR', NULL, '2025-10-16 19:32:05', 1, '2025-11-24 11:59:48', NULL),
(2, 'Doctor', 'APR', NULL, '2025-11-23 15:46:57', 1, '2025-11-24 11:59:52', 'ACTIVE'),
(3, 'Patient', 'APR', NULL, '2025-11-23 15:47:05', 1, '2025-11-24 11:59:57', 'ACTIVE'),
(4, 'Nurse', 'APR', NULL, '2025-11-23 15:47:10', 1, '2025-11-24 12:00:00', 'ACTIVE'),
(5, 'USER', 'APR', 1, '2025-11-23 23:06:01', 1, '2025-11-24 12:00:05', NULL);

-- --------------------------------------------------------

INSERT INTO `users` (`id`, `UserName`, `email`, `Password`, `Enabled`, `account_locked`, `session_token`, `StatusCode`, `FirstName`, `LastName`, `RoleId`, `CreatedBy`, `CreatedAt`, `UpdatedBy`, `UpdatedAt`) VALUES
(1, 'Admin', 'nyeinkolat@gmail.com', '$2a$10$8E2iJX9EM3OF1U0k3In8E.wTC2Eo/GnTjCqOfkoDEDq2s5f3ZrGLu', 1, 0, NULL, 'APR', 'Nyein', 'Ko Lat', 1, 1, '2025-11-23 22:45:40', 3, '2025-11-30 18:04:25');
