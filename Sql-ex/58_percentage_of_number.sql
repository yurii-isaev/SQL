/*
Задача 58.
Для каждого типа продукции и каждого производителя из таблицы Product c точностью до двух десятичных знаков
найти процентное отношение числа моделей данного типа данного производителя к общему числу моделей этого производителя.
Вывод: maker, type, процентное отношение числа моделей данного типа к общему числу моделей производителя
 */

USE Computer

-- 1 способ с использование преобразование типа CAST AS NUMERIC возврашает результат с заданной точностью.
SELECT m,
       t,
       CAST(100.0 * cc / cc1 AS NUMERIC(5, 2))
FROM (SELECT m,
             t,
             SUM(c) cc
      FROM (SELECT DISTINCT maker m, 'PC' t, 0 c
            FROM product
            UNION ALL
            SELECT DISTINCT maker, 'Laptop', 0
            FROM product
            UNION ALL
            SELECT DISTINCT maker, 'Printer', 0
            FROM product
            UNION ALL
            SELECT maker, type, COUNT(*)
            FROM product
            GROUP BY maker, type) as tt
      GROUP BY m, t) tt1
         JOIN (SELECT maker,
                      COUNT(*) cc1
               FROM product GROUP BY maker) tt2
             ON m = maker
GO

-- 2 способ с использование оконной функции типа OVER PARTITION BY.
SELECT DISTINCT maker,
                type,
                CAST(ROUND((count(model) OVER (PARTITION BY maker, type)) * 100.0 /
                           count(model) OVER (PARTITION BY maker), 2) AS NUMERIC(5, 2)) AS 'percent, %'
FROM (SELECT pt.maker,
             pt.type,
             p.model
      FROM (SELECT DISTINCT a.maker, b.type
            FROM product a, product b) pt
               LEFT JOIN product p ON pt.maker = p.maker AND pt.type = p.type) AS p
ORDER BY maker, type
GO
+-----------+---------------+--------------+
|   maker   |    type       |  percent, %  |
+-----------+---------------+--------------+
|    A      |   Laptop      |    28.57     |
|    A      |   PC          |    28.57     |
|    A      |   Printer     |    42.86     |
|    B      |   Laptop      |    50.00     |
|    B      |   PC          |    50.00     |
|    B      |   Printer     |     0.00     |
|    C      |   Laptop      |   100.00     |
|    C      |   PC          |     0.00     |
|    C      |   Printer     |     0.00     |
|    D      |   Laptop      |     0.00     |
|    D      |   PC          |     0.00     |
|    D      |   Printer     |   100.00     |
|    E      |   Laptop      |     0.00     |
|    E      |   PC          |    75.00     |
|    E      |   Printer     |    25.00     |
+-----------+---------------+--------------+
