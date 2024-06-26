USE [bdjCorporate]
GO
/****** Object:  StoredProcedure [dbo].[USP_APPS_DashBoard_List_Test]    Script Date: 3/6/2024 12:01:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************
** File  :   StoredProcedure [dbo].[USP_APPS_DashBoard_List]
** Name  :   dbo.USP_APPS_DashBoard_List
** Desc  :   @Type: N=New List; P=Posted Job List; L=Live Job List; R=Recent (Last 01 year) Job List
**			 D=Drafted Job List; A=Archive Job List
** Author:   Bipul
** Modified:   Mehedi
** Date  :   June 25, 2023
******************************************************************************************/

ALTER PROCEDURE [dbo].[USP_APPS_DashBoard_List_Test]
(
	--DECLARE 
	@CP_ID int = 35450 --15131
	, @Type char(1) = 'P' --N=New List; P=Posted Job List; L=Live Job List; R=Recent (Last 01 year) Job List; D=Drafted Job List; A=Archive Job List
	, @PageNo int = 1
	, @PageSize int = 6
	, @JobTitle As varchar(20) = ''
	, @UserID int = 122286 -- 147500
	, @Admin bit = 1
	, @StartDate As varchar(10) = ''-- '01/01/2023'
	, @EndDate As varchar(10) = '' --'07/13/2023' 
)
AS
BEGIN
	DECLARE @Select As varchar(2000) = ''
		, @From As varchar(1000) = ''
		, @CreatedOn As varchar(25) = ''
		, @Where As varchar(300) = ''
		, @GroupBy As varchar(400) = ''
		, @OrderBy As varchar(200) = ''
		, @SQL As varchar(5000) = ''

	DECLARE @StartingIndex int = 1

	IF @PageNo > 0
		SET @StartingIndex = (@PageNo -1) * @PageSize

	SELECT @CreatedOn = CP.PostedOn
	FROM ContactPersons CP
		INNER JOIN CorporateUserAccess CUA ON CP.ContactID = CUA.ContactID
	WHERE CUA.UserID = @UserID
	IF @Type = 'N' OR @Type = 'P' OR @Type = 'L' OR @Type = 'R' OR @Type = 'D'
		BEGIN
			SET @Select  = ';WITH Job_CTE As (' + CHAR(13)
			SET @Select = @Select + '	SELECT J.JP_ID' + CHAR(13)
			SET @Select = @Select + '	FROM dbo_JOBPOSTINGS J ' + CHAR(13)		
			IF (@UserID > 0 And @Admin = 0)
				SET @Select = @Select + '		INNER JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID And (AccessForever = 1 OR AccessTillDate >= CONVERT(varchar(10), GETDATE(), 101)) And UserID = ' + CAST(@UserID As varchar(10)) + '' + CHAR(13)
			IF @Type = 'D'
				SET @Select = @Select + '	WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(10)) + ' And J.Drafted = 1 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL)' + CHAR(13)
			ELSE
				SET @Select = @Select + '	WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(10)) + ' And J.Drafted = 0 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL)' + CHAR(13)
			SET @Select = @Select + '	UNION' + CHAR(13)
			SET @Select = @Select + '	SELECT J.JP_ID' + CHAR(13)
			SET @Select = @Select + '	FROM dbo_JOBPOSTINGS J ' + CHAR(13)
			SET @Select = @Select + '		LEFT JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID' + CHAR(13)
			IF @Type = 'D'
				SET @Select = @Select + '	WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(10)) + ' And J.Drafted = 1 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL) And UA.JP_ID IS NULL' + CHAR(13)
			ELSE
				SET @Select = @Select + '	WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(10)) + ' And J.Drafted = 0 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL) And UA.JP_ID IS NULL' + CHAR(13)
			SET @Select = @Select + '		And CAST(''' + @CreatedOn + ''' As smalldatetime) < CAST(GETDATE() AS smalldatetime)' + CHAR(13)
		END
	ELSE
		BEGIN
			SET @Select  = ';WITH Job_CTE As (' + CHAR(13)
			SET @Select = @Select + '	SELECT J.JP_ID' + CHAR(13)
			SET @Select = @Select + '	FROM arcCorporate..DBO_JOBPOSTINGS_arc J ' + CHAR(13)		
			IF (@UserID > 0 And @Admin = 0)
				SET @Select = @Select + '		INNER JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID And (AccessForever = 1 OR AccessTillDate >= CONVERT(varchar(10), GETDATE(), 101)) And UserID = ' + CAST(@UserID As varchar(10)) + '' + CHAR(13)
			SET @Select = @Select + '	WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(10)) + ' And J.Drafted = 0  And J.Deleted=0 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL)' + CHAR(13)
			SET @Select = @Select + '	UNION' + CHAR(13)
			SET @Select = @Select + '	SELECT J.JP_ID' + CHAR(13)
			SET @Select = @Select + '	FROM arcCorporate..DBO_JOBPOSTINGS_arc J ' + CHAR(13)
			SET @Select = @Select + '		LEFT JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID' + CHAR(13)	
			SET @Select = @Select + '	WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(10)) + ' And J.Drafted = 0  And J.Deleted=0 And (J.RegionalJob <> 4 OR J.RegionalJob IS NULL) And UA.JP_ID IS NULL' + CHAR(13)
			SET @Select = @Select + '		And CAST(''' + @CreatedOn + ''' As smalldatetime) < CAST(GETDATE() AS smalldatetime)' + CHAR(13)
		END
	SET @Select = @Select + '), New_CTE1 As ( ' + CHAR(13)	
	SET @Select = @Select + 'SELECT J.JP_ID, CASE WHEN J.JobLang = 2 THEN BJ.Title ELSE J.JobTitle END As JobTitle, J.Verified, J.Deadline, J.AdType, B.JType, J.Closed' + CHAR(13)

	IF @Type = 'A'
		SET @Select = @Select + '	, COUNT(I.ApplyID) ApplicantNo, COUNT(1) OVER() As TotalJob, J.ProceedToPublishDate, 0 As NEW' + CHAR(13)
	ELSE IF @Type = 'D'
		SET @Select = @Select + '	, COUNT(I.ApplyID) ApplicantNo, COUNT(1) OVER() As TotalJob, J.PostingDate, COUNT(CASE WHEN i.p_date>= JLVD.ViewedOn THEN 1 ELSE NULL END) As NEW' + CHAR(13)
	ELSE
		SET @Select = @Select + '	, COUNT(I.ApplyID) ApplicantNo, COUNT(1) OVER() As TotalJob, J.ProceedToPublishDate, COUNT(CASE WHEN i.p_date>= JLVD.ViewedOn THEN 1 ELSE NULL END) As NEW' + CHAR(13)
	
	SET @Select = @Select + '	, (SELECT NewDesign FROM DBO_COMPANY_PROFILES WHERE CP_ID = J.CP_ID) As NewDesign' + CHAR(13)
	SET @Select = @Select + '	, (SELECT COUNT(1) FROM rp.TestSteps WHERE JP_ID = J.JP_ID) As TotalStep' + CHAR(13)
	
	IF @Type = 'A'
		SET @Select = @Select + '	, C.ApropriateCandidate, C.Rank, 0 AS InProgress, J.PublishDate,CASE WHEN  (select COUNT(distinct StepNo) from JobStepsLog WHERE JP_ID = j.jp_id And StepNo IN (1,2,4) And IsBangla = CASE WHEN J.JobLang in (2,3) then 1 else 0 end  )  = 3 then 1 else 0 end As StepLog ' + CHAR(13) 
	ELSE
		SET @Select = @Select + '	, C.ApropriateCandidate, C.Rank, C.InProgress AS InProgress, J.PublishDate,CASE WHEN  (select COUNT(distinct StepNo) from JobStepsLog WHERE JP_ID = j.jp_id And StepNo IN (1,2,4) And IsBangla = CASE WHEN J.JobLang in (2,3) then 1 else 0 end  )  = 3 then 1 else 0 end As StepLog ' + CHAR(13) 
	SET @Select = @Select + '	, COUNT(CASE WHEN I.Hired = 1 THEN I.ApplyID END) TotalHired ' + CHAR(13)

	IF @Type = 'N' OR @Type = 'P' OR @Type = 'L' OR @Type = 'R' OR @Type = 'D'
		BEGIN
			SET @From = @From + 'FROM Job_CTE JC INNER JOIN dbo_JOBPOSTINGS J ON JC.JP_ID = J.JP_ID' + CHAR(13)

			--IF (@UserID > 0 And @Admin = 0)
			--	SET @From = @From + ' INNER JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID And (AccessForever = 1 OR AccessTillDate >= CONVERT(varchar(10), GETDATE(), 101)) And UserID = ' + CAST(@UserID As varchar(10)) + '' + CHAR(13)
			
			SET @From = @From + '	LEFT JOIN DBO_BNG_JOBPOSTINGS BJ ON J.JP_ID = BJ.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN dbo_job_inbox i ON J.JP_ID = I.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN JobBillInfo B ON J.JP_ID = B.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN JobLastViewedDate JLVD ON J.JP_ID = JLVD.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN rp.jobCloser C ON J.JP_ID = C.JP_ID' + CHAR(13)

		END
	ELSE
		BEGIN
			SET @From = @From + 'FROM Job_CTE JC INNER JOIN arcCorporate..DBO_JOBPOSTINGS_arc J ON JC.JP_ID = J.JP_ID' + CHAR(13)

			--IF (@UserID > 0 And @Admin = 0)
			--	SET @From = @From + ' INNER JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID And (AccessForever = 1 OR AccessTillDate >= CONVERT(varchar(10), GETDATE(), 101)) And UserID = ' + CAST(@UserID As varchar(10)) + '' + CHAR(13)
			
			SET @From = @From + '	LEFT JOIN arcCorporate..DBO_BNG_JOBPOSTINGS_arc BJ ON J.JP_ID = BJ.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN arcCorporate..dbo_job_inbox_arc i ON J.JP_ID = I.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN arcCorporate..JobBillInfo_arc B ON J.JP_ID = B.JP_ID' + CHAR(13)
			SET @From = @From + '	LEFT JOIN arcCorporate.rp.jobCloser_arc C ON J.JP_ID = C.JP_ID' + CHAR(13)
		END
	
	IF @JobTitle <> ''
		SET @Where = @Where + 'WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(8)) + ' And (BJ.Title LIKE ''%' + @JobTitle +  '%'' OR J.JobTitle LIKE ''%' + @JobTitle + '%'')' + CHAR(13)
	ELSE
		SET @Where = @Where + 'WHERE J.CP_ID = ' + CAST(@CP_ID As varchar(8))

	--IF (@StartDate <> '' And @StartDate IS NOT NULL)
	--	SET @Where = @Where + '		And J.ProceedToPublishDate >= ''' + @StartDate + '''' + CHAR(13)
	--IF (@EndDate <> '' And @EndDate IS NOT NULL)
	--	SET @Where = @Where + '		And J.ProceedToPublishDate <= ''' + @EndDate + '''' + CHAR(13) 

	IF (@StartDate <> '' And @StartDate IS NOT NULL And @Type = 'D')
		SET @Where = @Where + '		And J.PostingDate >= ''' + @StartDate + '''' + CHAR(13)
	ELSE IF (@StartDate <> '' And @StartDate IS NOT NULL)
		SET @Where = @Where + '		And J.ProceedToPublishDate >= ''' + @StartDate + '''' + CHAR(13)
	IF (@EndDate <> '' And @EndDate IS NOT NULL And @Type = 'D')
		SET @Where = @Where + '		And J.PostingDate <= ''' + @EndDate + '''' + CHAR(13) 
	ELSE IF (@EndDate <> '' And @EndDate IS NOT NULL)
		SET @Where = @Where + '		And J.ProceedToPublishDate <= ''' + @EndDate + '''' + CHAR(13) 

	IF @Type = 'N'
		SET @Where = @Where + ' And J.Drafted = 0 --And I.p_date >= JLVD.ViewedOn' + CHAR(13)
	ELSE IF @Type = 'P' OR @Type = 'A'
		BEGIN
			IF @Type = 'A'
				SET @Where = @Where + ' And J.Drafted = 0 And J.Deleted = 0' + CHAR(13)
			ELSE
				SET @Where = @Where + ' And J.Drafted = 0' + CHAR(13)
		END
	ELSE IF @Type = 'L'
		SET @Where = @Where + ' And J.Drafted = 0 And J.Deadline >= ''' + CONVERT(varchar(10), GETDATE(), 101) + ''' And J.Verified = 1' + CHAR(13)
	ELSE IF @Type = 'R'
		SET @Where = @Where + ' And J.Drafted = 0 And J.ProceedToPublishDate >= ''' + CONVERT(varchar(10), DATEADD(YEAR, -1, GETDATE()), 101) + '''' + CHAR(13)
	ELSE IF @Type = 'D'
		SET @Where = @Where + ' And J.Drafted = 1' + CHAR(13)
	
	IF @Type = 'D'
		BEGIN
			SET @GroupBy = @GroupBy + 'GROUP BY J.CP_ID, J.JP_ID, CASE WHEN J.JobLang = 2 THEN BJ.Title ELSE J.JobTitle END, J.Verified,J.PublishDate, j.Deadline, j.AdType, B.JType, j.Closed, J.PostingDate,C.ApropriateCandidate, C.Rank, C.InProgress,J.JobLang ' + CHAR(13)

			--SET @OrderBy = @OrderBy + ' ORDER BY j.jP_ID desc, J.PostingDate desc OFFSET ' + CAST(@StartingIndex As varchar(10)) + ' ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY ' + CHAR(13)
		END
	IF @Type = 'N' OR @Type = 'P' OR @Type = 'L' OR @Type = 'R'
		BEGIN
			SET @GroupBy = @GroupBy + 'GROUP BY J.CP_ID, J.JP_ID, CASE WHEN J.JobLang = 2 THEN BJ.Title ELSE J.JobTitle END, J.Verified,J.PublishDate, j.Deadline, j.AdType, B.JType, j.Closed, J.ProceedToPublishDate,C.ApropriateCandidate, C.Rank, C.InProgress,J.JobLang ' + CHAR(13)

			--SET @OrderBy = @OrderBy + ' ORDER BY j.jP_ID desc, J.ProceedToPublishDate desc OFFSET ' + CAST(@StartingIndex As varchar(10)) + ' ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY ' + CHAR(13)
		END
	IF @Type = 'A'
	BEGIN
			SET @GroupBy = @GroupBy + 'GROUP BY J.CP_ID, J.JP_ID, CASE WHEN J.JobLang = 2 THEN BJ.Title ELSE J.JobTitle END, J.Verified,J.PublishDate, j.Deadline, j.AdType, B.JType, j.Closed, J.ProceedToPublishDate,C.ApropriateCandidate, C.Rank,J.JobLang ' + CHAR(13)

			--SET @OrderBy = @OrderBy + ' ORDER BY j.jP_ID desc, J.ProceedToPublishDate desc OFFSET ' + CAST(@StartingIndex As varchar(10)) + ' ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY ' + CHAR(13)
		END
	
	IF @Type = 'N'
		BEGIN
			--SET @SQL = ';WITH New_CTE As (' + CHAR(13)
			SET @SQL = @SQL + @Select + @From + @Where + @GroupBy
			SET @SQL = @SQL +'), New_CTE2 As (' + CHAR(13)
			SET @SQL = @SQL +' SELECT J.JP_ID, COUNT(A.ApplyID) AS Total, A.LevelStatus, ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY A.LevelStatus DESC) r
							FROM Job_CTE JC
							INNER JOIN  dbo_job_inbox J ON JC.JP_ID = J.JP_ID
							INNER JOIN rp.ApplicantProcess A ON J.ApplyID = A.ApplyID
							WHERE A.LevelStatus <=6
							GROUP BY J.JP_ID,A.LevelStatus),'+ CHAR(13)
			SET @SQL = @SQL +' New_CTE3 As (' + CHAR(13)
			SET @SQL = @SQL +' SELECT JP_ID, Total, LevelStatus FROM New_CTE2 where r = 1) '+ CHAR(13)
		--	SET @SQL = @SQL + 'SELECT JP_ID, JobTitle, Verified, Deadline, AdType, JType, Closed, ApplicantNo, COUNT(1) OVER() As TotalJob, ProceedToPublishDate, New, NewDesign, TotalStep' + CHAR(13)
		--	SET @SQL = @SQL + 'FROM New_CTE ' + CHAR(13)
		--	SET @SQL = @SQL + 'WHERE NEW > 0 ' + CHAR(13)
		--	SET @SQL = @SQL + 'ORDER BY ProceedToPublishDate DESC, JP_ID DESC OFFSET ' + CAST(@StartingIndex As varchar(10)) + ' ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY ' + CHAR(13)
		END
	ELSE
		BEGIN
			SET @SQL = @Select + @From + @Where + @GroupBy
			SET @SQL = @SQL + '), ' + CHAR(13)
			SET @SQL = @SQL +' New_CTE2 As (' + CHAR(13)
			SET @SQL = @SQL +' SELECT J.JP_ID, COUNT(A.ApplyID) AS Total, A.LevelStatus, ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY A.LevelStatus)r
								FROM Job_CTE jc inner join dbo_job_inbox J ON jc.jp_id=j.jp_id
								INNER JOIN rp.ApplicantProcess A ON J.ApplyID = A.ApplyID
								WHERE A.LevelStatus <=6
								GROUP BY J.JP_ID,A.LevelStatus),'+ CHAR(13)
			SET @SQL = @SQL +' New_CTE3 As (' + CHAR(13)
			SET @SQL = @SQL +' SELECT JP_ID, Total, LevelStatus FROM New_CTE2 where r = 1) '+ CHAR(13)
		END
	IF @Type = 'P' OR @Type = 'L' OR @Type = 'R' OR @Type = 'A'
		SET @SQL = @SQL +' SELECT C1.JP_ID, C1.JobTitle, C1.Verified, C1.Deadline, C1.AdType, C1.JType, C1.Closed, c1.ApplicantNo, c1.TotalJob, c1.ProceedToPublishDate, c1.NEW, c1.NewDesign, c1.TotalStep,
						c2.Total, c2.LevelStatus,C1.ApropriateCandidate, C1.Rank, C1.InProgress, C1.StepLog, C1.PublishDate, C1.TotalHired
						FROM New_CTE1 C1 
						LEFT JOIN New_CTE3 C2 ON C1.JP_ID = C2.JP_ID
						ORDER BY c1.ProceedToPublishDate desc, c1.jP_ID desc OFFSET ' + CAST(@StartingIndex As varchar(10)) + '  ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY'+ CHAR(13)
	IF @Type = 'D'
		SET @SQL = @SQL +' SELECT C1.JP_ID, C1.JobTitle, C1.Verified, C1.Deadline, C1.AdType, C1.JType, C1.Closed, c1.ApplicantNo, c1.TotalJob, c1.PostingDate, c1.NEW, c1.NewDesign, c1.TotalStep,
						c2.Total, c2.LevelStatus,C1.ApropriateCandidate, C1.Rank, C1.InProgress, C1.StepLog, C1.PublishDate, C1.TotalHired
						FROM New_CTE1 C1 
						LEFT JOIN New_CTE3 C2 ON C1.JP_ID = C2.JP_ID
						ORDER BY c1.jP_ID desc, c1.PostingDate desc OFFSET ' + CAST(@StartingIndex As varchar(10)) + '  ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY'+ CHAR(13)
	IF @Type = 'N' 
		SET @SQL = @SQL +' SELECT C1.JP_ID, C1.JobTitle, C1.Verified, C1.Deadline, C1.AdType, C1.JType, C1.Closed, c1.ApplicantNo, COUNT(1) OVER() As TotalJob, c1.ProceedToPublishDate, c1.NEW, c1.NewDesign, c1.TotalStep,
						c2.Total, c2.LevelStatus,C1.ApropriateCandidate, C1.Rank, C1.InProgress, C1.StepLog, C1.PublishDate, C1.TotalHired
						FROM New_CTE1 C1 
						LEFT JOIN New_CTE3 C2 ON C1.JP_ID = C2.JP_ID
						 WHERE c1.NEW > 0 
						ORDER BY c1.ProceedToPublishDate desc,c1.jP_ID desc OFFSET ' + CAST(@StartingIndex As varchar(10)) + '  ROWS FETCH  NEXT ' + CAST(@PageSize As varchar(5)) + ' ROWS ONLY'+ CHAR(13)
	

	SET NOCOUNT ON

	--EXEC (@SQL)
	PRINT @SQL

	SET NOCOUNT OFF
END



