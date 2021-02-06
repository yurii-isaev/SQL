-- Задача 197.
-- Напишите SQL-запрос, чтобы найти все даты с более высокими температурами по сравнению с предыдущими датами (вчера).
-- Вывести: таблицу результатов в любом порядке.

USE leetcode;

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Weather')
    BEGIN
        DROP TABLE Weather
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Weather
        (
            id          int,
            recordDate  date,
            temperature int
        )

        INSERT INTO Weather (id, recordDate, temperature) VALUES (1, '2015-01-01', 10)
        INSERT INTO Weather (id, recordDate, temperature) VALUES (2, '2015-01-02', 25)
        INSERT INTO Weather (id, recordDate, temperature) VALUES (3, '2015-01-03', 20)
        INSERT INTO Weather (id, recordDate, temperature) VALUES (4, '2015-01-04', 30)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT
    w1.id as Id
FROM
    Weather as w1,
    Weather as w2
WHERE
    w1.temperature > w2.temperature
  AND
    DATEDIFF(DAY, w2.recordDate, w1.recordDate) = 1
GO

-- Solution
SELECT
    w2.Id
FROM
    Weather w1
         INNER JOIN
     Weather w2
         ON
             DATEDIFF(day, w1.recordDate, w2.recordDate) = 1
         AND
             w2.Temperature > w1.Temperature
GO

-- Input:
-- Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+

-- Output:
+----+
| id |
+----+
| 2  |
| 4  |
+----+
