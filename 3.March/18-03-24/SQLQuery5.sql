SELECT CP_ID, CompanyName FROM bdjCorporate.[dbo].[FollowedEmployers] WHERE CP_ID =  20131 --20109 AND CompanyName LIKE '%Square%' --20109 --20144 --18063 --18114 20084
SELECT COUNT(JP_ID) FROM bdjCorporate..DBO_JOBPOSTINGS WHERE CP_ID = 28640

SELECT TOP 5 * FROM bdjResumes.[dbo].[PERSONAL]

-- kotojon email send korse kotobar email send hoise....

SELECT COUNT(DISTINCT P_ID) AS [Sent Emails], COUNT(DISTINCT ID) AS [Email Sent Count] FROM bdjResumes.[dbo].[ApplicantEmails] 
WHERE JP_ID = 1182505
AND SentOn >= DATEADD(MONTH, -12, CONVERT(VARCHAR(100), GETDATE(), 101)) AND SentOn <= CONVERT(VARCHAR(100), GETDATE(), 101) --1134436 --1182107 --1182505