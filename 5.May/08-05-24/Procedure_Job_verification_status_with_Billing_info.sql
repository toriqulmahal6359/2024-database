USE [bdjCorporate]
GO

-- =======================================================================
-- File			:		<File Name>
-- Name			:		<Procedure Name>
-- Description	:		<Description,,>
-- Author		:		Md. Toriqul Islam Khan Mahal
-- Creation date:		May 8, 2024
-- =======================================================================

CREATE PROCEDURE [dbo].[]
(
	@postFrom DATETIME = '4/30/2024'
	, @postTo DATETIME = '5/7/2024'
	, @JobType CHAR(3) = 'B'
	, @accountStatus VARCHAR(50) = ''
	, @saleStatus VARCHAR(50) = '5'
	, @accountUser TINYINT = 2
	, @came_from VARCHAR(25) = ''
	, @pageNo INT = 1
	, @per_page_data INT =  50
)
AS
BEGIN

	DECLARE

		@isSaleNumeric AS TINYINT,
		@isAccountNumeric AS TINYINT,

		@strWhere VARCHAR(MAX),
		@strWhere1 VARCHAR(MAX),
	
		@SQLPart1 VARCHAR(MAX),
		@SQL_COMMON VARCHAR(MAX),

		@OrderBy VARCHAR(MAX),
	
		@pagination VARCHAR(MAX);

		SET @SQLPart1 = ' ' ;
		SET @SQL_COMMON = ' ' ;

		SET @strWhere = ' ';
		SET @strWhere1 = ' ';

		SET @OrderBy = ' ORDER BY '+CHAR(13)+' ';

		SET @pagination = ' ';

		SET NOCOUNT ON


	BEGIN
		IF @accountUser = 2
			BEGIN
				IF (@postFrom <> '' AND @postTo <> '') 
					SET @strWhere = @strWhere + ' '+CHAR(13)+' AND JVS.vStatusDate >= '''+CONVERT(VARCHAR(100), @postFrom, 120)+''' AND JVS.vStatusDate <= '''+CONVERT(VARCHAR(100), @postTo, 120)+''' '+CHAR(13)+' '
				ELSE IF @postFrom <> '' 
					SET @strWhere = @strWhere + ' '+CHAR(13)+' AND JVS.vStatusDate>= '''+ CONVERT(VARCHAR(100), @postFrom, 120)+ ''' '+CHAR(13)+' '
				ELSE IF @postTo <> '' 
					SET @strWhere = @strWhere + ' '+CHAR(13)+' AND JVS.vStatusDate <='''+CONVERT(VARCHAR(100), @postTo, 120)+''' '+CHAR(13)+' '
			END
			ELSE 
			BEGIN
				IF @JobType = 'E' 
				BEGIN
					IF (@postFrom <> '' AND @postTo <> '')
						SET @strWhere = @strWhere + ' '+CHAR(13)+' AND j.DeadLine >= '''+ CONVERT(VARCHAR(100), @postFrom, 120) +''' AND '''+ CONVERT(VARCHAR(100), @postTo, 120) + ''' '+CHAR(13)+' '
					ELSE IF (@postFrom <> '') 
						SET @strWhere = @strWhere + ' '+CHAR(13)+' AND j.DeadLine >= '''+CONVERT(VARCHAR(100), @postFrom, 120)+''' '+CHAR(13)+' '
					ELSE IF (@postTo <> '')
						SET @strWhere = @strWhere + ' '+CHAR(13)+' AND j.DeadLine <= '''+CONVERT(VARCHAR(100), @postTo, 120)+''' '+CHAR(13)+' '
				END
				ELSE 
					BEGIN
						IF (@postFrom <> '' AND @postTo <> '') 
							BEGIN
								SET @strWhere1 = @strWhere1 + ' '+CHAR(13)+' AND jo.ProceedToPublishDate >= ''' + CONVERT(VARCHAR(100), @postFrom, 120) + ''' AND jo.ProceedToPublishDate <= DATEADD(DAY, 1, ''' + CONVERT(VARCHAR(100), @postTo, 120) + ''') '+CHAR(13)+' '
								SET @strWhere = @strWhere + ' '+CHAR(13)+' AND j.ProceedToPublishDate >= ''' + CONVERT(VARCHAR(100), @postFrom, 120) + ''' AND j.ProceedToPublishDate <= DATEADD(DAY, 1, ''' + CONVERT(VARCHAR(100), @postTo, 120) + ''') '+CHAR(13)+' '
							END
						ELSE IF (@postFrom <> '')
							BEGIN
								SET @strWhere = @strWhere + ' '+CHAR(13)+' AND j.ProceedToPublishDate >= '''+CONVERT(VARCHAR(100), @postFrom, 120)+''' '+CHAR(13)+' '
								SET @strWhere1 = @strWhere1 + ' '+CHAR(13)+' AND jo.ProceedToPublishDate >= '''+ CONVERT(VARCHAR(100), @postFrom, 120)+''' '+CHAR(13)+' '
							END
						ELSE IF (@postTo <> '')
							BEGIN
								SET @strWhere = @strWhere + ' '+CHAR(13)+' AND j.ProceedToPublishDate <= DATEADD(DAY, 1, ''' +CONVERT(VARCHAR(100), @postTo, 120)+''') '+CHAR(13)+' '
								SET @strWhere1 = @strWhere1 + ' '+CHAR(13)+' AND jo.ProceedToPublishDate <= DATEADD(DAY, 1, '''+CONVERT(VARCHAR(100), @postTo, 120)+''') '+CHAR(13)+' '
							END
					END
			END

			IF @JobType = 'V' 
				BEGIN SET @strWhere = @strWhere + ' and j.Verified=1' END
			ELSE IF @JobType = 'U' 
				BEGIN SET @strWhere = @strWhere + ' and j.Verified=0' END
			ELSE IF @JobType = 'S'
				BEGIN SET @strWhere = @strWhere + ' and J.ADTYPE=1' END
			ELSE IF @JobType= 'SP'
				BEGIN SET @strWhere = @strWhere + ' and J.ADTYPE=2' END
			ELSE IF @JobType= 'R'
				BEGIN SET @strWhere = @strWhere + ' AND J.RegionalJob = 1' END
			ELSE IF @JobType = 'F'
				BEGIN SET @strWhere = @strWhere + ' and J.RegionalJob = 2' END
			ELSE IF @JobType = 'P'
				BEGIN SET @strWhere = @strWhere + ' AND J.Closed = 1' END
			ELSE IF @JobType = 'N'
				BEGIN SET @strWhere = @strWhere + ' AND C.Acct_CR >= ''' + CONVERT(VARCHAR(100), DATEADD(DAY,-2, GETDATE()), 120) + ''' AND (J.ServiceID is null Or J.ServiceID = 0) ' END
			ELSE IF @JobType = 'H'
				BEGIN SET @strWhere = @strWhere + ' AND JBI.JType IN (''H'',''P'')''' END
			ELSE IF @JobType = 'B'
				BEGIN SET @strWhere = @strWhere + ' AND J.Cat_ID >= 60 ' END
			ELSE IF @JobType = 'O'
				BEGIN SET @strWhere = @strWhere + ' AND JBI.OPID > 0 and JBI.PayStatus = 1 ' END
			ELSE IF @JobType = 'EC' OR @came_from = 'vp'
				BEGIN SET @strWhere = @strWhere + ' AND C.IsEntrepreneur = 1' END
			ELSE IF @JobType = 'EJ'
				BEGIN SET @strWhere = @strWhere + ' AND J.ADTYPE = 10' END
			ELSE IF @JobType = 'LNK'
				BEGIN SET @strWhere = @strWhere +' AND PostToLN = 1' END
			ELSE IF @JobType = 'L'
				BEGIN SET @strWhere = @strWhere + ' AND J.ADTYPE = 11 and PostToLN = 1' END
			ELSE IF @JobType= 'Fr'
				BEGIN SET @strWhere = @strWhere + ' AND J.ADTYPE = 12' END 

			SET @isSaleNumeric = ISNUMERIC(@saleStatus)
			SET @isAccountNumeric = ISNUMERIC(@accountStatus)

			IF @saleStatus <> '' AND @isSaleNumeric = 1
			BEGIN

				IF @accountUser = 2
					SET @strWhere = @strWhere + ' AND JVS.VStatus='+@saleStatus+' OR JVS.VStatus = 6'
				ELSE
					SET @strWhere = @strWhere + ' AND JVS.VStatus='+@saleStatus+''

				IF @saleStatus = '5' and @accountUser = 2
					SET @strWhere = @strWhere + ' AND JVS.VStatus in (5,6)'
				ELSE
					SET @strWhere = @strWhere +' AND JVS.VStatus='+@saleStatus+' '
			END

			IF @accountStatus <> '' AND @isAccountNumeric = 1
				SET @strWhere = @strWhere + ' AND JVA.VStatus='+@accountStatus+' '
			

			SET @SQLPart1 =	';WITH Comment_CTE AS('+CHAR(13)+' SELECT '+CHAR(13)+' '+CHAR(9)+' J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName '+CHAR(13)+' '+CHAR(9)+',ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r '+CHAR(13)+' FROM Dbo_JobPostings AS Jo ' + CHAR(13)
			SET @SQLPart1 = @SQLPart1 + ' '+CHAR(9)+' INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID '+CHAR(13)+' '+CHAR(9)+' LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID ' + CHAR(13)
			SET @SQLPart1 = @SQLPart1 +' WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000) '+CHAR(13)+' AND Jo.deleted = 0 AND Jo.drafted = 0 '+@strWhere1+' AND Jo.RegionalJob <> 4' + CHAR(13)
			--SET @SQLPart1 = @SQLPart1 +' '+@strWhere1+' AND Jo.RegionalJob <> 4' + CHAR(13)
			SET @SQLPart1 = @SQLPart1 +' ),'+CHAR(13)+'Final_CTE AS('+CHAR(13)+' '+CHAR(9)+'SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName FROM Comment_CTE WHERE r = 1 '+CHAR(13)+')' + CHAR(13)
			SET @SQLPart1 = @SQLPart1 + 'SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID ' + CHAR(13)	
			SET @SQLPart1 = @SQLPart1 + ', PayStatus = (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) ' + CHAR(13)                                          
			SET @SQLPart1 = @SQLPart1 + ', J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine '+CHAR(13)+', J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission ' + CHAR(13) 
			SET @SQLPart1 = @SQLPart1 + ', JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom'+CHAR(13)+', SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment '+CHAR(13)+', j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ' + CHAR(13)
			SET @SQLPart1 = @SQLPart1 + ', C.IsEntrepreneur, COUNT(JC.ID) AS TotalComment '+CHAR(13)+', CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over() ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '  FROM Dbo_Company_Profiles AS C '+CHAR(13)+'		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID '+CHAR(13)+'		LEFT JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID ' + CHAR(13) 
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID ' + CHAR(13)
			--SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = ''Sales'' ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = ''Accounts'' ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + '		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + ' WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0 '+@strWhere+' AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + ' GROUP BY '+CHAR(13)+'  J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob '+CHAR(13)+', JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed ' + CHAR(13) 
			SET @SQL_COMMON = @SQL_COMMON + ', JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission '+CHAR(13)+', JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom '+CHAR(13)+', SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME ' + CHAR(13)
			SET @SQL_COMMON = @SQL_COMMON + ', JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions '+CHAR(13)+', C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName ' + CHAR(13)
		
			IF @accountUser = 2 
			BEGIN

				SET @OrderBy = @OrderBy + '  JVS.vStatusDate desc, JVS.VStatus DESC' + CHAR(13)

				IF (@saleStatus <> '' AND @saleStatus = '5')
				BEGIN
					SET @OrderBy = @orderBy + ' , JVA.vStatusDate ASC, CAST(JVS.vStatusDate AS DATE) DESC '+CHAR(13)+' , CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC ' + CHAR(13)
				END
				ELSE 
				BEGIN
					SET @OrderBy = @OrderBy + ' , JVA.vStatusDate ASC, JVS.vStatusDate DESC '+CHAR(13)+', CASE WHEN JVS.VStatus IS NOT NULL AND JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC ' + CHAR(13)
				END

			END
			ELSE 
			BEGIN
				SET @OrderBy = @OrderBy + ' ProceedToPublishDate desc, J.JP_ID DESC ' + CHAR(13)
			END

			SET @pagination = @OrderBy + @pagination + ' OFFSET ' + CAST(((@pageNo - 1)*@per_page_data) AS VARCHAR(10)) + ' ROWS FETCH NEXT '+CAST(@per_page_data AS VARCHAR(10))+' ROWS ONLY '

			SET @SQLPart1 = @SQLPart1 + @SQL_COMMON + @pagination

			--EXEC(@SQLPart1)
			PRINT(@SQLPart1);

			--EXEC 
	END
END
