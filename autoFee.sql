SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER
PROCEDURE [dbo].[KSD_autoFee_current]

AS
SET NOCOUNT ON

/*===============================
Author: Benjamin Hutter
Date created: February 20, 2024

Automating Student Fees
===============================*/

/*********************************************
Fees for students in the current calendar 
while also considering pro-rated fees of 50% 
after the end of Q2
*********************************************/

/***********************************************
FeeID 13 - Grades 01-05
***********************************************/
INSERT INTO FeeAssignment (
    calendarID, personID, feeID, dueDate, exempt, comments, amount, createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT DISTINCT
    s.calendarID,
    s.personID,
    13 AS feeid,
    s.startdate,
    0 AS exempt,
    NULL AS comments,
    CASE
        WHEN s.startdate > (SELECT MAX(t.endDate) FROM term t WHERE t.seq = 2) THEN 95
        ELSE 190
    END AS amount,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    student s
INNER JOIN
    calendar c ON c.calendarID = s.calendarID

INNER JOIN calendarStructure cs ON cs.calendarID = s.calendarID
INNER JOIN TermSchedule ts ON ts.termScheduleID = cs.termScheduleID
INNER JOIN Term t ON t.termScheduleID = cs.termScheduleID 


LEFT JOIN
    FeeAssignment fa ON fa.personID = s.personID
    AND fa.calendarID = s.calendarID
    AND fa.feeID IN (12,13,14)
    AND ISNULL(fa.AssignmentID, 0) NOT IN (SELECT ISNULL(AssignmentID, 0) FROM FeeVoid)

WHERE
    s.endYear = (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.grade IN ('01','02','03','04','05')
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL
    AND NOT EXISTS (
    SELECT 1
    FROM FeeAssignment fa
    WHERE fa.personID = s.personID
    AND fa.feeID IN (12,13,14));


/***********************************************
FeeID 14 - Grades 06-08
***********************************************/
INSERT INTO FeeAssignment (
    calendarID, personID, feeID, dueDate, exempt, comments, amount, createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT DISTINCT
    s.calendarID,
    s.personID,
    14 AS feeid,
    s.startdate,
    0 AS exempt,
    NULL AS comments,
    CASE
        WHEN s.startdate > (SELECT MAX(t.endDate) FROM term t WHERE t.seq = 2) THEN 100
        ELSE 200
    END AS amount,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    student s
INNER JOIN
    calendar c ON c.calendarID = s.calendarID

INNER JOIN calendarStructure cs ON cs.calendarID = s.calendarID
INNER JOIN TermSchedule ts ON ts.termScheduleID = cs.termScheduleID
INNER JOIN Term t ON t.termScheduleID = cs.termScheduleID 


LEFT JOIN
    FeeAssignment fa ON fa.personID = s.personID
    AND fa.calendarID = s.calendarID
    AND fa.feeID IN (12,13,14)
    AND ISNULL(fa.AssignmentID, 0) NOT IN (SELECT ISNULL(AssignmentID, 0) FROM FeeVoid)

WHERE
    s.endYear = (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.grade IN ('06','07','08')
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL
    AND NOT EXISTS (
    SELECT 1
    FROM FeeAssignment fa
    WHERE fa.personID = s.personID
    AND fa.feeID IN (14));

/***********************************************
FeeID 12 - Grades EC/KG
***********************************************/
INSERT INTO FeeAssignment (
    calendarID, personID, feeID, dueDate, exempt, comments, amount, createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT DISTINCT
    s.calendarID,
    s.personID,
    12 AS feeid,
    s.startdate,
    0 AS exempt,
    NULL AS comments,
    CASE
        WHEN s.startdate > (SELECT MAX(t.endDate) FROM term t WHERE t.seq = 2) THEN 90
        ELSE 180
    END AS amount,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    student s
INNER JOIN
    calendar c ON c.calendarID = s.calendarID

INNER JOIN calendarStructure cs ON cs.calendarID = s.calendarID
INNER JOIN TermSchedule ts ON ts.termScheduleID = cs.termScheduleID
INNER JOIN Term t ON t.termScheduleID = cs.termScheduleID 


LEFT JOIN
    FeeAssignment fa ON fa.personID = s.personID
    AND fa.calendarID = s.calendarID
    AND fa.feeID IN (12,13,14)
    AND ISNULL(fa.AssignmentID, 0) NOT IN (SELECT ISNULL(AssignmentID, 0) FROM FeeVoid)

WHERE
    s.endYear = (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.grade IN ('KG','EC')
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL
    AND NOT EXISTS (
    SELECT 1
    FROM FeeAssignment fa
    WHERE fa.personID = s.personID
    AND fa.feeID IN (12,13,14));

GO
