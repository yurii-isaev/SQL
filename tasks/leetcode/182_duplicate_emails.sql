-- Задача 182.
-- Напишите SQL-запрос, чтобы сообщить обо всех повторяющихся электронных письмах.
-- Обратите внимание, что гарантируется, что поле электронной почты не равно NULL.
-- Вывести: таблицу результатов в любом порядке.

USE leetcode;

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Person')
BEGIN
  PRINT 'Table Exists'
END
ELSE
BEGIN
  PRINT 'Table NOT Exists'
END

IF OBJECT_ID(N'Person', N'U') IS NULL
CREATE TABLE Person (id int, email varchar(255))
INSERT INTO Person (id, email) VALUES (1, 'a@b.com')
INSERT INTO Person (id, email) VALUES (2, 'c@d.com')
INSERT INTO Person (id, email) VALUES (3, 'a@b.com')

TRUNCATE TABLE Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
-- id is the primary key column for this table.
-- Each row of this table contains an email. The emails will not contain uppercase letters.

-- JOIN:
SELECT DISTINCT P1.Email
FROM Person P1
JOIN Person P2 ON P1.Email = P2.Email
WHERE P1.Id <> P2.Id
GO

-- Sub-query:
SELECT EMAIL FROM
    (SELECT Email, COUNT(Email) AS EmailCount
     FROM Person GROUP BY Email) Q
WHERE EmailCount >= 2
GO

-- HAVING:
SELECT Email FROM Person
GROUP BY Email
HAVING COUNT(Email) >= 2
GO

-- Input:
-- Person table:
+----+---------+
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+

-- Output:
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
-- Explanation: a@b.com is repeated two times.