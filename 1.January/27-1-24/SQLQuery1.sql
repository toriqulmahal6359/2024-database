SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS] WHERE 
SELECT TOP 5 * FROM [dbo].[DBO_COMPANY_PROFILES]
SELECT TOP 5 * FROM [dbo].[JobBillInfo]
SELECT TOP 5 * FROM [dbo].DBO_BNG_JOBPOSTINGS

--Live job which has deadline about greater than the present day. And Paused are those jobs which are Drafted = 1. Pending 

SELECT 
	CP_ID,
	JP_ID,
	JobTitle,
	CASE 
		WHEN (j.AdType = 0 AND j.RegionalJob <> 5 AND j.JobType = )
FROM [dbo].[DBO_JOBPOSTINGS] AS j


--Expired JOB

SELECT 
	c.CP_ID,
	j.JP_ID,
	j.JobTitle
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0 
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.AdType = 1


-- Deadline Standard
SELECT TOP 2
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.AdType = 1
ORDER BY j.JP_ID DESC

-- Deadline Standard Premium
SELECT TOP 2
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN bj.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.AdType = 2
ORDER BY j.JP_ID DESC

-- Deadline linkedIn
SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE 
	j.VERIFIED = 0
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.AdType = 11
ORDER BY j.JP_ID DESC

-- Deadline Hot Jobs
SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine <= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND b.JType = 'H'
ORDER BY j.JP_ID DESC

-- DeadLine Hot Jobs Premium
SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
WHERE j.VERIFIED = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
	AND b.JType = 'P'
--ORDER BY j.JP_ID DESC

--DeadLine Basic Listing
SELECT TOP 2
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
WHERE j.VERIFIED = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
	AND (j.AdType = 0 AND j.RegionalJob <> 5 AND b.JType <> 'H' AND b.JType <> 'P')

-- DeadLine PNPL

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
WHERE 
	j.VERIFIED = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.RegionalJob = 5 AND j.JP_ID = 93687
	ORDER BY j.JP_ID DESC 
	

-- Live job

-- Live Standard

SELECT TOP 2
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.AdType = 1
ORDER BY j.JP_ID DESC

-- Live Standard Premium

SELECT TOP 2
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	--AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.AdType = 2
ORDER BY j.JP_ID DESC

-- Live LinkedIn

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE --j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	--AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
	--AND 
	j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.AdType = 11
ORDER BY j.JP_ID DESC

-- Live Hot jobs

SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND b.JType = 'H' --AND j.CP_ID = 109513
ORDER BY j.JP_ID DESC

-- Live Hot Jobs Premium

SELECT TOP 2
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	--AND (b.JType = 'H' OR b.JType = 'P')
	AND b.JType = 'P'
ORDER BY j.JP_ID DESC

-- Live basic Listings

SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	--AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND (j.AdType = 0 AND j.RegionalJob <> 5 AND b.JType <> 'H' AND b.JType <> 'P')
ORDER BY j.JP_ID DESC

-- Live PNPL

SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 
	--AND j.Drafted = 0 AND j.Closed = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.RegionalJob = 5 
ORDER BY j.JP_ID DESC

-- Live LinkedIn (Without verified)

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE --j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	--j.VERIFIED = 1 AND  
	j.Verified = 0
	AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
	AND j.AdType = 11
ORDER BY j.JP_ID DESC

-- Paused Jobs

-- Paused Standard
SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 1 AND j.Drafted = 0 AND j.Closed = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.AdType = 1
ORDER BY j.JP_ID DESC

-- Paused Standard Premium

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 1 AND j.Drafted = 0 AND j.Closed = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.AdType = 2
ORDER BY j.JP_ID DESC

-- Paused LinkedIn

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE --j.VERIFIED = 1 --AND j.Drafted = 0 AND j.Closed = 0
	--j.VERIFIED = 1 AND  
	j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) AND j.Verified = 0 AND j.Drafted = 0 AND j.Closed = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.AdType = 11
ORDER BY j.JP_ID DESC

--Paused Hot Jobs
SELECT TOP 6
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1 
	AND j.PublishDate >= '2023-05-01'
	AND b.JType = 'H'
ORDER BY j.JP_ID DESC

-- Paused Hot Jobs Premium 

SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1 
	AND j.PublishDate >= '2023-05-01'
	AND (b.JType = 'H' OR b.JType = 'P')
ORDER BY j.JP_ID DESC

-- Paused Basic Listings

SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1 AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate >= '2023-05-01'
	AND (j.AdType = 0 AND j.RegionalJob <> 5 AND b.JType <> 'H' AND b.JType <> 'P')
ORDER BY j.JP_ID DESC

-- Paused PNPL

SELECT TOP 100
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1 AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.PublishDate >= '2023-05-01'
	AND j.RegionalJob = 5 
ORDER BY j.JP_ID DESC

-- Pending Jobs

-- Pending Standard

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN bj.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND (j.AdType = 1 AND b.JType <> 'H' AND b.JType <> 'P') 

-- Pending Standard Premium
SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND j.AdType = 2

-- Pending LinkedIn

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND j.AdType = 11

-- Pending Hot Jobs

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND b.JType = 'H'

-- Pending Hot Jobs Premium

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND b.JType = 'P'


-- Paused Hot Jobs Premium

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 1 AND j.Drafted = 0 AND j.Closed = 1
	AND j.PublishDate >= '2023-05-01'
	AND b.JType = 'P'

-- Pending Basic Listings
SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND (j.AdType = 0 AND j.RegionalJob <> 5 AND b.JType <> 'H' AND b.JType <> 'P')

-- Pending PNPL
SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND j.RegionalJob = 5

-- Expired PNPL

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
WHERE 
	j.VERIFIED = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
	AND j.RegionalJob = 5
	ORDER BY j.JP_ID DESC

-- Pending PNPL
SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 0 AND j.Drafted = 0
	AND j.PublishDate >= '2023-05-01'
	AND j.RegionalJob = 5

-- Paused PNPL

SELECT
	j.CP_ID,
	j.JP_ID,
	CASE WHEN j.joblang = 2 THEN BJ.TITLE ELSE j.JobTitle END AS JobTitle,
	j.PublishDate,
	j.DeadLine
FROM [dbo].[DBO_JOBPOSTINGS] AS j
INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
LEFT JOIN [dbo].DBO_BNG_JOBPOSTINGS AS BJ ON J.JP_ID = bj.JP_ID
--INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
WHERE j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101) AND j.verified = 1 AND j.Drafted = 0 AND j.Closed = 1
	AND j.PublishDate >= '2023-05-01'
	AND j.RegionalJob = 5

















,case WHEN (J.AdType = 0 AND J.RegionalJob <> 5 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'Basic Listing' 
WHEN (J.AdType = 1) THEN 'Standard' 
WHEN (J.AdType = 2) THEN 'Standard Premium' 
WHEN (J.AdType = 10) THEN 'Udokta' 
WHEN (B.JType = 'H') THEN 'Hot Job' 
WHEN (B.JType = 'H' OR B.JType = 'P') THEN 'Hot Job Premium'    --RegionalJob(0-Regular, 1-Regional, 2-Easy, 3-Free Blue Collar, 4-JobFair, 5-PNPL) adType = 12 (FREE)

WHEN (J.RegionalJob = 5) THEN 'PNPL' 
WHEN (J.AdType = 11) THEN 'Linkedin'