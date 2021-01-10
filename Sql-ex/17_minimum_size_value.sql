/*
Задача 17.
Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed.
 */

USE computer;

SELECT DISTINCT Product.type, Laptop.model, Laptop.speed
FROM Product, Laptop
WHERE Laptop.speed < (SELECT MIN(speed) FROM PC)
  AND Product.type = 'laptop'
GO

SELECT DISTINCT product.type, laptop.model, laptop.speed
FROM Laptop JOIN Product
    ON Laptop.model = Product.model
WHERE Laptop.speed < ALL (SELECT PC.speed FROM PC)
GO
+---------+----------+----------+
|   type  |  model   |  speed   |
+---------+----------+----------+
| Laptop  |   1298   |   350    |
+---------+----------+----------+
