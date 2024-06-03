--Number of Applicants in AI assessment Activity
SELECT TOP 5 * FROM bdjCorporate.rp.applicantprocess
SELECT TOP 5 * FROM bdjCorporate.rp.TestSteps

WITH activityCTE AS (
	SELECT DISTINCT p.ApplyId, jp.CP_ID 
	FROM bdjCorporate..dbo_job_inbox j
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.jp_id 
	--LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate.rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN bdjCorporate.rp.applicantprocess p on j.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	--INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	WHERE rp.CreatedOn >= '03/10/2024 14:00:00' AND j.P_ID not in(select P_ID from bdjCorporate..ListOfPID)
	
)
SELECT 
	COUNT(DISTINCT ai.ApplyId) AS [Number Of Applicants invited for AI Assessment],
	COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL AND ai.FinalSubmitted = 1 THEN ai.ApplyId END) AS [Number of Applicants Submitted AI Assessments],
	COUNT(DISTINCT a.CP_ID) AS [Number Of unique Company's Created Assessments]
FROM activityCTE AS a
LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON a.ApplyId = ai.ApplyID
--WHERE a.CP_ID NOT IN (114174, 35450, 38918, 110412)

--AND j.P_ID NOT IN (1574916,5834138,2346014,2487497,6875439,2488631,4361771,977824,2411733,2487497,2461669,6150421,6195142,6098620,6108221,1575873,4259847,2332477,2411733,6195142,6150421,2338543,2589293,6866721,5572448,2384527,4572652,6100544)

SELECT TOP 5 * FROM bdjCorporate.[aiass].[AIAssessmentInfo]

select top 5 * from bdjCorporate.[aiass].[AIAssessmentApplicants]
select top 5 * from [aiass].[AIAssessmentInfo]
select top 5 * from [aiass].[AIAssessmentScore]
select top 5 * from [aiass].[AIAssessmentTypes]
select top 5 * from [aiass].[LogsAIAssessment]


SELECT DISTINCT p.ApplyId, j.P_ID, u.NAME--, jp.CP_ID 
	FROM bdjCorporate..dbo_job_inbox j
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.jp_id 
	INNER JOIN bdjResumes..PERSONAL AS u ON j.P_ID = u.ID
	--LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate.rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN bdjCorporate.rp.applicantprocess p on j.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
	--INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	WHERE rp.CreatedOn >= '03/10/2024 14:00:00'
	AND P_ID NOT IN (1574916,5834138,2346014,2487497,6875439,2488631,4361771,977824,2411733,2487497,2461669,6150421,6195142,6098620,6108221,1575873,4259847,2332477,2411733,6195142,6150421,2338543,2589293,6866721,5572448,2384527,4572652,6100544)



select P_ID from bdjCorporate..ListOfPID

