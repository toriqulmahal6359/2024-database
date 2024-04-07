SELECT a.P_ID FROM bdjResumes.[dbo].[PersonalAccomplishments] AS a
INNER JOIN bdjResumes.[dbo].[PERSONAL] AS p ON p.ID = a.P_ID
WHERE CONVERT(DATE, p.UPDATED_DATE, 101) <= '03/29/2024'
GROUP BY a.P_ID
HAVING COUNT(a.ID) > 4 



SELECT * FROM bdjResumes.[dbo].[PersonalAccomplishments] WHERE P_ID IN (
6136741,
852636,
4797179,
658962,
3766872,
1691148,
6798672,
4354709,
6786804,
6637012)

SELECT * FROM bdjResumes.[dbo].[PERSONAL]