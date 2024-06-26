USE [bdjCorporate]
GO
/****** Object:  StoredProcedure [dbo].[Voice_Blaster_Messages]    Script Date: 5/26/2024 4:18:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************
** File  :   StoredProcedure [Voice_Blaster_Messages]
** Name  :   Voice_Blaster_Messages 
** Desc  :   Voice_Blaster_Messages 1,20
** Author:   Meharaz
** Date  :   MAY 25, 2024
******************************************************************************************/
ALTER PROCEDURE [dbo].[Voice_Blaster_Messages]
(
    --DECLARE
	  @pageNo INT = 1
	, @per_page_data INT = 20
)
AS
BEGIN
SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#maincte') IS NOT NULL
		DROP TABLE #maincte;

	create table #maincte(
	JP_ID int
	)
	insert into #maincte(JP_ID)
	SELECT distinct ji.JP_ID
				FROM bdjCorporate..DBO_JOB_INBOX AS ji
				INNER JOIN bdjCorporate.rp.TestSteps TS ON ji.JP_ID = TS.JP_ID
				INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyID  And TS.TestLevel = RP.LevelStatus
			    INNER JOIN bdjCorporate.rp.Schedule AS s ON s.schId = rp.SchId
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND s.ScheduleDate >= GETDATE() and  rp.Notify=1 and rp.schid>0 and  TS.TestType in ('onlinetest','written','facetoface','aiasmnt','video')
 
	;with maincte as(
		SELECT distinct ji.P_ID,ji.JP_ID,rp.schid,TS.TestType,ji.applyid, Ts.stId,count(1) over() Total
				FROM bdjCorporate..DBO_JOB_INBOX AS ji
				INNER JOIN bdjCorporate.rp.TestSteps TS ON ji.JP_ID = TS.JP_ID
				INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyID  And TS.TestLevel = RP.LevelStatus
				INNER JOIN bdjCorporate.rp.Schedule AS s ON s.schId = rp.SchId
		WHERE rp.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND s.ScheduleDate >= GETDATE() and rp.Notify=1 and rp.schid>0 and  TS.TestType in ('onlinetest','written','facetoface','aiasmnt','video')
	
	order by P_ID,JP_ID OFFSET ((@pageNo - 1)*@per_page_data) ROWS FETCH NEXT @per_page_data ROWS ONLY	
	),Previously_Participated_exam as(
	SELECT distinct ji.P_ID	,COUNT(case when  p.ParticipatedOn is not null then p.ApplyId end) c
				FROM maincte m
				INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji on m.P_ID=ji.P_ID	
				INNER JOIN bdjCorporate.rp.TestSteps TS ON ji.JP_ID = TS.JP_ID and ts.TestType='onlinetest'
				INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyID  And TS.TestLevel = RP.LevelStatus
				INNER join bdjExaminations.exm.Participants p on ji.ApplyID = p.ApplyID and ji.P_ID = p.UserId
		WHERE ji.JP_ID not in(select JP_ID from #maincte)
		group by ji.P_ID
	),Previously_Participated as(
		SELECT distinct ji.P_ID
		,count(rp.applyid) c ,TS.TestType
				FROM maincte m
				INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji on m.P_ID=ji.P_ID
				INNER JOIN bdjCorporate.rp.TestSteps TS ON ji.JP_ID = TS.JP_ID and m.TestType=ts.TestType
				LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON ji.ApplyID = rp.ApplyID  And TS.TestLevel = RP.LevelStatus
		WHERE ji.JP_ID not in(select JP_ID from #maincte)
		group by ji.P_ID,TS.TestType
	),Responsed as(
		select m.P_ID,count(AR.applyid) c,TS.TestType,m.JP_ID
		from maincte m
			INNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID and m.TestType=ts.TestType
			INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
			LEFT JOIN bdjCorporate.rp.ApplicantsResponse AR ON AR.ApplyID = AP.ApplyId And AR.LevelStatus = AP.LevelStatus
		group by m.P_ID,TS.TestType,m.JP_ID
	),video_submit_not_submited as(
		select m.P_ID, count(distinct case when vdo.AnsweredOn is null then m.applyid end) as Video_not_submit
			   ,count(distinct case when vdo.AnsweredOn is not null then m.applyid end) as Video_submit
			   ,m.JP_ID
		FROM maincte AS m
			iNNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
			INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
			INNER JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON m.JP_ID = i.JP_ID
			LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON m.ApplyID = vdo.ApplyId 
		group by  m.P_ID,m.JP_ID
	),previous_video_submit as(

		select m.P_ID,count(distinct case when vdo.AnsweredOn is not null then m.applyid end) as Video_submit
		FROM maincte AS m
			INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji on m.P_ID=ji.P_ID
			iNNER JOIN bdjCorporate.rp.TestSteps TS ON ji.JP_ID = TS.JP_ID
			INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON ji.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
			INNER JOIN bdjCorporate.[vdo].[InterviewInfo] AS i ON ji.JP_ID = i.JP_ID
			LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON ji.ApplyID = vdo.ApplyId 
			WHERE ji.JP_ID not in(select JP_ID from #maincte)
		group by  m.P_ID
	),AI_submit_not_submited as(
		select m.P_ID, count(distinct case when ai.AnsweredOn is null then m.applyid end) as AI_not_submit
			   ,count(distinct case when ai.AnsweredOn is not null then m.applyid end) as AI_submit
			   ,m.JP_ID
		FROM maincte AS m
			iNNER JOIN bdjCorporate.rp.TestSteps TS ON m.JP_ID = TS.JP_ID
			INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
			INNER JOIN bdjCorporate.[aiass].AIAssessmentInfo AS i ON m.JP_ID = i.JP_ID 
			LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON m.ApplyId = ai.ApplyId
		group by  m.P_ID,m.JP_ID
	),previous_AI_submit as(

		select m.P_ID,count(distinct case when ai.AnsweredOn is not null then m.applyid end) as AI_submit
		FROM maincte AS m
			INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji on m.P_ID=ji.P_ID
			iNNER JOIN bdjCorporate.rp.TestSteps TS ON JI.JP_ID = TS.JP_ID
			INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON m.ApplyID = AP.ApplyId And TS.TestLevel = AP.LevelStatus
			INNER JOIN bdjCorporate.[aiass].AIAssessmentInfo AS i ON m.JP_ID = i.JP_ID 
			LEFT JOIN bdjCorporate.[aiass].AIAssessmentApplicants AS ai ON m.ApplyId = ai.ApplyId
		WHERE ji.JP_ID not in(select JP_ID from #maincte)
		group by  m.P_ID
		)
		select distinct p.NAME,m.P_ID,m.JP_ID
		, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]
	    , c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.MOBILE AS [Mobile Phone]
		,m.SchId,m.TestType, s.ScheduleDate
		--,case when  pp.c>0 then 1 else 0 end as Previously_Participated
		,  CASE 
				WHEN m.TestType = 'aiasmnt' THEN 
					CASE 
						WHEN pais.AI_submit > 0 THEN 1 
						ELSE 0 
					END
				WHEN m.TestType = 'video' THEN 
					CASE 
						WHEN pvs.Video_submit > 0 THEN 1 
						ELSE 0 
					END
				WHEN m.TestType = 'onlinetest' THEN 
					CASE 
						WHEN e.c > 0 THEN 1 
						ELSE 0 
					END
				ELSE 
					CASE
						WHEN pp.c > 0 THEN 1
						ELSE 0 
					END
			END as Previously_Participated
		 , CASE 
				WHEN m.TestType = 'aiasmnt' THEN 
					CASE 
						WHEN ais.AI_not_submit > 0 THEN 1 
						ELSE 0 
					END
				WHEN m.TestType = 'video' THEN 
					CASE 
						WHEN vs.Video_not_submit > 0 THEN 1 
						ELSE 0 
					END
				ELSE 
					CASE
						WHEN rp.c > 0 THEN 1
						ELSE 0 
					END
			END AS Responsed, v.VenueName,v.Address
			,m.Total
		from maincte m
			INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON m.JP_ID = j.JP_ID
			LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON m.JP_ID = bj.JP_ID
			INNER JOIN bdjResumes..PERSONAL AS p ON m.P_ID = p.ID
	        INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
			LEFT JOIN Previously_Participated pp on m.P_ID = pp.P_ID
			LEFT JOIN Responsed rp on m.P_ID = rp.P_ID and m.JP_ID = rp.JP_ID
			LEFT JOIN video_submit_not_submited vs on m.P_ID = vs.P_ID and m.JP_ID = vs.JP_ID
			LEFT JOIN previous_video_submit pvs on m.P_ID = pvs.P_ID 
			LEFT JOIN AI_submit_not_submited ais on m.P_ID = ais.P_ID and m.JP_ID = ais.JP_ID
			LEFT JOIN previous_AI_submit pais on m.P_ID = pais.P_ID 
			LEFT JOIN Previously_Participated_exam e on m.P_ID = e.P_ID 
			INNER JOIN rp.Schedule S on m.SchId = S.SchID And m.stId = s.stId 
			LEFT JOIN bdjCorporate.rp.TestVenues AS v ON s.VenueId = v.VenueId

SET NOCOUNT OFF
END
