


-- STEP 1: CREATE STUDENT TABLE

CREATE TABLE STUDENT (
    STUDENT_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(100)
);


-- STEP 2: CREATE COURSE TABLE

CREATE TABLE COURSE (
    COURSE_ID NUMBER PRIMARY KEY,
    COURSE_NAME VARCHAR2(50) NOT NULL
);


-- STEP 3: CREATE ENROLLMENT TABLE

CREATE TABLE ENROLLMENT (
    STUDENT_ID NUMBER NOT NULL,
    COURSE_ID NUMBER NOT NULL,
    MARKS NUMBER,

    CONSTRAINT CHK_MARKS
        CHECK (MARKS BETWEEN 0 AND 100),

    CONSTRAINT PK_ENROLLMENT
        PRIMARY KEY (STUDENT_ID, COURSE_ID),

    CONSTRAINT FK_STUDENT
        FOREIGN KEY (STUDENT_ID)
        REFERENCES STUDENT(STUDENT_ID),

    CONSTRAINT FK_COURSE
        FOREIGN KEY (COURSE_ID)
        REFERENCES COURSE(COURSE_ID)
);


-- STEP 4: INSERT STUDENT RECORDS

INSERT INTO STUDENT VALUES
(101, 'Ankita', 'ankita@example.com');

INSERT INTO STUDENT VALUES
(102, 'Riya', 'riya@example.com');

INSERT INTO STUDENT VALUES
(103, 'Priya', 'priya@example.com');

INSERT INTO STUDENT VALUES
(104, 'Rahul', 'rahul@example.com');


-- STEP 5: INSERT COURSE RECORDS

INSERT INTO COURSE VALUES (1, 'ADBMS');
INSERT INTO COURSE VALUES (2, 'Python');
INSERT INTO COURSE VALUES (3, 'DAA');
INSERT INTO COURSE VALUES (4, 'Data Science');

COMMIT;


-- ============================================
-- STEP 6: STORED PROCEDURE
-- WITH EXCEPTION HANDLING
-- ============================================

CREATE OR REPLACE PROCEDURE ADD_ENROLLMENT (
    P_STUDENT_ID IN NUMBER,
    P_COURSE_ID IN NUMBER,
    P_MARKS IN NUMBER
)
AS
    E_DUPLICATE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_DUPLICATE, -1);

    E_INVALID_REFERENCE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_INVALID_REFERENCE, -2291);

BEGIN

    IF P_MARKS IS NOT NULL AND
       (P_MARKS < 0 OR P_MARKS > 100) THEN

        RAISE_APPLICATION_ERROR(
            -20001,
            'Marks must be between 0 and 100'
        );
    END IF;

    INSERT INTO ENROLLMENT (
        STUDENT_ID, COURSE_ID, MARKS
    )
    VALUES (
        P_STUDENT_ID, P_COURSE_ID, P_MARKS
    );

    DBMS_OUTPUT.PUT_LINE(
        'Enrollment Successful'
    );

EXCEPTION

    WHEN E_DUPLICATE THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error: Student Already Enrolled'
        );
        RAISE;

    WHEN E_INVALID_REFERENCE THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error: Student or Course Does Not Exist'
        );
        RAISE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Enrollment Failed: ' || SQLERRM
        );
        RAISE;

END;
/


-- ============================================
-- STEP 7: ENROLL STUDENTS
-- ============================================

BEGIN

    ADD_ENROLLMENT(101, 1, 85);
    ADD_ENROLLMENT(101, 2, 90);
    ADD_ENROLLMENT(102, 1, 65);
    ADD_ENROLLMENT(103, 3, 35);
    ADD_ENROLLMENT(104, 4, 75);

    COMMIT;

END;
/


-- DISPLAY ENROLLMENT TABLE

SELECT * FROM ENROLLMENT
ORDER BY STUDENT_ID, COURSE_ID;


-- ============================================
-- STEP 8: FUNCTION TO CHECK RESULT
-- ============================================

CREATE OR REPLACE FUNCTION CHECK_RESULT (
    P_MARKS IN NUMBER
)
RETURN VARCHAR2
AS
    V_RESULT VARCHAR2(20);

BEGIN

    IF P_MARKS IS NULL THEN
        V_RESULT := 'NOT GRADED';

    ELSIF P_MARKS >= 40 THEN
        V_RESULT := 'PASS';

    ELSE
        V_RESULT := 'FAIL';

    END IF;

    RETURN V_RESULT;

END;
/


-- ============================================
-- STEP 9: CALL THE FUNCTION
-- ============================================

SELECT
    STUDENT_ID,
    COURSE_ID,
    MARKS,
    CHECK_RESULT(MARKS) AS RESULT
FROM ENROLLMENT
ORDER BY STUDENT_ID, COURSE_ID;


-- ============================================
-- STEP 10: EXPLICIT CURSOR
-- DISPLAY STUDENT RESULT DETAILS
-- ============================================

DECLARE

    CURSOR C_STUDENT IS
        SELECT
            S.NAME,
            C.COURSE_NAME,
            E.MARKS
        FROM STUDENT S
        JOIN ENROLLMENT E
            ON S.STUDENT_ID = E.STUDENT_ID
        JOIN COURSE C
            ON E.COURSE_ID = C.COURSE_ID
        ORDER BY S.STUDENT_ID, C.COURSE_ID;

    V_NAME STUDENT.NAME%TYPE;
    V_COURSE COURSE.COURSE_NAME%TYPE;
    V_MARKS ENROLLMENT.MARKS%TYPE;

BEGIN

    OPEN C_STUDENT;

    LOOP

        FETCH C_STUDENT
        INTO V_NAME, V_COURSE, V_MARKS;

        EXIT WHEN C_STUDENT%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || V_NAME ||
            ' | Course: ' || V_COURSE ||
            ' | Marks: ' ||
            NVL(TO_CHAR(V_MARKS), 'N/A') ||
            ' | Result: ' ||
            CHECK_RESULT(V_MARKS)
        );

    END LOOP;

    CLOSE C_STUDENT;

END;
/


-- ============================================
-- STEP 11: FINAL RESULT REPORT
-- ============================================

SELECT
    S.STUDENT_ID,
    S.NAME,
    C.COURSE_NAME,
    E.MARKS,
    CHECK_RESULT(E.MARKS) AS RESULT
FROM STUDENT S
JOIN ENROLLMENT E
    ON S.STUDENT_ID = E.STUDENT_ID
JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
ORDER BY S.STUDENT_ID, C.COURSE_ID;


-- ============================================
-- STEP 12: EXCEPTION HANDLING TESTS
-- RUN THESE SEPARATELY WHEN DEMONSTRATING
-- ============================================

-- TEST 1: DUPLICATE ENROLLMENT

BEGIN
    ADD_ENROLLMENT(101, 1, 85);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Duplicate Test Completed'
        );
END;
/


-- TEST 2: INVALID STUDENT ID

BEGIN
    ADD_ENROLLMENT(999, 1, 80);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Invalid Student Test Completed'
        );
END;
/


-- TEST 3: INVALID MARKS

BEGIN
    ADD_ENROLLMENT(102, 2, 120);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Invalid Marks Test Completed'
        );
END;
/

