WITH eduCTE AS (
	SELECT P_ID FROM bdjResumes..EDU AS e
	WHERE e.PASSING_YEAR = '2015' --AND e.PASSING_YEAR <= '2024'
		 AND e.Edulevel = 4
)
, CV_CTE AS (
	SELECT p.ID, 
		Ph = CASE WHEN p.PhotoUploaded = 1 THEN 20 END,
		Ed = CASE WHEN (SELECT TOP 1 Ed_ID FROM bdjResumes..EDU WHERE p.ID = P_ID) > 0 THEN 20 END,
		Tr = CASE WHEN (SELECT TOP 1 T_ID FROM bdjResumes..TRAINING WHERE p.ID = P_ID) > 0 THEN 5 END,
		Pr = CASE WHEN (SELECT TOP 1 Pe_ID FROM bdjResumes..PEDU WHERE p.ID = P_ID) > 0 THEN 5 END,
		Ex = CASE WHEN (SELECT TOP 1 Ex_ID FROM bdjResumes..EXP WHERE p.ID = P_ID) > 0 THEN 20 END,
		Sp = CASE WHEN (SELECT TOP 1 P_ID FROM bdjResumes..SPECIALIST WHERE p.ID = P_ID) > 0 THEN 5 END,
		Rf = CASE WHEN (SELECT TOP 1 R_ID FROM bdjResumes..REF WHERE p.ID = P_ID) > 0 THEN 5 END,
		CV = CASE WHEN u.CVPosted = 1 THEN 20 END 
	FROM bdjResumes..PERSONAL AS p
		INNER JOIN eduCTE AS e ON e.P_ID = p.ID
		LEFT JOIN bdjResumes..UserAccounts AS u ON p.ID = u.accID
		--WHERE p.ID IN (SELECT DISTINCT P_ID FROM eduCTE)
)
, completeCV_CTE AS (
	SELECT ID,
		(CASE WHEN Ph IS NULL THEN 0 ELSE Ph END) + (CASE WHEN Ed IS NULL THEN 0 ELSE Ed END) + (CASE WHEN Tr IS NULL THEN 0 ELSE Tr END) +
		(CASE WHEN Pr IS NULL THEN 0 ELSE Pr END) + (CASE WHEN Ex IS NULL THEN 0 ELSE Ex END) + (CASE WHEN Sp IS NULL THEN 0 ELSE Sp END) +
		(CASE WHEN Rf IS NULL THEN 0 ELSE Rf END) + (CASE WHEN CV IS NULL THEN 0 ELSE CV END) AS [CV_Complete]
	FROM CV_CTE
)
SELECT 
	COUNT(CASE WHEN e.[CV_Complete] >= 90 AND e.[CV_Complete] <= 100 THEN j.ApplyID END) AS [90-100 Percent],
	COUNT(CASE WHEN e.[CV_Complete] >= 90 AND e.[CV_Complete] <= 100 THEN p.ApplyID END) AS [90-100 Percent Shortlisted],
	COUNT(CASE WHEN e.[CV_Complete] >= 80 AND e.[CV_Complete] <= 90 THEN j.ApplyID END) AS [80-90 Percent],
	COUNT(CASE WHEN e.[CV_Complete] >= 80 AND e.[CV_Complete] <= 90 THEN p.ApplyID END) AS [80-90 Percent Shortlisted],
	COUNT(CASE WHEN e.[CV_Complete] >= 70 AND e.[CV_Complete] <= 80 THEN j.ApplyID END) AS [70-80 Percent],
	COUNT(CASE WHEN e.[CV_Complete] >= 70 AND e.[CV_Complete] <= 80 THEN p.ApplyID END) AS [70-80 Percent Shortlisted],
	COUNT(CASE WHEN e.[CV_Complete] >= 60 AND e.[CV_Complete] <= 70 THEN j.ApplyID END) AS [60-70 Percent],
	COUNT(CASE WHEN e.[CV_Complete] >= 60 AND e.[CV_Complete] <= 70 THEN p.ApplyID END) AS [60-70 Percent Shortlisted],
	COUNT(CASE WHEN e.[CV_Complete] >= 50 AND e.[CV_Complete] <= 60 THEN j.ApplyID END) AS [50-60 Percent],
	COUNT(CASE WHEN e.[CV_Complete] >= 50 AND e.[CV_Complete] <= 60 THEN p.ApplyID END) AS [50-60 Percent Shortlisted],
	COUNT(CASE WHEN e.[CV_Complete] <= 50 THEN j.ApplyID END) AS [Below 50 Percent],
	COUNT(CASE WHEN e.[CV_Complete] <= 50 THEN p.ApplyID END) AS [Below 50 Percent Shortlisted]
FROM completeCV_CTE AS e
INNER JOIN bdjCorporate..DBO_JOB_INBOX AS j ON e.ID = j.P_ID
LEFT JOIN bdjCorporate.rp.ApplicantProcess AS p ON j.ApplyID = p.ApplyId AND p.LevelStatus = 1














--SELECT 
--	COUNT(DISTINCT CASE WHEN Score >= 90 AND Score <= 100 THEN j.ApplyID END) AS [90-100 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 80 AND Score < 90 THEN j.ApplyID END) AS [80-90 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 70 AND Score < 80 THEN j.ApplyID END) AS [70-80 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 60 AND Score < 70 THEN j.ApplyID END) AS [60-70 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 50 AND Score < 60 THEN j.ApplyID END) AS [50-60 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 90 AND Score <= 100 THEN p.ApplyID END) AS [90-100 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 80 AND Score < 90 THEN p.ApplyID END) AS [80-90 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 70 AND Score < 80 THEN p.ApplyID END) AS [70-80 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 60 AND Score < 70 THEN p.ApplyID END) AS [60-70 percent],
--	COUNT(DISTINCT CASE WHEN Score >= 50 AND Score < 60 THEN p.ApplyID END) AS [50-60 percent]
--FROM bdjCorporate..DBO_JOB_INBOX AS j
--LEFT JOIN bdjCorporate.rp.ApplicantProcess AS p ON j.ApplyID = p.ApplyId


--SELECT TOP 10 * FROM bdjResumes..EDU 
