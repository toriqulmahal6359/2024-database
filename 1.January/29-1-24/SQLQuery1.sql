--SELECT TOP 10000 * FROM [dbo].[DBO_JOBPOSTINGS] AS p
--WHERE p.JP_ID = 1113068

SELECT TOP 15 * FROM [rp].[TestSteps] WHERE TestLevel = 2 ORDER BY JP_ID DESC 
SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS]

GO

-- Live Job

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestName,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	INNER JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
		AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
		AND j.Closed = 0
)
--SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
--AND a.TestType LIKE '%faceToface%' ORDER BY JP_ID DESC

SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType LIKE '%online%' ORDER BY JP_ID DESC


-- Pending Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	INNER JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
		--AND j.PublishDate IS NULL
		AND j.VERIFIED = 0 AND j.Drafted = 0
)

SELECT * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType LIKE '%video%' ORDER BY JP_ID DESC

-- Paused Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	INNER JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
		--AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
		AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1
)

SELECT * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType LIKE '%video%' ORDER BY JP_ID DESC

-- Expired Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	INNER JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
		--AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
		AND j.VERIFIED = 1 AND j.Closed = 1
)

SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType LIKE '%video%' ORDER BY JP_ID DESC


----NULL JOBS


-- Expired Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	LEFT JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine < CONVERT(VARCHAR(100), GETDATE(), 101)
		--AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
		AND j.VERIFIED = 1 AND j.Closed = 1
		AND j.CP_ID NOT IN ( 95015, 110412, 121549, 121361, 38918)
)

SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2 
AND a.TestType IS NULL ORDER BY JP_ID DESC


-- test jobs  95015, 110412, 121549, 121361, 38918


-- Paused Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	LEFT JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
		--AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
		AND j.VERIFIED = 1 AND j.Drafted = 0 AND j.Closed = 1
		AND j.CP_ID NOT IN (35450, 95015, 110412)
)

SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType IS NULL ORDER BY JP_ID DESC

-- Pending Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	LEFT JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine > CONVERT(VARCHAR(100), GETDATE(), 101)
		--AND j.PublishDate IS NULL
		AND j.VERIFIED = 0 AND j.Drafted = 0
		
)

SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType IS NULL ORDER BY JP_ID DESC

-- Live Jobs

WITH ActivityCTE AS (
	SELECT
		j.JP_ID,
		j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN jb.TITLE ELSE j.JobTitle END AS [Job Title],
		t.TestType,
		t.TestName,
		t.TestLevel,
		t.CreatedOn,
		ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY t.CreatedOn DESC, t.TestLevel DESC) AS Row_Type
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS jb ON jb.JP_ID = j.JP_ID
	LEFT JOIN [rp].[TestSteps] AS t ON t.JP_ID = j.JP_ID 
	WHERE j.PostingDate >= '05/01/2023' AND j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
		AND j.PublishDate < CONVERT(VARCHAR(100), GETDATE() + 1, 101)
		AND j.Closed = 0
)
--SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
--AND a.TestType LIKE '%faceToface%' ORDER BY JP_ID DESC

SELECT TOP 5 * FROM ActivityCTE AS a WHERE a.Row_Type < 2
AND a.TestType IS NULL ORDER BY JP_ID DESC
