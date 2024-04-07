
-- Matching Criteria
SELECT TOP 5 * FROM bdjCorporate..JobMatchFilters WHERE JP_ID = 1235364

-- Package Criteria
SELECT TOP 5 * FROM bdjResumes.mnt.CandidatePackages
SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess
SELECT TOP 5 * FROM bdjResumes..OnlinePaymentInfoJS --WHERE TransStatus = 'S' AND ServiceID IN (87, 88, 89)

-- Boosting Information
SELECT TOP 5 * FROM bdjResumes.mnt.ApplicationBoostingDetails
--SELECT TOP 5 * FROM bdjResumes.mnt.BoostedApplicants
SELECT TOP 5 * FROm bdjResumes.[mnt].[CandidatePackages]

-- Invitation Criteria
SELECT TOP 5 * FROM bdjCorporate.rp.TestSteps
SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess

WITH proCTE AS (
	SELECT o.P_ID, c.cpkStartDate, c.cpkDuration, 
	DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate,
	--c.isActive,
	ROW_NUMBER() OVER(PARTITION BY c.P_ID ORDER BY c.P_ID) AS r
	FROM bdjResumes..OnlinePaymentInfoJS AS o 
	INNER JOIN bdjResumes.mnt.CandidatePackages AS c ON c.P_ID = o.P_ID AND o.SysId = c.cpkId
	WHERE o.TransStatus = 'S' AND o.ServiceID IN (87, 88, 89)
)
, statusCTE AS (
	SELECT * 
	, CASE WHEN (p.EndDate > CONVERT(VARCHAR(100), GETDATE(), 101)) THEN 'Pro' ELSE 'Free' END AS [Status] 
	FROM proCTE AS p WHERE r= 1
)
SELECT * FROM statusCTE WHERE Status LIKE '%Free%'

