/*
Задача 129.
Предполагая, что среди идентификаторов квадратов имеются пропуски,
найти минимальный и максимальный "свободный" идентификатор
в диапазоне между имеющимися максимальным и минимальным идентификаторами.
Например, для последовательности идентификаторов квадратов 1,2,5,7 результат должен быть 3 и 6.
Если пропусков нет, вместо каждого искомого значения выводить NULL.
 */

USE painting;

-- 1 способ найти пропуски в последовательности идентификаторов квадратов с помощью производной таблицы.
SELECT (SELECT TOP 1 utq.Q_ID + 1 id
        FROM utQ utq
        WHERE not exists(SELECT NULL FROM utQ mi WHERE mi.Q_ID = utq.Q_ID + 1)
          AND utq.Q_ID < (SELECT max(Q_ID) FROM utQ)
        ORDER BY utq.Q_ID)      AS minq,
       (SELECT TOP 1 utq.Q_ID - 1 id
        FROM utQ utq
        WHERE NOT exists(SELECT NULL FROM utQ mi WHERE Q_ID = Q_ID - 1)
          AND utq.Q_ID > (SELECT min(Q_ID) FROM utQ)
        ORDER BY utq.Q_ID desc) AS minx
GO


-- 2 способ найти пропуски в последовательности идентификаторов квадратов с помощью обобщенного табличного выражения.
WITH cta as (SELECT row_number() OVER (ORDER BY urq.Q_ID) rn, urq.Q_ID + 1 AS minq
             FROM utQ urq
             WHERE NOT exists(SELECT NULL FROM utQ mi WHERE mi.Q_ID = urq.Q_ID + 1)
               and urq.Q_ID < (select max(Q_ID) from utQ)),
     ctb as (SELECT row_number() OVER (ORDER BY urq.Q_ID) rn, urq.Q_ID - 1 AS minx
             FROM utQ urq
             WHERE NOT exists(SELECT NULL FROM utQ mi WHERE mi.Q_ID = urq.Q_ID - 1)
               AND urq.Q_ID > (SELECT min(Q_ID) FROM utQ))
SELECT cta.minq, ctb.minx
FROM cta
    JOIN ctb ON ctb.rn = cta.rn
GO
+------------+-------------+
|    minq    |    minx     |
+------------+-------------+
|     24     |      24     |
+------------+-------------+
