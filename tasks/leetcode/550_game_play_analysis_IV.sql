-- Задача 550.
-- Напишите SQL-запрос, чтобы сообщить о доле игроков,
-- которые снова вошли в систему на следующий день после дня их первого входа в систему,
-- округленной до 2 знаков после запятой. Другими словами, вам нужно подсчитать количество игроков,
-- которые входили в систему не менее двух дней подряд, начиная с даты их первого входа в систему,
-- а затем разделить это число на общее количество игроков.
-- Вывести: результат запроса приведен в примере.

USE leetcode

IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Activity')
    BEGIN
        DROP TABLE Activity
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Activity
        (
            player_id    int,
            device_id    int,
            event_date   date,
            games_played int
        )

        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (1, 2, '2016-03-01', 5)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (1, 2, '2016-03-02', 6)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (2, 3, '2017-06-25', 1)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (3, 1, '2016-03-02', 0)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (3, 4, '2018-07-03', 5)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT ROUND(
    (SELECT
         count(*)
     FROM(SELECT
              player_id, min(event_date) AS date
          FROM
              activity
          GROUP BY
              player_id) a1
         INNER JOIN activity a2
             ON a1.player_id = a2.player_id
                    AND DATEDIFF(DAY, a1.date, a2.event_date) = 1)* 1.0 / count(DISTINCT player_id), 2
    ) AS fraction
FROM
    activity
GO

-- В SQL Server (Transact-SQL) функция LEAD является аналитической функцией,
-- которая позволяет запрашивать более одной строки в таблице одновременно без необходимости присоединяться к самой таблице.
-- Это возвращает значения из следующей строки в таблице.
-- Чтобы вернуть значение из предыдущей строки, нужно использовать функцию LAG.
WITH CTE as (SELECT *
                  , LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date ASC) AS LEAD
                  , ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date ASC)     AS Rank
             FROM Activity)
SELECT
    CONVERT(DECIMAL(6, 2), (COUNT(1) * 1.0) / (SELECT COUNT(DISTINCT player_id) FROM Activity)) AS fraction
FROM
    CTE
WHERE
    DATEDIFF(DAY, event_date, LEAD) = 1
  AND
    Rank = 1
GO

-- Solution
SELECT
    ROUND(1.0 * COUNT(DISTINCT A.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
    Activity AS A
JOIN
    (SELECT
        player_id,
        MIN(event_date) AS first_day
    FROM
        Activity
    GROUP BY
        player_id) AS T
ON
    A.player_id = T.player_id
WHERE
    DATEDIFF(DAY,T.first_day,A.event_date) = 1
GO

-- Input:
-- Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

-- Output:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
-- Explanation:
-- Только игрок с идентификатором 1 снова вошел в систему после первого дня, когда он вошел в систему,
-- поэтому ответ 13 = 0,33.
