SELECT * FROM DBO_JOBPOSTINGS AS p WHERE p.CP_ID = 85787 AND p.Drafted = 1 

SELECT TOP 5 * FROM rp.ApplicantProcess
SELECT TOP 5 * FROM rp.TestSteps
SELECT TOP 5 * FROM rp.empConversation
SELECT TOP 5 * FROM bdjCorporate.rp.ApplicantsResponse
SELECT TOP 150 * FROM bdjResumes.vdo.VideoResumes
SELECT TOP 5 * FROM  [dbo].[DBO_JOBPOSTINGS]
SELECT TOP 5 * FROM [dbo].[DBO_COMPANY_PROFILES] WHERE CP_ID = 77868--100408--23602--17587

SELECT TOp 5 * FROM [dbo].[Feedbacks]

SELECT TOP 100 * FROM [rp].[JobCloser]
SELECT TOP 500 * FROM [rp].[TestVenues]       --- here userID is Company User Id's
SELECT TOP 100 * FROM [Sales].[AssignCompany]
SELECT TOP 100 * FROM [Sales].[SalesPersons]

SELECT * FROm [vdo].[LiveChat]

SELECT * FROM bdjResumes.[dbo].[UserSocialMedia]
SELECT * FROM bdjResumes.[dbo].[wpVisits]
SELECT * FROm bdjResumes.[dbo].[wpVisitDetails]

SELECT * FROM bdjResumes.[spec].[NEW_SKILL]
SELECT * FROM bdjResumes.[spec].skills WHERE SkillName LIKE '%Java%' AND ( SkillName NOT LIKE '%Java_%' OR SkillName NOT LIKE '%_Java%')
SELECT * FROM bdjResumes.[spec].skills WHERE SkillName LIKE '%java%' AND ( SkillName NOT LIKE '%s' OR SkillName NOT LIKE '%c')

SELECT * FROM bdjResumes.[mnt].[Packages]
SELECT * FROM bdjResumes.[mnt].[PackageWiseFeatures]

SELECT * FROM bdjResumes.[pts].[ActivityList]
SELECT * FROM bdjResumes.[pts].[UserActivityPoints]

SELECT * FROM bdjResumes.[pwd].[PersonalInfo]
SELECT * FROM bdjResumes.[prc].[Agents]

SELECT * FROM bdjResumes.[prc].[PaymentInfo]


SELECT * FROM bdjResumes.[ttc].[Institutelist]