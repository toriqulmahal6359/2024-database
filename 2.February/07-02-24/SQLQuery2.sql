-----CASE 1-------

--------------------------LIVE JOB-----------------
DECLARE @Deadline AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE(), 101)
		,@PublishDate AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE()+1, 101)
SELECT JP_ID AS LiveJob
FROM DBO_JOBPOSTINGS J
WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed = 0 
AND J.Deadline >= @Deadline AND J.PublishDate < @PublishDate
AND RegionalJob <> 4 AND j.OnlineJob = 1 AND j.JP_ID = 1145575

SELECT * FROM DBO_JOBPOSTINGS WHERE JP_ID = 1145575

------------------------------------PAUSED JOB-------------------------
DECLARE @Deadline As varchar(10) = CONVERT(VARCHAR(100), GETDATE(), 101)
		,@PublishDate As varchar(10) = CONVERT(VARCHAR(100), GETDATE()+1, 101)

SELECT JP_ID AS PausedJob
FROM DBO_JOBPOSTINGS J
WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed = 1 AND J.PublishDate >= '05/01/2023 00:00:00'
AND RegionalJob <> 4 AND j.OnlineJob = 1 AND j.JP_ID = 1133023



------------------------------------Expired JOB----------------------------
DECLARE @Deadline AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE(), 101)
		,@PublishDate AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE()+1, 101)
SELECT JP_ID AS ExpiredJob
FROM DBO_JOBPOSTINGS J
WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed = 0 AND J.PublishDate >= '05/01/2023 00:00:00' AND J.Deadline < @Deadline
AND RegionalJob <> 4 AND j.OnlineJob = 1 AND j.JP_ID = 1143263






------------------------------------Pending JOB-------------------------
DECLARE @Deadline AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE(), 101)
		,@PublishDate AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE()+1, 101)
SELECT JP_ID AS PendingJob
FROM DBO_JOBPOSTINGS J
WHERE J.PostingDate >= '05/01/2023' AND J.PublishDate IS NULL
AND RegionalJob <> 4 AND j.OnlineJob = 1 AND j.JP_ID = 1173734


------------- CASE 2 -----------------

-- Counting and total applications

DECLARE @Deadline AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE(), 101)
		,@PublishDate AS VARCHAR(100) = CONVERT(VARCHAR(100), GETDATE()+1, 101)

SELECT j.JP_ID, COUNT(i.ApplyId) AS Applicants, j.PublishDate,
	CASE 
		WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)) THEN 'Live'
		WHEN (j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)) THEN 'Expired'
		--WHEN j.Closed = 1 THEN 'Paused'
		--WHEN j.PublishDate IS NULL THEN 'Pending'
	END AS [Status]
FROM [dbo].[DBO_JOBPOSTINGS] AS j 
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE j.PublishDate >= '05/01/2023 00:00:00' AND j.PublishDate <= '02/07/2024 11:00:00'
AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0 AND j.OnlineJob = 1
GROUP BY j.JP_ID, j.VERIFIED, j.Drafted, j.Closed, j.DeadLine, j.PublishDate
--ORDER BY j.JP_ID DESC


------------- CASE 3 -------------

-- Published Job
SELECT j.JP_ID, j.PublishDate FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PublishDate >= '05-01-2023 00:00:00' AND j.PublishDate <= '02-07-2024 03:20:00'
AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.RegionalJob <> 4 AND j.OnlineJob = 1 
--ORDER BY j.JP_ID DESC

-- Posted Job
SELECT j.JP_ID, j.PostingDate FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PostingDate >= '05-01-2023 00:00:00' AND j.PostingDate <= '02-07-2024 03:20:00'
AND j.PublishDate IS NULL  --AND j.Closed = 0
AND j.RegionalJob <> 4 AND j.OnlineJob = 1
--ORDER BY j.JP_ID DESC

-- Drafted Jobs
SELECT JP_ID  FROM [dbo].[DBO_JOBPOSTINGS] AS J 
WHERE j.Drafted = 1
AND j.PublishDate >= '05/01/2023 00:00:00' AND j.PublishDate <= '07/02/2024 03:20:00'
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
AND j.PublishDate >= '2023-05-01 00:00:00'
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- 63341




