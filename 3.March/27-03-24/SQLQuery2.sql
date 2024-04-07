SELECT TOP 5 
* FROM bdjCorporate.rp.ApplicantProcess


SELECT TOP 5 * FROM bdjCorporate.[dbo].DBO_JOB_INBOX 
SELECT TOP 5 * FROm bdjCorporate.rp.ApplicantProcess

GO

WITH applicantCTE AS (
	SELECT DISTINCT ji.P_ID, p.NAME AS [Applicant Name], ji.P_DATE AS [Apply Date], rp.UpdatedOn AS [Shortlisted], 
	v.AllowToShow AS [Have Video CV],
	r = ROW_NUMBER() OVER(PARTITION BY ji.P_ID ORDER BY ji.P_ID DESC) 
	FROM bdjCorporate.[dbo].DBO_JOB_INBOX AS ji
	INNER JOIN bdjCorporate.rp.ApplicantProcess AS rp ON rp.ApplyId = ji.ApplyId
	INNER JOIN bdjResumes..PERSONAL AS p ON p.ID = ji.P_ID
	LEFT JOIN bdjResumes.[vdo].[VideoResumes] AS v ON v.P_ID = ji.P_ID
	WHERE ji.JP_ID = 1235178
)
SELECT * FROM applicantCTE WHERE r = 1
ORDER BY [Have Video CV] DESC

SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess

SELECT TOP 5 * FROM bdjCorporate.rp.TestSteps WHERE TestType= 'ShortList'

SELECT TOP 5 * FROM bdjCorporate.[dbo].DBO_JOB_INBOX

SELECT TOP 5 * FROM bdjResumes.[dbo].[UserAccounts]

SELECT TOP 5 * FROM bdjResumes..PERSONAL

SELECT TOP 5 * FROM bdjResumes.[vdo].[VideoResumes]