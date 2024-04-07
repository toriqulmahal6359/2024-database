SELECT TOP 5 * FROM [bdjResumes].[dbo].[UserSummary]
SELECT TOP 50 * FROM [bdjCorporate].[dbo].[DBO_JOB_INBOX] ORDER BY JP_ID DESC
SELECT TOP 50 * FROM [bdjCorporate]..[Dbo_JOBPostings]

-- If Score is less than 50

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants] FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE i.Score < 50
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang


-- Only 90%

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants] FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID

WHERE i.Score > 90
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang

-- Only 89%

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants] FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
WHERE i.Score > 89
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang


--Expereince 0

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants], u.TExp FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
LEFT JOIN [bdjResumes].[dbo].[UserSummary] AS u ON u.P_ID = i.P_ID
WHERE u.TExp = 0
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang, u.TExp

--Expereince below 1 year

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants], u.TExp FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
LEFT JOIN [bdjResumes].[dbo].[UserSummary] AS u ON u.P_ID = i.P_ID
WHERE u.TExp < 12 AND u.TExp <> 0
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang, u.TExp

--Expereince above 2 year

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants], u.TExp FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
LEFT JOIN [bdjResumes].[dbo].[UserSummary] AS u ON u.P_ID = i.P_ID
WHERE u.TExp > 24
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang, u.TExp

--Expereince only 2 year

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants], u.TExp FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
LEFT JOIN [bdjResumes].[dbo].[UserSummary] AS u ON u.P_ID = i.P_ID
WHERE u.TExp = 24
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang, u.TExp

--Expereince above 10 years

SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title],
COUNT(i.ApplyID) AS [Total Applicants], u.TExp FROM [Dbo_JOBPostings] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
LEFT JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
LEFT JOIN [bdjResumes].[dbo].[UserSummary] AS u ON u.P_ID = i.P_ID
WHERE u.TExp = 24
GROUP BY j.JP_ID, j.CP_ID, c.NAME, bj.TITLE, j.JobTitle, j.JobLang, u.TExp