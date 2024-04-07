SELECT TOP 5 * FROM bdjResumes..EDU WHERE EDUCATION LIKE '%phd%' 

WITH cte1 AS (    SELECT DISTINCT p.id AS p_id    FROM bdjResumes.dbo.PERSONAL p 	LEFT join bdjresumes. [dbo].[EDU] e on p.id = e.P_ID	LEFT join bdjresumes.dbo.TRAINING t on p.id = t.P_ID 	where t.TNAME like '%NTQVF%'	)	, cte2 AS (    SELECT c1.p_id, jp.cp_id, ji.jp_id,         CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title]        --ROW_NUMBER() OVER (PARTITION BY c1.p_id ORDER BY jp.cp_id desc) AS R    FROM cte1 c1    INNER JOIN bdjcorporate.dbo.DBO_JOB_INBOX ji ON c1.p_id = ji.p_id    INNER JOIN bdjCorporate.dbo.DBO_JOBPOSTINGS jp ON ji.jp_id = jp.jp_id    LEFT JOIN bdjCorporate.dbo.DBO_BNG_JOBPOSTINGS bj ON bj.JP_ID = jp.JP_ID)SELECT *FROM cte2--WHERE R = 1;SELECT * FROm bdjresumes.dbo.TRAINING WHERE TNAME LIKE '%NTQVF%' --TType LIKE '%Training%'SELECT * FROM bdjresumes. [dbo].[EDU] WHERE P_ID IN (6184948,
4578068,
3205965,
3444160,
6594509,
5967315,
2194210,
3419516,
5285844,
6424238,
6424238
)

SELECT TOP 5 * FROM bdjresumes. [dbo].[EDU]
SELECT TOP 5 * FROM bdjResumes.[dbo].[EDU_NTVQF]



WITH cte1 AS (
    SELECT DISTINCT p.id AS p_id, education, edulevel2, Edulevel, t.tname
    FROM bdjResumes.dbo.PERSONAL p 
	inner join bdjresumes. [dbo].[EDU] e on p.id = e.P_ID
	inner join bdjresumes.dbo.TRAINING t on p.id = t.P_ID 
	where t.TNAME like '%NTQVF%'
	)
	, cte2 AS (
    SELECT c1.p_id, jp.cp_id, ji.jp_id, 
        CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title],
        ROW_NUMBER() OVER (PARTITION BY c1.p_id ORDER BY jp.cp_id desc) AS R
    FROM cte1 c1
    INNER JOIN bdjcorporate.dbo.DBO_JOB_INBOX ji ON c1.p_id = ji.p_id
    INNER JOIN bdjCorporate.dbo.DBO_JOBPOSTINGS jp ON ji.jp_id = jp.jp_id
    LEFT JOIN bdjCorporate.dbo.DBO_BNG_JOBPOSTINGS bj ON bj.JP_ID = jp.JP_ID
	where c1.education is not null and c1.EDULEVEL2 is not null and c1. edulevel is not null
)
SELECT *
FROM cte2
WHERE R = 1;

SELECT * FROM [dbo].[CATEGORY] WHERE CAT_ID = 6

SELECT TOP 5 * FROM [dbo].[EDU] WHERE INSTITUTE LIKE '% Shahjalal University of Science and Technology%'


SELECT 

GO

-- COunt how many cv's who are the student of Shahjalal University of Science and Technology

SELECT COUNT(1) AS [Total CV's] FROM bdjResumes.[dbo].[UserAccounts] AS a
LEFT JOIN bdjResumes.[dbo].[EDU] AS e ON e.P_ID = a.accID
WHERE a.accCatId = 6 AND e.INSTITUTE LIKE '%Shahjalal University of Science%'