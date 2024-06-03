SELECT * FROM bdjCorporate..DBO_JOB_INBOX WHERE FromMobile = 100

SELECT * FROM dbo.FN_Jobs_ApplicantsMatchingPoints_Count_V2(1086351, 5701970, 15000, 1)

-- Counting ApplyId testSteps wise
WITH testLevelCTE AS (
	SELECT DISTINCT p.LevelStatus, t.TestType, COUNT(j.ApplyId) AS Applicants,
	ROW_NUMBER() OVER(PARTITION BY p.LevelStatus ORDER BY p.LevelStatus DESC) AS r
	FROM bdjCorporate..DBO_JOB_INBOX AS j
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON t.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS p ON j.ApplyId = p.ApplyId AND p.LevelStatus = t.TestLevel
	WHERE j.JP_ID = 1226863
	GROUP BY p.LevelStatus, t.TestType
	--ORDER BY p.LevelStatus
)
SELECT * FROM testLevelCTE WHERE r = 1
ORDER BY LevelStatus

SELECT TOP 5 * FROm bdjCorporate.rp.ApplicantProcess 
SELECT TOP 5 * FROm bdjCorporate.rp.TestSteps