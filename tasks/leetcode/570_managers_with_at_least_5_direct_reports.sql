-- Задача 570.
-- Напишите SQL-запрос, чтобы сообщить менеджерам, по крайней мере, с пятью прямыми подчиненными.
-- Вывести: таблицу результатов в любом порядке.

USE leetcode

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Employee')
    BEGIN
        DROP TABLE Employee
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Employee
        (
            id         int,
            name       varchar(255),
            department varchar(255),
            managerId  int
        )

        INSERT INTO Employee (id, name, department, managerId) VALUES (101, 'John', 'A', null)
        INSERT INTO Employee (id, name, department, managerId) VALUES (102, 'Dan', 'A', 101)
        INSERT INTO Employee (id, name, department, managerId) VALUES (103, 'James', 'A', 101)
        INSERT INTO Employee (id, name, department, managerId) VALUES (104, 'Amy', 'A', 101)
        INSERT INTO Employee (id, name, department, managerId) VALUES (105, 'Anne', 'A', 101)
        INSERT INTO Employee (id, name, department, managerId) VALUES (106, 'Ron', 'B', 101)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT
    e1.name
FROM
    Employee e1
         INNER JOIN
    Employee e2
        ON
         e1.id = e2.managerId
GROUP BY
    e1.name
HAVING
    COUNT(e1.name) >= 5
GO

-- Solution
SELECT
    e.name
FROM
    Employee e
WHERE (SELECT
           COUNT(managerId)
       FROM
           Employee
       WHERE
           managerId = e.id) >= 5
GO


-- Input:
-- Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | None      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+

-- Output:
+------+
| name |
+------+
| John |
+------+