SELECT * FROM bdjActiveJobs.[dbo].[DBO_JOBPOSTINGS_AJ]

SELECT TOP 5 * FROM bdjActiveJobs.[dbo].[DBO_JOBPOSTINGS_ALL_AJ]

SELECT
	CASE WHEN JobLang = 2 THEN JobTitleBng END AS [Bangla Job Title], 
	JobTitle AS [English Job Title]
FROM bdjActiveJobs.[dbo].[DBO_JOBPOSTINGS_ALL_AJ]
WHERE DeadLine >= '04/23/2024'


SELECT COUNT(DISTINCT CP_ID) FROM bdjActiveJobs.[dbo].[DBO_JOBPOSTINGS_ALL_AJ]
SELECT TOP 5 * FROM bdjCorporate..DBO_COMPANY_PROFILES

DECLARE @Deadline As varchar(10) = CONVERT(varchar(10), GETDATE(), 101)
    ,@PublishDate As varchar(10) = CONVERT(varchar(10), GETDATE()+1, 101)

SELECT DISTINCT J.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Bangla Company] 
    FROM bdjCorporate..DBO_JOBPOSTINGS J 
    LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS JB ON J.JP_ID = JB.JP_ID 
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES c ON c.CP_ID = j.CP_ID
   WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed=0 And J.Deadline >=@Deadline And J.PublishDate < @PublishDate


SELECT
DISTINCT c.CP_ID,
 (CASE WHEN CompanyName IS NULL OR CompanyName = '' THEN CompanyNameBng ELSE 
CompanyName END)+'_'+ cast(c.cp_id as varchar(10)) Company
from bdjActiveJobs..DBO_JOBPOSTINGS_ALL_AJ AS j
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES c ON c.CP_ID = j.CP_ID
where DeadLine >= CONVERT(varchar(10), GETDATE(), 101) 

SELECT
DISTINCT c.CP_ID,
(CASE WHEN CompanyName IS NULL OR CompanyName = '' THEN CompanyNameBng ELSE 
CompanyName END) Company
from bdjActiveJobs..DBO_JOBPOSTINGS_ALL_AJ AS j
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES c ON c.CP_ID = j.CP_ID
where DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101) 

--'_'+ cast(c.cp_id as varchar(10)

WITH jobCTE AS (
	SELECT DISTINCT JP_ID FROM arcCorporate..DBO_JOBPOSTINGS_arc WHERE CP_ID = 28640 --18954
		UNION
	SELECT DISTINCT JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS WHERE CP_ID = 28640 --18954
	--WHERE --CP_ID = 18954
	AND 
	PublishDate >= '01/01/2021' --and PublishDate < '02/01/2021'
)
SELECT COUNT(DISTINCT JP_ID) FROM jobCTE



