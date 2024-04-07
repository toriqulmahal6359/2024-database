;WITH Job_CTE AS (
    SELECT JP_ID 
    FROM bdjCorporate..DBO_JOB_INBOX 
    WHERE P_DATE >= '2024-02-06'
    UNION 
    SELECT B.JP_ID 
    FROM bdjCorporate..JobBillInfo B 
    JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId
    WHERE (I.PAY_STATUS = 1 AND I.INV_DATE >= '2024-02-06')
        OR (I.PAY_STATUS = 0 OR I.PAY_STATUS IS NULL) -- Combine similar conditions
    UNION 
    SELECT B.JP_ID 
    FROM bdjCorporate..JobBillInfo B 
    JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID
    WHERE OP.TransStatus = 'S' AND OP.TransDate >= '2024-02-06'
    UNION 
    SELECT J.JP_ID 
    FROM DBO_JOBPOSTINGS J 
    WHERE J.UPDATED_DATE >= '2024-02-06'
    UNION 
    SELECT J.JP_ID 
    FROM UserJobAccess J 
    WHERE AccessGivenOn >= '2024-02-06'
    UNION 
    SELECT I.JP_ID 
    FROM bdjCorporate..DBO_JOB_INBOX I  
    JOIN rp.ApplicantProcess A ON I.ApplyID = A.ApplyId
    WHERE A.UpdatedOn >= '2024-02-06'
    UNION 
    SELECT I.JP_ID 
    FROM bdjCorporate.rp.TestSteps I 
    WHERE I.UpdatedOn >= '2024-02-06'
    UNION 
    SELECT I.JP_ID 
    FROM bdjCorporate.adm.JobVerificattionStatus I 
    WHERE I.vStatusDate >= '2024-02-06'
), 
job_post_user AS (
    SELECT j.jp_id, UA.UserId,
    ROW_NUMBER() OVER(PARTITION BY j.jp_id ORDER BY ua.accessgivenon) AS [sl]
    FROM Job_CTE j
    JOIN UserJobAccess UA ON j.JP_ID = ua.JP_ID
), 
Job_User_CTE AS (
    SELECT J.JP_ID,
    CAST(UA.UserId AS varchar(10)) + ' (' + 
    CASE WHEN ISNULL(NULL, AccessTillDate) = 0 THEN CAST(CONVERT(Date, AccessTillDate, 101) AS varchar(15)) ELSE '-1' END + 
    ')' AS PrivilegedUsers
    FROM Job_CTE J
    JOIN UserJobAccess UA ON J.JP_ID = UA.JP_ID
    LEFT JOIN CorporateUserAccess CUA ON UA.UserId = CUA.USerId AND CUA.AdminUser = 1
    WHERE CUA.USerId IS NULL
), 
Job_Verification_CTE AS (
    SELECT J.JP_ID, JVS.VStatus AS SalesVerify , JVA.VStatus AS AccountsVerify
    FROM Job_CTE J
    LEFT JOIN adm.JobVerificattionStatus JVS ON JVS.JP_ID = J.JP_ID AND JVS.vStatusFrom = 'Sales'
    LEFT JOIN adm.JobVerificattionStatus JVA ON JVA.JP_ID = J.JP_ID AND JVA.vStatusFrom = 'Accounts'
 ), 
JobPayment_CTE AS (
    SELECT DISTINCT J.JP_ID 
    FROM Job_CTE J
    JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
    JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
    WHERE I.PAY_STATUS = 1 
    UNION 
    SELECT DISTINCT J.JP_ID 
    FROM Job_CTE J 
    JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
    JOIN bdjCorporate..DBO_INVOICE I ON B.InvoiceID = I.InvoiceId 
    JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
    WHERE OP.TransStatus = 'S' AND (I.PAY_STATUS = 0 or I.PAY_STATUS is null)
    UNION 
    SELECT DISTINCT J.JP_ID 
    FROM Job_CTE J 
    JOIN bdjCorporate..JobBillInfo B ON J.JP_ID = B.JP_ID 
    JOIN bdjCorporate..OnlinePaymentInfo OP ON B.OPID = OP.OPID  
    WHERE OP.TransStatus = 'S' 
    UNION 
    SELECT DISTINCT J.JP_ID 
    FROM Job_CTE J 
    JOIN bdjCorporate..dbo_JOBPOSTINGS JJ ON J.JP_ID = JJ.JP_ID
    WHERE JJ.SERVICEID > 0
    UNION
    SELECT DISTINCT C.jp_id 
    FROM job_cte C 
    JOIN DBO_JOBPOSTINGS J ON C.JP_ID = J.JP_ID 
    WHERE J.AdType = 12
), 
CVOption_CTE AS (
    SELECT J.JP_ID,
    STRING_AGG(
        CASE 
            WHEN ISNUMERIC(Value) = 0 THEN  ''
            ELSE CASE 
                    WHEN Value = 1 THEN 'Apply Online'
                    WHEN Value = 2 THEN 'Email'
                    WHEN Value = 3 THEN 'Hard Copy'
                    WHEN Value = 4 THEN 'Walking Interview'
                    WHEN Value = 5 THEN 'External Link'
                    WHEN Value = 6 THEN 'Apply URL'
                END 
        END, ',') AS Options 
    FROM Job_CTE J
    JOIN dbo_JOBPOSTINGS JP ON J.JP_ID = JP.JP_ID
    CROSS APPLY STRING_SPLIT(JP.CVReceivingOptions, ',')
    GROUP BY J.JP_ID
), 
Last_Activity_CTE AS (
    SELECT J.JP_ID, T.TestType AS TestName, 
    ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY T.TestLevel DESC) AS SL
    FROM Job_CTE J
    JOIN bdjCorporate.rp.TestSteps T ON J.JP_ID = T.JP_ID
), 
JobList_CTE AS (
    SELECT J.CP_ID, J.JP_ID, 
    CASE WHEN J.JobLang = 2 THEN BJ.Title ELSE J.JobTitle END AS JobTitle, 
    J.ProceedToPublishDate, J.PostingDate, J.Deadline,
    J.Verified, J.PublishDate, J.Closed,
    CASE 
        WHEN B.JType = 'H' THEN 'Hot Job'
        WHEN B.JType = 'P' THEN 'Hot Job Premium'
        ELSE 
            CASE 
                WHEN J.RegionalJob = 5 THEN 'PNPL'
                WHEN J.RegionalJob = 1 THEN 'Discounted Job'
                WHEN J.RegionalJob = 2 THEN 'Free Service'
                WHEN J.RegionalJob = 3 THEN 'Free Blue Collar'
                WHEN J.RegionalJob = 4 THEN 'Job Fair'
                ELSE 
                    CASE 
                        WHEN J.Adtype = 0 THEN 'Basic'
                        WHEN J.Adtype = 1 THEN 'Standout'
                        WHEN J.Adtype = 2 THEN  'Standout Premium'
                        WHEN J.Adtype = 10 THEN  'Uddokta'
                        WHEN J.Adtype = 11 THEN  'Only Linkedin'
                        WHEN J.Adtype = 12 THEN 'Free'
                    END 
            END 
    END AS ServiceType,
    CASE WHEN J.PublishDate IS NOT NULL OR J.PublishDate <> '' THEN 1 ELSE 0 END AS IsPublished,
    0 AS JobViewed,
    C.Options AS [Apply_Options],
    CASE WHEN J.OwnerOrgType IS NOT NULL OR J.OwnerOrgType <> '' THEN 1 ELSE 0 END AS IsContentVerified,
    STRING_AGG(UJ.PrivilegedUsers, ',') AS PrivilegedUsers,
    J.Drafted AS IsDrafted,
    CASE WHEN j.Org_Type_ID IS NOT NULL AND j.Org_Type_ID <> '' AND j.companyname <> '' AND j.companyname IS NOT NULL THEN 1 ELSE 0 END AS [ContactId],
    jp.UserId
    FROM Job_CTE TJ  
    JOIN DBO_JOBPOSTINGS J ON TJ.JP_ID = J.JP_ID
    LEFT JOIN DBO_BNG_JOBPOSTINGS BJ ON J.jp_id = BJ.jp_id
    LEFT JOIN Job_User_CTE UJ ON TJ.JP_ID = UJ.JP_ID
    JOIN job_post_user jp ON J.JP_ID = jp.JP_ID AND jp.sl = 1
    JOIN CVOption_CTE C ON J.JP_ID = C.JP_ID
    LEFT JOIN JobBillInfo B ON J.JP_ID = B.JP_ID
    GROUP BY J.JobLang, BJ.Title, J.CP_ID, J.JP_ID, J.JobTitle, C.Options, J.ProceedToPublishDate, J.PostingDate, J.Deadline, J.Verified, J.PublishDate, J.Closed, J.PostToLN ,J.Adtype, J.OwnerOrgType, J.RegionalJob, B.JType, J.Drafted, CASE WHEN j.Org_Type_ID IS NOT NULL AND j.Org_Type_ID <> '' AND j.companyname <>'' AND j.companyname IS NOT NULL THEN 1 ELSE 0 END, jp.UserId
)
SELECT J.CP_ID, J.JP_ID, J.JobTitle, J.ProceedToPublishDate, J.PostingDate, J.Deadline, J.Verified, J.PublishDate,
    CASE WHEN J.Closed = 1 THEN 1 ELSE 0 END AS IsPaused,
    CASE WHEN JP.JP_ID IS NOT NULL OR JP.JP_ID <> '' THEN 1 ELSE 0 END AS JobPaymentStatus,
    J.ServiceType, J.IsPublished, JobViewed, JV.SalesVerify, JV.AccountsVerify, J.Apply_Options, J.IsContentVerified, J.IsDrafted,
    TestName, J.PrivilegedUsers, STRING_AGG(CAST(CUA.USERID AS varchar(10)) + ' (-1)', ',') AdminUsers,
    j.ContactId, j.UserId
FROM JobList_CTE J
LEFT JOIN JobPayment_CTE JP ON J.JP_ID = JP.JP_ID 
LEFT JOIN Last_Activity_CTE L ON J.JP_ID = L.JP_ID AND SL = 1
LEFT JOIN Job_Verification_CTE JV ON J.JP_ID = JV.JP_ID
LEFT JOIN CorporateUserAccess CUA ON J.CP_ID = CUA.CP_ID AND AdminUser = 1
GROUP BY J.CP_ID, J.JP_ID, J.JobTitle, J.ProceedToPublishDate, J.Deadline, J.Verified, J.PublishDate, J.Closed, J.IsContentVerified, J.IsDrafted,
    JP.JP_ID, J.ServiceType, J.Apply_Options, J.IsPublished, JobViewed, J.PostingDate, JV.SalesVerify, JV.AccountsVerify, 
    TestName, J.PrivilegedUsers, j.ContactId, j.UserId
ORDER BY J.JP_ID OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
