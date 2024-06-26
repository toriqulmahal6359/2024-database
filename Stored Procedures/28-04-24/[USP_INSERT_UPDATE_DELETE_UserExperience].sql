USE [bdjResumes]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_UPDATE_DELETE_UserExperience]    Script Date: 4/28/2024 11:58:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************
** File		:   StoredProcedure [dbo].[USP_INSERT_UPDATE_DELETE_UserExperience]
** Name		:   USP_INSERT_UPDATE_DELETE_UserExperience
** Desc		:   
** Author	:   Bipul
** Date		:   July 15, 2021
******************************************************************************************/

ALTER PROCEDURE [dbo].[USP_INSERT_UPDATE_DELETE_UserExperience]
(
	@Action smallint = 0	-- 0=Insert; 1=Update; 2=Delete
	, @Ex_ID int = 0
	, @P_ID int = 0
	, @COMPANY varchar(100) = ''
	, @BUSINESS	varchar(150) = ''
	, @EPOSITION varchar(100) = ''
	, @DEPT varchar(50) = ''
	, @CLOCATION varchar(100) = ''
	, @EFROM varchar(10) = ''
	, @ETO varchar(10) = ''
	, @SERVE_TILL bit = 0
	, @Duty	nvarchar(max) = N''
	, @JP_ID int = 0
	, @AreaExp varchar(50) = ''
)
AS
BEGIN
	
	DECLARE @Result As smallint = 0
		, @Exp_ID int = 0

	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
			IF @Action = 0 And @Ex_ID = 0 And @P_ID > 0
				BEGIN
-- For Insert Exp
					INSERT INTO Exp (P_ID, COMPANY, BUSINESS, EPOSITION, DEPT, CLOCATION, EFROM, ETO, SERVE_TILL, Duty, JP_ID, UpdatedOn)
					VALUES (@P_ID, @COMPANY, @BUSINESS, @EPOSITION, @DEPT, @CLOCATION, @EFROM, @ETO, @SERVE_TILL, @Duty, @JP_ID, GETDATE())

					SELECT @Exp_ID = SCOPE_IDENTITY()
				END
			ELSE IF @Action = 1 And @Ex_ID > 0
				BEGIN
-- For Update Exp
					UPDATE Exp
						SET P_ID = @P_ID
						, COMPANY = @COMPANY
						, BUSINESS = @BUSINESS
						, EPOSITION = @EPOSITION
						, DEPT = @DEPT
						, CLOCATION = @CLOCATION
						, EFROM = @EFROM
						, ETO = @ETO
						, SERVE_TILL = @SERVE_TILL
						, Duty = @Duty
						, JP_ID = @JP_ID
						, UpdatedOn = GETDATE()
					WHERE Ex_ID = @Ex_ID
				END
			ELSE IF @Action = 2 And @Ex_ID > 0
				BEGIN
-- SELECT * FROM APPLICANT_EXP_AREA
					DELETE APPLICANT_EXP_AREA WHERE Ex_ID = @Ex_ID
-- For Delete Exp
					DELETE Exp WHERE Ex_ID = @Ex_ID
				END

/*=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+ INSERT UPDATE DELETE APPLICANT_EXP_AREA +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+*/
			IF @Ex_ID = 0
				SET @Ex_ID = @Exp_ID

			IF @AreaExp <> '' And @Action < 2
				BEGIN
-- For DELETE APPLICANT_EXP_AREA
					;WITH AreaOfExp_CTE As (
						SELECT LTRIM(RTRIM(Value)) As AREA_OF_EXP FROM STRING_SPLIT(@AreaExp, ',')
						WHERE LTRIM(RTRIM(Value)) > 0
					)
					--SELECT A.*
					DELETE A
					FROM APPLICANT_EXP_AREA A
						LEFT JOIN AreaOfExp_CTE A1 ON A.AREA_OF_EXP = A1.AREA_OF_EXP
					WHERE A.Ex_ID = @Ex_ID And A1.AREA_OF_EXP IS NULL

-- For INSERT APPLICANT_EXP_AREA
					;WITH AreaOfExp_CTE As (
						SELECT LTRIM(RTRIM(Value)) As AREA_OF_EXP FROM STRING_SPLIT(@AreaExp, ',')
						WHERE LTRIM(RTRIM(Value)) > 0
					)
					INSERT INTO APPLICANT_EXP_AREA (Ex_ID, AREA_OF_EXP)
					SELECT @Ex_ID As Ex_ID, A1.*
					FROM AreaOfExp_CTE A1
						LEFT JOIN APPLICANT_EXP_AREA A ON A.AREA_OF_EXP = A1.AREA_OF_EXP And A.Ex_ID = @Ex_ID
					WHERE A.AREA_OF_EXP IS NULL
				END
--			ELSE IF @Action = 2
---- For DELETE APPLICANT_EXP_AREA
--				BEGIN
--					--SELECT * FROM APPLICANT_EXP_AREA
--					DELETE APPLICANT_EXP_AREA
--					WHERE Ex_ID = @Ex_ID
--				END
/*=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+= UPDATE Personal =+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+*/
-- For Update Personal
			UPDATE Personal
			SET UPDATED_DATE = GETDATE()
			WHERE ID = @P_ID

/*=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+*/

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
			SET @Result = 1	--ERROR_NUMBER()

			INSERT INTO logs.Error_Log(ProcedureName, ErrorNumber, ErrorLine, ErrorMessage, ErrorSeverity, ErrorState)
			SELECT ERROR_PROCEDURE() As ProcedureName, ERROR_NUMBER() As ErrorNumber, ERROR_LINE() As ErrorLine, ERROR_MESSAGE() As ErrorMessage, ERROR_SEVERITY() As ErrorSeverity, ERROR_STATE() As ErrorState
		END CATCH

	EXEC USP_Generate_Users_Experience @P_ID

	SELECT @Result As Result

	SET NOCOUNT OFF

END