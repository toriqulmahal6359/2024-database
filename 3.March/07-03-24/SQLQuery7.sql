WITH jobCTE AS (
	SELECT CONVERT(DATE, j.PostingDate, 101) AS m_name, 
	j.JP_ID, j.CP_ID, COUNT(FilterName) AS filter_count
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	GROUP BY CONVERT(DATE, j.PostingDate, 101), j.JP_ID, j.CP_ID
	--HAVING COUNT(FilterName) = 5
	--GROUP BY MONTH(j.PostingDate), j.JP_ID, j.CP_ID
)
, locCTE AS (
	SELECT j.JP_ID, j.CP_ID, j.m_name, j.filter_count FROM jobCTE AS j
	INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE m.FilterName LIKE '%Location%'
)
, salaryCTE AS (
	SELECT l.m_name,
	NULL AS [Total_job_Count],
	NULL AS [Unique Company Count],
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
--SELECT * FROM salaryCTE
, totalJobCounts AS (
SELECT CONVERT(DATE, j.PostingDate, 101) AS m_name, 
	COUNT(DISTINCT j.JP_ID) AS [Total_job_Count], COUNT(DISTINCT j.CP_ID) AS [Unique Company Count]
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	GROUP BY CONVERT(DATE, j.PostingDate, 101)
	--ORDER BY m_name
)
SELECT m_name, 
       [Total_job_Count], 
       [Unique Company Count],
       [Any_two_criteria_used_match(Jobs)], 
       [Any_two_criteria_used_match(Company)],
       [Any_three_criteria_used_match(Jobs)], 
       [Any_three_criteria_used_match(Company)],
       [Any_four_criteria_used_match(Jobs)], 
       [Any_four_criteria_used_match(Company)],
       [Any_five_criteria_used_match(Jobs)], 
       [Any_five_criteria_used_match(Company)]
FROM salaryCTE

UNION

SELECT m_name, 
       [Total_job_Count], 
       [Unique Company Count],
       NULL AS [Any_two_criteria_used_match(Jobs)], 
       NULL AS [Any_two_criteria_used_match(Company)],
       NULL AS [Any_three_criteria_used_match(Jobs)], 
       NULL AS [Any_three_criteria_used_match(Company)],
       NULL AS [Any_four_criteria_used_match(Jobs)], 
       NULL AS [Any_four_criteria_used_match(Company)],
       NULL AS [Any_five_criteria_used_match(Jobs)], 
       NULL AS [Any_five_criteria_used_match(Company)]
FROM totalJobCounts

ORDER BY m_name;


SELECT CONVERT(DATE, j.PostingDate, 101) AS m_name, 
    COUNT(DISTINCT j.JP_ID) AS [Total_job_Count], COUNT(DISTINCT j.CP_ID) AS [Unique Company Count]
    FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
    LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
    WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
    GROUP BY CONVERT(DATE, j.PostingDate, 101)