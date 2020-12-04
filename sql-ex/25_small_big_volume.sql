/*
Задача №25.
Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM
и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM.
Вывести: Maker.
 */

USE computer;

-- 1 способ.
SELECT DISTINCT maker
FROM Product
    JOIN PC ON Product.model = PC.model
WHERE maker IN
      (SELECT DISTINCT maker FROM Product WHERE type = 'Printer')
  AND ram = (SELECT min(ram) FROM PC)
  AND speed = (SELECT max(speed) FROM PC WHERE ram = (SELECT min(ram) FROM PC))
GO

-- 2 способ.
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer'
  AND maker
    IN (SELECT maker
        FROM Product
            JOIN PC ON Product.model = PC.model
        WHERE ram = (SELECT min(ram) FROM PC)
          AND speed = (SELECT max(speed) FROM PC WHERE ram = (SELECT min(ram) FROM PC)))
GO
+----------+
|   maker  |
+----------+
|    A     |
|    E     |
+----------+
