/*
Задача 63.
Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.
 */

USE aero;

SELECT name
FROM Passenger
WHERE ID_psg IN
      (SELECT ID_psg
       FROM Pass_in_trip
       GROUP BY ID_psg, place
       HAVING COUNT(*) > 1)
GO

SELECT name
FROM Pass_in_trip p1
    JOIN Passenger p2 ON p1.ID_psg = p2.ID_psg
GROUP BY p2.ID_psg, name
HAVING COUNT(place) > COUNT(DISTINCT place)
GO
+-----------------+
|      name       |
+-----------------+
|  Bruce Willis   |
|  Nikole Kidman  |
|  Mullah Omar    |
+-----------------+
