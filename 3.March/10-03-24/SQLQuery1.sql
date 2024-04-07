------ Set 1 -----

WITH jobCTE AS (
    SELECT DISTINCT CONVERT(DATE, j.PublishDate, 101) AS m_name, 
    j.JP_ID, j.CP_ID, COUNT(DISTINCT FilterName) AS filter_count
    FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
    LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
    GROUP BY CONVERT(DATE, j.PublishDate, 101), j.JP_ID, j.CP_ID
)
, locCTE AS (
    SELECT j.JP_ID, j.CP_ID, j.m_name, j.filter_count 
    FROM jobCTE AS j
    INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    --WHERE m.FilterName LIKE '%Location%'
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
	WHERE m.FilterName LIKE '%Salary%' OR m.FilterName LIKE '%Skill%' OR m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%WorkArea%'
    --WHERE m.FilterName LIKE '%Salary%'
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

----------- SET 1 -----------

WITH jobCTE AS (
    SELECT CONVERT(DATE, j.PublishDate, 101) AS m_name, 
    j.JP_ID, j.CP_ID, COUNT(DISTINCT FilterName) AS filter_count
    FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
    LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE j.PublishDate >= '01/22/2024 00:00:00' and j.Drafted = 0 AND j.OnlineJob = 1 AND j.Verified = 1
    GROUP BY CONVERT(DATE, j.PublishDate, 101), j.JP_ID, j.CP_ID
	HAVING COUNT(DISTINCT FilterName) = 3
)
, locCTE AS (
    SELECT j.JP_ID, j.CP_ID, j.m_name, j.filter_count 
    FROM jobCTE AS j
    INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE m.FilterName LIKE '%Location%'
)
, salaryCTE AS (
	SELECT j.JP_ID, j.CP_ID, j.m_name, j.filter_count 
    FROM jobCTE AS j
    INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE m.FilterName LIKE '%Salary%'
)

SELECT COUNT(DISTINCT j.JP_ID) [Job Count], COUNT(DISTINCT j.CP_ID) [Company Count], j.m_name
    FROM salaryCTE AS j
    INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Skill%' OR m.FilterName LIKE '%WorkArea%'
	GROUP BY j.m_name

SELECT * FROM locCTE

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


SELECT DISTINCT FilterName FROM bdjCorporate..JobMatchFilters