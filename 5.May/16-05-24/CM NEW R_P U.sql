;WIth mainCTEE as(	SELECT DISTINCT o.P_ID,u.accFirstName+' '+u.accLastName as name ,O.TransDate as [Purchase Date],o.SysID,o.ServiceID 	FROM OnlinePaymentInfoJS o	inner join UserAccounts u on o.p_id=u.accID 	where o.TransDate>='11/29/2023 20:00:00' and o.ServiceID in (87,88,89) AND O.TransStatus = 'S'	--ORDER BY O.P_ID),END_CTE AS(	SELECT DISTINCT M.P_ID, DATEADD(MONTH, cpkDuration, cpkStartDate) AS [Package End Date], C.cpkId,M.ServiceID 	FROM mainCTEE M	INNER JOIN mnt.CandidatePackages C ON M.P_ID = C.P_Id AND M.SysID = C.cpkId--order by  M.P_ID),Final_CTE1 AS(	SELECT DISTINCT M.P_ID, M.[Purchase Date], E.[Package End Date]	,LAG(E.[Package End Date]) OVER (PARTITION BY M.P_ID ORDER BY M.[Purchase Date]) D_Date,m.name,M.ServiceID 	FROM mainCTEE M	INNER JOIN END_CTE E ON M.SysID = E.cpkId	--where M.P_ID = 1045025	--ORDER BY M.P_ID),Final_CTE as(select f.P_ID,f.[Purchase Date], f.[Package End Date],f.D_Date,f.name,f.ServiceID ,ROW_NUMBER() OVER (PARTITION BY f.P_ID ORDER BY f.[Purchase Date]) RNfrom Final_CTE1 f --5926720--where f.P_ID = 1045025--order by f.P_ID), f as(SELECT f.P_ID,f.NAME,f.[Purchase Date] --, CASE WHEN f.[Purchase Date] < f.D_Date  THEN 'YES' ELSE 'NO' END AS Upgrade, CASE WHEN f.[Purchase Date] > D_Date THEN 'YES' ELSE 'NO' END AS Repurchase--, CASE WHEN f.RN = 1 THEN 'YES' ELSE 'NO' END AS NEW, 'S' [Payment Status],f.ServiceID FROM Final_CTE f)select * from f where Repurchase='Yes' --and P_ID in(--)--order by f.[Purchase Date] desc