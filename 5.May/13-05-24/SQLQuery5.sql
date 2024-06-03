WITH CompleteCV_CTE AS (
    SELECT 
        p.ID,
        Ph = CASE WHEN p.PhotoUploaded = 1 THEN 20 ELSE 0 END,
        Ed = CASE WHEN EXISTS (SELECT 1 FROM bdjResumes..EDU WHERE P_ID = p.ID) THEN 20 ELSE 0 END,
        Tr = CASE WHEN EXISTS (SELECT 1 FROM bdjResumes..TRAINING WHERE P_ID = p.ID) THEN 5 ELSE 0 END,
        Pr = CASE WHEN EXISTS (SELECT 1 FROM bdjResumes..PEDU WHERE P_ID = p.ID) THEN 5 ELSE 0 END,
        Ex = CASE WHEN EXISTS (SELECT 1 FROM bdjResumes..EXP WHERE P_ID = p.ID) THEN 20 ELSE 0 END,
        Sp = CASE WHEN EXISTS (SELECT 1 FROM bdjResumes..SPECIALIST WHERE P_ID = p.ID) THEN 5 ELSE 0 END,
        Rf = CASE WHEN EXISTS (SELECT 1 FROM bdjResumes..REF WHERE P_ID = p.ID) THEN 5 ELSE 0 END,
        CV = 20
    FROM 
        bdjResumes..PERSONAL AS p
    WHERE 
        EXISTS (SELECT 1 FROM bdjResumes..EDU WHERE P_ID = p.ID AND PASSING_YEAR >= 2014 AND Edulevel = 4)
        AND EXISTS (SELECT 1 FROM bdjResumes..userAccounts WHERE accID = p.ID AND cvPosted = 1)
),
Intermediate_CTE AS (
    SELECT 
        c.ID,
        [CV_Complete] = ISNULL(c.Ph, 0) + ISNULL(c.Ed, 0) + ISNULL(c.Tr, 0) + ISNULL(c.Pr, 0) +
                        ISNULL(c.Ex, 0) + ISNULL(c.Sp, 0) + ISNULL(c.Rf, 0) + ISNULL(c.CV, 0),
        [Shortlisted] = CASE WHEN p.ApplyID IS NOT NULL THEN 1 ELSE 0 END
    FROM 
        CompleteCV_CTE AS c
    LEFT JOIN 
        bdjCorporate..DBO_JOB_INBOX AS j ON c.ID = j.P_ID
    LEFT JOIN 
        bdjCorporate.rp.ApplicantProcess AS p ON j.ApplyID = p.ApplyId AND p.LevelStatus = 1
)
SELECT 
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 90 AND 100 THEN e.ID END) AS [90-100 Percent],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 90 AND 100 AND e.[Shortlisted] = 1 THEN e.ID END) AS [90-100 Percent Shortlisted],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 80 AND 90 THEN e.ID END) AS [80-90 Percent],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 80 AND 90 AND e.[Shortlisted] = 1 THEN e.ID END) AS [80-90 Percent Shortlisted],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 70 AND 80 THEN e.ID END) AS [70-80 Percent],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 70 AND 80 AND e.[Shortlisted] = 1 THEN e.ID END) AS [70-80 Percent Shortlisted],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 60 AND 70 THEN e.ID END) AS [60-70 Percent],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 60 AND 70 AND e.[Shortlisted] = 1 THEN e.ID END) AS [60-70 Percent Shortlisted],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 50 AND 60 THEN e.ID END) AS [50-60 Percent],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] BETWEEN 50 AND 60 AND e.[Shortlisted] = 1 THEN e.ID END) AS [50-60 Percent Shortlisted],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] <= 50 THEN e.ID END) AS [Below 50 Percent],
    COUNT(DISTINCT CASE WHEN e.[CV_Complete] <= 50 AND e.[Shortlisted] = 1 THEN e.ID END) AS [Below 50 Percent Shortlisted]
FROM 
    Intermediate_CTE e;
