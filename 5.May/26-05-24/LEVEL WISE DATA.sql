WITH mainCTE1 AS (
	SELECT P_ID, rp.ApplyID, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) --AND  rp.UpdatedOn <= GETDATE()
			and rp.SchId > 0 and rp.Notify = 1
	UNION
		SELECT P_ID, rp.ApplyId, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.Attended
		FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
		INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON ji.ApplyId = rp.ApplyId 
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE())-- AND  rp.UpdatedOn <= GETDATE()
		and rp.SchId > 0 and rp.Notify = 1
),rowCTE AS (
	select JP_ID,P_ID, ApplyId,MAX(SchId) SchId, MAX(LevelStatus) LevelStatus
	from mainCTE1
	GrOUP BY JP_ID,P_ID, ApplyId
), onlineResponseANDSubmittedCTE AS (
	SELECT 
		m.P_ID,m.JP_ID, count(AR.ApplyId) [not response],count(EP.applyid) [not Submitted]
		, s.ScheduleDate AS [Online Test Time] , v.VenueName AS [Online Test Venue], v.Address AS [Online Test Location]
	FROM rowCTE AS m
	LEFT JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID and ts.TestType LIKE '%onlinetest%'
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
    LEFT JOIN bdjExaminations.exm.[Participants] EP ON m.ApplyId=ep.ApplyID 
	group by m.P_ID,m.JP_ID, s.ScheduleDate , v.VenueName, v.Address 
), writtenResponseCTE AS (
	SELECT 
		m.P_ID,m.JP_ID, count(AR.ApplyId) [not response],count(case when ap.attended=1 then ap.applyid end) [not Submitted]
		, s.ScheduleDate AS [Written test Time], v.VenueName AS [Written test Venue], v.Address AS [Written Test Location]
	FROM rowCTE AS m
	LEFT JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID and ts.TestType LIKE '%written%'
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
    LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
	group by m.P_ID,m.JP_ID, s.ScheduleDate , v.VenueName , v.Address 
), facetofaceResponseCTE AS (
	SELECT 
		m.P_ID,m.JP_ID, count(AR.ApplyId) [not response],count(case when ap.attended=1 then ap.applyid end) [not Submitted]
		, s.ScheduleDate AS [face to Face Interview Time], v.VenueName AS [Face to face Venue], v.Address AS [face to face Location]
	FROM rowCTE AS m
	LEFT JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID and ts.TestType LIKE '%facetoface%'
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
	group by m.P_ID,m.JP_ID, s.ScheduleDate, v.VenueName, v.Address 

), videoCTE AS (
	SELECT 
		m.P_ID,m.JP_ID, count(vdo.ApplyId) [not Submitted], s.ScheduleDate AS [Video Interview Time], i.Deadline
	FROM rowCTE AS m
	LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON m.ApplyID = vdo.ApplyId --AND vdo.AnsweredOn IS NOT NULL
	LEFT JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID and ts.TestType LIKE '%video%' 
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	LEFT JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON m.JP_ID = i.JP_ID
	group by m.P_ID,m.JP_ID, s.ScheduleDate, i.Deadline
), aiCTE AS (
	SELECT 
		m.P_ID,m.JP_ID, COUNT(ai.ApplyId) [not Submitted], s.ScheduleDate AS [AI Assessment Time], i.Deadline as [AI Assessment Deadline]
	FROM rowCTE AS m
	left JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON m.ApplyId = ai.ApplyId --AND ai.AnsweredOn IS NOT NULL
	LEFT JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID and ts.TestType LIKE '%aiasmnt%'
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
	LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID And S.stId = TS.stId
	LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId
	INNER JOIN bdjCorporate.[aiass].AIAssessmentInfo AS i ON m.JP_ID = i.JP_ID 
	group by m.P_ID,m.JP_ID, s.ScheduleDate, i.Deadline

), finalCTE AS ( 
	SELECT  
		distinct m.P_ID, m.JP_ID
		, case when o.[not response]=0 and o.[not Submitted]=0  then 'Yes' else 'No' end [Online Test not response and not Submitted]
		, case when o.[not response] > 0 then 'Yes' else 'No' end [online test  Already Responded]
		, case when w.[not response]=0 and w.[not Submitted]=0  then 'Yes' else 'No' end [Written Test not response and not Submitted]
		, case when w.[not response] > 0 then 'Yes' else 'No' end [Written test  Already Responded]
		, case when f.[not response]=0 and f.[not Submitted]=0  then 'Yes' else 'No' end [Face 2 Face not response and not Submitted]
		, case when f.[not response] > 0 then 'Yes' else 'No' end [Face 2 Face Already Responded]
		, case when v.[not Submitted]=0  then 'Yes' else 'No' end [Video Interview  not Submitted]
		, case when a.[not Submitted]=0  then 'Yes' else 'No' end [AI Assessment not Submitted]
		, o.[Online Test Time]
		, o.[Online Test Location]
		, o.[Online Test Venue]
		, w.[Written test Time]
		, w.[Written Test Location]
		, w.[Written test Venue]
		, f.[face to Face Interview Time]
		, f.[face to face Location]
		, f.[Face to face Venue]
		, v.[Video Interview Time]
		, v.Deadline [Video Deadline] 
		, a.[AI Assessment Time]
		, a.[AI Assessment Deadline]

	FROM rowCTE AS m
	LEFT JOIN onlineResponseANDSubmittedCTE AS o ON m.P_ID = o.P_ID AND m.JP_ID = o.JP_ID
	LEFT JOIN writtenResponseCTE AS w ON m.P_ID = w.P_ID AND m.JP_ID = w.JP_ID
	LEFT JOIN facetofaceResponseCTE AS f ON m.P_ID = f.P_ID AND m.JP_ID = f.JP_ID
	LEFT JOIN videoCTE AS v ON m.P_ID = v.P_ID AND m.JP_ID = v.JP_ID
	LEFT JOIN aiCTE AS a ON m.P_ID = a.P_ID AND m.JP_ID = a.JP_ID
	--order by m.P_ID
), FINAL AS(
SELECT DISTINCT
	a.P_ID, a.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	, c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.MOBILE AS [Mobile Phone]
	, a.[Online Test not response and not Submitted]
	, a.[online test  Already Responded]
	, a.[Online Test Time]
	, a.[Online Test Location]
	, a.[Online Test Venue]
	, a.[Written Test not response and not Submitted]
	, a.[Written test  Already Responded]
	, a.[Written test Time]
	, a.[Written Test Location]
	, a.[Written test Venue]
	, a.[Video Interview  not Submitted]
	, a.[Video Interview Time]
	, a.[Video Deadline]
	, a.[Face 2 Face not response and not Submitted]
	, a.[Face 2 Face Already Responded]
	, a.[face to Face Interview Time]
	, a.[face to face Location]
	, a.[Face to face Venue]
	, a.[AI Assessment not Submitted]
	, a.[AI Assessment Time]
	,a.[AI Assessment Deadline]
	, ROW_NUMBER() OVER(PARTITION BY A.jp_id, A.P_ID ORDER BY a.[Online Test Time] DESC ) AS r

FROM finalCTE AS a
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON a.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON a.JP_ID = bj.JP_ID
	INNER JOIN bdjResumes..PERSONAL AS p ON a.P_ID = p.ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	--where a.JP_ID=1250244
--order by a.P_ID
)
select * from FINAL where r=1 order by P_ID


