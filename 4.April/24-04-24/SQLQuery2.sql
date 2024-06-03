-- linkedIn Job Count

SELECT CONVERT(DATE, LN_PostingDate, 101) AS [Posting Date], COUNT(LNLink) AS [Job Count] FROM bdjCorporate.[adm].[LNJobPosting]
WHERE LN_PostingDate >= '03/01/2024' AND LN_PostingDate <= '03/31/2024'
GROUP BY CONVERT(DATE, LN_PostingDate, 101)
ORDER BY CONVERT(DATE, LN_PostingDate, 101)



SELECT TOP 5 * FROM bdjCorporate.[adm].[LNJobPosting]

-- job Publish Count

SELECT CONVERT(DATE, PublishDate, 101) AS [Date], COUNT(JP_ID) AS [Job Count] FROM bdjCorporate..DBO_JobPostings
WHERE CONVERT(DATE, PublishDate, 101) >= '03/01/2024' AND CONVERT(DATE, PublishDate, 101) <= '03/31/2024'
GROUP BY CONVERT(DATE, PublishDate, 101)
ORDER BY CONVERT(DATE, PublishDate, 101)

-- Easy Apply Count

SELECT CONVERT(DATE, LN_PostingDate, 101) AS [Posting Date], COUNT(LNLink) AS [Job Count] FROM bdjCorporate.[adm].[LNJobPosting]
WHERE LN_PostingDate >= '03/01/2024' AND LN_PostingDate <= '03/31/2024' AND ApplyType = 1
GROUP BY CONVERT(DATE, LN_PostingDate, 101)
ORDER BY CONVERT(DATE, LN_PostingDate, 101)