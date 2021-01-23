/*
Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц,
так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker.
 */

USE computer;

-- 1 способ.
SELECT DISTINCT Product.maker
FROM Product
    INNER JOIN PC ON Product.model = PC.model
WHERE PC.speed >= 750
  AND Product.maker IN
      (SELECT Product.maker
       FROM Laptop
           INNER JOIN Product ON Laptop.model = Product.model
       WHERE Laptop.speed >= 750)
GROUP BY Product.maker
GO

-- 2 способ.
SELECT maker
FROM Product, PC
WHERE (Product.model = PC.model AND PC.speed >= 750)
INTERSECT
SELECT maker
FROM Product, Laptop
WHERE (Product.model = Laptop.model AND Laptop.speed >= 750)
GO
+---------+
|  maker  |
+---------+
|    A    |
|    B    |
+---------+