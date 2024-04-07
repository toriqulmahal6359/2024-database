SELECT * FROm [arcCorporate].[dbo].[DBO_JOBPOSTINGS_arc]


SELECT * FROM [dbo].[FollowedEmployers]

SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] WHERE CP_ID = 22779 GROUP BY CP_ID

SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] WHERE CP_ID = 46054 GROUP BY CP_ID

SELECT CP_ID, COUNT(P_ID) AS [Followers] FROM [dbo].[FollowedEmployers] WHERE CP_ID = 38918 GROUP BY CP_ID

--123185


SELECT  c.CP_ID, u.UserId, u.User_Name FROM [dbo].[CorporateUserAccess] AS u
INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = u.CP_ID
WHERE (u.User_Name LIKE '%~%' AND u.User_Name LIKE '%!%' OR u.User_Name LIKE '%@%' OR u.User_Name LIKE '%#%' OR u.User_Name LIKE '%$%'
OR u.User_Name LIKE '%./%./%' OR u.User_Name LIKE '%^%' OR u.User_Name LIKE '%&%' --OR u.ContactName LIKE '%*%'
OR u.User_Name LIKE '%./_./%' OR u.User_Name LIKE '%=%' OR u.User_Name LIKE '%+%' OR u.User_Name LIKE '%/%'
OR u.User_Name LIKE '%?%' OR u.User_Name LIKE '%<%' OR u.User_Name LIKE '%>%' OR u.User_Name LIKE '%./''./%' OR u.User_Name LIKE '%./""./%'
OR u.User_Name LIKE '%{}%' OR u.User_Name LIKE '%[]%' ) AND (u.AdminUser = 0) --AND c.CP_ID IN (81, 60128, 104718, 113393, 71972, 72575)


SELECT COUNT(JP_ID) FROM [dbo].[DBO_JOBPOSTINGS] AS j WHERE CP_ID = 28640
AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4
	AND j.PublishDate >= '05/01/2023'

SELECT COUNT(ApplyId) FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1142273

SELECT COUNT(ApplyId) FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1226811--1160482--1182773--1160502--1213001

SELECT TOP 100 * from [dbo].[CorporateUserAccess] WHERE CP_ID = 27721  AND UserId = 62553

30859 125515
28640 127952
30296 65080
29513 102659
27721 62553