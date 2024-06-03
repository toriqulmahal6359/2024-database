CREATE TABLE #temp(
	JP_ID INT
)
INSERT INTO #temp (JP_ID) VALUES 
(1248436),	(1245589),	(1246152),	(1247704),	(1246920),	(1247805),	(1247654),	(1247593),	(1248647),	(1248834),	(1246633),	
(1246631),	(1246636),	(1247833),	(1248561),	(1248558),	(1248546),	(1248721),	(1248777),	(1247962),	(1247984),	(1241962),	(1242733),	(1247342),	(1247440);


--DROP TABLE #temp


--DECLARE @count INT = 0;

--SET @count = COUNT(DISTINCT P_ID)


SELECT JP_ID,  ISNULL(COUNT(DISTINCT P_ID), 0) AS [Apply]
FROM bdjLogs.[crm].[ApplyInfo]

WHERE CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
--AND JP_ID IN (1248436,	1245589,	1246152,	1247704,	1246920,	1247805,	1247654,	1247593,	1248647,	1248834,	
--1246633,	1246631,	1246636,	1247833,	1248561,	1248558,	1248546,	1248721,	1248777,	1247962,	1247984,	1241962,	1242733,	1247342,	1247440
--)
--AND CONVERT(DATE, AppliedOn, 101) = '05/17/2024'

GROUP BY JP_ID
ORDER BY JP_ID DESC

SELECT t.JP_ID, 
	IF COUNT(DISTINCT a.P_ID) = 0 BEGIN 0 END
	ELSE COUNT(DISTINCT ) FROM #temp AS t
LEFT JOIN bdjLogs.[crm].[ApplyInfo] AS a ON t.JP_ID = a.JP_ID
WHERE CONVERT(DATE, a.AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, a.AppliedOn, 101) <= '05/18/2024'
GROUP BY t.JP_ID
 

SELECT JP_ID,  COUNT(DISTINCT P_ID) AS [Applied number by CRM]
FROM bdjLogs.[crm].[ApplyInfo]
WHERE JP_ID IN (1248436,	1245589,	1246152,	1247704,	1246920,	1247805,	1247654,	1247593,	1248647,	1248834,	1246633,	
1246631,	1246636,	1247833,	1248561,	1248558,	1248546,	1248721,	1248777,	1247962,	1247984,	1241962,	1242733,	1247342,	1247440) 
AND CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
--AND CONVERT(DATE, AppliedOn, 101) = '05/17/2024'

GROUP BY JP_ID
ORDER BY JP_ID DESC


--SELECT TOP 10 * FROM bdjLogs.crm.JobInfo

--SELECT TOP  10 * FROM bdjResumes.[dbo].[UserOtherProfiles] WITH(NOLOCk)

--bdjResumes
--bdjCorporate
--arcCorporate
--bdjActiveJobs
--bdjEmails
--bdjLogs

SELECT DISTINCT JP_ID, P_ID, AppliedOn FROM bdjLogs.[crm].[ApplyInfo]
WHERE JP_ID IN (1248436,
1245589,
1246152)
--WHERE JP_ID = 1246152
--AND CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
--GROUP BY JP_ID


SELECT JP_ID, COUNT(DISTINCT P_ID) FROM bdjLogs.[crm].[ApplyInfo]
WHERE CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
AND JP_ID IN (1248436,1245589,1246152)
GROUP BY JP_ID

--1248436
--1245589
--1246152

SELECT * FROM bdjLogs.[crm].[ApplyInfo]




WITH jobCounts AS (
    SELECT JP_ID, COUNT(*) AS AppliedCount
    FROM bdjLogs.[crm].[ApplyInfo]
    WHERE CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
    GROUP BY JP_ID
)
SELECT JP.JP_ID, ISNULL(J.AppliedCount, 0) AS [Applied number by CRM]
FROM (
    SELECT DISTINCT JP_ID 
    FROM bdjLogs.[crm].[ApplyInfo] 
    WHERE JP_ID IN (1248436, 1245589, 1246152, 1247704, 1246920, 1247805, 1247654, 1247593, 1248647, 1248834, 1246633, 
                    1246631, 1246636, 1247833, 1248561, 1248558, 1248546, 1248721, 1248777, 1247962, 1247984, 1241962, 
                    1242733, 1247342, 1247440)
) JP
LEFT JOIN jobCounts j ON JP.JP_ID = J.JP_ID
ORDER BY JP.JP_ID DESC;



WITH AggregatedCounts AS (
    SELECT JP_ID, COUNT(*) AS AppliedCount
    FROM bdjLogs.[crm].[ApplyInfo]
    WHERE CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
    GROUP BY JP_ID
)
SELECT DISTINCT a.JP_ID, ISNULL(AppliedCount, 0) FROM AggregatedCounts AS a
LEFT JOIN bdjLogs.[crm].[ApplyInfo] AS l ON l.JP_ID = a.JP_ID
WHERE a.JP_ID IN (1248436, 1245589, 1246152, 1247704, 1246920, 1247805, 1247654, 1247593, 1248647, 1248834, 1246633, 
                    1246631, 1246636, 1247833, 1248561, 1248558, 1248546, 1248721, 1248777, 1247962, 1247984, 1241962, 
                    1242733, 1247342, 1247440)
--GROUP BY a.JP_ID



WITH AggregatedCounts AS (
    SELECT JP_ID, COUNT(*) AS AppliedCount
    FROM bdjLogs.[crm].[ApplyInfo]
    WHERE CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
    GROUP BY JP_ID
)

SELECT JP.JP_ID, ISNULL(AC.AppliedCount, 0) AS [Applied number by CRM]
FROM (
    SELECT DISTINCT JP_ID 
    FROM bdjLogs.[crm].[ApplyInfo] 
    WHERE JP_ID IN (1248436, 1245589, 1246152, 1247704, 1246920, 1247805, 1247654, 1247593, 1248647, 1248834, 1246633, 
                    1246631, 1246636, 1247833, 1248561, 1248558, 1248546, 1248721, 1248777, 1247962, 1247984, 1241962, 
                    1242733, 1247342, 1247440)
) JP
LEFT JOIN AggregatedCounts AC ON JP.JP_ID = AC.JP_ID
ORDER BY JP.JP_ID DESC;


SELECT JP_ID, CONVERT(DATE, AppliedOn, 101) AS [Date], COUNT(DISTINCT P_ID) AS [Applied number By CRM] FROM bdjLogs.[crm].[ApplyInfo]
WHERE JP_ID = 1246920
AND CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
GROUP BY JP_ID, CONVERT(DATE, AppliedOn, 101)