SELECT * FROM bdjResumes..CATEGORY WHERE BlueCollar IS NULL



-- Paused Jobs but Live
SELECT * FROM bdjCorporate..DBO_JOBPOSTINGS
WHERE Closed = 1 AND DeadLine >= CONVERT(VARCHAR(100), GETDATE(), 101)
AND OnlineJob = 1


bdjCorporate..USP_MyBdjobs_ApplyPosition_v1 1,1481759,20,'EN','','',N'',-1