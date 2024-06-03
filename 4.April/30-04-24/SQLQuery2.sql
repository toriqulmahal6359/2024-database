SELECT * FROM bdjCorporate..ContactPersons WHERE ActiveUser = 1 AND CP_ID = 28640  --42709

SELECT * FROM bdjResumes..[UserAccounts] AS a WHERE (a.accCatId >= 60 OR a.accCatId = -11)

SELECT TOP 5 * FROm bdjCorporate..DBO_COMPANY_PROFILES 

SELECT DISTINCT JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS 
WHERE PostingDate >= '04/01/2024' AND PostingDate <= '04/29/2024'
ORDER BY JP_ID