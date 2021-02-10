-- Задача 570.
-- Напишите SQL-запрос, чтобы сообщить имена клиентов, на которые клиент не ссылается с помощью.
-- id = 2
-- Вывести: таблицу результатов в любом порядке.

USE leetcode

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Customer')
    BEGIN
        DROP TABLE Customer
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Customer
        (
            id         int,
            name       varchar(25),
            referee_id int
        )

        INSERT INTO Customer (id, name, referee_id) VALUES (1, 'Will', null)
        INSERT INTO Customer (id, name, referee_id) VALUES (2, 'Jane', null)
        INSERT INTO Customer (id, name, referee_id) VALUES (3, 'Alex', 2)
        INSERT INTO Customer (id, name, referee_id) VALUES (4, 'Bill', null)
        INSERT INTO Customer (id, name, referee_id) VALUES (5, 'Zack', 1)
        INSERT INTO Customer (id, name, referee_id) VALUES (6, 'Mark', 2)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT
    name
FROM
    Customer
WHERE
    referee_id IS NULL
   OR
    referee_id <> 2
GO

-- Solution
SELECT
    name
FROM
    Customer
WHERE
    referee_id != 2
   OR
    referee_id IS NULL
GO

-- Solution
SELECT
    name
FROM
    Customer
WHERE
    isnull(referee_id, 0) != 2
GO


-- Input:
-- Customer table:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+

-- Output:
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+