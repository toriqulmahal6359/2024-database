-- total Counts Jobposts and Applicants;WITH jobCTE AS (	SELECT jp.CP_ID, j.JP_ID, J.ApplyId, j.Score, c.NAME AS [cp_name]	FROM bdjCorporate..DBO_JOBPOSTINGS AS jp	INNER JOIN 	bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = jp.JP_ID	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID	--INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1	WHERE jp.PublishDate >= '01/01/2021' --and jp.PublishDate < '02/01/2021'	UNION	SELECT jp.CP_ID, j.JP_ID, J.ApplyId, j.Score, c.NAME AS [cp_name]	FROM arcCorporate..DBO_JOBPOSTINGS_arc AS jp 	INNER JOIN arcCorporate..DBO_JOB_INBOX_arc AS j ON j.JP_ID = jp.JP_ID	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID	--INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1	WHERE jp.PublishDate >= '01/01/2021' --and jp.PublishDate < '02/01/2021') --,tj as(--	SELECT CP_ID, COUNT(DISTINCT JP_ID) AS T_JOB FROM jobCTE GROUP BY CP_ID--), count1CTE AS (	SELECT 		j.CP_ID, j.[cp_name], 		COUNT(DISTINCT ApplyId) AS Tapply, COUNT(DISTINCT JP_ID) AS T_JOB,		COUNT(CASE WHEN j.Score <= 50 THEN j.ApplyId END) AS [less_50%_total_applicant_count],		COUNT(CASE WHEN j.Score >= 51 AND j.Score <= 60 THEN j.ApplyId END) AS [51% to 60%_total_applicant_count],			COUNT(CASE WHEN j.Score >= 61 AND j.Score <= 70 THEN j.ApplyId END) AS [61% to 70%_total_applicant_count],			COUNT(CASE WHEN j.Score >= 71 AND j.Score <= 80 THEN j.ApplyId END) AS [71% to 80%_total_applicant_count],	 		COUNT(CASE WHEN j.Score >= 81 AND j.Score <= 90 THEN j.ApplyId END) AS [81% to 90%_total_applicant_count],	 		COUNT(CASE WHEN j.Score >= 91 AND j.Score <= 100 THEN j.ApplyId END) AS [91% to 100%_total_applicant_count]		FROM jobCTE j	--INNER JOIN tj ON j.CP_ID = tj.CP_ID	GROUP BY j.CP_ID, j.[cp_name] --, tj.T_JOB ),final1CTE AS (	SELECT 		c.CP_ID, c.[cp_name], c.Tapply AS [totalApply], c.T_JOB AS [totalJob],		c.[less_50%_total_applicant_count],		CONCAT(ROUND((CAST(c.[less_50%_total_applicant_count] AS FLOAT) / CAST(c.Tapply AS FLOAT)) * 100, 2), '%') AS [less_50%_total_applicant_percentage],		c.[51% to 60%_total_applicant_count],		CONCAT(ROUND((CAST(c.[51% to 60%_total_applicant_count] AS FLOAT) / CAST(c.Tapply AS FLOAT)) * 100, 2), '%') AS [51% to 60%_total_applicant_percentage],		c.[61% to 70%_total_applicant_count],		CONCAT(ROUND((CAST(c.[61% to 70%_total_applicant_count] AS FLOAT) / CAST(c.Tapply AS FLOAT)) * 100, 2), '%') AS [61% to 70%_total_applicant_percentage],		c.[71% to 80%_total_applicant_count],		CONCAT(ROUND((CAST(c.[71% to 80%_total_applicant_count] AS FLOAT) / CAST(c.Tapply AS FLOAT)) * 100, 2), '%') AS [71% to 80%_total_applicant_percentage],		c.[81% to 90%_total_applicant_count],		CONCAT(ROUND((CAST(c.[81% to 90%_total_applicant_count] AS FLOAT) / CAST(c.Tapply AS FLOAT)) * 100, 2), '%') AS [81% to 90%_total_applicant_percentage],		c.[91% to 100%_total_applicant_count],		CONCAT(ROUND((CAST(c.[91% to 100%_total_applicant_count] AS FLOAT) / CAST(c.Tapply AS FLOAT)) * 100, 2), '%') AS [91% to 100%_total_applicant_percentage]	FROM count1CTE AS c)-- Counting of Total shortlisted Applicants--;WITH ,jobCTE2 AS (	SELECT jp.CP_ID, rp.UpdatedOn, rp.ApplyId, j.Score, c.NAME AS [cp_name]	FROM bdjCorporate..DBO_JOBPOSTINGS AS jp	LEFT JOIN 	bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = jp.JP_ID	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID	WHERE rp.UpdatedOn >= '01/01/2021' --and rp.UpdatedOn < '02/01/2021'	UNION	SELECT jp.CP_ID, rp.UpdatedOn, rp.ApplyId, j.Score, c.NAME AS [cp_name]	FROM arcCorporate..DBO_JOBPOSTINGS_arc AS jp 	LEFT JOIN arcCorporate..DBO_JOB_INBOX_arc AS j ON j.JP_ID = jp.JP_ID	INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON c.CP_ID = jp.CP_ID	WHERE rp.UpdatedOn >= '01/01/2021' --and rp.UpdatedOn < '02/01/2021'), countCTE AS (SELECT j.[CP_ID], j.[cp_name], MAX(j.UpdatedOn) max_date, --, f.T_apply, f.J_apply,	COUNT(j.ApplyId) AS [total_shortlisted_applicants],	COUNT(CASE WHEN j.Score <= 50 THEN j.ApplyId END) AS [less_50%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 51 AND j.Score <= 60 THEN j.ApplyId END) AS [51% to 60%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 61 AND j.Score <= 70 THEN j.ApplyId END) AS [61% to 70%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 71 AND j.Score <= 80 THEN j.ApplyId END) AS [71% to 80%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 81 AND j.Score <= 90 THEN j.ApplyId END) AS [81% to 90%_shortlisted_applicant_count],	COUNT(CASE WHEN j.Score >= 91 AND j.Score <= 100 THEN j.ApplyId END) AS [91% to 100%_shortlisted_applicant_count]FROM jobCTE2 AS jGROUP BY j.[CP_ID], j.[cp_name]), finalCTE AS (SELECT 	c.*, 	CONCAT(ROUND((CAST(c.[less_50%_shortlisted_applicant_count] AS FLOAT) / CAST(c.[total_shortlisted_applicants] AS Float)) * 100, 2), '%') AS [less_50%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[51% to 60%_shortlisted_applicant_count] AS FLOAT) / CAST(c.[total_shortlisted_applicants] AS Float)) * 100, 2), '%') AS [51% to 60%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[61% to 70%_shortlisted_applicant_count] AS FLOAT) / CAST(c.[total_shortlisted_applicants] AS Float)) * 100, 2), '%') AS [61% to 70%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[71% to 80%_shortlisted_applicant_count] AS FLOAT) / CAST(c.[total_shortlisted_applicants] AS Float)) * 100, 2), '%') AS [71% to 80%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[81% to 90%_shortlisted_applicant_count] AS FLOAT) / CAST(c.[total_shortlisted_applicants] AS Float)) * 100, 2), '%') AS [81% to 90%_shortlisted_applicant_percentage],	CONCAT(ROUND((CAST(c.[91% to 100%_shortlisted_applicant_count] AS FLOAT) / CAST(c.[total_shortlisted_applicants] AS Float)) * 100, 2), '%') AS [91% to 100%_shortlisted_applicant_percentage]FROM countCTE AS c)SELECT 	CONVERT(DATE, f.max_date, 101) AS [Date], 	f.[CP_ID],	f.[cp_name],	t.[totalJob] AS [total_jobpost],	t.[totalApply] AS [total_applicant],	f.[total_shortlisted_applicants],	t.[less_50%_total_applicant_count],	t.[less_50%_total_applicant_percentage],	t.[51% to 60%_total_applicant_count],	t.[51% to 60%_total_applicant_percentage],	t.[61% to 70%_total_applicant_count],	t.[61% to 70%_total_applicant_percentage],	t.[71% to 80%_total_applicant_count],	t.[71% to 80%_total_applicant_percentage],	t.[81% to 90%_total_applicant_count],	t.[81% to 90%_total_applicant_percentage],	t.[91% to 100%_total_applicant_count],	t.[91% to 100%_total_applicant_percentage],	f.[less_50%_shortlisted_applicant_count],	f.[less_50%_shortlisted_applicant_percentage],	f.[51% to 60%_shortlisted_applicant_count],	f.[51% to 60%_shortlisted_applicant_percentage],	f.[61% to 70%_shortlisted_applicant_count],	f.[61% to 70%_shortlisted_applicant_percentage],	f.[71% to 80%_shortlisted_applicant_count],	f.[71% to 80%_shortlisted_applicant_percentage],	f.[81% to 90%_shortlisted_applicant_count],	f.[81% to 90%_shortlisted_applicant_percentage],	f.[91% to 100%_shortlisted_applicant_count],	f.[91% to 100%_shortlisted_applicant_percentage]FROM finalCTE AS fINNER JOIN final1CTE t ON t.CP_ID = f.CP_IDORDER BY f.max_date