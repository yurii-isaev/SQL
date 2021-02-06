-- Задача 196.
-- Напишите SQL-запрос, чтобы удалить все повторяющиеся электронные письма,
-- сохранив только одно уникальное электронное письмо с наименьшим.
-- Обратите внимание, что вы должны написать заявление, а не одно.
-- После выполнения сценария ответом будет показана таблица.
-- Драйвер сначала скомпилирует и запустит фрагмент кода, а затем покажет таблицу.
-- Окончательный порядок таблицы значения не имеет.
-- Вывести: результата запроса приведен в следующем примере.

USE leetcode;

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Person')
    BEGIN
        DROP TABLE Person
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Person
        (
            Id    int,
            Email varchar(255)
        )

        INSERT INTO Person (id, email) VALUES (1, 'john@example.com')
        INSERT INTO Person (id, email) VALUES (2, 'bob@example.com')
        INSERT INTO Person (id, email) VALUES (3, 'john@example.com')

        PRINT 'Table create successfully'
    END
GO

-- Solution
DELETE
FROM
    PERSON
WHERE
    Id NOT IN (SELECT MIN(Id) FROM PERSON GROUP BY EMAIL)
GO

-- Solution
DELETE
    p1
FROM
    person p1
        JOIN
        person p2
            ON p1.email = p2.email AND p1.id > p2.id
GO

-- Solution
DELETE
    p1
FROM
    person p1,
    person p2
WHERE
    p1.id > p2.id
  AND
    p1.email = p2.email
GO

-- Input:
-- Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+

-- Output:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
-- Explanation:
-- john@example.com is repeated two times.
-- We keep the row with the smallest Id = 1.