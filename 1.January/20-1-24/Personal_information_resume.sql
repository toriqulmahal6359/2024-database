--SELECT TOP 5 * FROM UserAccounts AS u WHERE u.accID = 4669557
--SELECT TOP 5 * FROM EDU AS e 
--INNER JOIN EDU_BOARDS AS eb ON eb.BOARDID = e.BOARDID 
--INNER JOIN EDU_RESULT AS er ON er.Result_Val = e.RESULT
--GO
--SELECT TOP 5 * FROM UserOtherProfiles
--SELECT TOP 5 * FROM EDU_Boards
--SELECT TOP 5 * FROM EDU_RESULT

WITH PersonalInfoCTE AS (

	SELECT DISTINCT	
		p.ID,
		p.NAME,
		p.Nationality,
		p.BIRTH AS [Birth Date],
		CONCAT(DATEDIFF(YEAR, p.Birth, GETDATE()) -
			CASE 
				WHEN MONTH(p.BIRTH) > MONTH(GETDATE()) OR
					 MONTH(p.BIRTH) = MONTH(GETDATE()) AND(DAY(p.BIRTH) > DAY(GETDATE()))
				THEN 1 
				ELSE 0
			END, ' years', ' ,',
		12 - MONTH(GETDATE()) + MONTH(GETDATE()) -
			CASE
				WHEN DAY(p.BIRTH) > DAY(GETDATE())
				THEN 1
				ELSE 0
			END, ' months', ' ,',
		CASE 
			WHEN DAY(p.BIRTH) > MONTH(GETDATE())
			THEN DAY(DATEADD(MONTH, DATEDIFF(MONTH, p.BIRTH, GETDATE()), DATEADD(YEAR, DATEDIFF(YEAR, p.BIRTH, GETDATE()), p.BIRTH))) - DAY(p.BIRTH) + DAY(GETDATE())
			ELSE DAY(GETDATE()) - DAY(p.BIRTH)
		END, ' days') AS Age,
		p.PRESENT_ADD AS [Current Address],
		p.PERMANENT_ADD AS [Permanent Address],
		p.HOME_PHONE

	FROM PERSONAL AS p
	WHERE p.ID = 4669557
)
,AccountInfoCTE AS (
	SELECT DISTINCT
		u.accID AS ID,
		u.accEmail AS Email,
		u.accPhone AS Phone,
		CASE
			WHEN u.accGender = 'M' THEN 'MALE'
			WHEN u.accGender = 'F' THEN 'FEMALE'
		END AS Gender
		FROM UserAccounts AS u
)
,EducationCTE AS (
	SELECT
		e.P_ID,
		STRING_AGG(e.EDUCATION, ',') AS User_Education,
		STRING_AGG(e.INSTITUTE, ', ') AS [Education Institute],
		STRING_AGG(e.PERCENT_MARK, ', ') AS [Result],
		STRING_AGG(e.PASSING_YEAR, ', ') AS [passingYear],
		eb.BoardName,
		er.Result AS [Grade Type]
		--COUNT(*) AS Row_Count
		--ROW_NUMBER() OVER(PARTITION BY e.P_ID ORDER BY e.P_ID) AS ROW_NUMBER
	FROM EDU AS e
	LEFT JOIN EDU_Boards AS eb ON eb.BoardID = e.BoardID
	LEFT JOIN EDU_RESULT AS er ON er.Result_Val = e.RESULT
	WHERE e.P_ID = 4669557
	GROUP BY e.P_ID, eb.BoardName, er.Result
)
,TrainingCTE AS(
	SELECT
        t.P_ID,
        STRING_AGG(t.TNAME, ',') AS Training,
        t.TLOCATION AS [Training Location],
        t.TINSTITUTE AS [Training Institute],
        STRING_AGG(t.TTOPIC, ', ') AS [Topics Covered],
        t.TYEAR AS [Training Year],
        STRING_AGG(t.TDURATION, ', ') AS [Course Duration]
        -- Other columns related to training information
    FROM TRAINING AS t
    WHERE t.P_ID = 4669557
	GROUP BY t.P_ID, t.TLOCATION, t.TINSTITUTE, t.TYEAR
)
,ExperienceCTE AS (
	 SELECT 
		e.P_ID,
        STRING_AGG(e.COMPANY, ', ') AS Company,
        STRING_AGG(e.BUSINESS, ', ') AS Business,
        STRING_AGG(e.Dept, ',') AS Department,
        STRING_AGG(e.EFROM, '|') AS [Served From],
        STRING_AGG(e.eto, '|') AS [Served till],
		DATEDIFF(YEAR, e.EFROM, e.eto) AS [Service Year],
        STRING_AGG(e.duty, ',') AS [Responsibilities]
	FROM EXP AS e
	WHERE e.P_ID = 4669557
	GROUP BY e.P_ID, e.EFROM, e.ETO--, e.COMPANY, e.BUSINESS, e.Dept, e.EFROM, e.ETO
)
,SocialLinksCTE AS (
	SELECT 
		u.P_ID,
		STRING_AGG(u.ProfileURL, ',') AS ProfileURL,
		STRING_AGG(u.ProfileType, ',') AS [Profile Type] 
	FROM UserOtherProfiles AS u
	WHERE u.P_ID = 4669557
	GROUP BY u.P_ID
)

SELECT DISTINCT
	p.*, 
	a.Phone, a.Email, a.Gender,
	e.User_Education, e.[Education Institute], e.Result, e.passingYear,
	ep.COMPANY, ep.BUSINESS, ep.Department, ep.[Served From], ep.[Served till], ep.[Service Year], ep.Responsibilities,
	t.Training, t.[Topics Covered], t.[Training Institute], t.[Training Location], t.[Course Duration], t.[Training Year],
	s.ProfileURL, s.[Profile Type]
FROM PersonalInfoCTE AS p
LEFT JOIN AccountInfoCTE AS a ON p.ID = a.ID
LEFT JOIN EducationCTE AS e ON p.ID = e.P_ID
LEFT JOIN TrainingCTE AS t ON t.P_ID = p.ID
LEFT JOIN ExperienceCTE AS ep ON ep.P_ID = p.ID
LEFT JOIN SocialLinksCTE AS s ON s.P_ID = p.ID
