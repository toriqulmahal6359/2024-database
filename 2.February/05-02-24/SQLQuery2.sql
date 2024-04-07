;WITH User_ID AS(
	COUNT(CASE WHEN u.TExp > 25 AND u.TExp <= 60 THEN u.ApplyId END) AS [2 to 5], 
	COUNT(CASE WHEN u.TExp > 61 AND u.TExp <= 120 THEN u.ApplyId END) AS [5 to 10], 
	COUNT(CASE WHEN u.TExp >= 121 THEN u.ApplyId END) AS [OVER 10],
	COUNT(CASE WHEN j.Score > 50 AND j.Score <= 75 THEN j.ApplyId END) AS [50 to 75], 
	COUNT(CASE WHEN j.Score > 75 AND j.Score <= 90 THEN j.ApplyId END) AS [76 to 90], 
	COUNT(CASE WHEN j.Score > 90 THEN j.ApplyId END) AS [90-100]
	