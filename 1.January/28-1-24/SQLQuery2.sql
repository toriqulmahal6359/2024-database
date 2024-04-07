SELECT * FROM bdjResumes.[vdo].[ViewedByCompanies] ORDER BY TotalViewed DESC--WHERE comUserID = 26387
SELECT TOP 5 * FROM bdjResumes.[vdo].[VideoResumes]
SELECT TOP 5 * FROM [dbo].[DBO_BNG_JOBPOSTINGS]
SELECT TOP 5 * FROM [dbo].[DBO_JOB_INBOX]
SELECT TOP 1000 * FROM [dbo].[DBO_JOBPOSTINGS] WHERE CP_ID = 141554

SELECT TOP 5 * FROM [bdjCorporate]..[DBO_JOB_SOURCE] 
SELECT TOP 100 * FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS] WHERE IsVDOResume = 1
SELECT TOP 10 * FROM [dbo].[DBO_COMPANY_PROFILES]


SELECT TOP 100 * FROM bdjResumes.[vdo].[ViewedByCompanies] ORDER BY TotalViewed DESC
SELECT TOP 100 * FROM bdjResumes.[vdo].[VideoResumes] 
SELECT TOP 100 * FROM DBO_JOB_INBOX

SELECT TOP 100 * FROM bdjCorporate.dbo.DBO_COMPANY_PROFILES

SELECT
	CASE
		WHEN j.Joblang = 2 THEN bj.TITLE ELSE j.JobTitle
	END AS [Job Title],
	vc.TotalViewed
	FROM [dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
	INNER JOIN DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID
	INNER JOIN bdjResumes.[vdo].[ViewedByCompanies] AS vc ON vc.P_Id = i.P_ID
	INNER JOIN [dbo].[DBO_COMPANY_PROFILES] AS p ON p.CP_ID = vc.comUserId
	
	--GROUP BY i.P_Id, j.JobLang, j.JobTitle, bj.TITLE, vc.TotalViewed
	ORDER BY vc.TotalViewed DESC

WITH JobCTE AS (
	SELECT
		CASE
			WHEN j.Joblang = 2 THEN bj.TITLE ELSE j.JobTitle
		END AS [Job Title]
		FROM [dbo].[DBO_JOBPOSTINGS] AS j
		LEFT JOIN [dbo].[DBO_BNG_JOBPOSTINGS] AS bj ON bj.JP_ID = j.JP_ID
		INNER JOIN DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID
		WHERE j.Drafted = 0 AND j.Closed = 0
	AND j.IsVDOResume = 1
)
,

SELECT TOP 6 * FROM bdjCorporate.[dbo].[ContactPersons]


GO



WITH videoResumeCTE AS (
SELECT *
	FROM [vdo].[ViewedByCompanies] AS v
	INNER JOIN bdjCorporate.[dbo].[ContactPersons] AS p ON p.ContactId = v.comUserId
)
,CompanyCTE AS (
	SELECT c.CP_ID AS CompanyID, c.NAME, SUM(v.TotalViewed) AS TotalViewed
	FROM bdjCorporate.dbo.DBO_COMPANY_PROFILES AS c
	INNER JOIN videoResumeCTE AS v ON v.CP_ID = c.CP_ID
	GROUP BY c.NAME, c.CP_ID
)

SELECT TOP 10 * FROM companyCTE AS c
ORDER BY c.TotalViewed DESC



WITH resumeCTE AS (
	SELECT v.comUserID, c.NAME, SUM(v.TotalViewed) AS Total_View 
	FROM [vdo].[ViewedByCompanies] AS v
	INNER JOIN bdjCorporate.dbo.DBO_COMPANY_PROFILES AS c ON c.CP_ID = v.comUserID
	GROUP BY c.NAME, v.comUserID
)
SELECT TOP 10 * FROM resumeCTE AS r ORDER BY r.Total_View DESC

;with cte as(
select comUserID,TotalViewed
from [vdo].[ViewedByCompanies]
)
select top 10 comUserID, sum(TotalViewed) as S from cte group by comUserID order by sum(TotalViewed) desc


;with cte as(
select comUserID,TotalViewed
from [vdo].[ViewedByCompanies]
)
select top 10 Cp.NAME, sum(c.TotalViewed) as S 
from cte c
INNER JOIN bdjCorporate.[dbo].[ContactPersons]  p ON c.comUserId =p .ContactId
INNER JOIN bdjCorporate.dbo.DBO_COMPANY_PROFILES Cp on p.CP_ID = cp.CP_ID
group by Cp.NAME order by sum(c.TotalViewed) desc

