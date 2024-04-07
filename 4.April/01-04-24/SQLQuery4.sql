SELECT COUNT(DISTINCT a.P_ID) FROM bdjCorporate..DBO_JOB_INBOX AS j
INNER JOIN bdjCorporate.rp.APplicantProcess AS a ON a.ApplyId = j.ApplyId
WHERE j.JP_ID = 1220308

SELECT * FROM bdjCorporate.rp.ApplicantProcess WHERE