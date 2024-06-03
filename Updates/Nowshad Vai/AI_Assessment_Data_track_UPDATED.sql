WITH activityCTE AS (
	SELECT DISTINCT j.JP_ID, jp.CP_ID, c.NAME AS [Company Name], 
	CONVERT(DATE, rp.CreatedOn, 101) AS [Creation Date],
	ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY rp.CreatedOn DESC) AS r,
	CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title] 
	from bdjCorporate..dbo_job_inbox j
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate.rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN bdjCorporate.rp.applicantprocess p on j.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	--WHERE p.UpdatedOn >= '03/10/2024 14:00:00' AND p.UpdatedOn <= '05/01/2024 00:00:00' AND j.P_ID NOT IN (SELECT P_ID FROM bdjCorporate..ListOfPID)
	WHERE rp.CreatedOn >= '03/10/2024 14:00:00' AND rp.CreatedOn <= '05/11/2024 00:00:00' AND j.P_ID NOT IN (SELECT P_ID FROM bdjCorporate..ListOfPID)
	AND jp.CP_ID NOT IN (114174, 35450, 38918, 110412)
	--WHERE jp.PublishDate >= '03/10/2024 14:00:00'
)
, countCTE AS (
	SELECT a.JP_ID, a.CP_ID, a.[Company Name], a.[Job Title], a.[Creation Date],
	COUNT(DISTINCT ji.ApplyId) AS [Number Of Applicants in AI Assessment Activity],
	COUNT(DISTINCT ai.ApplyId) AS [Number of Applicants invited],
	COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL AND ai.FinalSubmitted = 1 THEN ai.ApplyId END) AS [Number of Applicants Submitted Voice Records],
	COUNT(DISTINCT CASE WHEN ai.ViewedOn IS NOT NULL THEN ai.ApplyId END) AS [Number of time view results button has been clicked]
	FROM activityCTE AS a
	INNER JOIN bdjCorporate..dbo_job_inbox AS ji ON ji.JP_ID = a.JP_ID
	INNER JOIN bdjCorporate.rp.TestSteps rp ON ji.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN bdjCorporate.rp.applicantprocess p on ji.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON ji.ApplyId = ai.ApplyID
	WHERE r = 1
	GROUP BY a.JP_ID, a.CP_ID, a.[Company Name], a.[Job Title], a.[Creation Date]
)
, infoCTE AS (
	SELECT c.*, 
		--ai.PostedOn,
		CONVERT(DATE, ai.PostedOn, 101) AS [AI Assessment instructions Creation Date],
		ROW_NUMBER() OVER(PARTITION BY c.JP_ID ORDER BY ai.PostedOn DESC) r
	FROM countCTE AS c
	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentInfo] AS ai ON c.JP_ID = ai.JP_ID 
)
SELECT i.JP_ID, i.[Company Name], i.CP_ID, 
	i.[Job Title],  
	i.[Creation date] AS [Assessment Activity Creation Date], 
	i.[Number Of Applicants in AI Assessment Activity],
	i.[AI Assessment instructions Creation Date],
	i.[Number of Applicants invited], 
	i.[Number of Applicants Submitted Voice Records],
	i.[Number of time view results button has been clicked]
FROM infoCTE AS i WHERE r = 1