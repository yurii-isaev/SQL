-- Задача 511.
-- Напишите SQL-запрос, чтобы сообщить дату первого входа в систему для каждого игрока.
-- Вывести: таблицу результатов в любом порядке.

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
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (1, 2, '2016-05-02', 6)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (2, 3, '2017-06-25', 1)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (3, 1, '2016-03-02', 0)
        INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES (3, 4, '2018-07-03', 5)

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT DISTINCT
    player_id,
    Min(event_date) as first_login
FROM
    Activity
GROUP BY
    player_id
GO

-- Input:
-- Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

-- Output:
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+