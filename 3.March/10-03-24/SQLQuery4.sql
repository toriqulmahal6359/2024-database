SELECT TOP 10 *, DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate FROM mnt.CandidatePackages

----==================================== MY CODE =======================================================

WITH packageCTE AS (
	SELECT DISTINCT o.P_ID, c.cpkDuration, 
	c.cpkStartDate AS [Start Date], DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate FROM bdjResumes..OnlinePaymentInfoJS AS o
	INNER JOIN mnt.CandidatePackages AS c ON c.P_ID = o.P_ID AND o.SysID = c.cpkId
	WHERE o.ServiceId IN (87, 88, 89) AND o.TransStatus = 'S'				-- Pro package Buyers
)
, shortlistCTE AS (
	SELECT p.P_ID, j.P_DATE,
	CASE WHEN j.P_DATE >= p.[Start Date] AND j.P_DATE <= p.[EndDate] THEN j.ApplyID END AS ApplyId
	FROM packageCTE AS p
	INNER JOIN bdjCorporate..[DBO_JOB_INBOX] AS j ON j.P_ID = p.P_ID
)
, finalCTE AS (
	SELECT CONVERT(DATE, s.P_DATE, 101) AS [i_date], s.P_ID, s.ApplyId  FROM shortlistCTE AS s
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a ON a.ApplyId = s.ApplyId
	GROUP BY CONVERT(DATE, s.P_DATE, 101), s.P_Id, s.ApplyId
)
SELECT [i_date], COUNT(DISTINCT ApplyId) AS Shortlisted_Count FROM finalCTE
GROUP BY [i_date] ORDER BY [i_Date]


----==================================== MY CODE =======================================================



WHERE j.P_DATE >= p.[Start Date] AND j.P_DATE <= p.EndDate
GROUP BY CONVERT(Date, j.P_DATE, 101)
ORDER BY [Date]


SELECT TOP 4 * FROM bdjCorporate..[DBO_JOB_INBOX]

SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess
SELECT TOP 10 * FROM bdjCorporate.rp.TestSteps

SELECT DISTINCT TestType FROM bdjCorporate.rp.TestSteps



---======================================= MEHARAZ VAI CODE ===========================================

WITH packageCTE AS (
	SELECT DISTINCT o.P_ID,o.ServiceID, 
	c.cpkStartDate AS [Start Date], DATEADD(MONTH, cpkDuration, cpkStartDate) AS EndDate 
	FROM bdjResumes..OnlinePaymentInfoJS AS o
	INNER JOIN mnt.CandidatePackages AS c ON c.P_ID = o.P_ID AND o.SysID = c.cpkId
	WHERE o.ServiceId IN (87, 88, 89) AND o.TransStatus = 'S'
),final as(
SELECT p.P_ID, case when j.P_DATE >= p.[Start Date] AND j.P_DATE <= p.EndDate then J.ApplyID end as Applyid, j.P_DATE
FROM bdjCorporate..[DBO_JOB_INBOX] AS j 
INNER JOIN  packageCTE AS p ON p.P_ID = j.P_ID 
),finalpart as(
select  distinct f.P_ID,f.Applyid,CONVERT(Date, f.P_DATE, 101) AS [Date]
from final f
inner join bdjCorporate.rp.ApplicantProcess p on f.applyid = p.applyid
where f.Applyid is not null
)
select f.[Date],count(distinct f.applyid) as Apply
from finalpart f
group by f.[Date]
order by f.[Date]

---======================================= MEHARAZ VAI CODE ===========================================