

SELECT TOP 5 FROm bdjCorporate..DBO_JOBPOSTINGS

SELECT TOP 5 * FROm bdjResumes..UserSummary


-- last 10 JobId's whose score is less than 25

WITH jobCTE AS (
	SELECT DISTINCT p.JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS p 
	LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS u ON p.JP_ID = u.JP_ID
	WHERE u.Score < 25
	--ORDER BY p.JP_ID DESC
)

SELECT TOP 10 * FROM jobCTE ORDER BY JP_ID DESC


-- last activity for last 10 Jobs

WITH jobCTE1 AS (
	SELECT DISTINCT p.JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS p 
	LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS u ON p.JP_ID = u.JP_ID
	WHERE u.Score < 25
	AND p.DeadLine < CONVERT(DATE, GETDATE(), 101)
	--ORDER BY p.JP_ID DESC
)
, testCTE AS (
	SELECT DISTINCT j.JP_ID, 
	t.TestType,
	r = ROW_NUMBER() OVER(PARTITION BY t.JP_ID ORDER BY t.CreatedOn DESC) 
	FROM jobCTE1 AS j 
	INNER JOIN bdjCorporate.rp.TestSteps AS t ON t.JP_ID = j.JP_ID
	--ORDER BY j.JP_ID DESC
)

SELECT TOP 10 * FROM testCTE WHERE r = 1
ORDER BY JP_ID DESC



-- cross check
SELECT TOP 5 * FROM bdjCorporate.rp.TestSteps


-- free listings jobs

SELECT * FROM bdjCorporate..DBO_JOBPOSTINGS WHERE AdType = 12 AND PublishDate IS NULL AND VERIFIED = 0 AND OnlineJob = 1