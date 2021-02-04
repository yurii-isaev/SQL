-- Задача 183.
-- Напишите SQL-запрос, чтобы сообщить обо всех клиентах, которые никогда ничего не заказывают.
-- Вывести: таблицу результатов в любом порядке.

USE leetcode;

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Customers'
            AND TABLE_NAME = N'Orders')
    BEGIN
        PRINT 'Table Exists'
    END
ELSE
    BEGIN
        CREATE TABLE Customers
        (
            id   int,
            name varchar(255)
        )

        CREATE TABLE Orders
        (
            id         int,
            customerId int
        )

        INSERT INTO Customers (id, name) VALUES ('1', 'Joe')
        INSERT INTO Customers (id, name) VALUES ('2', 'Henry')
        INSERT INTO Customers (id, name) VALUES ('3', 'Sam')
        INSERT INTO Customers (id, name) VALUES ('4', 'Max')

        INSERT INTO Orders (id, customerId) VALUES ('1', '3')
        INSERT INTO Orders (id, customerId) VALUES ('2', '1')
    END


-- Solution
SELECT name AS Customers
FROM Customers
         LEFT JOIN Orders ON Customers.id = Orders.customerId
WHERE Orders.customerId IS NULL;

-- Solution
SELECT name AS Customers
FROM Customers
WHERE id NOT IN (SELECT customerId FROM Orders);

-- Solution
SELECT name AS Customers
FROM Customers
WHERE NOT EXISTS(SELECT * FROM Orders WHERE Orders.customerId = Customers.id);


-- Input:
-- Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+

-- Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+

-- Output:
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+