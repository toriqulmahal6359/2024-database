-- updated user 4141462     5327873 3434119 241028  6467114 2332477 241028

DECLARE 
@UserStatus VARCHAR(5) = '', 
@id INT = 6091277;

WITH RankedPackages AS (
    SELECT TOP 2 c.*, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
           ROW_NUMBER() OVER (ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c
    WHERE c.P_ID = @id 
    ORDER BY c.UpdatedOn DESC
)

SELECT @UserStatus = 
    CASE 
        WHEN (SELECT EndDate FROM RankedPackages WHERE rn = 2) > (SELECT cpkStartDate FROM RankedPackages WHERE rn = 1) THEN 'Updated User'
                ELSE 'New User'
    END
FROM RankedPackages

IF @UserStatus = 'UpdatedUser'
BEGIN
	WITH baseCTE AS (
		SELECT * FROM [mnt]
	
	)

END



DateCTE AS (
    SELECT 
		P_ID,pkId,
		ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
		DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
		DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
	FROM RankedPackages
	CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
),


--boostingCTE AS (
--    SELECT u.P_ID,
--        a.BoostedOn,
--        COUNT(a.BoostedOn) OVER(PARTITION BY a.BoostedOn ORDER BY a.pkId DESC) AS Row_count
--    FROM userTypeCTE AS u 
--    INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = u.P_ID
--    WHERE a.BoostedOn >= u.StartDate AND a.BoostedOn <= u.EndDate
--	--GROUP BY u.P_ID, u.pkId
--)


--SELECT DISTINCT u.*
--	--, b.BoostedOn
--	--, b.Row_count
--    , ((SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = 1 AND u.IsActive = 1 AND BoostedOn >= StartDate) +
--    (SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = (SELECT COUNT(*) FROM RankedPackages WHERE rn = 2) AND u.IsActive = 0 AND BoostedOn >= StartDate AND BoostedOn <= EndDate)) AS Added_boost
--FROM userTypeCTE AS u 
--INNER JOIN boostingCTE AS b ON b.P_ID = u.P_ID;


SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 2332477