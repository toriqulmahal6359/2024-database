-- Company which Rejects Applicants 

SELECT DISTINCT j.CP_ID FROM bdjCorporate.rp.ApplicantProcess AS a
INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON ji.ApplyId = a.ApplyId
INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON j.JP_ID = ji.JP_ID 
WHERE a.Rejected = 1


-- Company who have high ammounts of Candidates at last stage Screening process 

WITH lastCTE AS (
	SELECT DISTINCT JP_ID, 
	last_step = ROW_NUMBER() OVER(PARTITION BY JP_ID ORDER BY TestLevel DESC),
	TestLevel
	FROM bdjCorporate.rp.testSteps --WHERE JP_ID = 1215553
)
, jobCTE AS (
	SELECT DISTINCT l.JP_ID, COUNT(DISTINCT a.ApplyId) AS [Total Candidates] FROM lastCTE AS l
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON j.JP_ID = l.JP_ID
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS a ON a.ApplyId = j.ApplyId AND l.TestLevel = a.LevelStatus
	WHERE last_step = 1
	GROUP BY l.JP_ID
)
SELECT DISTINCT jp.CP_ID, j.[Total Candidates] FROM jobCTE AS j
INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON jp.JP_ID = j.JP_ID
ORDER BY j.[Total Candidates] DESC

-- Company by highest order of Shortlisted 

SELECT j.CP_ID, COUNT(DISTINCT a.ApplyId) AS [Total Shortlisted] FROM bdjCorporate..DBO_JOBPOSTINGS AS j
INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
INNER JOIN bdjCorporate.rp.ApplicantProcess AS a ON a.ApplyId = ji.ApplyID
GROUP BY j.CP_ID
ORDER BY COUNT(DISTINCT a.ApplyId) DESC



SELECT TOP 10 * FROM bdjCorporate.rp.ApplicantProcess
SELECT TOP 10 * FROM bdjCorporate.rp.TestSteps

SELECT TOP 10 * FROM bdjCorporate..DBO_JOB_INBOX 