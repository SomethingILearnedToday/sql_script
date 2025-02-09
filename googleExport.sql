SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[google_csv_export]
AS
BEGIN

/*===============================
Author: Benjamin Hutter
Date created: May 13, 2023
===============================*/

    SELECT id.firstName as 'First Name [Required]', id.lastName as 'Last Name [Required]', REPLACE(REPLACE(UPPER(id.firstName + id.lastName  + '.' +
CASE
    WHEN e.grade = 'KG' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 8))
    WHEN e.grade = '01' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 7))
    WHEN e.grade = '02' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 6))
    WHEN e.grade = '03' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 5))
    WHEN e.grade = '04' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 4))
    WHEN e.grade = '05' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 3))
    WHEN e.grade = '06' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 2))
    WHEN e.grade = '07' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 1))
    WHEN e.grade = '08' THEN CONVERT(varchar(10),(cal.endYear - 2000 + 0))
END


   + '@ksd140.org'), ' ', ''),'''','')
    AS 'Email Address [Required]', 'Kirby' + p.studentNumber AS 'Password [Required]', e.grade as 'Grade', cal.name as "Calendar", '/School/Students' AS 'Org Unit Path [Required]'

FROM person p

    LEFT JOIN contact c on c.personID = p.personID
    INNER JOIN [Identity] id on id.personID = p.personID
    INNER JOIN Enrollment e on e.personID = p.personID
    INNER JOIN Calendar cal on cal.calendarID=e.calendarID AND cal.endYear = (SELECT endyear FROM SchoolYear where active=1)


WHERE (p.studentNumber IS NOT NULL) AND (e.endDate IS NULL OR e.endDate > getdate()) AND
(e.grade <> 'EP') AND (e.grade <> 'EC') AND (e.grade <> 'EW') AND (p.studentnumber < 9999)
AND (c.email IS NULL )

ORDER BY p.studentnumber DESC





END

GO
