/*
Задача 43.
Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
 */

USE ships

SELECT DISTINCT name
FROM Battles
WHERE year(date) NOT IN
      (SELECT launched FROM Ships WHERE launched IS NOT NULL)
GO
+-------------+
|  name       |
+-------------+
|  #Cuba62a   |
|  #Cuba62b   |
+-------------+
