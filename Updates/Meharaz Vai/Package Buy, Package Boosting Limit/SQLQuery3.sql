SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
c.IsActive, C.UpdatedOn, COUNT(a.BoostedOn) OVER(PARTITION BY c.UpdatedOn ORDER BY cpkStartDate) AS Boost_used
-- ROW_NUMBER() OVER(PARTITION BY c.UpdatedOn ORDER BY cpkStartDate) AS row_count
FROM [mnt].[CandidatePackages] AS c
LEFT JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = c.P_ID AND a.pkId = c.pkId
WHERE c.P_ID = 2332477    -- 2332477  4141462 5327873
GROUP BY --DATEPART(MONTH, a.BoostedOn)
a.BoostedOn, c.P_ID, c.pkId, c.cpkStartDate, c.cpkDuration, c.IsActive, c.UpdatedOn, a.BoostedOn
ORDER BY c.UpdatedOn


SELECT COUNT(d.BoostedOn) FROM mnt.ApplicationBoostingDetails AS d
WHERE d.P_ID = 2332477
--GROUP BY DATEPART(MONTH, d.BoostedOn)
GROUP BY MONTH(d.BoostedOn)

SELECT * FROM [mnt].[CandidatePackages] AS c WHERE c.P_ID = 4141462

DECLARE 
	@id INT = 2332477; -- updated user
	--@id INT = 5327873; -- updated user
	--@id INT = 4141462; -- new user
WITH DurationPackages AS (
	SELECT TOP 2 c.*, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
	r = ROW_NUMBER() OVER(ORDER BY c.UpdatedOn DESC)
	FROM [mnt].[CandidatePackages] AS c WHERE c.P_ID = @id ORDER BY c.UpdatedOn DESC
)
SELECT *, (SELECT EndDate FROM DurationPackages WHERE r = 2) AS prev_endDate
FROM DurationPackages WHERE 
	(SELECT EndDate FROM DurationPackages WHERE r = 2) IS NULL 
	OR EndDate > (SELECT EndDate FROM DurationPackages WHERE r = 2);


-- updated user 4141462   2332477  5327873 3434119 241028  6467114 2332477 241028
GO

DECLARE @id INT = 241028;
		--@StartDate DATE = '2023-11-28',
		--@EndDate DATE = '2024-02-29'; 

WITH RankedPackages AS (
    SELECT TOP 2 c.*, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
           ROW_NUMBER() OVER (ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c 
    WHERE c.P_ID = @id 
    ORDER BY c.UpdatedOn DESC
)
, userTypeCTE AS (
	SELECT *,
		CASE 
			WHEN --(SELECT EndDate FROM RankedPackages WHERE rn = 2) IS NULL OR 
				  (SELECT EndDate FROM RankedPackages WHERE rn = 2) > (SELECT cpkStartDate FROM RankedPackages WHERE rn = 1) THEN 'Updated User'
				  ELSE 'New User'
		END AS UserType
	FROM RankedPackages
)
--, boostingCTE AS (
--	SELECT  u.* FROM userTypeCTE AS u
--	INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = u.P_ID
--	--GROUP BY u.cpkId, u.cpkAmount, u.cpkDiscount, u.cpkDiscount, u.cpkDuration, u.cpkStartDate 
--	--,u.EndDate, u.IsActive, u.IsActive, u.OPID, u.P_ID, u.pkId, u.UpdatedOn, u.UserType, u.rn
--)
, boostingCTE AS (
	--SELECT P_ID, COUNT(u.BoostedOn) AS Boost_used FROM mnt.ApplicationBoostingDetails AS u WHERE u.P_ID = @id GROUP BY DATEPART(MONTH, u.BoostedOn), P_ID
	SELECT u.P_ID, COUNT(a.BoostedOn) AS Used_boost FROM userTypeCTE AS u 
	INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = u.P_ID
	WHERE a.BoostedOn >= u.cpkStartDate AND a.BoostedOn <= u.EndDate
	GROUP BY u.P_ID
)

SELECT DISTINCT u.*,
b.Used_boost
FROM userTypeCTE AS u 
INNER JOIN boostingCTE AS b ON b.P_ID = u.P_ID
--GROUP BY u.cpkId, u.cpkAmount, u.cpkDiscount, u.cpkDiscount, u.cpkDuration, u.cpkStartDate 
--, u.EndDate, u.IsActive, u.IsActive, u.OPID, u.P_ID, u.pkId, u.UpdatedOn, u.UserType, u.rn, b.Boost_used

--WHERE rn = 1;

SELECT  * FROM [mnt].[CandidatePackages] WHERE P_ID = 6467114
SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 6467114
SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 241028



DECLARE @id INT = 241028; -- updated user 4141462   2332477  5327873 3434119 241028  6467114 2332477 241028

WITH RankedPackages AS (
    SELECT TOP 2 c.*, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
           ROW_NUMBER() OVER (PARTITION BY c.P_ID ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c 
    -- WHERE c.P_ID = @id -- Remove this filter to get data for all users
    ORDER BY c.P_ID, c.UpdatedOn DESC
)
, userTypeCTE AS (
	SELECT *,
		CASE 
			WHEN (SELECT EndDate FROM RankedPackages WHERE rn = 2 AND P_ID = c.P_ID) IS NULL OR 
				 (SELECT EndDate FROM RankedPackages WHERE rn = 1 AND P_ID = c.P_ID) > c.cpkStartDate THEN 'Updated User'
			ELSE 'New User'
		END AS UserType
	FROM RankedPackages AS c
)
, boostingCTE AS (
    SELECT P_ID, BoostedOn
    FROM mnt.ApplicationBoostingDetails
    -- WHERE P_ID = @id -- If you want to filter by a specific user
)

SELECT DISTINCT u.*,
	b.Boost_used
FROM userTypeCTE AS u 
LEFT JOIN (
    SELECT P_ID, COUNT(*) AS Boost_used 
    FROM boostingCTE 
    GROUP BY P_ID
) AS b ON b.P_ID = u.P_ID;




GO

-- updated user 4141462   2332477  5327873 3434119 241028  6467114 2332477 241028
DECLARE @id INT = 241028;

WITH RankedPackages AS (
    SELECT TOP 2 c.*, 
           ROW_NUMBER() OVER (ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c
    WHERE c.P_ID = @id 
    ORDER BY c.UpdatedOn DESC
)
, DateCTE AS (
	SELECT r.*,
	DATEADD(MONTH, number, r.cpkStartDate) AS StartDate,
	DATEADD(MONTH, number + 1, r.cpkStartDate) AS EndDate FROM RankedPackages AS r
	INNER JOIN master..spt_values ON type = 'P' AND r.cpkDuration > number
)
, userTypeCTE AS (
	SELECT *,
		CASE 
			WHEN (SELECT EndDate FROM RankedPackages WHERE rn = 2) > (SELECT cpkStartDate FROM RankedPackages WHERE rn = 1) THEN 'Updated User'
				  ELSE 'New User'
		END AS UserType
	FROM DateCTE
)

, boostingCTE AS (
	SELECT u.P_ID,
	--COUNT(a.BoostedOn) AS Used_boost,
	a.BoostedOn,
	ROW_NUMBER() OVER(PARTITION BY u.pkId ORDER BY a.BoostedOn) AS Row_count
	FROM userTypeCTE AS u 
	INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = u.P_ID
	WHERE a.BoostedOn >= u.StartDate AND a.BoostedOn <= u.EndDate
	--GROUP BY u.P_ID, u.pkId, a.BoostedOn
)

SELECT DISTINCT u.*,
--b.Used_boost,
((SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = 10 AND u.IsActive = 1 AND 
BoostedOn >= StartDate AND BoostedOn <= EndDate) + (SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_Count = 1 AND BoostedOn >= StartDate AND BoostedOn <= EndDate)) AS Added_boost
,b.BoostedOn
,b.Row_count
FROM userTypeCTE AS u 
INNER JOIN boostingCTE AS b ON b.P_ID = u.P_ID



DECLARE @id INT = 241028;

WITH RankedPackages AS (
    SELECT TOP 2 c.*, 
           ROW_NUMBER() OVER (ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c
    WHERE c.P_ID = @id 
    ORDER BY c.UpdatedOn DESC
),
DateCTE AS (
    SELECT r.*,
        DATEADD(MONTH, number, r.cpkStartDate) AS StartDate,
        DATEADD(MONTH, number + 1, r.cpkStartDate) AS EndDate 
    FROM RankedPackages AS r
    INNER JOIN master..spt_values ON type = 'P' AND r.cpkDuration > number
),
userTypeCTE AS (
    SELECT *,
        CASE 
            WHEN (SELECT EndDate FROM RankedPackages WHERE rn = 2) > (SELECT cpkStartDate FROM RankedPackages WHERE rn = 1) THEN 'Updated User'
                  ELSE 'New User'
        END AS UserType
    FROM DateCTE
),
boostingCTE AS (
    SELECT u.P_ID,
        a.BoostedOn,
        COUNT(a.BoostedOn) OVER(PARTITION BY a.BoostedOn ORDER BY a.pkId DESC) AS Row_count
    FROM userTypeCTE AS u 
    INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = u.P_ID
    WHERE a.BoostedOn >= u.StartDate AND a.BoostedOn <= u.EndDate
	--GROUP BY u.P_ID, u.pkId
)

SELECT DISTINCT u.*
	--, b.BoostedOn
	, b.Row_count
    , ((SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = 1 AND u.IsActive = 1 AND BoostedOn >= StartDate AND BoostedOn <= EndDate) +
    (SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = (SELECT COUNT(*) FROM RankedPackages WHERE rn = 2) AND u.IsActive = 0 AND BoostedOn >= StartDate AND BoostedOn <= EndDate)) AS Added_boost
FROM userTypeCTE AS u 
INNER JOIN boostingCTE AS b ON b.P_ID = u.P_ID;



DECLARE @id INT = 241028;

WITH RankedPackages AS (
    SELECT TOP 2 c.*, 
           ROW_NUMBER() OVER (ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c
    WHERE c.P_ID = @id 
    ORDER BY c.UpdatedOn DESC
),
DateCTE AS (
    SELECT r.*,
        DATEADD(MONTH, number, r.cpkStartDate) AS StartDate,
        DATEADD(MONTH, number + 1, r.cpkStartDate) AS EndDate 
    FROM RankedPackages AS r
    INNER JOIN master..spt_values ON type = 'P' AND r.cpkDuration > number
),
userTypeCTE AS (
    SELECT *,
        CASE 
            WHEN (SELECT EndDate FROM RankedPackages WHERE rn = 2) > (SELECT cpkStartDate FROM RankedPackages WHERE rn = 1) THEN 'Updated User'
                  ELSE 'New User'
        END AS UserType
    FROM DateCTE
),
boostingCTE AS (
    SELECT u.P_ID,
        a.BoostedOn,
        COUNT(a.BoostedOn) OVER(PARTITION BY u.pkId ORDER BY a.BoostedOn) AS Row_count
    FROM userTypeCTE AS u 
    INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = u.P_ID
    WHERE a.BoostedOn >= u.StartDate AND a.BoostedOn <= u.EndDate
)

SELECT DISTINCT u.*,
    ((SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = (SELECT COUNT(*) FROM RankedPackages WHERE rn = 2) AND u.IsActive = 0 AND BoostedOn >= StartDate AND BoostedOn <= EndDate) +
    (SELECT COUNT(BoostedOn) FROM boostingCTE WHERE Row_count = 1 AND u.IsActive = 1 AND BoostedOn >= StartDate AND BoostedOn <= EndDate)) AS Added_boost
FROM userTypeCTE AS u 
INNER JOIN boostingCTE AS b ON b.P_ID = u.P_ID;






SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 241028 --241028     2332477



