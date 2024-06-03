SELECT c.CP_ID, c.NAME AS [Company Name] FROM bdjCorporate..DBO_COMPANY_PROFILES AS c
INNER JOIN bdjCorporate.edp.Entrepreneurship AS e ON c.CP_ID = e.CP_ID
WHERE e.ValidityDate > GETDATE()
	  AND e.CreatedOn >= '04/27/2024' AND e.CreatedOn < '05/29/2024'


	  --SELECT * FROM bdjCorporate..DBO_COMPANY_PROFILES WHERE CP_ID = 103156 --127259

