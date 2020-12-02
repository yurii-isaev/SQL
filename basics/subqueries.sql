/*
Вложенным запросом (подзапросом) называется запрос,содержащийся в предложении WHERE или HAVING другого оператора SQL.
Данный запрос обычно используется для получения данных из двух и более таблиц, а также для возвращения данных,
которые будут использоваться в основном запросе, как условие для ограничения получаемых данных.
 */

USE AdventureWorks2014;

--Из таблицы товаров выбрать все товары, стоимость которых совпадает
-- с минимальной ненулевой стоимостью товаров красного цвета.
-- 1. Напишем запрос, который возвращает минимальную ненулевую стоимость товаров красного цвета.
SELECT MIN(ListPrice)
FROM Production.Product
WHERE ListPrice > 0
  AND Color = 'Red'
-- 2. Напишем запрос, который возвращает все товары стоимостью результата первого запроса.
SELECT *
FROM Production.Product
WHERE ListPrice =
      (SELECT MIN(ListPrice)
       FROM Production.Product
       WHERE ListPrice > 0
         AND Color = 'Red')
GO
--4

-- Из таблицы  ProductVendor выбрать все товары, которые поставлялись поставщиками с кредитным рейтингом 4 и 5.
SELECT *
FROM Purchasing.ProductVendor
WHERE BusinessEntityID IN
      (SELECT BusinessEntityID
       FROM Purchasing.Vendor
       WHERE CreditRating IN (4, 5))
GO
--7


-- Коррелтрованные (связанные) подзапросы - подзапросы, в которых внутренний запрос имеет ссылку
-- на столбец таблицы во внешнем запросу.

-- Для каждого продавца таблицы Vendor вывести его код, название, максимальную и минимальную цену
-- последней поставки из связанной таблицы ProductVendor.
SELECT V.BusinessEntityID,
       V.Name,
       (SELECT MIN(PV.LastReceiptCost)
        FROM Purchasing.ProductVendor AS PV
        WHERE PV.BusinessEntityID = V.BusinessEntityID) AS Min_price,
    (SELECT MAX(PV.LastReceiptCost)
     FROM Purchasing.ProductVendor AS PV
     WHERE PV.BusinessEntityID = V.BusinessEntityID) AS Max_price
FROM Purchasing.Vendor AS V
GO
--104

-- Аналогичный запрос с помощью JOIN.
SELECT V.BusinessEntityID,
       V.Name,
       MIN(PV.LastReceiptCost) AS Min_price,
       MAX(PV.LastReceiptCost) AS Max_price
FROM Purchasing.Vendor AS V
    LEFT OUTER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID
GROUP BY V.BusinessEntityID, V.Name
GO
--104

-- Из таблицы Product нужно возвратить товары,
-- имеющие минимальную ненулевую цену за единицу товара в каждом классе товаров.
SELECT P.ProductID, P.Name, P.Class, P.ListPrice
FROM Production.Product AS P
WHERE P.ListPrice IN
      (SELECT MIN(P2.ListPrice)
       FROM Production.Product AS P2
       WHERE (P2.Class = P.Class OR (P2.Class IS NULL AND P.Class IS NULL))
         AND P2.ListPrice > 0)
GROUP BY P.ProductID, P.Name, P.Class, P.ListPrice
GO
--104

-- Из таблицы Product нужно возвратить товары,
-- имеющие максимальную ненулевую цену за единицу товара в каждом классе товаров c порядковой сортировкой классов.
SELECT P.ProductID, P.Name, P.Class, P.ListPrice
FROM Production.Product AS P
WHERE P.ListPrice IN
      (SELECT MAX(P2.ListPrice)
       FROM Production.Product AS P2
       WHERE (P2.Class = P.Class OR (P2.Class IS NULL AND P.Class IS NULL))
         AND P2.ListPrice > 0)
GROUP BY P.ProductID, P.Name, P.Class, P.ListPrice
ORDER BY
    CASE P.Class
        WHEN 'H' THEN 1
        WHEN 'M' THEN 2
        WHEN 'L' THEN 3
        ELSE 4
    END
GO
--104

-- Какие способы доставки использовались в заказах 01.10.2011?
-- Используем предикат Exists, который принимает подзапрос на вход и возвращает значение true,
-- когда подзапрос возвращает хотя бы одну строку, в противном случае - false.
SELECT *
FROM Purchasing.ShipMethod AS SM
WHERE EXISTS
    (SELECT *
     FROM Sales.SalesOrderHeader AS SOH
     WHERE SOH.ShipMethodID = SM.ShipMethodID
       AND (SOH.OrderDate >= '20111001' OR SOH.OrderDate < '20111001'))
GO
--2

-- Аналогичный запрос с помощью предиката ANY.
SELECT *
FROM Purchasing.ShipMethod AS SM
WHERE SM.ShipMethodID = ANY
(SELECT SOH.ShipMethodID
 FROM Sales.SalesOrderHeader AS SOH
 WHERE SOH.ShipMethodID = SM.ShipMethodID
   AND (SOH.OrderDate >= '20111001' OR SOH.OrderDate < '20111001'))
GO
--2

-- Аналогичный запрос с помощью соединения JOIN.
SELECT DISTINCT SM.*
FROM Purchasing.ShipMethod AS SM
    LEFT JOIN Sales.SalesOrderHeader AS SOH
        ON SOH.ShipMethodID = SM.ShipMethodID
WHERE SOH.OrderDate >= '20111001'
   OR SOH.OrderDate < '20111001'
GO
--2