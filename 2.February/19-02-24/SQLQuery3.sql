DECLARE @age1 FLOAT = 15		-- 18.75 = 15 + 3.75
DECLARE @exp1 FLOAT = 20		-- 25 = 20 + 5
DECLARE @joblevel1 FLOAT = 35	-- 43.75 = 35 + 8.75
DECLARE @sex1 FLOAT = 10		-- 12.5 = 10 + 2.5
DECLARE @edu1 FLOAT = 20		-- 20

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

SET @titleAge = 'Age'
SET @titleExperience = 'Experience'
SET @titleJobLevel = 'Job Level'
SET @titleSex = 'Sex'

--SET @ageFilter = @age1 / @filtertotal
--SET @age1 = ROUND(@age1 + (@edu1 * @ageFilter), 0)

--SET @ageFilter = @age1 / @filtertotal
--SET @age1 = ROUND(@age1 + (@edu1 * @ageFilter), 0)

SELECT @titleAge AS Title, @age1 AS Value
UNION ALL
SELECT @titleExperience AS Title, @exp1 AS Value
UNION ALL
SELECT @titleJobLevel AS Title, @joblevel1 AS Value
UNION ALL
SELECT @titleSex AS Title, @sex1 AS Value

SELECT * FROM bdjCorporate..JobMatchFilters WHERE JP_ID = 601570

--SET @filter = (@age1 + @exp1 + @joblevel1 + @sex1)

--SELECT @filter
--DECLARE @age1 
--SET @ratio = 1.0 * @filter/ @edu1

--SELECT @ratio

--SELECT *,
--       Title.values AS Title,
--       ValueColumn.Value AS Value
--FROM JobMatchFilters
--CROSS JOIN (VALUES ('Age'), ('Experience'), ('JobLevel'), ('Sex')) AS Title(Title)
--CROSS JOIN (VALUES (@age1), (@exp1), (@joblevel1), (@sex1)) AS ValueColumn(Value)
--WHERE JP_ID = 601570;


--SELECT *, @titleAge AS Title, @age1 AS Value FROM JobMatchFilters WHERE JP_ID = 601570
--	UNION 
--SELECT *, @titleExperience, @exp1 FROM JobMatchFilters WHERE JP_ID = 601570
--	UNION 
--SELECT *, @titleJobLevel, @joblevel1 FROM JobMatchFilters WHERE JP_ID = 601570
--	UNION 
--SELECT *, @titleSex, @sex1 FROM JobMatchFilters WHERE JP_ID = 601570