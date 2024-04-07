SELECT TOP 5 * FROM DBO_JOB_INBOX
SELECT TOP 5 * FROM DBO_JOBPOSTINGS


WITH jobCTE AS(
	SELECT * FROM [dbo].[DBO_JOBPOSTINGS]
	WHERE PostingDate >= '05/01/2023'
	AND Drafted = 1
)
SELECT CP_ID, JP_ID, Drafted FROM jobCTE ORDER BY JP_ID ASC