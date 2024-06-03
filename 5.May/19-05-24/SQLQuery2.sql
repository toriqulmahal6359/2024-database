CREATE TABLE #temp(
	JP_ID INT
)
INSERT INTO #temp (JP_ID) VALUES 
(1248436),	(1245589),	(1246152),	(1247704),	(1246920),	(1247805),	(1247654),	(1247593),	(1248647),	(1248834),	(1246633),	
(1246631),	(1246636),	(1247833),	(1248561),	(1248558),	(1248546),	(1248721),	(1248777),	(1247962),	(1247984),	(1241962),	(1242733),	(1247342),	(1247440);

--DROP TABLE #temp
--SELECT * FROM #temp

;with finalcte as(
SELECT JP_ID,  COUNT(DISTINCT P_ID) c
FROM bdjLogs.[crm].[ApplyInfo]
WHERE CONVERT(DATE, AppliedOn, 101) >= '05/17/2024' AND CONVERT(DATE, AppliedOn, 101) <= '05/18/2024'
GROUP BY JP_ID
)
select t.JP_ID, ISNULL(f.c, 0)--,case when f.c is null then  0 else f.c end
from #temp t
left join finalcte f on t.JP_ID=f.JP_ID

SELECT * FROM bdjEmails..ADMIN


--CRM username from ADMIN table

SELECT DISTINCT ad.USER_NAME, a.UserID FROM bdjLogs.[crm].[ApplyInfo] AS a
LEFT JOIN bdjEmails..ADMIN AS ad ON a.UserID = ad.ID
--LEFT JOIN bdjResumes..userAccounts AS ua ON a.P_ID = ua.accId
WHERE CONVERT(DATE, AppliedOn, 101) = '05/17/2024'