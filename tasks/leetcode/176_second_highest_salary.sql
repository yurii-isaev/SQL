-- Задача 176.
-- Напишите SQL-запрос, чтобы сообщить вторую по величине зарплату из таблицы «Сотрудники».
-- Если нет второй по величине зарплаты, запрос должен сообщить null.
-- Вывести: таблицу результатов.

CREATE TABLE Employee
(
    id     int,
    salary int
);

-- SQL Schema
TRUNCATE TABLE Employee;

INSERT INTO Employee (id, salary)
VALUES ('1', '100');

INSERT INTO Employee (id, salary)
values ('2', '400');

INSERT INTO Employee (id, salary)
VALUES ('3', '200');

INSERT INTO Employee (id, salary)
VALUES ('4', '500');

INSERT INTO Employee (id, salary)
VALUES ('5', '600');

-- Solution 1
SELECT max(salary) as SecondHighestSalary
FROM employee
WHERE salary < (SELECT max(salary) FROM employee);

-- Solution 2
SELECT max(a.salary) as SecondHighestSalary
FROM employee a, employee b
WHERE a.salary < b.salary;

-- Solution 3
SELECT max(a.salary) as SecondHighestSalary
FROM employee a
RIGHT JOIN employee b
ON a.salary < b.salary;


-- Example 1:
-- Input:
-- Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

-- Output:
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

-- Example 2:
-- Input:
-- Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+

-- Output:
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+