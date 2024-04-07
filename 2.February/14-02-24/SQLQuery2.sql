select  * from [mnt].[CandidatePackages] where p_id=2332477
select top 5 * from UserApplyLimit where p_id=2332477

select * from mnt.ApplicationBoostingDetails where p_id=2332477 


SELECT * FROM [mnt].[CandidatePackages] WHERE P_ID = 4141462 --NEW User
SELECT * FROM [mnt].[CandidatePackages] WHERE P_ID = 5327873 --Updated User
SELECT * FROM [mnt].[CandidatePackages] WHERE P_ID = 2332477 --Updated User

select top 5 * from UserApplyLimit where p_id=5327873
select * from mnt.ApplicationBoostingDetails where p_id=5327873 

select top 5 * from UserApplyLimit where p_id=4141462


SELECT DISTINCT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
	--COUNT(d.BoostedOn) AS Boost_Count,
	c.IsActive, c.UpdatedOn 
	FROM [mnt].[CandidatePackages] AS c
	WHERE c.P_ID=2332477  


WITH packageCTE AS (
	SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
		c.IsActive, C.UpdatedOn FROM [mnt].[CandidatePackages] AS c
	--WHERE c.P_ID = 5327873
)
, countCTE AS (
	SELECT a.pkId, a.P_ID, COUNT(*) AS boost_used FROM mnt.ApplicationBoostingDetails AS a
	--WHERE a.P_ID = 4141462
	GROUP BY MONTH(a.BoostedOn), pkId, P_ID
)
SELECT DISTINCT p.cpkStartDate, p.EndDate, p.UpdatedOn, c.boost_used, p.isActive, u.ApplicationBoostingLimit FROM packageCTE AS p
LEFT JOIN countCTE AS c ON c.pkId = p.pkId --AND p.P_ID = c.P_ID
INNER JOIN UserApplyLimit AS u ON u.pkId = c.pkId AND u.P_ID = p.P_ID 
WHERE p.P_ID = 2332477

SELECT COUNT(*) FROM mnt.ApplicationBoostingDetails WHERE P_ID = 5327873 -- 5327873 2332477 4141462
GROUP BY MONTH(BoostedOn)

SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
c.IsActive, C.UpdatedOn, COUNT(a.BoostedOn) OVER(PARTITION BY c.UpdatedOn ORDER BY cpkStartDate) AS Boost_used
-- ROW_NUMBER() OVER(PARTITION BY c.UpdatedOn ORDER BY cpkStartDate) AS row_count
FROM [mnt].[CandidatePackages] AS c
LEFT JOIN mnt.ApplicationBoostingDetails AS a ON a.P_ID = c.P_ID AND a.pkId = c.pkId
WHERE c.P_ID = 5327873    -- 2332477  4141462 5327873
GROUP BY DATEPART(MONTH, a.BoostedOn), c.P_ID, c.pkId, c.cpkStartDate, c.cpkDuration, c.IsActive, c.UpdatedOn, a.BoostedOn
ORDER BY c.UpdatedOn

SELECT c.P_ID, c.pkId, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
c.IsActive, C.UpdatedOn FROM [mnt].[CandidatePackages] AS c
INNER JOIN mnt.ApplicationBoostingDetails AS a ON a.pkId = c.pkId
WHERE c.P_ID = 2332477 AND c.IsActive = 1
GROUP BY DATEPART(MONTH, a.BoostedOn), c.P_ID, c.pkId, c.cpkStartDate, c.cpkDuration, c.IsActive, c.UpdatedOn
ORDER BY c.UpdatedOn



	SELECT BoostedOn FROM mnt.ApplicationBoostingDetails AS c 
	WHERE c.P_ID = 2332477
	GROUP BY DATEPART(MONTH, c.BoostedOn), pkId, c.BoostedOn
	
	INNER JOIN mnt.ApplicationBoostingDetails AS a ON c.P_ID = a.P_ID
	 --AND c.IsActive = 1 4141462
	--, a.pkId


SELECT COUNT(*) FROM mnt.ApplicationBoostingDetails AS a
WHERE a.P_ID=4141462
GROUP BY MONTH(BoostedOn)
--GROUP BY MONTH(BoostedOn)