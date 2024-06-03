WITH mainCTE1 AS (
	SELECT P_ID, rp.ApplyID, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
	UNION
		SELECT P_ID, rp.ApplyId, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
		INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON ji.ApplyId = rp.ApplyId 
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
)
,rowCTE AS (
	SELECT P_ID, ApplyID, JP_ID, LevelStatus, SchId, Attended,
	ROW_NUMBER() OVER(PARTITION BY P_ID ORDER BY LevelStatus DESC) AS r
	FROM mainCTE1
)
, mainCTE AS (
	SELECT P_ID, ApplyID, JP_ID, LevelStatus, SchId, Attended FROM rowCTE WHERE r = 1
)
, onlineResponseCTE AS (
	SELECT 
		m.P_ID, m.JP_ID, ap.ApplyId
		--CASE WHEN r.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Online Test Responded] 
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
	WHERE ts.TestType LIKE '%onlinetest%'
)
, writtenResponseCTE AS (
	SELECT 
		m.P_ID, m.JP_ID, ap.ApplyId
		--CASE WHEN r.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Written Test Responded] 
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
	WHERE ts.TestType LIKE '%written%'
)
, facetofaceResponseCTE AS (
	SELECT 
		m.P_ID, m.JP_ID, ap.ApplyId
		--CASE WHEN r.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Face to Face Test Responded] 
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
	WHERE ts.TestType LIKE '%facetoface%'
)
, onlinetestCTE AS (
	SELECT 
		m.P_ID, m.JP_ID, AP.ApplyId, s.ScheduleDate AS [Online Test Time], v.VenueName AS [Online Test Venue], v.Address AS [Online Test Location]
	FROM mainCTE AS m 
	INNER JOIN bdjExaminations.[exm].[Participants] AS ot ON m.P_ID = ot.UserId
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
	WHERE ot.ParticipatedOn IS NOT NULL AND ts.TestType LIKE '%onlinetest%'
)
, writtenCTE AS (
	SELECT m.P_ID, m.JP_ID, ap.ApplyId, s.ScheduleDate AS [Written test Time], v.VenueName AS [Written test Venue], v.Address AS [Written Test Location]
	FROM mainCTE AS m
	--INNER JOIN bdjCorporate.rp.TestSteps AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	WHERE TS.TestType LIKE '%written%' AND AP.Attended = 1 
	--	UNION
	--SELECT m.P_ID, m.JP_ID
	--FROM mainCTE AS m
	--INNER JOIN arcCorporate.rp.TestSteps_arc AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel AND t.TestType LIKE '%written%' AND m.Attended = 1
	--LEFT JOIN arcCorporate.rp.TestSteps_arc AS art ON m.JP_ID = art.JP_ID AND m.LevelStatus = t.TestLevel
)
,facetofaceCTE AS (
	SELECT m.P_ID, m.JP_ID, ap.ApplyId, s.ScheduleDate AS [face to Face Interview Time], v.VenueName AS [Face to face Venue], v.Address AS [face to face Location]
	FROM mainCTE AS m
	--INNER JOIN bdjCorporate.rp.TestSteps AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	WHERE ts.TestType LIKE '%facetoface%' AND AP.Attended = 1
	--	UNION
	--SELECT m.P_ID, m.JP_ID
	--FROM mainCTE AS m
	--INNER JOIN arcCorporate.rp.TestSteps_arc AS t ON m.JP_ID = t.JP_ID AND m.LevelStatus = t.TestLevel AND t.TestType LIKE '%facetoface%' AND m.Attended = 1
)
, videoCTE AS (
	SELECT 
		m.P_ID, m.JP_ID, vdo.ApplyId, s.ScheduleDate AS [Video Interview Time], i.Deadline
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON m.ApplyID = vdo.ApplyId 
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	INNER JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON m.JP_ID = i.JP_ID
	WHERE ts.TestType LIKE '%video%' AND vdo.AnsweredOn IS NOT NULL
	
)
, aiCTE AS (
	SELECT 
		m.P_ID, m.JP_ID, ai.ApplyId, s.ScheduleDate AS [AI Assessment Time], i.Deadline
	FROM mainCTE AS m
	INNER JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON m.ApplyId = ai.ApplyId
	INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	INNER JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	INNER JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	INNER JOIN bdjCorporate.[aiass].AIAssessmentInfo AS i ON m.JP_ID = i.JP_ID 
	WHERE ts.TestType LIKE '%aiasmnt%' AND ai.AnsweredOn IS NOT NULL
	
)
, finalCTE AS ( 
	SELECT  
		m.P_ID, m.LevelStatus, m.JP_ID, m.SchId,
		CASE WHEN o.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Online Test Submitted],
		CASE WHEN w.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Written Test Attended],
		CASE WHEN f.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Face to Face Attended],
		CASE WHEN v.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted],
		CASE WHEN a.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [AI Assessment Submitted],
		CASE WHEN wr.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Written Test Responded], 
		CASE WHEN ot.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Online Test Responded],
		CASE WHEN ff.ApplyId IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Face to Face Test Responded]
		--o.[Online Test Location], o.[Online Test Venue],
		, w.[Written Test Venue], w.[Written Test Location]
		, f.[face to face Location], f.[Face to face Venue]
		, o.[Online Test Time], w.[Written test Time], f.[face to Face Interview Time], v.[Video Interview Time], a.[AI Assessment Time]
		, v.Deadline AS [Video Interview Deadline]
		, a.Deadline AS [AI Assessment Deadline]
		--ROW_NUMBER() OVER(PARTITION BY m.P_ID ORDER BY m.LevelStatus DESC) AS r
	FROM mainCTE AS m
	LEFT JOIN onlinetestCTE AS o ON m.P_ID = o.P_ID AND m.JP_ID = o.JP_ID
	LEFT JOIN writtenCTE AS w ON m.P_ID = w.P_ID AND m.JP_ID = w.JP_ID
	LEFT JOIN facetofaceCTE AS f ON m.P_ID = f.P_ID AND m.JP_ID = f.JP_ID
	LEFT JOIN videoCTE AS v ON m.P_ID = v.P_ID AND m.JP_ID = v.JP_ID
	LEFT JOIN aiCTE AS a ON m.P_ID = a.P_ID AND m.JP_ID = a.JP_ID
	LEFT JOIN onlineResponseCTE AS ot ON m.P_ID = ot.P_ID AND m.JP_ID = ot.JP_ID
	LEFT JOIN writtenResponseCTE AS wr ON m.P_ID = wr.P_ID AND m.JP_ID = wr.P_ID
	LEFT JOIN facetofaceResponseCTE AS ff ON m.P_ID = ff.P_ID AND m.JP_ID = ff.JP_ID
)

SELECT 
	a.P_ID, a.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	, c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.MOBILE AS [Mobile Phone]
	, a.[Online Test Responded] , a.[Online Test Submitted], a.[Online Test Time]
	, a.[Written Test Responded], a.[Written Test Attended], a.[Written test Time], a.[Written Test Location], a.[Written test Venue]
	, a.[Face to Face Test Responded], a.[Face to Face Attended], a.[face to Face Interview Time], a.[face to face Location], a.[Face to face Venue]
	, a.[Video Interview Submitted], a.[Video Interview Time],  a.[Video Interview Deadline], 
	a.[AI Assessment Submitted], a.[AI Assessment Time], a.[AI Assessment Deadline]
	--, t.TestType
FROM finalCTE AS a
INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON a.JP_ID = j.JP_ID
LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON a.JP_ID = bj.JP_ID
INNER JOIN bdjResumes..PERSONAL AS p ON a.P_ID = p.ID
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
--INNER JOIN bdjCorporate.rp.TestSteps AS t ON a.JP_ID = t.JP_ID 
--LEFT JOIN bdjCorporate.rp.Schedule AS s ON a.SchId = s.schId--LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
--LEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON a.JP_ID = i.JP_ID
--LEFT JOIN bdjCorporate.[aiass].AIAssessmentInfo AS ai ON a.JP_ID = ai.JP_ID 
--WHERE r = 1
