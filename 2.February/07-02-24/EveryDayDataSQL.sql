-----CASE 1-------

-- Live Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-07 11:00:00'
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1


-- Paused Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 1
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-07 11:00:00'
AND j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- Expired Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-07 11:00:00'
AND j.Deadline < CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- Pending Jobs
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.VERIFIED = 0 AND j.Drafted = 0
AND j.PublishDate IS NULL
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1


------------- CASE 2 -----------------

-- Counting and total applications

SELECT j.JP_ID, COUNT(i.ApplyId) AS Applicants,
	CASE 
		WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) THEN 'Live'
		WHEN (j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101) THEN 'Expired'
		WHEN j.Closed = 1 THEN 'Paused'
		WHEN j.PublishDate IS NULL THEN 'Pending'
	END AS [Status]
FROM [dbo].[DBO_JOBPOSTINGS] AS j 
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE j.PublishDate >= '07-02-2024 00:00:00' AND j.PublishDate <= '07-02-2024 11:00:00'
AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0 AND j.OnlineJob = 1
GROUP BY j.JP_ID, j.VERIFIED, j.Drafted, j.Closed, j.DeadLine
ORDER BY j.JP_ID DESC


------------- CASE 3 -------------

-- Published Job
SELECT j.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PublishDate >= '05-01-2023 00:00:00' AND j.PublishDate <= '2024-02-07 11:00:00'
AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.RegionalJob <> 4 AND j.OnlineJob = 1 
ORDER BY j.JP_ID DESC

-- Posted Job
SELECT j.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PostingDate >= '05-01-2023 00:00:00' AND j.PostingDate <= '2024-02-07 11:00:00'
AND j.PublishDate IS NULL  AND j.Closed = 0
AND j.RegionalJob <> 4 AND j.OnlineJob = 1
ORDER BY j.JP_ID DESC

-- Drafted Jobs
SELECT JP_ID  FROM [dbo].[DBO_JOBPOSTINGS] AS J 
WHERE j.Drafted = 1
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-03 23:59:59'
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

--Drafted Jobs
--SELECT J.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS J
--WHERE j.VERIFIED = 0 AND j.Drafted = 1 --AND j.Closed = 0
--AND j.PublishDate >= '2023-05-01 00:00:00'
----AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
--AND j.RegionalJob <> 4 AND j.OnlineJob = 1
--ORDER BY JP_ID DESC

-- Total Jobs
SELECT j.JP_ID FROM [bdjCorporate].[dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 63341




