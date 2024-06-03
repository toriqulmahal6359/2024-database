SELECT DISTINCT 	ji.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]	, ji.P_ID, u.accPhone AS [Mobile Number], c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)]	, t.TestLevel, t.TestType, s.ScheduleDate, v.VenueName, v.Address	, CASE WHEN vi.FinalSubmitted = 1 THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted], i.Deadline AS [Video Interview Deadline] 	, CASE WHEN aa.FinalSubmitted = 1 THEN 'YES' ELSE 'NO' END AS [AI Voice Record Submitted], ai.Deadline AS [AI Assessment Deadline]	FROM bdjCorporate..DBO_JOB_INBOX AS ji		INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON ji.JP_ID = j.JP_ID		LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON ji.JP_ID = bj.JP_ID		LEFT JOIN bdjCorporate.rp.TestSteps AS t ON t.JP_ID = ji.JP_ID		LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON rp.ApplyId = ji.ApplyId AND rp.LevelStatus = t.TestLevel		INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID		LEFT JOIN bdjCorporate.rp.Schedule AS s ON rp.SchId = s.schId		LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId		LEFT JOIn bdjCorporate.[vdo].[InterviewInfo] AS i ON ji.JP_ID = i.JP_ID		LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vi ON ji.ApplyId = vi.ApplyId		LEFT JOIN bdjCorporate.[aiass].AIAssessmentInfo AS ai ON ji.JP_ID = ai.JP_ID 		LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS aa ON ji.ApplyId = aa.ApplyID		INNER JOIN bdjResumes..UserAccounts AS u ON ji.P_ID = u.accID	WHERE  rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE() 	AND t.TestType NOT LIKE '%Shortlist%'	--AND t.TestLevel <> 1--SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess--SELECT * FROM bdjCorporate..DBO_COMPANY_PROFILES--SELECT * FROm  bdjCorporate.[aiass].AIAssessmentInfo