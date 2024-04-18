
WHERE EduLevel IN (1, 2, 4, 5) --AND EduLevel IS NOT NULL
AND P_ID = 985

WITH expCTE AS (
SELECT TOP 5 *
, ROW_NUMBER() OVER()
FROM bdjResumes.[dbo].[EXP]
)

SELECT TOP 500 * FROM bdjResumes.[dbo].[EDU] WHERE EduLevel = 4 AND P_ID = 21858 --P_ID = 4669557

SELECT TOP 5 * FROm bdjResumes.[dbo].[EXP]  WHERE P_ID = 4669557

SELECT * FROM [dbo].[EDU_NTVQF]

SELECT TOP 500 * FROM bdjResumes.[dbo].[PEDU] WHERE P_ID = 4669557