SELECT TOP 100 * FROM bdjResumes..EDU


DECLARE @GUID VARCHAR(60) = '';

 SELECT CASE WHEN @GUID IS NOT NULL OR @GUID <> '' THEN '' ELSE END

SELECT accID, accFirstName + CASE WHEN (accLastName <> '' OR accLastName IS NOT NULL) THEN (' ' + accLastName) ELSE '' END, @Birth_Date, accGender, accPhone, @Year_of_Exp, GETDATE(), GETDATE() from UserAccounts where accID=@P_ID