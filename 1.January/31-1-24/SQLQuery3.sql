SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE
    @ComId INT = 20744,
    @PageNo INT = 3,
    @PageSize INT = 20,
    @JobTitle VARCHAR(50) = '',
    @DateFrom VARCHAR(10) = '',
    @DateTo VARCHAR(10) = '',
    @LiveJob BIT = 0,
    @UserID INT = 0,
    @Admin BIT = 0

-- Consider using table variables instead of temporary tables for improved performance
DECLARE @StartingIndex INT = 0,
        @CurrentDate VARCHAR(10) = CONVERT(VARCHAR(10), GETDATE(), 101),
        @LastPost VARCHAR(10)

SELECT @LastPost = CONVERT(VARCHAR(10), MAX(PostedOn), 101)
FROM bdjCorporate..JobMatchCount
WHERE CP_ID = @ComId

IF @PageNo > 0
    SET @StartingIndex = (@PageNo - 1) * @PageSize

-- Use parameters directly in the query to avoid dynamic SQL
;WITH JobList_CTE AS (
    SELECT
        J.JP_ID,
        CASE WHEN J.JobLang = 2 THEN BJ.Title ELSE J.JobTitle END AS JobTitle,
        J.ProceedToPublishDate,
        J.Deadline,
        J.Verified,
        J.PublishDate,
        J.Closed,
        COUNT(1) OVER() AS TotalJob,
        J.CVReceivingOptions,
        J.PostingDate,
        CASE WHEN J.JobLang = 2 AND (SELECT COUNT(1) FROM JobStepsLog_arc WHERE JP_ID = J.JP_ID AND StepNo IN (1, 2, 4) AND IsBangla = 1) = 3 THEN 1 ELSE 0 END AS StepLog
    FROM dbo_JOBPOSTINGS_arc J
    -- Consider INNER JOIN instead of LEFT JOIN if it fits your business logic
    LEFT JOIN DBO_BNG_JOBPOSTINGS_arc BJ ON J.jp_id = BJ.jp_id
    WHERE
        J.CP_ID = @ComId
        AND J.Drafted = 0
        AND J.Deleted = 0
        AND (J.RegionalJob <> 4 OR J.RegionalJob IS NULL)
        AND (@LiveJob = 0 OR (J.DeadLine >= @CurrentDate))
        AND (@JobTitle IS NULL OR (J.JobTitle LIKE '%' + @JobTitle + '%' OR BJ.Title LIKE '%' + @JobTitle + '%'))
        AND (@DateFrom = '' OR J.ProceedToPublishDate >= @DateFrom)
        AND (@DateTo = '' OR J.ProceedToPublishDate <= @DateTo)
    GROUP BY
        J.JobLang,
        BJ.Title,
        J.JP_ID,
        J.JobTitle,
        J.ProceedToPublishDate,
        J.Deadline,
        J.Verified,
        J.PublishDate,
        J.Closed,
        J.CVReceivingOptions,
        J.PostingDate
    ORDER BY
        J.ProceedToPublishDate DESC,
        J.JP_ID DESC
    OFFSET @StartingIndex ROWS FETCH NEXT @PageSize ROWS ONLY
)

-- Use parameters directly in the query to avoid dynamic SQL
SELECT
    J.JP_ID,
    J.JobTitle,
    J.ProceedToPublishDate,
    J.Deadline,
    COUNT(i.JP_ID) AS T,
    COUNT(CASE WHEN i.Viewed = 1 AND p.ApplyID IS NULL AND (i.rejected = 0 OR i.rejected IS NULL) THEN 1 ELSE NULL END) AS Viewed,
    COUNT(CASE WHEN p.levelStatus = 1 AND p.Rejected = 0 THEN 1 ELSE NULL END) AS Shortlisted,
    J.Verified,
    J.PublishDate,
    COUNT(CASE WHEN i.Score = 100 THEN i.ApplyID END) AS MatchCount,
    COUNT(CASE WHEN i.p_date >= JLVD.ViewedOn THEN 1 ELSE NULL END) AS NEW1,
    J.Closed,
    0 AS Interview,
    0 AS FinalList,
    0 AS Rejected,
    J.TotalJob,
    COUNT(V.ApplyID) AS TotalVDOInterviewInvited,
    COUNT(CASE WHEN V.ApplyID IS NOT NULL AND V.FinalSubmitted = 1 THEN V.ApplyID END) AS TotalVDOSubmitted,
    J.StepLog,
    (SELECT COUNT(1) FROM rp.TestSteps_arc WHERE JP_ID = J.JP_ID) AS NewSystem,
    II.intID,
    CASE WHEN J.CVReceivingOptions LIKE '%1%' THEN 1 ELSE 0 END AS ApplyOnline,
    J.PostingDate
FROM JobList_CTE J
LEFT JOIN dbo_job_inbox_arc i ON J.jp_id = i.jp_id
LEFT JOIN rp.ApplicantProcess_arc p ON i.Applyid = p.applyid AND p.LevelStatus = 1
LEFT JOIN bdjCorporate..JobLastViewedDate JLVD ON JLVD.JP_ID = J.JP_ID
LEFT JOIN vdo.InterviewInfo_arc AS II ON J.jp_id = II.jp_id
LEFT JOIN vdo.InterviewApplicants_arc AS V ON II.intId = V.intId AND V.applyid = i.applyid
GROUP BY
    J.JP_ID,
    J.JobTitle,
    J.ProceedToPublishDate,
    J.Deadline,
    J.Verified,
    J.PublishDate,
    J.Closed,
    J.TotalJob,
    J.StepLog,
    II.intID,
    CASE WHEN J.CVReceivingOptions LIKE '%1%' THEN 1 ELSE 0 END,
    J.PostingDate
ORDER BY
    J.ProceedToPublishDate DESC,
    J.JP_ID DESC
