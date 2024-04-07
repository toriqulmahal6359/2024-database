WITH jobCTE AS (

SELECT j.JP_ID, jp.CP_ID, c.NAME AS [Company Name], CONVERT(DATE, rp.CreatedOn, 101) AS [Creation Date],
	CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title],
	COUNT(DISTINCT p.ApplyId) AS [Number Of Applicants in AI Assessment Activity]
	from dbo_job_inbox j
	INNER JOIN DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN rp.applicantprocess p on j.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	INNER JOIN DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	WHERE p.UpdatedOn >= '03/10/2024 14:00:00'
	GROUP BY p.ApplyId, j.JP_ID, jp.CP_ID, c.NAME, rp.CreatedOn, jp.JobTitle, bj.TITLE, jp.JobLang 
)


	SELECT JP_ID, CP_ID,
	COUNT(DISTINCT ai.ApplyId) AS [Number of Applicants invited],
	COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL AND ai.FinalSubmitted = 1 THEN ai.ApplyId END) AS [Number of Applicants Submitted Voice Records],
	COUNT(DISTINCT CASE WHEN ai.ViewedOn IS NOT NULL THEN ai.ApplyId END) AS [Number of time view results button has been clicked]

	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON ai.ApplyId = j.ApplyID


	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentInfo] AS asi ON asi.JP_ID = j.JP_ID 
