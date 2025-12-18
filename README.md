## Health Care Appointment & Patient Visit Management System
### Overview
This repository contains the relational database design and implementation for the HealthCare Management System.
The database supports patient registration, doctor scheduling, appointment booking, clinical visits, and diagnosis recording.

The database is designed using MySQL, follows BCNF (Boyce–Codd Normal Form) principles, and integrates seamlessly with a Spring Boot backend (Java repository linked below).

🔗 **Backend (Java) Repository**:
(https://github.com/Nyein-Ko-Lat/HealthCareSystem)

### 🧱 Database Design
🔹 Core Entities

The database consists of the following key entities:

<table>
  <thead>
    <tr>
      <th>Entity</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>patients</td>
      <td>Stores patient demographic and medical profile data</td>
    </tr>
    <tr>
      <td>family_history</td>
      <td>Family medical background of patients</td>
    </tr>
    <tr>
      <td>doctors</td>
      <td>Stores doctor information and specialization</td>
    </tr>
    <tr>
      <td>doctor_schedules</td>
      <td>Weekly availability schedules for doctors</td>
    </tr>
    <tr>
      <td>appointments</td>
      <td>Appointment bookings between patients and doctors</td>
    </tr>
    <tr>
      <td>patient_visits</td>
      <td>Stores doctor information and specialization</td>
    </tr>
    <tr>
      <td>patient_conditions</td>
      <td>Diagnosed conditions during patient visits</td>
    </tr>
    <tr>
      <td>status_codes</td>
      <td>Centralized status management (APR, FIN, DEL, etc.)</td>
    </tr>
  </tbody>
</table>

### ER Diagram

A detailed Entity Relationship Diagram (ERD) can be found here "https://github.com/Nyein-Ko-Lat/HealthCareSystemDatabase/blob/main/HealthCareManagementSystem_ERD.pdf".


### Database Setup (MySQL)
Run Database Scripts (IMPORTANT ORDER)
_**Script Location : https://github.com/Nyein-Ko-Lat/HealthCareSystem/tree/master/DatabaseFiles**_
Execute the following SQL files in order:

01_db_schema.sql : **Creates all tables + insert required Roles, Status Code, and Admin User**

Defines primary keys, foreign keys, constraints, and relationships

02_triggers.sql :

Creates database triggers for data consistency and automation

03_views.sql :

Creates database views used for reporting, dashboard queries, and all listing and get data store procedures use views

04_stored_procedures.sql

Creates stored procedures used by the application and reports

⚠️ Do not change the order, as later scripts depend on earlier objects.
Dashboard & Report Data Setup

To support dashboard and reporting features, sample data is provided via SQL scripts.

### Master Data Insert

05_db_insert_data.sql : Inserts following master data

Doctors, Patients, Doctor schedules

⚠️ _**This script:**_ :

_Deletes all existing related data_

_Resets auto-increment values_

_Prevents duplicate record conflicts_

### Transaction Data Insert

06_db_insert_transactions.sql : Inserts following transaction tables

Appointments, Patient visits, Consultation / diagnosis records

⚠️ **_Depends on data created in the previous script_**
