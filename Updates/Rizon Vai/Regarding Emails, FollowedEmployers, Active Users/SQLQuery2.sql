WITH companyCTE AS (
	SELECT DISTINCT CP_ID, CompanyName, 
	ROW_NUMBER() OVER(PARTITION BY CP_ID ORDER BY CreatedOn DESC) AS r FROM bdjCorporate.[dbo].[FollowedEmployers]
	GROUP BY CP_ID, CompanyName, CreatedOn
)
, rowCTE AS (
	SELECT CP_ID, CompanyName FROM companyCTE WHERE r = 1
)
, applicantCTE AS (
	SELECT --DISTINCT f.P_ID, 
	f.CP_ID, COUNT(DISTINCT f.P_ID) AS [Followers] FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY f.CP_ID
)
SELECT a.CP_ID, r.CompanyName, a.[Followers] FROM applicantCTE AS a
INNER JOIN rowCTE AS r ON r.CP_ID = a.CP_ID
ORDER BY a.CP_ID


WITH companyCTE AS (
	SELECT DISTINCT CP_ID, COUNT(DISTINCT P_ID) AS [Followers] FROM bdjCorporate.[dbo].[FollowedEmployers]
	GROUP BY CP_ID
)
, nameCTE AS (
SELECT c.CP_ID, cmp.CompanyName, c.Followers,
ROW_NUMBER() OVER(PARTITION BY c.CP_ID ORDER BY c.CP_ID) AS r 
FROM companyCTE AS c
INNER JOIN bdjCorporate.[dbo].[FollowedEmployers] AS cmp ON cmp.CP_ID = c.CP_ID
)
SELECT CP_ID, CompanyName, Followers FROM nameCTE WHERE r = 1
ORDER BY CP_ID


SELECT TOP 10 * FROM bdjCorporate.[dbo].[FollowedEmployers]