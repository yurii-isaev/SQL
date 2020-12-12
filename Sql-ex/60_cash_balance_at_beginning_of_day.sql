/*
Задача 60.
Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных
с отчетностью не чаще одного раза в день.
Вывод: пункт, остаток.
Замечание. Не учитывать пункты, информации о которых нет до указанной даты.
 */

USE recycling_inc

SELECT input.point,
       input.inc - output.out remain
FROM (SELECT point, SUM(inc) AS inc
      FROM Income_o
      WHERE '20010415' > date
      GROUP BY point) AS input,
     (SELECT point, SUM(out) AS out
      FROM Outcome_o
      WHERE '20010415' > date
      GROUP BY point) AS output
WHERE input.point = output.point
GO

SELECT input.point,
       IIF(inc = NULL, 0, inc) - IIF(out = NULL, 0, out) remain
FROM (SELECT point, SUM(inc) inc
      FROM Income_o
      WHERE '20010415' > date
      GROUP BY point) AS input
         FULL JOIN
     (SELECT point, SUM(out) out
      FROM Outcome_o
      WHERE '20010415' > date
      GROUP BY point) AS output
     ON input.point = output.point
GO
+-----------+---------------+
|   point   |    remain     |
+-----------+---------------+
|    1      |   6403.9600   |
|    2      |   172.0000    |
+-----------+---------------+
