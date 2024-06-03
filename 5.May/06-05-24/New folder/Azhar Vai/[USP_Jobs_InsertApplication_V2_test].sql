USE [bdjCorporate]
GO

/*
Description		: Insert job application information into the database. 
Creation Date	: Nov-30-2008
Author			: Mustafa Ashek Mahmud
Modified by		: Mahal
Modified on		: 7th May, 2024
*/

ALTER PROCEDURE [dbo].[USP_Jobs_InsertApplication_V2]
(
	@ResumeID int
	, @JobID int
	, @ExpectedSalary numeric
	, @FromMobile tinyint = 0		-- 5 or 7
	, @Priority tinyint = 0
	, @packageID int
)
AS

BEGIN 	
	DECLARE @isJobFound int = 0
		, @MatchCount int = 0
		, @ApplyID int = 0

		, @Message As int = 0	-- 0=Success/1=Error occured

	SET NOCOUNT ON

		SELECT @MatchCount = COUNT(1) from Dbo_Job_Inbox where JP_ID = @JobID And P_ID = @ResumeID
		SELECT @isJobFound = COUNT(1) from JobMatchFilters where JP_ID = @JobID	

	IF @ResumeID is not Null AND @JobID is not Null AND @ExpectedSalary is not Null 
		BEGIN
			BEGIN TRY
				BEGIN TRAN
					IF @MatchCount = 0
						BEGIN
									
							INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Score, Priority) 
							VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, 
							CASE WHEN @isJobFound = 0 THEN 0 ELSE dbo.FN_Jobs_ApplicantsMatchingPoints_Count_V2(@JobID, @ResumeID, @ExpectedSalary, 1) END, @Priority)

							SELECT @ApplyID = SCOPE_IDENTITY()

							IF @Priority = 1
								INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
								VALUES(@ApplyID, @JobID, @ResumeID)

							IF @packageID > 0
								INSERT INTO bdjResumes.mnt.ApplicationBoostingDetails (P_ID, JP_ID, pkId, BoostedOn)
								VALUES(@ResumeID, @JobID, @packageID, GETDATE())
						END
					SET @Message = 0
				COMMIT TRAN
			END TRY

			BEGIN CATCH
				ROLLBACK TRAN
				SET @Message = 1
			END CATCH
		END
	
	SELECT @Message As [Message]

	SET NOCOUNT OFF

END


