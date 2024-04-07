SELECT * FROm mnt.CandidatePackages
SELECT * FROM OnlinePaymentInfoJS

GO

WITH proCTE AS (
	SELECT *
	, DATEADD(MONTH, cpkDuration, cpkStartDate) AS [EndDate] 
	--, CASE WHEN (DATEADD(MONTH, cpkDuration, cpkStartDate) > (CONVERT(VARCHAR(100), GETDATE(), 101))) THEN 1 ELSE 0 END AS [Pro User]
	, ROW_NUMBER() OVER(PARTITION BY c.P_ID ORDER BY c.UpdatedOn DESC) AS rank
	FROM mnt.CandidatePackages AS c
)
, packageCTE AS ( 
	SELECT p.P_ID, p.cpkId, o.TransDate  FROM proCTE AS p
	LEFT JOIN OnlinePaymentInfoJS AS o ON o.P_ID = p.P_ID AND o.SysId = p.cpkId
	WHERE o.ServiceId IN (87, 88, 89) AND o.TransStatus = 'S'
	AND p.rank = 1 --AND p.[Pro User] = 1
)
, jobCount AS(
	SELECT p.P_ID, p.TransDate, COUNT(j.JP_ID) AS [Total_jobs] FROM packageCTE AS p
	INNER JOIN bdjCorporate.[dbo].DBO_JOB_INBOX AS j ON p.P_ID = j.P_ID
	GROUP BY p.P_ID, p.TransDate
)
, personalCTE AS (
	SELECT j.*, p.NAME, p.MOBILE, c.CAT_NAME, CONCAT(us.TExp / 12, ' Years, ', us.TExp % 12, ' Months') AS [Years Of Experience]  FROM jobCount AS j
	INNER JOIN bdjResumes..PERSONAL p ON p.ID = j.P_ID
	INNER JOIN bdjResumes..UserAccounts u on j.p_id=u.accID 
	INNER JOIN bdjResumes.[dbo].[UserSummary] us ON j.P_ID = us.P_ID
	INNER JOIN bdjResumes.[dbo].[CATEGORY] c ON c.CAT_ID = u.accCatId
)

--, shortlistedCTE AS (
	SELECT * FROM personalCTE ORDER BY P_ID
	INNER JOIN rp.ApplicantProcess a ON a.
	ORDER BY P_ID
--)

SELECT * FROM UserAccounts

SELECT * FROM PERSONAL





;with maincte as(
select distinct o.P_ID,pr.NAME as name ,u.accPhone
,FORMAT(cpkStartDate, 'dd MMM yyyy')  as [Package Subscribed]
,CONCAT(us.TExp / 12, '.', us.TExp % 12)  AS [# Years of Experience (Total)]
, case when ((u.accCatId >= 1 AND u.accCatId < 60) OR u.accCatId = -10) THEN 'White'  WHEN u.accCatId >= 60 OR u.accCatId = -11 THEN 'Blue' END as [Profile Categorey]
, DATEADD(month,cpkduration,cpkStartDate) enddate
, o.cpkId,o.pkId,o.IsActive
from OnlinePaymentInfoJS c
INNER JOIN mnt.CandidatePackages o on c.P_ID = o.P_ID and c.SysID = o.cpkId
inner join UserAccounts u on o.p_id=u.accID 
INNER JOIN bdjResumes.dbo.PERSONAL pr ON o.P_ID = pr.ID
INNER JOIN bdjResumes.[dbo].[UserSummary] us ON o.P_ID = us.P_ID
where c.TransDate>='11/29/2023 20:00:00' and c.ServiceID in (87,88,89) AND TransStatus = 'S'
),packend as(
select P_ID,COUNT(CPKID) c from maincte  group by P_ID
)
select p.P_ID,m.*,p.*
from maincte m
INNER JOIN packend p on m.P_ID = p.P_ID
where p.c = 1 and m.enddate < GETDATE() 
order by p.P_ID


use bdjResumes
GO

;with maincte as(
select distinct o.P_ID,pr.NAME as name ,u.accPhone
,FORMAT(cpkStartDate, 'dd MMM yyyy')  as [Package Subscribed]
,CONCAT(us.TExp / 12, '.', us.TExp % 12)  AS [# Years of Experience (Total)]
, case when ((u.accCatId >= 1 AND u.accCatId < 60) OR u.accCatId = -10) THEN 'White'  WHEN u.accCatId >= 60 OR u.accCatId = -11 THEN 'Blue' END as [Profile Categorey]
, DATEADD(month,cpkduration,cpkStartDate) enddate
, o.cpkId,o.pkId,o.IsActive
from OnlinePaymentInfoJS c
INNER JOIN mnt.CandidatePackages o on c.P_ID = o.P_ID and c.SysID = o.cpkId
inner join UserAccounts u on o.p_id=u.accID 
INNER JOIN bdjResumes.dbo.PERSONAL pr ON o.P_ID = pr.ID
INNER JOIN bdjResumes.[dbo].[UserSummary] us ON o.P_ID = us.P_ID
where c.TransDate>='11/29/2023 20:00:00' and c.ServiceID in (87,88,89) AND TransStatus = 'S' 
),packend as(
select P_ID,COUNT(CPKID) c from maincte  group by P_ID
)
--,main_partCTE as(
select p.P_ID,m.name,m.accPhone,m.[Package Subscribed],m.[# Years of Experience (Total)],m.[Profile Categorey]
from maincte m
INNER JOIN packend p on m.P_ID = p.P_ID
where p.c = 1 and m.enddate < GETDATE() 
--)

---------========================================== MY CODE ==================================================

WITH packageCTE AS (
	SELECT DISTINCT c.cpkId, c.P_ID, c.pkId, c.IsActive 
	, FORMAT(c.cpkStartDate, 'dd MMM yyyy') AS [Package Subscribed]
	, DATEADD(MONTH, cpkDuration, cpkStartDate) AS [EndDate]
	FROM mnt.CandidatePackages AS c
	INNER JOIN OnlinePaymentInfoJS AS o ON o.P_ID = c.P_ID
	WHERE o.TransDate >= '11/29/2023 20:00:00' AND o.ServiceID IN (87, 88, 89) AND o.TransStatus = 'S'
)
, mainCTE AS (
	SELECT p.P_ID, COUNT(cpkID) AS c FROM packageCTE AS p GROUP BY p.P_ID
)
, countCTE AS (
	SELECT p.P_ID, p.cpkId, m.c, p.[Package Subscribed], p.IsActive FROM packageCTE AS p 
	INNER JOIN mainCTE AS m ON p.P_ID = m.P_ID
	WHERE m.c = 1 AND p.EndDate < CONVERT(VARCHAR(100), GETDATE(), 101)
)
, personalCTE AS (
	SELECT c.P_ID, c.cpkId, c.[Package Subscribed], c.IsActive, pr.NAME, pr.MOBILE, ct.CAT_NAME 
	, CONCAT(us.TExp / 12, ' Years, ', us.Texp % 12, ' Months') AS [Experience] 
	FROM countCTE AS c
	INNER JOIN UserAccounts u on c.P_ID = u.accID 
	INNER JOIN bdjResumes.dbo.PERSONAL pr ON c.P_ID = pr.ID
	INNER JOIN bdjResumes.[dbo].[UserSummary] us ON c.P_ID = us.P_ID
	INNER JOIN bdjResumes.[dbo].[CATEGORY] ct ON ct.CAT_ID = u.accCatId
)
, jobCount AS (
	SELECT p.P_ID,
	COUNT(DISTINCT CASE WHEN j.P_DATE >= '11/29/2023 20:00:00' THEN j.ApplyId END) AS [Job Applied],
	COUNT(DISTINCT CASE WHEN a.UpdatedOn > = '11/29/2023 20:00:00' THEN j.ApplyId END) AS [Job got Shortlisted],
	COUNT(DISTINCT CASE WHEN e.cnvApplicantFirst = 1 THEN e.cnvID END) AS [Message to Employers],
	COUNT(DISTINCT CASE WHEN ar.Activity > 0 THEN ar.ApplyId END) AS [Online Test Invite Recieved]
	--CASE WHEN v.AllowToShow = 1 THEN 'YES' ELSE 'NO' END AS [Video CV Exists ?(y/n)]
	FROM personalCTE AS p 
	LEFT JOIN bdjCorporate.[dbo].[DBO_JOB_INBOX] AS j ON j.P_ID = p.P_ID
	LEFT JOIN bdjCorporate.rp.ApplicantProcess a on j.ApplyID = a.ApplyId
	LEFT JOIN bdjCorporate.rp.ApplicantsResponse ar ON p.P_Id = ar.ID
	--LEFT JOIN vdo.VideoResumes v ON v.P_ID = p.P_ID
	LEFT JOIN bdjCorporate.rp.empConversation e ON e.P_ID = p.P_ID
	GROUP BY p.P_ID
)

SELECT p.P_ID, p.NAME, p.MOBILE, p.CAT_NAME, p.[Package Subscribed], p.[Experience], 
j.[Job Applied], j.[Job got Shortlisted], j.[Message to Employers], j.[Online Test Invite Recieved]
, CASE WHEN v.AllowToShow = 1 THEN 'YES' ELSE 'NO' END AS [Video CV Exists ?(y/n)]
FROM personalCTE AS p
INNER JOIN jobCount AS j ON j.P_ID = p.P_ID
LEFT JOIN vdo.VideoResumes v ON v.P_ID = p.P_ID


---------========================================== MY CODE ==================================================


SELECT * FROM bdjCorporate.rp.ApplicantsResponse

SELECT * FROM PERSONAL WHERE ID = 6829649