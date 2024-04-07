
	SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS]
	SELECT TOP 5 * FROM [dbo].[DBO_COMPANY_PROFILES]
	SELECT TOP 5 * FROM adm.LNJobPosting
	SELECT TOP 5 * FROM rp.ApplyFROMOtherSrc

GO

WITH jobCTE AS (
	SELECT j.JP_ID, j.CP_ID,
		CASE WHEN j.JobLang = 2 THEN bg.TITLE ELSE j.JobTitle END AS [Job Title]
		FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bg ON bg.JP_ID = j.JP_ID
	
)
, companyCTE AS (
	SELECT j.JP_ID, j.[Job TiTle], j.CP_ID, c.NAME AS [Company Name] FROM jobCTE AS j
	LEFT JOIN bdjCorporate.[dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
)

--SELECT c.JP_ID, c.[Job Title], c.CP_ID, c.[Company Name] FROM companyCTE AS c
SELECT c.JP_ID, c.[Job Title], c.CP_ID, c.[Company Name], COUNT(a.P_ID) AS [Total Easy Applicants] FROM companyCTE AS c
LEFT JOIN bdjCorporate.adm.LNJobPosting AS l ON l.JP_ID = c.JP_ID
LEFT JOIN bdjCorporate.rp.ApplyFromOtherSrc AS a ON a.JP_ID = l.JP_ID
WHERE l.LN_PostingDate = '02/18/2024'
AND l.ApplyType = 1
GROUP BY c.JP_ID, c.[Job Title], c.CP_ID, c.[Company Name] 


GO

WITH jobCTE AS (
	SELECT l.JP_ID, j.CP_ID, CASE WHEN j.JobLang = 2 THEN bg.TITLE ELSE j.JobTitle END AS [Job Title]  
	FROM adm.LNJobPosting AS l
	RIGHT JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.JP_ID = l.JP_ID
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bg ON bg.JP_ID = j.JP_ID
	WHERE l.ApplyType = 1 AND l.LN_PostingDate = '02/18/2024'
)
, companyCTE AS (
	SELECT j.*, c.NAME AS [Company Name] FROM jobCTE AS j
	INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
)
SELECT 

GO

WITH applyCTE AS (
	SELECT s.JP_ID, s.P_ID FROM bdjCorporate.rp.ApplyFROMOtherSrc AS s
	LEFT JOIN bdjCorporate.adm.LNJobPosting AS l ON l.JP_ID =  s.JP_ID
	WHERE s.ApplyDate = '02/18/2024' AND l.ApplyType = 1
)
, jobCTE AS (
	SELECT a.JP_ID, a.P_ID, j.CP_ID, CASE WHEN j.JobLang = 2 THEN bg.TITLE ELSE j.JobTitle END AS [Job Title] FROM applyCTE AS a
	INNER JOIN bdjCorporate.[dbo].[DBO_JOBPOSTINGS] AS j ON j.JP_ID = a.JP_ID
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bg ON bg.JP_ID = j.JP_ID

)
SELECT j.JP_ID, j.[Job Title], c.CP_ID, c.NAME AS [Company Name], COUNT(j.P_ID) AS [Total Apply Count] FROM jobCTE AS j
INNER JOIN bdjCorporate.[dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
GROUP BY j.JP_ID, j.[Job Title], c.CP_ID, c.NAME




