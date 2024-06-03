USE [bdjCorporate]
GO
/****** Object:  StoredProcedure [dbo].[USP_MyBdjobs_ApplyPosition_v1]    Script Date: 6/2/2024 3:09:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************
** File  :   StoredProcedure [dbo].[USP_MyBdjobs_ApplyPosition_Test]
** Name  :   bdjCorporate..USP_MyBdjobs_ApplyPosition_v1 1,6056723,20,'EN','','',N'',NULL
** Desc  :   
** Author:   MEHARAZ
** Date  :   27 january 2024
** Last Modify : Meharaz 19/5/2024
******************************************************************************************/
--ALTER PROCEDURE [dbo].[USP_MyBdjobs_ApplyPosition_v1]
--(
DECLARE
	 @PageNo int = 1
	,@uID int = 1481759        ----6098620  6056723 6152508   --4361771
	,@PageSize int = 20
	,@LanType char(2) = 'EN'
	,@FromDate varchar(10) =''
	,@SearchToDate varchar(15)=''
	,@SearchCompanyName nvarchar(240)= N''
	,@SearchIsViewed As int = -1  -- 0 Not viewed, 1 viewed, 2 Video resume required, 3 hiered, 4 Offered, 5 Cotacted, 6 InterviewInvitation 
	
--)
--AS
BEGIN	
	DECLARE @StartingIndex int = 1
	DECLARE	@strWhereCondition nvarchar(1500)='',
			@strSQL nvarchar(max)='',
			@Condition nvarchar(2000)=''

	DECLARE @TotalJobs int = 0
		, @Contacted int = 0
		, @NotContacted int = 0
		, @Hired int = 0
		, @Offered int = 0
	DECLARE @TotalCount Table(TotalJob int not null
							,	NotContacted int not null
							,	Contacted int not null
							,	Hired int not null
							,	Offered int not null)
	SET NOCOUNT ON
	IF @PageNo > 0
		SET @StartingIndex = (@PageNo -1) * @PageSize
	
	IF @FromDate<>''
		SET @strWhereCondition = @strWhereCondition +'And JI.P_Date >='''+@FromDate+''''  
    if @SearchToDate<> ''
          SET @strWhereCondition=@strWhereCondition+' AND JI.P_Date < '''+ convert(varchar(10), dateadd(day, 1, convert(date, @SearchToDate,101)), 101)+''''
    
    if @SearchCompanyName<>''
				SET  @strWhereCondition=@strWhereCondition+' AND (JP.CompanyName LIKE N''%'+@SearchCompanyName+'%'' or  JB.CompanyNameBng LIKE N''%'+@SearchCompanyName+'%'')'
			
    IF @SearchIsViewed <> -1
		BEGIN
			IF @SearchIsViewed = 0 
				SET @strWhereCondition = @strWhereCondition+' AND JI.Summary_Viewed = 0'
			IF @SearchIsViewed = 1
				SET @strWhereCondition = @strWhereCondition+' AND JI.Summary_Viewed > 0'
			IF @SearchIsViewed = 2
				SET @strWhereCondition = @strWhereCondition+' AND JP.IsVDOResume = 1' 
			IF @SearchIsViewed = 3 
				SET @strWhereCondition=@strWhereCondition+' AND JI.EmpResponse = 3'
			IF @SearchIsViewed = 4
				SET @strWhereCondition=@strWhereCondition+' AND JI.EmpResponse = 5'
			IF @SearchIsViewed = 5		
				SET @strWhereCondition=@strWhereCondition+' AND JI.EmpResponse = 2'
			IF @SearchIsViewed = 6 
				SET @strWhereCondition=@strWhereCondition+' AND ((CASE WHEN IA.UserActivity = 0 AND II.Deadline > GETDATE() THEN 1 END) = 1 OR  (CASE WHEN S.InterviewType < 2 AND S.ScheduleDate > GETDATE() THEN 1 ELSE 0 END) = 1 OR  (CASE WHEN S.InterviewType = 2 AND S.ScheduleDate > GETDATE() THEN 1 ELSE 0 END) = 1  OR  (CASE WHEN S.InterviewType = 4 AND S.ScheduleDate > GETDATE() THEN 1 ELSE 0 END) = 1) '
			IF @SearchIsViewed = 7
				SET @strWhereCondition=@strWhereCondition+' AND JI.Priority = 1'
			IF @SearchIsViewed = 8
				SET @strWhereCondition=@strWhereCondition+' AND (JI.Priority = 0 or JI.Priority is null)'
		END

	SET @Condition = @Condition + 'DECLARE @Tj int, @Nc int, @Ct int, @Hr int, @Of int' + CHAR(13)+ CHAR(13)
	SET @Condition = @Condition + 'SELECT @Tj  = COUNT(DISTINCT JI.JP_ID),  @Nc  = COUNT(DISTINCT CASE WHEN JI.EmpResponse = 1 THEN JI.JP_ID END) ' + CHAR(13)
	SET @Condition = @Condition + '	,  @Ct  = COUNT(DISTINCT CASE WHEN JI.EmpResponse = 2 THEN JI.JP_ID END), @Hr = COUNT(DISTINCT CASE WHEN JI.EmpResponse = 3 THEN JI.JP_ID END) ' + CHAR(13)
	SET @Condition = @Condition + '	,  @Of  = COUNT(DISTINCT CASE WHEN JI.EmpResponse = 5 THEN JI.JP_ID END)' + CHAR(13)
	SET @Condition = @Condition + 'FROM DBO_JOB_INBOX JI' + CHAR(13)
	SET @Condition = @Condition + 'INNER JOIN dbo_JOBPOSTINGS JP ON JI.JP_ID = JP.JP_ID' + CHAR(13)
	SET @Condition = @Condition + 'LEFT JOIN DBO_BNG_JOBPOSTINGS JB ON JP.JP_ID = JB.JP_ID' + CHAR(13)
	IF @SearchIsViewed = 6 
		BEGIN
			SET @Condition=@Condition+ '	LEFT JOIN  vdo.InterviewInfo II ON JI.JP_ID = II.JP_ID ' + CHAR(13)
			SET @Condition=@Condition+ '	LEFT JOIN vdo.InterviewApplicants IA ON JI.ApplyID = IA.ApplyId ' + CHAR(13)
			SET @Condition=@Condition+ '	INNER JOIN rp.TestSteps T ON JI.JP_ID= T.JP_ID ' + CHAR(13)
			SET @Condition=@Condition+ '	INNER JOIN rp.Schedule S ON T.stId = S.stId ' + CHAR(13)
			SET @Condition=@Condition+ '	INNER JOIN rp.ApplicantProcess A ON S.schId = A.SchId AND  JI.ApplyID = A.ApplyId AND A.Notify=1  ' + CHAR(13)
		END
	SET @Condition = @Condition + 'WHERE P_ID = ' +CAST(@uID AS nvarchar)+@strWhereCondition+ CHAR(13)  
	SET @Condition = @Condition + ' SELECT @Tj AS TotalJob, @Nc AS NotContacted ,@Ct AS Contacted,@Hr AS Hired,@Of AS Offered'+ CHAR(13)  
	
	insert into @TotalCount
	EXEC(@Condition)
	--PRINT(@Condition)
	
	SELECT @TotalJobs = TotalJob, @NotContacted = NotContacted, @Contacted = Contacted, @Hired = Hired, @Offered = Offered
	FROM @TotalCount


	SET @strSQL=@strSQL+ ';WITH Application_CTE As ( ' + CHAR(13)
	SET @strSQL=@strSQL+ '	SELECT JI.ApplyID, JI.JP_ID, JI.P_ID, JI.Score, JI.P_Date, JI.Summary_Viewed, JI.ExpectedSalary, JI.EmpResponse, 0 as AssessmentNeeded, JI.Priority,JP.IsVDOResume' + CHAR(13)
	SET @strSQL=@strSQL+ '	, CASE WHEN JP.JobLang = 2 THEN JB.TITLE ELSE JP.JobTitle END AS [Job Title]' + CHAR(13)
	SET @strSQL=@strSQL+ '	, CASE WHEN JP.JobLang = 2 THEN JB.CompanyNameBng ELSE JP.CompanyName END AS Company' + CHAR(13)
	SET @strSQL=@strSQL+ '	, JV.NoOfApply, JI.Serial' + CHAR(13)
	--SET @strSQL=@strSQL+ '	, CASE WHEN JV.NoOfApply > 0 THEN CAST(FORMAT(ROUND((CAST(JI.Serial As float)/JV.NoOfApply)*100, 0), ''###'') As int) ELSE JV.NoOfApply END As PositionStatus' + CHAR(13)
	SET @strSQL=@strSQL+ '	, CASE WHEN JV.NoOfApply > 0 THEN CAST(FORMAT(ROUND(CASE WHEN ((CAST(JI.Serial As float)/JV.NoOfApply)*100) > 0 AND ((CAST(JI.Serial As float)/JV.NoOfApply)*100) < 1 THEN 1 ELSE ((CAST(JI.Serial As float)/JV.NoOfApply)*100) END, 0), ''###'') As int) ELSE JV.NoOfApply END As PositionStatus' + CHAR(13)
	SET @strSQL=@strSQL+ '	FROM DBO_JOB_INBOX JI ' + CHAR(13)
	SET @strSQL=@strSQL+ '		LEFT JOIN dbo_JOBPOSTINGS JP WITH(NOLOCK) ON JI.JP_ID = JP.JP_ID ' + CHAR(13)
	SET @strSQL=@strSQL+ '		LEFT JOIN bdjCorporate..JobLastViewedDate JV ON JV.JP_ID = JP.JP_ID  ' + CHAR(13)
	SET @strSQL=@strSQL+ '		LEFT JOIN DBO_BNG_JOBPOSTINGS JB ON JP.JP_ID = JB.JP_ID ' + CHAR(13)
	IF @SearchIsViewed = 6 
		BEGIN
			SET @strSQL=@strSQL+ '	LEFT JOIN  vdo.InterviewInfo II ON JI.JP_ID = II.JP_ID ' + CHAR(13)
			SET @strSQL=@strSQL+ '	LEFT JOIN vdo.InterviewApplicants IA ON JI.ApplyID = IA.ApplyId ' + CHAR(13)
			SET @strSQL=@strSQL+ '	INNER JOIN rp.TestSteps T ON JI.JP_ID= T.JP_ID ' + CHAR(13)
			SET @strSQL=@strSQL+ '	INNER JOIN rp.Schedule S ON T.stId = S.stId ' + CHAR(13)
			SET @strSQL=@strSQL+ '	INNER JOIN rp.ApplicantProcess A ON S.schId = A.SchId AND  JI.ApplyID = A.ApplyId AND A.Notify=1  ' + CHAR(13)
		END
	SET @strSQL=@strSQL+ '	WHERE JI.P_ID = '+ CAST(@uID AS varchar(10)) + CHAR(13)
	SET @strSQL=@strSQL+@strWhereCondition + CHAR(13)
	--print @StartingIndex
	SET @strSQL=@strSQL+'   ORDER BY  JI.P_DATE DESC OFFSET '+CAST(@StartingIndex As varchar(5))+' ROWS FETCH NEXT '+CAST(@PageSize As varchar(5))+' ROWS ONLY ' + CHAR(13)
	--SET @strSQL=@strSQL+ '), JobWise_Applicant_Sl AS ( ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	SELECT DISTINCT A.JP_ID,I.Score, I.P_ID,I.ApplyId, I.P_DATE, I.Summary_Viewed, I.ExpectedSalary,I.AssessmentNeeded ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	, I.EmpResponse, I.Priority ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	FROM Application_CTE A ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	INNER JOIN DBO_JOB_INBOX I ON A.JP_ID = I.JP_ID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '), JobWise_Total AS ( ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	SELECT JP_ID, COUNT(1) AS NoOfApplicants ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	FROM JobWise_Applicant_Sl  ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	GROUP BY JP_ID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '), Score_CTE As (  ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	SELECT * ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	FROM JobWise_Applicant_Sl ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	WHERE P_ID = '+ CAST(@uID AS varchar(10)) + CHAR(13)
	--SET @strSQL=@strSQL+ '), JobInbox_CTE As ( ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	SELECT I.*, ROW_NUMBER()OVER(PARTITION BY I.JP_ID ORDER BY I.Score DESC, I.P_DATE) As SL  ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	FROM JobWise_Applicant_Sl I ' + CHAR(13)
	--SET @strSQL=@strSQL+ '		INNER JOIN Score_CTE S ON I.JP_ID = S.JP_ID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	WHERE I.Score >= S.Score ' + CHAR(13)
	--SET @strSQL=@strSQL+ '), TopScore_CTE As(  ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	SELECT JI.*,  CAST(FORMAT(ROUND((CAST(JI.SL As float)/J.NoOfApplicants)*100, 0), ''###'') As int) As Top50,J.NoOfApplicants ' + CHAR(13) 
	--SET @strSQL=@strSQL+ '	FROM JobInbox_CTE JI ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	INNER JOIN JobWise_Total J ON JI.JP_ID = J.JP_ID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	WHERE JI.P_ID = '+ CAST(@uID AS varchar(10)) + CHAR(13)
	SET @strSQL=@strSQL+ '), VDO_CTE AS ( ' + CHAR(13)
	SET @strSQL=@strSQL+ '	SELECT II.JP_ID, IA.ApplyId, I.P_ID, (CASE WHEN IA.UserActivity = 0 THEN 1 END) As [Vdo Invitation], DATEADD(DAY,1,II.Deadline) AS Deadline ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, ROW_NUMBER()OVER(PARTITION BY II.JP_ID ORDER BY (CASE WHEN IA.UserActivity = 0 THEN 1 END) DESC ) As SL  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	FROM vdo.InterviewInfo II  ' + CHAR(13)
	SET @strSQL=@strSQL+ '		INNER JOIN vdo.InterviewApplicants IA ON II.intId = IA.intID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '		INNER JOIN TopScore_CTE I ON IA.ApplyId = I.ApplyID ' + CHAR(13)
	SET @strSQL=@strSQL+ '		INNER JOIN Application_CTE I ON IA.ApplyId = I.ApplyID ' + CHAR(13)
	SET @strSQL=@strSQL+ '	WHERE I.P_ID = '+ CAST(@uID AS varchar(10)) + CHAR(13)
	SET @strSQL=@strSQL+ '), Interview_CTE AS ( ' + CHAR(13)
	SET @strSQL=@strSQL+ '	SELECT DISTINCT T.JP_ID ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, CASE WHEN S.InterviewType < 2 THEN 1 ELSE 0 END AS [General Interview], S.ScheduleDate--, R.ReasonId, R.ReplyText ' + CHAR(13)
	SET @strSQL=@strSQL+ ' 	, CASE WHEN S.InterviewType = 2 THEN 1 ELSE 0 END AS [Live Interview] , CASE WHEN S.InterviewType = 4 THEN 1 ELSE 0 END AS [Online Test] ' + CHAR(13)
	SET @strSQL=@strSQL+ '     , ROW_NUMBER()OVER(PARTITION BY T.JP_ID ORDER BY (CASE WHEN S.InterviewType < 2 THEN 1 ELSE 0 END) DESC , S.ScheduleDate DESC) As SL ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	FROM TopScore_CTE I ' + CHAR(13)
	SET @strSQL=@strSQL+ '	FROM Application_CTE I ' + CHAR(13)
	SET @strSQL=@strSQL+ '		INNER JOIN rp.TestSteps T ON I.JP_ID = T.JP_ID ' + CHAR(13)
	SET @strSQL=@strSQL+ '		INNER JOIN rp.Schedule S ON T.stId = S.stId ' + CHAR(13)
	SET @strSQL=@strSQL+ '		INNER JOIN rp.ApplicantProcess A ON S.schId = A.SchId AND  I.ApplyID = A.ApplyId AND A.Notify=1 ' + CHAR(13)  
	SET @strSQL=@strSQL+ '	WHERE I.P_ID = '+ CAST(@uID AS varchar(10)) +' AND S.ScheduleDate > GETDATE()'+ CHAR(13)
	SET @strSQL=@strSQL+ '), Interview_L AS ( ' + CHAR(13)

	--Meharaz
	SET @strSQL=@strSQL+ '	SELECT I.JP_ID,I.ScheduleDate,I.[Live Interview],I.[Online Test] from Interview_CTE I' + CHAR(13)
	--Meharaz

	--Meharaz
	--SET @strSQL=@strSQL+ '	SELECT DISTINCT T.JP_ID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	, CASE WHEN S.InterviewType = 2 THEN 1 ELSE 0 END AS [Live Interview], S.ScheduleDate , CASE WHEN S.InterviewType = 4 THEN 1 ELSE 0 END AS [Online Test] ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	, ROW_NUMBER()OVER(PARTITION BY T.JP_ID ORDER BY (CASE WHEN S.InterviewType = 2 THEN 1 ELSE 0 END) DESC , S.ScheduleDate DESC) As SL ' + CHAR(13)
	----SET @strSQL=@strSQL+ '	FROM TopScore_CTE I ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	FROM Application_CTE I ' + CHAR(13)
	--SET @strSQL=@strSQL+ '		INNER JOIN rp.TestSteps T ON I.JP_ID = T.JP_ID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '		INNER JOIN rp.Schedule S ON T.stId = S.stId ' + CHAR(13)
	--SET @strSQL=@strSQL+ '		INNER JOIN rp.ApplicantProcess A ON S.schId = A.SchId AND  I.ApplyID = A.ApplyId  AND A.Notify=1 ' + CHAR(13) 
	--SET @strSQL=@strSQL+ '	WHERE I.P_ID = '+ CAST(@uID AS varchar(10))  +' AND S.ScheduleDate > GETDATE()'+ CHAR(13)
   --Meharaz


	SET @strSQL=@strSQL+ '), VdoResume As ( ' + CHAR(13)
	SET @strSQL=@strSQL+ '	SELECT P_ID, AllowToShow FROM bdjResumes.vdo.VideoResumes WHERE TotalAnswered > 0 AND P_ID =  '+ CAST(@uID AS varchar(10)) + CHAR(13)

    SET @strSQL=@strSQL+ '),CHAT As (  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	SELECT C.JP_ID,C.cnvId FROM Application_CTE I INNER JOIN bdjCorporate.rp.empConversation C ON I.JP_ID= C.JP_ID WHERE  c.P_ID =  '+ CAST(@uID AS varchar(10)) + CHAR(13)

	SET @strSQL=@strSQL+ '	), CHAT_Unread_Message As (  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	SELECT distinct C.JP_ID,count(*) over() as unReadMessage FROM   ' + CHAR(13)
	SET @strSQL=@strSQL+ '	Application_CTE I   ' + CHAR(13)
	SET @strSQL=@strSQL+ '	INNER JOIN bdjCorporate.rp.empConversation C ON I.JP_ID= C.JP_ID  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	INNER JOIN  bdjCorporate.rp.empConversationChat cc ON c.cnvId=cc.cnvId and c.P_ID=I.p_id  and cc.cnvcSenderType=''R'' and (cc.ReadOn is null or cc.ReadOn='''')  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	WHERE  C.P_ID =  '+ CAST(@uID AS varchar(10)) + CHAR(13)
	SET @strSQL=@strSQL+ ' ) ,percentageCTE AS (' + CHAR(13)
	SET @strSQL=@strSQL+ '    SELECT i.JP_ID, COUNT(DISTINCT CASE WHEN i.Score > a.Score THEN i.applyid END) AS C,COUNT(i.applyid) AS a' + CHAR(13)
	SET @strSQL=@strSQL+ '    FROM Application_CTE a ' + CHAR(13)
	SET @strSQL=@strSQL+ '    LEFT JOIN bdjCorporate..DBO_JOB_INBOX i ON a.JP_ID = i.JP_ID' + CHAR(13)
	SET @strSQL=@strSQL+ '    GROUP BY i.JP_ID' + CHAR(13)
	SET @strSQL=@strSQL+ ' ), jobprocess as (' + CHAR(13)
	SET @strSQL=@strSQL+ '    select a.JP_ID,count(case when a.applyid is not null then 1 end) c' + CHAR(13)
	SET @strSQL=@strSQL+ ' 	 from Application_CTE a' + CHAR(13)
	SET @strSQL=@strSQL+ ' 	 INNER JOIN dbo_job_inbox i on a.JP_ID = i.JP_ID' + CHAR(13)
	SET @strSQL=@strSQL+ ' 	 INNER JOIN rp.applicantprocess a1 on i.applyid=a1.applyid' + CHAR(13)
	SET @strSQL=@strSQL+ ' 	 group by a.JP_ID' + CHAR(13)
	SET @strSQL=@strSQL+ ' )' + CHAR(13)

	--SET @strSQL=@strSQL+ ' SELECT JP_ID, CAST((C * 100.0 / NULLIF(a, 0)) AS DECIMAL(18, 2)) AS percentage' + CHAR(13)
	--SET @strSQL=@strSQL+ 'FROM percentageCTE' + CHAR(13)
	--SET @strSQL=@strSQL+ ')' + CHAR(13)
	SET @strSQL=@strSQL+ 'SELECT DISTINCT J.CP_ID,J.JP_ID,T.P_DATE  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, Company = (CASE WHEN (J.JobLang = 1 OR (J.JobLang = 3 And ''EN'' = ''EN'')) THEN (CASE WHEN (J.CompanyName IS NULL OR J.CompanyName = '''') THEN JB.CompanyNameBng ELSE J.CompanyName END) ELSE (CASE WHEN (JB.CompanyNameBng IS NULL OR JB.CompanyNameBng = '''') THEN J.CompanyName ELSE JB.CompanyNameBng END) END) ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, CASE WHEN (J.JobLang = 1 OR (J.JobLang = 3 And ''EN'' = ''EN'')) THEN J.JobTitle ELSE JB.Title END As JobTitle ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, T.ExpectedSalary, j.Deadline, T.Summary_Viewed, J.JobLang ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, '+ CAST(@TotalJobs AS varchar(10)) +'  AS TotalJob, T.EmpResponse ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, '+ CAST(@NotContacted AS varchar(10)) +' as NotCotatct  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	,  '+ CAST(@Contacted AS varchar(10)) +'  as Cotacted ' + CHAR(13)
	SET @strSQL=@strSQL+ '	,  '+ CAST(@Hired AS varchar(10)) +'  as Haired ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, T.AssessmentNeeded, (SELECT COUNT(1) FROM rp.ApplicantProcess WHERE ApplyID = T.ApplyID AND Notify=1 ) As Response, (SELECT COUNT(1) FROM rp.ApplicantsResponse WHERE ApplyID = T.ApplyID and Activity =0 ) as Uneen ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, J.MinSalary, J.MaxSalary  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, case when IA. deleted=0 and IA.FinalSubmitted=0  then 1 when  (IA. deleted=0 and IA.FinalSubmitted=1) or DATEADD(month, 2, II.deadline)>=CONVERT(date, getdate()) then 2 else 0 end ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, J.IsVDOResume As [Video Resume Required], V.[Vdo Invitation] , N.[General Interview], L.[Live Interview] ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, (CASE WHEN (SELECT P_ID FROM VdoResume) IS NOT NULL THEN 1 ELSE 0 END) As Vdo_Resume, T.Priority, T.ApplyID ' + CHAR(13)
	--SET @strSQL=@strSQL+ '	, NoOfPriority = (select count(CASE WHEN (p.PrioritySetDate >= DATEADD(DD, 0 - DATEPART(DW, GETDATE()),GETDATE()) And inb.Priority = 1) THEN 1 ELSE 0 END) from  PriorityLevelApplications P ,JobInbox_CTE inb where  inb.ApplyID = P.ApplyID and inb.p_id=T.p_id) ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, NoOfPriority = (select count(CASE WHEN (p.PrioritySetDate >= DATEADD(DD, 0 - DATEPART(DW, GETDATE()),GETDATE()) And inb.Priority = 1) THEN 1 ELSE 0 END) from  PriorityLevelApplications P, Application_CTE inb where  inb.ApplyID = P.ApplyID and inb.p_id=T.p_id) ' + CHAR(13)
	SET @strSQL=@strSQL+ '	, p.Jp_Id, (SELECT COUNT(1) FROM bdjResumes..Log_CancelApplication WHERE JP_ID = T.JP_ID And P_ID = T.P_ID) As IsCancelApply, T.Score ' + CHAR(13)
	
	--IF (@ShowOrHide = 1)
	--    SET @strSQL=@strSQL+ '	, T.Score' + CHAR(13)
	--ELSE IF (@ShowOrHide = 0)
	--   SET @strSQL=@strSQL+ '	, 0 as Score' + CHAR(13)

	
	SET @strSQL=@strSQL+ ', T.PositionStatus , CASE WHEN R.P_ID IS NOT NULL OR R.P_ID <> '''' THEN 1 ELSE 0 END AS PersonalResume ' + CHAR(13)
	
	-----Meharaz----

	--SET @strSQL=@strSQL+ ' , CASE WHEN (N.JP_ID IS NOT NULL OR N.JP_ID <> '''' OR L.JP_ID IS NOT NULL OR L.JP_ID <> '''' OR V.JP_ID IS NOT NULL OR V.JP_ID <> '''') AND (N.ScheduleDate > GETDATE() OR L.ScheduleDate > GETDATE() OR V.Deadline > GETDATE()) THEN 1 ELSE 0 END AS InterviewInvitation ' + CHAR(13)
	
	SET @strSQL=@strSQL+ ' 	 , CASE WHEN (N.[General Interview] = 1 AND N.ScheduleDate > GETDATE()) THEN 1 WHEN (L.[Live Interview] = 1 AND L.ScheduleDate > GETDATE()) THEN 2 WHEN (L.[Online Test] = 1 AND L.ScheduleDate > GETDATE()) THEN 3 WHEN (V.[Vdo Invitation] = 1 AND V.Deadline > GETDATE()) THEN 4 ELSE 0 END AS InterviewInvitation' + CHAR(13)
	
	--- Meharaz ------
	SET @strSQL=@strSQL+ '	, AR.ReasonId, AR.ReplyText , case when  T.NoOfApply is null or  T.NoOfApply=0 then pl.a else  T.NoOfApply end  NoOfApply' + CHAR(13)

	
	--IF (@ShowOrHide = 1)
	--    SET @strSQL=@strSQL+ '	, T.NoOfApply ' + CHAR(13)
	--ELSE IF (@ShowOrHide = 0)
	--   SET @strSQL=@strSQL+ '	, 0 as NoOfApply' + CHAR(13)
	

	SET @strSQL=@strSQL+ '	, '+ CAST(@Offered AS varchar(10)) +'  as Offered, AR.ID AS JobStatusId ' + CHAR(13) 
	SET @strSQL=@strSQL+ '	, (CASE WHEN (SELECT AllowToShow FROM VdoResume) > 0 THEN 1 ELSE 0 END) As VdoResumeOpen ,C.cnvId,CUM.unReadMessage' + CHAR(13)
	SET @strSQL=@strSQL+ '	, CASE WHEN CC.P_ID IS NOT NULL OR CC.P_ID <> '''' Then 1 ELSE 0 END MessageInitiate ' + CHAR(13)
	SET @strSQL=@strSQL+ '		, case when T.P_ID = pb.P_ID and T.JP_ID = pb.JP_ID then 1 Else 0 END as [is Boosted]' + CHAR(13)
	SET @strSQL=@strSQL+ '		, CASE WHEN T.ApplyID =  A.ApplyId THEN 1 ELSE 0 END AS isNotify' + CHAR(13)
    SET @strSQL=@strSQL+ '		, CASE WHEN J.JP_ID = CA.JP_ID  THEN 1 ELSE 0 END AS Detailed_view, CAST((pl.C * 100.0 / NULLIF(pl.a, 0)) AS DECIMAL(18, 2)) AS TopApplicantMatchingPercentage' + CHAR(13)	
	SET @strSQL=@strSQL+ '	,case when jp.c is not null then 1 else 0 end as isProcessed ' + CHAR(13)

	SET @strSQL=@strSQL+ '	FROM dbo_JOBPOSTINGS J ' + CHAR(13) 
	--SET @strSQL=@strSQL+ '	INNER JOIN TopScore_CTE T ON T.JP_ID=J.JP_ID ' + CHAR(13)  
	SET @strSQL=@strSQL+ '	INNER JOIN Application_CTE T ON T.JP_ID=J.JP_ID ' + CHAR(13)  
    SET @strSQL=@strSQL+ '	INNER JOIN percentageCTE pl on J.JP_ID = pl.JP_ID ' + CHAR(13)  
	SET @strSQL=@strSQL+ '	LEFT JOIN jobprocess jp on j.JP_ID =jp.JP_ID ' + CHAR(13) 
	SET @strSQL=@strSQL+ '	LEFT JOIN CHAT_Unread_Message CUM ON T.JP_ID=CUM.JP_ID  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	LEFT JOIN DBO_BNG_JOBPOSTINGS JB ON j.JP_ID = JB.JP_ID ' + CHAR(13) 
	SET @strSQL=@strSQL+ '	LEFT JOIN vdo.InterviewInfo II ON T.JP_ID = II.JP_ID And II.Active = 1 ' + CHAR(13) 
	SET @strSQL=@strSQL+ '	LEFT JOIN vdo.InterviewApplicants IA ON T.ApplyId = IA.Applyid  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	LEFT JOIN VDO_CTE V ON T.JP_ID = V.JP_ID  AND V.SL = 1  ' + CHAR(13)
	SET @strSQL=@strSQL+ '	LEFT JOIN Interview_CTE N ON T.JP_ID = N.JP_ID AND N.[General Interview] = 1  AND N.SL = 1 ' + CHAR(13)
	SET @strSQL=@strSQL+ '	LEFT JOIN Interview_L L ON T.JP_ID = L.JP_ID --AND L.[Live Interview] = 1 AND L.SL = 1 ' + CHAR(13) 
	SET @strSQL=@strSQL+ '	LEFT JOIN bdjCorporate..PriorityLevelApplications P on T.ApplyID = P.ApplyID ' + CHAR(13)  
	SET @strSQL=@strSQL+ '	LEFT JOIN bdjResumeFiles..ResumeFiles R ON T.P_ID = R.P_ID ' + CHAR(13)  
	SET @strSQL=@strSQL+ '	LEFT JOIN  AppliedJobStatus AR ON T.ApplyID = AR.ApplyId ' + CHAR(13)  
    SET @strSQL=@strSQL+ '	LEFT JOIN CHAT C ON T.JP_ID=C.JP_ID  ' + CHAR(13) 
	SET @strSQL=@strSQL+ '	LEFT JOIN bdjCorporate.rp.empConversation CC ON T.P_ID = CC.P_ID AND T.JP_ID = CC.JP_ID  ' + CHAR(13) 
    SET @strSQL=@strSQL+ '  LEFT JOIN bdjResumes..UserApplyLimit UA on  R.P_ID = UA.P_ID' + CHAR(13) 
    SET @strSQL=@strSQL+ '  LEFT JOIN bdjResumes.mnt.CandidatePackages cp on UA.pkId = cp.cpkId' + CHAR(13) 
	SET @strSQL=@strSQL+ ' 	LEFT JOIN bdjResumes.[mnt].[ApplicationBoostingDetails] pb on T.P_ID = pb.P_ID and T.JP_ID = pb.JP_ID' + CHAR(13) 
	SET @strSQL=@strSQL+ ' LEFT JOIN rp.ApplicantProcess A ON  T.ApplyID = A.ApplyId ' + CHAR(13) 
	SET @strSQL=@strSQL+ ' LEFT JOIN bdjCorporate..CompanyViewedCV CA ON  J.JP_ID = CA.JP_ID and CA.P_ID = '+ CAST(@uID AS varchar(10)) +' and J.CP_ID = CA.CP_ID ' + CHAR(13) 

	SET @strSQL=@strSQL+ '	WHERE 1 = 1 ' + CHAR(13)  
	

	SET @strSQL=@strSQL+ 'ORDER BY T.P_DATE DESC  ' + CHAR(13) 

	--EXEC(@strSQL)
	PRINT CAST(@strSQL AS Text)
	--PRINT CAST(@strSQL As text)
	SET NOCOUNT OFF
END