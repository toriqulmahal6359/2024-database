--SELECT TOP 10 * FROM bdjResumes.mnt.ApplicationBoostingDetails
--SELECT TOP 5 * FROM bdjResumes.mnt.CandidatePackages

--select TOP 500 * from bdjCorporate.rp.empConversation ORDER BY JP_ID DESC
--		select TOP 5 * from bdjCorporate..CompanyViewedCV

--SELECT TOP 5 * FROm bdjCorporate.rp.ApplicantProcess

--SELECT TOP 5 * FROM bdjResumes..OnlinePaymentInfoJS


--WITH jobCTE AS (
--	SELECT DISTINCT j.JP_ID, ji.P_ID, ji.ApplyId, ji.P_DATE, CONVERT(DATE, j.PublishDate, 101) AS publishDate FROM bdjCorporate..DBO_JOB_INBOX AS ji
--	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.JP_ID = ji.JP_ID
--	WHERE CONVERT(DATE, j.PublishDate, 101) >= '03/01/2024 00:00:00' AND CONVERT(DATE, j.PublishDate, 101) <= '03/31/2024 00:00:00'
--)
WITH packageCTE AS (
	SELECT DISTINCT o.P_ID, c.cpkStartDate, DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS EndDate
	FROM bdjResumes..OnlinePaymentInfoJS AS o 
	INNER JOIN bdjResumes.mnt.CandidatePackages AS c ON c.P_ID = o.P_ID AND o.SysId = c.cpkId
	WHERE o.ServiceID IN (87, 88, 89) AND o.TransStatus = 'S'
	AND c.IsActive = 1 
)
, proCTE AS (
	SELECT DISTINCT p.P_ID, p.cpkStartDate, p.EndDate FROM packageCTE AS p
	WHERE CONVERT(DATE, p.EndDate, 101) >= '03/01/2024' AND CONVERT(DATE, p.EndDate, 101) <= '03/31/2024'
)
, finalCTE AS (
	SELECT DISTINCT j.JP_ID,
	CASE WHEN j.P_DATE >= p.cpkStartDate AND j.P_DATE <= p.EndDate THEN j.ApplyId END AS ApplyId,
	p.P_ID, p.cpkStartDate, p.EndDate, j.P_DATE, j.Score
	FROM procte AS p
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.P_ID = p.P_ID
)
SELECT f.P_DATE, f.P_ID, f.JP_ID, 
f.Score [Matching(%)],
CASE WHEN f.ApplyId IS NOT NULL THEN 'Y' ELSE 'N' END AS [Shortlisted (Y/N)],
CASE WHEN b.BoostedOn IS NOT NULL THEN 'Y' ELSE 'N' END AS [Boosted (Y/N)],
CASE WHEN c.Viewed_ON IS NOT NULL THEN 'Y' ELSE 'N' END AS [CV Viewed (Y/N)],
CASE WHEN m.cnvApplicantFirst = 1 THEN 'Y' ELSE 'N' END AS [Messaging (Y/N)]
FROM finalCTE AS f
LEFT JOIN bdjCorporate.rp.ApplicantProcess AS r ON r.ApplyId = f.ApplyId
LEFT JOIN bdjResumes.mnt.ApplicationBoostingDetails AS b oN b.JP_ID = f.JP_ID AND b.P_ID = f.P_ID
LEFT JOIN bdjCorporate..CompanyViewedCV AS c ON c.P_ID = f.P_ID AND c.JP_ID = f.JP_ID
LEFT JOIN bdjCorporate.rp.empConversation AS m ON m.P_ID = f.P_ID AND f.JP_ID = m.JP_ID

