WITH packageCTE AS (
	SELECT 
	P_ID, cpkStartDate, DATEADD(MONTH, cpkDuration, cpkStartDate) AS [EndDate] 
	FROM bdjResumes.mnt.CandidatePackages --WITH(NOLOCK)
	--WHERE DATEADD(MONTH, cpkDuration, cpkStartDate) = '05/30/2024'
)
SELECT * FROM packageCTE WHERE EndDate = CONVERT(VARCHAR(100), GETDATE(), 101) --'05/30/2024'


SELECT * FROM bdjResumes.mnt.CandidatePackages WHERE P_ID = 1552