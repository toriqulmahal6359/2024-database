;WITH User_ID AS(
	select P.ID
	,p.PhotoUploaded
	from bdjResumes..PERSONAL p
	INNER JOIN P_ID_CTE  pc on p.ID = pc.P_ID
	GROUP BY P.ID,p.PhotoUploaded,p.NAME,p.MOBILE,CONCAT(DATEDIFF(year, p.BIRTH, GETDATE()), '.', DATEDIFF(month, p.BIRTH, GETDATE()) % 12),	CASE WHEN p.M_STATUS = 0 THEN 'UnMarried' ELSE 'Married' END

),CV_CTE AS (
	Select  P.ID,case when p.PhotoUploaded =  1 then 20 end as photo, 
		E=case when (select top 1 ed_id from bdjResumes..Edu where P_ID=p.ID) > 0 then 20 end, T=case when (select top 1 t_id from bdjResumes..TRAINING where P_ID=p.ID) > 0 then 5 end, 
		P=case when (select top 1 pe_id from bdjResumes..PEdu where P_ID=p.ID) > 0 then 5 end , X= case when (select top 1 ex_id from bdjResumes..[EXP] where P_ID=p.ID) > 0 then 20 end,
		S=case when (select top 1 p_id from bdjResumes..SPECIALIST where P_ID=p.ID) > 0 then 5 end, 
		R=case when (select top 1 r_id from bdjResumes..REF where P_ID=p.ID) > 0 then 5 end,
		case when ac.CVPosted = 1 then 20 end personal, ac.accCatId AS CAT_ID
	From ID  p
	Left Join bdjResumes..PersonalExtras pe on p.Id=pe.p_id
	LEFT Join bdjResumes..useraccounts ac on p.id=ac.accid
	)
	SELECT N.ID
	,(CASE WHEN photo IS NULL THEN 0 ELSE photo END)+(CASE WHEN E IS NULL THEN 0 ELSE E END)+(CASE WHEN T IS NULL THEN 0 ELSE T END)+(CASE WHEN P IS NULL THEN 0 ELSE P END) +(CASE WHEN X IS NULL THEN 0 ELSE X END)  +(CASE WHEN S IS NULL THEN 0 ELSE S END)+(CASE WHEN R IS NULL THEN 0 ELSE R END)+(CASE WHEN personal IS NULL THEN 0 ELSE personal END)  as [Bdjobs profile completeness]
	from CV_CTE N
	LEFT JOIN bdjResumes.vdo.VideoResumes V ON N.ID = V.P_ID

SELECT TOP 5 * FROM bdjCorporate..DBO_JOBPOSTINGS
SELECT TOP 5 * FROM bdjCorporate..DBO_JOB_INBOX

WITH JobCTE AS (
	SELECT * FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	WHERE j.PublishDate >= '07-01-2023 00:00:00' AND j.PublishDate <= '12-31-2023 00:00:00'
)
,ApplicantCTE AS (
	SELECT 
	j.JP_ID, 
	a.P_ID,
	a.ApplyId,
	ROW_NUMBER() OVER(PARTITION BY j.JP_ID ORDER BY a.P_DATE ASC) AS Row_Count
	FROM JobCTE AS j
	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS a ON a.JP_ID = j.JP_ID	
)
,UserCTE AS (
	SELECT
	a.JP_ID, a.ApplyId, u.P_ID, a.Row_Count
	FROM bdjResumes..UserSummary AS u
	INNER JOIN ApplicantCTE AS a ON a.P_ID = u.P_ID
	WHERE a.Row_count < 21
)

SELECT * FROM UserCTE 

GO

SELECT * FROM bdjCorporate..DBO_JOB_INBOX
SELECT * FROM DBO_JobPostings

GO

WITH JobCTE AS (
	SELECT 
	j.JP_ID, 
	i.P_ID,
	i.ApplyId,
	i.P_DATE,
	i.Score,
	u.TExp,
	ROW_NUMBER() OVER(PARTITION BY i.JP_ID ORDER BY i.P_DATE) AS ROW_COUNT
	--ROW_NUMBER() OVER(PARTITION BY i.JP_ID ORDER BY i.P_DATE) AS ROW_NUM
	FROM bdjCorporate..DBO_JOBPOSTINGS AS j
	LEFT JOIN bdjCorporate..DBO_JOB_INBOX AS i ON i.JP_ID = j.JP_ID
	LEFT JOIN bdjResumes..UserSummary AS u ON u.P_ID = i.P_ID
	WHERE j.PublishDate >= '07-01-2023 00:00:00' AND j.PublishDate <= '12-31-2023 00:00:00'
)

	SELECT DISTINCT
	j.JP_ID,
	COUNT(CASE WHEN j.TExp >= 0 AND j.TExp  <= 24 THEN j.ApplyId END) AS [0 to 2],
	COUNT(CASE WHEN j.TExp >= 25 AND j.TExp <= 60 THEN  j.ApplyId END) AS [2 to 5], 
	COUNT(CASE WHEN j.TExp >= 61 AND j.TExp <= 120 THEN  j.ApplyId END) AS [5 to 10], 
	COUNT(CASE WHEN j.TExp >= 121 THEN  j.ApplyId END) AS [OVER 10],
	COUNT(CASE WHEN j.Score >= 0 AND j.Score <= 50 THEN j.ApplyId END) AS [0 to 50],
	COUNT(CASE WHEN j.Score > 50 AND j.Score <= 75 THEN j.ApplyId END) AS [50 to 75], 
	COUNT(CASE WHEN j.Score > 75 AND j.Score <= 90 THEN j.ApplyId END) AS [76 to 90], 
	COUNT(CASE WHEN j.Score > 90 THEN j.ApplyId END) AS [90-100]
	FROM JobCTE AS j
	WHERE j.ROW_COUNT < 21
	GROUP BY j.JP_ID

SELECT ApplyID FROM DBO.DBO_JOB_INBOX WHERE JP_ID = 1211021 --1160476--1176764

	--, userCTE AS (
--	SELECT
--	j.JP_ID,
--	j.ApplyId,
--	u.P_ID, 
--	u.TExp,
--	--DATEDIFF(YEAR, 0, DATEADD(MONTH, u.TExp, 0)) AS Experience,
	
	
--	INNER JOIN JobCTE AS j ON j.P_ID = u.P_ID
--)

GO

WITH 

	SELECT DISTINCT
	u.JP_ID,
	
	

	



--SELECT u.*, j.* 
--FROM userCTE AS u 
--INNER JOIN jobCTE AS j ON j.P_ID = u.P_ID
--WHERE j.ROW_COUNT < 21
--ORDER BY j.JP_ID ASC

 