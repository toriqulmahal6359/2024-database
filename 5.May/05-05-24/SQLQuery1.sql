SELECT j.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title], j.CAT_ID, j.PublishDate 
FROM bdjCorporate..DBO_JOBPOSTINGS AS j
LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
WHERE 
j.PublishDate >= '01/01/2024'
AND j.JobTitle LIKE '%Medical Technologist%'
AND j.Verified = 0 AND j.Drafted = 0 AND j.PublishDate IS NOT NULL;