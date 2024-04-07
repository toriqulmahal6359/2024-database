SELECT TOP 5 * FROm [uddokta].[cmpDocuments]

SELECT TOP 5 * FROM DBO_COMPANY_PROFILES WHERE IsEntrepreneur = 1
SELECT TOP 5 * FROM edp.Entrepreneurship
SELECT TOP 5 * FROm [dbo].[DBO_JOBPOSTINGS]

SELECT j.PublishDate, j.PostingDate, C.IsEntrepreneur,EP.ValidityDate
FROM DBO_COMPANY_PROFILES AS C
LEFT JOIN edp.Entrepreneurship AS EP on EP.CP_ID = C.CP_ID
INNER JOIN [dbo].[DBO_JOBPOSTINGS] AS j ON j.CP_ID = C.CP_ID
WHERE IsEntrepreneur = 1 AND EP.ValidityDate > CONVERT(VARCHAR(100), GETDATE(), 101 )
AND j.PublishDate >= '05/01/2023' AND j.PostingDate >= '05/01/2023'


SELECT TOP 5 * FROM [dbo].[DBO_JOBPOSTINGS_arc] AS j WHERE j.PostingDate >= '01-01-2022' AND j.PostingDate <= '01-31-2022'

SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX_arc] AS j WHERE 
