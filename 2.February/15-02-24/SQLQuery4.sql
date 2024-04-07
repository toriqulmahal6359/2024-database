
--SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 2332477--241028
SELECT * FROM UserApplyLimit WHERE P_ID = 6091277 --241028 --241028 2332477
--SELECT  * FROM [mnt].[CandidatePackages] WHERE P_ID = 2332477 --241028 --6091277 241028 4141462
SELECT * FROM [mnt].[CandidatePackages] WHERE P_ID = 6467114
SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 6467114--6091277 --2332477--716794 --241028--6467114--6091277 --241028
--SELECT * FROM [mnt].[CandidatePackages] WHERE P_ID = 716794 --241028
SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 2332477--241028

	Declare @UNStatus varchar(5) = ''
	DECLARE @id INT = 6467114 ; -- updated user 4141462   2332477  5327873 3434119 241028  6467114 2332477 241028 6091277 716794

WITH RankedPackages AS (
    SELECT TOP 2 c.*, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
           ROW_NUMBER() OVER (ORDER BY c.UpdatedOn DESC) AS rn
    FROM [mnt].[CandidatePackages] AS c 
    WHERE c.P_ID = @id 
    ORDER BY c.UpdatedOn DESC
)
SELECT @UNStatus = CASE WHEN
         (SELECT EndDate FROM RankedPackages WHERE rn = 2) > (SELECT cpkStartDate FROM RankedPackages WHERE rn = 1) THEN 'U'
			  ELSE 'N'
    END 
FROM RankedPackages
print(@UNStatus)

 IF @UNStatus = 'U'
 BEGIN
	;WITH mainCTE as(
	   select CP.P_ID,cp.cpkstartdate,cp.cpkduration,cp.pkId, cp.IsActive
			from  bdjResumes.mnt.CandidatePackages CP 
			where  cp.P_ID = @id  AND  CP.IsActive = 1
	),SequencedData AS (
		SELECT 
			P_ID,pkId,isActive,
			ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
		FROM mainCTE
		CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
	),duration1 as(
	SELECT s.enddate, s.P_ID, s.pkId, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  > =DATEADD(DAY, -30, s.sdate)AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult,
	 s.IsActive
	FROM SequencedData s
	LEFT JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON  s.P_ID = AB.P_ID
	WHERE s.duration = 1
	group by s.enddate, s.P_ID, s.pkId, s.IsActive
	),duration2 as(
	select * from duration1
	UNION ALL
	SELECT s.enddate, s.P_ID, s.pkId, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  >= s.sdate AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult,
	s.IsActive
	FROM SequencedData s
	INNER JOIN bdjresumes.mnt.ApplicationBoostingDetails AS AB ON s.pkId = AB.pkId  AND s.P_ID = AB.P_ID
	WHERE s.duration > 1
	group by s.enddate, s.P_ID, s.pkId, s.IsActive 
	)
	select top 1 d.pkId, CountResult 
	, CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 1
		ELSE 0 END AS [Pro User]
	--CASE WHEN u.ApplicationBoostingLimit IS NULL THEN COALESCE(u.ApplicationBoostingLimit, 0) ELSE u.ApplicationBoostingLimit END AS boostingLimit
	--COALESCE(u.ApplicationBoostingLimit, 0) AS BoostingLimit
	--, CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN u.ApplicationBoostingLimit
	--	ELSE 0 END AS [Boosting Limit]
	, u.ApplicationBoostingLimit
	from BoostingCTE AS d
	INNER JOIN UserApplyLimit AS u ON u.P_ID = d.P_ID
	where d.enddate > GETDATE()
	AND u.ApplicationBoostingLimit IS NOT NULL
 END
 IF @UNStatus = 'N' OR @UNStatus = NULL 
 BEGIN
  ;WITH mainCTE as(
	   select CP.P_ID,cp.cpkstartdate,cp.cpkduration,cp.pkId, cp.IsActive
			from  bdjResumes.mnt.CandidatePackages CP 
			where  cp.P_ID = @id  AND  CP.IsActive = 1
	),SequencedData AS (
		SELECT 
			P_ID,pkId, IsActive,
			ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
		FROM mainCTE
		CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
	),duration1 as(
	SELECT s.P_ID, s.enddate, s.pkId, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  >= s.sdate AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult,
	s.IsActive
	FROM SequencedData s
	LEFT JOIN bdjresumes.mnt.ApplicationBoostingDetails AS ab ON s.pkId=ab.pkid and  s.P_ID = AB.P_ID
	group by s.enddate, s.P_ID, s.pkId, s.IsActive 
	)
	select top 1 d.pkId, d.CountResult
	, CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 1
		ELSE 0 END AS [Pro User]
	--, CASE 
	--	WHEN d.P_ID IS NOT NULL 
	--	THEN 
	--		CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 1
	--	ELSE 0 END 
	--	END AS [Pro User]
	--CASE WHEN u.ApplicationBoostingLimit IS NULL THEN COALESCE(u.ApplicationBoostingLimit, 0) ELSE u.ApplicationBoostingLimit END AS boostingLimit
	--COALESCE(u.ApplicationBoostingLimit, 0) AS BoostingLimit
	--, CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN u.ApplicationBoostingLimit
	--	ELSE 0 END AS [Boosting Limit]
	, u.ApplicationBoostingLimit
	from BoostingCTE AS d
	INNER JOIN UserApplyLimit AS u ON u.P_ID = d.P_ID
	where d.enddate > GETDATE()
	AND u.ApplicationBoostingLimit IS NOT NULL
 END

--SELECT * FROM [dbo].[OnlinePaymentInfoJS] WHERE P_ID = 6091277

--SELECT DISTINCT P_ID FROM mnt.CandidatePackages