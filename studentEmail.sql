SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertStudentEmails]
AS
BEGIN

/*===============================
Author: Benjamin Hutter
Date created: May 13, 2023

Creating Student Email
===============================*/

    INSERT INTO dbo.Contact (personID, email, emailMessenger) SELECT DISTINCT p.personID,
        (REPLACE(UPPER(
        CASE
            WHEN e.grade = 'KG' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 8)))
            WHEN e.grade = '01' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 7)))
            WHEN e.grade = '02' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 6)))
            WHEN e.grade = '03' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 5)))
            WHEN e.grade = '04' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 4)))
            WHEN e.grade = '05' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 3)))
            WHEN e.grade = '06' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 2)))
            WHEN e.grade = '07' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 1)))
            WHEN e.grade = '08' THEN (id.firstname + id.lastName + '.' + CONVERT(varchar(10),(cal.endYear - 2000 + 0)))
        END
        + '@ksd140.org' ), ' ', '')) as email,
        172 AS messenger
    FROM dbo.person p
         INNER JOIN [Identity] id on id.personID = p.personID
         INNER JOIN Enrollment e on e.personID = p.personID
         INNER JOIN Calendar cal on cal.calendarID=e.calendarID AND cal.endYear = (SELECT endyear FROM SchoolYear where active=1)+1


         LEFT OUTER JOIN contact c on p.personID = c.personID


    WHERE (p.studentNumber IS NOT NULL) AND (e.endDate IS NULL OR e.endDate > getdate())
    AND (e.grade <> 'EP') AND (e.grade <> 'EC') AND (e.grade <> 'EW')
    AND (c.email IS NULL) AND (c.personID IS NULL)

END

GO
