WITH BaseCTE AS (
	SELECT DISTINCT
		s.P_ID,
		p.NAME,
		a.accPhone,
		DATEDIFF(YEAR, 0, DATEADD(MONTH, s.TExp, 0)) AS Experience,
		CASE 
			WHEN a.accGender = 'M' THEN 'MALE'
			WHEN a.accGender = 'F' THEN 'FEMALE'
		END AS SEX,
		DATEDIFF(YEAR, p.BIRTH, GETDATE()) AS Age,
		CONVERT(VARCHAR(100), a.accCreatedON, 101) AS [BdJobs Reg Date],
		CASE
			WHEN i.PaidFrom = 0 THEN 'Website'
			WHEN i.PaidFrom = 3 THEN 'App'
		END AS [Paid From],
		CASE 
			WHEN (a.accCatId >= 60 OR a.accCatId = -11) THEN 'Blue Color'
			WHEN (a.accCatId >= 1 AND a.accCatId < 60) OR a.accCatId = -10 THEN 'White Color' 
		END AS [Profile Type],
		pa.pkName AS [Package Name],
		i.PaidBy AS [Payment Method],
		i.BdjAmount AS Price,
		p.EXP_SAL as expectedSalary,
		ROW_NUMBER() OVER(PARTITION BY s.P_ID ORDER BY s.P_ID) AS ROW_COUNT
		FROM [dbo].[PERSONAL] AS p
		INNER JOIN [dbo].[UserAccounts] AS a ON a.accID = p.ID
		INNER JOIN [dbo].[UserSummary] AS s ON s.P_ID = a.accID
		INNER JOIN [mnt].[CandidatePackages] AS c ON c.P_ID = s.P_ID
		INNER JOIN [dbo].[OnlinePaymentInfoJS] AS i ON c.OPID = i.OPID AND c.P_ID = i.P_ID
		INNER JOIN [mnt].[Packages] AS pa ON pa.pkId = c.pkId
		WHERE i.TransStatus = 'S' AND i.ServiceID IN (87, 88, 89)
)
,educationCTE AS (
	SELECT DISTINCT
		b.*,
		l.EDULEVEL,
	ROW_NUMBER() OVER(PARTITION BY e.P_ID ORDER BY (SELECT TOP 1 e.PASSING_YEAR) DESC ) AS ROW_COUNT_EDU
	FROM [dbo].[EDU] AS e
	INNER JOIN [dbo].[EDULEVEL] AS l ON l.E_CODE = e.EduLevel
	INNER JOIN BaseCTE AS b ON b.P_ID = e.P_ID
	WHERE b.ROW_COUNT < 2 
)
, packageCTE AS (
	SELECT DISTINCT
		e.*,
		c.cpkStartDate AS [Purchase Date],
		DATEADD(MONTH, c.cpkDuration, c.cpkStartDate) AS [Package End Date]
	FROM [mnt].[CandidatePackages] AS c
	INNER JOIN educationCTE AS e ON e.P_ID = c.P_ID
	WHERE e.ROW_COUNT_EDU < 2
)

SELECT TOP 5 AVG(expectedSalary) FROM packageCTE


SELECT * FROM [pwd].[PersonalInfo]


SELECT TOP 5 * FROm [dbo].[PERSONAL]

SELECT TOp 5 * FROM bdjResumes..PERSONAL


SELECT TOP 5 * FROm bdjResumes.[dbo].[UserSocialMedia]

SELECT TOP 5 * FROM bdjResumes.[dbo].[UserAccounts]
SELECT * FROm bdjResumes.[dbo].[UserOtherProfiles]

select * from   [dbo].[PersonalAccomplishments]


with cte1 as 
(
select DISTINCT p.id as p_id
from bdjResumes.dbo.PERSONAL p 
--left join bdjresumes.[dbo].[EDU] e on p.id = e.p_id
inner join bdjresumes.[dbo].[PersonalAccomplishments] a on p.id = a.p_id
inner join bdjresumes.pwd.PersonalInfo i on p.id = i.p_id
inner join bdjresumes.dbo.UserOtherProfiles up on p.id = up.P_ID
where pheight is not null AND pheight > 0
       and pweight is not null AND pweight > 0
	   and i.DisabilityID is not null OR i.DisabilityID != ''
	   --and e.ACHIEVEMENT is not null OR e.ACHIEVEMENT != ''
)
select c1.p_id, jp.cp_id, ji.jp_id, 
CASE WHEN jp.JobLang = 2 THEN bj.TITLE ELSE jp.JobTitle END AS [Job Title] 
from cte1 c1
INNER join bdjcorporate.[dbo].[DBO_JOB_INBOX]ji on c1.p_id = ji.p_id
inner join bdjCorporate.[dbo].[DBO_JOBPOSTINGS] jp on ji.jp_id = jp.jp_id
LEFT JOIN bdjCorporate.[dbo].[DBO_BNG_JOBPOSTINGS] bj ON bj.JP_ID = jp.JP_ID

