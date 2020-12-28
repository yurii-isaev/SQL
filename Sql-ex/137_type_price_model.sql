/*
Задача 137.
Для каждой пятой модели (в порядке возрастания номеров моделей) в таблице Product
узнайте ее тип продукта и среднюю цену.
 */

USE computer;

SELECT mo.type,
       CASE
           WHEN mo.type = 'pc' THEN AVG(p.price)
           WHEN mo.type = 'laptop' THEN AVG(lap.price)
           WHEN mo.type = 'printer' THEN AVG(prin.price)
       END avg_price
FROM (SELECT prod.model, prod.type, prod.num
      FROM (SELECT row_number() over (ORDER BY model ASC) num, model, type
            FROM Product) prod
      GROUP BY prod.model, prod.type, prod.num
      HAVING num % 5 = 0) mo
         LEFT JOIN Pc p ON mo.model = p.model
         LEFT JOIN Laptop lap ON mo.model = lap.model
         LEFT JOIN Printer prin ON mo.model = prin.model
GROUP BY mo.num, mo.type
GO
+------------+-------------+
|    type    |  avg_price  |
+------------+-------------+
|  PC        |    NULL     |
|  Printer   |  400.0000   |
|  Printer   |  270.0000   |
+------------+-------------+
