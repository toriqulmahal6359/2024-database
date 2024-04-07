;WITH Job_CTE AS (
	UNION 
		 SELECT Distinct B.JP_ID 
		 FROM bdjCorporate..JobBillInfo B 
				INNER JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId
		 WHERE I.PAY_STATUS = 1 AND I.INV_DATE >= '2024-02-06'
		 SELECT Distinct B.JP_ID 
		 FROM bdjCorporate..JobBillInfo B 
				INNER JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID
		 WHERE OP.TransStatus = 'S' AND OP.TransDate >= '2024-02-06'
	UNION 
	SELECT J.JP_ID
		, STRING_AGG(CASE WHEN ISNUMERIC(Value) = 0 THEN  ''
		 ELSE CASE WHEN Value=1 THEN 'Apply Online'
			   WHEN Value=2 THEN 'Email'
			   WHEN Value=3 THEN 'Hard Copy'
		       WHEN Value=4 THEN 'Walking Interview'
			   WHEN Value=5 THEN 'External Link'
			   WHEN Value=6 THEN 'Apply URL'
			   END END, ',') AS Options 
	FROM Job_CTE J
		INNER JOIN dbo_JOBPOSTINGS JP ON J.JP_ID = JP.JP_ID
		CROSS APPLY STRING_SPLIT(JP.CVReceivingOptions,',')
GROUP BY J.JP_ID
SELECT
	J.*,
    JV.SalesVerify, 
    JV.AccountsVerify, 
    --J.Apply_Options, 
    --J.IsContentVerified, 
    --J.IsDrafted, 
    TestName 
    --J.PrivilegedUsers, 
    --j.AdminUsers, 
    --j.ContactId, 
    --j.UserId
FROM JobList_CTE J
LEFT JOIN Last_Activity_CTE L ON J.JP_ID = L.JP_ID AND SL = 1
LEFT JOIN Job_Verification_CTE JV ON J.JP_ID = JV.JP_ID
--WHERE J.IsPublished = 1
ORDER BY J.JP_ID
OFFSET 1800 ROWS FETCH NEXT 200 ROWS ONLY
