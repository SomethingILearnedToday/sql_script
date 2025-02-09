SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER
PROCEDURE [dbo].[KSD_EarlyBird_NextYear]

AS
SET NOCOUNT ON

/*===============================
Author: Benjamin Hutter
Date created: April 02, 2024

Creating the Early Bird Fees 
due by April 30 
===============================*/ 

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
    '2024-04-30',
    0 AS exempt,
    NULL AS comments,
    190 AS amount,
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
    AND fa.feeID IN (12, 13, 14)
WHERE
    s.grade IN ('01','02','03','04','05')
    AND s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL;


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
    '2024-04-30',
    0 AS exempt,
    NULL AS comments,
    200 AS amount,
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
    AND fa.feeID IN (12, 13, 14)
WHERE
    s.grade IN ('06','07','08')
    AND s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL;



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
    '2024-04-30',
    0 AS exempt,
    NULL AS comments,
    180 AS amount,
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
    AND fa.feeID IN (12, 13, 14)
WHERE
    s.grade IN ('KG','EC')
    AND s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND s.endDate IS NULL
    AND fa.assignmentID IS NULL;

/**********************************************
Fee Adjustment
One time discount for the Early Bird Discount

Only creates this adjustment for 
next year's calendar and during the early bird 
discount period which will be during
the month of April
**********************************************/
-- Fee ID 12
INSERT INTO FeeAdjustment(
    assignmentID, amount, adjustmentDate, comments,createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT
    fa.assignmentID,
    35 amount,
    CONVERT(char(10), GETDATE(), 101) AS adjustmentDate,
    'Early Bird Discount' AS comments,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    FeeAssignment fa 
INNER JOIN
    student s ON s.personID = fa.personID
    AND fa.calendarID = s.calendarID
INNER JOIN
    calendar c ON c.calendarID = s.calendarID
WHERE
    s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND fa.feeID IN (12)
    AND MONTH(CONVERT(date, GETDATE())) = 4
    AND NOT EXISTS (
        SELECT 1
        FROM FeeAdjustment
        WHERE assignmentID = fa.assignmentID
    );


-- Fee ID 13
INSERT INTO FeeAdjustment(
    assignmentID, amount, adjustmentDate, comments,createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT
    fa.assignmentID,
    35 amount,
    CONVERT(char(10), GETDATE(), 101) AS adjustmentDate,
    'Early Bird Discount' AS comments,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    FeeAssignment fa 
INNER JOIN
    student s ON s.personID = fa.personID
    AND fa.calendarID = s.calendarID
INNER JOIN
    calendar c ON c.calendarID = s.calendarID
WHERE
    s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND fa.feeID IN (13)
    AND MONTH(CONVERT(date, GETDATE())) = 4
        AND NOT EXISTS (
        SELECT 1
        FROM FeeAdjustment
        WHERE assignmentID = fa.assignmentID
    );

--Fee ID 14
INSERT INTO FeeAdjustment(
    assignmentID, amount, adjustmentDate, comments,createdByID, createdDate, modifiedByID, modifiedDate
)
SELECT
    fa.assignmentID,
    35 amount,
    CONVERT(char(10), GETDATE(), 101) AS adjustmentDate,
    'Early Bird Discount' AS comments,
    1 AS createdByID,
    CONVERT(char(10), GETDATE(), 101) AS createdDate,
    1 AS modifiedByID,
    CONVERT(char(10), GETDATE(), 101) AS modifiedDate
FROM
    FeeAssignment fa 
INNER JOIN
    student s ON s.personID = fa.personID
    AND fa.calendarID = s.calendarID
INNER JOIN
    calendar c ON c.calendarID = s.calendarID
WHERE
    s.endYear > (SELECT endyear FROM schoolyear WHERE active = 1)
    AND fa.feeID IN (14)
    AND MONTH(CONVERT(date, GETDATE())) = 4
    AND NOT EXISTS (
        SELECT 1
        FROM FeeAdjustment
        WHERE assignmentID = fa.assignmentID    
    );


/*=================================
This removes the $35 adjustment 
IF there isn't any payment made

Set to run on 05/01 every year
==================================*/
DELETE FROM FeeAdjustment
WHERE amount = 35
AND assignmentID IN (
    SELECT ad.assignmentID
    FROM FeeAdjustment ad
    LEFT JOIN FeeAssignment fa ON fa.assignmentID = ad.assignmentID
    LEFT JOIN FeeCredit fc ON fc.assignmentID = fa.assignmentID
    LEFT JOIN FeePayment fp ON fp.paymentID = fc.paymentID
    WHERE fp.paymentID IS NULL
    AND ad.createdByID IN (1)
)
---Only works on the date specified
AND DAY(GETDATE()) = 1 AND MONTH(GETDATE()) = 5;


GO
