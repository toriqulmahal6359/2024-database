SELECT CONVERT(Date, TransDate, 101) AS [Date],
for_0 = COUNT(DISTINCT CASE WHEN PostedByAccounts = 0 THEN OPID END),      -- Not P_ID
for_1 = COUNT(DISTINCT CASE WHEN PostedByAccounts = 1 THEN OPID END)
FROM bdjResumes..OnlinePaymentInfoJS 
WHERE CONVERT(Date, TransDate, 101) >= '03/01/2024' AND CONVERT(Date, TransDate, 101) <= '03/03/2024'
AND ServiceId = 87 AND TransStatus = 'S'
GROUP BY CONVERT(Date, TransDate, 101)

--ORDER BY OPID DESC

--SELECT TOP 5 * FROM bdjResumes..OnlinePaymentInfoJS