USE [arcCorporate]
GO
/****** Object:  StoredProcedure [dbo].[USP_CorporateJobsWithApplicantNumber_ARC_VER8]    Script Date: 3/7/2024 11:58:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************
** File  :	StoredProcedure [dbo].[USP_CorporateJobsWithApplicantNumber_ARC_VER8]
** Name  :	USP_CorporateJobsWithApplicantNumber_ARC_VER8 35450,1,6, '','',''
** Desc  :  
** Author:	Mizan
** Date  :	July 18, 2021
******************************************************************************************/

--ALTER PROCEDURE [dbo].[USP_CorporateJobsWithApplicantNumber_ARC_VER8]
--(
Declare
	@ComId int = 20744
	, @PageNo int = 1
	, @PageSize int = 20
	, @JobTitle varchar(50) = ''
	, @DateFrom varchar(10) = ''
	, @DateTo varchar(10) = ''
	, @LiveJob bit = 0
	, @UserID int = 0
	, @Admin bit = 0
--)
--AS
BEGIN
	DECLARE @StartingIndex int = 0,
		@Query As varchar(5000) = '',
		@ProceedToPublishDate As varchar(100) = '',
		@Keyword As varchar(50) = '',
		@Record As int = 0,
		@LastPost As varchar(10) = '',
		@CurrentDate As varchar(10) = ''
	
	SET @CurrentDate = CONVERT(varchar(10),GETDATE(),101)
	SELECT @LastPost=CONVERT(varchar(10),MAX(PostedOn),101) FROM bdjCorporate..JobMatchCount WHERE CP_ID = @ComId


	IF @PageNo > 0
		SET @StartingIndex = (@PageNo -1) * @PageSize




	SET @Query = @Query + ';WITH mainCTE AS(' + CHAR(13)

	SET @Query = @Query + '	select J.JP_ID,count(ID) as ID' + CHAR(13)
	SET @Query = @Query + '	from dbo_JOBPOSTINGS_arc j' + CHAR(13)
	SET @Query = @Query + '	INNER JOIN JobStepsLog_arc ja on j.jp_id=ja.jp_id' + CHAR(13)
	SET @Query = @Query + '	where ja.StepNo IN (1,2,4) And ja.IsBangla = 1 AND J.CP_ID = 20744 And J.Drafted = 0 And J.Deleted=0 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL)'+ CHAR(13)
	SET @Query = @Query + '	group by J.JP_ID' + CHAR(13)
	SET @Query = @Query + '	having count(ID) = 3' + CHAR(13)

	SET @Query = @Query + '),JobList_CTE AS (' + CHAR(13)
	SET @Query = @Query + '	SELECT J.JP_ID, CASE WHEN J.JobLang =2 THEN BJ.Title ELSE J.JobTitle END As JobTitle, J.ProceedToPublishDate, J.Deadline' + CHAR(13)
	SET @Query = @Query + '		, J.Verified, J.PublishDate, J.Closed, COUNT(1) OVER() As TotalJob, J.CVReceivingOptions, J.PostingDate' + CHAR(13)
	--SET @Query = @Query + '		, COUNT(IA.ApplyID) As TotalVDOInterviewInvited' + CHAR(13)
	--SET @Query = @Query + '		, COUNT(CASE WHEN IA.ApplyID IS NOT NULL And IA.FinalSubmitted = 1 THEN IA.ApplyID END) As TotalVDOSubmitted' + CHAR(13)
	--SET @Query = @Query + '		, CASE WHEN J.JobLang=2 And (select COUNT(1) from JobStepsLog_arc WHERE JP_ID = j.jp_id And StepNo IN (1,2,4) And IsBangla = 1)=3 THEN 1 ELSE 0 END As StepLog' + CHAR(13)
	SET @Query = @Query + '		, CASE WHEN J.JobLang=2 And   J.JP_ID = m.JP_ID THEN 1 ELSE 0 END As StepLog' + CHAR(13)

	SET @Query = @Query + '	FROM dbo_JOBPOSTINGS_arc J ' + CHAR(13)
	
	IF (@UserID > 0 And @Admin = 0)
		SET @Query = @Query + '		INNER JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID And (AccessForever = 1 OR AccessTillDate >= GETDATE()) And UserID = ' + CAST(@UserID As varchar(10)) + '' + CHAR(13)

	SET @Query = @Query + '		LEFT JOIN DBO_BNG_JOBPOSTINGS_arc BJ on j.jp_id=BJ.jp_id ' + CHAR(13)
	SET @Query = @Query + '				LEFT JOIN mainCTE m on J.JP_ID = m.JP_ID' + CHAR(13)

	--SET @Query = @Query + '		LEFT JOIN vdo.InterviewInfo II on j.jp_id = II.jp_id' + CHAR(13)
	--SET @Query = @Query + '		LEFT JOIN vdo.InterviewApplicants IA ON II.intID = IA.intID' + CHAR(13)
	SET @Query = @Query + '	WHERE J.CP_ID = ' + CAST(@ComId As varchar(10)) + ' And J.Drafted = 0 And J.Deleted=0 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL)' + CHAR(13)
	
	IF @LiveJob = 1
		SET @Query = @Query + '		And J.DeadLine >= ''' + @CurrentDate + '''' + CHAR(13)
	
	IF (@JobTitle IS NOT NULL And @JobTitle <> '')
		SET @Query = @Query + '		And (J.JobTitle LIKE ''%' + @JobTitle + '%'' OR BJ.Title like ''%' + @JobTitle + '%'')' + CHAR(13)
	
	IF (@DateFrom <> '' And @DateFrom IS NOT NULL)
		SET @Query = @Query + '		And J.ProceedToPublishDate >= ''' + @DateFrom + '''' + CHAR(13)
	
	IF (@DateTo <> '' And @DateTo IS NOT NULL)
		SET @Query = @Query + '		And J.ProceedToPublishDate <= ''' + @DateTo + '''' + CHAR(13)
	
	SET @Query = @Query + '	GROUP BY J.JobLang,m.JP_ID, BJ.Title, J.JP_ID, J.JobTitle, J.ProceedToPublishDate, J.Deadline, J.Verified, J.PublishDate, J.Closed, J.CVReceivingOptions, J.PostingDate' + CHAR(13)
	SET @Query = @Query + '	ORDER BY J.ProceedToPublishDate DESC, J.JP_ID DESC offset ' + CAST(@StartingIndex As varchar(5)) + ' rows fetch next ' + CAST(@PageSize As varchar(5)) + ' rows only' + CHAR(13)
	SET @Query = @Query + ')' + CHAR(13)
	SET @Query = @Query + 'SELECT J.JP_ID, J.JobTitle, J.ProceedToPublishDate, J.Deadline, COUNT(i.JP_ID) AS T' + CHAR(13)
	SET @Query = @Query + '	, COUNT(case when i.Viewed=1 And p.ApplyID IS NULL And (i.rejected = 0 OR i.rejected IS NULL) then 1 else null end) AS Viewed' + CHAR(13)
	SET @Query = @Query + '	, COUNT(case when p.levelStatus=1 and p.Rejected = 0 then 1 else null end) AS Shortlisted' + CHAR(13)
	SET @Query = @Query + '	, J.Verified, J.PublishDate, COUNT(CASE WHEN i.Score = 100 THEN i.ApplyID END) AS MatchCount' + CHAR(13)
	SET @Query = @Query + '	, COUNT(CASE WHEN i.p_date>= JLVD.ViewedOn THEN 1 ELSE null END) As NEW1, J.Closed, 0 As Interview, 0 As FinalList, 0 As Rejected, J.TotalJob' + CHAR(13)
	--SET @Query = @Query + '	, TotalVDOInterviewInvited, TotalVDOSubmitted' + CHAR(13)
	SET @Query = @Query + '	, COUNT(V.ApplyID) As TotalVDOInterviewInvited' + CHAR(13)
	SET @Query = @Query + '	, COUNT(CASE WHEN V.ApplyID IS NOT NULL And V.FinalSubmitted = 1 THEN V.ApplyID END) As TotalVDOSubmitted' + CHAR(13)
	SET @Query = @Query + '	, J.StepLog, NewSystem = (SELECT COUNT(1) FROM rp.TestSteps_arc WHERE JP_ID = J.JP_ID), II.intID' + CHAR(13) --V.intID
	SET @Query = @Query + '	, CASE WHEN J.CVReceivingOptions LIKE ''%1%'' THEN 1 ELSE 0 END As ApplyOnline,  J.PostingDate' + CHAR(13)
	--SET @Query = @Query + '	, CASE WHEN V.JP_ID > 0 THEN ''Yes'' ELSE ''No'' END As  IsVDOInterview' + CHAR(13)
	SET @Query = @Query + 'FROM JobList_CTE J' + CHAR(13)
	SET @Query = @Query + '	LEFT JOIN dbo_job_inbox_arc i on j.jp_id=i.jp_id --and i.jp_id in (select jp_id from JobList_CTE)' + CHAR(13)
	SET @Query = @Query + '	LEFT JOIN rp.ApplicantProcess_arc p ON i.Applyid=p.applyid And p.LevelStatus=1' + CHAR(13)
	SET @Query = @Query + '	LEFT JOIN bdjCorporate..JobLastViewedDate JLVD ON JLVD.JP_ID=J.JP_ID' + CHAR(13)
	--SET @Query = @Query + '	LEFT JOIN JobMatchCount m ON m.JP_ID = J.JP_ID' + CHAR(13)
	SET @Query = @Query + '	LEFT JOIN vdo.InterviewInfo_arc AS II on j.jp_id=ii.jp_id' + CHAR(13) --Probal
	SET @Query = @Query + '	LEFT JOIN vdo.InterviewApplicants_arc AS V ON II.intId = V.intId and v.applyid=i.applyid' + CHAR(13) --Probal
	--SET @Query = @Query + '	LEFT JOIN vdo.vwInvitedSubmitVDO V ON V.JP_ID = J.JP_ID --And I.Applyid = V.Applyid' + CHAR(13) --Probal
	--SET @Query = @Query + 'GROUP BY m.MatchCount, m.JP_ID, J.JP_ID, J.JobTitle, J.ProceedToPublishDate, J.Deadline, J.Verified, J.PublishDate, J.Closed, J.TotalJob, J.StepLog, II.intID--, TotalVDOInterviewInvited, TotalVDOSubmitted' + CHAR(13) --V.intID
	SET @Query = @Query + 'GROUP BY J.JP_ID, J.JobTitle, J.ProceedToPublishDate, J.Deadline, J.Verified, J.PublishDate, J.Closed, J.TotalJob, J.StepLog, II.intID--, TotalVDOInterviewInvited, TotalVDOSubmitted' + CHAR(13) --V.intID
	SET @Query = @Query + '	, CASE WHEN J.CVReceivingOptions LIKE ''%1%'' THEN 1 ELSE 0 END,  J.PostingDate' + CHAR(13)
	----SET @Query = @Query + '	, CASE WHEN V.JP_ID > 0 THEN ''Yes'' ELSE ''No'' END' + CHAR(13)
	SET @Query = @Query + 'ORDER BY J.ProceedToPublishDate DESC, J.JP_ID DESC' + CHAR(13)

	SET NOCOUNT ON
	
	PRINT @Query
	EXEC(@Query)

	SET NOCOUNT OFF
END

