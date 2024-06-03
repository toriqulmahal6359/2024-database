
-- For all Job posts 

WITH companyCTE AS (
	SELECT CP_ID FROM arcCorporate..DBO_JOBPOSTINGS_arc AS j
	WHERE j.PostingDate IS NOT NULL
	--WHERE j.PublishDate IS NOT NULL
		UNION
	SELECT CP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	WHERE j.PostingDate IS NOT NULL
	--WHERE j.PublishDate IS NOT NULL
)
SELECT c1.CP_ID, c2.NAME AS [Company Name], c2.MinEmp, c2.MaxEmp FROM companyCTE AS c1
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c2 ON c1.CP_ID = c2.CP_ID
WHERE (c2.MinEmp IS NULL AND c2.MaxEmp IS NULL) OR (c2.MinEmp = 0 AND c2.MaxEmp = 0)
	  --AND (c2.MinEmp <> 0 OR c2.MaxEmp <> 0)
ORDER BY c1.CP_ID

-- 47984

GO


-- For last 2 years posted jobs

WITH companyCTE AS (
	SELECT CP_ID FROM arcCorporate..DBO_JOBPOSTINGS_arc AS j			-- j.PostingDate
	WHERE j.PostingDate >= DATEADD(YEAR, -2, GETDATE()) --AND j.PostingDate <= GETDATE()
	--WHERE j.PublishDate IS NOT NULL
		UNION
	SELECT CP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS j				-- j.PostingDate
	WHERE j.PostingDate >= DATEADD(YEAR, -2, GETDATE()) --AND j.PostingDate <= GETDATE()
	--WHERE j.PublishDate IS NOT NULL
)
SELECT c1.CP_ID, c2.NAME AS [Company Name], c2.MinEmp, c2.MaxEmp FROM companyCTE AS c1
INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c2 ON c1.CP_ID = c2.CP_ID
--WHERE (c2.MinEmp IS NULL AND c2.MaxEmp IS NULL)
WHERE (c2.MinEmp IS NULL AND c2.MaxEmp IS NULL) OR (c2.MinEmp = 0 AND c2.MaxEmp = 0)
ORDER BY c1.CP_ID

-- 10734



--119689 (CP_ID)