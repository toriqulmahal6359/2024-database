--SELECT * FROM mnt.ApplicationBoostingDetails WHERE P_ID = 6467114
	Declare @UNStatus varchar(5) = ''
	DECLARE @id INT = 6467114 ; -- updated user 4141462   2332477  5327873 3434119 241028  6467114 2332477 241028

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
	   select CP.P_ID,cp.cpkstartdate,cp.cpkduration,cp.pkId
			from  bdjResumes.mnt.CandidatePackages CP 
			where  cp.P_ID = @id  AND  CP.IsActive = 1
	),SequencedData AS (
		SELECT 
			P_ID,pkId,
			ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
		FROM mainCTE
		CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
	),duration1 as(
	SELECT s.enddate, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  > =DATEADD(DAY, -30, s.sdate)AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult
	FROM SequencedData s
	INNER JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON  s.P_ID = AB.P_ID
	WHERE s.duration = 1
	group by s.enddate
	),duration2 as(
	select * from duration1
	UNION ALL
	SELECT s.enddate, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  >= s.sdate AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult
	FROM SequencedData s
	INNER JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON  s.pkId = AB.pkId  AND s.P_ID = AB.P_ID
	WHERE s.duration > 1
	group by s.enddate 
	)
	select top 1 CountResult from duration2 where enddate > GETDATE()
 END
 IF @UNStatus = 'N' OR @UNStatus = NULL 
 BEGIN
  ;WITH mainCTE as(
	   select CP.P_ID,cp.cpkstartdate,cp.cpkduration,cp.pkId
			from  bdjResumes.mnt.CandidatePackages CP 
			where  cp.P_ID = @id  AND  CP.IsActive = 1
	),SequencedData AS (
		SELECT 
			P_ID,pkId,
			ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)  as Duration,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate)-1, cpkstartdate) AS sdate,
			DATEADD(MONTH, ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY cpkstartdate), cpkstartdate) AS enddate
		FROM mainCTE
		CROSS APPLY (SELECT TOP (cpkduration) 1 AS n FROM master.dbo.spt_values) AS X
	),duration1 as(
	SELECT s.enddate, COUNT(
	  DISTINCT CASE
		WHEN (AB.BoostedOn  >= s.sdate AND AB.BoostedOn <= s.enddate)
		THEN AB.abid
	  END
	) AS CountResult
	FROM SequencedData s
	INNER JOIN bdjresumes.mnt.ApplicationBoostingDetails AB ON s.pkId=ab.pkid and  s.P_ID = AB.P_ID
	group by s.enddate 
	)
	select top 1  CountResult from duration1 where enddate > GETDATE()
 END