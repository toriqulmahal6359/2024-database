-- Special Characters (Problem ase)

--SELECT c.ContactId, c.CP_ID, u.ContactName FROM [dbo].[ContactPersons] AS u
--LEFT JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = u.CP_ID
--WHERE u.ContactName LIKE '%~%' AND u.ContactName LIKE '%!%' OR u.ContactName LIKE '%@%' OR u.ContactName LIKE '%#%' OR u.ContactName LIKE '%$%'
--OR u.ContactName LIKE '%./%./%' OR u.ContactName LIKE '%^%' OR u.ContactName LIKE '%&%' --OR u.ContactName LIKE '%*%'
--OR u.ContactName LIKE '%./_./%' OR u.ContactName LIKE '%=%' OR u.ContactName LIKE '%+%' OR u.ContactName LIKE '%/%'
--OR u.ContactName LIKE '%?%' OR u.ContactName LIKE '%<%' OR u.ContactName LIKE '%>%' OR u.ContactName LIKE '%./''./%' OR u.ContactName LIKE '%./""./%'
--OR u.ContactName LIKE '%{}%' OR u.ContactName LIKE '%[]%'

---=============================== UPDATE =========================================

SELECT  c.CP_ID, u.UserId, u.User_Name FROM [dbo].[CorporateUserAccess] AS u
INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = u.CP_ID
WHERE (u.User_Name LIKE '%~%' AND u.User_Name LIKE '%!%' OR u.User_Name LIKE '%@%' OR u.User_Name LIKE '%#%' OR u.User_Name LIKE '%$%'
OR u.User_Name LIKE '%./%./%' OR u.User_Name LIKE '%^%' OR u.User_Name LIKE '%&%' --OR u.ContactName LIKE '%*%'
OR u.User_Name LIKE '%./_./%' OR u.User_Name LIKE '%=%' OR u.User_Name LIKE '%+%' OR u.User_Name LIKE '%/%'
OR u.User_Name LIKE '%?%' OR u.User_Name LIKE '%<%' OR u.User_Name LIKE '%>%' OR u.User_Name LIKE '%./''./%' OR u.User_Name LIKE '%./""./%'
OR u.User_Name LIKE '%{}%' OR u.User_Name LIKE '%[]%' ) --AND c.CP_ID IN (81, 60128, 104718, 113393, 71972, 72575)

---=============================== UPDATE =========================================

-- %~!@#$%^&*()_%

-- Total Number Of Jobs (Top Most [Companywise])

-- [dbo].[CorporateUserAccess]

WITH jobCTE AS (
	SELECT j.CP_ID, j.JP_ID,
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.PublishDate FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
	AND j.PublishDate >= '05/01/2023'
)
, jobCount AS (
	SELECT j.CP_ID, u.UserId, COUNT(j.JP_ID) AS [Job Count]
	FROM jobCTE AS j
	INNER JOIN [dbo].[CorporateUserAccess] AS u ON u.CP_ID = j.CP_ID
	GROUP BY j.CP_ID, u.UserId
)
SELECT * FROM jobCount AS j ORDER BY j.[Job Count] DESC

--WITH jobCount AS (
--	SELECT CP_ID, COUNT(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS] AS j
--	GROUP BY CP_ID
--)
--SELECT 

-- Total Number Of Applicants (Top Most [Jobwise])

--SELECT JP_ID FROM 

---=============================== UPDATE =========================================

WITH applicantCTE AS (
	SELECT JP_ID, COUNT(ApplyID) AS [Total Applicants] FROM [DBO].[DBO_JOB_INBOX] 
	GROUP BY JP_ID
)
, jobCTE AS (
	SELECT a.*, j.CP_ID
	, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	FROM [dbo].[DBO_JOBPOSTINGS] AS j 
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	LEFT JOIN applicantCTE AS a ON j.JP_ID = a.JP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
	AND j.PublishDate >= '05/01/2023'
)
, UserCTE AS (
	SELECT j.*, u.UserId FROM jobCTE AS j
	INNER JOIN [dbo].[CorporateUserAccess] AS u ON u.CP_ID = j.CP_ID
)

SELECT UserId, CP_ID, JP_ID, [Job TiTle], [Total Applicants] FROM UserCTE ORDER BY [Total Applicants] DESC

---=============================== UPDATE =========================================

--WITH jobCTE AS (
--	SELECT j.CP_ID, j.JP_ID, 
--	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title] FROM [dbo].[DBO_JOBPOSTINGS] AS j
--	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
--	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
--	AND j.PublishDate >= '05/01/2023'
--)
--, ApplyCount AS (
--	SELECT j.*, COUNT(i.ApplyId) AS [Total Applicants]
--	FROM jobCTE AS j
--	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
--	GROUP BY j.JP_ID, j.CP_ID, j.[Job Title]
--)
--, UserCTE AS (
--	SELECT a.*, u.UserId FROM ApplyCount AS a 
--	INNER JOIN [dbo].[CorporateUserAccess] AS u ON u.CP_ID = a.CP_ID
--)
--SELECT * FROM UserCTE

--SELECT * FROM ApplyCount ORDER BY [Total Applicants] DESC

--SELECT TOP 5 * FROM [DBO].[DBO_JOB_INBOX]

-- Total Number of Followers (Top Most)
--SELECT TOP 5 * FROM [app].[UserInfolog]

---=============================== UPDATE =========================================

WITH followCountCTE AS (
	SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] GROUP BY CP_ID
)
,jobCTE AS (
	SELECT DISTINCT f.CP_ID, f.[Followers]
	--, ROW_NUMBER() OVER(PARTITION BY f.CP_ID ORDER BY f.[followers]) AS Row_NUM 
	FROM followCountCTE AS f
	RIGHT JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.CP_ID = f.CP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
	AND j.PublishDate >= '05/01/2023'
)
, userCTE AS (
	SELECT j.CP_ID, u.UserId, j.[Followers] 
	, ROW_NUMBER() OVER(PARTITION BY j.CP_ID ORDER BY j.[followers] DESC) AS ROW_NUM
	FROM jobCTE AS j
	INNER JOIN [dbo].[CorporateUserAccess] AS u ON u.CP_ID = j.CP_ID
	--WHERE Row_NUM < 2
	--ORDER BY j.[Followers] DESC
)
SELECT u.CP_ID, u.UserId, u.Followers FROM userCTE AS u WHERE ROW_NUM < 2
ORDER BY u.[Followers] DESC

---=============================== UPDATE =========================================

--WITH followCountCTE AS (
--	SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] GROUP BY CP_ID
--)
--,jobCTE AS (
--	SELECT f.CP_ID, f.[Followers] FROM followCountCTE AS f
--	RIGHT JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.CP_ID = f.CP_ID
--	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
--	AND j.PublishDate >= '05/01/2023'
--)
--SELECT j.CP_ID, u.ContactId, j.[Followers] FROM jobCTE AS j
--INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
--ORDER BY j.[Followers] DESC

-- Number of Posted Jobs

SELECT u.UserId, p.CP_ID, COUNT(p.JP_ID) AS [Posted Jobs] FROM DBO_JOBPOSTINGS AS p
LEFT JOIN [dbo].[CorporateUserAccess] AS u ON u.CP_ID = p.CP_ID
WHERE p.PostingDate >= '05/01/2023' AND p.Drafted = 0 AND p.Verified = 1
GROUP BY u.UserId, p.CP_ID
--HAVING COUNT(p.JP_ID) <= 5
HAVING COUNT(p.JP_ID) <= 5

-- Archived List

SELECT u.UserId, 
p.CP_ID, p.JP_ID FROM DBO_JOBPOSTINGS AS p
LEFT JOIN [dbo].[CorporateUserAccess] AS u ON u.CP_ID = p.CP_ID
INNER JOIN [arcCorporate].[dbo].[DBO_JOBPOSTINGS_arc] AS a ON a.JP_ID = p.JP_ID AND a.CP_ID = p.CP_ID
WHERE p.VERIFIED = 1 AND p.OnlineJob = 1