SELECT TOP 5 * FROM [dbo].[DBO_COMPANY_PROFILES]
SELECT TOP 5 * FROm [dbo].[COMPANY_BUSINESS]
SELECT TOP 5 * FROm [dbo].[CompanyServices]

SELECT TOP 5 * FROm [dbo].[ContactPersons]

SELECT TOP 5 * FROM [dbo].[DBO_JOB_SOURCE]
SELECT TOP 5 * FROM [dbo].[DBO_SOURCES]

SELECT TOP 5 * FROm [dbo].[JobActivities]

-- Special Characters

SELECT c.ContactId, c.CP_ID, u.ContactName FROM [dbo].[ContactPersons] AS u
LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = u.CP_ID
WHERE u.ContactName LIKE '%~!@#$%^&*()_%'

-- Total Number Of Jobs (Top Most [Companywise])

WITH jobCTE AS (
	SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title] FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
)
, jobCount AS (
	SELECT j.CP_ID, u.ContactId AS [UserId], COUNT(j.JP_ID) AS [Job Count]
	FROM jobCTE AS j
	INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
	GROUP BY j.CP_ID, u.ContactId
)
SELECT * FROM jobCount AS j ORDER BY j.[Job Count] DESC


-- Total Number Of Applicants (Top Most [Jobwise])

WITH jobCTE AS (
	SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title] FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
)
, ApplyCount AS (
	SELECT j.CP_ID, u.ContactId AS [UserId], j.JP_ID, j.[Job Title], COUNT(i.ApplyId) AS [Total Applicants]
	FROM jobCTE AS j
	INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
	GROUP BY j.JP_ID, u.ContactId, j.CP_ID, j.[Job Title]
)

SELECT * FROM ApplyCount ORDER BY [Total Applicants] DESC


-- Total Number Of Followers

WITH jobCTE AS (
	SELECT j.CP_ID, j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title] FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
	AND j.PublishDate >= '05/01/2023'
)
, CompanyCTE AS (
	SELECT j.CP_ID, u.ContactId AS [UserId] FROM jobCTE AS j
	INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
)
SELECT c.CP_ID, c.UserId, COUNT(f.P_ID) FROM companyCTE AS c 
INNER JOIN [dbo].[FollowedEmployers] AS f ON f.CP_ID = c.CP_ID
GROUP BY c.CP_ID, c.UserId

-- Total Followers

WITH followCountCTE AS (
	SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] GROUP BY CP_ID
)
,jobCTE AS (
	SELECT f.CP_ID, f.[Followers] FROM followCountCTE AS f
	INNER JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.CP_ID = f.CP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
)
SELECT j.CP_ID, u.ContactId AS [UserId], j.[Followers] FROM jobCTE AS j
INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
ORDER BY j.[Followers] DESC

--SELECT j.CP_ID, j.JP_ID, u.ContactId AS [UserId], COUNT(f.P_ID) AS [Total Followers]  FROM jobCTE AS j
--INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
--INNER JOIN [dbo].[FollowedEmployers] AS f ON f.CP_ID = j.CP_ID
--GROUP BY j.CP_ID, j.JP_ID, u.ContactId



-- Number of Posted Jobs

SELECT u.ContactId, p.CP_ID, COUNT(p.JP_ID) AS [Posted Jobs] FROM DBO_JOBPOSTINGS AS p
LEFT JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = p.CP_ID
WHERE p.PostingDate >= '05/01/2023'
GROUP BY u.ContactId, p.CP_ID
HAVING COUNT(p.JP_ID) <= 5

-- Archived List

SELECT u.ContactId, p.CP_ID, p.JP_ID FROM DBO_JOBPOSTINGS AS p
LEFT JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = p.CP_ID
INNER JOIN [arcCorporate].[dbo].[DBO_JOBPOSTINGS_arc] AS a ON a.JP_ID = p.JP_ID AND a.CP_ID = p.CP_ID

SELECT * FROM [arcCorporate].[dbo].[DBO_JOBPOSTINGS_arc] WHERE JP_ID = 512944

SELECT * FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID = 773461     --773461


SELECT p.JP_ID FROM DBO_JOBPOSTINGS AS p
LEFT JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = p.CP_ID


SELECT TOP 5 * FROm [arcCorporate].[dbo].[DBO_JOBPOSTINGS_arc]

--, ApplyCount AS (
--	SELECT j.UserId, j.CP_ID, j.JP_ID, j.[Job Title], COUNT(i.ApplyID) AS [Total Applicants] FROM jobCount AS j
--	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
--	GROUP BY j.JP_ID, j.UserId, j.CP_ID, j.JP_ID, j.[Job Title]
--)


SELECT * FROM [dbo].[DBO_JOB_INBOX] WHERE JP_ID = 1213001

SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS] WHERE CP_ID = 35450

SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX]

SELECT TOP 5 * FROM AND j.PublishDate >= '05/01/2023'


SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX]




SELECT * FROM [dbo].[DBO_JOB_SOURCE]
SELECT TOP 5 * FROm [dbo].[DBO_JOBPOSTINGS]


--'/^(a(\1)?b)$/'


SELECT name
FROM names
WHERE name REGEXP '^[^a-zA-Z0-9%@#^*!]+$';


-- sudipto sarker ` !$#%^&*&
-- ~!@#$%^&*()_+~!@#$%^&*(
-- nkscnoeosnownfowjoejicheofjelfneojxiejfoejofjeuheidnihdi dij dohdhwib2_92+_96@$-@$-$+$+*;";`!:*?"-*;
-- nkscnoeosnownfowjoejicheofjelfneojxiejfoejofjeuheidnihdi dij dohdhwib2_92+_96@$-@$-$+$+*;";`!:*?"-*;
-- %*#/£#/£#_("^($_¥$^#¥_$?€$/£#¥_$=€#_?$£/#?€$/*"&)%_£$ ydiydyofuoclydyofuoditdpufjhcyofoyfuoflhxtid6
-- $$$