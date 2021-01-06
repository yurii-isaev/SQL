/*
Задача 153.
Найти пассажира, который совершил перелет на том же месте,
на котором и обратный перелет на следующем по времени рейсу.
 */

USE aero;

-- Создаем порядковую нумерацию с помощью обобщенного табличного выражения.
WITH cte AS
    (SELECT p.id_psg,
            p.name,
            pit.trip_no,
            pit.date,
            pit.place,
            row_number() OVER (PARTITION BY p.id_psg ORDER BY pit.date, t.time_out) num
     FROM passenger p
         JOIN pass_in_trip pit ON pit.id_psg = p.id_psg
         JOIN trip t ON t.trip_no = pit.trip_no)
SELECT t1.name
FROM cte t1
    JOIN cte t2 ON t1.id_psg = t2.id_psg
    AND t1.place = t2.place
    AND t1.num = t2.num + 1
GROUP BY t1.id_psg, t1.name
GO
+-------------------+
|       name        |
+-------------------+
|   Nikole Kidman   |
+-------------------+
