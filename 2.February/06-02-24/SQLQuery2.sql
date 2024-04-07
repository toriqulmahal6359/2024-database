-----CASE 1-------

-- Live Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101) --'2024-02-6 23:59:59'
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 4741
-- 4689

-- Paused Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 1
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101) --'2024-02-06 23:59:59'
AND j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 92

-- Expired Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101) --'2024-02-06 23:59:59'
AND j.Deadline < CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 58099

-- Pending Jobs
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.VERIFIED = 0 AND j.Drafted = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101) --'2024-02-06 23:59:59'
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 26
-- 25

------------- CASE 2 -----------------

SELECT j.JP_ID, COUNT(i.ApplyId) AS Applicants,
	CASE 
		WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)) AND (j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0) THEN 'Live'
		WHEN (j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101)) AND (j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0) THEN 'Expired'
		--WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)) AND (j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1) THEN 'Paused'
		--WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) AND (j.VERIFIED = 0 AND j.Drafted = 0)) THEN 'Pending'
	END AS [Status]
FROM [dbo].[DBO_JOBPOSTINGS] AS j 
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE j.PublishDate >= '01-20-2024 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101) --'02-06-2024 23:59:59'
AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0 AND j.OnlineJob = 1
GROUP BY j.JP_ID, j.VERIFIED, j.Drafted, j.Closed, j.DeadLine
ORDER BY j.JP_ID DESC

-- 3475
-- 3450

------------- CASE 3 -------------

-- Published Job
SELECT j.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PublishDate >= '05-01-2023 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.RegionalJob <> 4
ORDER BY j.JP_ID DESC

--62851

-- Posted Job
SELECT j.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PostingDate >= '05-01-2023 00:00:00' AND j.PostingDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.PublishDate IS NULL AND j.Drafted = 0 AND j.OnlineJob = 1 AND j.Closed = 0 AND j.VERIFIED = 0
AND j.RegionalJob <> 4
ORDER BY j.JP_ID DESC

-- 4557

-- Drafted Jobs
SELECT JP_ID  FROM [dbo].[DBO_JOBPOSTINGS] AS J 
WHERE j.Drafted = 1
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <=  CONVERT(VARCHAR(100), GETDATE(), 101) --'2024-02-06 23:59:59'
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 3

--Drafted Jobs
SELECT J.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.VERIFIED = 0 AND j.Drafted = 1 --AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00'
--AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1
ORDER BY JP_ID DESC

-- 3



