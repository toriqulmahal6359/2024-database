DECLARE @range INT = 10000;

WITH salaryCTE AS (
    SELECT JP_ID, ApplyId, ExpectedSalary 
    FROM [DBO].[DBO_JOB_INBOX] 
    WHERE JP_ID = 1186095 --1231141 --1169653
),
SalaryRanges AS (
    SELECT 
        (MinRange - 1) AS MinRange,
        (MinRange + @range) AS MaxRange
    FROM (
        SELECT 
            (FLOOR(ExpectedSalary / @range) * @range) AS MinRange,
            ROW_NUMBER() OVER (ORDER BY (FLOOR(ExpectedSalary / @range) * @range)) AS RowNumber
        FROM salaryCTE
    ) AS Ranges
    GROUP BY MinRange
)
SELECT 
     CASE 
        WHEN MinRange = 0 THEN CONCAT(MinRange, '-', MaxRange)
        ELSE CONCAT(MinRange + 1, '-', MaxRange)
    END AS SalaryRange,
    JP_ID,
    COUNT(ApplyId) AS TotalApplicants 
FROM SalaryRanges
LEFT JOIN salaryCTE ON ExpectedSalary >= MinRange AND ExpectedSalary < MaxRange
GROUP BY MinRange, MaxRange, JP_ID
ORDER BY MinRange;



DECLARE @range INT = 10000;

WITH salaryCTE AS (
    SELECT JP_ID, ApplyId, ExpectedSalary 
    FROM [DBO].[DBO_JOB_INBOX] 
    WHERE JP_ID = 1195094 -- Replace with your desired JP_ID
),
SalaryRanges AS (
    SELECT 
        (ROW_NUMBER() OVER (ORDER BY number) - 1) * @range AS MinRange,
        (ROW_NUMBER() OVER (ORDER BY number)) * @range AS MaxRange
    FROM 
        master..spt_values AS m
    WHERE 
        type = 'P'
        AND number <= (SELECT MAX(ExpectedSalary) FROM salaryCTE)
)
SELECT 
    CONCAT(MinRange, '-', MaxRange) AS SalaryRange,
    JP_ID,
    COUNT(ApplyId) AS TotalApplicants 
FROM SalaryRanges
LEFT JOIN salaryCTE ON ExpectedSalary >= MinRange AND ExpectedSalary < MaxRange
GROUP BY MinRange, MaxRange, JP_ID
ORDER BY MinRange;


DECLARE @range INT = 10000;

WITH salaryCTE AS (
	SELECT JP_ID, ApplyId, ExpectedSalary FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1195447 --1231141 --1169653
)
, SalaryRanges AS (
    SELECT 
		(ROW_NUMBER() OVER (ORDER BY number) - 1) * @range AS MinRange,
        (ROW_NUMBER() OVER (ORDER BY number)) * @range AS MaxRange
    FROM 
        master..spt_values
    WHERE 
        type = 'P'
        AND number + @range >= (SELECT MIN(ExpectedSalary) FROM salaryCTE ) / @range 
		AND number <= (SELECT MAX(ExpectedSalary) FROM salaryCTE ) / @range
)
SELECT 
    CASE 
        WHEN MinRange = 0 THEN CONCAT(MinRange, '-', MaxRange)
        ELSE CONCAT(MinRange, '-', MaxRange)
    END AS SalaryRange,
	JP_ID,
	COUNT(ApplyId) AS TotalApplicants 
FROM SalaryRanges
INNER JOIN salaryCTE ON ExpectedSalary >= MinRange AND ExpectedSalary < MaxRange
GROUP BY MinRange, MaxRange, JP_ID
ORDER BY MinRange;

SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1195447

