SELECT TOP (1000) [ID]
      ,[P_ID]
      ,[CP_ID]
      ,[CompanyName]
      ,[CreatedOn]
      ,[CreatedFrom]
      ,[SMSnotification]
  FROM [bdjCorporate].[dbo].[FollowedEmployers]


  SELECT DISTINCT j.JP_ID,CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.jobTitle END AS [Job Title]
  , j.CP_ID, c.NAME AS [Company Name], j.DeadLine, j.PublishDate 
  FROM bdjCorporate..DBO_JOBPOSTINGS AS j
  LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
  INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
  WHERE j.Deadline >= GETDATE() 
  AND j.OnlineJob = 1 AND j.VERIFIED = 1  
  AND j.PostToLn = 1
  
  SELECT TOP 10* FROM bdjCorporate.[adm].[LNJobPosting]