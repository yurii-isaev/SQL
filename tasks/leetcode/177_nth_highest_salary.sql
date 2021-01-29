-- Задача 177.
-- Напишите SQL-запрос, чтобы сообщить о самой высокой зарплате из таблицы.
-- Если нет самой высокой зарплаты, запрос должен сообщить null.
-- Вывести: таблицу результатов.

-- Solution using Dense_Rank()
CREATE FUNCTION
    getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (SELECT
                max(salary) as getNthHighestsalary
            FROM (SELECT salary, Dense_Rank() OVER (ORDER BY SALARY DESC) AS rn
                  FROM Employee) E
            WHERE E.rn = @N)
END

SELECT dbo.getNthHighestSalary(2) AS "getNthHighestSalary"

DROP FUNCTION getNthHighestSalary

-- Input:
-- Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
n = 2

-- Output:
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+

-- Input:
-- Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 400    |
| 3  | 200    |
| 4  | 500    |
| 5  | 600    |
+----+--------+
n = 2

-- Output:
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 500                    |
+------------------------+

-- Output:
+------------------------+
| getNthHighestSalary(1) |
+------------------------+
| 600                    |
+------------------------+