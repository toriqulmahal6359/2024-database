WITH mainCTE AS (
	SELECT P_ID, rp.ApplyID, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		--ROW_NUMBER() OVER(PARTITION BY P_ID ORDER BY rp.LevelStatus DESC) AS r
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
	UNION
		SELECT P_ID, rp.ApplyId, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
		INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON ji.ApplyId = rp.ApplyId 
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
)
--,mainCTE AS (
--	SELECT P_ID, ApplyID, JP_ID, LevelStatus, SchId, Attended FROM mainCTE1 WHERE r = 1
--)
, onlinetestCTE AS (
	SELECT 
		m.P_ID, m.JP_ID
	FROM mainCTE AS m 
	INNER JOIN bdjExaminations.[exm].[Participants] AS ot ON m.P_ID = ot.UserId AND ot.ParticipatedOn IS NOT NULL
)
, writtenCTE AS (
	SELECT m.P_ID, m.JP_ID
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel AND t.TestType LIKE '%written%' AND m.Attended = 1
	--	UNION
	--SELECT m.P_ID, m.JP_ID
	--FROM mainCTE AS m
	--INNER JOIN arcCorporate.rp.TestSteps_arc AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel AND t.TestType LIKE '%written%' AND m.Attended = 1
	--LEFT JOIN arcCorporate.rp.TestSteps_arc AS art ON m.JP_ID = art.JP_ID AND m.LevelStatus = t.TestLevel
)
,facetofaceCTE AS (
	SELECT m.P_ID, m.JP_ID
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel AND t.TestType LIKE '%facetoface%' AND m.Attended = 1
	--	UNION
	--SELECT m.P_ID, m.JP_ID
	--FROM mainCTE AS m
	--INNER JOIN arcCorporate.rp.TestSteps_arc AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel AND t.TestType LIKE '%facetoface%' AND m.Attended = 1
)
, videoCTE AS (
	SELECT 
		m.P_ID, m.JP_ID
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON m.ApplyID = vdo.ApplyId AND vdo.AnsweredOn IS NOT NULL
	
)
, aiCTE AS (
	SELECT 
		m.P_ID, m.JP_ID
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON m.ApplyId = ai.ApplyId AND ai.AnsweredOn IS NOT NULL
	
)
, finalCTE AS ( 
	SELECT  
		m.P_ID, m.LevelStatus, m.JP_ID, m.SchId,
		CASE WHEN o.P_ID IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Online Test Submitted],
		CASE WHEN w.P_ID IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Written Test Attended],
		CASE WHEN f.P_ID IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Face to Face Attended],
		CASE WHEN v.P_ID IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted],
		CASE WHEN a.P_ID IS NOT NULL THEN 'YES' ELSE 'NO' END AS [AI Assessment Submitted],
		ROW_NUMBER() OVER(PARTITION BY m.P_ID ORDER BY m.LevelStatus DESC) AS r
	FROM mainCTE AS m
	LEFT JOIN onlinetestCTE AS o ON m.P_ID = o.P_ID AND m.JP_ID = o.JP_ID
	LEFT JOIN writtenCTE AS w ON m.P_ID = w.P_ID AND m.JP_ID = w.JP_ID
	LEFT JOIN facetofaceCTE AS f ON m.P_ID = f.P_ID AND m.JP_ID = f.JP_ID
	LEFT JOIN videoCTE AS v ON m.P_ID = v.P_ID AND m.JP_ID = v.JP_ID
	LEFT JOIN aiCTE AS a ON m.P_ID = a.P_ID AND m.JP_ID = a.JP_ID
)

SELECT 
	a.P_ID, a.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	, c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.MOBILE AS [Mobile Phone]
	, s.ScheduleDate AS [Schedule Time]
	, a.[Online Test Submitted], a.[Written Test Attended], a.[Face to Face Attended]
	, v.VenueName AS [Venue Name], v.Address AS [Venue Location]
	, a.[Video Interview Submitted], a.[AI Assessment Submitted]
	, i.Deadline AS [Video Interview Deadline]
	, ai.Deadline AS [AI Assessment Deadline]
	, t.TestType
FROM finalCTE AS a
INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON a.JP_ID = j.JP_ID
LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON a.JP_ID = bj.JP_ID
INNER JOIN bdjResumes..PERSONAL AS p ON a.P_ID = p.ID
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
INNER JOIN bdjCorporate.rp.TestSteps AS t ON a.JP_ID = t.JP_ID 
LEFT JOIN bdjCorporate.rp.Schedule AS s ON a.SchId = s.schIdLEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
LEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON a.JP_ID = i.JP_ID
LEFT JOIN bdjCorporate.[aiass].AIAssessmentInfo AS ai ON a.JP_ID = ai.JP_ID 
WHERE r = 1
