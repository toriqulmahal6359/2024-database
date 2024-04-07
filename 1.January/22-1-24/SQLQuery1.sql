SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS] --WHERE JP_ID = 1219556
SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS] WHERE JP_ID = 1214923
SELECT TOP 5000 * FROM [dbo].[JobBillInfo] ORDER BY JP_ID DESC
SELECT TOP 5 * FROM [dbo].[COMPANY_BUSINESS]
SELECT TOP 5 * FROM [dbo].[CompanyServices]
SELECT TOP 5 * FROM [dbo].[AppliedJobStatus]
SELECT TOP 5 * FROM [dbo].[SERVICE_LIST]
SELECT TOP 5 * FROM [dbo].[DBO_COMPANY_PROFILES]


GO

--DECLARE
--	@job_type CHAR(3) = NULL;

--	IF(@job_type = 'H')
--	BEGIN
--		PRINT 'HOT JOB'
--	END
--	ELSE IF(@job_type = 'H') 

SELECT 
	j.JP_ID,
	j.JobTitle,
	j.CP_ID,
	j.CompanyName,
	CASE 
		WHEN j.AdType = 0  THEN 'BASIC LISTINGS'
		WHEN j.AdType = 1  THEN 'STANDARD'
		WHEN j.AdType = 2  THEN 'PREMIUM'
		WHEN j.AdType = 10 THEN 'Uddokta'
		WHEN j.Adtype = 11 THEN 'LINKEDIN'
	END AS [AD Type],
	CASE
		WHEN ISNUMERIC(j.CVReceivingOptions) = 1 THEN 'Apply Online'
		WHEN ISNUMERIC(j.CVReceivingOptions) = 2 THEN 'Email'
		WHEN ISNUMERIC(j.CVReceivingOptions) = 3 THEN 'Hard Copy'
		WHEN ISNUMERIC(j.CVReceivingOptions) = 4 THEN 'Walk-in Interview'
		WHEN ISNUMERIC(j.CVReceivingOptions) = 5 THEN 'External Link'
	END AS [CV Recieving Options],
	CASE 
		WHEN b.JType = 'H' THEN 'HOT JOB'
		WHEN b.JType = 'P' OR b.JType = 'H' THEN 'HOT JOB PREMIUM'
		ELSE '' 
	END AS [Service Type],
	CASE 
		WHEN j.RegionalJob = 5 THEN 'PNPL' 
		ELSE ''
		END
	AS [Regional Job Type],
	j.PublishDate
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
	WHERE j.VERIFIED = 1 AND j.OnlineJob = 1
	AND j.PublishDate >= '01/01/2024' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
	ORDER BY j.PublishDate ASC


WITH JobPostingsCTE AS (
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
			END, value), ',') AS CVOptions,
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
			END) AS [Service Type],
		j.PublishDate
		FROM [dbo].[DBO_JOBPOSTINGS] AS j
		INNER JOIN [dbo].[JobBillInfo] AS b ON j.JP_ID = b.JP_ID
		INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS c ON c.CP_ID = j.CP_ID
		CROSS APPLY STRING_SPLIT(j.CVReceivingOptions, ',')
		WHERE j.VERIFIED = 1 AND j.OnlineJob = 1
		AND j.PublishDate >= '01/01/2024' AND j.PublishDate <= CONVERT(VARCHAR(100), GETDATE(), 101)
		GROUP BY j.JP_ID, j.JobTitle, c.CP_ID, c.NAME, j.AdType, j.RegionalJob, j.PublishDate, b.JType
		ORDER BY j.PublishDate ASC
)
,SplitCTE AS (
	SELECT
		--j.JP_ID,
		COALESCE(j.CVOptions,
		CASE  
			WHEN ISNUMERIC(j.CVOptions) = 1 THEN 'Apply Online'
			WHEN ISNUMERIC(j.CVOptions) = 2 THEN 'Email'
			WHEN ISNUMERIC(j.CVOptions) = 3 THEN 'Hard Copy'
			WHEN ISNUMERIC(j.CVOptions) = 4 THEN 'Walk-in Interview'
			WHEN ISNUMERIC(j.CVOptions) = 5 THEN 'External Links'
		END) AS [Apply Options]
		FROM JobPostingsCTE AS j
		--GROUP BY j.JP_ID 
)

SELECT * FROM SplitCTE