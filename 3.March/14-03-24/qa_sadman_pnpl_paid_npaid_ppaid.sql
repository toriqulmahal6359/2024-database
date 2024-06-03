WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [JobTitle], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j 
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.RegionalJob= 5 and J.CP_ID not in (35450, 115462, 106414, 38918)
	AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0
)
,paid as (
SELECT DISTINCT  J.JP_ID ,j.CP_ID,j.JobTitle
 FROM JobCTE J
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
  WHERE I.PAY_STATUS = 1 
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
 	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
 	WHERE OP.TransStatus = 'S' AND (I.PAY_STATUS = 0 or I.PAY_STATUS is null)
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
 	WHERE OP.TransStatus = 'S' 
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..dbo_JOBPOSTINGS JJ ON J.JP_ID = JJ.JP_ID
		WHERE JJ.SERVICEID > 0
)
, companyCTE AS (
	SELECT j.JP_ID, j.[JobTitle], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin], ua.UpdatedOn 
	,ROW_NUMBER()over(partition by j.cp_id order by ua.UpdatedOn desc ) [r]
	FROM paid AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
	WHERE ua.AdminUser = 1
)

, applicantCTE AS (
	SELECT s.JP_ID, s.[JobTitle], s.CP_ID, s.[Company Name], s.userId, s.[Admin], j.ApplyId
	FROM companyCTE AS s
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = s.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplyFromOtherSrc] AS sc ON sc.JP_ID = j.JP_ID AND sc.P_ID = j.P_ID
	WHERE r = 1
)
, total_count AS (
	SELECT a1.JP_ID, a1.[JobTitle], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], COUNT(DISTINCT a1.ApplyId) AS [Total Applicant]
		--CASE WHEN a2.Rejected = 1 THEN 'Rejected'
		--ELSE 'Shortlisted' END AS [Status]
	FROM applicantCTE AS a1
	GROUP BY a1.JP_ID, a1.[JobTitle], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin]
)
, shortlist_count AS (
	SELECT a1.JP_ID,
	COUNT(DISTINCT a2.ApplyId) AS [Shortlisted],
	COUNT(DISTINCT CASE WHEN a2.Rejected = 1 THEN a2.ApplyId END) AS [Rejected]
	FROM applicantCTE AS a1
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a2 ON a1.ApplyId = a2.ApplyId
	GROUP BY a1.JP_ID
)

SELECT t.JP_ID, t.[JobTitle], t.CP_ID, t.[Company Name], t.userId, t.[Admin], t.[Total Applicant],
s.[Shortlisted], s.[Rejected]
FROM total_count AS t
INNER JOIN shortlist_count AS s ON s.JP_ID = t.JP_ID



-------------------------------non paid-----------------------------------------------

WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [JobTitle], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j 
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.RegionalJob= 5 and J.CP_ID not in (35450, 115462, 106414, 38918)
	AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0
)
,paid as (
SELECT DISTINCT   J.JP_ID ,j.CP_ID,j.JobTitle
 FROM JobCTE J
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
  WHERE I.PAY_STATUS = 1 
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
 	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
 	WHERE OP.TransStatus = 'S' AND (I.PAY_STATUS = 0 or I.PAY_STATUS is null)
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
 	WHERE OP.TransStatus = 'S' 
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..dbo_JOBPOSTINGS JJ ON J.JP_ID = JJ.JP_ID
		WHERE JJ.SERVICEID > 0
)

, nonpaid as (

select  J.CP_ID, j.JP_ID,j.JobTitle 
from jobcte j
where j.JP_ID not in (select JP_ID from paid) and
j.JP_ID not in(select JP_ID  from bdjCorporate.[rp].[ApplicantCVPurchase] where OPID is not null)
)
, companyCTE AS (
	SELECT top 10 j.JP_ID, j.[JobTitle], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin], ua.UpdatedOn 
	,ROW_NUMBER()over(partition by j.cp_id order by ua.UpdatedOn desc ) [r]
	FROM nonpaid AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
	WHERE ua.AdminUser = 1
)

, applicantCTE AS (
	SELECT s.JP_ID, s.[JobTitle], s.CP_ID, s.[Company Name], s.userId, s.[Admin], j.ApplyId
	FROM companyCTE AS s
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = s.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplyFromOtherSrc] AS sc ON sc.JP_ID = j.JP_ID AND sc.P_ID = j.P_ID
	WHERE r = 1
)
, total_count AS (
	SELECT a1.JP_ID, a1.[JobTitle], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], COUNT(DISTINCT a1.ApplyId) AS [Total Applicant]
		--CASE WHEN a2.Rejected = 1 THEN 'Rejected'
		--ELSE 'Shortlisted' END AS [Status]
	FROM applicantCTE AS a1
	GROUP BY a1.JP_ID, a1.[JobTitle], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin]
)
, shortlist_count AS (
	SELECT a1.JP_ID,
	COUNT(DISTINCT a2.ApplyId) AS [Shortlisted],
	COUNT(DISTINCT CASE WHEN a2.Rejected = 1 THEN a2.ApplyId END) AS [Rejected]
	FROM applicantCTE AS a1
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a2 ON a1.ApplyId = a2.ApplyId
	GROUP BY a1.JP_ID
)

SELECT t.JP_ID, t.[JobTitle], t.CP_ID, t.[Company Name], t.userId, t.[Admin], t.[Total Applicant],
s.[Shortlisted], s.[Rejected]
FROM total_count AS t
left JOIN shortlist_count AS s ON s.JP_ID = t.JP_ID




----------------------------partialpaid------------------------------

WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [JobTitle], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j 
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.RegionalJob= 5 and J.CP_ID not in (35450, 115462, 106414, 38918)
	AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0
)
,paid as (
SELECT DISTINCT top 2  J.JP_ID ,j.CP_ID,j.JobTitle
 FROM JobCTE J
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
  WHERE I.PAY_STATUS = 1 
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
 	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
 	WHERE OP.TransStatus = 'S' AND (I.PAY_STATUS = 0 or I.PAY_STATUS is null)
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
 	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
 	WHERE OP.TransStatus = 'S' 
 UNION 
 SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle
 FROM JobCTE J 
 	INNER JOIN bdjCorporate..dbo_JOBPOSTINGS JJ ON J.JP_ID = JJ.JP_ID
		WHERE JJ.SERVICEID > 0
)
,ppaid as (
select  J.CP_ID, j.JP_ID,j. JobTitle 
from jobcte j
where --j.JP_ID not in (select jp_id from paid) and
j.JP_ID  in (select JP_ID from bdjCorporate.[rp].[ApplicantCVPurchase] where OPID is not null)


)
, companyCTE AS (
	SELECT j.JP_ID, j.[JobTitle], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin], ua.UpdatedOn 
	FROM ppaid AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
	WHERE ua.AdminUser = 1
)

, applicantCTE AS (
	SELECT s.JP_ID, s.[JobTitle], s.CP_ID, s.[Company Name], s.userId, s.[Admin], j.ApplyId
	FROM companyCTE AS s
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = s.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplyFromOtherSrc] AS sc ON sc.JP_ID = j.JP_ID AND sc.P_ID = j.P_ID
	--WHERE r = 1
)
, total_count AS (
	SELECT a1.JP_ID, a1.[JobTitle], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], COUNT(DISTINCT a1.ApplyId) AS [Total Applicant]
		--CASE WHEN a2.Rejected = 1 THEN 'Rejected'
		--ELSE 'Shortlisted' END AS [Status]
	FROM applicantCTE AS a1
	GROUP BY a1.JP_ID, a1.[JobTitle], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin]
)
, shortlist_count AS (
	SELECT a1.JP_ID,
	COUNT(DISTINCT a2.ApplyId) AS [Shortlisted],
	COUNT(DISTINCT CASE WHEN a2.Rejected = 1 THEN a2.ApplyId END) AS [Rejected]
	FROM applicantCTE AS a1
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a2 ON a1.ApplyId = a2.ApplyId
	GROUP BY a1.JP_ID
)

SELECT t.JP_ID, t.[JobTitle], t.CP_ID, t.[Company Name], t.userId, t.[Admin], t.[Total Applicant],
s.[Shortlisted], s.[Rejected]
FROM total_count AS t
left JOIN shortlist_count AS s ON s.JP_ID = t.JP_ID

SELECT DISTINCT JP_ID FROM bdjCorporate.[rp].[ApplicantCVPurchase]