--SELECT TOP 5 * FROM bdjCorporate..DBO_JOBPOSTINGS

--SELECT TOP 5 * FROM  bdjCorporate..DBO_COMPANY_PROFILES

--SELECT TOP 5 * FROM bdjCorporate..ContactPersons

--SELECT TOP 5 * FROM [dbo].[DBO_JOB_CATEGORY]

--SELECT * FROM [dbo].[CATEGORY]

WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], 
	j.CP_ID, j.JobLevel, ct.CAT_NAME AS [Category Name],
	CASE WHEN j.MinExp = -1 THEN 0 ELSE j.MinExp END AS [MinExp], 
	CASE WHEN j.MaxExp = -1 THEN 0 ELSE j.MaxExp END AS [MaxExp], 
	CONVERT(DATE, j.DeadLine, 101) AS [DeadLine] 
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
	INNER JOIN [dbo].[CATEGORY] AS ct ON ct.CAT_ID = j.CAT_ID
	WHERE j.PublishDate > '03/13/2024 00:00:00'
	AND j.CVReceivingOptions LIKE '%1%' AND j.OnlineJob = 1 AND j.VERIFIED = 1--AND j.Drafted = 0 AND j.Closed = 0
)
, companyCTE AS (
	SELECT j.JP_ID, j.[Job Title], j.CP_ID, c.NAME AS [Company Title], 
	j.JobLevel, 
	CONCAT(j.MinExp , '-' ,j.MaxExp) AS [Experience (Min-Max)], 
	j.DeadLine, j.[Category Name] 
	FROM bdjCorporate..DBO_COMPANY_PROFILES AS c
	INNER JOIN jobCTE AS j ON j.CP_ID = c.CP_ID
)
, finalCTE AS (
	SELECT DISTINCT
	ROW_NUMBER() OVER(PARTITION BY c.JP_ID ORDER BY cp.ContactId DESC) AS [r],
	c.CP_ID AS [Company ID], c.[Company Title], c.JP_ID AS [JPID], c.[Job Title],
	c.JobLevel, c.[Category Name], c.[Experience (Min-Max)], c.DeadLine, cp.ContactName, cp.Mobile AS [Phone Number]
	FROM companyCTE AS c
	INNER JOIN bdjCorporate..ContactPersons AS cp ON cp.CP_ID = c.CP_ID
	WHERE cp.ActiveUser = 1
)

SELECT DISTINCT
ROW_NUMBER() OVER(ORDER BY f.JPID) AS [sl],
f.[Company ID], f.[Company Title], f.[JPID], f.[Job Title],
	f.JobLevel, f.[Category Name], f.[Experience (Min-Max)], f.DeadLine, f.ContactName, f.[Phone Number] 
FROM finalCTE AS f WHERE r = 1 --AND f.[Company Title] LIKE '%London%'
ORDER BY f.[Company ID]--, f.JPID
 
