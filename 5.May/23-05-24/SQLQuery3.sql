WITH onlineTestCTE AS (
	SELECT I.P_ID, ep.ApplyId		
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID AND TS.TestType LIKE '%onlinetest%'
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
			LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID AND S.stId = TS.stId
			--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId AND AR.LevelStatus = AP.LevelStatus
			LEFT JOIN bdjExaminations.exm.[Participants] EP ON I.ApplyId = ep.ApplyID AND I.P_ID = ep.UserId
)
, writtenCTE AS (
	SELECT I.P_ID, ap.ApplyId		
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID AND TS.TestType LIKE '%written%'
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
			LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID AND S.stId = TS.stId
			--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId AND AR.LevelStatus = AP.LevelStatus
)
,facetofaceCTE AS (
	SELECT I.P_ID, ap.ApplyId	
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID AND TS.TestType LIKE '%facetoface%'
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
			LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID AND S.stId = TS.stId
			--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId AND AR.LevelStatus = AP.LevelStatus
)
,aiasmntCTE AS (
	SELECT I.P_ID, ap.ApplyId		
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID AND TS.TestType LIKE '%aiasmnt%'
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
			LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID AND S.stId = TS.stId
			--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId AND AR.LevelStatus = AP.LevelStatus
			LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON I.ApplyId = ai.ApplyId
)
, videoCTE AS (
	SELECT I.P_ID, ap.ApplyId		
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID AND TS.TestType LIKE '%video%'
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
			LEFT JOIN bdjCorporate.rp.Schedule S ON AP.SchId = S.SchID AND S.stId = TS.stId
			--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId AND AR.LevelStatus = AP.LevelStatus
			LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON I.ApplyID = vdo.ApplyId
)
, mainCTE AS (
	SELECT CASE WHEN ApplyId IS NOT NULL THEN P_ID END AS P_ID FROM onlineTestCTE
		UNION
	SELECT CASE WHEN ApplyId IS NOT NULL THEN P_ID END AS P_ID FROM writtenCTE
		UNION
	SELECT CASE WHEN ApplyId IS NOT NULL THEN P_ID END AS P_ID FROM facetofaceCTE
		UNION
	SELECT CASE WHEN ApplyId IS NOT NULL THEN P_ID END AS P_ID FROM videoCTE
		UNION
	SELECT CASE WHEN ApplyId IS NOT NULL THEN P_ID END AS P_ID FROM aiasmntCTE
)
SELECT P_ID FROM mainCTE


