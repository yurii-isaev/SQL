/*
HAVING condition.
HAVING используется для фильтрации строк по значениям агрегатных функций.
HAVING - условие, применяемое только к агрегированным результатам, чтобы ограничить группы возвращаемых строк.
Только те группы, состояние которых оценивается как true, будут включены в набор результатов.
HAVING было добавлено в SQL, поскольку ключевое слово WHERE не могло использоваться с агрегатными функциями.

Отличие HAVING от WHERE
WHERE — сначала выбираются записи по условию, а затем могут быть сгруппированы, отсортированы и т.д.
HAVING — сначала группируются записи, а затем выбираются по условию,
при этом, в отличие от WHERE, в нём можно использовать значения агрегатных функций.
 */

USE AdventureWorks2014;

SELECT *
FROM Production.Product
GO

-- Выбрать сколько товаров каждого класса начали выпускать по годам.
SELECT YEAR(SellStartDate) AS Год_выпуска,
       Class,
       COUNT(*)            AS Начали_выпускать_товары
FROM Production.Product
WHERE ListPrice > 0
  AND Class IS NOT NULL
GROUP BY YEAR(SellStartDate), Class
ORDER BY Год_выпуска, Начали_выпускать_товары DESC
GO

-- Выбрать сколько товаров каждого класса начали выпускать по годам c условием, товаров в год бвло больше 20.
/*5*/
SELECT YEAR(SellStartDate) AS Год_выпуска,
       Class,
       COUNT(*)            AS Начали_выпускать_товары
/*1*/
FROM Production.Product
/*2*/
WHERE ListPrice > 0
  AND Class IS NOT NULL
/*3*/
GROUP BY YEAR(SellStartDate), Class
/*4*/
HAVING COUNT(*) > 20
/*6*/
ORDER BY Год_выпуска, Начали_выпускать_товары DESC
GO

-- Запрос недопустим в предложении HAVING, поскольку он не содержится ни в агрегатной функции, ни в предложении GROUP BY
-- Допустим в MySQL
SELECT *
FROM Production.Product
HAVING ListPrice > 10
GO

-- HAVING можно использовать в T-SQL без GROUP BY только для неявных группировок
SELECT COUNT(*)                  AS Количество_записей,
       AVG(NULLIF(ListPrice, 0)) AS Средняя_цена
FROM Production.Product
HAVING AVG(NULLIF(ListPrice, 0)) > 10
GO
