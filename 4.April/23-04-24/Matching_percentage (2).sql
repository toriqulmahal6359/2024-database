	
	
	;with mainCTE as(
	SELECT DISTINCT jp.CP_ID,c.NAME,max(rp.UpdatedOn) as date,count(distinct rp.applyid) as T_shortlist,
	COUNT(CASE WHEN j.Score <= 50 THEN j.ApplyId END) AS [less_50%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 51 AND j.Score <= 60 THEN j.ApplyId END) AS [51% to 60%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 61 AND j.Score <= 70 THEN j.ApplyId END) AS [61% to 70%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 71 AND j.Score <= 80 THEN j.ApplyId END) AS [71% to 80%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 81 AND j.Score <= 90 THEN j.ApplyId END) AS [81% to 90%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 91 AND j.Score <= 100 THEN j.ApplyId END) AS [91% to 100%_shortlisted_applicant_count]
	FROM bdjCorporate..DBO_JOBPOSTINGS AS jp
	INNER JOIN 	bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = jp.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON j.ApplyId = rp.ApplyId
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID
	WHERE rp.UpdatedOn >= '01/01/2023'
	group by jp.CP_ID,c.NAME
	),main_cte2 as(	
	SELECT m.date,m.CP_ID,m.NAME--, j.Score
	,count(distinct jp.JP_ID) as T_JOB, count(distinct j.APPLYID)  as T_apply,m.T_shortlist,
	COUNT(CASE WHEN j.Score <= 50 THEN j.ApplyId END) AS [less_50%_total_applicant_count],    COUNT(CASE WHEN j.Score >= 51 AND j.Score <= 60 THEN j.ApplyId END) AS [51% to 60%_total_applicant_count],		COUNT(CASE WHEN j.Score >= 61 AND j.Score <= 70 THEN j.ApplyId END) AS [61% to 70%_total_applicant_count],		COUNT(CASE WHEN j.Score >= 71 AND j.Score <= 80 THEN j.ApplyId END) AS [71% to 80%_total_applicant_count],	 	COUNT(CASE WHEN j.Score >= 81 AND j.Score <= 90 THEN j.ApplyId END) AS [81% to 90%_total_applicant_count],	 	COUNT(CASE WHEN j.Score >= 91 AND j.Score <= 100 THEN j.ApplyId END) AS [91% to 100%_total_applicant_count]	
	,m.[51% to 60%_shortlisted_applicant_count],m.[61% to 70%_shortlisted_applicant_count],m.[71% to 80%_shortlisted_applicant_count]
	,m.[81% to 90%_shortlisted_applicant_count],m.[91% to 100%_shortlisted_applicant_count]
	FROM mainCTE m
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp on m.CP_ID=jp.CP_ID
	INNER JOIN 	bdjCorporate..DBO_JOB_INBOX AS j ON jp.JP_ID = j.JP_ID
	and jp.CP_ID >= 1234 and rp.applyid >= 212118561
	group by m.CP_ID,m.date,m.NAME,m.T_shortlist,m.[51% to 60%_shortlisted_applicant_count]
	,m.[61% to 70%_shortlisted_applicant_count],m.[71% to 80%_shortlisted_applicant_count]
	,m.[81% to 90%_shortlisted_applicant_count],m.[91% to 100%_shortlisted_applicant_count]
	),main_cte3 as(
	select 	    c.CP_ID,		CONCAT(ROUND((CAST(c.[less_50%_total_applicant_count] AS FLOAT) / CAST(c.T_apply AS FLOAT)) * 100, 2), '%') AS [less_50%_total_applicant_percentage],		CONCAT(ROUND((CAST(c.[51% to 60%_total_applicant_count] AS FLOAT) / CAST(c.T_apply AS FLOAT)) * 100, 2), '%') AS [51% to 60%_total_applicant_percentage],		CONCAT(ROUND((CAST(c.[61% to 70%_total_applicant_count] AS FLOAT) / CAST(c.T_apply AS FLOAT)) * 100, 2), '%') AS [61% to 70%_total_applicant_percentage],		CONCAT(ROUND((CAST(c.[71% to 80%_total_applicant_count] AS FLOAT) / CAST(c.T_apply AS FLOAT)) * 100, 2), '%') AS [71% to 80%_total_applicant_percentage],		CONCAT(ROUND((CAST(c.[81% to 90%_total_applicant_count] AS FLOAT) / CAST(c.T_apply AS FLOAT)) * 100, 2), '%') AS [81% to 90%_total_applicant_percentage],		CONCAT(ROUND((CAST(c.[91% to 100%_total_applicant_count] AS FLOAT) / CAST(c.T_apply AS FLOAT)) * 100, 2), '%') AS [91% to 100%_total_applicant_percentage]	FROM main_cte2 AS c
	),main_cte4 as (
	select c.CP_ID,
	CONCAT(ROUND((CAST(c.[less_50%_shortlisted_applicant_count] AS FLOAT) / CAST(c.T_shortlist AS Float)) * 100, 2), '%') AS [less_50%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[51% to 60%_shortlisted_applicant_count] AS FLOAT) / CAST(c.T_shortlist AS Float)) * 100, 2), '%') AS [51% to 60%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[61% to 70%_shortlisted_applicant_count] AS FLOAT) / CAST(c.T_shortlist AS Float)) * 100, 2), '%') AS [61% to 70%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[71% to 80%_shortlisted_applicant_count] AS FLOAT) / CAST(c.T_shortlist AS Float)) * 100, 2), '%') AS [71% to 80%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[81% to 90%_shortlisted_applicant_count] AS FLOAT) / CAST(c.T_shortlist AS Float)) * 100, 2), '%') AS [81% to 90%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[91% to 100%_shortlisted_applicant_count] AS FLOAT) / CAST(c.T_shortlist AS Float)) * 100, 2), '%') AS [91% to 100%_shortlisted_applicant_percentage]
	FROM mainCTE as c
	)
	select
	CONVERT(DATE, m.date, 101) AS [Date],
	m3.CP_ID,
	m1.NAME AS [cp_name],
	m1.T_JOB AS [total_jobpost],
	m1.T_apply AS [total_applicant],
	m1.T_shortlist AS [total_shortlisted_applicant],
	m1.[less_50%_total_applicant_count],	m2.[less_50%_total_applicant_percentage],	m1.[51% to 60%_total_applicant_count],	m2.[51% to 60%_total_applicant_percentage],	m1.[61% to 70%_total_applicant_count],	m2.[61% to 70%_total_applicant_percentage],	m1.[71% to 80%_total_applicant_count],	m2.[71% to 80%_total_applicant_percentage],	m1.[81% to 90%_total_applicant_count],	m2.[81% to 90%_total_applicant_percentage],	m1.[91% to 100%_total_applicant_count],	m2.[91% to 100%_total_applicant_percentage],	
	m.[less_50%_shortlisted_applicant_count],
	m3.[less_50%_shortlisted_applicant_percentage],
	m.[51% to 60%_shortlisted_applicant_count],	m3.[51% to 60%_shortlisted_applicant_percentage],	m.[61% to 70%_shortlisted_applicant_count],	m3.[61% to 70%_shortlisted_applicant_percentage],	m.[71% to 80%_shortlisted_applicant_count],	m3.[71% to 80%_shortlisted_applicant_percentage],	m.[81% to 90%_shortlisted_applicant_count],	m3.[81% to 90%_shortlisted_applicant_percentage],	m.[91% to 100%_shortlisted_applicant_count],
	m3.[91% to 100%_shortlisted_applicant_percentage]
	--,m1.*,m2.*,m3.*
	from mainCTE m
	INNER JOIN main_cte2 m1 on m.CP_ID = m1.CP_ID
	INNER JOIN main_cte3 m2 on m.CP_ID = m2.CP_ID
	INNER JOIN main_cte4 m3 on m.CP_ID = m3.CP_ID



