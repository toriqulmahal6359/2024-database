SELECT TOP 5 * FROM rp.ApplicantProcess

SELECT TOP 5 * FROM DBO_JOBPOSTINGS
SELECT TOP 5 * FROM DBO.DBO_JOB_INBOX
SELECT TOP 5 * FROM bdjResumes..OnlinePaymentInfoJS 
SELECT TOP 5 * FROM bdjResumes.mnt.CandidatePackages

SELECT p.JP_ID, i.ApplyID, i.P_ID,
	CASE WHEN c.IsActive = 1 
	AND DATEADD(MONTH, cpkDuration, cpkStartDate) > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 'Pro' ELSE 'Free' END AS [User Type] 
FROM bdjCorporate..DBO_JOBPOSTINGS AS p
INNER JOIN bdjCorporate.DBO.DBO_JOB_INBOX AS i ON p.JP_ID = i.JP_ID
INNER JOIN bdjResumes..OnlinePaymentInfoJS o ON o.P_ID = i.P_ID
inner join bdjResumes.mnt.CandidatePackages c on o.P_ID = c.P_ID and  o.SysID = c.cpkId
where o.ServiceID in(87,88,89) and TransStatus = 'S'
AND p.DeadLine = '02-16-2024 00:00:00'
AND Verified = 1 AND OnlineJob = 1 

WITH JobCTE AS (
	SELECT JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS p WHERE p.DeadLine = '02-16-2024 00:00:00' AND Verified = 1 AND OnlineJob = 1 
)
, ApplicantCTE AS (
	SELECT j.JP_ID, ApplyId, P_ID FROM JobCTE AS j INNER JOIN bdjCorporate.DBO.DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID --where J.JP_ID = 1200740  and P_ID = 6416757
)
, userTypeCTE AS (
	SELECT a.JP_ID, a.ApplyId, a.P_ID,--cpkDuration, cpkStartDate
		CASE WHEN o.P_ID is not null and DATEADD(MONTH, cpkDuration, cpkStartDate) > CONVERT(VARCHAR(100), GETDATE(), 101) THEN 'Pro' ELSE 'Free' END AS [User Type] 
	FROM ApplicantCTE AS a 
	LEFT JOIN bdjResumes..OnlinePaymentInfoJS o ON o.P_ID = a.P_ID
	inner join bdjResumes.mnt.CandidatePackages c on o.P_ID = c.P_ID and  o.SysID = c.cpkId
	where o.ServiceID in(87,88,89) and TransStatus = 'S' and IsActive = 1
)

--, activityCTE AS (
	SELECT DISTINCT u.JP_ID, u.P_ID, u.[User Type]--, u.ApplyId,
	,s.TestType AS [Activity]
	FROM userTypeCTE AS u 
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS r ON r.ApplyId = u.ApplyID
	INNER JOIN bdjCorporate.rp.TestSteps AS s ON s.JP_ID = u.JP_ID AND r.LevelStatus = s.TestLevel--AND r.LevelStatus = 1
	WHERE s.TestType LIKE '%video%' OR s.TestType LIKE '%written%' OR s.TestType LIKE '%facetoface%' OR s.TestType LIKE '%onlinetest%'
	order BY u.JP_ID

SELECT * FROM bdjResumes..UserApplyLimit WHERE P_ID = 3264610 --1072055
SELECT * FROM rp.ApplicantProcess WHERE prId = 1612021
SELECT TOP 5 * FROM bdjResumes.mnt.CandidatePackages WHERE P_ID = 1072055--3264610 --

SELECT DISTINCT TestType FROM rp.TestSteps

