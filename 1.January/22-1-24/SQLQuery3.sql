;with Split as(
SELECT DISTINCT j.JP_ID,case when J.JobLang = 2 THEN JB.title ELSE J.JobTitle END AS JobTitle,
value CVReceivingOptions,j.CP_ID
,case WHEN (J.AdType = 0 AND J.RegionalJob <> 5 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'Basic Listing' WHEN (J.AdType = 1 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'Standard' WHEN (J.AdType = 2 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'Standard Premium' WHEN (J.AdType = 10 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'Udokta' WHEN (B.JType = 'H' AND B.JType <> 'P') THEN 'Hot Job' WHEN (B.JType = 'H' OR B.JType = 'P') THEN 'Hot Job Premium' WHEN (J.RegionalJob = 5 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'PNPL' WHEN (J.AdType = 11 AND B.JType <> 'H' AND B.JType <> 'P') THEN 'Linkedin' END AS [Apply online]
,c.NAME
FROM DBO_JOBPOSTINGS j CROSS APPLY STRING_SPLIT(CVReceivingOptions, ',')
INNER JOIN DBO_COMPANY_PROFILES c on j.CP_ID = c.CP_ID
LEFT JOIN DBO_BNG_JOBPOSTINGS jB on j.JP_ID = jB.JP_ID
LEFT JOIN JobBillInfo B on j.JP_ID = B.JP_ID
where j.PublishDate >= '01/01/2024' and j.PublishDate < GETDATE() and j.OnlineJob=1 and j.VERIFIED = 1

)
select s.JP_ID,s.Jobtitle,s.CP_ID,s.NAME, STRING_AGG(case when CVReceivingOptions = 1 then 'Apply Online' when CVReceivingOptions = 2 then 'Email' when CVReceivingOptions = 3 then 'Hard Copy' when CVReceivingOptions = 4 then 'Walking Interview' when CVReceivingOptions = 5 then 'External Link' end,',')  as apply,s.[Apply online]
from Split s
group by s.JP_ID,s.Jobtitle,s.CP_ID,s.NAME,s.[Apply online]