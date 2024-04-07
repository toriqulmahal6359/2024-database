USE [bdjResumes]
GO

/*****************************************************************************************
** File  :   StoredProcedure [dbo].[USP_INSERT_Blue_CV_v1]
** Name  :   dbo.USP_INSERT_Blue_CV_v1
** Desc  :   
** Author:   Mahal
** Date  :   March 31, 2024
******************************************************************************************/

ALTER PROCEDURE [dbo].[USP_INSERT_Blue_CV_v1](	  
	@p_id int = 0
	, @Birth_Date varchar(10) = ''
	, @Year_of_Exp int = 0
	, @Edu_Level int = 0
	, @Education varchar(100) = ''
	, @Institute varchar(80)= ''
	, @passing_year smallint = 0
	, @educationType tinyint = 0	
	, @skillIDs varchar(150) = ''
	, @hasEducation bit = 0
	, @LocationID int = 0
	, @Village nvarchar(300) = ''
	, @SkilledBy varchar(200) = ''--'19,22s25,30s12,21'
	, @ntvqfLevel varchar(30) = ''--'0,2,0'
	, @accCatId As varchar(100) = ''
	, @BoardID tinyint = 0
	, @pGUID AS varchar(50) = ''
	, @sGUID AS varchar(50) = ''
	, @eGUID AS varchar(50) = ''
)
AS
BEGIN

	DECLARE @Result As int = 0
		, @Loc1 As int = 0
		, @Loc2 As int = 0
		, @Loc3 As int = 0

		, @DistrictID As int = 0
		, @ThanaID As int = 0
		, @PostOffice As int = 0
		, @Exist As int = 0
		, @accID As int = 0

	SELECT @Loc1= Loc.L_Id
		, @Loc2 = (CASE WHEN Loc2.L_ID>=1000 And Loc2.L_ID<1010 THEN 0 ELSE Loc2.L_ID END)
		, @Loc3 = (CASE WHEN Loc3.L_ID>=1000 And Loc3.L_ID<1010 THEN 0 ELSE Loc3.L_ID END) 
	FROM Locations Loc 
		LEFT JOIN Locations Loc2 ON Loc.ParentID = Loc2.L_ID 
		LEFT JOIN Locations Loc3 ON Loc2.ParentID = Loc3.L_ID 
	WHERE Loc.L_ID = @LocationID --2244--1431--

	IF @Loc3 = 0
		BEGIN
			SET @PostOffice = 0
			SET @ThanaID = @Loc1
			SET @DistrictID = @Loc2
		END
	ELSE
		BEGIN
			SET @PostOffice = @Loc1
			SET @ThanaID = @Loc2
			SET @DistrictID = @Loc3
		END
	
	SET NOCOUNT ON

	SELECT @Exist = COUNT(ID) FROM PERSONAL WHERE ID = @P_ID
	
	IF @Exist = 0
		SELECT @accID = @P_ID
	
	BEGIN TRY
		BEGIN TRAN
			
			IF @skillIDs <> '' And @accID > 0
				BEGIN
					
					-- INSERT Personal Informations

					INSERT INTO Personal (ID, NAME, BIRTH, SEX, MOBILE,EXPERIENCE,POSTING_DATE,UPDATED_DATE, GUID) 
					--VALUES (@p_id, @Name, @Birth_Date, @Gender, @mMobile, @Year_of_Exp, GETDATE(), GETDATE(), @pGUID)
					SELECT accID, accFirstName + CASE WHEN (accLastName <> '' OR accLastName IS NOT NULL) THEN (' ' + accLastName) ELSE '' END, @Birth_Date, accGender, accPhone, @Year_of_Exp, GETDATE(), GETDATE(), @pGUID
					from UserAccounts
				

					-- INSERT Skill Information

					;WITH Skill_CTE(P_ID, SkillID, SkillIDs, SkilledByID, SkilledBy, ntvqfLevelID, ntvqfLevel) as (
						SELECT @p_id As P_ID, CAST(RTRIM(LTRIM(LEFT(@skillIDs, CHARINDEX(',', @skillIDs + ',')-1))) As int),
							STUFF(@skillIDs, 1, CHARINDEX(',',@skillIDs+','), '')
							, CASE WHEN @SkilledBy <> '' THEN CAST(RTRIM(LTRIM(LEFT(@SkilledBy, CHARINDEX('s', @SkilledBy + 's')-1))) As varchar(40)) ELSE NULL END,
							STUFF(@SkilledBy, 1, CHARINDEX('s',@SkilledBy+'s'), '')
							, CASE WHEN @ntvqfLevel <> '' THEN CAST(RTRIM(LTRIM(LEFT(@ntvqfLevel, CHARINDEX(',', @ntvqfLevel + ',')-1))) As int) ELSE NULL END,
							STUFF(@ntvqfLevel, 1, CHARINDEX(',',@ntvqfLevel+','), '')
						WHERE (@skillIDs IS NOT NULL And @skillIDs <> '')
							OR (@SkilledBy IS NOT NULL And @SkilledBy <> '')
							OR (@ntvqfLevel IS NOT NULL And @ntvqfLevel <> '')
						UNION ALL
						SELECT P_ID, CAST(RTRIM(LTRIM(LEFT(SkillIDs, CHARINDEX(',',SkillIDs+',')-1))) As int),
							STUFF(SkillIDs, 1, CHARINDEX(',',SkillIDs+','), '')
							, CAST(RTRIM(LTRIM(LEFT(SkilledBy, CHARINDEX('s',SkilledBy+'s')-1))) As varchar(40)),
							STUFF(SkilledBy, 1, CHARINDEX('s',SkilledBy+'s'), '')
							, CAST(RTRIM(LTRIM(LEFT(ntvqfLevel, CHARINDEX(',',ntvqfLevel+',')-1))) As int),
							STUFF(ntvqfLevel, 1, CHARINDEX(',',ntvqfLevel+','), '')
						FROM Skill_CTE
						WHERE SkillIDs > '' OR SkilledBy > '' OR ntvqfLevel > ''
					)
					INSERT INTO SPECIALIST(P_ID, SKILL_ID, SkilledBy, ntvqfLevel, GUID)
					SELECT P_ID, SkillID, SkilledByID, CASE WHEN ntvqfLevelID = 0 THEN NULL ELSE ntvqfLevelID END As ntvqfLevel, @sGUID
					FROM Skill_CTE

				END

			-- INSERT Educational Informations

			IF @hasEducation = 1
				BEGIN
					INSERT INTO EDU(P_ID,EDULEVEL,EDUCATION,INSTITUTE,PASSING_YEAR,EducationType,BoardID, GUID)
					VALUES (@p_id, @Edu_Level, @Education, @Institute, @passing_year, @educationType,@BoardID, @eGUID)
				END
			
			-- INSERT UserAddress Informations

			EXEC USP_INSERT_UPDATE_UserAddress @p_id, 1, 0, 0, 1, @DistrictID, @ThanaID, @PostOffice, @Village, 0, 0, 0, 0, 0, 0, 0, 0, '', 0
			
			-- INSERT User Category
			IF @accCatId <> ''
				EXEC USP_Users_Category @p_id, @accCatId

			-- UPDATE UserAccounts Informations
			IF @accCatId <> ''
				UPDATE UserAccounts SET CVPosted = 1, accIsActivate = 1, accCatId = @accCatId WHERE accID = @p_id
			ELSE
				UPDATE UserAccounts SET CVPosted = 1, accIsActivate = 1 WHERE accID = @p_id

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
			SET @Result = ERROR_NUMBER()

			INSERT INTO logs.Error_Log(ProcedureName, ErrorNumber, ErrorLine, ErrorMessage, ErrorSeverity, ErrorState)
			SELECT ERROR_PROCEDURE() As ProcedureName, ERROR_NUMBER() As ErrorNumber, ERROR_LINE() As ErrorLine, ERROR_MESSAGE() As ErrorMessage, ERROR_SEVERITY() As ErrorSeverity, ERROR_STATE() As ErrorState
	END CATCH

	EXEC USP_Generate_Users_Experience @p_id

	SELECT @Result As Result
	
	SET NOCOUNT OFF
END