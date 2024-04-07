SELECT 
		j.JP_ID,
		j.JobTitle,
		c.CP_ID,
		c.NAME AS [Company Name],
		STRING_AGG(COALESCE(
			CASE 
				WHEN value = 1 THEN 'Apply Online'
				WHEN value = 2 THEN 'Email'
				WHEN value = 3 THEN 'Hard Copy'
				WHEN value = 4 THEN 'Walk-in Interview'
				WHEN value = 5 THEN 'External Links' 
			END, value), ',') AS [Apply Options],
		CONCAT(
		CASE 
			WHEN j.AdType = 0  THEN 'BASIC LISTINGS'
			WHEN j.AdType = 1  THEN 'STANDARD'
			WHEN j.AdType = 2  THEN 'PREMIUM'
			WHEN j.AdType = 10 THEN 'Uddokta'
			WHEN j.Adtype = 11 THEN 'LINKEDIN'
		END, ' , ',
		CASE 
			WHEN b.JType = 'H' THEN 'HOT JOB'
			WHEN b.JType = 'P' OR b.JType = 'H' THEN 'HOT JOB PREMIUM'
			ELSE '' 
		END, ' , ', 
		CASE 
			WHEN j.RegionalJob = 5 THEN 'PNPL' 
			ELSE ''
			END) AS [Service Type]
		FROM [dbo].[DBO_JOBPOSTINGS] AS j
		INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
		INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
		CROSS APPLY STRING_SPLIT(j.CVReceivingOptions, ',')
		WHERE j.VERIFIED = 1 AND j.OnlineJob = 1
		AND j.PublishDate >= '01/01/2024' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
		GROUP BY j.JP_ID, j.JobTitle, c.CP_ID, c.NAME, j.AdType, j.RegionalJob, j.PublishDate, b.JType
		ORDER BY j.PublishDate ASC