--SELECT TOP 500 * FROM bdjResumes..EXP

WITH jobCTE AS (
	SELECT JP_ID, P_ID, ApplyID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236832 --1236826 --1236811 
)
, curEXP AS (
	SELECT j.P_ID, ex.EFROM AS [Start Date], ex.EPOSITION AS [Current Designation], ex.COMPANY AS [Current Company], ex.DEPT AS [Current Department] FROM jobCTE AS j
	LEFT JOIN bdjResumes..EXP AS ex ON j.P_ID = ex.P_ID
	WHERE ex.ETO LIKE NULL OR ex.ETO = '1900-01-01 00:00:00'
)
, expCTE AS (
	SELECT 
		j.P_ID, 
		ex.EPOSITION, ex.COMPANY, ex.DEPT
		, ex.EFROM, ex.ETO
		, ROW_NUMBER() OVER(PARTITION BY j.P_ID ORDER BY ex.EFROM DESC) AS rn
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..EXP AS ex ON ex.P_ID = j.P_ID
	WHERE ex.ETO NOT LIKE NULL OR ex.ETO <> '1900-01-01 00:00:00'
)
, expCTE1 AS (
	SELECT P_ID, EFROM AS [Starting Date 1], EPOSITION AS [Previous Designation 1], COMPANY AS [Previous Company 1], DEPT AS [Previous Department 1] FROM expCTE WHERE rn = 1 
)
, expCTE2 AS (
	SELECT P_ID, EFROM AS [Starting Date 2], EPOSITION AS [Previous Designation 2], COMPANY AS [Previous Company 2], DEPT AS [Previous Department 2] FROM expCTE WHERE rn = 2
)
, expCTE3 AS (
	SELECT P_ID, EFROM AS [Starting Date 3], EPOSITION AS [Previous Designation 3], COMPANY AS [Previous Company 3], DEPT AS [Previous Department 3] FROM expCTE WHERE rn = 3	
)
, expCTE4 AS (
	SELECT P_ID, EFROM AS [Starting Date 4], EPOSITION AS [Previous Designation 4], COMPANY AS [Previous Company 4], DEPT AS [Previous Department 4] FROM expCTE WHERE rn = 4
)
SELECT DISTINCT
	j.P_ID,
	c.[Start Date], c.[Current Designation], c.[Current Company], c.[Current Department],
	e1.[Starting Date 1], e1.[Previous Designation 1], e1.[Previous Company 1], e1.[Previous Department 1],
	e2.[Starting Date 2], e2.[Previous Designation 2], e2.[Previous Company 2], e2.[Previous Department 2],
	e3.[Starting Date 3], e3.[Previous Designation 3], e3.[Previous Company 3], e3.[Previous Department 3],
	e4.[Starting Date 4], e4.[Previous Designation 4], e4.[Previous Company 4], e4.[Previous Department 4]
FROM jobCTE AS j
LEFT JOIN curEXP AS c ON j.P_ID = c.P_ID
LEFT JOIN expCTE1 AS e1 ON j.P_ID = e1.P_ID
LEFT JOIN expCTE2 AS e2 ON j.P_ID = e2.P_ID
LEFT JOIN expCTE3 AS e3 ON j.P_ID = e3.P_ID
LEFT JOIN expCTE4 AS e4 ON j.P_ID = e4.P_ID


--SELECT DISTINCT
--	c.[Current Designation], c.[Current Company], c.[Current Department],

--	CASE WHEN rn = 1 THEN ex.EPOSITION END AS [Previous Designation 1],
--	CASE WHEN rn = 1 THEN ex.COMPANY END AS [Previous Company 1],
--	CASE WHEN rn = 1 THEN ex.DEPT END AS [Previous Department 1],

--	CASE WHEN rn = 2 THEN ex.EPOSITION END AS [Previous Designation 2],
--	CASE WHEN rn = 2 THEN ex.COMPANY END AS [Previous Company 2],
--	CASE WHEN rn = 2 THEN ex.DEPT END AS [Previous Department 2],

--	CASE WHEN rn = 3 THEN ex.EPOSITION END AS [Previous Designation 3],
--	CASE WHEN rn = 3 THEN ex.COMPANY END AS [Previous Company 3],
--	CASE WHEN rn = 3 THEN ex.DEPT END AS [Previous Department 3],

--	CASE WHEN rn = 4 THEN ex.EPOSITION END AS [Previous Designation 4],
--	CASE WHEN rn = 4 THEN ex.COMPANY END AS [Previous Company 4],
--	CASE WHEN rn = 4 THEN ex.DEPT END AS [Previous Department 4]

--FROM jobCTE AS j
--LEFT JOIN curEXP AS c ON j.P_ID = c.P_ID
--LEFT JOIN expCTE AS ex ON j.P_ID = ex.P_ID













	--CASE WHEN rn = 2 THEN EPOSITION END AS [Previous Designation 2], 
	--CASE WHEN rn = 2 THEN COMPANY END AS [Previous Company 2], 
	--CASE WHEN rn = 2 THEN DEPT END AS [Previous Department 2],

	--CASE WHEN rn = 3 THEN EPOSITION END AS [Previous Designation 3], 
	--CASE WHEN rn = 3 THEN COMPANY END AS [Previous Company 3], 
	--CASE WHEN rn = 3 THEN DEPT END AS [Previous Department 3],

	--CASE WHEN rn = 4 THEN EPOSITION END AS [Previous Designation 4], 
	--CASE WHEN rn = 4 THEN COMPANY END AS [Previous Company 4], 
	--CASE WHEN rn = 4 THEN DEPT END AS [Previous Department 4]