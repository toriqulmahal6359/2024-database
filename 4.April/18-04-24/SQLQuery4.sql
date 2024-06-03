SELECT DISTINCT JP_ID FROM bdjCorporate..DBO_JOBPOSTINGS AS j
WHERE j.Postingdate >= '04/01/2024' AND JP_ID = 1245082

SELECT * FROM bdjCorporate..DBO_JOBPOSTINGS AS j
WHERE j.PublishDate >= '04/01/2024'

SELECT TOP 5 * FROM bdjCorporate.rp.TestSteps
SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantProcess
--SELECT DISTINCT TestType FROM bdjCorporate.rp.TestSteps