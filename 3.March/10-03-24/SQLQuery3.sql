WITH jobCTE AS (
	SELECT DISTINCT CONVERT(DATE, j.PublishDate, 101) AS d_name, 
	j.JP_ID, j.CP_ID, COUNT(DISTINCT m.FilterName) AS filter_count FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
	AND (m.FilterName LIKE '%Location%' OR m.FilterName LIKE '%Salary%' OR m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%WorkArea%' OR m.FilterName LIKE '%Skill%')
	GROUP BY CONVERT(DATE, j.PublishDate, 101), j.JP_ID, j.CP_ID
)
, countCTE AS (
	SELECT 
	j.d_name,
	COUNT(DISTINCT CASE WHEN j.filter_count = 1 THEN j.JP_ID END) AS [Any_one_criteria_used_match(jobs)], 
	COUNT(DISTINCT CASE WHEN j.filter_count = 1 THEN j.CP_ID END) AS [Any_one_criteria_used_match(company)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 2 THEN j.JP_ID END) AS [Any_two_criteria_used_match(jobs)], 
	COUNT(DISTINCT CASE WHEN j.filter_count = 2 THEN j.CP_ID END) AS [Any_two_criteria_used_match(company)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 3 THEN j.JP_ID END) AS [Any_three_criteria_used_match(jobs)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 3 THEN j.CP_ID END) AS [Any_three_criteria_used_match(company)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 4 THEN j.JP_ID END) AS [Any_four_criteria_used_match(jobs)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 4 THEN j.CP_ID END) AS [Any_four_criteria_used_match(company)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 5 THEN j.JP_ID END) AS [Any_five_criteria_used_match(jobs)],
	COUNT(DISTINCT CASE WHEN j.filter_count = 5 THEN j.CP_ID END) AS [Any_five_criteria_used_match(company)]
	FROM jobCTE AS j
	INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	GROUP BY j.d_name 
)
, totaljobCTE AS (
	SELECT CONVERT(DATE, j.PublishDate, 101) AS d_name, 
    COUNT(DISTINCT j.JP_ID) AS [Total_job_Count], COUNT(DISTINCT j.CP_ID) AS [Unique Company Count]
    FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
    LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
    GROUP BY CONVERT(DATE, j.PublishDate, 101)
)
, job2CTE AS (
	SELECT J.JP_ID, STRING_AGG(CASE WHEN Mandatory IS NULL THEN 0 ELSE Mandatory END, ',') AS Mandatory 
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters M ON J.JP_ID = M.JP_ID
	WHERE j.PublishDate >= '01/22/2024' and j.Drafted = 0 AND j.Verified = 1 AND j.OnlineJob = 1
	--AND (m.FilterName LIKE '%%Age' OR m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Sex%')
	GROUP BY J.JP_ID
)
, oneCount AS (
SELECT JP_ID, Mandatory, LEN(Mandatory) - LEN(REPLACE(mandatory, '1', '')) AS ones 
FROM job2CTE
--WHERE Mandatory LIKE '%1%'
)
, restrictionCTE AS (
	SELECT CONVERT(DATE, j.PublishDate, 101) AS d_name, 
	COUNT(DISTINCT o.JP_ID) AS [Total Job Count], COUNT(DISTINCT j.CP_ID) AS [Unique Company Count],
	COUNT(DISTINCT CASE WHEN o.Mandatory NOT LIKE '%1%' THEN o.JP_ID END) AS [No_criteria_used (jobs)],
	COUNT(DISTINCT CASE WHEN o.Mandatory NOT LIKE '%1%' THEN j.CP_ID END) AS [No_criteria_used (Company)],
	COUNT(DISTINCT CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 1 THEN o.JP_ID END) AS [any_one_criteria_used_restriction(jobs)],
	COUNT(DISTINCT CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 1 THEN j.CP_ID END) AS [any_one_criteria_used_restriction(Company)],
	COUNT(DISTINCT CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 2 THEN o.JP_ID END) AS [any_two_criteria_used_restriction(jobs)],
	COUNT(DISTINCT CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 2 THEN j.CP_ID END) AS [any_two_criteria_used_restriction(Company)],
	COUNT(DISTINCT CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 3 THEN o.JP_ID END) AS [any_three_criteria_used_restriction(jobs)],
	COUNT(DISTINCT CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 3 THEN j.CP_ID END) AS [any_three_criteria_used_restriction(Company)]
	FROM oneCount AS o
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON o.JP_ID = j.JP_ID
	--WHERE o.ones = 1
	--GROUP BY MONTH(j.PostingDate)
	GROUP BY CONVERT(DATE, j.PublishDate, 101)
	--ORDER BY m_name
)

SELECT c.d_name, 
       t.[Total_job_Count], 
       t.[Unique Company Count],
	   c.[Any_one_criteria_used_match(Jobs)], 
       c.[Any_one_criteria_used_match(Company)],
       c.[Any_two_criteria_used_match(Jobs)], 
       c.[Any_two_criteria_used_match(Company)],
       c.[Any_three_criteria_used_match(Jobs)], 
       c.[Any_three_criteria_used_match(Company)],
       c.[Any_four_criteria_used_match(Jobs)], 
       c.[Any_four_criteria_used_match(Company)],
       c.[Any_five_criteria_used_match(Jobs)], 
       c.[Any_five_criteria_used_match(Company)],
	   r.[No_criteria_used (jobs)],
	   r.[No_criteria_used (Company)],
	   r.[any_one_criteria_used_restriction(jobs)],
	   r.[any_one_criteria_used_restriction(Company)],
	   r.[any_two_criteria_used_restriction(jobs)],
	   r.[any_two_criteria_used_restriction(Company)],
	   r.[any_three_criteria_used_restriction(jobs)],
	   r.[any_three_criteria_used_restriction(Company)]
FROM countCTE c
JOIN totaljobCTE t ON c.d_name = t.d_name
JOIN restrictionCTE AS r ON r.d_name = c.d_name;


--SELECT COUNT(DISTINCT CP_ID) AS c_count FROM DBO_JOBPOSTINGS AS j
--WHERE j.PostingDate >= '01/22/2024'

--SELECT COUNT(DISTINCT CP_ID) AS c_Count FROM DBO_COMPANY_PROFILES


--Unique Job and Company Count  

SELECT --DISTINCT --CONVERT(DATE, j.PublishDate, 101) AS d_name, 
	COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company, COUNT(DISTINCT m.FilterName) AS filter_count FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
	AND (m.FilterName LIKE '%Location%' OR m.FilterName LIKE '%Salary%' OR m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%WorkArea%' OR m.FilterName LIKE '%Skill%')
	--GROUP BY CONVERT(DATE, j.PublishDate, 101)

