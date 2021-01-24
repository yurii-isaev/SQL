/*
Задача 61.
Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.
 */

USE recycling_inc

-- 1 способ с использование объединения UNION.
SELECT SUM(t.Remain) remain
FROM (SELECT
          SUM(inc) Remain
      FROM Income_o
      UNION
      SELECT - SUM(out)
      FROM Outcome_o) AS t
GO

-- 2 способ с использование выражения явного преобразования типов CAST.
SELECT ((SELECT CAST(SUM(cast(inc as DEC(12, 4))) as DEC(12, 4))
         FROM Income_o)
    -
        (SELECT CAST(SUM(cast(out as DEC(12, 4))) as DEC(12, 4))
         FROM Outcome_o))
    AS remain
GO

-- 3 способ.
SELECT (SELECT sum(inc) FROM Income_o)
           -
       (SELECT sum(out) FROM Outcome_o)
    AS remain
GO
+------------+
|   remain   |
+------------+
| 28985.9600 |
+------------+
