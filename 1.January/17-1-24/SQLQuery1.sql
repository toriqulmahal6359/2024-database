SELECT  TOP 67 * FROM UserAccounts WHERE accID = 985--ORDER BY accID DESC
SELECT TOP 5 * FROM [dbo].[PERSONAL]
SELECT TOP 5 * FROM [dbo].[UserSummary] WHERE P_ID = 5691683--P_ID = 3651040
SELECT TOP 5 * FROM [dbo].[CATEGORY]
SELECT TOP 5 * FROM [dbo].[CV_Verification]
SELECT TOP 5 * FROM [dbo].[expCVs]
SELECT TOP 5 * FROM [vdo].[VideoResumes]
SELECT TOP 5 * FROM [dbo].[PersonalOthers]
SELECT TOP 5 * FROM [dbo].[PersonalExtras]
SELECT TOP 5 * FROM [dbo].[expCVs] 
SELECT TOP 5 * FROM [dbo].[EXP]
--SELECT TOP 5 DATEADD(YEAR, DATEDIFF(MONTH, 0, u.TExp), GETDATE()) FROM [dbo].[UserSummary] AS u ORDER BY P_ID DESC
--SELECT TOP 5 DATEADD(YEAR, , DATEADD(MONTH, 12, u.TExp)) FROM [dbo].[UserSummary] AS u ORDER BY P_ID DESC

--SELECT TOP 5 DATEDIFF(YEAR, DATEADD(MONTH, 12, GETDATE()), u.TExp) FROM [dbo].[UserSummary] AS u 
--SELECT TOP 5 DATEDIFF(YEAR, 0, DATEADD(MONTH, us.TExp, 0)) AS Experience FROM UserSummary AS us WHERE P_ID = 955
SELECT TOP 5 FLOOR(us.TExp/12) AS Experience FROM UserSummary AS us WHERE P_ID = 955

WITH BaseCTE AS (
	SELECT
		TOP 1000 u.accID, 
			u.accCatId,
			c.CAT_NAME,
			--DATEADD(MONTH, 12, u.accCreatedOn)
			--FLOOR(us.TExp/12) AS Experience,
			DATEDIFF(YEAR, 0, DATEADD(MONTH, us.TExp, 0)) AS Experience,
			CASE WHEN u.CVPosted = 1 THEN 'YES'
				ELSE 'NO'
			END AS CVPosted,
			DATEDIFF(YEAR, BIRTH, GETDATE()) AS Age,
			CASE WHEN p.IsActivate = 1 THEN 'YES'
				ELSE 'NO'
			END AS CVActivated

			--DATEADD(YEAR, DATEDIFF(YEAR, DATEADD(MONTH, -12, us.TExp), GETDATE()), GETDATE()) AS Experience
			--DATEDIFF(MONTH, 12, us.TExp) AS Experience
			--DATEDIFF(YEAR, DATEADD(MONTH, 12, us.TExp), GETDATE()) AS Experience
		FROM UserAccounts AS u 
		LEFT JOIN CATEGORY AS c ON u.accCatID = c.CAT_ID 
		LEFT JOIN UserSummary AS us ON us.P_ID = u.accID
		LEFT JOIN PERSONAL AS p ON p.ID = u.accID
		WHERE u.accCreatedOn BETWEEN u.accCreatedOn AND GETDATE()
			  AND c.CAT_ID >= 60 OR c.CAT_ID = -11
			  AND u.BlueColar = 1
)

SELECT TOP 10 * FROM BaseCTE ORDER BY accID DESC

SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, SaleDate), 0) AS [year_month_date_field]
FROM Sales

SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(DAY, <number_of_days>, 0)), 0) AS [month_date_field]
FROM (SELECT 286 AS [number_of_days]) AS [input]


SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(DAY, <number_of_days>, 0)), us.TExp) AS [month_date_field]
FROM (SELECT 286 AS [number_of_days]) AS [input]


SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(DAY, <number_of_days>, 0)), 0) AS [month_date_field]
FROM (SELECT 286 AS [number_of_days]) AS [input]

--SELECT username, password FROM User
--WHERE username <> 'Somiron' password = '123'

SELECT DATEDIFF(YEAR, 0, DATEADD(MONTH, 286, us.TExp)) AS [years], MONTH(DATEADD(MONTH, 286, 0)) AS [months]


WITH BaseCTE AS (
	SELECT
		TOP 10 u.accID, 
			u.accCatId,
			--c.CAT_NAME,
			u.accCreatedOn,
			DATEDIFF(YEAR, 0, DATEADD(MONTH, us.TExp, 0)) AS Experience,
			CASE WHEN u.CVPosted = 1 THEN 'YES'
				ELSE 'NO'
			END AS CVPosted,
			DATEDIFF(YEAR, BIRTH, GETDATE()) AS Age,
			CASE WHEN p.IsActivate = 1 THEN 'YES'
				ELSE 'NO'
			END AS CVActivated
		FROM UserAccounts AS u 
		LEFT JOIN CATEGORY AS c ON u.accCatID = c.CAT_ID 
		LEFT JOIN UserSummary AS us ON us.P_ID = u.accID
		LEFT JOIN PERSONAL AS p ON p.ID = u.accID
		WHERE u.accCreatedOn >= DATEADD(MONTH, -12, GETDATE())
			  AND u.accCatId <= 60 OR u.accCatId= -11
			  --AND u.BlueColar = 1
)

SELECT TOP 10 * FROM BaseCTE



