WITH main as(
SELECT distinct P_ID
		FROM bdjCorporate..DBO_JOB_INBOX AS ji
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyId					--79134	7098589
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND  rp.UpdatedOn <= GETDATE()
),onlineTestCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c		
		FROM main m 
		INNER JOIN bdjCorporate..DBO_JOB_INBOX I on m.P_ID=I.P_ID
		LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'onlinetest' 
	group by I.P_ID
)
, writtenCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c			
		FROM main m 
		INNER JOIN bdjCorporate..DBO_JOB_INBOX I on m.P_ID=I.P_ID
		LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
	where TS.TestType  = 'written'
	group by I.P_ID

)
,facetofaceCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c			
	FROM main m 
		INNER JOIN bdjCorporate..DBO_JOB_INBOX I on m.P_ID=I.P_ID
		LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'facetoface'	
	group by I.P_ID

)
,aiasmntCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c				
		FROM main m 
		INNER JOIN bdjCorporate..DBO_JOB_INBOX I on m.P_ID=I.P_ID
		LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'aiasmnt'	
	group by I.P_ID
	
)
, videoCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c				
		FROM main m 
		INNER JOIN bdjCorporate..DBO_JOB_INBOX I on m.P_ID=I.P_ID
		LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
		LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'video'	
		group by I.P_ID

)
, mainCTE AS (
	SELECT P_ID  FROM onlineTestCTE where c=0
		UNION
	SELECT P_ID  FROM writtenCTE where c=0
		UNION
	SELECT P_ID  FROM facetofaceCTE where c=0
		UNION
	SELECT P_ID  FROM videoCTE where c=0
		UNION
	SELECT P_ID FROM aiasmntCTE where  c=0
)
SELECT count(P_ID) FROM mainCTE


