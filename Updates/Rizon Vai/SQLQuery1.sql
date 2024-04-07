-- For Job from 2015

SELECT DISTINCT j.JP_ID,
CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.PublishDate--, c.NAME AS [Company Name]
FROM bdjCorporate..DBO_JOBPOSTINGS AS j
LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
--INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
WHERE j.PublishDate >= '01/01/2015' AND j.PublishDate IS NOT NULL
--AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0 AND j.RegionalJob <> 4
	UNION ALL
SELECT DISTINCT j.JP_ID,
CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.PublishDate--, c.NAME AS [Company Name]
FROM [arcCorporate]..[DBO_JOBPOSTINGS_arc] AS j
LEFT JOIN [arcCorporate]..[DBO_BNG_JOBPOSTINGS_arc] AS bj ON bj.JP_ID = j.JP_ID 
--INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
--WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0 AND j.RegionalJob <> 4
WHERE j.PublishDate >= '01/01/2015' AND j.PublishDate IS NOT NULL
ORDER BY j.PublishDate


-- For Company From 2010

SELECT c.NAME AS [Company Name] FROM [bdjCorporate]..DBO_COMPANY_PROFILES AS c
WHERE ACCT_CR >= '01/01/2010'

SELECT c.Name AS [Company Name] FROM [bdjCorporate]..DBO_COMPANY_PROFILES AS c
WHERE 

SELECT TOP 5 * FROM [arcCorporate]..[DBO_JOBPOSTINGS_arc]
SELECT TOP 5 * FROm [arcCorporate]..[DBO_JOBPOSTINGS_arc]


SELECT TOP 5 * FROM [bdjCorporate]..DBO_COMPANY_PROFILES
WHERE ACCT_CR >= '01/01/2010'


-- Live Jobs 4547

SELECT DISTINCT 
j.JP_ID,
CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
FROM [bdjCorporate]..DBO_JOBPOSTINGS AS j
LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID
WHERE j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101) AND j.PublishDate IS NOT NULL--AND PublishDate < CONVERT(VARCHAR(100), GETDATE()+1, 101) 
AND j.Verified = 1 AND j.Drafted = 0 AND j.OnlineJob = 1 AND j.RegionalJob <> 4


-- Live Company 2333

SELECT DISTINCT 
j.CP_ID,
c.Name AS [Company Name]
FROM [bdjCorporate]..DBO_JOBPOSTINGS AS j
INNER JOIN [bdjCorporate]..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
WHERE j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101) AND j.PublishDate IS NOT NULL--AND PublishDate < CONVERT(VARCHAR(100), GETDATE()+1, 101) 
AND j.Verified = 1 AND j.Drafted = 0 AND j.OnlineJob = 1 AND j.RegionalJob <> 4

--howar kotha chilo Job (4604) AND Company is (2606)

SELECT COUNT(1) FROM [bdjActiveJobs].[dbo].[DBO_JOBPOSTINGS_AJ] AS j
WHERE j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101) AND j.PublishDate IS NOT NULL--AND PublishDate < CONVERT(VARCHAR(100), GETDATE()+1, 101) 
AND j.Verified = 1 AND j.Drafted = 0 AND j.OnlineJob = 1 AND j.RegionalJob <> 4

SELECT COUNT(1) FROM [bdjActiveJobs].[dbo].[DBO_JOBPOSTINGS_AJ] AS j
WHERE j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101) --AND j.PublishDate IS NOT NULL 



-- Live Jobs (All Okay)

SELECT j.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title] 
FROM [bdjActiveJobs].[dbo].[DBO_JOBPOSTINGS_ALL_AJ] AS j
LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON bj.JP_ID = j.JP_ID

-- Live Company (hoitese na match)

SELECT DISTINCT c.CP_ID, c.Name AS [Company Name] FROM [bdjCorporate]..DBO_COMPANY_PROFILES AS c 
INNER JOIN [bdjActiveJobs].[dbo].[DBO_JOBPOSTINGS_ALL_AJ] AS j ON c.CP_ID = j.CP_ID

SELECT COUNT(DISTINCT CP_ID) FROM [bdjActiveJobs].[dbo].[DBO_JOBPOSTINGS_AJ] AS j
WHERE j.Deadline >= CONVERT(VARCHAR(100), GETDATE(), 101) 


-- Linkedin Jobs Apply ANd applicants account

WITH jobCTE AS (
	SELECT j.JP_ID, JobTitle
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j 
	INNER JOIN bdjCorporate.[adm].[LNJobPosting] AS l ON l.JP_ID = j.JP_ID
)
, personCTE AS (
SELECT j.JP_ID, j.JobTitle, i.P_ID ,
ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY i.P_ID DESC) AS r 
FROM jobCTE AS j
INNER JOIN bdjCorporate.rp.ApplyFromOtherSrc AS i ON i.JP_ID = j.JP_ID
)

SELECT p.JP_ID, p.JobTitle, p.P_ID FROM personCTE AS p
INNER JOIN bdjResumes..UserSocialMedia AS sm ON p.P_ID = sm.accID
WHERE sm.UseType = 'L' AND r= 1


SELECT TOP 5 * FROM bdjResumes..UserSocialMedia AS 