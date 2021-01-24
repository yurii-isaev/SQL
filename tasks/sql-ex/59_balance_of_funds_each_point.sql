/*
Задача 59.
Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день.
Вывод: пункт, остаток.
 */

USE recycling_inc;

-- 1 способ с использование объединения.
SELECT point,
       SUM(remain) remain
FROM (SELECT point, SUM(inc) remain
      FROM income_o GROUP BY point
      UNION
      SELECT point, -SUM(out)
      FROM outcome_o GROUP BY point) this_table
GROUP BY point
GO

-- 2 способ с использование таблицы подзапросов.
SELECT input.point,
       input.inc - output.out remain
FROM (SELECT point, SUM(inc) AS inc
      FROM Income_o GROUP BY point) AS input,
     (SELECT point, SUM(out) AS out
      FROM Outcome_o GROUP BY point) AS output
WHERE input.point = output.point;
GO
+-----------+---------------+
|   point   |    remain     |
+-----------+---------------+
|    1      |   5263.9600   |
|    2      |   172.0000    |
|    3      |   23550.0000  |
+-----------+---------------+
