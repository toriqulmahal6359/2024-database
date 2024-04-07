select  top 5* from [mnt].[CandidatePackages] where isactive = 1
select top 5 * from UserApplyLimit where p_id=2332477

select * from mnt.CandidatePackages where p_id=2332477
select * from mnt.ApplicationBoostingDetails where p_id=2332477

select * from mnt.CandidatePackages where p_id=241028

select * from mnt.ApplicationBoostingDetails where p_id=241028

select * from mnt.CandidatePackages where p_id=2296339

select  top 5* from [mnt].[CandidatePackages] where isactive = 1
select top 5 * from UserApplyLimit where p_id=2296339

select * from mnt.ApplicationBoostingDetails where p_id=2296339
select top 5 * from UserApplyLimit where p_id=2332477


DECLARE 
	@id INT = 2332477;
	--@id INT = 241028;
	--@id INT = 2296339;

SELECT COUNT(1) AS [Used_Boost], l.ApplicationBoostingLimit FROM mnt.CandidatePackages AS p
LEFT JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = p.P_ID
INNER JOIN UserApplyLimit AS l ON l.P_ID = p.P_ID
WHERE p.IsActive = 1 AND p.P_ID = @id
--AND l.ApplicationBoostingLimit IS NOT NULL
GROUP BY l.ApplicationBoostingLimit


SELECT TOP 5 * from mnt.CandidatePackages --where p_id=241028

DECLARE 
	--@id INT = 2332477;
	@id INT = 241028;
	--@id INT = 2296339;

SELECT DATEADD(MONTH, p.cpkDuration, p.cpkStartDate) AS EndDate FROM mnt.CandidatePackages AS p
LEFT JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = p.P_ID
INNER JOIN UserApplyLimit AS l ON l.P_ID = p.P_ID
WHERE p.P_ID = @id
GROUP BY MONTH(EndDate)
--AND l.ApplicationBoostingLimit IS NOT NULL
--GROUP BY l.ApplicationBoostingLimit

SELECT * FROM mnt.CandidatePackages
SELECT * from mnt.CandidatePackages where p_id=241028

SELECT cpkStartDate, 
	DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate, 
	--COUNT(1) AS count,
	ROW_NUMBER() OVER(PARTITION BY p.pkId ORDER BY p.UpdatedOn DESC) AS SERIAL
	FROM mnt.CandidatePackages AS p
RIGHT JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = p.P_ID
WHERE p.P_ID = 241028
GROUP BY DATEDIFF(MONTH, cpkStartDate, DATEADD(MONTH, cpkDuration, cpkStartDate)), cpkDuration, cpkStartDate, p.pkId, p.UpdatedOn

SELECT * FROM mnt.CandidatePackages
SELECT * FROM mnt.ApplicationBoostingDetails
select * from UserApplyLimit

SELECT *, DATEADD(MONTH, cpkDuration, cpkStartDate) AS Enddate FROM mnt.CandidatePackages

SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate, c.cpkDuration, c.IsActive,
l.MonthNo, l.ApplicationBoostingLimit, d.BoostedOn 
FROM mnt.CandidatePackages AS c
LEFT JOIN UserApplyLimit AS l ON l.P_ID =  c.P_ID
INNER JOIN mnt.ApplicationBoostingDetails AS d ON d.P_ID = c.P_ID AND d.pkId = c.pkId
GROUP BY 

GO

DECLARE 
	--@id INT = 2332477;
	@id INT = 241028;
	--@id INT = 2296339;

WITH baseCTE AS (
	SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate, c.IsActive, u.ApplicationBoostingLimit 
	 FROM mnt.CandidatePackages AS c
	LEFT JOIN UserApplyLimit AS u ON u.P_ID = c.P_ID
	--GROUP BY u.MonthNo
) 
, boostCTE AS (
	SELECT d.P_ID,
		COUNT(d.BoostedOn) AS Boost_Count,
		r = ROW_NUMBER() OVER(PARTITION BY d.P_ID ORDER BY d.BoostedOn DESC)
	FROM mnt.ApplicationBoostingDetails AS d
	GROUP BY DATEPART(MONTH, d.BoostedOn), d.P_ID, d.BoostedOn
)

SELECT b.*, c.Boost_Count FROM baseCTE AS b
INNER JOIN boostCTE AS c ON c.P_ID = b.P_ID
WHERE r < 2 AND b.IsActive <> 1 AND c.P_ID = @id
--GROUP BY b.P_ID, b.pkId, b.cpkStartDate, b.EndDate, b.IsActive

SELECT * FROM UserApplyLimit WHERE P_ID = 241028
SELECT * FROM mnt.CandidatePackages WHERE P_ID = 241028
SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 241028

DECLARE 
	--@id INT = 2332477;
	@id INT = 241028;
	--@id INT = 2296339;

SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate, c.IsActive--, u.ApplicationBoostingLimit 
	 FROM mnt.CandidatePackages AS c
LEFT JOIN UserApplyLimit AS u ON u.P_ID = c.P_ID
WHERE c.P_ID = @id

SELECT * FROM mnt.CandidatePackages WHERE P_ID = 241028
SELECT * FROM UserApplyLimit WHERE P_ID = 241028


DECLARE 
	--@id INT = 2332477;
	@id INT = 241028;
	--@id INT = 2296339;

SELECT DISTINCT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate, c.cpkDuration, c.UpdatedOn
		, u.StartDate, u.EndDate, u.ApplicationBoostingLimit, d.BoostedOn
	 FROM mnt.CandidatePackages AS c
LEFT JOIN UserApplyLimit AS u ON u.P_ID = c.P_ID
INNER JOIN mnt.ApplicationBoostingDetails AS d ON d.P_ID = c.P_ID
WHERE c.P_ID = @id

select  * from [mnt].[CandidatePackages] where p_id=2332477
select top 5 * from UserApplyLimit where p_id=2332477

select * from mnt.ApplicationBoostingDetails where p_id=2332477 

GO

DECLARE 
	--@id INT = 2332477;
	  @id INT = 241028;
	--@id INT = 2296339;

WITH baseCTE AS (
	SELECT DISTINCT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
	--r = ROW_NUMBER() OVER(PARTITION BY c.cpkStartDate ORDER BY c.cpkStartDate),
	--COUNT(d.BoostedOn) AS Boost_Count,
	c.IsActive, c.UpdatedOn 
	, u.ApplicationBoostingLimit
	FROM [mnt].[CandidatePackages] AS c
	INNER JOIN UserApplyLimit AS u ON u.pkId = c.pkId 
	WHERE c.P_ID=241028 --AND u.ApplicationBoostingLimit IS NOT NULL
	--GROUP BY c.P_ID, c.pkId, c.cpkStartDate, c.cpkDuration, c.IsActive, c.UpdatedOn
)

, CountCTE AS (
	SELECT P_ID, COUNT(u.BoostedOn) AS Boost_Count FROM mnt.ApplicationBoostingDetails AS u WHERE p_id=@id GROUP BY pkId, P_ID
)

SELECT 
b.pkId, b.cpkStartDate, b.EndDate, b.ApplicationBoostingLimit, 
	CASE 
		WHEN b.UpdatedOn IS NOT NULL OR b.ApplicationBoostingLimit IS NOT NULL THEN (b.ApplicationBoostingLimit + c.Boost_Count)
		WHEN b.UpdatedOn IS NULL THEN b.ApplicationBoostingLimit
    ELSE b.ApplicationBoostingLimit
	END AS adding_package,
	b.IsActive
FROM baseCTE as b
INNER JOIN CountCTE AS c ON c.P_ID = b.P_ID

--SELECT o.P_ID, pkId, o.cpkStartDate AS [OLD_P], DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate FROM [mnt].[CandidatePackages] AS o
--	UNION
--SELECT n.P_ID, pkId, n.cpkStartDate AS [NEW_P], DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate FROM [mnt].[CandidatePackages] AS n
--WHERE P_ID = n.P_ID AND P_ID = 2332477


DECLARE 
	--@id INT = 2332477;
	  @id INT = 241028;
	--@id INT = 2296339;

WITH baseCTE AS (
	SELECT DISTINCT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
	--r = ROW_NUMBER() OVER(PARTITION BY c.cpkStartDate ORDER BY c.cpkStartDate),
	--COUNT(d.BoostedOn) AS Boost_Count,
	c.IsActive, c.UpdatedOn 
	, u.ApplicationBoostingLimit
	FROM [mnt].[CandidatePackages] AS c
	INNER JOIN UserApplyLimit AS u ON u.pkId = c.pkId 
	WHERE c.P_ID=241028 --AND u.ApplicationBoostingLimit IS NOT NULL
	--GROUP BY c.P_ID, c.pkId, c.cpkStartDate, c.cpkDuration, c.IsActive, c.UpdatedOn
)

, CountCTE AS (
	SELECT P_ID, COUNT(u.BoostedOn) AS Boost_Count FROM mnt.ApplicationBoostingDetails AS u WHERE p_id=@id GROUP BY pkId, P_ID
)

SELECT 
b.pkId, b.cpkStartDate, b.EndDate, b.ApplicationBoostingLimit, 
	CASE 
		WHEN b.UpdatedOn IS NOT NULL OR b.ApplicationBoostingLimit IS NOT NULL THEN (b.ApplicationBoostingLimit + c.Boost_Count)
		WHEN b.UpdatedOn IS NULL THEN b.ApplicationBoostingLimit
    ELSE b.ApplicationBoostingLimit
	END AS adding_package,
	b.IsActive
FROM baseCTE as b
INNER JOIN CountCTE AS c ON c.P_ID = b.P_ID