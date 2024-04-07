SELECT TOP 5 * FROM bdjCorporate..DBO_JOBPOSTINGS

SELECT TOP 5 * FROM bdjCorporate.[adm].[LNJobPosting]

SELECT TOP 5 * FROM bdjCorporate.[dbo].[CorporateUserAccess]

WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.AdType = 11
)
SELECT j.JP_ID, j.[Job Title], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin] FROM jobCTE AS j
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
WHERE ua.AdminUser = 1


INNER JOIN bdjCorporate.[adm].[LNJobPosting] AS l ON l.JP_ID = j.JP_ID


SELECT * FROM bdjCorporate..DBO_JOBPOSTINGS AS j WHERE JP_ID = 1223824  --1223824 1176822 1188351 1177674


-- ======================================= LINKEDIN JOBS ==============================================

WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.AdType = 11 and J.CP_ID not in (35450, 115462, 106414, 38918)
)
, companyCTE AS (
	SELECT j.JP_ID, j.[Job Title], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin], ua.UpdatedOn 
	FROM jobCTE AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
	WHERE ua.AdminUser = 1
)
, serviceCTE AS (
	SELECT c.JP_ID, c.[Job Title], c.CP_ID, c.[Company Name], c.userId, c.[Admin], c.[UpdatedOn],
	CASE WHEN B.JType = 'H' THEN 'Hot Job'
			  ELSE CASE WHEN J.RegionalJob = 5 THEN 'PNPL'
				   ELSE CASE WHEN J.Adtype = 0 THEN 'Standard Listing'
							 WHEN J.Adtype = 1 THEN 'Premium'
							 WHEN J.Adtype = 2 THEN  'Premium Plus'
							 WHEN J.Adtype = 10 THEN  'SME Package'
							 WHEN j.AdType = 11 THEN 'LinkedIn Jobs'
							 WHEN J.Adtype = 12 THEN 'Free Listing' 
							 when j.adtype = 13 then 'Internship,Announcement'
							 when j.adtype=14 then 'Selected Blue Collar Job Position'
							 END END END ServiceType
	, ROW_NUMBER() OVER(PARTITION BY c.JP_ID ORDER BY c.[UpdatedOn] DESC) AS r
	FROM companyCTE AS c
	INNER JOIN bdjCorporate.[DBO].[DBO_JOBPOSTINGS] AS j ON j.JP_ID = c.JP_ID
	INNER JOIN bdjCorporate.[dbo].[JobBillInfo] AS b ON b.JP_ID = c.JP_ID
)
, applicantCTE AS (
	SELECT s.JP_ID, s.[Job Title], s.CP_ID, s.[Company Name], s.userId, s.[Admin], s.[ServiceType], j.ApplyId
	FROM serviceCTE AS s
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = s.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplyFromOtherSrc] AS sc ON sc.JP_ID = j.JP_ID AND sc.P_ID = j.P_ID
	WHERE r = 1
)

SELECT a1.JP_ID, a1.[Job Title], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], a1.[ServiceType], COUNT(DISTINCT a1.ApplyId) AS [Total Applicant]
	--CASE WHEN a2.Rejected = 1 THEN 'Rejected'
	--ELSE 'Shortlisted' END AS [Status]
FROM applicantCTE AS a1
GROUP BY a1.JP_ID, a1.[Job Title], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], a1.[ServiceType]
--INNER JOIN bdjCorporate.rp.ApplicantProcess AS a2 ON a1.ApplyId = a2.ApplyId


--SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess WHERE ApplyID = 284971563


SELECT TOP 5 * FROM bdjCorporate.[rp].[ApplyFromOtherSrc]
SELECT TOP 5 * FROM bdjCorporate..DBO_JOB_INBOX





SELECT TOP 100 * FROM bdjCorporate.[dbo].[JobBillInfo]

SELECT TOP 100 * FROM bdjCorporate.rp.ApplicantProcess

CASE WHEN B.JType = 'H' THEN 'Hot Job'
	      ELSE CASE WHEN J.RegionalJob = 5 THEN 'PNPL'
			   ELSE CASE WHEN J.Adtype = 0 THEN 'Standard Listing'
						 WHEN J.Adtype = 1 THEN 'Premium'
						 WHEN J.Adtype = 2 THEN  'Premium Plus'
						 WHEN J.Adtype = 10 THEN  'SME Package'
						 WHEN J.Adtype = 12 THEN 'Free Listing' 
						 when j.adtype = 13 then 'Internship,Announcement'
						 when j.adtype=14 then 'Selected Blue Collar Job Position'
						 END END END ServiceType


-- ==================================== All Jobs ==================================

WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j 
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.AdType <> 11 and J.CP_ID not in (35450, 115462, 106414, 38918)
	AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4 AND j.Drafted = 0
)
, companyCTE AS (
	SELECT j.JP_ID, j.[Job Title], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin], ua.UpdatedOn 
	FROM jobCTE AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
	WHERE ua.AdminUser = 1
)
, serviceCTE AS (
	SELECT c.JP_ID, c.[Job Title], c.CP_ID, c.[Company Name], c.userId, c.[Admin], c.[UpdatedOn],
	CASE WHEN B.JType = 'H' THEN 'Hot Job'
			  ELSE CASE WHEN J.RegionalJob = 5 THEN 'PNPL'
				   ELSE CASE WHEN J.Adtype = 0 THEN 'Standard Listing'
							 WHEN J.Adtype = 1 THEN 'Premium'
							 WHEN J.Adtype = 2 THEN  'Premium Plus'
							 WHEN J.Adtype = 10 THEN  'SME Package'
							 --WHEN j.AdType = 11 THEN 'LinkedIn Jobs'
							 WHEN J.Adtype = 12 THEN 'Free Listing' 
							 when j.adtype = 13 then 'Internship,Announcement'
							 when j.adtype=14 then 'Selected Blue Collar Job Position'
							 END END END ServiceType
	, ROW_NUMBER() OVER(PARTITION BY c.JP_ID ORDER BY c.[UpdatedOn] DESC) AS r
	FROM companyCTE AS c
	INNER JOIN bdjCorporate.[DBO].[DBO_JOBPOSTINGS] AS j ON j.JP_ID = c.JP_ID
	INNER JOIN bdjCorporate.[dbo].[JobBillInfo] AS b ON b.JP_ID = c.JP_ID
)
, applicantCTE AS (
	SELECT s.JP_ID, s.[Job Title], s.CP_ID, s.[Company Name], s.userId, s.[Admin], s.[ServiceType], j.ApplyId
	FROM serviceCTE AS s
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = s.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplyFromOtherSrc] AS sc ON sc.JP_ID = j.JP_ID AND sc.P_ID = j.P_ID
	WHERE r = 1
)
, total_count AS (
	SELECT a1.JP_ID, a1.[Job Title], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], a1.[ServiceType], COUNT(DISTINCT a1.ApplyId) AS [Total Applicant]
		--CASE WHEN a2.Rejected = 1 THEN 'Rejected'
		--ELSE 'Shortlisted' END AS [Status]
	FROM applicantCTE AS a1
	GROUP BY a1.JP_ID, a1.[Job Title], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], a1.[ServiceType]
)
, shortlist_count AS (
	SELECT a1.JP_ID,
	COUNT(DISTINCT a2.ApplyId) AS [Shortlisted],
	COUNT(DISTINCT CASE WHEN a2.Rejected = 1 THEN a2.ApplyId END) AS [Rejected]
	FROM applicantCTE AS a1
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a2 ON a1.ApplyId = a2.ApplyId
	GROUP BY a1.JP_ID
)

SELECT t.JP_ID, t.[Job Title], t.CP_ID, t.[Company Name], t.userId, t.[Admin], t.[ServiceType], t.[Total Applicant],
s.[Shortlisted], s.[Rejected]
FROM total_count AS t
INNER JOIN shortlist_count AS s ON s.JP_ID = t.JP_ID

SELECT TOP 5 * FROm bdjCorporate.rp.ApplicantProcess 

--CP_ID = 93653 Barovoot 


with job_cte as (select J.CP_ID, JP_ID, JobTitleFrom DBO_JOBPOSTINGS Jwhere J.Verified = 1 And J.Drafted = 0 And J.Closed=0    And J.Deadline >=GETDATE() And J.PublishDate < GETDATE()   AND RegionalJob = 5),paid as (SELECT DISTINCT top 2  J.JP_ID ,j.CP_ID,j.JobTitle FROM Job_CTE J 	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID  	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId   WHERE I.PAY_STATUS = 1  UNION  SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle FROM Job_CTE J  	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID  	INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId  	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID   	WHERE OP.TransStatus = 'S' AND (I.PAY_STATUS = 0 or I.PAY_STATUS is null) UNION  SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle FROM Job_CTE J  	INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID  	INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID   	WHERE OP.TransStatus = 'S'  UNION  SELECT DISTINCT J.JP_ID,j.CP_ID,j.JobTitle FROM Job_CTE J  	INNER JOIN bdjCorporate..dbo_JOBPOSTINGS JJ ON J.JP_ID = JJ.JP_ID		WHERE JJ.SERVICEID > 0)--, nonpaid as (--select  J.CP_ID, j.JP_ID,j.JobTitle --from job_cte j--where j.JP_ID not in (select jp_id from paid) and--j.JP_ID not in(select JP_ID  from[rp].[ApplicantCVPurchase] where OPID is not null)--),ppaid as (select  J.CP_ID, j.JP_ID,j. JobTitle from job_cte jwhere --j.JP_ID not in (select jp_id from paid) andj.JP_ID  in (select JP_ID  from[rp].[ApplicantCVPurchase] where OPID is not null))select top 2 * from ppaid--WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID,  
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.CP_ID
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j 
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	WHERE j.AdType <> 11 and J.CP_ID not in (35450, 115462, 106414, 38918)
	AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.RegionalJob <> 4 AND j.Drafted = 0
)
, companyCTE AS (
	SELECT j.JP_ID, j.[Job Title], j.CP_ID, c.NAME AS [Company Name], ua.UserId, ua.[User_Name] AS [Admin], ua.UpdatedOn,
	ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY ua.UpdatedOn DESC) AS r
	FROM jobCTE AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
	INNER JOIN bdjCorporate.[dbo].[CorporateUserAccess] AS ua ON ua.CP_ID = c.CP_ID 
	WHERE ua.AdminUser = 1
)
, applicantCTE AS (
	SELECT s.JP_ID, s.[Job Title], s.CP_ID, s.[Company Name], s.userId, s.[Admin], j.ApplyId
	FROM companyCTE AS s
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = s.JP_ID
	INNER JOIN bdjCorporate.[rp].[ApplyFromOtherSrc] AS sc ON sc.JP_ID = j.JP_ID AND sc.P_ID = j.P_ID
	WHERE r = 1
)
, total_count AS (
	SELECT a1.JP_ID, a1.[Job Title], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin], COUNT(DISTINCT a1.ApplyId) AS [Total Applicant]
		--CASE WHEN a2.Rejected = 1 THEN 'Rejected'
		--ELSE 'Shortlisted' END AS [Status]
	FROM applicantCTE AS a1
	GROUP BY a1.JP_ID, a1.[Job Title], a1.CP_ID, a1.[Company Name], a1.userId, a1.[Admin]
)
, paid as (	SELECT DISTINCT J.JP_ID ,j.CP_ID,j.[Job Title], j.[Company Name], j.userId, j.[Admin]	 FROM applicantCTE J 		INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID  		INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 	  WHERE I.PAY_STATUS = 1 	 UNION 	 SELECT DISTINCT J.JP_ID,j.CP_ID,j.[Job Title], j.[Company Name], j.userId, j.[Admin]	 FROM applicantCTE J  		INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID  		INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId  		INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID   		WHERE OP.TransStatus = 'S' AND (I.PAY_STATUS = 0 or I.PAY_STATUS is null)	 UNION 	 SELECT DISTINCT J.JP_ID,j.CP_ID,j.[Job Title], j.[Company Name], j.userId, j.[Admin]	 FROM applicantCTE J  		INNER JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID  		INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID   		WHERE OP.TransStatus = 'S' 	 UNION 	 SELECT DISTINCT J.JP_ID,j.CP_ID,j.[Job Title], j.[Company Name], j.userId, j.[Admin]	 FROM applicantCTE J  		INNER JOIN bdjCorporate..dbo_JOBPOSTINGS JJ ON J.JP_ID = JJ.JP_ID			WHERE JJ.SERVICEID > 0)
, shortlist_count AS (
	SELECT a1.JP_ID,
	COUNT(DISTINCT a2.ApplyId) AS [Shortlisted],
	COUNT(DISTINCT CASE WHEN a2.Rejected = 1 THEN a2.ApplyId END) AS [Rejected]
	FROM paid AS a1
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a2 ON a1.ApplyId = a2.ApplyId
	GROUP BY a1.JP_ID
)

SELECT t.JP_ID, t.[Job Title], t.CP_ID, t.[Company Name], t.userId, t.[Admin], t.[ServiceType], t.[Total Applicant],
s.[Shortlisted], s.[Rejected]
FROM total_count AS t
INNER JOIN shortlist_count AS s ON s.JP_ID = t.JP_ID




