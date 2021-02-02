-- Задача 181.
-- Напишите SQL-запрос, чтобы найти сотрудников, которые зарабатывают больше, чем их руководители.
-- Вывести: таблицу результатов в любом порядке.

USE leetcode;

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
-- id is the primary key column for this table.
-- Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.

IF OBJECT_ID(N'Employee', N'U') IS NULL
CREATE TABLE Employee
(
    id        int,
    name      varchar(255),
    salary    int,
    managerId int
)
INSERT INTO Employee (id, name, salary, managerId)
VALUES (1, 'Joe', 70000, 3)
INSERT INTO Employee (id, name, salary, managerId)
VALUES (2, 'Henry', 80000, 4)
INSERT INTO Employee (id, name, salary, managerId)
VALUES (3, 'Sam', 60000, null)
INSERT INTO Employee (id, name, salary, managerId)
VALUES (4, 'Max', 90000, null)
GO

TRUNCATE TABLE Employee;

-- Solution
SELECT employee.name AS Employee
FROM Employee employee,
     Employee manager
WHERE employee.managerid = manager.id
  AND employee.salary > manager.salary
GO

SELECT employee.name AS Employee
FROM Employee employee,
     (select * from employee where id in (select managerId from employee)) AS manager
WHERE employee.salary > manager.salary
  AND employee.managerId = manager.id;
GO

-- Solution by INNER JOIN
SELECT employee.name AS Employee
FROM Employee employee
    INNER JOIN Employee manager
    ON employee.managerId = manager.id
    AND employee.salary > manager.salary
GO

-- Solution by JOIN
SELECT employee.name Employee
FROM employee employee
    JOIN employee manager
        ON employee.managerid = manager.id
WHERE employee.salary > manager.salary
GO

-- Input:
-- Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | null      |
| 4  | Max   | 90000  | null      |
+----+-------+--------+-----------+

-- Output:
+----------+
| Employee |
+----------+
| Joe      |
+----------+