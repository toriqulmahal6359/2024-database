CREATE TABLE #tempCTE (
	JP_ID INT
)


-- DROP TABLE #tempCTE
INSERT INTO #tempCTE 
SELECT DISTINCT I.JP_ID FROM bdjCorporate..DBO_JOB_INBOX I
INNER JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
INNER JOIN bdjCorporate.rp.Schedule AS s ON ap.schId = s.SchId
WHERE ap.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND ap.UpdatedOn <= GETDATE()
		AND s.ScheduleDate >= GETDATE()
		AND ts.TestType IN('onlinetest','written','facetoface','aiasmnt','video')
		AND ap.SchID > 0 AND ap.Notify = 1

-- SELECT * FROM #tempCTE

;WITH mainCTE AS (
	SELECT I.P_ID, I.JP_ID, ap.SchId, ts.TestType, AP.ApplyId, s.stId			--COUNT(DISTINCT AP.ApplyId) AS [Previously Participated]
			FROM bdjCorporate..DBO_JOB_INBOX I
				INNER JOIN bdjCorporate.rp.TestSteps TS ON I.JP_ID = TS.JP_ID 
				INNER JOIN bdjCorporate.rp.ApplicantProcess AP ON I.ApplyID = AP.ApplyId AND TS.TestLevel = AP.LevelStatus
				INNER JOIN bdjCorporate.rp.Schedule AS s ON ap.schId = s.SchId 
	WHERE ap.UpdatedOn >= DATEADD(HOUR, -3, GETDATE()) AND ap.UpdatedOn <= GETDATE()
		AND ts.TestType IN('onlinetest','written','facetoface','aiasmnt','video')
		AND s.ScheduleDate >= GETDATE()
		AND ap.SchID > 0 AND ap.Notify = 1
		--AND I.JP_ID NOT IN (SELECT JP_ID FROM #tempCTE)
	--GROUP BY I.P_ID, I.JP_ID, ap.SchId, ts.TestType--, ap.ApplyId						--AP.ApplyId, ap.LevelStatus, 
	--HAVING COUNT(AP.ApplyId) = 0
)
, PrevParticipatedExamCTE AS (
	SELECT
		m.P_ID,				--, m.JP_ID, m.SchId,--AND ap.Attended = 1--m.[Previously Participated]
		COUNT(CASE WHEN p.ParticipatedOn IS NOT NULL THEN p.ApplyId END) AS [Previously Participated Exam]
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.ApplyId = ji.ApplyID
		INNER JOIN bdjCorporate.rp.TestSteps ts ON m.JP_ID = ts.JP_ID AND ts.TestType = 'onlinetest'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON ts.TestLevel = ap.LevelStatus					-- m.ApplyId = ap.ApplyId AND
		--INNER JOIN bdjCorporate.rp.ApplicantsResponse AS ar ON ap.ApplyId = ar.ApplyId AND ts.TestLevel = ar.LevelStatus
		INNER JOIN bdjExaminations.exm.Participants AS p ON m.P_ID = p.UserId AND ji.ApplyId = p.ApplyID --AND m.JP_ID = p.JP_ID 
	WHERE m.JP_ID NOT IN (SELECT JP_ID FROM #tempCTE)
	GROUP BY m.P_ID --, m.JP_ID, m.SchId, m.[Previously Participated]
)
, PrevParticipatedCTE AS (
	SELECT 
		m.P_ID, COUNT(ap.ApplyId) AS [Previously participated], ts.TestType 
	FROM mainCTE AS m
		INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.ApplyId = ji.ApplyID
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID --AND ts.TestType = 'onlinetest'
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON ji.ApplyId = ap.ApplyId
		--INNER JOIN bdjExaminations.exm.Participants AS p ON ap.ApplyId = p.ApplyId
	WHERE m.JP_ID NOT IN (SELECT JP_ID FROM #tempCTE)
	GROUP BY m.P_ID, ts.TestType
)
, responseCTE AS (
	SELECT 
		m.P_ID, COUNT(ar.ApplyId) AS [Responded], ts.TestType, m.JP_ID 
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON m.ApplyId = ap.ApplyId AND ts.TestLevel = ap.LevelStatus
		LEFT JOIN bdjCorporate.rp.ApplicantsResponse AS ar ON ap.ApplyId = ar.ApplyId AND ap.LevelStatus = ar.LevelStatus
	GROUP BY m.P_ID, ts.TestType, m.JP_ID
)
, videoCTE AS (
	SELECT 
		m.P_ID, 
		COUNT(DISTINCT CASE WHEN vdo.AnsweredOn IS NOT NULL THEN ap.ApplyId END) AS [Video Submitted],
		COUNT(DISTINCT CASE WHEN vdo.AnsweredOn IS NULL THEN ap.ApplyId END) AS [Video Not Submitted]
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON m.ApplyId = ap.ApplyId
		LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON m.ApplyId = vdo.ApplyId
	GROUP BY m.P_ID
)
, prev_videoCTE AS (
	SELECT 
		m.P_ID, 
		COUNT(DISTINCT CASE WHEN vdo.AnsweredOn IS NOT NULL THEN ap.ApplyId END) AS [Video Submitted],
		COUNT(DISTINCT CASE WHEN vdo.AnsweredOn IS NULL THEN ap.ApplyId END) AS [Video Not Submitted]
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON m.ApplyId = ap.ApplyId
		LEFT JOIN bdjCorporate.vdo.InterviewApplicants AS vdo ON m.ApplyId = vdo.ApplyId
	WHERE m.JP_ID NOT IN (SELECT JP_ID FROM #tempCTE)
	GROUP BY m.P_ID
)
, aiasmntCTE AS (
	SELECT 
		m.P_ID, 
		COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL THEN ap.ApplyId END) AS [AI Assessment Submitted],
		COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NULL THEN ap.ApplyId END) AS [AI Assessment Not Submitted]
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON m.ApplyId = ap.ApplyId
		LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON m.ApplyId = ai.ApplyId
	GROUP BY m.P_ID
)
, prev_aiasmntCTE AS (
	SELECT 
		m.P_ID, 
		COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NOT NULL THEN ap.ApplyId END) AS [AI Assessment Submitted],
		COUNT(DISTINCT CASE WHEN ai.AnsweredOn IS NULL THEN ap.ApplyId END) AS [AI Assessment Not Submitted]
	FROM mainCTE AS m
		INNER JOIN bdjCorporate.rp.TestSteps AS ts ON m.JP_ID = ts.JP_ID
		INNER JOIN bdjCorporate.rp.ApplicantProcess AS ap ON m.ApplyId = ap.ApplyId
		LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON m.ApplyId = ai.ApplyId
	WHERE m.JP_ID NOT IN (SELECT JP_ID FROM #tempCTE)
	GROUP BY m.P_ID
)

SELECT DISTINCT 
	p.NAME AS [Applicant Name], m.JP_ID, CASE WHEN j.JobLang = 2 THEN bj.TITLE ELSE j.JobTitle END AS [Job TiTle],
	c.CP_ID, c.NAME AS [Company Name], c.NameBng AS [Company Name (Bangla)], p.Mobile AS [Mobile Phone]
	,m.SchId,m.TestType, s.ScheduleDate
	, CASE 
		WHEN m.TestType = 'aiasmnt' THEN 
			CASE WHEN pai.[AI Assessment Submitted] > 0 THEN 1 ELSE 0 END
 
		WHEN m.TestType = 'video' THEN
			CASE WHEN v.[Video Submitted] > 0 THEN 1 ELSE 0 END

		WHEN m.TestType = 'onlineTest' THEN
			CASE WHEN ppe.[Previously Participated Exam] > 0 THEN 1 ELSE 0 END
	ELSE
	CASE WHEN pp.[Previously Participated] > 0 THEN 1 ELSE 0 END
	END AS [Previously Participated]
	,CASE 
		WHEN m.TestType = 'aiasmnt' THEN 
			CASE WHEN ai.[AI Assessment Not Submitted] > 0 THEN 1 ELSE 0 END
 
		WHEN m.TestType = 'video' THEN
			CASE WHEN v.[Video Not Submitted] > 0 THEN 1 ELSE 0 END

	ELSE
		CASE WHEN r.[Responded] > 0 THEN 1 ELSE 0 END
	END AS [Responded]
	, vt.VenueName, vt.Address

FROM mainCTE AS m
	INNER JOIN bdjCorporate..DBO_JOBPOSTINGS AS j ON m.JP_ID = j.JP_ID
	LEFT JOIN bdjCorporate..DBO_BNG_JOBPOSTINGS AS bj ON j.JP_ID = bj.JP_ID
	INNER JOIN bdjCorporate..DBO_COMPANY_PROFILES AS c ON j.CP_ID = c.CP_ID
	INNER JOIN bdjResumes..PERSONAL AS p ON m.P_ID = p.ID
	LEFT JOIN prevParticipatedExamCTE AS ppe ON m.P_ID = ppe.P_ID
	LEFT JOIN PrevParticipatedCTE AS pp ON m.P_ID = pp.P_ID
	LEFT JOIN responseCTE AS r ON m.P_ID = r.P_ID
	LEFT JOIN videoCTE AS v ON m.P_ID = v.P_ID
	LEFT JOIN prev_videoCTE AS pv ON m.P_ID = pv.P_ID
	LEFT JOIN aiasmntCTE AS ai ON m.P_ID = ai.P_ID
	LEFT JOIN prev_aiasmntCTE AS pai ON m.P_ID = pai.P_ID
	INNER JOIN bdjCorporate.rp.Schedule AS s ON m.SchId = s.SchId AND m.stId = s.stID
	LEFT JOIN bdjCorporate.rp.TestVenues AS vt ON s.VenueId = vt.VenueId

--SELECT TOP 5 * FROM bdjCorporate.rp.Schedule
--SELECT TOP 5 * FROM bdjCorporate.rp.TestVenues


--SELECT FROM 
--, aisubmissionCTE AS (
--	SELECT m.P_ID, COUNT(CASE WHEN ai.AnsweredOn IS NOT NULL THEN ai.ApplyId ELSE 0 END) AS [AI submitted]
--	FROM mainCTE AS m
--	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
--	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON ji.ApplyId = ai.ApplyId
--	GROUP By m.P_ID
--)
--, videosubmissionCTE AS (
--	SELECT m.P_ID, COUNT(CASE WHEN vd.AnsweredOn IS NOT NULL THEN vd.ApplyId ELSE 0 END) AS [Video Interview submitted]
--	FROM mainCTE AS m
--	INNER JOIN bdjCorporate..DBO_JOB_INBOX AS ji ON m.P_ID = ji.P_ID
--	LEFT JOIN bdjCorporate.[aiass].[AIAssessmentApplicants] AS ai ON ji.ApplyId = ai.ApplyId
--	LEFT JOIN bdjCorporate.[vdo].[InterviewApplicants] AS vd ON ji.ApplyID = vd.ApplyId
--	GROUP BY m.P_ID
--) 
----SELECT TOP 10 * FROM bdjExaminations.exm.Participants

--SELECT TOP 10 * FROM bdjCorporate.[aiass].[AIAssessmentApplicants]


		--COUNT(DISTINCT CASE WHEN ts.TestType = 'onlineTest' AND p.ParticipatedOn IS NOT NULL THEN ap.ApplyId ELSE									--AND ap.ApplyID IS NOT NULL
		--		CASE WHEN ts.TestType = 'written' AND ap.Attended = 1 THEN ap.ApplyId ELSE									--AND ap.Attended = 1 
		--			CASE WHEN ts.TestType = 'facetoface' AND ap.Attended = 1 THEN ap.ApplyId ELSE
		--				CASE WHEN ts.TestType = 'aiasmnt' THEN ap.ApplyId ELSE 
		--					CASE WHEN ts.TestType = 'video' THEN ap.ApplyId END END END END END) AS [Responded]