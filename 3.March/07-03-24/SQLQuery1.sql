SELECT TOP 5 * FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS]


SELECT DISTINCT JP_ID FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS]
SELECT DISTINCT CP_ID FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS]

SELECT * FROM bdjCorporate..JobMatchFilters
SELECT * FROM bdjCorporate.[dbo].[JobMatchCount]

-- ====================================INITIAL APPROACH=========================================

WITH jobCTE AS (
	SELECT DISTINCT JP_ID, CP_ID FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS]
)

SELECT m.JP_ID,
COUNT( CASE WHEN m.FilterName LIKE '%Location%' THEN m.JP_ID END ) AS location_count,
COUNT( CASE WHEN m.FilterName LIKE '%Salary%' THEN m.JP_ID END ) AS salary_count,
COUNT( CASE WHEN m.FilterName LIKE '')
--COUNT( ) AS salary_count
FROM jobCTE AS j
INNER JOIN bdjCorporate..JobMatchFilters AS m ON j.JP_ID = m.JP_ID 
GROUP BY m.JP_ID
WHERE m.Mandatory = 1

-- ================================== TESTING PURPOSE =======================================

SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Location%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%skill%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Exp%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Salary%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Workarea%'  ----not sure

SELECT (COUNT(CASE WHEN FilterName LIKE '%Location%' THEN JP_ID END) + COUNT(CASE WHEN FilterName LIKE '%salary%' THEN JP_ID END)) AS total FROM bdjCorporate..JobMatchFilters
GROUP BY JP_ID

WITH jobCTE AS (
	SELECT DISTINCT JP_ID FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS]
)

SELECT * FROM jobCTE AS j
LEFT JOIN bdjCorporate..JobMatchFilters AS m 


-- ======================================EFFECTIVE CODE============================================

WITH jobCTE AS (
	SELECT MONTH(j.PostingDate) AS m_name, 
	j.JP_ID, j.CP_ID, COUNT(FilterName) AS filter_count
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	GROUP BY MONTH(j.PostingDate), j.JP_ID, j.CP_ID
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

SELECT * FROM salaryCTE

SELECT * FROM bdjCorporate..JobMatchFilters WHERE m.FilterName LIKE '%Location%'


-- ==============================================COUNT of Strategy Uses============================================
WITH countCTE AS (
	SELECT COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Skill%' 
	--'%Exp%' '%Workarea%' '%Skill%' '%Location%' '%Salary%'
)
SELECT * FROM countCTE


-- ======================================EFFECTIVE CODE============================================


-- ================================================= CASE CODE ==============================================
WITH jobCTE AS (
	SELECT MONTH(j.PostingDate) AS m_name, 
	j.JP_ID, j.CP_ID
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	GROUP BY MONTH(j.PostingDate), j.JP_ID, j.CP_ID
	HAVING COUNT(FilterName) = 1
	--GROUP BY MONTH(j.PostingDate), j.JP_ID, j.CP_ID
)
, ageCTE AS (
	SELECT j.m_name, COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company FROM jobCTE AS j
	INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE m.FilterName LIKE '%Age%' AND j.
	GROUP BY j.m_name
)
SELECT * FROM ageCTE

, salaryCTE AS (
	SELECT l.m_name, COUNT(DISTINCT l.JP_ID) AS job, COUNT(DISTINCT l.CP_ID) AS company FROM locCTE AS l
	INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = l.JP_ID
	WHERE m.FilterName LIKE '%Salary%'
	GROUP BY l.m_name
)

SELECT * FROM salaryCTE 

SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Age%' AND mandatory = 1

SELECT DISTINCT MONTH(j.PostingDate) AS m_name, 
	j.JP_ID, j.CP_ID 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	AND (m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Age%' OR m.FilterName LIKE '%sex%') AND m.Mandatory = 1
	--GROUP BY MONTH(j.PostingDate)


WITH jobCTE AS (
	SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(j.JP_ID) AS job, COUNT(j.CP_ID) AS company
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	GROUP BY MONTH(j.PostingDate)
	HAVING COUNT(FilterName) = 2
)

SELECT j.m_name, COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company FROM jobCTE AS j
INNER JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
WHERE (m.FilterName LIKE '%Age%' OR m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Sex%')
GROUP BY m_name;

-- ================================================= CASE CODE ==============================================


WITH countCTE AS (
	SELECT COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND j.Drafted = 0 AND m.FilterName LIKE '%Exp%' AND m.Mandatory = 1
	--'%Exp%' '%Workarea%' '%Skill%' '%Location%' '%Salary%'
	-- '%Age%' '%Exp%' '%Sex%'
)
SELECT * FROM countCTE

SELECT DISTINCT MONTH(j.PostingDate) AS m_name, 
	j.JP_ID, j.CP_ID 
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	AND m.Mandatory = 1

	with a as (
	SELECT JP_ID, STRING_AGG(Case when Mandatory is null then 0 else Mandatory end,',') aa  FROM bdjCorporate..JobMatchFilters 
	Group by JP_ID
	)
	select JP_ID, aa 
	from a
	Where  aa like '%1%' 
	--WHERE Mandatory = 1

	select * from bdjCorporate..JobMatchFilters 
	where jp_id =
	853069--604947

--- Just How can I Go Forward

	with a as (
	SELECT JP_ID, STRING_AGG(Case when Mandatory is null then 0 else Mandatory end,',') aa  FROM bdjCorporate..JobMatchFilters 
	Group by JP_ID
	)
	select JP_ID, LEN(aa) - LEN(REPLACE(aa, '1', '')) AS countOfOne 
	from a
	Where  aa like '%1%'
	
------------------------------------------------------ CRITERIA RESTRICTION ----------------------------------------

-- ==========================GOOD APPROACH=============================

	WITH jobCTE AS (
		SELECT JP_ID, STRING_AGG(CASE WHEN Mandatory IS NULL THEN 0 ELSE Mandatory END, ',') AS Mandatory FROM bdjCorporate..JobMatchFilters GROUP BY JP_ID
	)
	, oneCount AS (
	SELECT JP_ID, LEN(Mandatory) - LEN(REPLACE(mandatory, '1', '')) AS ones FROM jobCTE
	WHERE Mandatory LIKE '%1%'
	)
	SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT o.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company 
	FROM oneCount AS o
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON o.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024' AND o.ones = 3
	GROUP BY MONTH(j.PostingDate)

--=======================PERFECT APPROACH========================

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
	WHERE Mandatory LIKE '%1%'
	)
	SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT o.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company 
	FROM oneCount AS o
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON o.JP_ID = j.JP_ID
	WHERE o.ones = 1
	GROUP BY MONTH(j.PostingDate)
	ORDER BY m_name

------ Not mandatory Lists----------

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

--------- Total UNIQUE Job and Company Count -------------------------

	SELECT CONVERT(DATE, j.PostingDate, 101) AS date, 
	COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	GROUP BY CONVERT(DATE, j.PostingDate, 101)
	ORDER BY date

