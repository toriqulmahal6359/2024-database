--select top 5 * from [aiass].[AIAssessmentApplicants] -- AAAId -- AAIID
--select top 100 * from [aiass].[AIAssessmentInfo] -- AAIId
--select top 5 * from [aiass].[AIAssessmentScore]
--select top 5 * from [aiass].[AIAssessmentTypes]
--select top 5 * from [aiass].[LogsAIAssessment]

--SELECT TOP 5 * FROM bdjResumes.[dbo].[UserAccounts]
--SELECT TOP 5 * FROM bdjResumes.[dbo].[UserNames]

--SELECT TOP 5 * FROM bdjCorporate..DBO_JOB_INBOX

--SELECT TOP 5 * FROM bdjResumes..PERSONAL WHERE ID = 6791386--2136415

WITH assessmentCTE AS (
	SELECT DISTINCT a.JP_ID, a.Deadline FROM bdjCorporate.[aiass].[AIAssessmentInfo] AS a
	WHERE a.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101) AND a.Deadline <= CONVERT(VARCHAR(100), GETDATE() + 3, 101)
)
, jobCTE AS (
	SELECT DISTINCT a.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Position Name],
	j.CP_ID,
	c.NAME AS [Company Name],
	CONVERT(DATE, a.Deadline, 101) AS [Deadline Date],
	ji.ApplyId, ji.P_ID
	FROM assessmentCTE AS a
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.JP_ID = a.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.rp.TestSteps rp ON j.Jp_ID = rp.JP_ID AND rp.TestType = 'aiasmnt'
	INNER JOIN bdjCorporate.rp.applicantprocess p on ji.ApplyID = p.ApplyId AND p.Levelstatus = rp.TestLevel
)
, applicantCTE AS (
	SELECT j.JP_ID, j.[Job Title], j.[Position Name], j.CP_ID, j.[Company Name], j.[Deadline Date], j.P_ID
		FROM bdjCorporate.[aiass].[AIAssessmentApplicants] AS a
	INNER JOIN jobCTE AS j ON j.ApplyId = a.ApplyId
	--WHERE a.FinalSubmitted = 0
)

SELECT DISTINCT j.JP_ID, j.[Job Title], j.[CP_ID], j.[Company Name], j.[Position Name], j.[Deadline Date], 
CONCAT(u.accFirstName, ' ', u.accLastName) AS [User Name],  u.accPhone, u.accEmail
FROM applicantCTE AS j
INNER JOIN bdjResumes..UserAccounts AS u ON u.accID = j.P_ID


--SELECT TOP 5 * FROm bdjResumes..PERSONAL


--SELECT TOP 5 * FROM bdjCorporate.[dbo].[CorporateUserAccess] WHERE UserId = 148062 --155734 --104252
--SELECT TOP 5 * FROm [dbo].[ContactPersons]