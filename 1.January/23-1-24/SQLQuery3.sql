WITH PackageCTE AS (
	SELECT
		c.P_ID,number + 1 AS EndNumberCount,DATEADD(MONTH, number, c.cpkStartDate) AS [Start Date],DATEADD(MONTH, number + 1, c.cpkStartDate) AS [Package End Date],
		ROW_NUMBER() OVER(PARTITION BY c.P_ID ORDER BY c.cpkDuration DESC) AS ROW_COUNT
	FROM [mnt].[CandidatePackages] AS c
	JOIN master..spt_values ON type = 'P' AND number < c.cpkDuration
	--WHERE c.P_ID = 8707
)
,rankedCTE AS(
	SELECT P_ID, EndNumberCount, [Start Date], [Package End Date] 
	FROM PackageCTE WHERE ROW_COUNT = (SELECT MAX(ROW_COUNT) FROM PackageCTE WHERE P_ID = PackageCTE.P_ID)   
)
,educationCTE AS (
	SELECT e.P_ID,l.EDULEVEL,
	ROW_NUMBER() OVER(PARTITION BY e.P_ID ORDER BY (SELECT TOP 1 e.PASSING_YEAR) DESC ) AS ROW_COUNT
	FROM [dbo].[EDU] AS e
	INNER JOIN [dbo].[EDULEVEL] AS l ON l.E_CODE = e.EduLevel
)
,salaryCTE AS (
	SELECT 
	s.P_ID,AVG(s.ExpectedSalary) AS Avg_Exp_Salary
	FROM (
	SELECT P_ID, ExpectedSalary, ROW_NUMBER() OVER(PARTITION BY P_ID ORDER BY ApplyID DESC) AS row_count
	FROM bdjCorporate.[dbo].[DBO_JOB_INBOX]) s
	WHERE s.row_count <= 5 --AND s.P_ID = 1400
	GROUP BY s.P_ID
)
,accountsCTE AS (
	SELECT s.P_ID,p.NAME,a.accPhone,
		CASE 
			WHEN a.accGender = 'M' THEN 'MALE'
			WHEN a.accGender = 'F' THEN 'FEMALE'
		END AS SEX,
		DATEDIFF(YEAR, p.BIRTH, GETDATE()) AS Age,
		CONVERT(VARCHAR(100), a.accCreatedON, 101) AS [BdJobs Reg Date],
		DATEDIFF(YEAR, 0, DATEADD(MONTH, s.TExp, 0)) AS Experience,
		--DATEDIFF(YEAR, 0 , s.TExp) AS Exp,
		pa.pkName,i.PaidBy AS [Payment Method],
		CASE
			WHEN i.PaidFrom = 0 THEN 'WAVE'
			WHEN i.PaidFrom = 3 THEN 'F'
		END AS [Paid From],
		CASE 
			WHEN (a.accCatId >= 60 OR a.accCatId = -11) THEN 'Blue Color'
			WHEN (a.accCatId >= 1 AND a.accCatId < 60) OR a.accCatId = -10 THEN 'White Color' 
		END AS [Profile Type],
		cte_e.EDULEVEL,cte.[Package End Date],cte_s.Avg_Exp_Salary,
		ROW_NUMBER() OVER(PARTITION BY s.P_ID ORDER BY s.P_ID) AS ROW_COUNT
		FROM [dbo].[PERSONAL] AS p
		INNER JOIN [dbo].[UserAccounts] AS a ON a.accID = p.ID
		INNER JOIN [dbo].[UserSummary] AS s ON s.P_ID = a.accID
		INNER JOIN [mnt].[CandidatePackages] AS c ON c.P_ID = s.P_ID
		INNER JOIN [dbo].[OnlinePaymentInfoJS] AS i ON c.OPID = i.OPID AND c.P_ID = i.P_ID
		INNER JOIN bdjCorporate.[dbo].[DBO_JOB_INBOX] AS j ON j.P_ID = i.P_ID
		INNER JOIN rankedCTE AS cte ON cte.P_ID = i.P_ID
		INNER JOIN educationCTE AS cte_e ON cte_e.P_ID = i.P_ID
		INNER JOIN salaryCTE AS cte_s ON cte_s.P_ID = cte_e.P_ID
		INNER JOIN [mnt].[Packages] AS pa ON pa.pkId = c.pkId
		WHERE i.TransStatus = 'S' AND i.ServiceID = 87 OR i.ServiceID = 88 OR i.ServiceID = 89
)

SELECT TOP 100 * FROM accountsCTE AS a WHERE a.ROW_COUNT < 2