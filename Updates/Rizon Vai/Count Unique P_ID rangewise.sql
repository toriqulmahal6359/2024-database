--WITH companyCTE AS (
--	SELECT DISTINCT CP_ID, CompanyName
--	--ROW_NUMBER() OVER(PARTITION BY CP_ID ORDER BY CreatedOn DESC) AS r 
--	FROM bdjCorporate.[dbo].[FollowedEmployers]
--	GROUP BY CP_ID, CompanyName
--)
--, rowCTE AS (
--	SELECT DISTINCT CP_ID, CompanyName FROM companyCTE --WHERE r = 1
--)
--, applicantCTE AS (
--	SELECT --DISTINCT f.P_ID, 
--	f.CP_ID, COUNT(DISTINCT f.P_ID) AS [Followers] FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
--	GROUP BY f.CP_ID
--)
--SELECT COUNT(DISTINCT a.[Followers]) 
--FROM applicantCTE AS a
--INNER JOIN rowCTE AS r ON r.CP_ID = a.CP_ID
--WHERE a.[Followers] >= 500 AND a.[Followers] <= 1000
----ORDER BY a.CP_ID



--WITH companyCTE AS (
--	SELECT DISTINCT CP_ID, CompanyName
--	--ROW_NUMBER() OVER(PARTITION BY CP_ID ORDER BY CreatedOn DESC) AS r 
--	FROM bdjCorporate.[dbo].[FollowedEmployers]
--	GROUP BY CP_ID, CompanyName
--)
--, rowCTE AS (
--	SELECT DISTINCT CP_ID, CompanyName FROM companyCTE --WHERE r = 1
--)
--, applicantCTE AS (
--	SELECT --DISTINCT f.P_ID, 
--	f.CP_ID, COUNT(DISTINCT f.P_ID) AS [Followers] FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
--	GROUP BY f.CP_ID
--)
--SELECT COUNT(DISTINCT a.[Followers]) 
--FROM applicantCTE AS a
--INNER JOIN rowCTE AS r ON r.CP_ID = a.CP_ID
--WHERE a.[Followers] >= 500 AND a.[Followers] <= 1000


With applicantCountCTE AS (
	SELECT COUNT(DISTINCT P_ID) AS Followers FROM bdjCorporate.[dbo].[FollowedEmployers] 
	GROUP BY CP_ID, CompanyName
	HAVING COUNT(DISTINCT P_ID) < 100
)
SELECT COUNT(DISTINCT Followers) FROM applicantCountCTE 


-- For 100 Unique P_ID

With applicantCountCTE AS (
	SELECT distinct CP_ID AS Followers FROM bdjCorporate.[dbo].[FollowedEmployers] 
	GROUP BY CP_ID
	HAVING COUNT(P_ID) < 100
)
SELECT COUNT(distinct f.P_ID)
FROM applicantCountCTE a
inner join bdjCorporate.[dbo].[FollowedEmployers]  f on a.Followers = f.CP_ID


-- For 100 to 500

With applicantCountCTE AS (
	SELECT distinct CP_ID AS Followers FROM bdjCorporate.[dbo].[FollowedEmployers] 
	GROUP BY CP_ID
	HAVING COUNT(P_ID) > 100 AND COUNT(P_ID) < 500
)
SELECT COUNT(distinct f.P_ID)
FROM applicantCountCTE a
inner join bdjCorporate.[dbo].[FollowedEmployers]  f on a.Followers = f.CP_ID

-- For Above 500

With applicantCountCTE AS (
	SELECT distinct CP_ID AS Followers FROM bdjCorporate.[dbo].[FollowedEmployers] 
	GROUP BY CP_ID
	HAVING COUNT(P_ID) > 500
)
SELECT COUNT(distinct f.P_ID)
FROM applicantCountCTE a
inner join bdjCorporate.[dbo].[FollowedEmployers]  f on a.Followers = f.CP_ID

-- For Range 500 to 1000

With applicantCountCTE AS (
	SELECT distinct CP_ID AS Followers FROM bdjCorporate.[dbo].[FollowedEmployers] 
	GROUP BY CP_ID
	HAVING COUNT(P_ID) >= 500 AND COUNT(P_ID) <= 1000
)
SELECT COUNT(distinct f.P_ID)
FROM applicantCountCTE a
inner join bdjCorporate.[dbo].[FollowedEmployers]  f on a.Followers = f.CP_ID

-- For Range 1000

With applicantCountCTE AS (
	SELECT distinct CP_ID AS Followers FROM bdjCorporate.[dbo].[FollowedEmployers] 
	GROUP BY CP_ID
	HAVING COUNT(P_ID) > 1000
)
SELECT COUNT(distinct f.P_ID)
FROM applicantCountCTE a
inner join bdjCorporate.[dbo].[FollowedEmployers]  f on a.Followers = f.CP_ID


-- below 50

WITH followersCTE AS (
	SELECT P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY P_ID
	HAVING COUNT(CP_ID) < 50
)

SELECT COUNT(1) FROM followersCTE

-- For 100

WITH followersCTE AS (
	SELECT P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY P_ID
	HAVING COUNT(CP_ID) < 100
)

SELECT COUNT(1) FROM followersCTE


-- For 100 to 500

WITH followersCTE AS (
	SELECT P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY P_ID
	HAVING COUNT(CP_ID) >= 100 AND COUNT(CP_ID) <= 500
)

SELECT COUNT(1) FROM followersCTE

-- Above 500

WITH followersCTE AS (
	SELECT P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY P_ID
	HAVING COUNT(CP_ID) > 500
)

SELECT COUNT(1) FROM followersCTE

-- 500 to 1000

WITH followersCTE AS (
	SELECT P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY P_ID
	HAVING COUNT(CP_ID) >= 500 AND COUNT(CP_ID) <= 1000
)

SELECT COUNT(1) FROM followersCTE

-- For 1000

WITH followersCTE AS (
	SELECT P_ID FROM bdjCorporate.[dbo].[FollowedEmployers] AS f
	GROUP BY P_ID
	HAVING COUNT(CP_ID) > 1000
)

SELECT COUNT(1) FROM followersCTE


-- Cross Check

SELECT COUNT(DISTINCT P_ID) FROM bdjCorporate.[dbo].[FollowedEmployers]






SELECT TOP 5 * FROm bdjCorporate.[dbo].[FollowedEmployers]
