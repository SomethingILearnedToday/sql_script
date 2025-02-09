SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER
PROCEDURE [dbo].[KSD_GraduationFee]

AS
SET NOCOUNT ON

/*=================================
Graduation Fees for 8th Grade
in current year calendar

Ignoring Outplaced students
==================================*/
/*INSERT INTO FeeAssignment (
    calendarID, personID, feeID, dueDate, exempt, comments, amount, createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT DISTINCT
    s.calendarID,
    s.personID,
    5 AS feeid,
    s.startDate,
    0 AS exempt,
    NULL AS comments,
    40 AS amount,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    student s
INNER JOIN
    calendar c ON c.calendarID = s.calendarID
LEFT JOIN
    FeeAssignment fa ON fa.personID = s.personID
    AND fa.calendarID = s.calendarID
    AND fa.feeID IN (4,5)
WHERE
    s.grade IN ('08')
    AND s.endYear = (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL
    --AND s.personID IN (28504)
    AND s.schoolID NOT IN (8);*/


/*=================================
Graduation Fees for 8th Grade
in next years calendar

Ignoring Outplaced students
==================================*/
INSERT INTO FeeAssignment (
    calendarID, personID, feeID, dueDate, exempt, comments, amount, createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT DISTINCT
    s.calendarID,
    s.personID,
    5 AS feeid,
    s.startDate,
    0 AS exempt,
    NULL AS comments,
    40 AS amount,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    student s
INNER JOIN
    calendar c ON c.calendarID = s.calendarID
LEFT JOIN
    FeeAssignment fa ON fa.personID = s.personID
    AND fa.calendarID = s.calendarID
    AND fa.feeID IN (4,5)
WHERE
    s.grade IN ('08')
    AND s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL
    AND s.schoolID NOT IN (8);

GO
