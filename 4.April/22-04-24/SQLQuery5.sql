
WITH jobCTE AS (
	SELECT jp.CP_ID, j.JP_ID, rp.UpdatedOn, j.ApplyID AS applicant, rp.ApplyId AS shortlist, 
	ROW_NUMBER() OVER(PARTITION BY jp.CP_ID ORDER BY rp.UpdatedOn DESC) AS r 
	FROM bdjCorporate..DBO_JOB_INBOX AS j
	LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON j.JP_ID = jp.JP_ID
	--	UNION
	--SELECT jp.CP_ID, j.JP_ID, rp.UpdatedOn, j.ApplyID AS applicant, rp.ApplyId AS shortlist,
	--ROW_NUMBER() OVER(PARTITION BY jp.CP_ID ORDER BY rp.UpdatedOn DESC) AS r 
	--FROM arcCorporate..DBO_JOB_INBOX_arc AS j
	--LEFT JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON j.ApplyID = rp.ApplyId AND rp.LevelStatus = 1
	--INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON j.JP_ID = jp.JP_ID
	--WHERE rp.UpdatedOn >= '01/01/2021'
)
SELECT * FROM jobCTE WHERE r = 1

WITH jobCTE AS (
	SELECT jp.CP_ID, j.JP_ID, MAX(rp.UpdatedOn) AS [Date] FROM bdjCorporate..DBO_JOB_INBOX AS j
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS jp ON j.JP_ID = jp.JP_ID
	GROUP By jp.CP_ID, j.JP_ID
		UNION
	SELECT jp.CP_ID, j.JP_ID, MAX(rp.UpdatedOn) AS [Date] FROM arcCorporate..DBO_JOB_INBOX_arc AS j
	INNER JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1
	INNER JOIN arcCorporate..DBO_JOBPOSTINGS_arc AS jp ON j.JP_ID = jp.JP_ID
	WHERE rp.UpdatedOn >= '01/01/2021'
	GROUP By jp.CP_ID, j.JP_ID
)
SELECT 
	COUNT(ji.ApplyId) AS [Total Applicant],
	COUNT(CASE WHEN ji.Score <= 50 THEN ji.ApplyId END) AS [less_50%_total_applicant_count],
	COUNT(CASE WHEN ji.Score >= 51 AND ji.Score <= 60 THEN ji.ApplyId END) AS [51% to 60%_total_applicant_count],
	COUNT(CASE WHEN ji.Score >= 61 AND ji.Score <= 70 THEN ji.ApplyId END) AS [61% to 70%_total_applicant_count],
	COUNT(CASE WHEN ji.Score >= 71 AND ji.Score <= 80 THEN ji.ApplyId END) AS [71% to 80%_total_applicant_count],
	COUNT(CASE WHEN ji.Score >= 81 AND ji.Score <= 90 THEN ji.ApplyId END) AS [81% to 90%_total_applicant_count],
	COUNT(CASE WHEN ji.Score >= 91 AND ji.Score <= 100 THEN ji.ApplyId END) AS [91% to 100%_total_applicant_count]
FROM jobCTE AS j
INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON ji.JP_ID = j.JP_ID
GROUP BY j.[Date], j.[CP_ID]



