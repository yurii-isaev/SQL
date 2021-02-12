-- Задача 595.
-- Напишите SQL-запрос, чтобы найти клиента, который разместил наибольшее количество заказов.
-- Тестовые примеры генерируются таким образом, что ровно один клиент разместит больше заказов, чем любой другой клиент.
-- Вывести: результат запроса приведен в примере.

USE leetcode

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'World')
    BEGIN
        DROP TABLE World
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE World
        (
            name       varchar(255),
            continent  varchar(255),
            area       int,
            population int,
            gdp        bigint
        )

        INSERT INTO World (name, continent, area, population, gdp)
        VALUES ('Afghanistan', 'Asia', 652230, 25500100, 20343000000)

        INSERT INTO World (name, continent, area, population, gdp)
        VALUES ('Albania', 'Europe', 28748, 2831741, 12960000000)

        INSERT INTO World (name, continent, area, population, gdp)
        VALUES ('Algeria', 'Africa', 2381741, 37100000, 188681000000)

        INSERT INTO World (name, continent, area, population, gdp)
        VALUES ('Andorra', 'Europe', 468, 78115, 3712000000)

        INSERT INTO World (name, continent, area, population, gdp)
        VALUES ('Angola', 'Africa', 1246700, 20609294, 100990000000)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT
    name,
    population,
    area
FROM
    world
WHERE
    area >= 3000000
   OR
    population >= 25000000
GO

-- Solution
DECLARE @MinArea as int = 3000000
DECLARE @MinPopulation as int = 25000000

SELECT
    name,
    population,
    area
FROM
    World
WHERE
    area >= @MinArea
   OR
    population >= @MinPopulation
GO

-- Input:
-- World table:
+-------------+-----------+---------+------------+--------------+
| name        | continent | area    | population | gdp          |
+-------------+-----------+---------+------------+--------------+
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |
+-------------+-----------+---------+------------+--------------+

-- Output:
+-------------+------------+---------+
| name        | population | area    |
+-------------+------------+---------+
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |
+-------------+------------+---------+