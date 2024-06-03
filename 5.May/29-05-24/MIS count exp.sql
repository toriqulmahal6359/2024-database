WITH jobCTE AS (
	SELECT j.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.CP_ID, 
	case when j.CompanyName is null or j.CompanyName = ' ' then c.NAME else j.companyname end [cp_name]
	, CASE WHEN j.MinExp > 0 AND j.MinExp <= 1 AND j.MaxExp <= 1 THEN '0-1 Year exp'
		 WHEN j.MinExp > 1 AND j.MinExp <= 3 AND j.MaxExp <= 3 THEN '1-3 Year exp'
		 WHEN j.MinExp > 3 AND j.MinExp <= 5 AND j.MaxExp <= 5 THEN '3-5 Year exp'
		 WHEN j.MinExp > 5 AND j.MinExp <= 8 AND j.MaxExp <= 8 THEN '5-8 Year exp' 
		 WHEN j.MinExp > 8 AND j.MinExp <= 10 AND j.MaxExp <= 10 THEN '8-10 Year exp'
		 WHEN j.MinExp > 10 THEN '10+ Year Exp' --ELSE 'Any'
	END AS [Required Experience]
	, j.PublishDate , ji.ApplyID,ji.P_ID 
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	WHERE j.PublishDate >= '01/01/2024' AND j.VERIFIED = 1 AND j.OnlineJob = 1 and ji.JP_ID >=277480 and ji.ApplyID>=291878230
), countCTE AS (
	SELECT distinct j.JP_ID 
		, COUNT( DISTINCT CASE WHEN v.TExp/12 <=1 THEN V.P_ID ELSE NULL END ) AS [0-1 Year Exp]  
		, COUNT( DISTINCT CASE WHEN v.TExp/12 > 1 AND v.TExp/12 <= 3 THEN V.P_ID ELSE NULL END ) [1-3 Year Exp]  
		, COUNT( DISTINCT CASE WHEN v.TExp/12 > 3 AND v.TExp/12 <= 5 THEN V.P_ID ELSE NULL END ) [3-5 Year Exp] 
		, COUNT( DISTINCT CASE WHEN v.TExp/12 > 5 AND v.TExp/12 <= 8 THEN V.P_ID ELSE NULL END ) [5-8 Year Exp]  
		, COUNT( DISTINCT CASE WHEN v.TExp/12 > 8 AND v.TExp/12 <= 10 THEN V.P_ID ELSE NULL END ) [8-10 Year Exp]
		, COUNT( DISTINCT CASE WHEN v.TExp/12 > 10 THEN V.P_ID ELSE NULL END ) [10+ Year Exp]
	FROM jobCTE AS j
	INNER JOIN bdjResumes..UserSummary AS v ON j.P_ID = v.P_ID
	where [Required Experience] is not null  
	GROUP BY j.JP_ID
)
SELECT COUNT(*)  
	--PublishDate,
	--j.JP_ID, j.[Job Title]
	--, j.[Required Experience]
	--, j.CP_ID, j.[cp_name]
	--, j.ApplyId
	--, [0-1 Year Exp], [1-3 Year Exp], [3-5 Year Exp], [5-8 Year Exp], [8-10 Year Exp], [10+ Year Exp]
FROM jobCTE AS j
INNER JOIN countCTE AS c ON j.JP_ID = c.JP_ID
