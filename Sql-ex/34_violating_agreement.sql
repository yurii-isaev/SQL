/*
Задача 34.
По Вашингтонскому международному договору от начала 1922 г.
запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн.
Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду).
Вывести названия кораблей.
 */

USE ships;

-- 1 способ с помощью JOIN.
SELECT name
FROM Classes
    JOIN Ships
        ON Ships.class = Classes.class
WHERE launched >= 1922
  AND displacement > 35000
  AND type = 'bb'
GO

-- 2 способ без JOIN.
SELECT name
FROM ships, classes
WHERE ships.class = classes.class
  AND launched >= 1922
  AND displacement > 35000
  AND type = 'bb'
GO
+------------------+
|      name        |
+------------------+
|  Iowa            |
|  Missouri        |
|  Musashi         |
|  New Jersey      |
|  North Carolina  |
|  South Dakota    |
|  Washington      |
|  Wisconsin       |
|  Yamato          |
+------------------+
