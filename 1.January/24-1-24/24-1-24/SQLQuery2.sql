select j.P_ID,P_DATE,Score,u.texp,case when j.P_ID in(3730244,3845040,6631527,6759097,2515121) then 1 else 0 end pro
from dbo_job_inbox j
INNER JOIN bdjResumes..UserSummary u on j.P_ID = u.P_ID
where JP_ID = 1220189 


SELECT 
	j.P_ID,
	j.P_DATE,
	j.Score,
	u.texp,
CASE 
	WHEN j.P_ID in(3730244,3845040,6631527,6759097,2515121) THEN 1 ELSE 0 END AS pro

FROM dbo_job_inbox AS j
INNER JOIN bdjResumes..UserSummary u ON j.P_ID = u.P_ID
WHERE j.JP_ID = 1220189


SELECT 
	j.P_ID, 
	j.P_DATE,
	j.Score,
	u.tExp,
	CASE
		WHEN j.P_ID IN(3730244,3845040,6631527,6759097,2515121) 
		THEN 1
		ELSE 0
	END AS pro
	FROM [dbo].[DBO_JOB_INBOX] AS j
	INNER JOIN bdjResumes..UserSummary u ON j.P_ID = u.P_ID
	WHERE j.JP_ID = 1220189 AND (j.Score >= 60 AND j.Score <= 100) OR (j.Score >= 40 AND j.Score <= 59) OR (j.Score >= 0 AND j.Score <= 39)
	ORDER BY j.Score, pro DESC

GO




SELECT 
	j.P_ID, 
	j.P_DATE,
	j.Score,
	CASE
		WHEN j.P_ID IN(3730244,3845040,6631527,6759097,2515121) 
		THEN 1
		ELSE 0
	END AS pro
	FROM [dbo].[DBO_JOB_INBOX] AS j
	INNER JOIN bdjResumes..UserSummary u ON j.P_ID = u.P_ID
	WHERE j.JP_ID = 1220189 --AND (j.Score >= 60 AND j.Score <= 100) OR (j.Score >= 40 AND j.Score <= 59) OR (j.Score >= 0 AND j.Score <= 39)
	ORDER BY j.Score, pro DESC

WITH BaseCTE AS (
	SELECT 
	j.P_ID, 
	j.P_DATE,
	j.Score,
	CASE
		WHEN j.P_ID IN(3730244,3845040,6631527,6759097,2515121) THEN 1
		ELSE 0
	END AS pro
	FROM [dbo].[DBO_JOB_INBOX] AS j
	INNER JOIN bdjResumes..UserSummary u ON j.P_ID = u.P_ID
	WHERE j.JP_ID = 1220189
)
,firstCTE AS (
	SELECT b.* FROM BaseCTE AS b
	WHERE b.Score >= 60 AND b.Score <= 100
	ORDER BY j.pro DESC
)

SELECT * FROM firstCTE
, secondCTE AS (
	SELECT b.* FROM BaseCTE AS b
	WHERE b.Score >= 40 AND b.Score <= 59
	ORDER BY b.Score DESC
)
,thirdCTE AS (
	SELECT b.* FROM BaseCTE AS b
	WHERE b.Score >= 0 AND b.Score <= 39
	ORDER BY b.Score DESC
)

SELECT f.* 
	FROM firstCTE AS f
	INNER JOIN secondCTE AS s ON s.P_ID = f.P_ID
	INNER JOIN thirdCTE AS t ON t.P_ID = f.P_ID
	ORDER BY f.pro DESC

SELECT 
  j.P_ID,
  P_DATE,
  Score,
  u.texp,
  CASE 
    WHEN j.P_ID IN (3730244, 3845040, 6631527, 6759097, 2515121) THEN 1 
    ELSE 0 
  END AS pro
FROM dbo_job_inbox AS j
INNER JOIN bdjResumes..UserSummary u ON j.P_ID = u.P_ID
WHERE 
  JP_ID = 1220189
  AND (
    (Score >= 60 AND Score <= 100)
    OR (Score >= 40 AND Score <= 59 )
    OR (Score >= 0 AND Score <= 39)
  )
ORDER BY Score DESC, P_DATE;

WITH BaseCTE AS (
	SELECT j.P_ID,P_DATE,Score,u.TExp,
		CASE 
			WHEN j.P_ID IN(3730244,3845040,6631527,6759097,2515121) THEN 1 ELSE 0 
		END AS pro
	FROM dbo_job_inbox AS j
	INNER JOIN bdjResumes..UserSummary u ON j.P_ID = u.P_ID
	WHERE JP_ID = 1220189
)

SELECT b.* ,
	ROW_NUMBER() OVER(PARTITION BY b.Score, b.pro ORDER BY b.pro ASC, b.Score DESC, b.TExp DESC, b.P_Date ASC) 
FROM BaseCTE AS b

GO

WITH RankedData AS (
    SELECT
        j.P_ID,
        P_DATE,
        Score,
        u.texp,
        CASE 
			WHEN j.P_ID IN (3730244, 3845040, 6631527, 6759097, 2515121, 3056408) THEN 1				--3056408 test purpose
			ELSE 0
		END AS pro,
        ROW_NUMBER() OVER (PARTITION BY
			CASE 
				WHEN j.P_ID IN (3730244, 3845040, 6631527, 6759097, 2515121, 3056408) THEN 1		--3056408 test purpose
				ELSE 0			
			END		
        ORDER BY Score DESC, texp DESC, P_DATE ASC) AS ROW_PRIORITY
    FROM dbo_job_inbox AS j
    INNER JOIN bdjResumes..UserSummary AS u ON j.P_ID = u.P_ID
    WHERE JP_ID = 1220189
)
SELECT r.*
FROM RankedData AS r
ORDER BY
    CASE
        WHEN r.Score >= 60 THEN 1
        WHEN r.Score >= 40 AND r.Score <= 59 THEN 2
        ELSE 3
    END,
r.pro DESC,
r.ROW_PRIORITY;
--SELECT P_ID, P_DATE, Score, texp, pro
--FROM RankedData
--ORDER BY
--    CASE
--        WHEN Score >= 60 THEN 1
--        WHEN Score >= 40 AND Score <= 59 THEN 2
--        ELSE 3
--    END,
--pro DESC,
--ROW_PRIORITY;





