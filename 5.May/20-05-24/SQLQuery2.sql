WITH mainCTE AS (
	SELECT P_ID, ji.ApplyID
	FROM bdjCorporate..DBO_JOB_INBOX AS ji
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
)
SELECT m.P_ID 
	FROM mainCTE AS m
LEFT JOIN arcCorporate..DBO_JOB_INBOX_arc AS ji ON m.ApplyID = ji.ApplyID
LEFT JOIN arcCorporate.rp.ApplicantProcess_arc AS arc ON ji.ApplyId = arc.ApplyId 
--WHERE ji.P_ID IN (SELECT P_ID FROM mainCTE)




,shortlistCTE AS (
	SELECT P_ID, ji.ApplyId, ji.JP_ID, rp.SchId, t.TestType  
		FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON ji.JP_ID = t.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
		UNION
	SELECT P_ID, ji.ApplyId, ji.JP_ID, rp.SchId, t.TestType
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON ji.JP_ID = t.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
)
SELECT 
	s.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	, c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], s.P_ID, p.MOBILE AS [Mobile Number]
FROM shortlistCTE AS s
	INNER JOIN bdjResumes..PERSONAL AS p ON s.P_ID = p.ID
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.JP_ID = s.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON s.JP_ID = bj.JP_ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	LEFT JOIN bdjCorporate.rp.Schedule AS sc ON s.SchId = sc.schId	LEFT JOIN bdjCorporate.rp.TestVenues AS v ON sc.VenueId = v.VenueId	LEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON s.JP_ID = i.JP_ID	LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vi ON s.ApplyId = vi.ApplyId	LEFT JOIN bdjCorporate.[aiass].AIAssessmentInfo AS ai ON s.JP_ID = ai.JP_ID 	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS aa ON s.ApplyId = aa.ApplyID


SELECT TOP 10 * FROM arcCorporate.rp.ApplicantProcess_arc
SELECT TOP 10 * FROM arcCorporate.rp.TestSteps_arc



SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess

--WITH mainCTE AS (
--	SELECT P_ID, rp.ApplyID, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
--	FROM bdjCorporate..DBO_JOB_INBOX AS ji
--	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
--	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
--)
--, arcCTE AS (
--	SELECT P_ID, ApplyID, JP_ID, LevelStatus, SchId, Attended FROM mainCTE
--		UNION ALL
--	SELECT m.P_ID ,arc.ApplyId, 0 AS JP_ID, arc.LevelStatus, arc.SchId, m.Attended 
--		FROM mainCTE AS m
--	INNER JOIN arcCorporate..DBO_JOB_INBOX_arc AS ji ON m.P_ID = ji.P_ID
--	INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS arc ON ji.ApplyId = arc.ApplyId 
--)
WITH mainCTE AS (
	SELECT P_ID, rp.ApplyID, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
	UNION
		SELECT P_ID, rp.ApplyId, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
		INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON ji.ApplyId = rp.ApplyId 
	--WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
)
, activityCTE AS (
SELECT
	a.*,
	CASE WHEN ot.ParticipatedOn IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Online Test Submitted],
	CASE WHEN (t.TestType LIKE '%written%' OR art.TestType LIKE '%written%') AND a.Attended = 1 THEN 'YES' ELSE 'NO' END AS [Written test Submitted],
	CASE WHEN (t.TestType LIKE '%facetoface%' OR art.TestType LIKE '%facetoface%') AND a.Attended = 1 THEN 'YES' ELSE 'NO' END AS [Face To Face Submitted], 
	CASE WHEN vdo.AnsweredOn IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted],
	CASE WHEN ai.AnsweredOn IS NOT NULL THEN 'YES' ELSE 'NO' END AS [AI Assessment Submitted]
	FROM mainCTE AS a 
	LEFT JOIN bdjExaminations.[exm].[Participants] AS ot ON a.P_ID = ot.UserId
	LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON a.ApplyID = vdo.ApplyId 
	LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON a.ApplyId = ai.ApplyId 
	LEFT JOIN bdjCorporate.rp.TestSteps AS t ON a.JP_ID = t.JP_ID AND a.LevelStatus = t.TestLevel
	LEFT JOIN arcCorporate.rp.TestSteps_arc AS art ON a.JP_ID = art.JP_ID AND a.LevelStatus = t.TestLevel
)

SELECT DISTINCT
	a.P_ID, a.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	, c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.MOBILE AS [Mobile Phone]
	, s.ScheduleDate AS [Schedule Time]
	, a.[Online Test Submitted], a.[Written test Submitted], a.[Face To Face Submitted]
	, v.VenueName AS [Venue Name], v.Address AS [Venue Location]
	, i.Deadline AS [Video Interview Deadline], a.[Video Interview Submitted]
	, ai.Deadline AS [AI Assessment Deadline], a.[AI Assessment Submitted]
FROM activityCTE AS a
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON a.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON a.JP_ID = bj.JP_ID
	INNER JOIN bdjResumes..PERSONAL AS p ON a.P_ID = p.ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	LEFT JOIN bdjCorporate.rp.Schedule AS s ON a.SchId = s.schId	LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	LEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON a.JP_ID = i.JP_ID
	LEFT JOIN bdjCorporate.[aiass].AIAssessmentInfo AS ai ON a.JP_ID = ai.JP_ID 


--SELECT TOp 10 * FROM arcCorporate.rp.TestSteps_arc

--SELECT 
--	a.P_ID, a.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
--	, c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.MOBILE AS [Mobile Phone]
--	, s.ScheduleDate AS [Schedule Time], v.VenueName AS [Venue Name], v.Address AS [Venue Location]
--	, CASE WHEN vi.FinalSubmitted = 1 THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted], i.Deadline AS [Video Interview Deadline] --	, CASE WHEN aa.FinalSubmitted = 1 THEN 'YES' ELSE 'NO' END AS [AI Voice Record Submitted], ai.Deadline AS [AI Assessment Deadline]
--	FROM arcCTE AS a
--INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON a.JP_ID = j.JP_ID
--LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON a.JP_ID = bj.JP_ID
--INNER JOIN bdjResumes..PERSONAL AS p ON a.P_ID = p.ID
--INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
--LEFT JOIN bdjCorporate.rp.TestSteps AS t ON a.JP_ID = t.JP_ID AND a.LevelStatus = t.TestLevel
--LEFT JOIN arcCorporate.rp.TestSteps_arc AS art ON a.JP_ID = art.JP_ID AND a.LevelStatus = t.TestLevel
--LEFT JOIN bdjCorporate.rp.Schedule AS s ON a.SchId = s.schId--LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId--LEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON a.JP_ID = i.JP_ID--LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vi ON a.ApplyId = vi.ApplyId
--LEFT JOIN bdjCorporate.[aiass].AIAssessmentInfo AS ai ON a.JP_ID = ai.JP_ID --LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS aa ON a.ApplyId = aa.ApplyID











SELECT 
	a.P_ID
	FROM arcCTE AS a
	INNER JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON a.ApplyID = vdo.ApplyId AND vdo.AnsweredOn IS NOT NULL

SELECT 
	a.P_ID 
	FROM arcCTE AS a
	INNER JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON a.ApplyId = ai.ApplyId AND ai.AnsweredOn IS NOT NULL

SELECT 
	a.P_ID
	FROM arcCTE AS a
	INNER JOIN bdjExaminations.[exm].[Participants] AS ot ON a.P_ID = ot.P_ID


SELECT TOP 10 * FROM bdjCorporate.vdo.InterviewApplicants




		

-- 4th step

LEFT JOIN bdjCorporate.rp.Schedule AS s ON rp.SchId = s.schIdLEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueIdLEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON ji.JP_ID = i.JP_IDLEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vi ON ji.ApplyId = vi.ApplyId

