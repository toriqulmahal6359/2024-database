declare  @jp_id as int = 1219180


;WITH JOB_CTE1 AS (
SELECT min(I.P_ID) as minpid
FROM bdjCorporate..DBO_JOBPOSTINGS J
	INNER JOIN bdjCorporate..DBO_JOB_INBOX I ON J.JP_ID = I.JP_ID
WHERE J.JP_ID = @jp_id --AND I.P_ID >= 162404order by I.P_ID
),JOB_CTE as (SELECT DISTINCT J.JP_ID, I.ApplyID, I.P_ID
FROM bdjCorporate..DBO_JOBPOSTINGS J
	INNER JOIN bdjCorporate..DBO_JOB_INBOX I ON J.JP_ID = I.JP_ID
WHERE J.JP_ID = @jp_id AND I.P_ID >= (select minpid from JOB_CTE1)), Edu_CTE AS (SELECT P.P_ID
	, A.EDUCATION AS SSC, A.PERCENT_MARK AS [SSC Result] , A.Subject AS [SSC Group/Subject], A.Passing_Year AS [SSC Passing Year], A.Institute AS [SSC Institute] , B1.BoardName AS [SSC Board]--, A.University AS Board
	, (CASE WHEN A1.EDUCATION IS NULL OR A1.EDUCATION = '' THEN A2.EDUCATION ELSE A1.EDUCATION END) AS [HSC/Diploma]
	, (CASE WHEN A1.PERCENT_MARK IS NULL OR A1.PERCENT_MARK = '' THEN A2.PERCENT_MARK ELSE A1.PERCENT_MARK END) AS  [HSC Result]
	, (CASE WHEN A1.Subject IS NULL OR A1.SUBJECT = '' THEN A2.SUBJECT ELSE A1.SUBJECT END) AS [HSC Group/Subject]
	, (CASE WHEN A1.Passing_Year IS NULL OR A1.PASSING_YEAR = '' THEN A2.PASSING_YEAR ELSE A1.PASSING_YEAR END) AS [HSC Passing Year]
	, (CASE WHEN A1.Institute IS NULL OR A1.INSTITUTE= '' THEN A2.INSTITUTE ELSE A1.INSTITUTE END) AS  [HSC Institute], B2.BoardName AS [HSC Board] --, A1.University AS Board
	--, A2.EDUCATION AS Graduation, A2.PERCENT_MARK AS Result , A2.Subject AS [Group/Subject], A2.Passing_Year, A2.Institute--, A2.University
	, A3.EDUCATION AS Graduation, A3.PERCENT_MARK AS [B Result] , A3.Subject AS [B Group/Subject], A3.Passing_Year AS [B Passing Year], A3.Institute AS [B Institute], A3.CourseDuration--, A3.University
	, A4.EDUCATION AS Post_Graduation, A4.PERCENT_MARK AS [M Result], A4.Subject AS [M Group/Subject], A4.Passing_Year AS [M Passing Year], A4.Institute AS [M Institute]--, A3.University
	, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY A4.Edulevel, A4.Passing_Year DESC) AS [Row_Number]
FROM JOB_CTE P
	LEFT JOIN dbo.Edu A ON P.P_ID = A.P_ID AND A.Edulevel = 1
	LEFT JOIN dbo.EDU_Boards B1 ON A.BoardID = B1.BoardID
	LEFT JOIN dbo.Edu A1 ON P.P_ID = A1.P_ID AND A1.Edulevel = 2
	LEFT JOIN dbo.EDU_Boards B2 ON A1.BoardID = B2.BoardID
	LEFT JOIN dbo.Edu A2 ON P.P_ID = A2.P_ID AND A2.Edulevel = 3
	LEFT JOIN dbo.Edu A3 ON P.P_ID = A3.P_ID AND A3.Edulevel = 4
	LEFT JOIN dbo.Edu A4 ON P.P_ID = A4.P_ID AND A4.Edulevel = 5), Org_CTE AS (SELECT P.P_ID , EX.COMPANY AS PresentOrg, EX.EPOSITION AS PresentPosition, CAST(Ex.EFROM AS varchar(11)) AS EFROM, CASE WHEN (CAST(Ex.ETO AS varchar(11)) = '1900-01-01 00:00:00' OR Ex.ETO IS NULL) THEN 'Till' ELSE CAST(Ex.ETO AS varchar(11)) END AS ETO, Ex.UpdatedOn, SERVE_TILL
, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID
WHERE SERVE_TILL = 1), Org_CTE1 AS (SELECT P.P_ID , EX.COMPANY AS PresentOrg, EX.EPOSITION AS PresentPosition, CAST(Ex.EFROM AS varchar(11)) AS EFROM, CASE WHEN (CAST(Ex.ETO AS varchar(11)) = '1900-01-01 00:00:00' OR Ex.ETO IS NULL) THEN 'Till' ELSE CAST(Ex.ETO AS varchar(11)) END AS ETO, Ex.UpdatedOn
, Ex.BUSINESS, STRING_AGG(S.SkillName, ', ') AS [Work Area]
, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
	INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID	LEFT JOIN APPLICANT_EXP_AREA AE ON AE.EX_ID = EX.EX_ID	LEFT JOIN spec.Skills S ON AE.AREA_OF_EXP = S.SkillIDWHERE SERVE_TILL <> 1GROUP BY P.P_ID , EX.COMPANY,  EX.EPOSITION , CAST(Ex.EFROM AS varchar(11)) , CASE WHEN (CAST(Ex.ETO AS varchar(11)) = '1900-01-01 00:00:00' OR Ex.ETO IS NULL) THEN 'Till' ELSE CAST(Ex.ETO AS varchar(11)) END, Ex.UpdatedOn, Ex.BUSINESS), LOC_CTE As (
SELECT T.ID, value PREF_JOB_LOCATION
FROM JOB_CTE J
INNER JOIN bdjResumes.dbo.Personal T ON J.P_ID = T.ID
	CROSS APPLY STRING_SPLIT(PREF_JOB_LOCATION, ',')
), L_CTE AS (
SELECT L.ID, CAST(LTRIM(RTRIM(CASE WHEN ISNUMERIC(L.PREF_JOB_LOCATION) = 1 THEN L.PREF_JOB_LOCATION END)) AS varchar(10)) As LOC_ID--, LD.L_Name --LTRIM(RTRIM(CASE WHEN L.LOC_PREF = 'Any' THEN '' ELSE L.LOC_PREF END)) As LOC_ID, LD.L_Name
FROM LOC_CTE L 
), FINAL_CTE AS (
SELECT P.ID, STRING_AGG(LD.L_Name, ',  ') AS JobLocation
FROM L_CTE P
LEFT JOIN bdjResumes..LOCATIONS LD ON P.LOC_ID = CAST(LD.L_ID AS varchar(10))
GROUP BY P.ID), Addres_CTE AS (SELECT J.P_ID, U1.Location AS PresentAddress, U2.Location AS PermanentAddress, U1.DistrictID AS D1 , U2.DistrictID AS D2, U1.ThanaIDFROM JOB_CTE J LEFT JOIN bdjResumes..UserAddress U1 ON J.P_ID = U1.P_ID AND U1.AddressType IN (1,3)LEFT JOIN bdjResumes..UserAddress U2 ON J.P_ID = U2.P_ID AND U2.AddressType IN (2,3)), DIST_CTE AS (SELECT A.P_ID, REPLACE(REPLACE(' ' + ISNULL(A.PresentAddress, ' '), CHAR(10), ' '), CHAR(13), ' ') as PresentAddress --A.PresentAddress, REPLACE(REPLACE(' ' + ISNULL(A.PermanentAddress, ' '), CHAR(10), ' '), CHAR(13), ' ') as PermanentAddress--A.PermanentAddress , L.L_Name AS PresentDistrict, L1.L_Name AS PermanentDistrict, L2.L_Name AS Thana, ROW_NUMBER() OVER(PARTITION BY A.P_ID ORDER BY A.PresentAddress, A.PermanentAddress DESC) AS [Row_Number]FROM Addres_CTE ALEFT JOIN bdjResumes..LOCATIONS L ON A.D1 = L.L_ID LEFT JOIN bdjResumes..LOCATIONS L1 ON A.D2 = L1.L_ID LEFT JOIN bdjResumes..LOCATIONS L2 ON A.ThanaID = L2.L_ID --ORDER BY A.P_ID)SELECT J.P_ID, J.ApplyID AS TrackingNo, P.NAME, P.SEX AS Gender, '88'+P.MOBILE AS MobileNo, (CASE WHEN P.E_MAIL1 IS NULL OR P.E_MAIL1 = '' THEN P.E_MAIL2 ELSE P.E_MAIL1 END) AS Email, P.FNAME AS FathersName, P.MNAME AS MothersName, D.PermanentAddress, D.PermanentDistrict, D.PresentAddress, D.PresentDistrict, D.Thana, REPLACE(REPLACE(' ' + ISNULL(F.JobLocation, ' '), CHAR(10), ' '), CHAR(13), ' ') as JobLocation, P.NID, FORMAT(P.BIRTH, 'MM-dd-yy') AS [Date Of Birth] , E.SSC,E.[SSC Group/Subject], E.[SSC Result], REPLACE(REPLACE(' ' + ISNULL(E.[SSC Institute], ' '), CHAR(10), ' '), CHAR(13), ' ') as [SSC Institute], E.[HSC/Diploma], E.[HSC Group/Subject], E.[HSC Result], REPLACE(REPLACE(' ' + ISNULL(E.[HSC Institute], ' '), CHAR(10), ' '), CHAR(13), ' ') as [HSC Institute], REPLACE(REPLACE(' ' + ISNULL(CASE WHEN E.[B Institute] = 'National University' THEN E.[B Institute] ELSE 'OtherUniversity' END, ' '), CHAR(10), ' '), CHAR(13), ' ') as [National University Or OtherUniversity], E.Graduation,E.[B Group/Subject], E.[B Result], REPLACE(REPLACE(' ' + ISNULL(E.[B Institute], ' '), CHAR(10), ' '), CHAR(13), ' ') as [B Institute]--, REPLACE(REPLACE(' ' + ISNULL(E.CourseDuration, ' '), CHAR(10), ' '), CHAR(13), ' ') as [B CourseDuration], E.Post_Graduation,E.[M Group/Subject], E.[M Result], REPLACE(REPLACE(' ' + ISNULL(E.[M Institute], ' '), CHAR(10), ' '), CHAR(13), ' ') as [M Institute], CASE WHEN PWD.P_ID IS NULL THEN 'No' ELSE 'Yes' END AS [Person with Disability], CASE WHEN (EX.P_ID IS NULL AND Ep.P_ID IS NULL) THEN 'No Experience' ELSE 'Experienced' END AS [Is Experience], REPLACE(REPLACE(' ' + ISNULL(Ep.BUSINESS, ' '), CHAR(10), ' '), CHAR(13), ' ') as [BUSINESS Organization], REPLACE(REPLACE(' ' + ISNULL(Ep.[Work Area], ' '), CHAR(10), ' '), CHAR(13), ' ') as [Work Area], REPLACE(REPLACE(' ' + ISNULL(Ep.PresentOrg, ' '), CHAR(10), ' '), CHAR(13), ' ') as PrviewOrg, REPLACE(REPLACE(' ' + ISNULL(Ep.PresentPosition, ' '), CHAR(10), ' '), CHAR(13), ' ') as PrviewPosition, REPLACE(REPLACE(' ' + ISNULL(Ep.EFROM, ' '), CHAR(10), ' '), CHAR(13), ' ') as PrviewStartDate, REPLACE(REPLACE(' ' + ISNULL(Ep.ETO, ' '), CHAR(10), ' '), CHAR(13), ' ') as PrviewEndDate, REPLACE(REPLACE(' ' + ISNULL(EX.PresentOrg, ' '), CHAR(10), ' '), CHAR(13), ' ') as PresentOrg, REPLACE(REPLACE(' ' + ISNULL(EX.PresentPosition, ' '), CHAR(10), ' '), CHAR(13), ' ') as PresentPosition, REPLACE(REPLACE(' ' + ISNULL(EX.EFROM, ' '), CHAR(10), ' '), CHAR(13), ' ') as StartDate, REPLACE(REPLACE(' ' + ISNULL(EX.ETO, ' '), CHAR(10), ' '), CHAR(13), ' ') as EndDate, P.CUR_SAL AS CurrentSalary, P.EXP_SAL AS ExpectedSalary --, FORMAT (getdate(), 'MM-dd-yy') as dateFROM JOB_CTE J LEFT JOIN bdjResumes..Personal P ON J.P_ID = P.IDLEFT JOIN bdjResumes.pwd.PersonalInfo PWD ON J.P_ID = PWD.P_ID  LEFT JOIN DIST_CTE D ON J.P_ID = D.P_ID AND D.[Row_Number] = 1LEFT JOIN FINAL_CTE F ON J.P_ID = F.IDLEFT JOIN Edu_CTE E ON J.P_ID = E.P_ID --and E.Row_Number = 1 LEFT JOIN Org_CTE EX ON J.P_ID = EX.P_ID AND EX.[Row_Number] = 1LEFT JOIN Org_CTE1 Ep ON J.P_ID = Ep.P_ID AND Ep.[Row_Number] = 1WHERE E.[Row_Number] = 1ORDER BY J.P_ID OFFSET 0 ROWS FETCH NEXT 5000 ROWS ONLY--REPLACE(REPLACE(' ' + ISNULL(A.PresentAddress, ' '), CHAR(10), ' '), CHAR(13), ' ') as PresentAddress--REPLACE(REPLACE(' ' + ISNULL(A.PermanentAddress, ' '), CHAR(10), ' '), CHAR(13), ' ') as PermanentAddress--SELECT TOP 20
--	PR.ID AS P_ID
--	,(CASE WHEN E.MaxDegree = 5 THEN 'MasterS' END) AS  Masters
--FROM bdjResumes..PERSONAL PR 
--	INNER JOIN bdjResumes.[dbo].[vMaxEduLevel] E ON PR.ID = E.P_ID
--group by E.MaxDegree, PR.ID--SELECT TOP 5* FROM bdjResumes.dbo.Exp--SELECT TOP 5* FROM bdjResumes.spec.Skills--SELECT TOP 5* FROM bdjResumes..SPECIALIST--SELECT TOP 5* FROM bdjResumes..LOCATIONS L--SELECT TOP 5* FROM bdjResumes..UserAddress L--SELECT TOP 5* FROM bdjResumes..PERSONAL L