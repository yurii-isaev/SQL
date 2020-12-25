/*
Задача 104.
Для каждого класса крейсеров, число орудий которого известно, пронумеровать (последовательно от единицы) все орудия.
Вывод: имя класса, номер орудия в формате 'bc-N'.
 */

USE ships;

-- C помощью обобщенного табличного выражения нумеруем классы кораблей в порядке numguns и фильтра типа.
WITH CTE AS
    (SELECT x.class,
            x.numGuns,
            ROW_NUMBER() over (PARTITION BY x.class ORDER BY x.numguns) n
     FROM Classes x,
          classes y
     WHERE x.type = 'bc')
-- Запрос на выборку класса и нумерации по шаблону из обобщенного табличного выражения.
SELECT DISTINCT class,
                'bc-' + CAST(n AS char(2)) num
FROM CTE
WHERE numguns >= n
GO
+-----------+---------+
|   class   |   num   |
+-----------+---------+
|   Kongo   |  bc-1   |
|   Kongo   |  bc-2   |
|   Kongo   |  bc-3   |
|   Kongo   |  bc-4   |
|   Kongo   |  bc-5   |
|   Kongo   |  bc-6   |
|   Kongo   |  bc-7   |
|   Kongo   |  bc-8   |
|   Renown  |  bc-1   |
|   Renown  |  bc-2   |
|   Renown  |  bc-3   |
|   Renown  |  bc-4   |
|   Renown  |  bc-5   |
|   Renown  |  bc-6   |
+-----------+---------+
