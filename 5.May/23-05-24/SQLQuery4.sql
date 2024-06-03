--;with cte as(
--SELECT I.P_ID,  AP.ApplyId		
--		FROM bdjCorporate..DBO_JOB_INBOX I
--			LEFT JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
--			LEFT JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
--where  TS.TestType in('onlinetest','written','facetoface','aiasmnt','video')
--)
--select count(distinct P_ID) from cte where ApplyId is null


--use bdjCorporate
