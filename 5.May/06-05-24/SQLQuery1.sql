strSqlForBoost = "INSERT INTO mnt.ApplicationBoostingDetails (P_ID, JP_ID, pkId) VALUES (" & UserID & ", " &intJobId  & ", " & intPackageId & ")"


--SELECT TOP 5 * FROM bdjResumes.mnt.ApplicationBoostingDetails ORDER BY BoostedOn DESC
--SELECT TOP 5 * FROM bdjResumes.mnt.ApplicationBoostingDetails JP_ID = 812777

--IF @boostEligible = 1 
				--	BEGIN 
				--		SELECT P_ID, JP_ID, pkId FROM bdjResumes.mnt.ApplicationBoostingDetails WHERE JP_ID = @JobID
				--	END