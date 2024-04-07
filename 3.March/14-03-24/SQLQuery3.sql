
WITH applyCTE AS (
	SELECT [ApplyID],[P_ID]
	FROM [bdjCorporate].[dbo].[DBO_JOB_INBOX] where JP_ID = 1213001
)


select 
 m.P_ID,CASE WHEN ('/'+F.FolderName+'/'+R.PhotoName+'.jpg') IS NOT NULL THEN  ('https://storage.googleapis.com/bdjobs/mybdjobs/photos/'+F.FolderName+'/'+R.PhotoName+'.jpg') END AS [Photo]
,p.name, p.SEX , p.MOBILE, p.E_MAIL1, m.[ApplyId]
from shortlistCTE m
inner join bdjresumes..personal p on m.P_ID = p.ID
LEFT JOIN bdjResumes..ResumePhotoInfo R ON m.P_ID=R.P_ID 
LEFT JOIN bdjResumes..PhotoFolderInfo F ON R.FolderID=F.ID 
ORDER BY m.[ApplyId]

--SELECT TOP 5 * FROM shortlistCTE

SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess

SELECT TOP 5 * FROM bdjCorporate..DBO_JOB_INBOX WHERE ApplyId = 295913742


SELECT * FROM bdjCorporate.[dbo].[DBO_COMPANY_PROFILES] WHERE CP_ID = 20871 --27554
SELECT * FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS] WHERE JP_ID = 1213001


;with main_cte as(
select P_ID 
from dbo_job_inbox
where JP_ID = 1229053
)
select 
 m.P_ID,CASE WHEN ('/'+F.FolderName+'/'+R.PhotoName+'.jpg') IS NOT NULL THEN  ('https://storage.googleapis.com/bdjobs/mybdjobs/photos/'+F.FolderName+'/'+R.PhotoName+'.jpg') END AS [Photo]
,p.name,p.SEX , p.MOBILE,p.E_MAIL1
from main_cte m
inner join bdjresumes..personal p on m.P_ID = p.ID
LEFT JOIN bdjResumes..ResumePhotoInfo R ON m.P_ID=R.P_ID 
LEFT JOIN bdjResumes..PhotoFolderInfo F ON R.FolderID=F.ID 


WITH applyCTE AS (
	SELECT [ApplyID],[P_ID]
	FROM [bdjCorporate].[dbo].[DBO_JOB_INBOX] where JP_ID = 1213001
)
, shortlistCTE AS (
	SELECT p.[ApplyId], a.[JP_ID], a.[P_ID] FROM applyCTE AS a
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS p ON p.ApplyId = a.ApplyId
)

select 
 m.P_ID,CASE WHEN ('/'+F.FolderName+'/'+R.PhotoName+'.jpg') IS NOT NULL THEN  ('https://storage.googleapis.com/bdjobs/mybdjobs/photos/'+F.FolderName+'/'+R.PhotoName+'.jpg') END AS [Photo]
,p.name, p.SEX , p.MOBILE, p.E_MAIL1, m.[ApplyId]
from shortlistCTE m
inner join bdjresumes..personal p on m.P_ID = p.ID
LEFT JOIN bdjResumes..ResumePhotoInfo R ON m.P_ID=R.P_ID 
LEFT JOIN bdjResumes..PhotoFolderInfo F ON R.FolderID=F.ID 
ORDER BY m.[ApplyId]