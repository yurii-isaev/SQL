/*
Задача №26.
Найдите средний размер диска ПК
каждого из тех производителей, которые выпускают и принтеры.
Вывести: maker, средний размер HD.
 */

USE computer;

-- 1 способ с помощью DISTINCT
-- DISTINCT позволяет выбирать только уникальные значения из базы данных.
-- В выборке используем агрегатную функцию.
-- Мы выводим не все значения, а только одно среднее по каждому производителю
-- поэтому в конце запроса нам нужно использовать group by по тому полю которое не агрегатное.
SELECT maker, AVG(hd) AS avg_hd
FROM PC JOIN Product
    ON PC.model = Product.model
WHERE maker IN
      (SELECT DISTINCT maker FROM Product WHERE type = 'Printer')
GROUP BY maker
GO

-- 2 способ с помощью INTERSECT
-- INTERSECT (пересечение) – это оператор Transact-SQL, который выводит одинаковые строки из первого,
-- второго и последующих наборов данных.
SELECT maker, AVG(hd) AS avg_hd
 FROM PC JOIN Product
    ON PC.model = Product.model
        WHERE maker IN
              (SELECT maker FROM Product WHERE type = 'PC'
INTERSECT
    SELECT maker FROM Product WHERE type = 'Printer')
GROUP BY maker
GO

-- 3 способ с помощью постфильтра having.
SELECT maker, AVG(hd) AS avg_hd
FROM PC JOIN Product P
    ON PC.model = P.model
GROUP BY P.maker
HAVING P.maker IN
       (SELECT DISTINCT P.maker FROM Product P WHERE P.type = 'Printer')
GO

-- 4 способ с помощью INNER JOIN.
SELECT maker, AVG(hd) AS avg_hd
FROM PC
    INNER JOIN Product P ON pc.model = P.model
WHERE maker IN
      (SELECT maker FROM product P
          INNER JOIN printer PR ON P.model = PR.model)
GROUP BY maker
GO
+----------+-----------+
|   maker  |   avg_hd  |
+----------+-----------+
|     A    |   14.75   |
|     E    |     10    |
+----------+-----------+
