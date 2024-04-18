declare  @jp_id as int = 1219180


;WITH JOB_CTE1 AS (
SELECT min(I.P_ID) as minpid
FROM bdjCorporate..DBO_JOBPOSTINGS J
	INNER JOIN bdjCorporate..DBO_JOB_INBOX I ON J.JP_ID = I.JP_ID
WHERE J.JP_ID = @jp_id --AND I.P_ID >= 162404order by I.P_ID
),JOB_CTE as (
FROM bdjCorporate..DBO_JOBPOSTINGS J
	INNER JOIN bdjCorporate..DBO_JOB_INBOX I ON J.JP_ID = I.JP_ID
WHERE J.JP_ID = @jp_id AND I.P_ID >= (select minpid from JOB_CTE1)
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
	LEFT JOIN dbo.Edu A4 ON P.P_ID = A4.P_ID AND A4.Edulevel = 5
, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID
WHERE SERVE_TILL = 1
, Ex.BUSINESS, STRING_AGG(S.SkillName, ', ') AS [Work Area]
, ROW_NUMBER() OVER(PARTITION BY P.P_ID ORDER BY Ex.UpdatedOn DESC) AS [Row_Number]
FROM JOB_CTE P
	INNER JOIN bdjResumes.dbo.Exp Ex ON P.P_ID = Ex.P_ID
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
GROUP BY P.ID
--	PR.ID AS P_ID
--	,(CASE WHEN E.MaxDegree = 5 THEN 'MasterS' END) AS  Masters
--FROM bdjResumes..PERSONAL PR 
--	INNER JOIN bdjResumes.[dbo].[vMaxEduLevel] E ON PR.ID = E.P_ID
--group by E.MaxDegree, PR.ID