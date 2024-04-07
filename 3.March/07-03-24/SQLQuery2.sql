WITH jobCTE AS (
		SELECT J.JP_ID, STRING_AGG(CASE WHEN Mandatory IS NULL THEN 0 ELSE Mandatory END, ',') AS Mandatory 
		FROM bdjCorporate..DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters M ON J.JP_ID = M.JP_ID
		WHERE j.PostingDate >= '01/22/2024' and j.Drafted = 0
		GROUP BY J.JP_ID
	)
	, oneCount AS (
	SELECT JP_ID, LEN(Mandatory) - LEN(REPLACE(mandatory, '1', '')) AS ones 
	FROM jobCTE
	WHERE Mandatory NOT LIKE '%1%'
	)
	SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT o.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company 
	FROM oneCount AS o
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON o.JP_ID = j.JP_ID
	--WHERE o.ones = 0
	GROUP BY MONTH(j.PostingDate)
	ORDER BY m_name