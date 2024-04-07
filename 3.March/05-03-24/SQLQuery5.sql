WITH jobCTE AS (
	SELECT DISTINCT j.JP_ID, j.P_ID ,j.ApplyID
	FROM bdjCorporate.[dbo].[DBO_JOB_INBOX] AS j
	WHERE j.JP_ID = 1213001
), personalCTE AS (
	SELECT j.P_ID, p.NAME, j.ApplyID, 
	   CONCAT(DATEDIFF(year, p.BIRTH, GETDATE()), '.', DATEDIFF(month, p.BIRTH, GETDATE()) % 12) as age1,
		DATEDIFF(YEAR, p.BIRTH, GETDATE()) AS Age,
		p.BIRTH AS [Date Of Birth],
		p.MOBILE AS [Contact Number],
		p.HOME_PHONE AS [Secondary Number],
		p.E_MAIL1 AS [Email]
	FROM jobCTE AS j
	INNER JOIN bdjResumes..PERSONAL AS p ON p.ID = j.P_ID
	WHERE p.BIRTH >= '12/26/1993'
), educationCTE1 AS (
	SELECT p.ApplyID,p.P_ID, p.NAME, p.Age, p.[Date Of Birth], RIGHT(p.[Contact Number],11) as [Contact Number], RIGHT(p.[Secondary Number],11) as [Secondary Number], p.Email 
	, e.EDUCATION, e.PERCENT_MARK AS [CGPA]
	,ROW_NUMBER() over(partition by  p.P_ID order by e.passing_year desc) as rr
	FROM personalCTE AS p
	inner JOIN bdjResumes.[dbo].[EDU] AS e ON e.P_ID = p.P_ID
	WHERE p.Age < 30 AND e.RESULT = 11 AND e.Edulevel = 4 and  e.PERCENT_MARK > 2.5
	--order by p.P_ID
),educationCTE as (
select * from educationCTE1 where rr=1
)
, experienceCTE AS (
	SELECT distinct ed.ApplyID, ed.P_ID
	, ed.NAME, ed.Age, ed.[Date Of Birth], ed.[Contact Number], ed.[Secondary Number], ed.Email  
	, ed.EDUCATION, ed.[CGPA]
	,case when  ex.SERVE_TILL = 1 then ex.COMPANY end AS [Current Organization], ex.ETO
	,ROW_NUMBER() over(partition by ed.P_ID order by ex.EFROM desc) r
	FROM educationCTE AS ed
	LEFT JOIN bdjResumes.[dbo].[EXP] AS ex ON ex.P_ID = ed.P_ID

)
, finalCTE AS (
	SELECT 
	ROW_NUMBER() OVER(ORDER BY e.P_ID) AS sl,
	e.applyid,e.P_ID, e.NAME, e.Age, e.[Date Of Birth], e.[Contact Number], e.[Secondary Number], e.[CGPA], e.[Current Organization], e.Email, e.ETO --,r
	FROM experienceCTE AS e
	where  r=1 ---and e.p_id = 4543710
	--order by  e.P_ID
)

SELECT * FROM finalCTE WHERE P_ID NOT IN (1790334)
order by P_ID 