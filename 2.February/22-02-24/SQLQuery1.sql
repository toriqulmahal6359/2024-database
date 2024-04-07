SELECT JP_ID, COUNT(ApplyID) AS TotalApplicants FROM [dbo].[DBO_JOB_INBOX] 
WHERE JP_ID IN (1227085, 1227068, 1226989, 1226980, 1226913, 1226894, 1226889, 1226888, 1226800, 1226778)
GROUP BY JP_ID

SELECT * FROM 

SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX] 
SELECT TOP 5 * , DATEADD(YEAR, TExp, 0) AS  FROM [dbo].[UserSummary]



SELECT TOP 5 * FROM [bdjResumes].dbo.PERSONAL
SELECT TOP 5 * FROm [bdjResumes]..[UserSummary]
SELECT TOP 5 * FROM [bdjResumes].[dbo].[UserAccounts] 
SELECT TOP 5 * FROM [bdjResumes]..[PersonalExtras]
SELECT TOP 5 * FROM [bdjResumes]..[PersonalOthers]




SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS]

SELECT TOP 5 * FROm [bdjResumes]..[EDU]
SELECT TOP 5 * FROM [bdjResumes].[dbo].[EducationDegrees]
SELECT TOP 5 * FROM [bdjResumes].[dbo].[EDULEVEL]

WITH jobCTE AS (
	SELECT j.JP_ID,
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], 
	i.P_ID, j.CP_ID FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
	INNER JOIN DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	WHERE j.JP_ID = 1229053 AND c.CP_ID = 20558
)
, personalCTE AS (
	SELECT j.JP_ID, j.P_ID,
	CONCAT(u.accFirstName, ' ', u.accLastName) AS [Name], 
	CASE WHEN u.accGender = 'M' THEN 'MALE'
		WHEN u.accGender = 'F' THEN 'FEMALE' END AS [Gender],
		u.accPhone AS [Phone Number],
		u.accEmail AS [Email]
	FROM jobCTE AS j
	INNER JOIN [bdjResumes].dbo.PERSONAL AS p ON p.ID = j.P_ID
	INNER JOIN [bdjResumes].[dbo].[UserAccounts] AS u ON u.accID = j.P_ID
)
, experienceCTE AS (
	SELECT p.*,
	CASE WHEN (CAST(ex.ETO AS VARCHAR(11)) = '1900-01-01 00:00:00' OR ex.ETO IS NULL) THEN 'YES' ELSE 'NO' END AS [Employed (Yes/No)]
	FROM personalCTE AS p
	INNER JOIN [bdjResumes].[dbo].[EXP] AS ex ON ex.P_ID = e.P_ID
)
, educationCTE AS (
SELECT p.P_ID, p.Name, p.Gender, p.Email, 
	e.Education,
	e.INSTITUTE AS [University],
	e.SUBJECT,
	e.PASSING_YEAR,
	e.ACHIEVEMENT,
	CASE WHEN e.Edulevel = 5 THEN 'YES' ELSE 'NO' END AS [Masters Completed],
	ROW_NUMBER() OVER(PARTITION BY p.P_ID ORDER BY (SELECT TOP 1 e.Passing_Year) DESC) AS ROW_NUM
	FROM personalCTE AS p
INNER JOIN [bdjResumes]..[EDU] AS e ON e.P_ID = p.P_ID
--INNER JOIN [bdjResumes].[dbo].[EDULEVEL] AS l ON l.E_CODE = e.Edulevel AND l.E_CODE = e.EDULEVEL2
--WHERE e.EduLevel = 5
--GROUP BY e.Education, p.P_ID, p.Name, p.Gender, p.Email, e.PASSING_YEAR
)
, experienceCTE AS (
	SELECT e.*, 
	CASE WHEN (CAST(ex.ETO AS VARCHAR(11)) = '1900-01-01 00:00:00' OR ex.ETO IS NULL) THEN 'YES' ELSE 'NO' END AS [Employed (Yes/No)]
	FROM educationCTE AS e 
	INNER JOIN [bdjResumes].[dbo].[EXP] AS ex ON ex.P_ID = e.P_ID
	WHERE e.ROW_NUM < 2
)

SELECT * FROM experienceCTE


SELECT TOP 5 * FROM [bdjResumes].[dbo].[EXP]

SELECT p.NAME FROM [bdjResumes].dbo.PERSONAL AS p
