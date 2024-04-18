WITH jobCTE AS (
	SELECT DISTINCT JP_ID, P_ID, ApplyID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236811
)

SELECT * FROM jobCTE P
INNER JOIN bdjResumes.dbo.Exp AS ex ON P.P_ID = Ex.P_ID
WHERE ex.ETO = '1900-01-01 00:00:00' OR Ex.ETO IS NULL

, expCTE AS (
	SELECT P.P_ID , EX.COMPANY AS [Current Organization], EX.EPOSITION AS [Current Designation], 
	CAST(Ex.EFROM AS varchar(11)) AS [Stating Date at Current Organization], 
	CASE WHEN (CAST(Ex.ETO AS varchar(11)) = '1900-01-01 00:00:00' OR Ex.ETO IS NULL) THEN 'Till' ELSE CAST(Ex.ETO AS varchar(11)) END AS [End Date At Current Organization], 
	SERVE_TILL
	, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
	FROM jobCTE P
	INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID
	WHERE SERVE_TILL = 1
)
, expCTE1 AS (
	SELECT P.P_ID , EX.COMPANY AS PresentOrg, EX.EPOSITION AS PresentPosition, CAST(Ex.EFROM AS varchar(11)) AS EFROM, CASE WHEN (CAST(Ex.ETO AS varchar(11)) = '1900-01-01 00:00:00' OR Ex.ETO IS NULL) THEN 'Till' ELSE CAST(Ex.ETO AS varchar(11)) END AS ETO 
	, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
	INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID
)



, Org_CTE AS (
, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID
WHERE SERVE_TILL = 1
, Ex.BUSINESS, STRING_AGG(S.SkillName, ', ') AS [Work Area]
, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
	INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID


SELECT DISTINCT JP_ID, P_ID, ApplyID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236832