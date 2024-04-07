;with main_cte as(
select P_ID 
from dbo_job_inbox
where JP_ID = 1229053
),part1 as(
select 
 m.P_ID,CASE WHEN ('/'+F.FolderName+'/'+R.PhotoName+'.jpg') IS NOT NULL THEN  ('https://my.bdjobs.com/photos/'+F.FolderName+'/'+R.PhotoName+'.jpg') END AS [Photo]
,p.name,p.SEX , p.MOBILE,p.E_MAIL1
from main_cte m
inner join bdjresumes..personal p on m.P_ID = p.ID
LEFT JOIN bdjResumes..ResumePhotoInfo R ON m.P_ID=R.P_ID 
LEFT JOIN bdjResumes..PhotoFolderInfo F ON R.FolderID=F.ID 
),expcte as(
select m.P_ID,CASE WHEN (CAST(Ex.ETO AS varchar(11)) = '1900-01-01 00:00:00' OR Ex.ETO IS NULL) THEN 'Till' ELSE CAST(Ex.ETO AS varchar(11)) END AS ETO,
ROW_NUMBER() over(partition by m.P_ID order by Ex.ETO) r
from main_cte m
LEFT JOIN bdjResumes.dbo.Exp Ex ON m.P_ID = Ex.P_ID
),final as(
select distinct p.*,e.PASSING_YEAR,e.SUBJECT,e.INSTITUTE,e.ACHIEVEMENT,e.EDUCATION, case when ex.ETO = 'Till' THEN 'Yes' Else 'No' END as [Employed (Yes/No)]
,ROW_NUMBER() over(partition by p.P_ID order by e.passing_year desc) r
from part1 p
INNER JOIN bdjResumes..edu e on p.P_ID = e.P_ID
LEFT JOIN expcte ex on p.P_ID = ex.P_ID and r = 1
),final_part as(
select f.P_ID,f.Photo,f.NAME,f.SEX,f.MOBILE,f.E_MAIL1,case when r = 1  and f.EDUCATION like '%master%' then cast(f.PASSING_YEAR as varchar(100)) else 'No' end [Master's completed (Month/Year)]
,case when r = 1  and f.EDUCATION like '%master%' then f.SUBJECT else 'No' end [Subject/Departments]
,case when r = 1  and f.EDUCATION like '%master%' then f.INSTITUTE else 'No' end [University]
,case when r = 1  and f.EDUCATION like '%master%' and f.ACHIEVEMENT <> '' then f.ACHIEVEMENT else 'No' end [Academic Achievement]
,case when r = 1  and f.EDUCATION like '%master%' then f.[Employed (Yes/No)] else 'No' end [Employed (Yes/No)]
,ROW_NUMBER() over(partition by f.P_ID order by f.passing_year desc) r
from final f
)
select * 
from final_part
where r = 1 --and [Master's completed (Month/Year)] <> 'No'
order by P_ID



