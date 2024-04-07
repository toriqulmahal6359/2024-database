SELECT TOP 5 * FROM [dbo].[UserSummary]
SELECT TOP 5 * FROM [bdjCorporate].[dbo].[DBO_JOB_INBOX]

SELECT TOP 20 
i.JP_ID, 
DATEDIFF(YEAR, 0, DATEADD(MONTH, s.TExp, 0)) AS Experience
FROM [bdjResumes].[dbo].[UserSummary] AS s
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.P_ID = s.P_ID
INNER JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.JP_ID = i.JP_ID
WHERE j.PublishDate >= '05-01-2023 00:00:00' AND j.PublishDate <= '12-31-2023 00:00:00' 
ORDER BY i.ApplyID DESC

;WITH USER_CTE AS (