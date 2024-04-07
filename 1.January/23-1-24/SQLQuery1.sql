SELECT TOP 100 * FROM [dbo].[UserAccounts] ORDER BY accID DESC
SELECT TOP 5 * FROM [dbo].[UserSummary]
SELECT TOP 5 * FROM [dbo].[PaymentInfoJS]
SELECT TOP 5 * FROM [dbo].[EDULEVEL]
SELECT TOP 5 * FROM [dbo].[EDU]
SELECT TOP 5 * FROM bdjCorporate.[dbo].[DBO_JOB_INBOX]
SELECT TOP 500 * FROM [mnt].[CandidatePackages]
SELECT TOP 5 * FROM [mnt].[Packages]
SELECT TOP 500 * FROM [dbo].[OnlinePaymentInfoJS]
SELECT TOP 5 * FROM [dbo].[PERSONAL]

GO

WITH AccountsCTE AS (
	SELECT TOP 5
		s.P_ID,
		p.NAME,
		a.accPhone,
		a.accGender,
		p.BIRTH,
		a.accCreatedON
		FROM [dbo].[PERSONAL] AS p
		INNER JOIN [dbo].[UserAccounts] AS a ON a.accID = p.ID
		INNER JOIN [dbo].[UserSummary] AS s ON s.P_ID = a.accID
)
,PurchaseCTE AS (
	SELECT 
	i.P_ID,
	p.pkName,
	i.PaidBy AS [Payment Method]
	FROM [mnt].[CandidatePackages] AS c
	INNER JOIN [dbo].[OnlinePaymentInfoJS] AS i ON c.OPID = i.OPID AND c.P_ID = i.P_ID
	INNER JOIN [mnt].[Packages] AS p ON p.pkId = c.pkId
		WHERE i.TransStatus = 'S' AND i.ServiceID = 87 OR i.ServiceID = 88 OR i.ServiceID = 89
)

SELECT a.*, p.* 
FROM PurchaseCTE AS p
INNER JOIN AccountsCTE AS a ON a.P_ID = p.P_ID

SELECT 
	c.P_ID,
	number + 1 AS EndNumberCount,
	DATEADD(MONTH, number, c.cpkStartDate) AS [Start Date],
	DATEADD(MONTH, number + 1, c.cpkStartDate) END AS [Package End Date],
	ROW_NUMBER() OVER(PARTITION BY c.P_ID ORDER BY (SELECT TOP 1 c.P_ID) DESC) AS Row_COUNT
FROM [mnt].[CandidatePackages] AS c
JOIN master..spt_values ON type = 'P' AND number < c.cpkDuration
WHERE c.P_ID = 8707
ORDER BY c.P_ID






SELECT 
	i.P_ID,
	p.pkName,
	i.PaidBy AS [Payment Method]
	FROM [mnt].[CandidatePackages] AS c
	INNER JOIN [dbo].[OnlinePaymentInfoJS] AS i ON i.P_ID = c.P_ID 
	INNER JOIN [mnt].[Packages] AS p ON p.pkId = c.pkId AND p.ServiceID = i.ServiceID
	
	--INNER JOIN AccountsCTE AS a ON a.P_ID = i.P_ID
WHERE i.TransStatus = 'S' AND i.ServiceID = 87 AND i.ServiceID = 88 AND i.ServiceID = 89

