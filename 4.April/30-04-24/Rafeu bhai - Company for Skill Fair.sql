WITH Job as (
Select JP_ID
From bdjCorporate..DBO_JOBPOSTINGS J
Where  j.PublishDate >= '01/01/2023' AND j.PublishDate <= '04/29/2024' and VERIFIED = 1 AND (j.CAT_ID >= 60 OR j.CAT_ID = -11)

UNION

Select JP_ID
From arcCorporate..DBO_JOBPOSTINGS_arc J
Where  j.PublishDate >= '01/01/2023' AND j.PublishDate <= '04/29/2024' and VERIFIED = 1 AND (j.CAT_ID >= 60 OR j.CAT_ID = -11)
), Apply_CTE as (
	Select J.JP_ID, COUNT(ApplyID) [ApplyCOUNT]
	From Job J
		INNER JOIN DBO_JOB_INBOX I ON J.JP_ID = I.JP_ID
	GROUP by J.JP_ID

	UNION

	Select J.JP_ID, COUNT(ApplyID) [ApplyCOUNT]
	From Job J
		INNER JOIN arcCorporate..DBO_JOB_INBOX_arc I ON J.JP_ID = I.JP_ID
	GROUP by J.JP_ID

), Job_Apply as (
	SELECT J.JP_ID, CASE WHEN A.JP_ID is null Then 0 else A.[ApplyCOUNT] END [ApplyCOUNT]
	FROM Job J
		LEFT JOIN Apply_CTE A ON J.JP_ID = A.JP_ID
), jobCTE AS (
	SELECT DISTINCT
	j.JP_ID
	, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job Title]  
	,j.CP_ID, c.NAME AS [Company Name], j.DeadLine, j.PublishDate, ct.CAT_NAME AS [Special Skill Category], i.ORG_TYPE_NAME AS [Industry Type], c.ADDRESS, jj.ApplyCount
	FROM Job_Apply AS jj
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON jj.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON j.JP_ID = ji.JP_ID
	LEFT JOIN bdjCorporate.[dbo].[CATEGORY] AS ct ON j.CAT_ID = ct.CAT_ID
	LEFT JOIN bdjCorporate..[ORG_TYPES] AS i ON j.ORG_Type_ID = i.ORG_TYPE_ID 
)
, companyCTE AS (
	SELECT j.CP_ID, p.ContactName AS [Name], p.Mobile, p.Email,
	ROW_NUMBER() OVER(PARTITION BY j.CP_ID ORDER BY p.ContactId DESC) AS r
	FROM jobCTE AS j
	INNER JOIN bdjCorporate..ContactPersons AS p ON j.CP_ID = p.CP_ID AND p.ActiveUser = 1
), Contact_CTE as (
	Select CP_ID, [Name], Mobile, Email
	FROM companyCTE
	WHERE r = 1
)

SELECT J.CP_ID, [Company Name], [Industry Type], JP_ID, [Job Title], [Special Skill Category], PublishDate, Deadline, [ApplyCount] AS [# of Applicant]
,Name, Mobile AS [Phone], Email, ADDRESS
FROM jobCTE J
	LEFT JOIN Contact_CTE  C ON J.CP_ID = C.CP_ID
