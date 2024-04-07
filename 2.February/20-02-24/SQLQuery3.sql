DECLARE @range INT = 10000;

WITH salaryCTE AS (
	SELECT JP_ID, ApplyId, ExpectedSalary FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1231141 --1231141 --1169653
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
		AND number < (SELECT MAX(ExpectedSalary) FROM salaryCTE ) / @range
)
SELECT 
    CASE 
        WHEN MinRange = 0 THEN CONCAT(MinRange, '-', MaxRange)
        ELSE CONCAT(MinRange + 1, '-', MaxRange)
    END AS SalaryRange,
	JP_ID,
	COUNT(ApplyId) AS TotalApplicants 
FROM SalaryRanges
LEFT JOIN salaryCTE ON ExpectedSalary > MinRange AND ExpectedSalary <= MaxRange
GROUP BY MinRange, MaxRange, JP_ID
ORDER BY MinRange;

SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID =  1231141--1186095

SELECT * FROM 

SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1183450
SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1169653
SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1186095
SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1231141 --1231141
SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1185509

--SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1169653

--SELECT COUNT(ApplyId) FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1230695
SELECT * FROM [DBO].[DBO_JOB_INBOX] WHERE JP_ID = 1231141 ORDER BY JP_ID DESC WHERE JP_ID = 1141677

SELECT JP_ID FROM [DBO].[DBO_JOB_INBOX] GROUP BY JP_ID HAVING MIN(ExpectedSalary) < 20000
SELECT JP_ID FROM [DBO].[DBO_JOB_INBOX] GROUP BY JP_ID HAVING MIN(ExpectedSalary) > 20000 WHERE JP_ID = 1169653

SELECT 