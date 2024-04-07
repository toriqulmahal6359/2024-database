DECLARE @range INT = 10000;

WITH salaryCTE AS (
	SELECT MIN(ExpectedSalary) AS minSalary, MAX(ExpectedSalary) AS maxSalary FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695
)
, SalaryRanges AS (
    SELECT 
        (ROW_NUMBER() OVER (ORDER BY number) - 1) * @range AS MinRange,
        (ROW_NUMBER() OVER (ORDER BY number)) * @range AS MaxRange
    FROM 
        master..spt_values
    WHERE 
        type = 'P'
        AND number >= (SELECT minSalary FROM salaryCTE) 
		AND number <= (SELECT maxSalary FROM salaryCTE) / @range
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
LEFT JOIN [DBO].[DBO_JOB_INBOX] ON ExpectedSalary >= MinRange AND ExpectedSalary < MaxRange AND JP_ID = 1230695
GROUP BY MinRange, MaxRange, JP_ID
ORDER BY MinRange;


SELECT COUNT(ApplyId) FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695

--SELECT 
--	CASE WHEN ExpectedSalary > MIN(ExpectedSalary) AND ExpectedSalary < @range THEN COUNT()
--		 WHEN ExpectedSalary > @range AND ExpectedSalary < @range * 2 THEN CONCAT(@range, ' - ', (@range * 2) - 1)
--	END AS Ranged_salary
--FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695
--GROUP BY ExpectedSalary


--SELECT JP_ID,
--	MinRange = CAST(((ExpectedSalary / @range) * @range) AS DECIMAL(10, 0)),
--	MaxRange = CAST((((ExpectedSalary / @range) + 1) * @range - 1) AS DECIMAL(10, 0))
--	FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695 

SELECT 
	

SELECT
        (ExpectedSalary / @range) * @range AS MinRange,
        ((ExpectedSalary / @range) + 1) * @range AS MaxRange
	FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695


SELECT ExpectedSalary FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695


