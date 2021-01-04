/*
Задача 126.
Для последовательности пассажиров, упорядоченных по id_psg, определить того,
кто совершил наибольшее число полетов, а также тех, кто находится в последовательности непосредственно перед и после него.
Для первого пассажира в последовательности предыдущим будет последний, а для последнего пассажира последующим будет первый.
Для каждого пассажира, отвечающего условию, вывести: имя, имя предыдущего пассажира, имя следующего пассажира.
 */

USE aero;

-- Пронумеровка по полю.
SELECT ID_psg,
       ROW_NUMBER() OVER (ORDER BY ID_psg asc) AS row_number
FROM Pass_in_trip
GO

-- Группировка с числом повторений.
SELECT ID_psg,
       count(*) OVER (PARTITION BY ID_psg) AS count
FROM Pass_in_trip
GO

-- Группировка с числом повторений по каждому ID.
SELECT ID_psg,
       count(*) AS max_count
FROM Pass_in_trip
GROUP BY ID_psg
HAVING count(*) > 1
GO

-- Найти общее количество числа полетов id пассажтров || счет.
SELECT DISTINCT SUM(COUNT(ID_psg)) OVER () count_duplicates
FROM Pass_in_trip
GROUP BY ID_psg
HAVING COUNT(ID_psg) > 1
GO

-- Найти общее количество числа полетов id пассажтров || счет дублткатов c с помощью подзопроса.
-- 29
SELECT SUM(max_count)
FROM (SELECT ID_psg,
             count(*) AS max_count
      FROM Pass_in_trip
      GROUP BY ID_psg
      HAVING count(ID_psg) > 1) _
GO

-- Вывести поле с итогами максимального числа вылетов.
-- 32
select ID_psg,
       count(*)              AS count,
       max(count(*)) OVER () AS max_count
FROM Pass_in_trip
GROUP BY ID_psg
HAVING COUNT(ID_psg) > 1
GO

-- Найти общее количество пассажиров.
SELECT count(*) AS count_one
FROM Pass_in_trip
GO

-- Найти id пассажиров с максимальным чтслом вылетов.
SELECT count(*) AS count_one
FROM Pass_in_trip
         INNER JOIN
     (SELECT ID_psg,
             count(*)              AS count,
             max(count(*)) OVER () AS max_count
      FROM Pass_in_trip
      GROUP BY ID_psg
      HAVING COUNT(ID_psg) > 1 / 2) temp
     ON temp.count = temp.max_count
GO

-- Определить того, кто совершил наибольшее число полетов,
-- а также тех, кто находится в последовательности непосредственно перед и после него среди уже найденных.
WITH cte AS (SELECT ID_psg,
                    count(*)              AS ct,
                    max(count(*)) OVER () AS mct
             FROM Pass_in_trip
             GROUP BY ID_psg),

     ctf AS (SELECT cte.*,
                    Passenger.name
             FROM cte
                      JOIN Passenger on Passenger.ID_psg = cte.ID_psg
             WHERE ct = mct),

     ctg AS (SELECT row_number() OVER
         (ORDER BY ID_psg)           AS rn,
                    count(*) OVER () AS cr,
                    ID_psg,
                    name
             FROM Passenger)

SELECT ctg.name,
       LAG(ctg.name) OVER (ORDER BY ctg.name)  AS prev,
       LEAD(ctg.name) OVER (ORDER BY ctg.name) AS next

FROM ctf
         JOIN ctg ON ctg.ID_psg = ctf.ID_psg
GO
+-----------------+--------------------------+-------------------+
|      psg        |         prev             |        next       |
+-----------------+--------------------------+-------------------+
|  Michael Caine  |  NULL                    |  Mullah Omar      |
|  Mullah Omar    |  Michael Caine           |  NULL             |
+-----------------+--------------------------+-------------------+

-- Определить того, кто совершил наибольшее число полетов,
-- а также тех, кто находится в последовательности непосредственно перед и после него среди общего списка пассажиров.
WITH cte AS (SELECT ID_psg,
                    count(*)              AS ct,
                    max(count(*)) OVER () AS mct
             FROM Pass_in_trip
             GROUP BY ID_psg),

     ctf AS (SELECT cte.*,
                    Passenger.name
             FROM cte
                      JOIN Passenger on Passenger.ID_psg = cte.ID_psg
             WHERE ct = mct),

     ctg AS (SELECT row_number() OVER (order by ID_psg) AS rn,
                    count(*) OVER ()                    AS cr,
                    ID_psg,
                    name
             FROM Passenger)

SELECT ctf.name AS psg,
       CASE
           WHEN ctg.rn = 1
               THEN (SELECT name FROM ctg ga WHERE ga.rn = ctg.cr)
           ELSE (SELECT name FROM ctg ga WHERE ga.rn = ctg.rn - 1)
           END  AS prev,
       CASE
           WHEN ctg.rn = ctg.cr
               THEN (SELECT name FROM ctg ga WHERE ga.rn = 1)
           ELSE (SELECT name FROM ctg ga WHERE ga.rn = ctg.rn + 1)
       END  AS next
FROM ctf
         JOIN ctg ON ctg.ID_psg = ctf.ID_psg
GO
+-----------------+--------------------------+-------------------+
|      psg        |         prev             |        next       |
+-----------------+--------------------------+-------------------+
|  Michael Caine  | Steve Martin             |  Angelina Jolie   |
|  Mullah Omar    | Bruce WillisGuadalcanal  |  Bruce Willis     |
+-----------------+--------------------------+-------------------+
