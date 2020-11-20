/*
ROLLUP – оператор, который формирует промежуточные итоги для каждого указанного элемента и общий итог.
GROUPING SETS – оператор, который формирует результаты нескольких группировок в один набор данных,
GROUPING SETS эквивалентен конструкции UNION ALL к указанным группам.
CUBE используется в комбинации с предложением GROUP BY,
CUBE производит результаты посредством генерации всех комбинаций столбцов, указанных в предложении GROUP BY CUBE.
GROUPING_ID для того чтобы выбрать только нужные итоги я строю матрицу, значениями в которой будет ноль или единица.
CASE – оператор позволяет осуществить проверку условий и возвратить результат в зависимости от выполнения того или иного условия.
IIF – логическая функция языка T-SQL, которая возвращает одно из двух значений в зависимости от результата логического выражения.
 */

USE AdventureWorks2014;

SELECT *
FROM Production.Product
GO

-- Выбрать количество товаров в разрезе цветов и классов.
SELECT Color,
       Class,
       Count(*)                  AS Количество_товаров,
       AVG(nullif(ListPrice, 0)) AS Средняя_цена
FROM Production.Product
GROUP BY Color, Class
GO

-- Выбрать количество товаров в разрезе цветов и классов с итогоми по цвету и общим итогом
SELECT Color,
       Class,
       Count(*)                  AS Количество_товаров,
       AVG(nullif(ListPrice, 0)) AS Средняя_цена
FROM Production.Product
GROUP BY ROLLUP (Color, Class)
GO

-- Выбрать количество товаров в разрезе цветов и классов с итогами по цвету и общим итогом
-- Значения NULL, возвращаетые запросом с ROLLUP, будут означать итоговые значения
SELECT Color,
       Class,
       Count(*)                  AS Количество_товаров,
       AVG(nullif(ListPrice, 0)) AS Средняя_цена
FROM Production.Product
WHERE Color IS NOT NULL
  AND Class IS NOT NULL
GROUP BY ROLLUP (Color, Class)
GO

-- Выбрать количество товаров в разрезе цветов и классов с итогами по цвету и общим итогом
-- 1 в поле означает подведение итога по группе товаров
SELECT Color,
       Class,
       Count(*)                  AS Количество_товаров,
       AVG(nullif(ListPrice, 0)) AS Средняя_цена,
       GROUPING(Color)           AS Итого_поле_цвет,
       GROUPING(Class)           AS Итого_поле_класс
FROM Production.Product
GROUP BY ROLLUP (Color, Class)
GO

-- Использование GROUPING
SELECT (IIF(GROUPING(Color) = 1, N'Итого', Color)) AS Color,
       (IIF(GROUPING(Class) = 1, N'Итого', Class)) AS Class,
       Count(*)                                    AS Количество_товаров,
       AVG(nullif(ListPrice, 0))                   AS Средняя_цена
FROM Production.Product
GROUP BY ROLLUP (Color, Class)
GO

-- Использование CUBE для подведения итогов всех видов товаров
SELECT (IIF(GROUPING(Color) = 1, N'Итого', Color)) AS Color,
       (IIF(GROUPING(Class) = 1, N'Итого', Class)) AS Class,
       Count(*)                                    AS Количество_товаров,
       AVG(nullif(ListPrice, 0))                   AS Средняя_цена
FROM Production.Product
GROUP BY CUBE (Color, Class)
GO

-- Использование CUBE для подведения итогов количества товаров
SELECT (IIF(GROUPING_ID(Color, Class) = 1, N'Итого', Color)) AS Color,
       (IIF(GROUPING(Class) = 1, N'Итого', Class))           AS Class,
       Count(*)                                              AS Количество_товаров,
       AVG(nullif(ListPrice, 0))                             AS Средняя_цена,
       GROUPING_ID(Color, Class)                             AS GROUPING_ID
FROM Production.Product
GROUP BY CUBE (Color, Class)
GO

-- Использование CASE для подведения итогов количества товаров
SELECT CASE
           WHEN GROUPING_ID(Color, Class) = 0 THEN Color
           WHEN GROUPING_ID(Color, Class) = 1 THEN Color
           WHEN GROUPING_ID(Color, Class) = 2 THEN N'Итого класс: ' + COALESCE(Class, N'Null')
           WHEN GROUPING_ID(Color, Class) = 3 THEN N'Общий итог:'
           ELSE N'Неизвестно'
           END                   AS N'Color',
       CASE
           WHEN GROUPING_ID(Color, Class) = 0 THEN Class
           WHEN GROUPING_ID(Color, Class) = 1 THEN N'Итого цвет: ' + COALESCE(Color, N'Null')
           WHEN GROUPING_ID(Color, Class) = 2 THEN Class
           WHEN GROUPING_ID(Color, Class) = 3 THEN N'Общий итог:'
           ELSE N'Неизвестно'
        END                      AS N'Class',
       Count(*)                  AS Количество_товаров,
       GROUPING_ID(Color, Class) AS GROUPING_ID
FROM Production.Product
GROUP BY CUBE (Color, Class)
ORDER BY Color, GROUPING_ID(Color, Class)
GO

-- Использование IIF для подведения итогов количества товаров
SELECT IIF((GROUPING_ID(Color, Class) & 2) = 2, N'Итого', Color) AS Color,
       IIF((GROUPING_ID(Color, Class) & 1) = 1, N'Итого', Class) AS Class,
       Count(*)                                                  AS Количество_товаров
       -- GROUPING_ID(Color, Class)                              AS GROUPING_ID
FROM Production.Product
GROUP BY CUBE (Color, Class)
ORDER BY Color, GROUPING_ID(Color, Class)
GO

-- Выбрать количество товаров с итогами
-- 1 в поле означает подведение итога по группе товаров
-- 0 в поле означает поле группировки
SELECT Color,
       Class,
       Style,
       Count(*)        AS Количество_товаров,
       GROUPING(Color) AS Итого_поле_цвет,
       GROUPING(Class) AS Итого_поле_класс,
       GROUPING(Style) AS Итого_поле_стиль
FROM Production.Product
GROUP BY GROUPING SETS ((Color), (Class), (Style))
GO

-- Выбрать количество товаров с итогами
-- 1 в поле означает подведение итога по группе товаров
-- 0 в поле означает поле группировки
-- () - подведение общтх итогов
SELECT Color,
       Class,
       Style,
       Count(*)        AS Количество_товаров,
       GROUPING(Color) AS Итого_поле_цвет,
       GROUPING(Class) AS Итого_поле_класс,
       GROUPING(Style) AS Итого_поле_стиль
FROM Production.Product
GROUP BY GROUPING SETS ((Color, Class, Style), ())
GO

-- Выбрать количество товаров с итогами по каждоиу цвету и по паре класс цвет
-- 1 в поле означает подведение итога по группе товаров
-- 0 в поле означает поле группировки
-- () - подведение общтх итогов
SELECT Color,
       Class,
       Style,
       COUNT(*)        AS Количество_товаров,
       GROUPING(Color) AS Итого_поле_цвет,
       GROUPING(Class) AS Итого_поле_класс,
       GROUPING(Style) AS Итого_поле_стиль
FROM Production.Product
GROUP BY GROUPING SETS ((Color), (Class, Style))
GO

-- Максимально иформативный запрос
SELECT IIF(GROUPING_ID(Color) = 0, Color, N'Итого') AS Color,
       IIF(GROUPING_ID(Class) = 0, Class, N'Итого') AS Class,
       IIF(GROUPING_ID(Style) = 0, Style, N'Итого') AS Style,
       Count(*)                                     AS Количество_товаров
FROM Production.Product
GROUP BY GROUPING SETS ((Color), (Class, Style), ())
GO

-- Предложение GROUP BY имеет синтаксис, совместимый с ISO, и синтаксис, не соответствующий стандарту ISO.
-- В одном операторе SELECT можно использовать только один стиль синтаксиса.
-- Для всех новых работ используйте синтаксис, совместимый с ISO.
-- Синтаксис, не соответствующий ISO, предоставляется для обратной совместимости.

SELECT ProductLine,
       Class,
       COUNT(*)       AS Количество,
       MAX(ListPrice) AS Максимальная_цена
FROM Production.Product
GROUP BY ProductLine, Class
GO
-- 17

SELECT ProductLine,
       Class,
       COUNT(*)       AS Количество,
       MAX(ListPrice) AS Максимальная_цена
FROM Production.Product
WHERE ProductLine IS NOT NULL
  AND Class IS NOT NULL
GROUP BY ALL ProductLine, Class
GO
-- 17

SELECT ProductLine,
       Class,
       COUNT(*)       AS Количество,
       MAX(ListPrice) AS Максимальная_цена
FROM Production.Product
WHERE ProductLine IS NOT NULL
  AND Class IS NOT NULL
GROUP BY ProductLine, Class
GO
-- 9

-- Запрос, не соответствующий стандарту ISO
SELECT ProductLine,
       Class,
       COUNT(*)       AS Количество,
       MAX(ListPrice) AS Максимальная_цена
FROM Production.Product
WHERE ProductLine IS NOT NULL
  AND Class IS NOT NULL
GROUP BY ProductLine, Class
WITH CUBE
GO
-- ORDER BY ProductLine DESC, Class DESC
-- 16

-- Запрос, не соответствующий стандарту ISO
SELECT ProductLine,
       Class,
       COUNT(*)       AS Количество,
       MAX(ListPrice) AS Максимальная_цена
FROM Production.Product
WHERE ProductLine IS NOT NULL
  AND Class IS NOT NULL
GROUP BY CUBE (ProductLine, Class)
GO
-- 16
