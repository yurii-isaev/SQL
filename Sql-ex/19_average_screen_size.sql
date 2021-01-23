/*
Задача 19.
Для каждого производителя найдите средний размер экрана выпускаемых им ПК-блокнотов.
Вывести: maker, средний размер экрана.
 */

USE сomputer;

SELECT maker, AVG(screen) screen
FROM product JOIN laptop ON product.model = laptop.model
GROUP BY maker
GO
+---------+------------+
|  maker  |   screen   |
+---------+------------+
|    A    |     13     |
|    B    |     14     |
|    C    |     12     |
+---------+------------+
