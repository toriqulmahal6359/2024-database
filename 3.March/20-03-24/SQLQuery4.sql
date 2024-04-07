--WITH jobCTE AS (
	--SELECT DISTINCT j.JP_ID,
	--j.CP_ID, 
	--CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], 
	--c.NAME AS [Company Name]
	--, i.ApplyID
	--FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	--LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	--INNER JOIN bdjCorporate..DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID
	--INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	----WHERE j.PublishDate >= '03/10/2024 14:00:00'  
	----AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
)
WITH activityCTE AS (
	SELECT p.ApplyId, j.JP_ID, jp.CP_ID, c.NAME AS [Company Title], rp.CreatedOn AS [Creation Date],
	CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title] 
	from dbo_job_inbox j
	INNER JOIN DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	inner join rp.applicantprocess p on j.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	INNER JOIN DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	WHERE p.UpdatedOn >= '03/10/2024 14:00:00'
)
, countAssessmentCTE AS (
	SELECT a.JP_ID, a.CP_ID COUNT(DISTINCT a.ApplyId) AS [Number Of AI Applicants in AI Assessment Activity] 
	FROM activityCTE AS a
	GROUP BY a.JP_ID, a.CP_ID
)
, activityCountCTE AS (
	SELECT a.JP_ID, a.CP_ID,
	COUNT(DISTINCT ai.ApplyId) AS [Number of Applicants invited],
	COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL AND ai.FinalSubmitted = 1 THEN ai.ApplyId END) AS [Number of Applicants Submitted Voice Records],
	COUNT(DISTINCT CASE WHEN ai.ViewedOn IS NOT NULL THEN ai.ApplyId END) AS [Number of time view results button has been clicked]
	FROM activityCTE AS a
	JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON ai.ApplyId = a.ApplyID
	GROUP BY a.JP_ID, a.CP_ID
)
, rowCTE AS (
SELECT a.JP_ID, a.CP_ID, a.[Job Title], a.[Company Title], a.[Creation date], 
	c.[Number of Applicants invited], 
	c.[Number of Applicants Submitted Voice Records],
	c.[Number of time view results button has been clicked],
	ca.[Number Of AI Applicants in AI Assessment Activity],
	a.PostedOn AS [AI Assessment instructions Creation Date],
	ROW_NUMBER() OVER(PARTITION BY a.JP_ID ORDER BY a.JP_ID, a.CP_ID) AS r 
	FROM activityCTE AS a
INNER JOIN activityCountCTE AS c ON c.JP_ID = a.JP_ID
INNER JOIN countAssessmentCTE AS ca ON ca.JP_ID = c.JP_ID
INNER JOIN bdjCorporate.[aiass].[AIAssessmentInfo] AS a ON a.JP_ID = ca.JP_ID 
)

SELECT * FROM rowCTE WHERE r = 1

GO

--SELECT a.JP_ID, a.CP_ID, COUNT(DISTINCT p.ApplyId) FROM aiactivityCTE AS a
--GROUP BY a.JP_ID, a.CP_ID

--, processCTE AS (
--	SELECT a.ApplyID, a.JP_ID, a.[CP_ID], a.[Company Name], a.[Job Title], 
--	a.[Activity Creation Date], a.TestLevel FROM aiactivityCTE AS a
--	INNER JOIN bdjCorporate.rp.ApplicantProcess AS p ON p.ApplyId = a.ApplyID AND a.TestLevel = p.LevelStatus
--)
--, assessmentCreation AS (
--	SELECT p.ApplyID, p.JP_ID, p.[CP_ID], p.[Company Name], p.[Job Title], 
--		p.[Activity Creation Date], p.TestLevel, a.PostedOn AS [Assessment Creation Date] FROM processCTE AS p
--		LEFT JOIN bdjCorporate.[aiass].[AIAssessmentInfo] AS a ON a.JP_ID = p.JP_ID
--)
--SELECT * FROM assessmentCreation


-- Cross Check 

SELECT rpp.*
from dbo_job_inbox ji
INNER JOIN rp.TestSteps rp ON ji.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
inner join rp.applicantprocess rpp on ji.ApplyID = rpp.ApplyId AND rpp.Levelstatus = rp.TestLevel
WHERE rpp.UpdatedOn >= '03/10/2024 14:00:00'

SELECT TOP 5 * FROM bdjCorporate.[aiass].[AIAssessmentInfo]