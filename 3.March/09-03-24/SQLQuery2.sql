SELECT * FROM bdjCorporate..QuickJobPostings

SELECT COUNT(DISTINCT JP_ID) AS Job_Count, COUNT(DISTINCT CP_ID) FROM bdjCorporate..QuickJobPostings AS j
WHERE j.PostedOn = '01/05/2023'


-- Jobs Count

DECLARE @sdate VARCHAR(20) = '01/12/2024',
		@fdate VARCHAR(20) = '';
	
IF @fdate = ''
BEGIN 
	SET @fdate = GETDATE();

END
	SELECT 
	COUNT(DISTINCT j.JP_ID) AS [Job Count], 
	COUNT(DISTINCT q.CP_ID) AS [Company Count],
	COUNT(DISTINCT CASE WHEN j.Closed = 0 AND j.Verified = 1 AND j.Drafted = 0 AND j.OnlineJob = 1
	AND j.DeadLine >= CONVERT(DATE, GETDATE(), 101) AND j.PublishDate < CONVERT(DATE, GETDATE(), 101) THEN j.JP_ID END) AS [Live Job],
	COUNT(DISTINCT CASE WHEN j.PublishDate IS NULL THEN j.JP_ID END) AS [Not Live],
	COUNT(DISTINCT CASE WHEN j.Deadline < CONVERT(DATE, GETDATE(), 101) AND j.PublishDate < j.DeadLine AND j.OnlineJob = 1 THEN j.JP_ID END) AS [Expired Jobs]
	FROM  bdjCorporate..QuickJobPostings AS q
	LEFT JOIN bdjCorporate..DBO_JOBPostings AS j ON j.JP_ID = q.JP_ID
	WHERE q.PostedOn >= @sdate AND q.PostedOn <= @fdate


SELECT j.* FROM bdjCorporate..QuickJobPostings AS q
LEFT JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.JP_ID = q.JP_ID


select q.QJ_JP_ID,c.name[company name],c.ADDRESS,case when j.VERIFIED = 1 then 1 else 0 end [Verified]
,b.JType,j.AdType,j.RegionalJob
,q.QJ_JobTitle,q.PostedOn, case when J.Verified = 1 And J.Drafted = 0 And J.Closed=0 and j.OnlineJob=1
   And J.Deadline >=GETDATE() And J.PublishDate < GETDATE() then 1 else 0 end [Live]					 
from QuickJobPostings q
left join DBO_JOBPOSTINGS j on q.JP_ID = j.JP_ID
left join JobBillInfo  b on q.jp_id = b.jp_id
inner join DBO_COMPANY_PROFILES c on  q.CP_ID = c.CP_ID




SELECT TOP 5 * FROM [dbo].[JobBillInfo]



