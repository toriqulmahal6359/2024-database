DECLARE 
	@adtype INT = 1,
	@jType CHAR(3) = 'H',
	@applyType INT = 1;

SELECT jp.JP_ID, jp.JobTitle, jp.CompanyName, jp.CAT_ID, ln.ApplyType, 
	CASE WHEN jb.JType = 'H' THEN 'Hot Jobs'
			WHEN 
from DBO_JOBPOSTINGS jp 
LEFT JOIN adm.LNJobPosting ln ON ln.JP_ID = jp.JP_ID 
INNER JOIN [dbo].[JobBillInfo] jb ON jp.JP_ID = jb.JP_ID
WHERE jp.PostToLN=1 AND jp.PostingDate >= '02/25/2024'
AND jp.PostingDate <= GETDATE() 
AND jp.AdType = @adtype AND ln.ApplyType = @applyType AND jb.JType = @jType
ORDER BY jp.PostingDate DESC

SELECT TOP 5 * FROM DBO_JOBPOSTINGS
SELECT TOP 5 * FROM DBO_JOB_INBOX
SELECT TOP 10 * FROm [dbo].[DBO_JOB_SOURCE] ORDER BY JP_ID DESC
SELECT TOP 5 * FROM [dbo].[JobActivities]
SELECT TOP 5 * FROM [dbo].[JobBillInfo] 
