/*
GROUP BY - группирует выбранный набор строк для получения набора сводных строк
по значению одного или нескольких столбцов или выражений.
Возвращается одна строка для каждой группы

DISTINCT позволяет выбирать только уникальные значения из базы данных.
Вместо DISTINCT можно использовать DISTINCTROW - в mySQL это одно и то же.

Агрегатные функции — это функции, которые вычисляются от группы значения и объединяют их в одно результирующее значение.
Агрегатные функции выполняют вычисления над значениями в наборе строк.
В T-SQL имеются следующие агрегатные функции:
- AVG: находит среднее значение
- SUM: находит сумму значений
- MIN: находит наименьшее значение
- MAX: находит наибольшее значение
- COUNT: находит количество строк в запросе
 */

USE AdventureWorks2014;

SELECT *
FROM AdventureWorks2014.Production.Product
GO

-- Выбрать все цвета, сгруппированных по цвету.
SELECT Color
FROM Production.Product
GROUP BY Color
GO

-- Выбрать все уникальные цвета.
SELECT DISTINCT Color
FROM Production.Product
GO

-- Выбрать все товары, упорядоченных по цвету.
SELECT Color
FROM Production.Product
ORDER BY Color
GO

-- Выбрать всё количество товаров, путём подсчета строк.
SELECT COUNT(*)
FROM Production.Product
GO

-- Аналогичный запрос.
SELECT COUNT(*)
FROM Production.Product
GROUP BY ()
GO

-- Результат запроса присваивается в переменную с объявлением скалярной переменной.
DECLARE @C INT;
SET @C = (SELECT COUNT(*)
          FROM Production.Product)
GO
-- SELECT @C

-- Подсчитать все товары, все цвета, все классы и стили не равные NULL.
SELECT COUNT(*),
       COUNT(Color) AS Цвета,
       COUNT(Class) AS Классы,
       COUNT(Style) AS Стили
FROM Production.Product
GO

-- Подсчитать все товары, все цвета, все уникальные цвета не равные NULL.
SELECT COUNT(*),
       COUNT(Color)          AS Цвета,
       COUNT(DISTINCT Color) AS Уникальные_цвета
FROM Production.Product
GO

-- Выбрать количество товара каждого цвета.
SELECT Color,
       COUNT(*) AS Количество_товаров
FROM Production.Product
GROUP BY Color
ORDER BY Количество_товаров
GO

-- Выбрать количество товара каждого цвета и стиля.
SELECT Color, Style, COUNT(*) AS Количество_товаров
FROM Production.Product
GROUP BY Color, Style
ORDER BY Color
GO

-- Порядок выполнения запроса:
/*4*/
SELECT Color,
       YEAR(SellStartDate) AS Год_выпуска,
       COUNT(*)            AS Количество_товаров
/*1*/
FROM Production.Product
/*2*/
WHERE YEAR(SellStartDate) IN (2008, 2011)
/*3*/
GROUP BY Color, YEAR(SellStartDate)
/*5*/
ORDER BY Год_выпуска, Color

-- Выбрать количество товара c минимальным, максимальным и среднем значением списка цен.
-- NULLIF(ListPrice, 0) = ListPrice == 0 -> NULL else -> ListPrice.
SELECT MAX(ListPrice)            AS Max,
       MIN(NULLIF(ListPrice, 0)) AS Min,
       AVG(NULLIF(ListPrice, 0)) AS Avg,
       COUNT(*)                  AS Count
FROM Production.Product
GO
-- WHERE ListPrice > 0

-- Выбрать количество товара со стилем и уникальном стиле.
SELECT Color,
       COUNT(Style)          Количество_товаров_со_стилем,
       COUNT(DISTINCT Style) Количество_уникальных_стилей,
       COUNT(*)              Количество_товаров
FROM Production.Product
GROUP BY Color
GO


SELECT *
FROM Sales.SalesOrderDetail
GO

-- Для каждого заказа подсчитать стоимость заказа.
SELECT SalesOrderID, SUM(LineTotal) AS Сумма_заказа
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
GO
