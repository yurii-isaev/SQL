/*
Задача №26.
Найдите среднюю цену ПК и ПК-блокнотов,
выпущенных производителем A (латинская буква).
Вывести: одна общая средняя цена.
 */

USE computer;

-- 1 способ с помощью UNION all
SELECT AVG(price) AS avg_price
FROM (SELECT price -- Получаем цену из таблицы PC по условию таблицы Product.
      FROM PC
          FULL JOIN product AS P
              ON P.model = PC.model
      WHERE maker = 'A'
        AND type = 'PC'
      UNION ALL
-- Получаем цену из таблицы Laptop по условию таблицы Product.
      SELECT price
      FROM Laptop AS LT
          FULL JOIN Product AS P
              ON P.model = LT.model
      WHERE maker = 'A'
        AND type = 'Laptop') AS price
GO

-- 2 способ с помощью UNION ALL без JOIN.
SELECT AVG(price) AS avg_price
FROM (SELECT price
      FROM PC
      WHERE model IN
            (SELECT model FROM product WHERE maker = 'A' AND type = 'PC')
      UNION ALL
      SELECT price
      FROM laptop
      WHERE model IN
            (SELECT model FROM product WHERE maker = 'A' and type = 'laptop')) AS price
GO
+-----------+
| avg_price |
+-----------+
| 754.1666  |
+-----------+
