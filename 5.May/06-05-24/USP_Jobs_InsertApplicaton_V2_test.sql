USE [bdjCorporate]
GO

/*
Description		: 
Creation Date	: 
Author			: 
Modified by		: 
Modified on		: 
*/
--CREATE PROCEDURE [dbo].[USP_Jobs_InsertApplicaton_V2_test]
--(
DECLARE
	@ResumeID int
	, @JobID int = 812777
	, @ExpectedSalary numeric
	, @FromMobile tinyint = 0
	, @Priority tinyint = 0
	, @boostEligible TINYINT = 0
--)
--AS
BEGIN 	

			IF @boostEligible = 1 
					BEGIN 
						SELECT P_ID, JP_ID, pkId FROM bdjResumes.mnt.ApplicationBoostingDetails WHERE JP_ID = @JobID
					END ELSE  BEGIN SELECT 0 END
	END

	DECLARE @isJobFound int = 0
		, @MatchCount int = 0
		, @ApplyID int = 0

		, @Message As int = 0-- 0=Success/1=Error occured

	SET NOCOUNT ON

	IF (@FromMobile = 5 OR @FromMobile = 7)
		SELECT @MatchCount = COUNT(1)  from Dbo_Job_Inbox where JP_ID = @JobID And P_ID = @ResumeID
	
		SELECT @isJobFound = COUNT(1)  from JobMatchFilters where JP_ID = @JobID

		

	IF @ResumeID is not Null AND @JobID is not Null AND @ExpectedSalary is not Null
		BEGIN
				--IF @boostEligible = 1 
				--	BEGIN 
				--		SELECT P_ID, JP_ID, pkId FROM bdjResumes.mnt.ApplicationBoostingDetails WHERE JP_ID = @JobID
				--	END
			--BEGIN TRY
				--BEGIN TRAN
					--IF (@FromMobile = 5 OR @FromMobile = 7)
					--	BEGIN
					--		IF @MatchCount = 0
					--			BEGIN
					--				IF @isJobFound = 0 
					--					BEGIN
											--INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Priority) 
											--VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, @Priority)

											--SELECT @ApplyID = SCOPE_IDENTITY()

											--IF @Priority = 1
											--	INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
											--	VALUES(@ApplyID, @JobID, @ResumeID)
										--END
									--ELSE
										--BEGIN
											--INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Score, Priority) 
											--VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, dbo.FN_Jobs_ApplicantsMatchingPoints_Count_V2(@JobID, @ResumeID, @ExpectedSalary, 1), @Priority)

											--SELECT @ApplyID = SCOPE_IDENTITY()

											--IF @Priority = 1
											--	INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
											--	VALUES(@ApplyID, @JobID, @ResumeID)
										--END
								--END
						--END
					--ELSE
						--BEGIN
						--	IF @isJobFound = 0 
						--		BEGIN
						--			INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Priority) 
						--			VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, @Priority)

						--			SELECT @ApplyID = SCOPE_IDENTITY()

						--			IF @Priority = 1
						--				INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
						--				VALUES(@ApplyID, @JobID, @ResumeID)
						--		END
						--	ELSE
						--		BEGIN
						--			INSERT INTO Dbo_Job_Inbox (P_ID, JP_ID, ExpectedSalary, FromMobile, Score, Priority) 
						--			VALUES(@ResumeID, @JobID, @ExpectedSalary, @FromMobile, dbo.FN_Jobs_ApplicantsMatchingPoints_Count_V2(@JobID, @ResumeID, @ExpectedSalary, 1), @Priority)

						--			SELECT @ApplyID = SCOPE_IDENTITY()

						--			IF @Priority = 1
						--				INSERT INTO PriorityLevelApplications (Applyid, JP_ID, P_ID) 
						--				VALUES(@ApplyID, @JobID, @ResumeID)
						--		END
						--END
				
					--SET @Message = 0
				--COMMIT TRAN
		--	END TRY
		--	BEGIN CATCH
		--		ROLLBACK TRAN
		--		SET @Message = 1
		--	END CATCH
		END
	
	--SELECT @Message As [Message]

	SET NOCOUNT OFF

END

--SELECT TOP 5 * FROM bdjResumes.mnt.ApplicationBoostingDetails
--SELECT TOP 5 * FROM bdjResumes.mnt.ApplicationBoostingDetails JP_ID = 812777
