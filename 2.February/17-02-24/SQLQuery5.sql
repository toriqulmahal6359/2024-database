	Declare @UNStatus varchar(5) = ''
	DECLARE @id INT = 64671141;-- 64671141 ; -- updated user 4141462   2332477  5327873 3434119 241028  6467114 2332477 241028

--IF EXISTS (SELECT 1 FROM mnt.[CandidatePackages] WHERE P_ID = @id)
--BEGIN
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
IF @UNStatus = 'U' OR @UNStatus = 'N'
BEGIN
 IF @UNStatus = 'U'
 BEGIN
	;WITH mainCTE as(
	   select 
			COALESCE(cp.P_ID, 0) AS P_ID, cp.cpkstartdate,cp.cpkduration,cp.pkId, cp.IsActive, u.ApplicationBoostingLimit
			from  bdjResumes.mnt.CandidatePackages CP 
			INNER JOIN UserApplyLimit AS u ON u.P_ID = cp.P_ID
			where  cp.P_ID = @id  AND  CP.IsActive = 1
			--AND u.ApplicationBoostingLimit IS NOT NULL
	),SequencedData AS (
		SELECT 
			P_ID,pkId, isActive, 
			BoostingLimit = (SELECT TOP 1 ApplicationBoostingLimit FROM mainCTE WHERE IsActive = 1 ORDER BY ApplicationBoostingLimit DESC),
			ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
		FROM mainCTE
		CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
	),duration1 as(
	SELECT s.enddate, s.pkId,  COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  > =DATEADD(DAY, -30, s.sdate)AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult, IsActive, BoostingLimit
	FROM SequencedData s
	INNER JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON  s.P_ID = AB.P_ID
	WHERE s.duration = 1
	group by s.enddate, s.IsActive, s.BoostingLimit, s.pkId
	),duration2 as(
	select * from duration1
	UNION ALL
	SELECT s.enddate, s.pkid, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  >= s.sdate AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult, IsActive, BoostingLimit
	FROM SequencedData s
	INNER JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON  s.pkId = AB.pkId  AND s.P_ID = AB.P_ID
	WHERE s.duration > 1
	group by s.enddate, s.IsActive, s.BoostingLimit, s.pkId
	)
	select top 1 
		COALESCE(pkId, 0) AS pkId,
		COALESCE(CountResult, 0) AS CountResult
	, COALESCE(CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 1
		ELSE 0 END, 0) AS [Pro User], COALESCE(BoostingLimit, 0) AS BoostingLimit
	from duration2 AS d
	where d.enddate > GETDATE()
	
 END

 IF (@UNStatus = 'N' OR @UNStatus = NULL)
 BEGIN
	;WITH mainCTE as(
		select 
			COALESCE(cp.P_ID, 0) AS P_ID, cp.cpkstartdate,cp.cpkduration,cp.pkId, cp.IsActive, u.ApplicationBoostingLimit, u.ID
			from  bdjResumes.mnt.CandidatePackages CP
			INNER JOIN UserApplyLimit AS u ON u.P_ID = cp.P_ID
			where  cp.P_ID = @id  AND  CP.IsActive = 1
			--AND u.ApplicationBoostingLimit IS NOT NULL
	),SequencedData AS (
		SELECT 
			P_ID, pkId, IsActive, 
			BoostingLimit = (SELECT TOP 1 ApplicationBoostingLimit FROM mainCTE WHERE IsActive = 1 ORDER BY ID DESC),
			ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
		FROM mainCTE
		CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
	),duration1 as(
	SELECT s.enddate, s.pkId, COUNT(
		DISTINCT CASE
		WHEN (AB.BoostedOn  >= s.sdate AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
		END
	) AS CountResult, s.IsActive, s.BoostingLimit
	FROM SequencedData s 
	LEFT JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON s.pkId=ab.pkid and  s.P_ID = AB.P_ID
	group by s.enddate, s.IsActive, s.pkId, s.BoostingLimit 
	)
	select top 1 pkId, CountResult,
	CASE WHEN IsActive = 1 AND d.enddate > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 1
		ELSE 0 END AS [Pro User], BoostingLimit
	from duration1 AS d where d.enddate > GETDATE()
END
END
ELSE BEGIN
	SELECT 0 AS pkId, 0 AS CountResult, 0 AS [Pro User], 0 AS [BoostingLimit]
END
	