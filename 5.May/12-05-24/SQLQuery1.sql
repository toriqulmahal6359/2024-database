--;WITH Comment_CTE AS(-- SELECT -- 	 J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName -- 	,ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r -- FROM Dbo_JobPostings AS Jo -- 	 INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID -- 	 LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID -- WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000) -- AND Jo.deleted = 0 AND Jo.drafted = 0   -- AND jo.ProceedToPublishDate BETWEEN '05/02/2024' AND DATEADD(DAY, 1, '05/09/2024') --  AND Jo.RegionalJob <> 4-- ),--Final_CTE AS(-- 	SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName FROM Comment_CTE WHERE r = 1 --)--SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID --, PayStatus = (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) --, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine --, J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom--, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment --, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur, COUNT(JC.ID) AS TotalComment --, CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over() --   FROM Dbo_Company_Profiles AS C --		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID --		LEFT JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID --		LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID --		LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID --		LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID --		LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID --		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID --		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' --		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID --		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' --		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID -- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0   -- AND j.ProceedToPublishDate BETWEEN '05/05/2024' AND DATEADD(DAY, 1, '05/09/2024') --  AND C.Acct_CR >= '05/10/2024' AND (J.ServiceID is null Or J.ServiceID = 0)  AND JVS.VStatus=4  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 -- GROUP BY --  J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob --, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed --, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom --, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME --, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName -- ORDER BY --  ProceedToPublishDate desc, J.JP_ID DESC --  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 


--;WITH Comment_CTE AS(	SELECT J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName, ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r 
-- FROM Dbo_JobPostings AS Jo inner join adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID 
-- where (Jo.JP_ID < 200000 or Jo.JP_ID>=400000) AND Jo.deleted = 0 AND Jo.drafted = 0   And jo.ProceedToPublishDate 
-- Between '5/5/2024' AND DATEADD(day, 1, '5/9/2024')  AND Jo.RegionalJob <> 4   ),Final_CTE 
-- AS(SELECT JP_ID, Comment,vStatusFrom, PostedOn,UName 
-- FROM Comment_CTE WHERE r = 1 ) SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID,  PayStatus=(SELECT COUNT(Pay_Status) FROM Dbo_Invoice 
-- WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID), J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, 
-- JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus,
-- JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,COUNT(JC.ID) AS TotalComment ,
-- CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over()  
-- FROM Dbo_Company_Profiles AS C 
-- inner JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID 
-- left JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID 
-- LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID 
-- LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID 
-- LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID
-- LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID 
-- LEFT JOIN  CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID 
-- LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' 
-- LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID  LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' 
-- LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  
-- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  And j.ProceedToPublishDate 
-- Between '5/5/2024' AND DATEADD(day, 1, '5/9/2024')  and C.Acct_CR>='5/10/2024' AND (J.ServiceID is null Or J.ServiceID=0)  and JVS.VStatus=4 and  
-- isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 
 
--GROUP BY J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, 
-- J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, 
-- JVS.vStatusFrom,SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions 
-- ,C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName  
-- ORDER BY ProceedToPublishDate desc, J.JP_ID DESC  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY
 



 -- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0    --AND j.ProceedToPublishDate BETWEEN '05/02/2024' AND DATEADD(DAY, 1, '05/09/2024')  -- AND C.Acct_CR >= '05/10/2024' AND (J.ServiceID is null Or J.ServiceID = 0)  AND JVS.VStatus=4  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 


 -- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  And j.ProceedToPublishDate 
 --Between '5/5/2024' AND DATEADD(day, 1, '5/9/2024')  and C.Acct_CR>='5/10/2024' AND (J.ServiceID is null Or J.ServiceID=0)  and JVS.VStatus=4 and  
 --isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 

-- ;WITH Comment_CTE AS(-- SELECT -- 	 J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName -- 	,ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r -- FROM Dbo_JobPostings AS Jo -- 	 INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID -- 	 LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID -- WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000) -- AND Jo.deleted = 0 AND Jo.drafted = 0   -- AND jo.ProceedToPublishDate BETWEEN '05/02/2024' AND DATEADD(DAY, 1, '05/09/2024') --  AND Jo.RegionalJob <> 4-- ),--Final_CTE AS(-- 	SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName FROM Comment_CTE WHERE r = 1 --)--SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID --, PayStatus = (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) --, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine --, J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom--, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment --, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur, COUNT(JC.ID) AS TotalComment --, CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over() --   FROM Dbo_Company_Profiles AS C --		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID --		LEFT JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID --		LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID --		LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID --		LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID --		LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID --		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID --		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' --		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID --		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' --		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID -- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0   -- AND j.ProceedToPublishDate BETWEEN '05/05/2024' AND DATEADD(DAY, 1, '05/09/2024') --  AND j.Verified=1 AND JVS.VStatus=4  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 -- GROUP BY --  J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob --, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed --, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom --, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME --, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName -- ORDER BY --  ProceedToPublishDate desc, J.JP_ID DESC --  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 


--;WITH Comment_CTE AS(	SELECT J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName, ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r 
--FROM Dbo_JobPostings AS Jo inner join adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID 
--where (Jo.JP_ID < 200000 or Jo.JP_ID>=400000) AND Jo.deleted = 0 AND Jo.drafted = 0   And jo.ProceedToPublishDate Between '5/5/2024' AND DATEADD(day, 1, '5/9/2024')  
--AND Jo.RegionalJob <> 4   ),Final_CTE AS(SELECT JP_ID, Comment,vStatusFrom, PostedOn,UName FROM Comment_CTE WHERE r = 1 ) SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, 
--J.ServiceID,  PayStatus=(SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID), J.ADTYPE , J.RegionalJob, JBI.JType, 
--J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, 
--JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,
--C.IsEntrepreneur,COUNT(JC.ID) AS TotalComment ,CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over()   
--FROM Dbo_Company_Profiles AS C 
--inner JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID 
--left JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID 
--LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID 
--LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID 
--LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID 
--LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID 
--LEFT JOIN  CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID 
--LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' 
--LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID  
--LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' 
--LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  
--WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  And j.ProceedToPublishDate Between '5/5/2024' AND DATEADD(day, 1, '5/9/2024') 
--and j.Verified=1 and JVS.VStatus=4 and  isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 
--GROUP BY J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE ,
--J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, 
--JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom,SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,
--J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName  
--ORDER BY ProceedToPublishDate desc, J.JP_ID DESC  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 




-- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0   -- AND j.ProceedToPublishDate BETWEEN '05/02/2024' AND DATEADD(DAY, 1, '05/09/2024') --  AND j.Verified=1 AND JVS.VStatus=4  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4
  

--  WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  And j.ProceedToPublishDate Between '5/5/2024' AND DATEADD(day, 1, '5/9/2024') 
--and j.Verified=1 and JVS.VStatus=4 and  isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4


--;WITH Comment_CTE AS(-- SELECT -- 	 J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName -- 	,ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r -- FROM Dbo_JobPostings AS Jo -- 	 INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID -- 	 LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID -- WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000) -- AND Jo.deleted = 0 AND Jo.drafted = 0   AND Jo.RegionalJob <> 4-- ),--Final_CTE AS(-- 	SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName FROM Comment_CTE WHERE r = 1 --)--SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID --, PayStatus = (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) --, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine --, J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom--, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment --, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur, COUNT(JC.ID) AS TotalComment --, CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over() --   FROM Dbo_Company_Profiles AS C --		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID --		LEFT JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID --		LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID --		LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID --		LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID --		LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID --		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID --		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' --		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID --		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' --		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID -- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0   -- AND JVS.vStatusDate BETWEEN '05/05/2024' AND '05/12/2024' --  AND j.Verified=1 AND JVA.VStatus=4  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 -- GROUP BY --  J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob --, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed --, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom --, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME --, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName  -- ORDER BY --   JVS.vStatusDate desc, JVS.VStatus DESC-- , JVA.vStatusDate ASC--, CASE WHEN JVS.VStatus IS NOT NULL AND JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC --  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 
--;WITH Comment_CTE AS(	SELECT J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName, ROW_NUMBER() --OVER(PARTITION BY J.JP_ID --ORDER BY J.ID DESC) r --FROM Dbo_JobPostings AS Jo --inner join adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID --LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID --where (Jo.JP_ID < 200000 or Jo.JP_ID>=400000) AND Jo.deleted = 0 AND Jo.drafted = 0   AND Jo.RegionalJob <> 4   ),--Final_CTE AS(SELECT JP_ID, Comment,vStatusFrom, PostedOn,UName FROM Comment_CTE WHERE r = 1 ) --SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID,  PayStatus=(SELECT COUNT(Pay_Status) --FROM Dbo_Invoice --WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID), J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, --JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, --JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,COUNT(JC.ID) --AS TotalComment ,CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, --COUNT(1) Over()   --FROM Dbo_Company_Profiles AS C --inner JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID --left JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID --LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID --LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID--LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID --LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID --LEFT JOIN  CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID --LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' --LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID  --LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' --LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  --WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  and JVS.vStatusDate between '5/5/2024' AND DATEADD(day, 1, '5/12/2024')  and--j.Verified=1 and JVA.VStatus=4 and  isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 --GROUP BY J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, --JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom,SU.USER_NAME, JVA.VStatus, --JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,CC.Comment,CC.vStatusFrom,--CC.PostedOn,J.ProceedToPublishDate, CC.UName --ORDER BY JVA.vStatusDate ASC, cast(JVS.vStatusDate as date) DESC, --CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 




-- WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0   -- AND JVS.vStatusDate BETWEEN '05/02/2024' AND '05/10/2024' --  AND j.Verified=1 AND JVA.VStatus=4  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4
  

--  WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  and JVS.vStatusDate between '5/5/2024' AND DATEADD(day, 1, '5/12/2024')  and--j.Verified=1 and JVA.VStatus=4 and  isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 


-- ORDER BY --   JVS.vStatusDate desc, JVS.VStatus DESC-- , JVA.vStatusDate ASC--, CASE WHEN JVS.VStatus IS NOT NULL AND JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC --  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 

--ORDER BY JVA.vStatusDate ASC, cast(JVS.vStatusDate as date) DESC, --CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC  
--OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 


;WITH Comment_CTE AS( SELECT  	 J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName  	,ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r  FROM Dbo_JobPostings AS Jo  	 INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID  	 LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID  WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000)  AND Jo.deleted = 0 AND Jo.drafted = 0   AND Jo.RegionalJob <> 4 ),Final_CTE AS( 	SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName	FROM Comment_CTE WHERE r = 1 ), count_CTE AS (	SELECT CP_ID, COUNT(Pay_Status) AS PayStatus FROM Dbo_Invoice AS d	LEFT JOIN Comment_CTE AS c ON d.CP_ID = c.JP_ID 	WHERE Pay_Status = 0 AND ServiceId=11 --AND CP_ID = J.CP_ID	GROUP BY CP_ID)SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID , coc.PayStatus --= (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) , J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine , J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission , JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment , j.OwnerOrgType,J.jobLang, J.CVReceivingOptions , C.IsEntrepreneur , COUNT(JC.ID) AS TotalComment , CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over()    FROM Dbo_Company_Profiles AS C 		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID 		LEFT JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID 		LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID 		LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID 		LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID 		LEFT JOIN count_CTE AS coc ON c.CP_ID = coc.CP_ID		--LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID 		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID 		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' 		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID 		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' 		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0    AND JVS.vStatusDate BETWEEN '05/05/2024' AND '05/13/2024'   AND j.Verified=1 AND JVS.VStatus in (5,6) AND JVA.VStatus=5  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4  GROUP BY   J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob , JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, coc.PayStatus , JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission , JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom , SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME , JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions , C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName  ORDER BY    JVA.vStatusDate ASC, CAST(JVS.vStatusDate AS DATE) DESC  , CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC   OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 


--SELECT TOP 100 * FROM Dbo_Invoice





;WITH Comment_CTE AS( SELECT 	 J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName  	,ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r  FROM Dbo_JobPostings AS Jo  	 INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID  	 LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID  WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000)  AND Jo.deleted = 0 AND Jo.drafted = 0   AND Jo.RegionalJob <> 4 ),Final_CTE AS( 	SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName FROM Comment_CTE WHERE r = 1 ), data_cte AS (SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, c.CP_ID , P_Status = (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) , J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine , J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission , JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment , j.OwnerOrgType,J.jobLang, J.CVReceivingOptions , C.IsEntrepreneur--, COUNT(JC.ID) AS TotalComment , CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName --, COUNT(1) Over()    FROM Dbo_Company_Profiles AS C 		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID 		LEFT JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID 		--LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID 		LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID 		LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID 		LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID 		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID 		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' 		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID 		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' 		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0    AND JVS.vStatusDate BETWEEN '05/05/2024' AND '05/13/2024'   AND j.Verified=1 AND JVS.VStatus in (5,6) AND JVA.VStatus=5  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 -- GROUP BY --  J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob --, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed --, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission --, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom --, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME --, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions --, C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName --ORDER BY  --  JVA.vStatusDate ASC, CAST(JVS.vStatusDate AS DATE) DESC  --, CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC )SELECT d.*, COUNT(JC.ID) AS TotalComment FROM data_cte AS dLEFT JOIN adm.JobVerificattionComments JC ON d.JP_ID = JC.JP_IDGROUP BY   d.JP_ID,d.CP_ID, d.Acct_CR, d.Name, d.City, d.ServiceID, d.ADTYPE , d.RegionalJob , d.JType, d.JobTitle, d.BlueCollar, d.VERIFIED,d.DeadLine, d.Closed , d.OPID, d.P_Status, d.vStatus, d.Address, d.SpecialPermission , d.UserID, d.VStatus, d.vStatusDate, d.vStatusFrom , d.USER_NAME, d.VStatus, d.vStatusDate, d.vStatusFrom, d.USER_NAME , d.Comment, d.Comment, d.OwnerOrgType,d.jobLang, d.CVReceivingOptions , d.IsEntrepreneur,d.Comment,d.vStatusFrom, d.PostedOn,d.ProceedToPublishDate, d.UNameORDER BY   d.vStatusDate ASC, CAST(d.vStatusDate AS DATE) DESC  , CASE WHEN d.VStatus IS NOT NULL And d.VStatus=5 THEN 9 ELSE d.VStatus END DESC   OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 
  



;WITH Comment_CTE AS( SELECT  	 J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName  	,ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r  FROM Dbo_JobPostings AS Jo  	 INNER JOIN adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID  	 LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID  WHERE(Jo.JP_ID < 200000 or Jo.JP_ID>=400000)  AND Jo.deleted = 0 AND Jo.drafted = 0   AND Jo.RegionalJob <> 4 )--,--Final_CTE AS( 	--SELECT JP_ID, Comment,vStatusFrom, PostedOn, UName FROM Comment_CTE WHERE r = 1 --)SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID , PayStatus = (SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID) , J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine , J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission , JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment , j.OwnerOrgType,J.jobLang, J.CVReceivingOptions , C.IsEntrepreneur, COUNT(JC.ID) AS TotalComment , CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over()    FROM Dbo_Company_Profiles AS C 		INNER JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID  		LEFT JOIN Comment_CTE CC ON J.JP_ID = CC.JP_ID and R=1 		LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' 		LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID 		LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' 		LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID 		LEFT JOIN JobBillInfo JBI ON J.JP_ID=JBI.JP_ID 		LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID 		LEFT JOIN CommentsOnVerification AS CV ON J.JP_ID = CV.JP_ID 		LEFT JOIN CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID  		--LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID  WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0    AND JVS.vStatusDate BETWEEN '05/05/2024' AND '05/13/2024'   AND j.Verified=1 AND JVS.VStatus in (5,6) AND JVA.VStatus=5  AND ISNULL(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4  GROUP BY   J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob , JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed , JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission , JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom , SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME , JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions , C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName  ORDER BY    JVA.vStatusDate ASC, CAST(JVS.vStatusDate AS DATE) DESC  , CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC   OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 







