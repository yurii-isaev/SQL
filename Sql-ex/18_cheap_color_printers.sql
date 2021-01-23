/*
Задача 18.
Найдите производителей самых дешевых цветных принтеров.
Вывести: maker, price.
 */

USE computer;

SELECT DISTINCT Product.maker, Printer.price
FROM Product
    INNER JOIN Printer
        ON product.model = printer.model
WHERE (Printer.price = (SELECT MIN(price) FROM Printer WHERE Printer.color = 'y'))
  AND Printer.color = 'y'
GO
+---------+------------+
|  maker  |  price     |
+---------+------------+
|    D    |  270.0000  |
+---------+------------+
