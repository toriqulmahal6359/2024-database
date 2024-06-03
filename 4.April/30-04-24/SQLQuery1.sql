--SELECT c.cp_ID,z.ZoneName
--				FROM bdjCorporate.Sales.SalesPersons S
--					INNER JOIN bdjCorporate.Sales.AssignRegion R ON S.SPID = R.SPID
--					INNER JOIN bdjCorporate.Sales.ZoneWiseArea ZA ON R.AreaID = ZA.AreaID
--					INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES C ON ZA.AreaID = C.ThanaId
--					INNER JOIN bdjCorporate.[Sales].[Zone] z on za.ZoneID = z.ZoneID

--SELECT * FROM bdjCorporate.Sales.SalesPersons

WITH job AS (
	SELECT JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	WHERE j.PublishDate >= '01/01/2023' AND j.PublishDate <= '04/29/2024' AND (j.CAT_ID >= 60 OR j.CAT_ID = -11)
	UNION 
	SELECT JP_ID FROM arcCorporate..DBO_JOBPOSTINGS_arc AS j
	WHERE j.PublishDate >= '01/01/2023' AND j.PublishDate <= '04/29/2024' AND (j.CAT_ID >= 60 OR j.CAT_ID = -11)

)
, applyCTE AS (
	SELECT j.JP_ID, COUNT(ApplyID) AS [ApplyCount]
	FROM job AS j
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
		GROUP BY j.JP_ID

		UNION
	SELECT j.JP_ID, COUNT(ApplyID) AS [ApplyCount]
	FROM job AS j
		INNER JOIN arcCorporate..DBO_JOB_INBOX_arc AS ji ON j.JP_ID = ji.JP_ID
		GROUP BY j.JP_ID
)
, jobApply_CTE AS (
	SELECT j.JP_ID, CASE WHEN a.JP_ID IS NULL THEN 0 ELSE a.[ApplyCount] END AS [ApplyCount]
	FROM job AS j
	LEFT JOIN applyCTE a ON j.JP_ID = a.JP_ID
)
,jobCTE AS (
	SELECT DISTINCT
	j.JP_ID
	, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]  
	,j.CP_ID, c.NAME AS [Company Name], j.DeadLine, j.PublishDate, ct.CAT_NAME AS [Special Skill Category], i.ORG_TYPE_NAME AS [Industry Type], c.ADDRESS, jj.[ApplyCount]
	FROM jobApply_CTE AS jj
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON jj.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
	LEFT JOIN bdjCorporate.[dbo].[CATEGORY] AS ct ON j.CAT_ID = ct.CAT_ID
	LEFT JOIN bdjCorporate..[ORG_TYPES] AS i ON j.ORG_Type_ID = i.ORG_TYPE_ID 

	--LEFT JOIN bdjCorporate..ContactPersons AS p ON j.CP_ID = p.CP_ID AND p.ActiveUser = 1
	--WHERE j.PublishDate >= '01/01/2023' AND j.PublishDate <= '04/29/2024'
	--AND (j.CAT_ID >= 60 OR j.CAT_ID = -11)
	--GROUP BY j.JP_ID, j.JobLang, bj.TITLE, j.JobTitle, j.CP_ID, c.NAME, j.DeadLine, j.PublishDate, ct.CAT_NAME, i.ORG_TYPE_NAME, c.ADDRESS
)
, companyCTE AS (
	SELECT j.*, p.ContactName AS [Name], p.Mobile, p.Email,
	ROW_NUMBER() OVER(PARTITION BY j.CP_ID ORDER BY p.ContactId DESC) AS r
	FROM jobCTE AS j
	LEFT JOIN bdjCorporate..ContactPersons AS p ON j.CP_ID = p.CP_ID AND p.ActiveUser = 1
)
, contact_CTE AS (
	SELECT CP_ID, Name, Mobile, Email 
	FROM companyCTE 
			  --bdjCorporate.Sales.SalesPersons S
	INNER JOIN bdjCorporate.Sales.AssignRegion R ON S.SPID = R.SPID
	INNER JOIN bdjCorporate.Sales.ZoneWiseArea ZA ON R.AreaID = ZA.AreaID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES C ON ZA.AreaID = C.ThanaId
	INNER JOIN bdjCorporate.[Sales].[Zone] z on za.ZoneID = z.ZoneID
	WHERE r = 1
)
 
SELECT j.CP_ID, [Company Name], [Industry Type], j.JP_ID, [Job Title], [Special Skill Category], PublishDate, Deadline, [ApplyCount] AS [# of Applicant]
,Name, Mobile AS [Phone], Email, ADDRESS
FROM jobCTE j
	LEFT JOIN contact_CTE AS c ON c.CP_ID = j.CP_ID
--WHERE r = 1

--SELECT * FROM bdjCorporate..[ORG_TYPES]
--SELECT * FROM bdjCorporate.[dbo].[CATEGORY]
--SELECT TOP 5 * FROM bdjCorporate..DBO_JOBPOSTINGS
--SELECT TOP 5 * FROM bdjCorporate..DBO_COMPANY_PROFILES
--SELECT TOP 5 * FROM bdjResumes..UserAccounts
--SELECT * FROm bdjCorporate.[dbo].[DBO_JOB_CATEGORY]

--SELECT * FROM bdjCorporate.[dbo].[IndustryTypes]
--SELECT * FROm bdjCorporate.[dbo].[IndustryWiseCompanies]




--SELECT TOP 5 * FROM bdjCorporate..ContactPersons WHERE JP_ID = 1143181

--SELECT j.JP_ID, COUNT(ji.ApplyID) FROM jobCTE AS j
--LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
--GROUP BY j.JP_ID


SELECT ApplyId, JP_ID FROM bdjCorporate..DBO_JOB_INBOX AS ji
WHERE JP_ID IN (1164128, 1195217, 1203922)

