SELECT TOP 5 * FROM bdjResumes..EDU
SELECT TOP 5 * FROM [dbo].[EDU_Edulevels]

SELECT TOP 100--DISTINCT TOP 10000
e.Ed_ID, e.EDUCATION, e.INSTITUTE AS [Foriegn Institute], 
e.EDUCATION AS [Exam], e.SUBJECT AS [Concentration], 
b.BoardName AS [Board], e.FICountry AS [Country Of Foreign University],
r.Result, e.PASSING_YEAR AS [Year Of Passing], e.PERCENT_MARK AS [CGPA], e.GRADE_SCALE AS [Scale], 
e.CourseDuration AS [Duration], e.ACHIEVEMENT, e.F_INSTITUTE FROM bdjResumes..EDU AS e
LEFT JOIN [dbo].[EDULEVEL] AS l ON l.E_CODE = e.Edulevel
LEFT JOIN [dbo].[EDU_Boards] AS b ON b.BoardID = e.BoardID
LEFT JOIN [dbo].[EDU_RESULT] AS r ON r.Result_Val = e.RESULT
--WHERE e.F_INSTITUTE = 1 AND e.P_ID = 3126 21704--21631--3126