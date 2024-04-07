WITH jobCTE AS (
	SELECT CONVERT(DATE, jp.PublishDate, 101) AS [Date], 
	COUNT(DISTINCT j.ApplyId) AS [Total Applicants], 
	COUNT(DISTINCT jp.JP_ID) AS [No. Of Jobs],
	COUNT(DISTINCT j.P_ID) AS [Unique P_ID]
	FROM bdjCorporate..DBO_JOB_INBOX AS j
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.JP_ID
	WHERE CONVERT(DATE, jp.PublishDate, 101) >= '02/28/2024 00:00:00'
	GROUP BY CONVERT(DATE, jp.PublishDate, 101)
)
, applicantCTE AS (
	SELECT DISTINCT CONVERT(DATE, j.PublishDate, 101) AS [Date], ji.ApplyId, ji.JP_ID, ji.P_ID 
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
	WHERE CONVERT(DATE, j.PublishDate, 101) >= '02/28/2024 00:00:00'
	--GROUP BY CONVERT(DATE, j.PublishDate, 101)
)
, shortlistedCTE AS (
	SELECT DISTINCT a.[Date], a.applyId, a.P_ID FROM applicantCTE AS a
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS p ON p.ApplyId = a.ApplyID
)
, countCTE AS (
	SELECT DISTINCT a.[Date], COUNT(DISTINCT a.ApplyId) AS [Total Shortlisted] 
	FROM bdjCorporate.rp.ApplicantProcess AS ap
	INNER JOIN applicantCTE AS a ON a.ApplyId = ap.ApplyId
	GROUP BY a.[Date]
	--ORDER BY a.[Date]
)
, listedboostingCountCTE AS (
	SELECT s.[Date], COUNT(DISTINCT b.BoostedOn) AS [Total Boosted Shortlisted App] FROM [bdjResumes].mnt.[ApplicationBoostingDetails] AS b
	INNER JOIN shortlistedCTE AS s ON s.P_ID = b.P_ID
	GROUP BY s.[Date]
)
, boostingCount AS (
	SELECT a.[Date], COUNT(DISTINCT b.BoostedOn) AS [Unique Boosted Applicant] FROM [bdjResumes].mnt.[ApplicationBoostingDetails] AS b
	INNER JOIN applicantCTE AS a ON a.P_ID = b.P_ID
	GROUP BY a.[Date]
)

SELECT j.[Date], j.[Total Applicants], j.[No. Of Jobs], j.[Unique P_ID] 
, c.[Total Shortlisted], b.[Unique Boosted Applicant], l.[Total Boosted Shortlisted App]
FROM jobCTE AS j
INNER JOIN countCTE AS c ON c.[Date] = j.[Date]
INNER JOIn boostingCount AS b ON b.[Date] = j.[Date]
INNER JOIN listedboostingCountCTE AS l ON l.[Date] = b.[Date]


--SELECT * FROM jobCTE AS j
--INNER JOIN countCTE AS c ON j.[Date] = c.[Date]

--SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess