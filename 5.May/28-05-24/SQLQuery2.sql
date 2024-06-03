with tJOb as ( 
select J.JP_ID , JIB.P_ID as ID  From DBO_JOBPOSTINGS J inner join dbo_job_inbox JIB On J.JP_ID = JIB.JP_ID  
where year(J.PublishDate) = 2024  and month(J.PublishDate) = 2 and J.MinExp > 1 and J.MinExp <=3   and J.MaxExp<=3 ) 
select count(distinct JP_ID), count(distinct ID) 
, count( Distinct case when v.TExp/12 <=1 then V.P_ID else null end ) '0-1',''   
, count( Distinct case when v.TExp/12 >1 and v.TExp/12 <=3 then V.P_ID else null end ) '1-3',''  
, count( Distinct case when v.TExp/12 >3 and v.TExp/12 <=5 then V.P_ID else null end ) '3-5','' 
, count( Distinct case when v.TExp/12 >5 and v.TExp/12 <=8 then V.P_ID else null end ) '5-8',''  
, count( Distinct case when v.TExp/12 >8 and v.TExp/12 <=10 then V.P_ID else null end ) '8-10',''  
, count( Distinct case when v.TExp/12 >10 then V.P_ID else null end ) '10+',''  
from tJOb J inner join bdjResumes..vExpCount V On J.ID = v.P_ID

select count(1)  from DBO_JOBPOSTINGS J where year(J.PublishDate) = 2024 and month(J.PublishDate) = 2 and verified =1 and onlineJOb = 1  and J.MinExp > 1 and J.MinExp <=3   and J.MaxExp<=3



SELECT TOP 10 * FROM bdjCorporate..DBO_JOB_INBOX