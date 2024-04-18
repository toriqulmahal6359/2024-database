WITH jobCTE AS (
	SELECT DISTINCT JP_ID, P_ID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236811
)
, infoCTE AS (
	SELECT DISTINCT p.ID AS P_ID, p.NAME AS [Name], CONVERT(DATE, p.BIRTH, 101) AS [Date of Birth], 
	DATEDIFF(year, p.[BIRTH], jp.deadline) AS [Age as of Deadline], u.accPhone AS [Mobile No.], NID,
	--PRESENT_ADD AS [Contact Address], --PERMANENT_ADD AS [Permanent Address],
	--PRESENT_ADD AS [Present Location], PERMANENT_ADD AS [Permanent Location],
	DATEDIFF(YEAR, 0, DATEADD(MONTH, s.TExp, 0)) AS [Total Experience]
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..PERSONAL AS p ON j.P_ID = p.ID
	LEFT JOIN bdjResumes..UserAccounts AS u ON j.P_ID = u.accID
	LEFT JOIN bdjResumes..UserSummary AS s ON j.P_ID = s.P_ID
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON j.JP_ID = jp.JP_ID
)
, addressCTE AS ( 
	SELECT J.P_ID, U1.Location AS PresentAddress, U2.Location AS PermanentAddress, U1.DistrictID AS D1, U2.DistrictID AS D2, U1.ThanaID
)
)
, locationCTE1 AS (
	SELECT DISTINCT P_ID, 
		   PresentAddress AS [Contact Address], 
		   PermanentAddress AS [Permanent Address], 
		   PresentDistrict AS [Present Location], 
		   PermanentDistrict AS [Permanent Location], 
		   PermanentDistrict AS [Home District]
		   , ROW_NUMBER() OVER(PARTITION BY P_ID ORDER BY PresentAddress, PermanentAddress DESC) AS [Row_Number]
	FROM locationCTE AS l
	--WHERE l.Row_Number = 1
)
, eduCTE1 AS (
	SELECT DISTINCT j.P_ID, e.Education AS [Exam Name: SSC/Equivalent], e.PASSING_YEAR AS [SSC/Passing Year], b.BoardName AS [SSC/Equivalent Board]
	, e.PERCENT_MARK AS [SSC/Equivalent Result]
	, e.INSTITUTE AS [SSC/Equivalent Instituion]
	, e.SUBJECT AS [SSC/ Equivalent Group]
	, ROW_NUMBER() OVER(PARTITION BY j.P_ID ORDER BY e.Passing_Year DESC) AS r1
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 1
)
, eduCTE2 AS (
	SELECT DISTINCT j.P_ID, e.Education AS [Exam Name: HSC/Equivalent], e.PASSING_YEAR AS [HSC/Passing Year], b.BoardName AS [HSC/Equivalent Board]
	, e.PERCENT_MARK AS [HSC/Equivalent Result]
	, e.INSTITUTE AS [HSC/Equivalent Instituion]
	, e.SUBJECT AS [HSC/ Equivalent Group]
	, ROW_NUMBER() OVER(PARTITION BY j.P_ID ORDER BY e.Passing_Year DESC) AS r2
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 2
)
, eduCTE3 AS (
	SELECT DISTINCT j.P_ID, e.Education AS [Exam Name: Graduation/Equivalent], e.PASSING_YEAR AS [Graduation/Passing Year]
	, e.PERCENT_MARK AS [Graduation/Equivalent Result]
	, e.INSTITUTE AS [Graduation University Name]
	, e.INSTITUTE AS [Graduation Instituion/Faculty Name]
	, e.SUBJECT AS [Graduation on Major1]
	, e.SUBJECT AS [Graduation on Major2]
	, ROW_NUMBER() OVER(PARTITION BY j.P_ID ORDER BY e.Passing_Year DESC) AS r3
	FROM jobCTE AS j												-- 66082 double entity
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 4
)
, eduCTE4 AS (
	SELECT DISTINCT j.P_ID, e.Education AS [Exam Name: Post-Graduation/Equivalent], e.PASSING_YEAR AS [Post-Graduation/Passing Year]
	, e.PERCENT_MARK AS [Post-Graduation/Equivalent Result]
	, e.INSTITUTE AS [Post-Graduation University Name]
	, e.INSTITUTE AS [Post-Graduation Instituion/Faculty Name]
	, e.SUBJECT AS [Post-Graduation on Major1]
	, e.SUBJECT AS [Post-Graduation on Major2]
	, ROW_NUMBER() OVER(PARTITION BY j.P_ID ORDER BY e.Passing_Year DESC) AS r4
	FROM jobCTE AS j												-- 66082 double entity
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 5
)
	, l.[Contact Address], l.[Permanent Address], l.[Present Location], l.[Permanent Location], l.[Home District]
	, e2.[Exam Name: HSC/Equivalent], e2.[HSC/Passing Year], e2.[HSC/Equivalent Board], e2.[HSC/Equivalent Result], e2.[HSC/Equivalent Instituion], e2.[HSC/ Equivalent Group]
	, e3.[Exam Name: Graduation/Equivalent], e3.[Graduation/Passing Year], e3.[Graduation/Equivalent Result], e3.[Graduation University Name], e3.[Graduation Instituion/Faculty Name], e3.[Graduation on Major1], e3.[Graduation on Major2]
	, e4.[Exam Name: Post-Graduation/Equivalent], e4.[Post-Graduation/Passing Year], e4.[Post-Graduation/Equivalent Result], e4.[Post-Graduation University Name], e4.[Post-Graduation Instituion/Faculty Name], e4.[Post-Graduation on Major1], e4.[Post-Graduation on Major2]
	, ex.Experience3_sdate AS [Start Date in Previous Organization 2], ex.Experience3_edate AS [End Date in Previous Organization 2], ex.orgname3 AS [Previous organization 2], ex.designation3 AS [Previous Designation 2]
	, ex.Experience4_sdate AS [Start Date in Previous Organization 3], ex.Experience4_edate AS [End Date in Previous Organization 3], ex.orgname4 AS [Previous organization 3], ex.designation4 AS [Previous Designation 3]
	, ex.Experience5_sdate AS [Start Date in Previous Organization 4], ex.Experience5_edate AS [End Date in Previous Organization 4], ex.orgname5 AS [Previous organization 4], ex.designation5 AS [Previous Designation 4]

, finalCTE AS (
SELECT DISTINCT
	j.JP_ID, j.P_ID, i.[Name], i.[Date of Birth], i.[Age as of Deadline], i.[Mobile No.], i.NID AS [NID Number] --, i.[Contact Address], i.[Permanent Address], i.[Present Location], i.[Permanent Location], i.[Home District]
	, l.[Contact Address], l.[Permanent Address], l.[Present Location], l.[Permanent Location], l.[Home District]
	, e1.[Exam Name: SSC/Equivalent], e1.[SSC/Passing Year], e1.[SSC/Equivalent Board], e1.[SSC/Equivalent Result], e1.[SSC/Equivalent Instituion], e1.[SSC/ Equivalent Group]
	, e2.[Exam Name: HSC/Equivalent], e2.[HSC/Passing Year], e2.[HSC/Equivalent Board], e2.[HSC/Equivalent Result], e2.[HSC/Equivalent Instituion], e2.[HSC/ Equivalent Group]
	, e3.[Exam Name: Graduation/Equivalent], e3.[Graduation/Passing Year], e3.[Graduation/Equivalent Result], e3.[Graduation University Name], e3.[Graduation Instituion/Faculty Name], e3.[Graduation on Major1], e3.[Graduation on Major2]
	, e4.[Exam Name: Post-Graduation/Equivalent], e4.[Post-Graduation/Passing Year], e4.[Post-Graduation/Equivalent Result], e4.[Post-Graduation University Name], e4.[Post-Graduation Instituion/Faculty Name], e4.[Post-Graduation on Major1], e4.[Post-Graduation on Major2]
	--, ex.currentExp_sdate AS [Starting Date in Current Organization], ex.orgname1 AS [Current Organization], ex.designation1 AS [Current Designation]
	--, ex.Experience3_sdate AS [Start Date in Previous Organization 2], ex.Experience3_edate AS [End Date in Previous Organization 2], ex.orgname3 AS [Previous organization 2], ex.designation3 AS [Previous Designation 2]
	--, ex.Experience4_sdate AS [Start Date in Previous Organization 3], ex.Experience4_edate AS [End Date in Previous Organization 3], ex.orgname4 AS [Previous organization 3], ex.designation4 AS [Previous Designation 3]
	--, ex.Experience5_sdate AS [Start Date in Previous Organization 4], ex.Experience5_edate AS [End Date in Previous Organization 4], ex.orgname5 AS [Previous organization 4], ex.designation5 AS [Previous Designation 4]
	, i.[Total Experience]
	, ROW_NUMBER() OVER(PARTITION BY j.P_ID ORDER BY j.P_ID) AS row_number
	-- e3.[Exam Name: Graduation/Equivalent], e4.[Exam Name: Post-Graduation/Equivalent]
FROM jobCTE AS j
	LEFT JOIN infoCTE AS i ON j.P_ID = i.P_ID
	LEFT JOIN locationCTE1 AS l ON j.P_ID = l.P_ID
	LEFT JOIN eduCTE1 AS e1 ON j.P_ID = e1.P_ID
	LEFT JOIN eduCTE2 AS e2 ON j.P_ID = e2.P_ID
	LEFT JOIN eduCTE3 AS e3 ON j.P_ID = e3.P_ID
	LEFT JOIN eduCTE4 AS e4 ON j.P_ID = e4.P_ID
	--LEFT JOIN expCTE AS ex ON j.P_ID = ex.P_ID
)
SELECT DISTINCT * FROM finalCTE
--WHERE P_ID = 300408
ORDER BY P_ID, row_number