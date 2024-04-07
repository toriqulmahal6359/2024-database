--SELECT * FROM bdjResumes.[vdo].[VideoResumes]
--SELECT * FROM 

--SELECT TOP 5 * FROM UserAccounts
--SELECT TOP 5 * FROM [bdjCorporate].rp.[ApplicantProcess]

--SELECT TOP 5 * FROM [dbo].[PersonalExtras]
--SELECT TOP 5 * FROM [dbo].[PersonalOthers]

--SELECT TOP 5 * FROM UserSummary
--SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS]
--SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX]

GO

WITH jobCTE AS (
	SELECT p.JP_ID, p.CP_ID, i.P_ID, i.Viewed, i.ApplyId,
	CASE WHEN p.JobLang = 2 THEN bn.TITLE ELSE p.JobTitle END AS [Job Title]
	FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS] AS p
	LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] AS bn ON bn.JP_ID = p.JP_ID
	INNER JOIN bdjCorporate.[dbo].[DBO_JOB_INBOX] AS i ON p.JP_ID = i.JP_ID
	WHERE p.PublishDate >= '01/05/2023'
	AND p.VERIFIED = 1 AND p.OnlineJob = 1
)
, activityCTE AS (
	SELECT j.JP_ID, j.CP_ID, j.P_ID, j.[Job Title], s.TestType AS [Activity], j.Viewed FROM jobCTE AS j
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS p ON p.ApplyId = j.ApplyId
	INNER JOIN bdjCorporate.rp.TestSteps AS s ON s.JP_ID = j.JP_ID AND p.LevelStatus = s.TestLevel
	WHERE s.TestType LIKE '%video%' OR s.TestType LIKE '%written%' OR s.TestType LIKE '%facetoface%' OR s.TestType LIKE '%onlinetest%'
)
SELECT a.JP_ID, a.CP_ID, a.[Job Title], a.Activity,
COUNT(a.P_ID) AS Video_CV,
COUNT(CASE WHEN a.Viewed = 1 THEN a.P_ID END) AS Viewed_CV,
COUNT(CASE WHEN a.Viewed = 0 THEN a.P_ID END) AS Not_viewed_CV
FROM activityCTE AS a
INNER JOIN bdjResumes.[vdo].[VideoResumes] AS v ON a.P_ID = v.P_ID
WHERE v.AllowToShow = 1
GROUP BY a.JP_ID, a.CP_ID, a.[Job Title], a.Activity

--GROUP BY j.JP_ID, j.CP_ID, j.[Job Title]

--, videoResume AS (
--	SELECT j.* ,COUNT(v.P_ID) FROM bdjResumes.[vdo].[VideoResumes] AS v
--	INNER JOIN jobCTE AS j ON j.P_ID = v.P_ID 
--	GROUP BY j.JP_ID, j.CP_ID, j.P_ID, j.[Job Title], j.Viewed
--)
--,viewCVCTE AS (

--)
--, 

--SELECT * FROM bdjResumes.[vdo].[VideoResumes] WHERE P_ID = 1166135

GO 

WITH jobCTE AS (
	SELECT p.JP_ID, p.CP_ID, i.P_ID, i.Viewed, i.ApplyId,
	CASE WHEN p.JobLang = 2 THEN bn.TITLE ELSE p.JobTitle END AS [Job Title]
	FROM [dbo].[DBO_JOBPOSTINGS] AS p
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bn ON bn.JP_ID = p.JP_ID
	INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON p.JP_ID = i.JP_ID
	WHERE p.PublishDate >= '01/05/2023'
	AND p.VERIFIED = 1 AND p.OnlineJob = 1
)

SELECT a.JP_ID, a.CP_ID, a.[Job Title],
COUNT(a.P_ID) AS Has_Video_CV,
COUNT(CASE WHEN a.Viewed = 1 THEN a.P_ID END) AS Viewed_CV,
COUNT(CASE WHEN a.Viewed = 0 THEN a.P_ID END) AS Not_viewed_CV
FROM jobCTE AS a
INNER JOIN bdjResumes.[vdo].[VideoResumes] AS v ON a.P_ID = v.P_ID
WHERE v.AllowToShow = 1
GROUP BY a.JP_ID, a.CP_ID, a.[Job Title]

SELECT * FROM [dbo].[DBO_JOBPOSTINGS] AS j 
INNER JOIN [dbo].[DBO_JOB_INBOX] AS i ON j.JP_ID = i.JP_ID
INNER JOIN bdjResumes.[vdo].[VideoResumes] AS v ON i.P_ID = v.P_ID
WHERE i.JP_ID = 1086950 
AND j.VERIFIED = 1 AND j.OnlineJob = 1 AND i.Viewed = 0