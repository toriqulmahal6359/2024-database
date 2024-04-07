DECLARE @range INT = 10000;

WITH salaryCTE AS (
	SELECT JP_ID, ApplyId, ExpectedSalary FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695
)
, SalaryRanges AS (
    SELECT 
        (ROW_NUMBER() OVER (ORDER BY number) - 1) * @range AS MinRange,
        (ROW_NUMBER() OVER (ORDER BY number)) * @range AS MaxRange
    FROM 
        master..spt_values
    WHERE 
        type = 'P'
        AND number >= (SELECT MIN(ExpectedSalary) FROM salaryCTE ) 
		AND number <= (SELECT MAX(ExpectedSalary) FROM salaryCTE ) / @range
)
SELECT 
    CASE 
        WHEN MinRange = 0 THEN CONCAT(MinRange, '-', MaxRange)
        ELSE CONCAT(MinRange + 1, '-', MaxRange)
    END AS SalaryRange,
	JP_ID,
	COUNT(ApplyId) AS TotalApplicants
    --COUNT(*) AS Frequency  
FROM SalaryRanges
--LEFT JOIN [DBO].[DBO_JOB_INBOX] ON ExpectedSalary >= MinRange AND ExpectedSalary < MaxRange --AND JP_ID = 1141677
LEFT JOIN salaryCTE ON ExpectedSalary >= MinRange AND ExpectedSalary < MaxRange
GROUP BY MinRange, MaxRange, JP_ID
ORDER BY MinRange;


SELECT COUNT(ApplyId) FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695
SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1141677