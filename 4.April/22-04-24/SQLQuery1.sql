--WITH jobCTE AS (
--	SELECT j.JP_ID, j.CP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS j
--		UNION
--	SELECT j.JP_ID, j.CP_ID FROM [arcCorporate].[dbo].[DBO_JOBPOSTINGS_arc] AS j
--)
--SELECT 
--	j.CP_ID,
--	COUNT(DISTINCT j.JP_ID) AS [Total Job Post], 
--	COUNT(DISTINCT ji.ApplyId) AS [Total Applicant], 
--	COUNT(DISTINCT a.ApplyId) AS [Total Shortlisted Count] 
--FROM jobCTE AS j
--LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
--LEFT JOIN bdjCorporate.rp.ApplicantProcess AS a ON ji.ApplyID = a.ApplyId
--GROUP BY j.CP_ID

SELECT TOP  5 * FROM bdjCorporate.rp.applicantProcess
	

WITH jobCTE AS (	
	SELECT 
	CONVERT(DATE, MAX(rp.UpdatedOn), 101) AS [shortlisted_date], 
	j.CP_ID, j.JP_ID
	FROM bdjCorporate..DBO_JOB_INBOX AS ji
			INNER JOIN bdjCorporate.rp.applicantProcess rp on ji.applyid = rp.applyid AND rp.levelstatus = 1
			INNER JOIN bdjCorporate..DBO_JOBPOSTINGS J ON Ji.JP_ID= J.JP_ID		 
	GROUP BY j.CP_ID, j.JP_ID
		UNION 
	SELECT 
	CONVERT(DATE, MAX(rp.UpdatedOn), 101) AS [shortlisted_date], 
	j.CP_ID, j.JP_ID
	FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
			INNER JOIN arcCorporate.rp.ApplicantProcess_arc rp on ji.applyid = rp.applyid AND rp.levelstatus = 1
			INNER JOIN arcCorporate..DBO_JOBPOSTINGS_arc J ON Ji.JP_ID= J.JP_ID
	WHERE rp.UpdatedOn >= '01/01/2021'
	GROUP BY j.CP_ID, j.JP_ID
)
SELECT * FROM jobCTE
, companyCTE AS (
	SELECT CP_ID, UpdatedOn,   
	ROW_NUMBER() OVER(ORDER BY UpdatedOn DESC) AS r
	FROM jobCTE
)
SELECT * FROM companyCTE WHERE r = 1
SELECT 
	COUNT(DISTINCT j.JP_ID) AS [total_job_count],
	COUNT(DISTINCT ji.P_ID) AS [total_apply_count]
FROM jobCTE AS j
GROUP BY j.[Date], j.CP_ID

, companyCTE AS (
	SELECT j.[Date], j.CP_ID, c.NAME AS [cp_name] 
	FROM jobCTE AS j
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
)
--SELECT 
--	j.[Date],
--	COUNT(DISTINCT ji.ApplyID) AS [total_applicant]
--	--COUNT(DISTINCT CASE WHEN ji.Score <= 50 THEN ji.ApplyID END) AS [less_50%_total_applicant_count],
--	--COUNT(DISTINCT CASE WHEN ji.Score >= 51 AND ji.Score <= 60 THEN ji.ApplyID END) AS [51%_60%_total_applicant_count]
--FROM jobCTE AS j
--INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
--GROUP BY j.[Date]

SELECT c.CP_ID, cp.NAME AS [cp_name] FROM companyCTE AS c

ORDER BY c.[Date]




--WITH companyCTE AS (
--	SELECT CP_ID, NAME AS [cp_name] FROM bdjCorporate..DBO_COMPANY_PROFILES
--)
--SELECT COUNT(DISTINCT j.JP_ID) AS [Total Job Post],
--COUNT(DISTINCT ji.ApplyId) AS [Total Apply Count],
--COUNT(DISTINCT a.ApplyId) AS [Total Shortlist Count]
--FROM companyCTE AS c
--LEFT JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.CP_ID = c.CP_ID
--LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
--LEFT JOIN bdjCorporate.rp.ApplicantProcess AS a ON a.ApplyId = ji.ApplyID AND a.LevelStatus = 1
--GROUP BY c.CP_ID





--SELECT TOP 5 * FROM arcCorporate.[dbo].[DBO_JOBPOSTINGS_arc]


--SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess

--SELECT TOP 5 * FROM arcCorporate.[rp].[ApplicantProcess_arc]

--SELECT TOP 5 * FROM bdjCorporate.rp.TestSteps
--SELECT TOP 5 * FROM arcCorporate.rp.TestSteps_arc