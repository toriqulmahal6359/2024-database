WITH onlineTestCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c		
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'onlinetest' 
	group by I.P_ID
)
, writtenCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c			
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'written'
	group by I.P_ID

)
,facetofaceCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c			
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'facetoface'	
	group by I.P_ID

)
,aiasmntCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c				
		FROM bdjCorporate..DBO_JOB_INBOX I
			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
		where TS.TestType  = 'aiasmnt'	
	group by I.P_ID
	
)
, videoCTE AS (
	SELECT I.P_ID,  count(AP.ApplyId) c				
		FROM bdjCorporate..DBO_JOB_INBOX I
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


