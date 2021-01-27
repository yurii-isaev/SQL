-- Функции, определенные пользователем (user defined functions, UDF) — это конструкции, содержащие исполняемый код.
-- Функция выполняет какие-либо действия над данными и возвращает некоторое значение/набор данных
-- К функциям можно обращаться из триггеров, хранимых процедура и из других программных компонентов.

USE leetcode;

-- Создаем таблицу сотрудников
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Salary     DECIMAL(10, 2)
);

-- Добавляем данные в таблицу
INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary)
VALUES (1, 'John', 'Doe', 50000.00),
       (2, 'Jane', 'Doe', 60000.00),
       (3, 'Bob', 'Smith', 75000.00),
       (4, 'Alice', 'Johnson', 90000.00),
       (5, 'Tom', 'Jones', 65000.00);


-- Создаем пользовательскую функцию, которая возвращает среднюю зарплату сотрудника
CREATE FUNCTION GetAvgSalary(@LastName VARCHAR(50))
    RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalSalary DECIMAL(10, 2);
    DECLARE @NumEmployees INT;
    DECLARE @AvgSalary DECIMAL(10, 2);

    SELECT @TotalSalary = SUM(Salary),
           @NumEmployees = COUNT(*)
    FROM Employees
    WHERE LastName = @LastName;

    SET @AvgSalary = @TotalSalary / @NumEmployees;

    RETURN @AvgSalary;
END;

-- Вызываем пользовательскую функцию и передаем значение аргумента
SELECT dbo.GetAvgSalary('Doe') AS "avg_salary";

DROP FUNCTION GetAvgSalary;

-- table:
+------------+-----------+-----------+------------+
| EmployeeID | FirstName | LastName  | Salary     |
+------------+-----------+-----------+------------+
|   1        | John      | Doe       |   50000    |
|   2        | Jane      | Doe       |   60000    |
|   3        | Bob       | Smith     |   75000    |
|   4        | Alice     | Johnson   |   90000    |
|   5        | Tom       | Jones     |   65000    |
+------------+-----------+-----------+------------+

-- Output:
+-------------+
| avg_salary  |
+-------------+
|  55000.00   |
+-------------+