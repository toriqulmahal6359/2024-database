SELECT P_ID FROM bdjCorporate..DBO_JOB_INBOX
WHERE P_DATE >= '04/01/2024'

-- 20,74,467 / 20,74,554

SELECT ApplyID FROM bdjCorporate..DBO_JOB_INBOX
WHERE P_DATE >= '04/01/2024'

--20,74,490

SELECT ApplyID FROM bdjCorporate..DBO_JOB_INBOX
WHERE P_DATE >= '04/01/2024 00:00:00' AND P_DATE <= '04/24/2024 00:00:00'
ORDER BY ApplyID 
OFFSET 2000000 ROWS FETCH NEXT 1000000 ROWS ONLY;