/*
Задача 64.
Используя таблицы Income и Outcome,
для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день.
 */

USE recycling_inc

SELECT i.point,
       i.date,
       'inc'    AS operation,
       sum(inc) AS money
FROM Income i
         LEFT JOIN Outcome o ON i.point = o.point AND i.date = o.date
WHERE o.date IS NULL
GROUP BY i.point, i.date
UNION
SELECT o.point, o.date, 'out', sum(out)
FROM Income i
    RIGHT JOIN Outcome o ON i.point = o.point AND i.date = o.date
WHERE i.date IS NULL
GROUP BY o.point, o.date
GO
+-----------+---------------+-------------+---------------+
|   point   |    date       |  operation  |     money     |
+-----------+---------------+-------------+---------------+
|    1      |   2001-03-14  |    out      |   15348.0000  |
|    1      |   2001-03-22  |    inc      |   30000.0000  |
|    1      |   2001-03-23  |    inc      |   15000.0000  |
|    1      |   2001-03-26  |    out      |    1221.0000  |
|    1      |   2001-03-28  |    out      |    2075.0000  |
|    1      |   2001-03-29  |    out      |    4010.0000  |
|    1      |   2001-04-11  |    out      |    3195.0400  |
|    1      |   2001-04-27  |    out      |    3110.0000  |
|    2      |   2001-03-24  |    inc      |    3000.0000  |
|    2      |   2001-03-29  |    out      |    7848.0000  |
|    2      |   2001-04-02  |    out      |    2040.0000  |
|    3      |   2001-09-14  |    out      |    1150.0000  |
+-----------+---------------+-------------+---------------+
