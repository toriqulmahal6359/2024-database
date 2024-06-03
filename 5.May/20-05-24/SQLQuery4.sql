
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
, onlinetestCTE AS (
	SELECT 
		a.P_ID, CASE WHEN ot.ParticipatedOn IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Online Test Submitted] 
	FROM mainCTE AS a 
	LEFT JOIN bdjExaminations.[exm].[Participants] AS ot ON a.P_ID = ot.UserId
)
, written_CTE AS (
	SELECT a.P_ID,
		CASE WHEN (t.TestType LIKE '%written%' OR art.TestType LIKE '%written%') AND a.Attended = 1 THEN 'YES' ELSE 'NO' END AS [Written test Submitted],
		CASE WHEN (t.TestType LIKE '%facetoface%' OR art.TestType LIKE '%facetoface%') AND a.Attended = 1 THEN 'YES' ELSE 'NO' END AS [Face To Face Submitted]
	FROM mainCTE AS m
	LEFT JOIN bdjCorporate.rp.TestSteps AS t ON a.JP_ID = t.JP_ID AND a.LevelStatus = t.TestLevel
	LEFT JOIN arcCorporate.rp.TestSteps_arc AS art ON a.JP_ID = art.JP_ID AND a.LevelStatus = t.TestLevel
)
, videoCTE AS (
	SELECT 
		a.P_ID, CASE WHEN vdo.AnsweredOn IS NOT NULL THEN 'YES' ELSE 'NO' END AS [Video Interview Submitted]
	FROM mainCTE AS m
	LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON a.ApplyID = vdo.ApplyId 
)
, aiCTE AS (
SELECT 
	a.P_ID, CASE WHEN ai.AnsweredOn IS NOT NULL THEN 'YES' ELSE 'NO' END AS [AI Assessment Submitted]
	FROM mainCTE AS m
	LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON a.ApplyId = ai.ApplyId 
)
