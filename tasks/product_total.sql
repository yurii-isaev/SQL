/*
Задача:
Для каждого товара подсчитать общую сумму, на которую он был отправлен в Германию.
 */

USE AdventureWorks2014;

-- Запрос не выводит те товары, которые не поставлялись в Германию.
SELECT P.Name             AS Product,
       SUM(SOD.LineTotal) AS Total
FROM Production.Product AS P
    LEFT JOIN Sales.SalesOrderDetail AS SOD
        ON P.ProductID = SOD.ProductID
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.SalesTerritory AS ST
        ON SOH.TerritoryID = ST.TerritoryID AND ST.Name = 'Germany'
GROUP BY P.Name
ORDER BY P.Name
GO
-- 219

-- Правтльный запрос с использование скобок для управления порядка выполнения запроса.
SELECT P.Name             AS Product,
       SUM(SOD.LineTotal) AS Total,
       ST.Name            AS Country
FROM Production.Product AS P
    LEFT JOIN
    (
        Sales.SalesOrderDetail AS SOD
        INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
        INNER JOIN Sales.SalesTerritory AS ST
        ON SOH.TerritoryID = ST.TerritoryID
        AND ST.Name = 'Germany'
    )
        ON P.ProductID = SOD.ProductID
GROUP BY P.Name, ST.Name
ORDER BY P.Name
GO
-- 504
