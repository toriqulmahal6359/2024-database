WITH companyCTE AS (
	SELECT DISTINCT CP_ID, COUNT(DISTINCT P_ID) AS [Followers] FROM bdjCorporate.[dbo].[FollowedEmployers]
	GROUP BY CP_ID
)
--, nameCTE AS (
SELECT c.CP_ID, STRING_AGG(cmp.CompanyName, ',') AS [Company], c.Followers
--, ROW_NUMBER() OVER(PARTITION BY c.CP_ID ORDER BY c.CP_ID) AS r 
FROM companyCTE AS c
INNER JOIN bdjCorporate.[dbo].[FollowedEmployers] AS cmp ON cmp.CP_ID = c.CP_ID
GROUP BY c.CP_ID, c.[Followers]
ORDER BY c.CP_ID
--)
--SELECT CP_ID, CompanyName, Followers FROM nameCTE WHERE r = 1
--ORDER BY CP_ID