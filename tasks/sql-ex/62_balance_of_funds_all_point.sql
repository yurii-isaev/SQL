/*
Задание: 62.
Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01
для базы данных с отчетностью не чаще одного раза в день.
 */

USE recycling_inc

-- 1 способ с использование объединения UNION.
SELECT SUM(t.Remain) remain
FROM (SELECT
          SUM(inc) Remain
      FROM Income_o
      WHERE '20010415' > date
      UNION
      SELECT - SUM(out)
      FROM Outcome_o
      WHERE '20010415' > date) AS t
GO

-- 2 способ.
SELECT (SELECT sum(inc)
        FROM Income_o
        WHERE '20010415' > date)
           -
       (SELECT sum(out)
        FROM Outcome_o
        WHERE '20010415' > date) AS remain
GO
+------------+
|   remain   |
+------------+
|  6575.9600 |
+------------+
