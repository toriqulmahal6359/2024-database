--SELECT TOP 5 * FROM bdjResumes.[dbo].[OnlinePaymentInfoJS]
--SELECT TOP  5 * FROM bdjCorporate.[rp].[ApplicantProcess]


GO


WITH jobCTE AS (
	SELECT DISTINCT JP_ID, CONVERT(DATE, j.PublishDate, 101) AS [Publish Date] FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	WHERE CONVERT(DATE, j.PublishDate, 101) > '11/29/2023'
)
, applyCount AS (
	SELECT j.JP_ID, COUNT(DISTINCT ji.P_ID) AS [Total Applied] FROM bdjCorporate..DBO_JOB_INBOX AS ji
	INNER JOIN jobCTE AS j ON j.JP_ID = ji.JP_ID
	GROUP BY j.JP_ID
)
, proApplyCount AS (
	SELECT j.JP_ID, COUNT(DISTINCT ji.P_ID) AS [Total Pro Applied] FROM jobCTE AS j 
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
	INNER JOIN bdjResumes.[dbo].[OnlinePaymentInfoJS] AS o ON o.P_ID = ji.P_ID
	WHERE o.ServiceID IN (87, 88, 89) AND o.TransStatus = 'S'
	GROUP BY j.JP_ID
)
, totalShortlisted AS (
	SELECT j.JP_ID, COUNT(DISTINCT ji.P_ID) AS [Total Shortlisted] FROM jobCTE AS j 
	INNER JOIn bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplicantProcess] AS s ON s.ApplyId = ji.ApplyID
	GROUP BY j.JP_ID
)
, totalProShortListed AS (
	SELECT j.JP_ID, COUNT(DISTINCT ji.P_ID) AS [Total Pro Shortlisted] FROM jobCTE AS j 
	INNER JOIn bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
	INNER JOIN bdjResumes.[dbo].[OnlinePaymentInfoJS] AS o ON o.P_ID = ji.P_ID
	INNER JOIN bdjCorporate.[rp].[ApplicantProcess] AS s ON s.ApplyId = ji.ApplyID
	WHERE o.ServiceID IN (87, 88, 89) AND o.TransStatus = 'S'
	GROUP BY j.JP_ID
)

SELECT j.JP_ID, j.[Publish Date], a.[Total Applied], t.[Total Shortlisted], p.[Total Pro Applied], tp.[Total Pro Shortlisted] FROM jobCTE AS j
INNER JOIN applyCount AS a ON a.JP_ID = j.JP_ID
INNER JOIN proApplyCount AS p ON p.JP_ID = a.JP_ID
INNER JOIN totalShortlisted AS t ON t.JP_ID = p.JP_ID
INNER JOIN totalProShortListed AS tp ON tp.JP_ID = t.JP_ID
--WHERE j.JP_ID = 1220308

