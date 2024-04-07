--WITH followCountCTE AS (
--	SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] GROUP BY CP_ID
--)
--,jobCTE AS (
--	SELECT f.CP_ID, f.[Followers] FROM followCountCTE AS f
--	INNER JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.CP_ID = f.CP_ID
--	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
--)
--SELECT j.CP_ID, u.ContactId AS [UserId], j.[Followers] FROM jobCTE AS j
--INNER JOIN [dbo].[ContactPersons] AS u ON u.CP_ID = j.CP_ID
--ORDER BY j.[Followers] DESC



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


SELECT CP_ID , NAME FROM [dbo].[]


SELECT TOP 5 * FROM [dbo].[FollowedEmployers]


WITH companyCTE AS (
	SELECT CP_ID, STRING_AGG(CAST(CompanyName AS VARCHAR(MAX)), ',') AS [Company] FROM bdjCorporate.[dbo].[FollowedEmployers]
	GROUP BY CP_ID
)
, applicantCTE AS (
	SELECT DISTINCT f.P_ID, f.CP_ID, c.[Company] FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	INNER JOIN companyCTE AS c ON f.CP_ID = c.CP_ID
)
SELECT CP_ID, [Company], COUNT(DISTINCT P_ID) AS [Followers] FROM applicantCTE 
GROUP BY CP_ID, [Company]
ORDER BY CP_ID


SELECT * FROM companyCTE

SELECT COUNT(DISTINCT P_ID) FROM bdjCorporate.[dbo].[FollowedEmployers]

-- Active user who uses follow button

SELECT COUNT(DISTINCT f.P_ID) AS [Following Button user] FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
LEFT JOIN bdjResumes..PERSONAL AS p ON p.ID = f.P_ID 
WHERE p.UPDATED_DATE >= DATEADD(MONTH, -6, CONVERT(VARCHAR(100), GETDATE(), 101))

-- Active user Updated

SELECT COUNT(DISTINCT P_ID) AS [Following Button used] FROM bdjCorporate.[dbo].[FollowedEmployers] 
where P_ID in(
select ID from bdjResumes..PERSONAL WHERE UPDATED_DATE >= DATEADD(MONTH, -6, CONVERT(VARCHAR(100), GETDATE(), 101))
)

SELECT COUNT(DISTINCT ua.accID) FROM bdjResumes..UserAccounts AS ua 
INNER JOIN bdjCorporate.[dbo].[FollowedEmployers] AS f ON f.P_ID = ua.accID
WHERE ua.accISActivate = 1

SELECT f.P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
INNER JOIN bdjResumes.[dbo].[PERSONAL] AS p ON p.ID = f.P_ID

SELECT TOP 100 * FROM bdjResumes.[dbo].[PERSONAL] ORDER BY UpdatedOn DESC

SELECT COUNT(DISTINCT accID) FROM bdjResumes..UserAccounts
WHERE accIsActivate = 1


SELECT * FROM bdjResumes.[dbo].[ApplicantEmails] WHERE JP_ID = 1182505


-- Jobwise email data

SELECT JP_ID, COUNT(DISTINCT P_ID) AS [Applicant]
FROM bdjResumes.[dbo].[ApplicantEmails]
WHERE SentOn >= DATEADD(MONTH, -12, CONVERT(VARCHAR(100), GETDATE(), 101)) AND SentOn <= CONVERT(VARCHAR(100), GETDATE(), 101) 
GROUP BY JP_ID ORDER BY JP_ID

-- koto bar Email pathano hoise ar kotojon job seeker email pathaise last 1 year e 

SELECT COUNT(DISTINCT P_ID) AS [Applicant who sent Emails], COUNT(DISTINCT ID) AS [Count of Email Sent] FROM bdjResumes.[dbo].[ApplicantEmails]
WHERE SentOn >= DATEADD(MONTH, -12, CONVERT(VARCHAR(100), GETDATE(), 101)) --AND SentOn <= CONVERT(VARCHAR(100), GETDATE(), 101) 






