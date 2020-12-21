-- Задача 109.
-- Вывести:
-- 1. Названия всех квадратов черного или белого цвета.
-- 2. Общее количество белых квадратов.
-- 3. Общее количество черных квадратов.

USE painting
GO

SELECT A.Q_NAME         AS q_name,
       A.Whites         AS whites,
       A.Cnt - A.Whites AS blacks
FROM (SELECT Q.Q_ID,
             Q.Q_NAME,
             (SUM(SUM(B.B_VOL)) OVER ()) / 765 AS Whites, --10
             COUNT(*) OVER ()                  AS Cnt --12
      FROM utQ AS Q
               LEFT JOIN utB AS B
                         ON Q.Q_ID = B.B_Q_ID
      GROUP BY Q.Q_ID,
               Q.Q_NAME
      HAVING SUM(B.B_VOL) = 765
          OR SUM(B.B_VOL) IS NULL) AS A
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
