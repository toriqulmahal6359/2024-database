WITH mainCTE AS (	
	SELECT P_ID,rp.applyid, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.UpdatedOn--, rp.Attended
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -24, GETDATE()) --AND  rp.UpdatedOn <= GETDATE()
			and rp.SchId > 0 --and rp.Notify = 1
	UNION
		SELECT P_ID,rp.applyid, ji.JP_ID, rp.LevelStatus, rp.SchId, rp.UpdatedOn--, rp.Attended
		FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
		INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON ji.ApplyId = rp.ApplyId 
	WHERE rp.UpdatedOn >= DATEADD(HOUR, -24, GETDATE())-- AND  rp.UpdatedOn <= GETDATE()
		and rp.SchId > 0 --and rp.Notify = 1
	--ORDER BY P_ID
)
, rowCTE AS (
	SELECT DISTINCT P_ID, ApplyId, JP_ID, MAX(UpdatedOn) AS UpdatedOn FROM mainCTE
	GROUP BY P_ID, ApplyId, JP_ID
)
--SELECT m.P_ID, COUNT(CASE WHEN EP.ParticipatedOn IS NOT NULL THEN ep.ApplyId END) AS [Participated]
--FROM rowCTE AS m 
--	--LEFT JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID AND ts.TestType LIKE '%onlinetest%'
--	--LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
--	--LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
--    LEFT JOIN bdjExaminations.exm.[Participants] EP ON  m.ApplyId = ep.ApplyID AND m.P_ID = ep.UserId
--GROUP BY m.P_ID
--	UNION
--SELECT DISTINCT m.P_ID, COUNT(CASE WHEN m.Attended = 1 THEN m.P_ID END) AS [Participated] 
--FROM rowCTE AS m
--	LEFT JOIN bdjCorporate.rp.TestSteps AS ts ON m.P_ID = ts.UserId AND ts.TestType LIKE '%written%'
--	GROUP BY m.P_ID
--	ORDER BY m.P_ID

--SELECT m.P_ID, COUNT(CASE WHEN m.Attended = 1 THEN m.ApplyId END) AS [Participated] 
--FROM rowCTE AS m
--	LEFT JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType LIKE '%written%'
--	LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyID = rp.ApplyId AND ts.TestLevel = rp.LevelStatus
--	GROUP BY m.P_ID
--	ORDER BY m.P_ID

SELECT m.P_ID, COUNT(CASE WHEN rp.Attended = 1 THEN m.ApplyId END) AS [Participated] 
FROM rowCTE AS m
	LEFT JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType LIKE '%facetoface%'
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyID = rp.ApplyId AND ts.TestLevel = rp.LevelStatus
	GROUP BY m.P_ID
	ORDER BY m.P_ID

--SELECT m.P_ID, COUNT(CASE WHEN m.Attended = 1 THEN m.P_ID END) AS [Participated] 
--FROM rowCTE AS m
--	LEFT JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID AND ts.TestType LIKE '%facetoface%'
--	LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON m.ApplyID = rp.ApplyId AND ts.TestLevel = rp.LevelStatus
--	GROUP BY m.P_ID
--	ORDER BY m.P_ID

--SELECT TOP 10 * FROM bdjCorporate.rp.TestSteps ts 
--LEFT JOIN bdjCorporate.rp.ApplicantProcess a ON ts.TestLevel = a.LevelStatus
--WHERE a.prId = 1091114



SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess





--SELECT *

--SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess WHERE ApplyId = 310313734

--6997315	310313734	3
--6997315	310313734	7


--P_ID	applyid	JP_ID	LevelStatus	SchId	UpdatedOn
--1611680	309872334	1251912	3	43708	2024-05-23 11:34:00
--1611680	309872334	1251912	2	43705	2024-05-23 11:31:00