WITH jobCTE AS (
	SELECT DISTINCT j.CP_ID, j.JP_ID, i.P_ID FROM bdjCorporate.[dbo].[DBO_JOBPOSTINGS] AS j
	LEFT JOIN bdjCorporate.[dbo].[DBO_JOB_INBOX] AS i ON i.JP_ID = j.JP_ID
	WHERE j.CP_ID = 20871 AND j.JP_ID = 1213001
)
, personalCTE AS (
	SELECT j.P_ID, p.NAME,  
		DATEDIFF(YEAR, p.BIRTH, GETDATE()) AS Age,
		p.BIRTH AS [Date Of Birth],
		p.MOBILE AS [Contact Number],
		p.HOME_PHONE AS [Secondary Number],
		u.accEmail AS [Email]
	FROM jobCTE AS j
	LEFT JOIN bdjResumes..PERSONAL AS p ON p.ID = j.P_ID
	LEFT JOIN bdjResumes..UserAccounts AS u ON u.accId = j.P_ID
	WHERE p.BIRTH >= '12-26-1993 00:00:00'
)
, educationCTE AS (
	SELECT p.P_ID, p.NAME, p.Age, p.[Date Of Birth], p.[Contact Number], p.[Secondary Number], p.Email 
	, e.EDUCATION, e.PERCENT_MARK AS [CGPA]
	FROM personalCTE AS p
	LEFT JOIN bdjResumes.[dbo].[EDU] AS e ON e.P_ID = p.P_ID
	WHERE p.Age < 30 AND e.RESULT = 11 AND e.Edulevel = 4
)
, experienceCTE AS (
	SELECT ed.P_ID, ed.NAME, ed.Age, ed.[Date Of Birth], ed.[Contact Number], ed.[Secondary Number], ed.Email  
	, ed.EDUCATION, ed.[CGPA]
	, ex.COMPANY AS [Current Organization], ex.ETO
	FROM educationCTE AS ed
	LEFT JOIN bdjResumes.[dbo].[EXP] AS ex ON ex.P_ID = ed.P_ID
	WHERE ex.ETO IS NULL OR ex.ETO = '01-01-1900 00:00:00'
)

SELECT e.P_ID, e.NAME, e.Age, e.[Date Of Birth], e.[Contact Number], e.[Secondary Number], e.[CGPA], e.[Current Organization], e.Email, e.ETO
FROM experienceCTE AS e
