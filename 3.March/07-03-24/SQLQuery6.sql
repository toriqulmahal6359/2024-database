WITH jobCTE AS (	SELECT CONVERT(Date,j.PostingDate,101) AS m_name, 	j.JP_ID, j.CP_ID, COUNT(FilterName) AS filter_count	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0	GROUP BY CONVERT(Date,j.PostingDate,101), j.JP_ID, j.CP_ID	--HAVING COUNT(FilterName) = 5	--GROUP BY MONTH(j.PostingDate), j.JP_ID, j.CP_ID), locCTE AS (	SELECT j.JP_ID, j.CP_ID, j.m_name, j.filter_count 	FROM jobCTE AS j	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID	WHERE m.FilterName LIKE '%Location%')--, countCTE AS (--	SELECT CONVERT(DATE, PostingDate, 101), COUNT(DISTINCT JP_ID) AS Jobs, COUNT(DISTINCT CP_ID) AS Company FROM bdjCorporate..DBO_JOBPOSTINGS AS j--	WHERE PostingDate >= '01/22/2024 00:00:00' AND Drafted = 0--	GROUP BY CONVERT(DATE, PostingDate, 101)--), salaryCTE AS (	SELECT l.m_name,--l.filter_count, l.JP_ID , l.CP_ID	COUNT(DISTINCT CASE WHEN l.filter_count = 2 THEN l.JP_ID END) AS [Any_two_criteria_used_match(Jobs)], 	COUNT(DISTINCT CASE WHEN l.filter_count = 2 THEN l.CP_ID END) AS [Any_two_criteria_used_match(Company)],	COUNT(DISTINCT CASE WHEN l.filter_count = 3 THEN l.JP_ID END) AS [Any_three_criteria_used_match(Jobs)], 	COUNT(DISTINCT CASE WHEN l.filter_count = 3 THEN l.CP_ID END) AS [Any_three_criteria_used_match(Company)],	COUNT(DISTINCT CASE WHEN l.filter_count = 4 THEN l.JP_ID END) AS [Any_four_criteria_used_match(Jobs)], 	COUNT(DISTINCT CASE WHEN l.filter_count = 4 THEN l.CP_ID END) AS [Any_four_criteria_used_match(Company)],	COUNT(DISTINCT CASE WHEN l.filter_count = 5 THEN l.JP_ID END) AS [Any_five_criteria_used_match(Jobs)], 	COUNT(DISTINCT CASE WHEN l.filter_count = 5 THEN l.CP_ID END) AS [Any_five_criteria_used_match(Company)]	FROM jobCTE J	LEFT JOIN locCTE AS l ON J.JP_ID = l.JP_ID	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = l.JP_ID	--LEFT JOIN bdjCorporate..DBO_JOBPOSTINGS AS p ON p.JP_ID = J.JP_ID	WHERE m.FilterName LIKE '%Salary%'	GROUP BY l.m_name)SELECT  *FROM salaryCTE WITH jobCTE AS (
	SELECT J.JP_ID, STRING_AGG(CASE WHEN Mandatory IS NULL THEN 0 ELSE Mandatory END, ',') AS Mandatory 
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters M ON J.JP_ID = M.JP_ID
	WHERE j.PostingDate >= '01/22/2024' and j.Drafted = 0
	GROUP BY J.JP_ID
)
, oneCount AS (
SELECT JP_ID, Mandatory, LEN(Mandatory) - LEN(REPLACE(mandatory, '1', '')) AS ones 
FROM jobCTE
--WHERE Mandatory LIKE '%1%'
)
SELECT CONVERT(DATE, j.PostingDate, 101) AS m_name, 
COUNT(DISTINCT o.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company,
COUNT(CASE WHEN o.Mandatory NOT LIKE '%1%' THEN o.JP_ID END) AS [No_criteria_used (jobs)],
COUNT(CASE WHEN o.Mandatory NOT LIKE '%1%' THEN j.CP_ID END) AS [No_criteria_used (Company)],
COUNT(CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 1 THEN o.JP_ID END) AS [any_one_criteria_used_restriction(jobs)],
COUNT(CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 1 THEN j.CP_ID END) AS [any_one_criteria_used_restriction(Company)],
COUNT(CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 2 THEN o.JP_ID END) AS [any_two_criteria_used_restriction(jobs)],
COUNT(CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 2 THEN j.CP_ID END) AS [any_two_criteria_used_restriction(Company)],
COUNT(CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 3 THEN o.JP_ID END) AS [any_three_criteria_used_restriction(jobs)],
COUNT(CASE WHEN o.Mandatory LIKE '%1%' AND o.ones = 3 THEN j.CP_ID END) AS [any_three_criteria_used_restriction(Company)]
FROM oneCount AS o
INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON o.JP_ID = j.JP_ID
--WHERE o.ones = 1
--GROUP BY MONTH(j.PostingDate)
GROUP BY CONVERT(DATE, j.PostingDate, 101)
ORDER BY m_name


WITH jobCTE AS ( 
	SELECT CONVERT(DATE, j.PostingDate, 101) AS m_name, 		j.JP_ID, j.CP_ID		FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID		WHERE PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0		GROUP BY CONVERT(DATE, j.PostingDate, 101), j.JP_ID, j.CP_ID)SELECT j.m_name, COUNT(DISTINCT j.JP_ID), COUNT(DISTINCT CP_ID), COUNT(DISTINCT FilterName) FROM jobCTE  AS jINNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID --WHERE COUNT(DISTINCT FilterName) = 5GROUP BY m_name , locCTE AS (	SELECT j.JP_ID, j.CP_ID, j.m_name, COUNT(FilterName) AS filter_Count	FROM jobCTE AS j	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID	WHERE m.FilterName LIKE '%Location%'	GROUP BY j.m_name)SELECT * FROM locCTE