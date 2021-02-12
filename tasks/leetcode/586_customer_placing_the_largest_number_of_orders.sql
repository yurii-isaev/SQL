-- Задача 570.
-- Напишите SQL-запрос, чтобы найти клиента, который разместил наибольшее количество заказов.
-- Тестовые примеры генерируются таким образом, что ровно один клиент разместит больше заказов, чем любой другой клиент.
-- Вывести: результат запроса приведен в примере.

USE leetcode

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Orders')
    BEGIN
        DROP TABLE Orders
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Orders
        (
            order_number    int,
            customer_number int
        )

        INSERT INTO Orders (order_number, customer_number) VALUES (1, 1)
        INSERT INTO Orders (order_number, customer_number) VALUES (2, 2)
        INSERT INTO Orders (order_number, customer_number) VALUES (3, 3)
        INSERT INTO Orders (order_number, customer_number) VALUES (4, 3)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT TOP 1
    customer_number
FROM
    Orders
GROUP BY
    customer_number
ORDER BY
    count(customer_number) DESC
GO

-- Solution
WITH cte AS
    (SELECT TOP 1 customer_number, count(order_number) AS count_of_orders
FROM
    Orders
GROUP BY
    customer_number
ORDER BY
    count(order_number) desc)
SELECT
    customer_number
FROM
    cte
GO

-- Input:
-- Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+

-- Output:
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
-- Explanation:
-- The customer with number 3 has two orders,
-- which is greater than either customer 1 or 2 because each of them only has one order.
-- So the result is customer_number 3.