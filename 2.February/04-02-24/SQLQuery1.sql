-- 

SELECT TOP 5 * FROm [dbo].[DBO_JOB_INBOX]


SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed=0
	AND J.DeadLine > GETDATE()


WITH JobCTE AS (
	SELECT j.JP_ID, j.CP_ID, COUNT(i.ApplyId) AS ApplyCount FROM [dbo].[DBO_JOBPOSTINGS] AS j
	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON j.JP_ID = i.JP_ID
	WHERE 
	J.Verified = 1 
	And J.Drafted = 0 
	And J.Closed=0
	--AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	GROUP BY j.JP_ID, j.CP_ID
	
)

SELECT TOP 5 j.JP_ID, j.CP_ID, j.ApplyCount FROM JobCTE AS j WHERE j.ApplyCount > 1000
ORDER BY j.Applycount DESC

SELECT * FROM [dbo].[DBO_JOBPOSTINGS]

-- Live Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-3 23:59:59'
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1


-- Paused Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 1
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-03 23:59:59'
AND j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- Expired Jobs

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-03 23:59:59'
AND j.Deadline < CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- Pending Jobs
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.VERIFIED = 0 AND j.Drafted = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-03 23:59:59'
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

--Drafted Jobs
--SELECT TOP 10 * FROM [dbo].[DBO_JOBPOSTINGS]
SELECT J.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.VERIFIED = 0 AND j.Drafted = 1 --AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00'
--AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.RegionalJob <> 4 AND j.OnlineJob = 1
ORDER BY JP_ID DESC




-- Live Jobs CV Recieving Options

SELECT DISTINCT TOP 5 JP_ID, CP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-3 23:59:59'
AND j.Deadline > CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.CVReceivingOptions NOT LIKE '%1%'
ORDER BY JP_ID DESC


-- Expired Jobs CV Recieving Options

SELECT DISTINCT TOP 5 JP_ID, CP_ID, CVReceivingOptions FROM [dbo].[DBO_JOBPOSTINGS] AS J
WHERE j.Verified = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.PublishDate >= '2023-05-01 00:00:00'
AND j.Deadline < CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.CVReceivingOptions NOT LIKE '%1%'
ORDER BY JP_ID DESC




SELECT j.JP_ID, j.CP_ID, COUNT(i.ApplyId) AS ApplyCount FROM [dbo].[DBO_JOBPOSTINGS] AS j
	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON j.JP_ID = i.JP_ID
	WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed=0
	AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	GROUP BY j.JP_ID, j.CP_ID


SELECT DISTINCT TOP 5 j.JP_ID, j.CP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed=0
	AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.CVReceivingOptions LIKE '%4%'
	ORDER BY j.JP_ID DESC
	--GROUP BY j.JP_ID, j.CP_ID

SELECT DISTINCT TOP 5 j.JP_ID, j.CP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed=0
	--AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.CVReceivingOptions LIKE '%4%'
	ORDER BY JP_ID DESC


SELECT DISTINCT TOP 100 j.JP_ID, j.CP_ID, j.CVReceivingOptions FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed=0
	AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND (j.CVReceivingOptions LIKE '%1%' OR j.CVReceivingOptions LIKE '%2%' OR j.CVReceivingOptions LIKE '%3%' OR j.CVReceivingOptions LIKE '%4%')
ORDER BY j.JP_ID DESC;

SELECT DISTINCT TOP 15 j.JP_ID, j.CP_ID, j.CVReceivingOptions FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE J.Verified = 1 AND J.Drafted = 0 AND J.Closed=0
	--AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
	AND (j.CVReceivingOptions LIKE '%1%' OR j.CVReceivingOptions LIKE '%2%' OR j.CVReceivingOptions LIKE '%3%' OR j.CVReceivingOptions LIKE '%4%')
ORDER BY j.JP_ID DESC;

SELECT DISTINCT TOP 5 j.JP_ID, j.CP_ID, j.CVReceivingOptions FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE J.Verified = 0 AND J.Drafted = 0
	--AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND (j.CVReceivingOptions LIKE '%1%' OR j.CVReceivingOptions LIKE '%2%' OR j.CVReceivingOptions LIKE '%3%' OR j.CVReceivingOptions LIKE '%4%')
	ORDER BY JP_ID DESC

SELECT DISTINCT TOP 100 j.JP_ID, j.CP_ID, j.CVReceivingOptions FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE J.Verified = 0 AND J.Drafted = 0
	--AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND (j.CVReceivingOptions NOT LIKE '%1%') AND (j.CVReceivingOptions LIKE '%2%' OR j.CVReceivingOptions LIKE '%3%' OR j.CVReceivingOptions LIKE '%4%')
	ORDER BY JP_ID DESC

GO

SELECT DISTINCT j.CP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.Drafted = 0 ORDER BY j.CP_ID DESC

GO
SELECT j.JP_ID, COUNT(i.ApplyId) AS Applicants,
	CASE 
		WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)) AND (j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0) THEN 'Live'
		WHEN (j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101) AND (j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0) THEN 'Expired'
		--WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)) AND (j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1) THEN 'Paused'
		--WHEN (j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) AND (j.VERIFIED = 0 AND j.Drafted = 0)) THEN 'Pending'
	END AS [Status]
FROM [dbo].[DBO_JOBPOSTINGS] AS j 
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE j.PublishDate >= '01-20-2024 00:00:00' AND j.PublishDate <= '02-04-2024 13:00:00'
AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0 AND j.OnlineJob = 1
GROUP BY j.JP_ID, j.VERIFIED, j.Drafted, j.Closed, j.DeadLine
ORDER BY j.JP_ID DESC

--SELECT * FROM [dbo].[DBO_JOBPOSTINGS] AS j WHERE JP_ID = 1222921
SELECT TOP 5 * FROM  [dbo].[DBO_JOB_INBOX]
SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID WHERE j.JP_ID = 271152


-- Published Job
SELECT j.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PublishDate >= '05-01-2023 00:00:00' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0 AND j.Closed = 0
AND j.RegionalJob <> 4
ORDER BY j.JP_ID DESC

-- Posted Job
SELECT j.JP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
WHERE j.PostingDate >= '05-01-2023 00:00:00' AND j.PostingDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
AND j.PublishDate IS NULL AND j.Drafted = 0 AND j.OnlineJob = 1 AND j.Closed = 0 AND j.VERIFIED = 0
AND j.RegionalJob <> 4
ORDER BY j.JP_ID DESC

--Drafted Jobs
SELECT JP_ID  FROM [dbo].[DBO_JOBPOSTINGS] AS J 
WHERE j.Drafted = 1
AND j.PublishDate >= '2023-05-01 00:00:00' AND j.PublishDate <= '2024-02-03 23:59:59'
AND j.RegionalJob <> 4 AND j.OnlineJob = 1

-- Expeirence Only 0 Candidates
SELECT * FROM [dbo].[DBO_JOBPOSTINGS] AS j
SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX] AS j


--SELECT TOP 5 JP_ID FROM [bdjResumes].[dbo].[UserAccounts] AS u
--INNER JOIN [bdjResumes].[dbo].[UserSummary] AS s ON s.P_ID = u.accID
--INNER JOIN [dbo].[DBO_JOB_INBOX] AS j ON j.P_ID = s.P_ID
--ORDER BY P_ID

--SELECT JP_ID, CP_ID FROM  [dbo].[DBO_JOBPOSTINGS] AS p 
--INNER JOIN [dbo].[DBO_JOB_INBOX] AS j ON j.P_ID = s.P_ID
--INNER JOIN [bdjResumes].[dbo].[UserSummary] AS s ON s.P_ID =

SELECT TOP 20 
i.JP_ID, 
p.CP_ID,
i.ApplyId,
DATEDIFF(YEAR, 0, DATEADD(MONTH, s.TExp, 0)) AS Experience
FROM [bdjResumes].[dbo].[UserSummary] AS s
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.P_ID = s.P_ID
INNER JOIN [dbo].[DBO_JOBPOSTINGS] AS p ON p.JP_ID = i.JP_ID
ORDER BY i.ApplyID DESC










