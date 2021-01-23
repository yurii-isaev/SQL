/*
Задача 20.
Найдите производителей, выпускающих по меньшей мере три различных модели ПК.
Вывести: Maker, число моделей.
 */

USE сomputer;

SELECT maker, COUNT(model) model
FROM product
WHERE type = 'pc'
GROUP BY maker
HAVING COUNT(model) >= 3
GO
+---------+------------+
|  maker  |   model    |
+---------+------------+
|    E    |      3     |
+---------+------------+
