USP_INSERT_Blue_CV_v1 
6997394,
'4/4/1994',
2,
2,
'A Level',
'ggg',
1990,
1,
'327',
True,
1831, 
N'hhh',
'1',
'0',
'63',
'10',
'90efd651-0494-44e7-87ec-ae26eb5e7b6a',
'7e81bae9-82c1-4c4d-b2cb-67544cde8b9f',
'ecea1931-2d1e-4bbb-a045-fc528f1d67bc' 




USP_INSERT_Blue_CV_v1 

SELECT 6997394,
'4/4/1994',
2,
2,
'A Level',
'ggg',
1990,
1,
'327',
True,
1831, 
N'hhh',
'1',
'0',
'63',
10,
'90efd651-0494-44e7-87ec-ae26eb5e7b6a',
'7e81bae9-82c1-4c4d-b2cb-67544cde8b9f',
'ecea1931-2d1e-4bbb-a045-fc528f1d67bc'


INSERT INTO Personal (ID, NAME, BIRTH, SEX, MOBILE,EXPERIENCE,POSTING_DATE,UPDATED_DATE, GUID) 
SELECT 6997394, 
accFirstName + CASE WHEN (accLastName <> '' OR accLastName IS NOT NULL) THEN ('' + accLastName) ELSE '' END, 
@Birth_Date, accGender, accPhone, @Year_of_Exp, GETDATE(), GETDATE(), @pGUID
from UserAccounts

SELECT * FROM UserAccounts WHERE accId = 6997394

SELECT TOP 45 * FROM bdjResumes..SPECIALIST WHERE P_ID = 6997394

SELECT TOp 5 * FROM bdjResumes..EDU WHERE P_ID = 6997394

SELECT * FROM bdjResumes..PERSONAL WHERE ID = 6997394