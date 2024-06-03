SELECT COUNT(DISTINCT x.ApplyID) 
from bdjCorporate..dbo_job_inbox x
	--INNER JOIN bdjCorporate.rp.ApplicantProcess  ap on ap.ApplyId = x.ApplyID
	INNER JOIN bdjResumes..personal p on x.p_id = p.id
where x.JP_ID = 1230305 --and ap.LevelStatus = 1


SELECT x.ApplyID
from bdjCorporate..dbo_job_inbox x
	--INNER JOIN bdjCorporate.rp.ApplicantProcess  ap on ap.ApplyId = x.ApplyID
	INNER JOIN bdjResumes..personal p on x.p_id = p.id
where x.JP_ID = 1230305 --and ap.LevelStatus = 1
ORDER BY x.ApplyID

SELECT x.ApplyId, x.P_ID
from bdjCorporate..dbo_job_inbox x
	--INNER JOIN bdjCorporate.rp.ApplicantProcess  ap on ap.ApplyId = x.ApplyID
	INNER JOIN bdjResumes..personal p on x.p_id = p.id
where x.JP_ID = 1230305 --and ap.LevelStatus = 1
ORDER BY x.P_ID

SELECT * FROM bdjCorporate..DBO_JOB_INBOX WHERE P_ID = 6936700

SELECT DISTINCT x.P_ID
from bdjCorporate..dbo_job_inbox x
	INNER JOIN bdjCorporate.rp.ApplicantProcess  ap on ap.ApplyId = x.ApplyID
	INNER JOIN bdjResumes..personal p on x.p_id = p.id
where x.JP_ID = 1230305 and ap.LevelStatus = 1
ORDER BY x.P_ID