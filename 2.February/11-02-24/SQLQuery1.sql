SELECT * FROM [bdjCorporate]..DBO_COMPANY_PROFILES

SELECT * FROM [dbo].[DBO_JOBPOSTINGS]

SELECT TOP 5 * FROM [dbo].[JobBillInfo]


SELECT j.JP_ID, 
	CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS JobTitle,
	CASE 
		WHEN b.JType = 'H' THEN 'Hot Jobs'
		WHEN b.JType = 'P' THEN 'Hot Jobs Premium' 
		ELSE CASE
				WHEN j.RegionalJob = 1 THEN 'Discounted Job'
				WHEN j.RegionalJob = 2 THEN 'Free Service'
				WHEN j.RegionalJob = 3 THEN 'Free Bluie Collar'
				WHEN j.RegionalJob = 4 THEN 'Job Fair'
				WHEN j.RegionalJob = 5 THEN 'PNPL'
				ELSE CASE 
					WHEN j.AdType = 0 THEN 'Basic'
					WHEN j.AdType = 1 THEN 'Standout'
					WHEN j.AdType = 2 THEN 'Standout Premium'
					WHEN j.AdType = 10 THEN 'Uddokta'
					WHEN j.AdType = 11 THEN 'Only LinkedIn'
					WHEN j.AdType = 12 THEN 'Free'
	END END END AS [Job Type],
	j.CP_ID,
	c.NAME AS [Company Name],
	c.ACCT_CR AS [Account Creation Date]
FROM [dbo].[DBO_JOBPOSTINGS] AS j
LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
LEFT JOIN [bdjCorporate]..DBO_COMPANY_PROFILES AS c ON c.CP_ID = j.CP_ID
Left JOIN [dbo].[JobBillInfo] AS b ON b.JP_ID = j.JP_ID
WHERE j.PublishDate >= '01/01/2024 00:00:00' AND j.PublishDate < '02/01/2024 00:00:00' and J.VERIFIED = 1 and J.OnlineJob=1
AND j.CP_ID NOT IN(121137, 121139, 121143, 121147, 121148, 121150, 121173, 121175, 121176, 110412, 35450, 121175, 121215, 121196)
AND c.NAME NOT LIKE '%sadman_test%'
AND c.NAME NOT LIKE '%sakib_test%'
AND c.NAME NOT LIKE '%Awwab Test Account%'
AND c.NAME NOT LIKE '%sadman123_live%'
AND c.NAME NOT LIKE '%sakib_free%'
ORDER BY JP_ID DESC

