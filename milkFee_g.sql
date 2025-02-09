/*===============================
Author: Benjamin Hutter
Date created: February 05, 2025

Assigning fee for milk choice
FeeID:
07 -- Fall Semester
08 -- Spring Semester
===============================*/ 

INSERT INTO FeeAssignment (calendarID, personID, feeID, dueDate)
SELECT DISTINCT 
FROM Student s
INNER JOIN CustomStudent m ON m.enrollmentID = s.enrollmentID
INNER JOIN calendar ca ON ca.calenderID = s.calendarID
WHERE m.value IN ('C','W')
AND s.endYear >= (SELECT endyear FROM schoolyear WHERE active = 1)
AND (s.enddate IS NULL OR s.enddate > getdate())
AND NOT EXISTS (
    SELECT feeID
    FROM FeeAssignment
    WHERE feeID IN (7)
);

INSERT INTO FeeAssignment (calendarID, personID, feeID, amount, dueDate, exempt, comments, createdByID, createdDate, modifiedByID, modifiedDate)
SELECT DISTINCT 
s.calendarID,
m.personId,
'8',
'26' amount,
ca.startDate + 150,
'0' exempt,
'null' comments,
'1' createdByID,
convert(char(10),getdate(),101) createdDate,
'1' modifiedByID,
convert(char(10),getdate(),101) modifiedDate
FROM student s
INNER JOIN CustomStudent m ON m.enrollmentID = s.enrollmentID AND m.attributeID IN(SELECT attributeid FROM CampusAttribute WHERE object = 'enrollment' AND element = 'Milk') --and s.personID = 25993
LEFT JOIN CustomStudent w ON w.enrollmentID = s.enrollmentID AND w.attributeID IN(SELECT attributeid FROM CampusAttribute WHERE object = 'enrollment' AND element = 'Milk Waiver')
INNER JOIN calendar ca ON ca.calendarID = s.calendarID 
WHERE m.value IN ('C','W')
AND s.endYear >= (SELECT endyear FROM schoolyear WHERE active = 1)
AND (s.enddate IS NULL OR s.enddate > getdate())
AND NOT EXISTS (
    SELECT 1
    FROM FeeAssignment fa
    WHERE fa.personID = s.personID
      AND fa.feeID = 8
);

INSERT INTO FeeAssignment (calendarID, personID, feeID, amount, dueDate, exempt, comments, createdByID, createdDate, modifiedByID, modifiedDate)
SELECT DISTINCT 
s.calendarID,
m.personId,
'7',
'26' amount,
ca.startDate + 21,
'0' exempt,
'null' comments,
'1' createdByID,
convert(char(10),getdate(),101) createdDate,
'1' modifiedByID,
convert(char(10),getdate(),101) modifiedDate
FROM student s
INNER JOIN CustomStudent m ON m.enrollmentID = s.enrollmentID AND m.attributeID IN(SELECT attributeid FROM CampusAttribute WHERE object = 'enrollment' AND element = 'Milk')
LEFT JOIN CustomStudent w ON w.enrollmentID = s.enrollmentID AND w.attributeID IN(SELECT attributeid FROM CampusAttribute WHERE object = 'enrollment' AND element = 'Milk Waiver')
INNER JOIN calendar ca ON ca.calendarID = s.calendarID 
WHERE m.value IN ('C','W')
AND s.endYear >= (SELECT endyear FROM schoolyear WHERE active = 1)
AND (s.enddate IS NULL OR s.enddate > getdate())
AND NOT EXISTS (
    SELECT 1
    FROM FeeAssignment fa
    WHERE fa.personID = s.personID
      AND fa.feeID = 7
);
/***
select top (1)*
from CampusAttribute
WHERE object = 'enrollment' AND element = 'Milk Waiver'

DELETE FROM FeeAssignment
WHERE feeID IN (7, 8)
AND createdDate = CAST(GETDATE() AS DATE);
**/
