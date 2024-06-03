DECLARE @pageNumber INT;
DECLARE @rowsOfPage INT;

SET @rowsOfPage = 16300;
SET @pageNumber = 29

SELECT ApplyId FROM bdjCorporate..DBO_JOB_INBOX
WHERE P_DATE >= '04/15/2024' AND P_DATE <= '04/19/2024'
ORDER BY ApplyId
OFFSET (@pageNumber - 1)*@rowsOfPage ROWS FETCH NEXT @rowsOfPage ROWS ONLY;


--SELECT ApplyId FROM bdjCorporate..DBO_JOB_INBOX
--WHERE P_DATE = '04/06/2024'

--USP_INSERT_UPDATE_DELETE_UserExperience_V4 0, 0, 0, '', '', '', '', '', '', '', 0, N'', 0, '', ''    --14 index GUID

--SELECT ApplyId FROM bdjCorporate..DBO_JOB_INBOX
--WHERE P_DATE >= '04/15/2024 00:00:00' AND P_DATE <= '04/19/2024 00:00:00'
--ORDER BY ApplyId

--SELECT ApplyId FROM bdjCorporate..DBO_JOB_INBOX
--WHERE P_DATE >= '04/20/2024 00:00:00' AND P_DATE <= '04/24/2024 00:00:00'
--ORDER BY ApplyId