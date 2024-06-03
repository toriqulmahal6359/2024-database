USE [bdjCorporate]
GO

/*
Description		: USP_Jobs_InsertApplication_V2_test
Creation Date	: May 6, 2024
Author			: Mahal
*/

CREATE PROCEDURE [dbo].[USP_Jobs_InsertApplication_V2_test]
(
--DECLARE
	@ResumeID int
	, @JobID int
	, @ExpectedSalary numeric
	, @FromMobile tinyint = 0  -- 5 or 7
	, @Priority tinyint = 0
	, @packageID int
)
AS

BEGIN 	
	DECLARE @isJobFound int = 0
		, @MatchCount int = 0
		, @ApplyID int = 0

		, @Message As int = 0-- 0=Success/1=Error occured

		--, @Score INT = 0  -- 0 = initializing

	SET NOCOUNT ON

	--IF (@FromMobile = 5 OR @FromMobile = 7)
		SELECT @MatchCount = COUNT(1) from Dbo_Job_Inbox where JP_ID = @JobID And P_ID = @ResumeID
		SELECT @isJobFound = COUNT(1) from JobMatchFilters where JP_ID = @JobID	

	IF @ResumeID is not Null AND @JobID is not Null AND @ExpectedSalary is not Null 
		BEGIN
			BEGIN TRY
				BEGIN TRAN
					--IF (@FromMobile = 5 OR @FromMobile = 7)
						--BEGIN
							IF @MatchCount = 0
								BEGIN
									--IF @isJobFound = 0 
									--	BEGIN
									--		INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Score, Priority) 
									--		VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, @Score, @Priority)

									--		SELECT @ApplyID = SCOPE_IDENTITY()

									--		IF @Priority = 1
									--			INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
									--			VALUES(@ApplyID, @JobID, @ResumeID)
									--	END
									--ELSE
										--BEGIN
											INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Score, Priority) 
											VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, 
											CASE WHEN @isJobFound = 0 THEN 0 ELSE dbo.FN_Jobs_ApplicantsMatchingPoints_Count_V2(@JobID, @ResumeID, @ExpectedSalary, 1) END, @Priority)

											SELECT @ApplyID = SCOPE_IDENTITY()

											IF @Priority = 1
												INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
												VALUES(@ApplyID, @JobID, @ResumeID)
										--END

									IF @packageID > 0
										--BEGIN 
											INSERT INTO bdjResumes.mnt.ApplicationBoostingDetails (P_ID, JP_ID, pkId, BoostedOn)
											VALUES(@ResumeID, @JobID, @packageID, GETDATE())
											--SELECT P_ID, JP_ID, pkId FROM bdjResumes.mnt.ApplicationBoostingDetails WHERE JP_ID = @JobID AND pkId = @packageID AND P_ID = @ResumeID
										--END 

									--ELSE 
									--	BEGIN 
									--		SELECT 0 
									--	END
								END
						--END
					--ELSE
					--	BEGIN
					--		IF @isJobFound = 0 
					--			BEGIN
					--				INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Priority) 
					--				VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, @Priority)

					--				SELECT @ApplyID = SCOPE_IDENTITY()

					--				IF @Priority = 1
					--					INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
					--					VALUES(@ApplyID, @JobID, @ResumeID)
					--			END
					--		ELSE
					--			BEGIN
					--				INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Score, Priority) 
					--				VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, dbo.FN_Jobs_ApplicantsMatchingPoints_Count_V2(@JobID, @ResumeID, @ExpectedSalary, 1), @Priority)

					--				SELECT @ApplyID = SCOPE_IDENTITY()

					--				IF @Priority = 1
					--					INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
					--					VALUES(@ApplyID, @JobID, @ResumeID)
					--			END
					--	END
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


