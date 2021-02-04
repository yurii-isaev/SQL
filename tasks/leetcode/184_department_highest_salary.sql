-- Задача 184.
-- Напишите SQL-запрос, чтобы найти сотрудников, которые имеют самую высокую зарплату в каждом из отделов.
-- Вывести: таблицу результатов в любом порядке.

USE leetcode

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Employee')
    BEGIN
        DROP TABLE Employee;
        DROP TABLE Department
        PRINT 'Tables delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Employee
        (
            id           int,
            name         varchar(255),
            salary       int,
            departmentId int
        )

        CREATE TABLE Department
        (
            id   int,
            name varchar(255)
        )

        INSERT INTO Employee (id, name, salary, departmentId) VALUES (1, 'Joe', 70000, 1)
        INSERT INTO Employee (id, name, salary, departmentId) VALUES (2, 'Jim', 90000, 1)
        INSERT INTO Employee (id, name, salary, departmentId) VALUES (3, 'Henry', 80000, 2)
        INSERT INTO Employee (id, name, salary, departmentId) VALUES (4, 'Sam', 60000, 2)
        INSERT INTO Employee (id, name, salary, departmentId) VALUES (5, 'Max', 90000, 1)

        INSERT INTO Department (id, name) VALUES (1, 'IT')
        INSERT INTO Department (id, name) VALUES (2, 'Sales')
        PRINT 'Tables create successfully'
    END
GO

-- Solution
SELECT
    Department.Name AS Department,
    Employee.Name   AS Employee,
    Employee.Salary
FROM
    Department,
    Employee
WHERE
    Employee.DepartmentId = Department.Id
  AND
    Employee.Salary = (SELECT max(Salary)
                       FROM Employee
                       WHERE Employee.DepartmentId = Department.Id)
GO

-- Solution
SELECT
    Department,
    Employee,
    Salary
FROM (SELECT D.NAME                                                         AS Department,
             E.NAME                                                         AS Employee,
             E.Salary                                                       AS Salary,
             DENSE_RANK() OVER (PARTITION BY D.NAME ORDER BY E.Salary DESC) AS rank
      FROM
          EMPLOYEE E
              JOIN
              DEPARTMENT D ON D.ID = E.DepartmentId) AS R
WHERE
    R.rank = 1;
GO

-- Input:
-- Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+

-- Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+

-- Output:
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
-- Explanation:
-- Max and Jim both have the highest salary in the IT department and
-- Henry has the highest salary in the Sales department.