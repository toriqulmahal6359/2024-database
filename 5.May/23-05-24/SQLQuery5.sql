WITH mainCTE AS (
	SELECT P_ID, ji.ApplyId, ji.JP_ID 
	FROM bdjCorporate..DBO_JOB_INBOX AS ji
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyId = rp.ApplyID --AND rp.LevelStatus = ts.TestLevel 
	INNER JOIN bdjCorporate.rp.Schedule AS s ON s.schId = rp.SchId
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND rp.UpdatedOn <= GETDATE()
		AND s.ScheduleDate >= GETDATE()
		AND rp.SchID > 0 AND rp.Notify = 1
)
, currentonlineCTE AS (
	SELECT m.P_ID, ep.ParticipatedOn, COUNT(DISTINCT ar.ApplyID) AS c_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType = 'onlinetest'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel
		INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = rp.ApplyId AND AR.LevelStatus = rp.LevelStatus
		LEFT JOIN bdjExaminations.exm.[Participants] EP ON ar.ApplyId = ep.ApplyID AND m.P_ID = ep.UserId
	GROUP BY m.P_ID, ep.ParticipatedOn, m.JP_ID
)
, onlinetestCTE AS ( 
	SELECT m.P_ID, ep.ParticipatedOn, COUNT(DISTINCT ep.ApplyID) AS p_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON ji.JP_ID = ts.JP_ID AND ts.TestType = 'onlinetest'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		LEFT JOIN bdjExaminations.exm.[Participants] EP ON ji.ApplyId = ep.ApplyID AND ji.P_ID = ep.UserId
	GROUP BY m.P_ID, ep.ParticipatedOn
)
, finalCTE1 AS (
	SELECT c.P_ID, c_count AS [Currently Responded], p_count AS [Previously Participated] FROM currentonlineCTE AS c
	INNER JOIN onlinetestCTE AS o ON o.P_ID = c.P_ID
)
, currentfaceCTE AS (
	SELECT m.P_ID, rp.Attended, COUNT(DISTINCT ar.ApplyID) AS c_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType = 'facetoface'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = rp.ApplyId AND AR.LevelStatus = rp.LevelStatus
	GROUP BY m.P_ID, rp.Attended --, m.JP_ID
)
, facetofaceCTE AS ( 
	SELECT m.P_ID, rp.Attended ,COUNT(DISTINCT rp.ApplyID) AS p_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON ji.JP_ID = ts.JP_ID AND ts.TestType = 'facetoface'
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		--LEFT JOIN bdjExaminations.exm.[Participants] EP ON ji.ApplyId = ep.ApplyID AND ji.P_ID = ep.UserId
	GROUP BY m.P_ID, rp.Attended
)
, finalCTE2 AS (
	SELECT c.P_ID, c_count AS [Currently Responded], p_count AS [Previously Participated] FROM currentfaceCTE AS c
	INNER JOIN facetofaceCTE AS o ON o.P_ID = c.P_ID
)
, currentwrittenCTE AS (
	SELECT m.P_ID, rp.Attended, COUNT(DISTINCT ar.ApplyID) AS c_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType = 'written'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = rp.ApplyId AND AR.LevelStatus = rp.LevelStatus
	GROUP BY m.P_ID, rp.Attended --, m.JP_ID
)
, writtenCTE AS ( 
	SELECT m.P_ID, rp.Attended, COUNT(DISTINCT rp.ApplyID) AS p_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON ji.JP_ID = ts.JP_ID AND ts.TestType = 'written'
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		--LEFT JOIN bdjExaminations.exm.[Participants] EP ON ji.ApplyId = ep.ApplyID AND ji.P_ID = ep.UserId
	GROUP BY m.P_ID, rp.Attended
)
, finalCTE3 AS (
	SELECT c.P_ID, c_count AS [Currently Responded], p_count AS [Previously Participated] FROM currentwrittenCTE AS c
	INNER JOIN writtenCTE AS o ON c.P_ID = o.P_ID
)
, currentvideoCTE AS (
	SELECT m.P_ID, vdo.AnsweredOn, COUNT(DISTINCT vdo.ApplyID) AS c_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType = 'video'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = rp.ApplyId AND AR.LevelStatus = rp.LevelStatus
		LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON ar.ApplyID = vdo.ApplyId
	GROUP BY m.P_ID, vdo.AnsweredOn, m.JP_ID
)
, videoCTE AS ( 
	SELECT m.P_ID, vdo.AnsweredOn, COUNT(DISTINCT rp.ApplyID) AS p_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON ji.JP_ID = ts.JP_ID AND ts.TestType = 'video'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel
		LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON ji.ApplyID = vdo.ApplyId
	GROUP BY m.P_ID, vdo.AnsweredOn
)
, finalCTE4 AS (
	SELECT c.P_ID, c_count AS [Currently Responded], p_count AS [Previously Participated] FROM currentvideoCTE AS c
	INNER JOIN videoCTE AS o ON c.P_ID = o.P_ID
)
, currentaiasmntCTE AS (
	SELECT m.P_ID, ai.AnsweredOn, COUNT(DISTINCT ai.ApplyID) AS c_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType = 'aiasmnt'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel 
		INNER JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = rp.ApplyId AND AR.LevelStatus = rp.LevelStatus
		LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON ar.ApplyId = ai.ApplyId
	GROUP BY m.P_ID, ai.AnsweredOn, m.JP_ID
)
, aiasmntCTE AS ( 
	SELECT m.P_ID, ai.AnsweredOn, COUNT(DISTINCT ai.ApplyID) AS p_count
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON ji.JP_ID = ts.JP_ID AND ts.TestType = 'aiasmnt'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyId = rp.ApplyID AND rp.LevelStatus = ts.TestLevel
		LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON ji.ApplyId = ai.ApplyId
	GROUP BY m.P_ID, ai.AnsweredOn
)
, finalCTE5 AS (
	SELECT c.P_ID, c_count AS [Currently Responded], p_count AS [Previously Participated] FROM currentaiasmntCTE AS c
	INNER JOIN aiasmntCTE AS o ON c.P_ID = o.P_ID
)
SELECT * FROM finalCTE2

--SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess

--SELECT TOP 10 * FROM bdjCorporate.rp.TestSteps

--SELECT TOP 10 * FROm bdjCorporate.rp.Schedule