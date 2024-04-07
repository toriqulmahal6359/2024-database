WITH packageCTE AS (
	SELECT DISTINCT o.P_ID,o.ServiceID, 
	c.cpkStartDate AS [Start Date], DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate 
	FROM bdjResumes..OnlinePaymentInfoJS AS o
	INNER JOIN mnt.CandidatePackages AS c ON c.P_ID = o.P_ID AND o.SysID = c.cpkId
	WHERE o.ServiceId IN (87, 88, 89) AND o.TransStatus = 'S'
)
,final as(
	SELECT p.P_ID, jo.JP_ID, case when j.P_DATE >= p.[Start Date] AND j.P_DATE <= p.EndDate then J.ApplyID end as Applyid, j.P_DATE,jo.CP_ID
	FROM bdjCorporate..[DBO_JOB_INBOX] AS j 
	INNER JOIN  packageCTE AS p ON p.P_ID = j.P_ID 
	inner join bdjCorporate..DBO_JOBPOSTINGS jo on j.JP_ID=Jo.JP_ID
)
,finalpart as(
	select distinct f.P_ID, f.JP_ID, f.Applyid,CONVERT(Date, f.P_DATE, 101) AS [Date],f.CP_ID
	from final f
	inner join bdjCorporate.rp.ApplicantProcess p on f.applyid = p.applyid
	where f.Applyid is not null 
)
, freeCTE AS (
	SELECT i.ApplyID, i.P_ID, j.CP_ID 
	FROM bdjCorporate..[DBO_JOBPOSTINGS] AS j
	JOIN bdjCorporate..[DBO_JOB_INBOX] AS i ON j.JP_ID = i.JP_ID
)
, applyCTE AS (
	SELECT --f.P_ID, 
	CONVERT(DATE, a.UpdatedOn, 101) AS [Date], COUNT(DISTINCT f.CP_ID) AS company, COUNT(DISTINCT a.ApplyID) AS Shortlist_Count_Free FROM freeCTE AS f
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a ON a.ApplyID = f.ApplyID
	WHERE a.UpdatedOn >= '2023-11-30'
	GROUP BY CONVERT(DATE, a.UpdatedOn, 101)
)
, mainCTE AS (
	SELECT f.[Date],
	count(distinct f.applyid) as Shortlisted_Pro,
	count(distinct f.CP_ID) as unique_company
	FROM finalpart AS f
	GROUP BY f.[Date]
	--order by f.[Date]
)

SELECT m.[Date],
m.Shortlisted_Pro, m.unique_company, a.Shortlist_Count_Free, a.company
FROM applyCTE AS a
INNER JOIN mainCTE AS m ON m.[Date] = a.[Date]
ORDER BY m.[Date]



SELECT TOP 5 * FROM bdjCorporate..DBO_JOB_INBOX