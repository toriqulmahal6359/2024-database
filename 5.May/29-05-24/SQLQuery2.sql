SELECT * FROM bdjLogs.[dbo].[vExpCount]


SELECT TOP 1000 * FROM bdjExaminations.[dbo].[tmpQuestions]

SELECT TOP 1000 * FROM bdjExaminations.[dbo].[tmpQuestionType]


SELECT TOP 1000 * FROM bdjExaminations.[ans].[Answers]

SELECT * FROM bdjExaminations.[ans].[DescriptiveAnswer]

SELECT * FROM bdjExaminations.[ans].[Summary]
SELECT * FROm bdjExaminations.[que].[Questions]

SELECT * FROM bdjExaminations.[dbo].[tmpExam]
SELECT * FROM bdjExaminations.[dbo].[tmpLocalAnswer]

SELECT * FROM bdjExaminations.[dbo].[AnswerFileAnalysis]

SELECT * FROM bdjExaminations.[que].[gOptionBank]
SELECT * FROM bdjExaminations.[que].[Options]

SELECT q.QText, o.OptText FROM bdjExaminations.[que].[Questions] AS q WITH(NOLOCK)
LEFT JOIN bdjExaminations.[que].[Options] AS o WITH(NOLOCK) ON q.QID = o.QID
WHERE o.RightAnswer = 1
