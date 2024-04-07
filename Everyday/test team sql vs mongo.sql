
-------------------------cm asccess userselect distinct c.CP_ID [cm_access_user]from DBO_COMPANY_PROFILES cpleft join [dbo].[CompanyServices] c on cp.cp_id = c.cp_id and DATEADD(DAY,c.Duration,c.StartingDate)> GETDATE()inner join DBO_JOBPOSTINGS j on cp.CP_ID = j.CP_IDwhere cp.acct_cr >='12/01/2023' and cp.acct_cr < '12/02/2023' and c.CP_ID is not null and j.PublishDate is not null--------------------------normal user-------------select  distinct cp.CP_ID [normal_user]from DBO_COMPANY_PROFILES cpleft join [dbo].[CompanyServices] c on cp.cp_id = c.cp_id and DATEADD(DAY,c.Duration,c.StartingDate)> GETDATE()inner join DBO_JOBPOSTINGS j on cp.CP_ID = j.CP_IDwhere cp.acct_cr >='12/01/2023' and cp.acct_cr < '12/02/2023' and c.CP_ID is null and j.PublishDate is not null  --------live job

Declare @Deadline As varchar(10) = CONVERT(varchar(10), GETDATE(), 101)		,@PublishDate As varchar(10) = CONVERT(varchar(10), GETDATE()+1, 101)SELECT distinct  j.cp_id FROM DBO_JOBPOSTINGS J 	WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed=0 And J.Deadline >=@Deadline And J.PublishDate < @PublishDateand j.cp_id in(121586,120940,121627,120866,120723,122027,121082,120224,120247,121353,119679,120372,121297,121451,121712,119436,119731,121059,121403,121606,122055,119591,119837)





--2. SQL er 
--Published job without job fair = 66152
--Posted job without job fair = 78309
--Drafted jobs  8055

--Mongo DB er 
--Published job = 63288
--Processing Job = 75371
--Drafted job = 8055

--counting deben. eta 1 may 2023 theke ****current time porjonto deben.



--Published job without job fair
select COUNT(*) 
from DBO_JOBPOSTINGS 
where PublishDate >= '2023-05-01' and PublishDate <= '2024-01-30'  and RegionalJob <> 4 and VERIFIED = 1
--Published job without job fair
{
  "PublishDate": {
    "$gte": ISODate("2023-05-01T00:00:00.000Z"),
    "$lte": ISODate("2024-01-30T00:00:00.000Z")
  },
  "ContentVerify": 1
}



--Posted job without job fair
select COUNT(*) 
from DBO_JOBPOSTINGS 
where PostingDate >= '2023-05-01' and PostingDate <= '2024-01-30' AND  PublishDate is null and RegionalJob <> 4
--Posted job without job fair
{
  "JobPostingDate": {
    $gte: ISODate("2023-05-01T00:00:00.000Z"),
    $lte: ISODate("2024-01-30T00:00:00.000Z")
  },
  "PublishDate":ISODate("0001-01-01T00:00:00.000+00:00")
}
--Drafted jobs 
select JP_ID
from DBO_JOBPOSTINGS 
where PostingDate >= '05/01/2023' and PublishDate is null and Drafted = 1 and RegionalJob <> 4


--Drafted jobs 
{
  $and: [
    { "JobPostingDate": { $gte: ISODate("2023-05-01T00:00:00.000Z") } },
    { "IsDrafted": true }
  ]
}









--3. Sql corporate default, Mongo gateway, Mongo hiring activity page er number of jobs and applications deben. eta 20 tarikh theke today 1 PM porjonto deben.

--3.
--Sql corporate default 6383
--Mongo gateway
--Mongo hiring activity

--Sql corporate default
with Jobs as (select Distinct JP_ID From DBO_JOB_INBOX WHERE P_DATE >= '01/20/2024' AND P_DATE <='01/30/2024')Select J.JP_ID, COUNT(Distinct ApplyID) [Applicants]From Jobs JINNER JOIN DBO_JOB_INBOX I ON J.JP_ID = I.JP_ID--where J.JP_ID in(1222791,1222801,1222802,1222803,1222805,1222021,1222022)Group by J.JP_IDOrder By J.JP_ID
--select * from DBO_JOBPOSTINGS where JP_ID in(1222791,1222801,1222802,1222803,1222805,1222021,1222022)
--Mongo gateway
db.getCollection("GatewayCollection").find({
  "JobId": {
    "$in": []
  }
}, {
  "JobId": 1,
  "TotalApplications": 1
})


--Mongo hiring activity
const jobIds = [


];

jobIds.forEach((jobId) => {
  const pipeline = [
    {
      "$match": {
        "JobInformations.JobId": jobId
      }
    },
    {
      "$group": {
        "_id": null,
        "totalCount": { "$sum": 1 }
      }
    },
    {
      "$project": {
        "_id": 0,
        "JobId": jobId,
        "totalCount": 1
      }
    }
  ];

  const result = db.getCollection("ApplicantHiringActivityCollection").aggregate(pipeline).toArray();
  
  // Print the result for each JobId
  print(`${jobId},${result[0]?.totalCount || 0}`);
});



--4. SQL without job fair and Mongo DB te
--1. Total number of Live jobs
--2. Total number of Paused jobs
--3. Total number of Expired jobs
--4. Total number of Pending jobs
--1 May 2023 theke ****current time porjonto deben

--4
--SQL
--LiveJob=5190
--PausedJob=1496
--ExpiredJob=59084
--PendingJob=12542

--Mongo
--LiveJob=
--PausedJob=
--ExpiredJob=
--PendingJob=


select JP_ID from bdjActiveJobs..dbo_jobpostings_all_aj
--------------------------LIVE JOB-----------------
Declare @Deadline As varchar(10) = CONVERT(varchar(10), GETDATE(), 101)
		,@PublishDate As varchar(10) = CONVERT(varchar(10), GETDATE()+1, 101)
SELECT JP_ID AS LiveJob
FROM DBO_JOBPOSTINGS J
WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed = 0 And J.Deadline >= @Deadline And J.PublishDate < @PublishDate and OnlineJob = 1
AND RegionalJob <> 4

print(@PublishDate)

{
  $and: [
   { "DeadlineDate": { $gte: ISODate("2024-01-31T18:00:00.000Z") } },
    { "PublishDate": { $lt: ISODate("2024-02-01T18:00:00.000Z") } },
    { "IsDrafted": false },
	{ "ContentVerify": { $eq: 1 }},
	{ "IsPaused": false }
  ]
}

2022-10-15 00:00:00
------------------------------------PAUSED JOB-------------------------
Declare @Deadline As varchar(10) = CONVERT(varchar(10), GETDATE(), 101)
		,@PublishDate As varchar(10) = CONVERT(varchar(10), GETDATE()+1, 101)
--select top 1* from DBO_JOBPOSTINGS
SELECT JP_ID AS PausedJob
FROM DBO_JOBPOSTINGS J
WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed = 1 And J.PublishDate >= '2023-05-01 00:00:00' 
AND RegionalJob <> 4 and OnlineJob = 1

{
  $and: [
   { "PublishDate": { $gte: ISODate("2023-05-01T00:00:00.000Z") } },
    { "IsPaused": true },
	{ "ContentVerify": { $eq: 1 }},
	{ "IsDrafted": false }
  ]
}
------------------------------------Expired JOB-------------------------
Declare @Deadline As varchar(10) = CONVERT(varchar(10), GETDATE(), 101)
		,@PublishDate As varchar(10) = CONVERT(varchar(10), GETDATE()+1, 101)
SELECT JP_ID AS ExpiredJob
FROM DBO_JOBPOSTINGS J
WHERE J.Verified = 1 And J.Drafted = 0 And J.Closed = 0 And J.PublishDate >= '2023-05-01 00:00:00' And J.Deadline <= '2024-02-13 23:59:59'
AND RegionalJob <> 4 and OnlineJob = 1

{
  $and: [
   { "PublishDate": { $gte: ISODate("2023-05-01T00:00:00.000Z") } },
    { "DeadlineDate": { $lte: ISODate("2024-01-30T18:00:00.000Z") } },
    { "IsPaused": false },
	{ "ContentVerify": { $eq: 1 }},
	{ "IsDrafted": false }
  ]
}

------------------------------------Pending JOB-------------------------
Declare @Deadline As varchar(10) = CONVERT(varchar(10), GETDATE(), 101)
		,@PublishDate As varchar(10) = CONVERT(varchar(10), GETDATE()+1, 101)
SELECT JP_ID AS PendingJob
FROM DBO_JOBPOSTINGS J
WHERE J.PostingDate >= '2023-05-01 00:00:00' And J.PublishDate IS NULL
AND RegionalJob <> 4 and Drafted = 0 and OnlineJob = 1

{
  $and: [
   { "JobPostingDate": { $gte: ISODate("2023-05-01T00:00:00.000Z") } },
    { "JobPostingDate": { $lte: ISODate("2024-01-30T18:00:00.000Z") } },
	{ContentVerify: { $eq: 0 }},
	{SalesVerify: { $eq: 0}},
	{AccountsVerify: { $eq: 0}}
  ]
}



select JP_ID from DBO_JOBPOSTINGS where  RegionalJob<>4 And OnlineJob=1  and PublishDate is not null and PublishDate>='05/01/2023'
















select jp_id 
from DBO_JOBPOSTINGS 
where  RegionalJob<>4 And OnlineJob=1  and PublishDate is not null and PublishDate>='05/01/2023'

select jp_id
from DBO_JOBPOSTINGS 
where  RegionalJob<>4 And OnlineJob=1 and PostingDate>='05/01/2023' and PublishDate is null