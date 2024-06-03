SELECT  j.JP_ID, MAX(rp.UpdatedOn) FROM bdjCorporate..DBO_JOB_INBOX AS j
LEFT JOIN bdjCorporate.rp.ApplicantProcess AS rp ON j.ApplyId = rp.ApplyId AND rp.LevelStatus = 1
GROUP BY j.JP_ID
	UNION 
SELECT j.JP_ID, MAX(rp.UpdatedOn) FROM arcCorporate..DBO_JOB_INBOX_arc AS j
LEFT JOIN arcCorporate.rp.ApplicantProcess_arc AS rp ON j.ApplyID = rp.ApplyId AND rp.LevelStatus = 1
WHERE rp.UpdatedOn >= '01/01/2021'
GROUP BY j.JP_ID

	