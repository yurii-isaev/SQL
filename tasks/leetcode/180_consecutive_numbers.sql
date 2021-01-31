-- Задача 180.
-- Напишите SQL-запрос, чтобы найти все числа, которые появляются не менее трех раз подряд.
-- Вывести: таблицу результатов в любом порядке.

USE leetcode;

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
-- id is the primary key for this table.
-- id is an autoincrement column.

IF OBJECT_ID(N'Logs', N'U') IS NULL
CREATE TABLE Logs (id int, num int)
INSERT INTO Logs (id, num) VALUES ('1', '1')
INSERT INTO Logs (id, num) VALUES ('2', '1')
INSERT INTO Logs (id, num) VALUES ('3', '1')
INSERT INTO Logs (id, num) VALUES ('4', '2')
INSERT INTO Logs (id, num) VALUES ('5', '1')
INSERT INTO Logs (id, num) VALUES ('6', '2')
INSERT INTO Logs (id, num) VALUES ('7', '2')
GO


-- Solution using distinct
SELECT DISTINCT(l1.num) AS ConsecutiveNums
FROM logs l1,
     logs l2,
     logs l3
WHERE l1.id = l2.id + 1
  AND l2.id = l3.id + 1
  AND l1.num = l2.num
  AND l2.num = l3.num
GO


-- Solution using distinct and join
SELECT DISTINCT l1.num ConsecutiveNums
FROM Logs l1
    JOIN Logs l2 on l1.id = l2.id + 1
    JOIN Logs l3 on l2.id = l3.id + 1
WHERE l1.num = l2.num
  AND l2.num = l3.num
GO

TRUNCATE TABLE Logs;

-- Input:
-- Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

-- Output:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
