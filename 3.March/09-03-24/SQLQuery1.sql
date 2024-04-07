------ Set 1 -----

WITH jobCTE AS (
    SELECT CONVERT(DATE, j.PublishDate, 101) AS m_name, 
    j.JP_ID, j.CP_ID, COUNT(FilterName) AS filter_count
    FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
    LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
    GROUP BY CONVERT(DATE, j.PublishDate, 101), j.JP_ID, j.CP_ID
)
, locCTE AS (
    SELECT j.JP_ID, j.CP_ID, j.m_name, j.filter_count 
    FROM jobCTE AS j
    INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE m.FilterName LIKE '%Location%'
)
, salaryCTE AS (
    SELECT l.m_name,
    COUNT(DISTINCT CASE WHEN l.filter_count = 2 THEN l.JP_ID END) AS [Any_two_criteria_used_match(Jobs)], 
    COUNT(DISTINCT CASE WHEN l.filter_count = 2 THEN l.CP_ID END) AS [Any_two_criteria_used_match(Company)],
    COUNT(DISTINCT CASE WHEN l.filter_count = 3 THEN l.JP_ID END) AS [Any_three_criteria_used_match(Jobs)], 
    COUNT(DISTINCT CASE WHEN l.filter_count = 3 THEN l.CP_ID END) AS [Any_three_criteria_used_match(Company)],
    COUNT(DISTINCT CASE WHEN l.filter_count = 4 THEN l.JP_ID END) AS [Any_four_criteria_used_match(Jobs)], 
    COUNT(DISTINCT CASE WHEN l.filter_count = 4 THEN l.CP_ID END) AS [Any_four_criteria_used_match(Company)],
    COUNT(DISTINCT CASE WHEN l.filter_count = 5 THEN l.JP_ID END) AS [Any_five_criteria_used_match(Jobs)], 
    COUNT(DISTINCT CASE WHEN l.filter_count = 5 THEN l.CP_ID END) AS [Any_five_criteria_used_match(Company)]
    FROM locCTE AS l
    INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = l.JP_ID
    WHERE m.FilterName LIKE '%Salary%'
    GROUP BY l.m_name
)
, totalJobCounts AS (
    SELECT CONVERT(DATE, j.PublishDate, 101) AS m_name, 
    COUNT(DISTINCT j.JP_ID) AS [Total_job_Count], COUNT(DISTINCT j.CP_ID) AS [Unique Company Count]
    FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
    LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
    GROUP BY CONVERT(DATE, j.PublishDate, 101)
)

SELECT s.m_name, 
       t.[Total_job_Count], 
       t.[Unique Company Count],
       s.[Any_two_criteria_used_match(Jobs)], 
       s.[Any_two_criteria_used_match(Company)],
       s.[Any_three_criteria_used_match(Jobs)], 
       s.[Any_three_criteria_used_match(Company)],
       s.[Any_four_criteria_used_match(Jobs)], 
       s.[Any_four_criteria_used_match(Company)],
       s.[Any_five_criteria_used_match(Jobs)], 
       s.[Any_five_criteria_used_match(Company)]
FROM salaryCTE s
JOIN totalJobCounts t ON s.m_name = t.m_name;


------------- Set 2 ---------------

WITH jobCTE AS (
	SELECT J.JP_ID, STRING_AGG(CASE WHEN Mandatory IS NULL THEN 0 ELSE Mandatory END, ',') AS Mandatory 
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters M ON J.JP_ID = M.JP_ID
	WHERE j.PublishDate >= '01/22/2024' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
	GROUP BY J.JP_ID
)
, oneCount AS (
SELECT JP_ID, Mandatory, LEN(Mandatory) - LEN(REPLACE(mandatory, '1', '')) AS ones 
FROM jobCTE
--WHERE Mandatory LIKE '%1%'
)
SELECT CONVERT(DATE, j.PublishDate, 101) AS m_name, 
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
ORDER BY m_name


------------------- SET 3 ----------------------------

WITH expCTE AS (
	SELECT 
	(CASE WHEN m.FilterName LIKE '%Exp%' THEN 'Years Of Experience' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Exp%' --AND m.Mandatory = 1 
	GROUP BY m.FilterName
	--'%Exp%' '%Workarea%' '%Skill%' '%Location%' '%Salary%'
	--'%Age%' '%Exp%' '%Sex%'
)
, locCTE AS (
SELECT 
	(CASE WHEN m.FilterName LIKE '%Location%' THEN 'Location' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Location%' 
	GROUP BY m.FilterName
)
, salaryCTE AS (
SELECT 
	(CASE WHEN m.FilterName LIKE '%Salary%' THEN 'Salary' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Salary%' 
	GROUP BY m.FilterName
)
, IndExpCTE AS (
SELECT 
	(CASE WHEN m.FilterName LIKE '%WorkArea%' THEN 'Industry Experience' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Workarea%' 
	GROUP BY m.FilterName
)
, SkillCTE AS (
	SELECT 
	(CASE WHEN m.FilterName LIKE '%Skill%' THEN 'Skill/Expertise' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Skill%' 
	GROUP BY m.FilterName--AND m.Mandatory = 1 
)
SELECT * FROM expCTE
UNION ALL
SELECT * FROM locCTE
UNION ALL
SELECT * FROM salaryCTE
UNION ALL
SELECT * FROM IndExpCTE
UNION ALL
SELECT * FROM SkillCTE


---------------------------------- SET 4 --------------------------------------

WITH ageCTE AS (
	SELECT 
	(CASE WHEN m.FilterName LIKE '%Age%' THEN 'Age' END) AS [Restriction Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Age%' AND m.Mandatory = 1 
	GROUP BY m.FilterName
	--'%Exp%' '%Workarea%' '%Skill%' '%Location%' '%Salary%'
	--'%Age%' '%Exp%' '%Sex%'
)
, genderCTE AS (
SELECT 
	(CASE WHEN m.FilterName LIKE '%Sex%' THEN 'Gender' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Sex%' AND m.Mandatory = 1
	GROUP BY m.FilterName
)
, expCTE AS (
SELECT 
	(CASE WHEN m.FilterName LIKE '%Exp%' THEN 'Years Of Experience' END) AS [Matching Criteria Name], 
	COUNT(DISTINCT j.JP_ID) AS [UsageCount(Jobs)], COUNT(DISTINCT j.CP_ID) AS [Usage_Count(Company)] 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Exp%' AND m.Mandatory = 1
	GROUP BY m.FilterName
)

SELECT * FROM ageCTE
UNION ALL
SELECT * FROM genderCTE
UNION ALL
SELECT * FROM expCTE

SELECT *  FROM 
