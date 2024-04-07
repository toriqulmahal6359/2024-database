SELECT MAX(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS]
SELECT MIN(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS]
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS]
SELECT TOP 5 *  FROM [dbo].[DBO_JOBPOSTINGS]
SELECT TOP 5 * FROM [dbo].[DBO_JOB_SOURCE]

SELECT COUNT(*) FROM [dbo].[DBO_JOB_SOURCE]
SELECT TOP 5 * FROM [dbo].[DBO_JOB_SOURCE]

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE PublishDate >= '2001-01-01'

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE PublishDate >= '2001-01-01' OR ProceedToPublishDate >= '2001-01-01'
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE PublishDate IS NULL OR ProceedToPublishDate >= '2001-01-01'
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE PublishDate >= '2001-01-01' OR ProceedToPublishDate IS NULL

SELECT COUNT(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS] WHERE PublishDate >= '2001-01-01' OR ProceedToPublishDate IS NULL

SELECT DISTINCT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817  AND JP_ID <=  1222649

SELECT COUNT(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND Drafted = 1 

SELECT * FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND ProceedToPublishDate IS NOT NULL AND PublishDate IS NULL
SELECT COUNT(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND ProceedToPublishDate IS NULL AND PublishDate IS NOT NULL

SELECT * FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND ProceedToPublishDate <= '2023-05-01' AND PublishDate IS NULL

SELECT * FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND ProceedToPublishDate <= '2023-05-01'
SELECT * FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND PublishDate <= '2023-05-01'
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 1142817 AND JP_ID <= 1222609 AND Drafted = 1

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE 
	--JP_ID >= 1142817 AND JP_ID <= 1222649 
	--AND 
	VERIFIED = 1 AND Drafted = 0 AND Closed = 0
	AND DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)

-- MINIMUM 631538
-- MAXIMUM 1222857
SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS]

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 631538 AND JP_ID <= 1222857

SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 631538 AND JP_ID <= 1222857 AND Drafted = 1 --12457
SELECT COUNT(*) FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID >= 631538 AND JP_ID <= 1222857

SELECT COUNT(*) FROM [dbo].[DBO_JOB_INBOX]
SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX]


SELECT COUNT(ApplyID) 
FROM [dbo].[DBO_JOBPOSTINGS] AS p
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = p.JP_ID
WHERE p.JP_ID IN (1137261, 1143010, 1146479)
--GROUP BY i.JP_ID

SELECT COUNT(ApplyID) 
FROM [dbo].[DBO_JOBPOSTINGS] AS p
WHERE p.JP_ID IN (1137261, 1143010, 1146479)    1137261


SELECT COUNT(ApplyID) 
FROM [dbo].[DBO_JOBPOSTINGS] AS p
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = p.JP_ID
WHERE p.JP_ID = 1137261