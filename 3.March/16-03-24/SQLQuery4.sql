SELECT t.JP_ID,  COUNT(DISTINCT t.TestType) AS [Steps Count]
FROM bdjCorporate..DBO_JOBPOSTINGS AS j
LEFT JOIN bdjCorporate.rp.TestSteps AS t ON t.JP_ID = j.JP_ID
WHERE j.DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) 
AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND j.Drafted = 0 
AND j.RegionalJob <> 4 AND j.CLosed = 0
GROUP BY t.JP_ID
HAVING COUNT(DISTINCT t.TestType) = 4

SELECT * FROm bdjCorporate.rp.TestSteps WHERE JP_ID = 1231227

SELECT TOP 5 * FROM bdjCorporate.[rp].[ApplicantsResponse]