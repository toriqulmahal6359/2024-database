WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,
	j.CP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	--, i.ApplyID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	--INNER JOIN bdjCorporate..DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID
	WHERE j.PublishDate >= '03/10/2024 14:00:00'  
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
)
, applicantCTE AS (
	SELECT i.ApplyID, j.JP_ID, j.[CP_ID], j.[Job Title] FROM jobCTE AS j
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID
)
, companyCTE AS (
	SELECT a.ApplyID, a.JP_ID, a.[CP_ID], c.NAME AS [Company Name], a.[Job Title] FROM applicantCTE AS a
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = a.CP_ID
)
, aiactivityCTE AS (
	SELECT c.ApplyID, c.JP_ID, c.[CP_ID], c.[Company Name], c.[Job Title], 
	t.CreatedOn AS [Activity Creation Date], t.TestLevel 
	FROM companyCTE AS c
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON t.JP_ID = c.JP_ID 
	WHERE t.TestType LIKE '%aiasmnt%'
)
, processCTE AS (
	SELECT a.ApplyID, a.JP_ID, a.[CP_ID], a.[Company Name], a.[Job Title], 
	a.[Activity Creation Date], a.TestLevel FROM aiactivityCTE AS a
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS p ON p.ApplyId = a.ApplyID AND a.TestLevel = p.LevelStatus
)
, assessmentCreation AS (
	SELECT p.ApplyID, p.JP_ID, p.[CP_ID], p.[Company Name], p.[Job Title], 
		p.[Activity Creation Date], p.TestLevel, a.PostedOn AS [Assessment Creation Date] FROM processCTE AS p
		LEFT JOIN bdjCorporate.[aiass].[AIAssessmentInfo] AS a ON a.JP_ID = p.JP_ID
)
SELECT * FROM assessmentCreation





--SELECT TOP 5 * FROM rp.TestSteps

--select top 5 * from [aiass].[AIAssessmentApplicants] -- AAAId -- AAIID
--select top 5 * from [aiass].[AIAssessmentInfo] -- AAIId
--select top 5 * from [aiass].[AIAssessmentScore]
--select top 5 * from [aiass].[AIAssessmentTypes]
--select top 5 * from [aiass].[LogsAIAssessment]

--Company Name	Company Id	Job Tittle

--Assesment Activity Creation Date, 	
--Number of Applicants in AI Assessment Activity,	
--AI Assessment instructions Creation Date,	
--Number of Applicants Invited,	
--Number of Applicants Submitted Voice Record,	
--Number of time view results button has been clicked