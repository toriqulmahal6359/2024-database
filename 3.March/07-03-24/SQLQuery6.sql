WITH jobCTE AS (
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
	SELECT CONVERT(DATE, j.PostingDate, 101) AS m_name, 