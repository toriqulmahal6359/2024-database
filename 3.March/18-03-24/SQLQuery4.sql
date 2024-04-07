WITH companyCTE AS (
	SELECT DISTINCT CP_ID, CompanyName,
	COUNT(DISTINCT P_ID) AS [Followers] FROM bdjCorporate.[dbo].[FollowedEmployers]
	GROUP BY CP_ID, CompanyName 
)
, jobCTE AS (
SELECT c.CP_ID, COUNT(DISTINCT j.JP_ID) AS [Job Count] FROM companyCTE AS c
INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.CP_ID = c.CP_ID
GROUP BY c.CP_ID
)

SELECT c.*, j.[Job Count] FROM jobCTE AS j
INNER JOIN companyCTE AS c ON c.CP_ID = j.CP_ID


--SELECT TOP 5 * FROM bdjCorporate..DBO_JOBPOSTINGS

--SELECT CP_ID, CompanyName FROM bdjCorporate.[dbo].[FollowedEmployers] WHERE CP_ID =  20131 --20109 AND CompanyName LIKE '%Square%' --20109 --20144 --18063 --18114 20084
--SELECT COUNT(JP_ID) FROM bdjCorporate..DBO_JOBPOSTINGS WHERE CP_ID = 28640