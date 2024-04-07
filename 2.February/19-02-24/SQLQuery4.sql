DECLARE @age1 INT = 15		-- 18.75 = 15 + 3.75
DECLARE @exp1 INT = 20		-- 25 = 20 + 5
DECLARE @joblevel1 INT = 35	-- 43.75 = 35 + 8.75
DECLARE @sex1 INT = 10		-- 12.5 = 10 + 2.5
DECLARE @edu1 INT = 20		-- 20

DECLARE @total INT = NULL 

;WITH valueCTE AS ( 
	SELECT JP_ID, FilterName,
		CASE WHEN FilterName = 'Age' THEN @age1 
			WHEN FilterName = 'Exp' THEN @exp1
			WHEN FilterName = 'JobLevel' THEN @jobLevel1
			WHEN FilterName = 'Sex' THEN @sex1
		END AS value
	FROM JobMatchFilters WHERE JP_ID = 615250
)
, scoreCTE AS (
	SELECT JP_ID, Filtername, CAST(value AS float) AS value, SUM(value) OVER() AS Total FROM valueCTE
	GROUP BY JP_ID ,FilterName, value
)
--, ratioAS (
	SELECT JP_ID, Filtername, value AS [BEFORE], CAST((value + (value * (100 - Total)/ Total)) AS DECIMAL(10, 2)) AS [AFTER] FROM scoreCTE
--)



SELECT * FROM JobMatchFilters WHERE JP_ID = 601570
DECLARE @filtertotal FLOAT = NULL,
		@ageFilter FLOAT = NULL,
		@expFilter FLOAT = NULL,
		@jobLevelFilter FLOAT = NULL,
		@sexFilter FLOAT = NULL,
		@titleAge VARCHAR(100) = '',
		@titleExperience VARCHAR(100) = '',
		@titleJobLevel VARCHAR(100) = '',
		@titleSex VARCHAR(100) = '';

SET @filterTotal = (@age1 + @exp1 + @jobLevel1 + @sex1)

SET @ageFilter = @age1 / @filtertotal
SET @age1 = @age1 + (@edu1 * @ageFilter)

SET @expFilter = @exp1 / @filtertotal
SET @exp1 = @exp1 + (@edu1 * @expFilter)

SET @jobLevelFilter = @joblevel1 / @filtertotal
SET @joblevel1 = @joblevel1 + (@edu1 * @jobLevelFilter)

SET @sexFilter = @sex1 / @filtertotal
SET @sex1 = @sex1 + (@edu1 * @sexFilter)





--SET @titleAge = 'Age'
--SET @titleExperience = 'Experience'
--SET @titleJobLevel = 'Job Level'
--SET @titleSex = 'Sex'

--SET @ageFilter = @age1 / @filtertotal
--SET @age1 = ROUND(@age1 + (@edu1 * @ageFilter), 0)

--SET @ageFilter = @age1 / @filtertotal
--SET @age1 = ROUND(@age1 + (@edu1 * @ageFilter), 0)

--SELECT @titleAge AS Title, @age1 AS Value
--UNION ALL
--SELECT @titleExperience AS Title, @exp1 AS Value
--UNION ALL
--SELECT @titleJobLevel AS Title, @joblevel1 AS Value
--UNION ALL
--SELECT @titleSex AS Title, @sex1 AS Value

SELECT * FROM JobMatchFilters WHERE JP_ID = 601570

SELECT * FROM JobMatchFilters WHERE JP_ID = 604647


SELECT FilterValue FROM JobMatchFilters WHERE JP_ID = 601570