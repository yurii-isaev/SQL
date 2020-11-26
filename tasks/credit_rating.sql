/*
Задача:
Сформировать кредитный рейтинг поставщиков.
Для каждого поставщика вывести его кредитный рейтинг и общее количество видов товаров,
которые он поставил или поставляет и упорядочить по кредитному рейтингу.
 */

USE AdventureWorks2014;

SELECT V.Name,
       V.CreditRating,
       COUNT(PV.ProductID) AS Products
FROM Purchasing.Vendor AS V
    INNER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID -- в поле ON описывается условие соединения
GROUP BY V.Name, V.CreditRating
ORDER BY V.CreditRating DESC
GO
-- 86
+------------------------+--------------+-------------+
|           Name         | CreditRating |   Products  |
+------------------------+--------------+-------------+
| Victory Bikes          |      5       |      4      |
| Proseware, Inc.        |      4       |      3      |
| Consumer Cycles        |      3       |      1      |
| Continental Pro Cycles |      3       |      9      |
+------------------------+--------------+-------------+

-- Если необходтмо отобразить всех поставщтков в том числе которые вообще не поставили товар.
-- то правильным решением будет использовать внешнее соединение таблиц.
SELECT V.Name,
       V.CreditRating,
       COUNT(PV.ProductID) AS Products
FROM Purchasing.Vendor AS V
    LEFT OUTER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID -- в поле ON описывается условие соединения.
GROUP BY V.Name, V.CreditRating
ORDER BY V.CreditRating DESC
GO
-- 104
+------------------------+--------------+-------------+
|           Name         | CreditRating |   Products  |
+------------------------+--------------+-------------+
| Merit Bikes            |       5      |      0      |
| Victory Bikes          |       5      |      4      |
| Proseware, Inc.        |       4      |      3      |
| Recreation Place       |       4      |      0      |
+------------------------+--------------+-------------+

-- Если необходимо поменять таблицы местами,
-- то тогда необходимо сохранять столбцы из таблтцы правой части присоединения.
SELECT V.Name,
       V.CreditRating,
       COUNT(PV.ProductID) AS Products
FROM Purchasing.ProductVendor AS PV
    RIGHT OUTER JOIN Purchasing.Vendor AS V
        ON V.BusinessEntityID = PV.BusinessEntityID -- в поле ON описывается условие соединения.
GROUP BY V.Name, V.CreditRating
ORDER BY V.CreditRating DESC
GO
-- 104
