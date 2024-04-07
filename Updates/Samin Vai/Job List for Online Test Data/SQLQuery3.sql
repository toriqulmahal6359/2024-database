;WITH Job_CTE AS (
SELECT DISTINCT J.CP_ID, C.NAME, J.JP_ID, CASE WHEN J.JobLang = 2 THEN BJ.TITLE ELSE J.JobTitle END AS JobTitle, CT.CAT_NAME, J.JobLevel
, CASE WHEN CAST(J.MinExp AS varchar(2)) = -1 THEN 'Any' ELSE CAST(J.MinExp AS varchar(2)) END+'-'+ CASE WHEN CAST(J.MaxExp AS varchar(2)) = -1 THEN 'Any' ELSE CAST(J.MaxExp AS varchar(2)) END AS [Experience (Min-Max)], J.DeadLine
FROM bdjCorporate..DBO_JOBPOSTINGS J
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES C ON J.CP_ID = C.CP_ID
	INNER JOIN bdjCorporate..CATEGORY CT ON J.CAT_ID = CT.CAT_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS BJ ON J.JP_ID = BJ.JP_ID
WHERE J.VERIFIED = 1 AND J.CVReceivingOptions LIKE '%1%' AND J.PublishDate > '03/19/2024' --AND J.PublishDate < '05/26/2023'
), Contact_CTE AS (
SELECT DISTINCT J.CP_ID, C.ContactName, C.Mobile,  ROW_NUMBER() OVER (PARTITION BY C.CP_ID ORDER BY C.Mobile) row_num
FROM Job_CTE J
INNER JOIN bdjCorporate..ContactPersons C ON J.CP_ID = C.CP_ID
WHERE C.ActiveUser = 1 AND (C.Mobile <> NULL OR C.Mobile <> '')
)
SELECT DISTINCT J.CP_ID, J.NAME, J.JP_ID, J.JobTitle, J.CAT_NAME, J.JobLevel, J.[Experience (Min-Max)], J.DeadLine,C.ContactName, 
CASE WHEN C.Mobile LIKE '/./' OR C.Mobile = '0' THEN NULL ELSE c.Mobile END AS [Mobile]
FROM Job_CTE J
LEFT JOIN Contact_CTE C ON J.CP_ID = C.CP_ID AND C.row_num = 1
ORDER BY J.CP_ID,J.JP_ID


;WITH Job_CTE AS (SELECT DISTINCT J.CP_ID, C.NAME, J.JP_ID, CASE WHEN J.JobLang = 2 THEN BJ.TITLE ELSE J.JobTitle END AS JobTitle, CT.CAT_NAME, J.JobLevel, CASE WHEN CAST(J.MinExp AS varchar(2)) = -1 THEN 'Any' ELSE CAST(J.MinExp AS varchar(2)) END+'-'+ CASE WHEN CAST(J.MaxExp AS varchar(2)) = -1 THEN 'Any' ELSE CAST(J.MaxExp AS varchar(2)) END AS [Experience (Min-Max)], J.DeadLineFROM bdjCorporate..DBO_JOBPOSTINGS J	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES C ON J.CP_ID = C.CP_ID	INNER JOIN bdjCorporate..CATEGORY CT ON J.CAT_ID = CT.CAT_ID	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS BJ ON J.JP_ID = BJ.JP_IDWHERE J.VERIFIED = 1 AND J.CVReceivingOptions LIKE '%1%' AND J.PublishDate > '03/19/2024' --AND J.PublishDate < '05/26/2023'), Contact_CTE AS (SELECT DISTINCT J.CP_ID, C.ContactName, C.Mobile,  ROW_NUMBER() OVER (PARTITION BY C.CP_ID ORDER BY C.Mobile) row_numFROM Job_CTE JINNER JOIN bdjCorporate..ContactPersons C ON J.CP_ID = C.CP_IDWHERE C.ActiveUser = 1 AND (C.Mobile <> NULL OR C.Mobile <> '')AND LEN(C.MOBILE) > 10   AND LEN(C.MOBILE) < 12  AND C.MOBILE LIKE '01%' --AND (C.MOBILE <> '0119%' OR C.MOBILE <> '011%' OR C.MOBILE <> '012%'))SELECT DISTINCT J.CP_ID, J.NAME, J.JP_ID, J.JobTitle, J.CAT_NAME, J.JobLevel, J.[Experience (Min-Max)], J.DeadLine,C.ContactName,C.Mobile--,CASE WHEN C.Mobile IS NULL OR  C.Mobile = 0 THEN NULL ELSE C.Mobile END AS MobileFROM Job_CTE JLEFT JOIN Contact_CTE C ON J.CP_ID = C.CP_ID AND C.row_num = 1ORDER BY J.CP_ID,J.JP_ID