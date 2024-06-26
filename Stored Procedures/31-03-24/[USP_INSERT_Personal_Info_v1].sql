USE [bdjResumes]
GO

/*****************************************************************************************
** File  :   StoredProcedure [dbo].[USP_INSERT_Personal_Info_v1]
** Name  :   dbo.USP_INSERT_Personal_Info_v1 241028
** Desc  :   
** Author:   Mahal
** Date  :   March 31, 2024
******************************************************************************************/

CREATE PROCEDURE [dbo].[USP_INSERT_Personal_Info_v1] 
(
	@P_ID AS int = 241028,
	@GUID AS VARCHAR(50) = ''
)
AS
BEGIN
	DECLARE @accID As int = 0
		, @accFirstName As varchar(50) = ''
		, @accLastName As varchar(50) = ''
		, @accGender As char(1) = ''
		, @accPhone As varchar(50) = ''
		, @accEmail As varchar(50) = ''
	
	DECLARE @Exist As int = 0
	DECLARE @Cat_IDs varchar(100) = ''
	DECLARE @Name As varchar(100) = ''

	SET NOCOUNT ON

	SELECT @Exist = COUNT(ID) FROM PERSONAL WHERE ID = @P_ID
	SELECT @Cat_IDs=  COALESCE(@Cat_IDs + ',', ',') + CAST(Cat_ID AS varchar(5)) FROM UsersCategory WHERE P_ID = @P_ID
	IF @Cat_IDs = ''
		SET @Cat_IDs = ''
	ELSE
		SET @Cat_IDs = @Cat_IDs + ','
	IF @Exist = 0
		SELECT @accID = accID, @accFirstName = accFirstName, @accLastName = (CASE WHEN accLastName IS NULL THEN '' ELSE accLastName END), @accGender = accGender, @accPhone = accPhone, @accEmail = accEmail FROM UserAccounts where accid=@P_ID
	
	IF @accLastName <> ''
		SET @Name = @accFirstName + ' ' + @accLastName
	ELSE
		SET @Name = @accFirstName

	IF @accID > 0
		BEGIN
			BEGIN TRY
				BEGIN TRAN
					INSERT INTO PERSONAL(ID, NAME, MOBILE, E_MAIL1, SEX, Posting_Date, GUID)
					VALUES(@accID, @Name, @accPhone, @accEmail, @accGender, GETDATE(), @GUID)

					SELECT u.accFirstName,u.accLastName,u.accGender,u.accPhone,u.accEmail,u.accCatID,p.FName
						, p.MName,p.Birth,p.M_Status,p.Nationality,p.Relegion, p.Present_Add,p.Permanent_Add
						, p.Current_Location, p.Home_Phone,p.Office_Phone,p.E_mail2,p.Obj,p.Cur_Sal,p.Exp_Sal
						, p.Pref,p.Available,@Cat_IDs,p.Pref_Job_Location, p.Type_Of_Org, o.Career_Summary
						, o.Spequa,o.Keywords,p.NID, (CASE WHEN u.accUNtype IS NULL THEN 0 ELSE u.accUNtype END) As accUNtype
						, P.BirthPlace, P.pHeight, P.pWeight, P.PassportNo, P.PassportIssueDate, U.accCountryCode, P.BloodGroup
					FROM UserAccounts u 
						LEFT JOIN Personal P ON u.accID = P.ID 
						LEFT JOIN personalOthers o on u.accid=o.p_id 
					WHERE u.accID= @P_ID
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN

				--Error Log
				INSERT INTO logs.Error_Log(ProcedureName, ErrorNumber, ErrorLine, ErrorMessage, ErrorSeverity, ErrorState)
				SELECT ERROR_PROCEDURE() As ProcedureName, ERROR_NUMBER() As ErrorNumber, ERROR_LINE() As ErrorLine, ERROR_MESSAGE() As ErrorMessage, ERROR_SEVERITY() As ErrorSeverity, ERROR_STATE() As ErrorState

				SELECT 'Nothing'
			END CATCH
		END
	ELSE
		SELECT u.accFirstName,u.accLastName,u.accGender,u.accPhone,u.accEmail,u.accCatID,p.FName,p.MName
			, p.Birth,p.M_Status,p.Nationality,p.Relegion, p.Present_Add,p.Permanent_Add, p.Current_Location
			, p.Home_Phone,p.Office_Phone,p.E_mail2,p.Obj,p.Cur_Sal,p.Exp_Sal,p.Pref,p.Available,@Cat_IDs
			, p.Pref_Job_Location, p.Type_Of_Org, o.Career_Summary, o.Spequa,o.Keywords,p.NID
			, (CASE WHEN u.accUNtype IS NULL THEN 0 ELSE u.accUNtype END) As accUNtype
			, P.BirthPlace, P.pHeight, P.pWeight, P.PassportNo, P.PassportIssueDate, U.accCountryCode, P.BloodGroup
		FROM UserAccounts u 
			LEFT JOIN Personal P ON u.accID = P.ID 
			LEFT JOIN personalOthers o on u.accid=o.p_id 
		WHERE u.accID= @P_ID
		
	EXEC USP_Generate_Users_Experience @P_ID

	SET NOCOUNT OFF
END

