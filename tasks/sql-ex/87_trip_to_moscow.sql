/*
Задача 87.
Считая, что пункт самого первого вылета пассажира является местом жительства,
найти не москвичей, которые прилетали в Москву более одного раза.
Вывод: имя пассажира, количество полетов в Москву
 */

USE aero;

SELECT P.name,
       COUNT(town_to) AS trip_quentity
FROM Passenger P
    JOIN Pass_in_trip I on P.ID_psg = I.ID_psg
    JOIN Trip T on I.trip_no = T.trip_no
WHERE town_to = 'Moscow'
GROUP BY I.ID_psg, P.name
HAVING COUNT(town_to) > 1
GO
+-----------------+------------------+
|       name      |   trip_quentity  |
+-----------------+------------------+
|  Nikole Kidman  |         2        |
+-----------------+------------------+
