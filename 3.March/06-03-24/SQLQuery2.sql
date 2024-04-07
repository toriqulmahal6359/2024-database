SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%skill%'
WHERE JP_ID = 1234144--276917


SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Location%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%skill%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Exp%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Salary%'
SELECT * FROM bdjCorporate..JobMatchFilters WHERE FilterName LIKE '%Workarea%'  ----not sure

SELECT j.* FROM bdjCorporate..JobMatchFilters AS j
RIGHT JOIN bdjCorporate..DBO_JOBPOSTINGS AS i ON i.JP_ID = j.JP_ID
WHERE j.FilterName LIKE '%Age%' AND j.mandatory = 1
AND i.PostingDate >= '01/22/2024'

SELECT (COUNT(CASE WHEN FilterName LIKE '%Location%' THEN JP_ID END) + COUNT(CASE WHEN FilterName LIKE '%skill%' THEN JP_ID END)) AS total FROM bdjCorporate..JobMatchFilters
GROUP BY JP_ID


SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	AND (m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Age%') AND m.Mandatory = 1
	GROUP BY MONTH(j.PostingDate)


SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	AND (m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Age%' OR m.FilterName LIKE '%sex%') AND m.Mandatory = 1
	GROUP BY MONTH(j.PostingDate)

SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	AND (m.FilterName LIKE '%Exp%' OR m.FilterName LIKE '%Age%' AND m.FilterName LIKE '%sex%') AND m.Mandatory = 1
	GROUP BY MONTH(j.PostingDate)



SELECT MONTH(j.PostingDate) AS m_name, 
	COUNT(DISTINCT j.JP_ID) AS job, COUNT(DISTINCT j.CP_ID) AS company
	FROM bdjCorporate.[dbo].DBO_JOBPOSTINGS AS j
		LEFT JOIN bdjCorporate..JobMatchFilters AS m ON m.JP_ID = j.JP_ID
	WHERE j.PostingDate >= '01/22/2024 00:00:00' AND j.Drafted = 0
	AND (m.FilterName LIKE '%sex%') AND m.Mandatory = 1
	GROUP BY MONTH(j.PostingDate)

