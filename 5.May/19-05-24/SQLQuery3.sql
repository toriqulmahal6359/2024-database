SELECT * FROM bdjCorporate.[aiass].[AIAssessmentApplicants]

SELECT * FROM [rp].[ApplicantsResponse]

--WITH jobCTE AS (
	SELECT DISTINCT ji.JP_ID, ji.P_ID, c.CP_ID, s.ScheduleDate, c.NAME, v.VenueName, v.Address
	, CASE WHEN vi.FinalSubmitted = 1 THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted]
	FROM bdjCorporate..DBO_JOB_INBOX AS ji
		LEFT JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON ji.JP_ID = j.JP_ID
		INNER JOIN bdjCorporate.rp.TestSteps AS t ON t.JP_ID = ji.JP_ID
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON rp.ApplyId = ji.ApplyId AND rp.LevelStatus = t.TestLevel
		INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
		LEFT JOIN bdjCorporate.rp.Schedule AS s ON rp.SchId = s.schId
		LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
		LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vi ON rp.ApplyId = vi.ApplyId
	WHERE rp.UpdatedOn <= GETDATE() AND rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE())
--)


SELECT TOP 10 * FROM bdjCorporate.vdo.InterviewApplicants
SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess
SELECT TOP 10 * FROM bdjCorporate.rp.TestVenues


SELECT * FROM bdjCorporate.rp.Schedule

SELECT TOP 10 * FROm bdjCorporate.rp.TestSteps


SELECT DISTINCT ji.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]