WITH BaseCTE AS (
	SELECT DISTINCT
		s.P_ID,
		p.NAME,
		a.accPhone,
		--DATEDIFF(YEAR, 0, DATEADD(MONTH, s.TExp, 0)) AS Experience,
		CONCAT(DATEDIFF(MONTH, 0, DATEADD(MONTH, s.TExp, 0)) / 12, ' years ', DATEDIFF(MONTH, 0, DATEADD(MONTH, s.TExp, 0)) % 12, ' months')  AS Experience,
		CASE 
			WHEN a.accGender = 'M' THEN 'MALE'
			WHEN a.accGender = 'F' THEN 'FEMALE'
		END AS SEX,
		--DATEDIFF(YEAR, p.BIRTH, GETDATE()) AS Age,
		--CONCAT(DATEDIFF(YEAR, p.BIRTH, GETDATE()), ' years ', DATEDIFF(MONTH, p.BIRTH, GETDATE()) % 12, ' months') AS Age,
		CONCAT(DATEDIFF(YEAR, p.BIRTH, GETDATE()) -
			CASE 
			WHEN MONTH(p.BIRTH) > MONTH(GETDATE()) OR
				(MONTH(p.BIRTH)) = MONTH(GETDATE()) OR (DAY(p.BIRTH) > DAY(GETDATE()))
			THEN 1
			ELSE 0
		END, ' years ',
		12 - MONTH(p.BIRTH) + MONTH(GETDATE()) -
			CASE 
            WHEN DAY(p.BIRTH) > DAY(GETDATE()) 
            THEN 1 
            ELSE 0 
        END, ' months') AS AGE,
		CONVERT(VARCHAR(100), a.accCreatedON, 101) AS [BdJobs Reg Date],
		CASE
			WHEN i.PaidFrom = 0 THEN 'WEB'
			WHEN i.PaidFrom = 3 THEN 'APP'
		END AS [Paid From],
		CASE 
			WHEN (a.accCatId >= 60 OR a.accCatId = -11) THEN 'Blue Color'
			WHEN (a.accCatId >= 1 AND a.accCatId < 60) OR a.accCatId = -10 THEN 'White Color' 
		END AS [Profile Type],
		pa.pkName AS [Package Name],
		i.PaidBy AS [Payment Method],
		i.BdjAmount AS Price
		FROM [dbo].[PERSONAL] AS p
		INNER JOIN [dbo].[UserAccounts] AS a ON a.accID = p.ID
		INNER JOIN [dbo].[UserSummary] AS s ON s.P_ID = a.accID
		INNER JOIN [mnt].[CandidatePackages] AS c ON c.P_ID = s.P_ID
		INNER JOIN [dbo].[OnlinePaymentInfoJS] AS i ON c.OPID = i.OPID AND c.P_ID = i.P_ID
		INNER JOIN [mnt].[Packages] AS pa ON pa.pkId = c.pkId
		WHERE i.TransStatus = 'S' AND i.ServiceID IN (87, 88, 89)
)
,educationCTE AS (
	SELECT DISTINCT
		b.*,
		l.EDULEVEL,
	ROW_NUMBER() OVER(PARTITION BY e.P_ID ORDER BY (SELECT TOP 1 e.PASSING_YEAR) DESC ) AS ROW_COUNT_EDU
	FROM [dbo].[EDU] AS e
	INNER JOIN [dbo].[EDULEVEL] AS l ON l.E_CODE = e.EduLevel
	INNER JOIN BaseCTE AS b ON b.P_ID = e.P_ID
)
, packageCTE AS (
	SELECT DISTINCT
		e.*,
		c.cpkStartDate AS [Purchase Date],
		DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS [Package End Date]
	FROM [mnt].[CandidatePackages] AS c
	INNER JOIN educationCTE AS e ON e.P_ID = c.P_ID
	WHERE e.ROW_COUNT_EDU < 2
)
, salaryCTE AS (
	SELECT s.P_ID, s.ExpectedSalary,
	ROW_NUMBER() OVER(PARTITION BY s.P_ID ORDER BY s.P_DATE DESC) AS ROW_COUNT_SALARY
		FROM bdjCorporate.[dbo].[DBO_JOB_INBOX] AS s
)

SELECT p.*, AVG(s.ExpectedSalary) AS Average_Salary
FROM packageCTE AS p
INNER JOIN salaryCTE AS s ON s.P_ID = p.P_ID
GROUP BY p.P_ID, 
	p.NAME, 
	p.accPhone, 
	p.Experience, 
	p.SEX, 
	p.Age, 
	p.[BdJobs Reg Date], 
	p.[Paid From], 
	p.[Profile Type], p.EDULEVEL, p.ROW_COUNT_EDU, p.[Purchase Date], p.[Package End Date], p.[Payment Method], p.Price, p.[Package Name]