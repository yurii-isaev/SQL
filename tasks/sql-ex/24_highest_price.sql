/*
Задание 24:
Перечислите номера моделей любых типов,
имеющих самую высокую цену по всей имеющейся в базе данных продукции.
 */

USE computer;

WITH allproducts AS
         (SELECT model, price
          FROM pc
          WHERE price = (SELECT MAX(price) FROM pc)
          UNION
          SELECT model, price
          FROM laptop
          WHERE price = (SELECT MAX(price) FROM laptop)
          UNION
          SELECT model, price
          FROM printer
          WHERE price = (SELECT MAX(price) FROM printer))
SELECT model
FROM allproducts
WHERE price = (SELECT MAX(price) FROM allproducts)
GO
+------------+
|   model    |
+------------+
|    1750    |
+------------+
