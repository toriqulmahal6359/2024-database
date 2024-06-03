WITH mainCTE AS (	
	SELECT j.CP_ID, j.JP_ID, rp.UpdatedOn
	FROM bdjCorporate..DBO_JOB_INBOX AS ji
			INNER JOIN bdjCorporate.rp.applicantProcess rp on ji.applyid = rp.applyid AND rp.levelstatus = 1
			INNER JOIN bdjCorporate..DBO_JOBPOSTINGS J ON Ji.JP_ID= J.JP_ID		 
		UNION 
	SELECT j.CP_ID, j.JP_ID, rp.UpdatedOn
	FROM arcCorporate..DBO_JOB_INBOX_arc AS ji
			INNER JOIN arcCorporate.rp.ApplicantProcess_arc rp on ji.applyid = rp.applyid AND rp.levelstatus = 1
			INNER JOIN arcCorporate..DBO_JOBPOSTINGS_arc J ON Ji.JP_ID= J.JP_ID
	WHERE rp.UpdatedOn >= '01/01/2021'
)
, rowCTE AS (
	SELECT CONVERT(DATE, m.UpdatedOn, 101) AS [shortlist_Date], m.CP_ID, m.JP_ID,
	ROW_NUMBER() OVER(PARTITION BY m.CP_ID ORDER BY m.UpdatedOn DESC) AS r
	FROM mainCTE AS m
)
SELECT * FROM rowCTE WHERE r = 1  

SELECT c.CP_ID, cp.NAME AS [cp_name] FROM companyCTE AS c
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS cp ON c.CP_ID = cp.CP_ID
ORDER BY c.[Date]