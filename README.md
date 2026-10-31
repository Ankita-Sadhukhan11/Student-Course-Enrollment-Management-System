# Student-Course-Enrollment-Management-System
ADBMS mini project using Oracle PL/SQL, stored procedures, functions, cursors and exception handling.


# Student Course Enrollment and Result Management System

## Project Overview

The **Student Course Enrollment and Result Management System** is an ADBMS mini project developed using **Oracle SQL and PL/SQL**.

The project manages student information, course details, student enrollments, and examination results. It demonstrates the practical implementation of stored procedures, functions, explicit cursors, and exception handling in Oracle Database.

## Technologies Used

- **Database:** Oracle Database (Oracle FreeSQL)
- **Language:** SQL and PL/SQL
- **Development Environment:** Oracle FreeSQL SQL Worksheet

## Project Features

### 1. Student Management
- Stores student ID, name, and email.
- Maintains student records in the database.

### 2. Course Management
- Stores course ID and course name.
- Maintains available course information.

### 3. Student Enrollment — Stored Procedure
- Uses the `ADD_ENROLLMENT` procedure.
- Enrolls students into courses.
- Prevents duplicate enrollment using a composite primary key.
- Handles invalid enrollment operations.

### 4. Result Calculation — Function
- Uses the `CHECK_RESULT` function.
- Calculates results based on student marks.
- **PASS:** Marks greater than or equal to 40.
- **FAIL:** Marks below 40.
- **NOT GRADED:** Marks not yet assigned.

### 5. Student Result Display — Explicit Cursor
- Uses the `C_STUDENT` cursor.
- Retrieves student names, courses, and marks.
- Displays student results one record at a time using `OPEN`, `FETCH`, and `CLOSE`.

### 6. Exception Handling
Handles errors such as:
- Duplicate student enrollment
- Invalid student or course ID
- Marks outside the allowed range of 0–100

## Database Structure

The project uses three relational tables.

| Table Name | Description |
|---|---|
| `STUDENT` | Stores student details |
| `COURSE` | Stores course details |
| `ENROLLMENT` | Stores student-course enrollment and marks |

Primary keys, foreign keys, and constraints maintain data integrity.

## PL/SQL Concepts Implemented

| Concept | Implementation |
|---|---|
| Stored Procedure | `ADD_ENROLLMENT` |
| Function | `CHECK_RESULT` |
| Explicit Cursor | `C_STUDENT` |
| Exception Handling | `EXCEPTION`, `RAISE_APPLICATION_ERROR` |
| Data Integrity | Primary Key, Foreign Key, CHECK Constraint |

## Sample Output

| Student Name | Course | Marks | Result |
|---|---|---|---|
| Ankita | ADBMS | 85 | PASS |
| Ankita | Python | 90 | PASS |
| Riya | ADBMS | 65 | PASS |
| Priya | DAA | 35 | FAIL |
| Rahul | Data Science | 75 | PASS |

*The passing threshold of 40 marks is assumed for this project.*

## How to Run the Project

1. Open **Oracle FreeSQL** and connect to your Oracle database.
2. Open the SQL Worksheet.
3. Open `Student_Course_Enrollment.sql`.
4. Execute the script in the provided sequence.
5. Enable DBMS Output to view procedure and cursor messages.
6. Run the final SELECT query to display student results.

**Note:** The script is intended for first-time execution. If the tables or sample records already exist, running it again may produce duplicate-object or duplicate-record errors.

## Project Objectives

- Understand relational database design.
- Implement stored procedures for student enrollment.
- Use PL/SQL functions to calculate examination results.
- Retrieve records using explicit cursors.
- Handle database errors using exception handling.
- Maintain data integrity using database constraints.

## Conclusion

This project demonstrates how Oracle SQL and PL/SQL can be used to manage student course enrollments and examination results efficiently.

It provides a practical understanding of stored procedures, functions, cursors, exception handling, and relational database constraints.

---

