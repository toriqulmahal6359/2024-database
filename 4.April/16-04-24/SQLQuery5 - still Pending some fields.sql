WITH jobCTE AS (
	SELECT DISTINCT JP_ID, P_ID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236811
)
, infoCTE AS (
	SELECT p.ID AS P_ID, p.NAME AS [Name], CONVERT(DATE, p.BIRTH, 101) AS [Date of Birth], 
	DATEDIFF(year, p.[BIRTH], jp.deadline) AS [Age as of Deadline], u.accPhone AS [Mobile No.], NID,
	PRESENT_ADD AS [Present Location], PERMANENT_ADD AS [Permanent Location]
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..PERSONAL AS p ON j.P_ID = p.ID
	LEFT JOIN bdjResumes..UserAccounts AS u ON u.accID = p.ID
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON j.JP_ID = jp.JP_ID
)
, eduCTE1 AS (
	SELECT j.P_ID, e.Education AS [Exam Name: SSC/Equivalent], e.PASSING_YEAR AS [SSC/Passing Year], b.BoardName AS [SSC/Equivalent Board]
	, e.PERCENT_MARK AS [SSC/Equivalent Result]
	, e.INSTITUTE AS [SSC/Equivalent Instituion]
	, e.SUBJECT AS [SSC/ Equivalent Group]
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 1
)
, eduCTE2 AS (
	SELECT j.P_ID, e.Education AS [Exam Name: HSC/Equivalent], e.PASSING_YEAR AS [HSC/Passing Year], b.BoardName AS [HSC/Equivalent Board]
	, e.PERCENT_MARK AS [HSC/Equivalent Result]
	, e.INSTITUTE AS [HSC/Equivalent Instituion]
	, e.SUBJECT AS [HSC/ Equivalent Group]
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 2
)
, eduCTE3 AS (
	SELECT j.P_ID, e.Education AS [Exam Name: Graduation/Equivalent], e.PASSING_YEAR AS [Graduation/Passing Year]
	, e.PERCENT_MARK AS [Graduation/Equivalent Result]
	, e.INSTITUTE AS [Graduation University Name]
	, e.INSTITUTE AS [Graduation Instituion/Faculty Name]
	, e.SUBJECT AS [Graduation on Major1]
	, e.SUBJECT AS [Graduation on Major2]
	--, ROW_NUMBER() OVER(PARTITION BY P_ID ORDER BY e.Passing_Year DESC)
	FROM jobCTE AS j												-- 66082 double entity
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 4
)
, eduCTE4 AS (
	SELECT j.P_ID, e.Education AS [Exam Name: Post-Graduation/Equivalent], e.PASSING_YEAR AS [Post-Graduation/Passing Year]
	, e.PERCENT_MARK AS [Post-Graduation/Equivalent Result]
	, e.INSTITUTE AS [Post-Graduation University Name]
	, e.INSTITUTE AS [Post-Graduation Instituion/Faculty Name]
	, e.SUBJECT AS [Post-Graduation on Major1]
	, e.SUBJECT AS [Post-Graduation on Major2]
	FROM jobCTE AS j												-- 66082 double entity
	LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
	LEFT JOIN bdjResumes..[EDU_Boards] AS b ON e.BoardID = b.BoardID
	WHERE Edulevel = 5
)
, expCTE as (SELECT     p_id,    MAX(CASE WHEN rn = 1 THEN Efrom END) AS currentExp_sdate,	MAX(CASE WHEN rn = 1 THEN Eto END) AS currentExp_edate,	MAX(CASE WHEN rn = 1 THEN company END) AS orgname1,	MAX(CASE WHEN rn = 1 THEN eposition END) AS designation1,    MAX(CASE WHEN rn = 2 THEN Efrom END) AS Experience2_sdate,	MAX(CASE WHEN rn = 2 THEN Eto END) AS Experience2_edate,	MAX(CASE WHEN rn = 2 THEN company END) AS orgname2,	MAX(CASE WHEN rn = 2 THEN eposition END) AS designation2,    MAX(CASE WHEN rn = 3 THEN Efrom END) AS Experience3_sdate,	MAX(CASE WHEN rn = 3 THEN Eto END) AS Experience3_edate,	MAX(CASE WHEN rn = 3 THEN company END) AS orgname3,	MAX(CASE WHEN rn = 3 THEN eposition END) AS designation3,    MAX(CASE WHEN rn = 4 THEN Efrom END) AS Experience4_sdate,	MAX(CASE WHEN rn = 4 THEN Eto END) AS Experience4_edate,	MAX(CASE WHEN rn = 4 THEN company END) AS orgname4,	MAX(CASE WHEN rn = 4 THEN eposition END) AS designation4,	MAX(CASE WHEN rn = 5 THEN Efrom END) AS Experience5_sdate,	MAX(CASE WHEN rn = 5 THEN Eto END) AS Experience5_edate,	MAX(CASE WHEN rn = 5 THEN company END) AS orgname5,	MAX(CASE WHEN rn = 5 THEN eposition END) AS designation5FROM (    SELECT         e.p_id,		e.company,		e.eposition,        e.Efrom,		e.eto,        ROW_NUMBER() OVER (PARTITION BY e.p_id ORDER BY e.Efrom DESC) AS rn    FROM jobCTE AS j 	INNER join exp e on j.P_ID = e.P_ID) AS subqueryGROUP BY p_id)

, finalCTE AS (
SELECT 
	j.JP_ID, j.P_ID, i.[Name], i.[Date of Birth], i.[Age as of Deadline], i.[Mobile No.], i.NID, i.[Present Location], i.[Permanent Location]
	,e1.[Exam Name: SSC/Equivalent], e1.[SSC/Passing Year], e1.[SSC/Equivalent Board], e1.[SSC/Equivalent Result], e1.[SSC/Equivalent Instituion], e1.[SSC/ Equivalent Group]
	,e2.[Exam Name: HSC/Equivalent], e2.[HSC/Passing Year], e2.[HSC/Equivalent Board], e2.[HSC/Equivalent Result], e2.[HSC/Equivalent Instituion], e2.[HSC/ Equivalent Group]
	,e3.[Exam Name: Graduation/Equivalent], e3.[Graduation/Passing Year], e3.[Graduation/Equivalent Result], e3.[Graduation University Name], e3.[Graduation Instituion/Faculty Name], e3.[Graduation on Major1], e3.[Graduation on Major2]
	,e4.[Exam Name: Post-Graduation/Equivalent], e4.[Post-Graduation/Passing Year], e4.[Post-Graduation/Equivalent Result], e4.[Post-Graduation University Name], e4.[Post-Graduation Instituion/Faculty Name], e4.[Post-Graduation on Major1], e4.[Post-Graduation on Major2]
	, ex.currentExp_sdate AS [Starting Date in Current Organization], ex.orgname1 AS [Current Organization], ex.designation1 AS [Current Designation]	, ex.Experience2_sdate AS [Start Date in Previous Organization 1], ex.Experience2_edate AS [End Date in Previous Organization 1], ex.orgname2 AS [Previous organization 1], ex.designation2 AS [Previous Designation 1]
	, ex.Experience3_sdate AS [Start Date in Previous Organization 2], ex.Experience3_edate AS [End Date in Previous Organization 2], ex.orgname3 AS [Previous organization 2], ex.designation3 AS [Previous Designation 2]
	, ex.Experience4_sdate AS [Start Date in Previous Organization 3], ex.Experience4_edate AS [End Date in Previous Organization 3], ex.orgname4 AS [Previous organization 3], ex.designation4 AS [Previous Designation 3]
	, ex.Experience5_sdate AS [Start Date in Previous Organization 4], ex.Experience5_edate AS [End Date in Previous Organization 4], ex.orgname5 AS [Previous organization 4], ex.designation5 AS [Previous Designation 4]
FROM jobCTE AS j
	LEFT JOIN infoCTE AS i ON j.P_ID = i.P_ID 
	LEFT JOIN eduCTE1 AS e1 ON j.P_ID = e1.P_ID
	LEFT JOIN eduCTE2 AS e2 ON j.P_ID = e2.P_ID
	LEFT JOIN eduCTE3 AS e3 ON j.P_ID = e3.P_ID
	LEFT JOIN eduCTE4 AS e4 ON j.P_ID = e4.P_ID
	LEFT JOIN expCTE AS ex ON j.P_ID = ex.P_ID
)

SELECT * FROM finalCTE