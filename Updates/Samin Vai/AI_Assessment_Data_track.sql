WITH activityCTE AS (
	SELECT DISTINCT p.ApplyId, j.JP_ID, jp.CP_ID, c.NAME AS [Company Name], CONVERT(DATE, rp.CreatedOn, 101) AS [Creation Date],
	CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title] 
	from bdjCorporate..dbo_job_inbox j
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate.rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN bdjCorporate.rp.applicantprocess p on j.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	WHERE p.UpdatedOn >= '03/10/2024 14:00:00'
	--WHERE jp.PublishDate >= '03/10/2024 14:00:00'
)
, countAssessmentCTE AS (
	SELECT a.JP_ID, a.CP_ID, COUNT(DISTINCT a.ApplyId) AS [Number Of Applicants in AI Assessment Activity] 
	FROM activityCTE AS a
	GROUP BY a.JP_ID, a.CP_ID
)
, activityCountCTE AS (
	SELECT a.JP_ID, a.CP_ID,
	COUNT(DISTINCT ai.ApplyId) AS [Number of Applicants invited],
	COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL AND ai.FinalSubmitted = 1 THEN ai.ApplyId END) AS [Number of Applicants Submitted Voice Records],
	COUNT(DISTINCT CASE WHEN ai.ViewedOn IS NOT NULL THEN ai.ApplyId END) AS [Number of time view results button has been clicked]
	FROM activityCTE AS a
	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON ai.ApplyId = a.ApplyID
	GROUP BY a.JP_ID, a.CP_ID
)
--, rowCTE AS (
SELECT DISTINCT 
	a.JP_ID, a.[Company Name], a.CP_ID, 
	a.[Job Title],  
	a.[Creation date] AS [Assessment Activity Creation Date], 
	ca.[Number Of Applicants in AI Assessment Activity],
	CONVERT(DATE, ai.PostedOn, 101) AS [AI Assessment instructions Creation Date],
	c.[Number of Applicants invited], 
	c.[Number of Applicants Submitted Voice Records],
	c.[Number of time view results button has been clicked]
	--ROW_NUMBER() OVER(PARTITION BY a.JP_ID ORDER BY a.JP_ID, a.CP_ID) AS r 
	FROM activityCTE AS a
INNER JOIN activityCountCTE AS c ON c.JP_ID = a.JP_ID
INNER JOIN countAssessmentCTE AS ca ON ca.JP_ID = c.JP_ID
LEFT JOIN bdjCorporate.[aiass].[AIAssessmentInfo] AS ai ON ai.JP_ID = ca.JP_ID 
WHERE a.CP_ID NOT IN (114174, 35450, 38918, 110412)
--WHERE ai.PostedOn IS NOT NULL
--)

--SELECT r.[Company Title], r.CP_ID AS [Company Id], r.[Job Title],
--r.[Creation date] AS [Assessment Activity Creation Date], 
--r.[Number Of AI Applicants in AI Assessment Activity],
--r.[AI Assessment instructions Creation Date],
--r.[Number of Applicants invited], 
--r.[Number of Applicants Submitted Voice Records],
--r.[Number of time view results button has been clicked]
--FROM rowCTE AS r WHERE r = 1

--SELECT DISTINCT CP_ID FROM bdjCorporate..DBO_JOBPOSTINGS WHERE PublishDate > '03/10/2024 14:00:00' 

-- Cross Check

--SELECT DISTINCT j.JP_ID FROM dbo_JOBPOSTINGS AS jp 
--INNER JOIN dbo_job_inbox j ON j.JP_ID = jp.JP_ID
--INNER JOIN rp.TestSteps t ON t.JP_ID = j.JP_ID
--INNER JOIN rp.ApplicantProcess AS r ON r.LevelStatus = t.Testlevel AND r.ApplyId = j.ApplyId
--WHERE t.TestType = 'aiasmnt'
--AND r.UpdatedOn >= '03/10/2024 14:00:00' 


--SELECT TOP 5 * FROM bdjCorporate.[aiass].[AIAssessmentInfo]


--SELECT TOP 5 * FROM bdjCorporate.[aiass].[AIAssessmentInfo] WHERE JP_ID = 1236397 --1231955 --1236397

--CP_ID = 38245