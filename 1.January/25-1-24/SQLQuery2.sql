WITH rankCTE AS (
    SELECT
        j.P_ID,
        P_DATE,
        Score,
        u.TExp,
        CASE 
			WHEN j.P_ID IN (3730244, 3845040, 6631527, 6759097, 2515121, 3056408) THEN 1			--3056408 test purpose
			ELSE 0
		END AS pro,
        ROW_NUMBER() OVER (PARTITION BY
			CASE 
				WHEN j.P_ID IN (3730244, 3845040, 6631527, 6759097, 2515121, 3056408) THEN 1		--3056408 test purpose
				ELSE 0			
			END		
        ORDER BY Score DESC, TExp DESC, P_DATE ASC) AS ROW_PRIORITY
    FROM dbo_job_inbox AS j
    INNER JOIN bdjResumes..UserSummary AS u ON j.P_ID = u.P_ID
    WHERE JP_ID = 1220189
)

,scoreCTE AS (
SELECT r.*, --r.P_ID, r.P_DATE, r.Score, r.TExp, r.pro, r.ROW_PRIORITY,
	CASE
		WHEN Score >= 60 THEN 1
		WHEN Score >= 40 AND Score <= 59 THEN 2
		ELSE 3
	END AS SCORE_RANGE
FROM rankCTE AS r
)

SELECT P_ID, P_DATE, Score, TExp, pro 
FROM scoreCTE
ORDER BY
	SCORE_RANGE,
	pro DESC,
	ROW_PRIORITY

