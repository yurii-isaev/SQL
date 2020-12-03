/*
Производные таблицы (таблицы подзапросов) определяются в предложении FROM внешних запросов,
и область их существования - внешние запросы. После завершения внешнего запроса производная таблица исчезает.
Форма табличного выражения, которая в результате запроса возвращает целую таблтцу.
 */

USE AdventureWorks2014;

-- Из таблицы SalesOrderDetail для каждого заказа вывести две строки с самыми дорогими товарами,
-- указав их цену и название.
SELECT ROW_NUMBER() over
    (PARTITION BY SOD.SalesOrderID --секционирование в пределах одного заказа.
    ORDER BY SOD.UnitPrice DESC, SOD.SalesOrderDetailID) AS Row_number,
    SOD.SalesOrderID,
    P.Name,
    SOD.UnitPrice
FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Production.Product AS P
        ON SOD.ProductID = P.ProductID
GO
-- WHERE ROW_NUMBER() over (PARTITION BY SOD.SalesOrderID ORDER BY SOD.UnitPrice DESC, SOD.SalesOrderDetailID) <= 2

-- Отсортировать запрос по первым двум товарам -> способ 1
SELECT Row_number, SalesOrderID, Name, UnitPrice
FROM (SELECT ROW_NUMBER() over
    (PARTITION BY SOD.SalesOrderID
    ORDER BY SOD.UnitPrice DESC, SOD.SalesOrderDetailID) AS Row_number,
          SOD.SalesOrderID,
          P.Name,
          SOD.UnitPrice
      FROM Sales.SalesOrderDetail AS SOD
          INNER JOIN Production.Product AS P
              ON SOD.ProductID = P.ProductID) AS PRT
WHERE Row_number <= 2
GO
--52674

-- Отсортировать запрос по первым двум строкам -> способ 2
SELECT Row_number, SalesOrderID, Name, UnitPrice
FROM (SELECT ROW_NUMBER() over (PARTITION BY SOD.SalesOrderID
    ORDER BY SOD.UnitPrice DESC, SOD.SalesOrderDetailID) AS Row_number,
             SOD.SalesOrderID,
             P.Name,
             SOD.UnitPrice
      FROM Sales.SalesOrderDetail AS SOD
          INNER JOIN Production.Product AS P ON SOD.ProductID = P.ProductID) AS PRT
    (Row_number, SalesOrderID, Name, UnitPrice)
WHERE Row_number <= 2
GO
--52674
