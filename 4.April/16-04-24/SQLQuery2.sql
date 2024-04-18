SELECT TOP 5 * FROM bdjResumes..EDU 

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
, expCTE as (
, finalCTE AS (
	SELECT * FROM jobCTE AS j
	LEFT JOIN infoCTE AS i ON j.P_ID = i.P_ID 
	LEFT JOIN eduCTE1 AS e1 ON j.P_ID = e1.P_ID
	LEFT JOIN eduCTE2 AS e2 ON j.P_ID = e2.P_ID
	LEFT JOIN eduCTE3 AS e3 ON j.P_ID = e3.P_ID
	LEFT JOIN eduCTE4 AS e4 ON j.P_ID = e4.P_ID
	LEFT JOIN expCTE AS ex ON j.P_ID = ex.P_ID
)
SELECT 
	JP_ID, [Name], [Date of Birth], [Age as of Deadline], [Mobile No.], NID, [Present Location], [Permanent Location]
	,[Exam Name: SSC/Equivalent], [SSC/Passing Year], [SSC/Equivalent Board], [SSC/Equivalent Result], [SSC/Equivalent Instituion], [SSC/ Equivalent Group]
	,[Exam Name: HSC/Equivalent], [HSC/Passing Year], [HSC/Equivalent Board], [HSC/Equivalent Result], [HSC/Equivalent Instituion], [HSC/ Equivalent Group]
	,[Exam Name: Graduation/Equivalent], [Graduation/Passing Year], [Graduation/Equivalent Result], [Graduation University Name], [Graduation Instituion/Faculty Name], [Graduation on Major1], [Graduation on Major2]
	,[Exam Name: Post-Graduation/Equivalent], [Post-Graduation/Passing Year], [Post-Graduation/Equivalent Result], [Post-Graduation University Name], [Post-Graduation Instituion/Faculty Name], [Post-Graduation on Major1], [Post-Graduation on Major2]
	, currentExp_sdate AS [Starting Date in Current Organization], orgname1 AS [Current Organization], designation1 AS [Current Designation],
	, Experience3_sdate AS [Start Date in Previous Organization 2], Experience3_edate AS [End Date in Previous Organization 2], orgname3 AS [Previous organization 2], designation3 AS [Previous Designation 2],
	, Experience4_sdate AS [Start Date in Previous Organization 3], Experience4_edate AS [End Date in Previous Organization 3], orgname4 AS [Previous organization 3], designation4 AS [Previous Designation 3],
	, Experience5_sdate AS [Start Date in Previous Organization 4], Experience5_edate AS [End Date in Previous Organization 4], orgname5 AS [Previous organization 4], designation5 AS [Previous Designation 4]
FROM finalCTE









WITH jobCTE AS (
	SELECT DISTINCT JP_ID, P_ID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236811
)
, infoCTE AS (
	SELECT p.NAME AS [Name], CONVERT(DATE, p.BIRTH, 101) AS [Date of Birth], 
	DATEDIFF(year, p.[BIRTH], jp.deadline) AS [Age as of Deadline], u.accPhone AS [Mobile No.], NID,
	PRESENT_ADD AS [Present Location], PERMANENT_ADD AS [Permanent Location]
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..PERSONAL AS p ON j.P_ID = p.ID
	LEFT JOIN bdjResumes..UserAccounts AS u ON u.accID = p.ID
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON j.JP_ID = jp.JP_ID
)

SELECT TOP 100 * FROM bdjResumes..PERSONAL
SELECT TOP 100 * FROM bdjResumes.[dbo].[UserAccounts]

SELECT TOP 100 * FROM [dbo].[EXP] WHERE P_ID =  401589 --39511  --10173

SELECT TOP 5 * FROM [dbo].[LOCATIONS] WHERE L_ID = 14

SELECT TOP 5 * FROM vAddress



with maincte as (



-- Cross Checks

SELECT DISTINCT e.P_ID FROM bdjCorporate..DBO_JOB_INBOX AS j
LEFT JOIN bdjResumes..EDU AS e ON j.P_ID = e.P_ID
WHERE JP_ID = 1236811


with maincte as (


with person as (
