;WITH Comment_CTE AS(	
	SELECT J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName, ROW_NUMBER() 
	OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r 
	FROM Dbo_JobPostings AS Jo 
	inner join adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID 
	LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID 
	where (Jo.JP_ID < 200000 or Jo.JP_ID>=400000) AND 
	Jo.deleted = 0 AND Jo.drafted = 0   And jo.ProceedToPublishDate Between '4/30/2024' AND DATEADD(day, 1, '5/7/2024')  AND 
	Jo.RegionalJob <> 4   
)
,Final_CTE AS(SELECT JP_ID, Comment,vStatusFrom, PostedOn,UName 
FROM Comment_CTE 
WHERE r = 1 
)

SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID,  PayStatus=(SELECT COUNT(Pay_Status) FROM Dbo_Invoice 
WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID), J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, 
J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, 
JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, 
JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,COUNT(JC.ID) AS TotalComment ,CC.Comment,CC.vStatusFrom, 
CC.PostedOn ,J.ProceedToPublishDate, CC.UName, 
COUNT(1) Over()   
FROM Dbo_Company_Profiles AS C 
inner JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID 
left JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID 
LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID 
LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID 
LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID 
LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID 
LEFT JOIN  CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID 
LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' 
LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID  
LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' 
LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  
WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0  And j.ProceedToPublishDate 
Between '4/30/2024' AND DATEADD(day, 1, '5/7/2024')  and  isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 
GROUP BY J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, 
J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, 
JVS.vStatusDate, JVS.vStatusFrom,SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, 
j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName  
ORDER BY ProceedToPublishDate desc, J.JP_ID DESC OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY 



input
PostFrom - '4/30/2024'
PostTo - '5/7/2024'
JobType - B
accountStatus - ""
saleStatus- 1
pageNo 1
per_page_data 50



if accountUser = 2 Then

	if PostFrom <> "" AND PostTo <> "" then 
		strWhere = strWhere & " and JVS.vStatusDate between '"&cdate(PostFrom)&"' AND '"&cdate(PostTo)&"' "
	elseif PostFrom<>"" then
		strWhere = strWhere & " and JVS.vStatusDate>='"&cdate(PostFrom)&"' "
	elseif PostTo <> "" then
		strWhere = strWhere & " and JVS.vStatusDate <='"&cdate(PostTo)&"' "
	end if
Else
	if JobType = "E" Then
		if PostFrom <> "" AND PostTo <> "" then 
			strWhere = strWhere & " and j.DeadLine between '"&cdate(PostFrom)&"' AND '"&cdate(PostTo)&"' "
		elseif PostFrom<>"" then
			strWhere = strWhere & " and j.DeadLine>='"&cdate(PostFrom)&"' "
		elseif PostTo <> "" then
			strWhere = strWhere & " and j.DeadLine <='"&cdate(PostTo)&"' "
		end if
	Else
		If PostFrom <> "" And PostTo <> "" Then 
			strWhere = strWhere & " And j.ProceedToPublishDate Between '" & CDate(PostFrom) & "' AND DATEADD(day, 1, '" & CDate(PostTo) & "') "
		    strWhere1 = strWhere1 & " And jo.ProceedToPublishDate Between '" & CDate(PostFrom) & "' AND DATEADD(day, 1, '" & CDate(PostTo) & "') "
		ElseIf PostFrom <> "" Then
			strWhere = strWhere & " And j.ProceedToPublishDate >= '" & CDate(PostFrom) & "' "
			strWhere1 = strWhere1 & " And jo.ProceedToPublishDate >= '" & CDate(PostFrom) & "' "

		ElseIf PostTo <> "" Then
			strWhere = strWhere & " And j.ProceedToPublishDate <= DATEADD(day, 1, '" & CDate(PostTo) & "') "
			strWhere1 = strWhere1 & " And jo.ProceedToPublishDate <= DATEADD(day, 1, '" & CDate(PostTo) & "') "
		End If
	end if
End If


if JobType="V" then
	strWhere = strWhere&" and j.Verified=1"
elseif JobType="U" then
	strWhere = strWhere&" and j.Verified=0"
elseif JobType="S" then
    strWhere = strWhere&" and J.ADTYPE=1"
elseif JobType="SP" then
    strWhere = strWhere&" and J.ADTYPE=2"
elseif JobType="R" then
    strWhere = strWhere&" and J.RegionalJob=1"
elseif JobType="F" then
    strWhere = strWhere&" and J.RegionalJob=2"
elseif JobType="P" then
    strWhere = strWhere&" and J.Closed=1"
elseif JobType="N" then
    strWhere = strWhere&" and C.Acct_CR>='"&DateAdd("d",-2,Date)&"' AND (J.ServiceID is null Or J.ServiceID=0) "
elseif JobType="H" then
    strWhere = strWhere&" and JBI.JType in ('H','P')"
elseif JobType="B" then
    strWhere = strWhere&" and J.Cat_ID>=60"
elseif JobType="O" then
    strWhere = strWhere&" and JBI.OPID > 0 and JBI.PayStatus = 1 "
elseif JobType="EC" or came_from = "vp" then
    strWhere = strWhere&" and C.IsEntrepreneur = 1"
elseif JobType="EJ" then
    strWhere = strWhere&" and J.ADTYPE = 10"
elseif JobType="LNK" then
    strWhere = strWhere&" and PostToLN = 1"
elseif JobType="L" then
	strWhere = strWhere&" and J.ADTYPE = 11 and PostToLN = 1"
elseif JobType="Fr" then
    strWhere = strWhere&" and J.ADTYPE = 12"
end if

isSaleNumeric = IsNumeric(saleStatus)
isAccountNumeric = IsNumeric(accountStatus)

if saleStatus <> "" and isSaleNumeric = true then 
	'if accountUser = 2 Then
		'strWhere = strWhere&" and JVS.VStatus="&saleStatus&" OR JVS.VStatus=6"
	'else
		'strWhere = strWhere&" and JVS.VStatus="&saleStatus&""
	'End If
	if saleStatus = 5 and accountUser = 2 Then
		strWhere = strWhere&" and JVS.VStatus in (5,6)"
	Else
		strWhere = strWhere&" and JVS.VStatus="&saleStatus&""
	End If
end if

if accountStatus <> "" and isAccountNumeric = true then 
	strWhere = strWhere&" and JVA.VStatus="&accountStatus&""
end if




SQLPart1=";WITH Comment_CTE AS(	SELECT J.JP_ID, J.Comment,J.vStatusFrom, J.PostedOn, M.USER_NAME AS UName, ROW_NUMBER() OVER(PARTITION BY J.JP_ID ORDER BY J.ID DESC) r FROM Dbo_JobPostings AS Jo "
SQLPart1 = SQLPart1 &"inner join adm.JobVerificattionComments J  on Jo.JP_ID = j.JP_ID LEFT JOIN bdjEmails..vMISadmin M ON J.UserID = M.ID "
SQLPart1 = SQLPart1 &"where (Jo.JP_ID < 200000 or Jo.JP_ID>=400000) AND Jo.deleted = 0 AND Jo.drafted = 0 "
SQLPart1 = SQLPart1 &" "& strWhere1 &" AND Jo.RegionalJob <> 4  "
 SQLPart1 = SQLPart1 &" ),Final_CTE AS(SELECT JP_ID, Comment,vStatusFrom, PostedOn,UName FROM Comment_CTE WHERE r = 1 ) "
'                    0          1        2       3          4
SQLPart1 = SQLPart1 &"SELECT J.JP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID,  " 
'                          5	
SQLPart1 = SQLPart1 & "PayStatus=(SELECT COUNT(Pay_Status) FROM Dbo_Invoice WHERE Pay_Status = 0 AND ServiceId=11 AND CP_ID = J.CP_ID), "  
'                         6             7            8          9            10            11         12         13       14          15             16         17              18                 19          20               21              22              23           24            25               26              27           28           29            30            31             32                                                     
SQLPart1 = SQLPart1 & "J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus, CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom, SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions "
'                             33                     34                       35            36           37             38                 39         40
SQLPart1 = SQLPart1 & ",C.IsEntrepreneur,COUNT(JC.ID) AS TotalComment ,CC.Comment,CC.vStatusFrom, CC.PostedOn ,J.ProceedToPublishDate, CC.UName, COUNT(1) Over()  "
SQL_COMMON = SQL_COMMON & " FROM Dbo_Company_Profiles AS C inner JOIN Dbo_JobPostings AS J ON J.CP_ID = C.CP_ID left JOIN JobBillInfo JBI ON JBI.JP_ID=J.JP_ID "
SQL_COMMON = SQL_COMMON & "LEFT JOIN adm.JobVerificattionComments JC ON J.JP_ID = JC.JP_ID "
SQL_COMMON = SQL_COMMON & "LEFT JOIN Final_CTE CC ON J.JP_ID = CC.JP_ID "
SQL_COMMON = SQL_COMMON & "LEFT JOIN CommentsOnVerification AS CV ON CV.JP_ID = J.JP_ID "
SQL_COMMON = SQL_COMMON & "LEFT JOIN JobSearchCriteria AS JS ON J.JP_ID = JS.JP_ID "
SQL_COMMON = SQL_COMMON & "LEFT JOIN  CompanyVerificationStatus  CVS On C.CP_ID = CVS.CP_ID "
SQL_COMMON = SQL_COMMON & "LEFT JOIN adm.JobVerificattionStatus JVS On JVS.JP_ID = J.JP_ID and JVS.vStatusFrom = 'Sales' "
SQL_COMMON = SQL_COMMON & "LEFT JOIN bdjEmails..vMISadmin SU on JVS.UserID = Su.ID  "
SQL_COMMON = SQL_COMMON & "LEFT JOIN adm.JobVerificattionStatus JVA On JVA.JP_ID = J.JP_ID and JVA.vStatusFrom = 'Accounts' "
SQL_COMMON = SQL_COMMON & "LEFT JOIN bdjEmails..vMISadmin AU on JVA.UserID = Au.ID  "
SQL_COMMON = SQL_COMMON & "WHERE (J.JP_ID < 200000 or j.JP_ID>=400000) AND J.deleted = 0 AND J.drafted = 0 "& strWhere &" and  isnull(C.OfflineCom, 0) = 0 AND J.RegionalJob <> 4 "
SQL_COMMON = SQL_COMMON & "GROUP BY J.JP_ID,J.CP_ID, C.Acct_CR, C.Name, C.City, J.ServiceID, J.ADTYPE , J.RegionalJob, JBI.JType, J.JobTitle, J.BlueCollar, J.VERIFIED,J.DeadLine, J.Closed, JBI.OPID, JBI.PayStatus,CVS.vStatus, c.Address, CVS.SpecialPermission, JVS.UserID, JVS.VStatus, JVS.vStatusDate, JVS.vStatusFrom,SU.USER_NAME, JVA.VStatus, JVA.vStatusDate, JVA.vStatusFrom, Au.USER_NAME, JVS.Comment, JVA.Comment, j.OwnerOrgType,J.jobLang, J.CVReceivingOptions ,C.IsEntrepreneur,CC.Comment,CC.vStatusFrom, CC.PostedOn,J.ProceedToPublishDate, CC.UName "

if accountUser = 2 Then   
	'if saleStatus <> "" and saleStatus = 5 Then
		OrderBy = "ORDER BY JVA.vStatusDate ASC, cast(JVS.vStatusDate as date) DESC, CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC "
	'Else
		'OrderBy = "ORDER BY JVA.vStatusDate ASC, JVS.vStatusDate DESC, CASE WHEN JVS.VStatus IS NOT NULL And JVS.VStatus=5 THEN 9 ELSE JVS.VStatus END DESC "
	'End If
	
	'OrderBy = " ORDER BY JVS.vStatusDate desc, JVS.VStatus DESC"
Else
	OrderBy = " ORDER BY ProceedToPublishDate desc, J.JP_ID DESC "
End If

pagination = OrderBy & pagination & " OFFSET "&((pageNo-1)*per_page_data) &" ROWS FETCH NEXT "&per_page_data&" ROWS ONLY "

SQLPart1 = SQLPart1 & SQL_COMMON & pagination

response.Write "<!-- "&SQLPart1 & "-->"

SELECT TOP 5 * FROM bdjCorporate.adm.JobVerificattionStatus WHERE UserId = 0