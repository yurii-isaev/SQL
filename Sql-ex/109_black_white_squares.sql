/*
Задача 109.
Вывести:
1. Названия всех квадратов черного или белого цвета.
2. Общее количество белых квадратов.
3. Общее количество черных квадратов.
 */

USE painting;

SELECT sub.Q_NAME           AS q_name,
       sub.Whites           AS whites,
       sub.Cnt - sub.Whites AS blacks
FROM (SELECT utq.Q_ID,
             utq.Q_NAME,
             (SUM(SUM(utb.B_VOL)) OVER ()) / 765 AS Whites, --10
             COUNT(*) OVER ()                    AS Cnt     --12
      FROM utQ AS utq
          LEFT JOIN utB AS utb
              ON utq.Q_ID = utb.B_Q_ID
      GROUP BY utq.Q_ID,
               utq.Q_NAME
      HAVING SUM(utb.B_VOL) = 765
          OR SUM(utb.B_VOL) IS NULL) AS sub
GO
+---------------+---------+---------+
|   q_name      |  whites |  blacks |
+---------------+---------+---------+
|  Square # 01  |   10    |    2    |
|  Square # 02  |   10    |    2    |
|  Square # 03  |   10    |    2    |
|  Square # 05  |   10    |    2    |
|  Square # 06  |   10    |    2    |
|  Square # 07  |   10    |    2    |
|  Square # 09  |   10    |    2    |
|  Square # 10  |   10    |    2    |
|  Square # 11  |   10    |    2    |
|  Square # 12  |   10    |    2    |
|  Square # 23  |   10    |    2    |
|  Square # 25  |   10    |    2    |
+---------------+---------+---------+
