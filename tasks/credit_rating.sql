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

/*
Разница между предложениями ON и WHERE.
В случае внешнего соединения предложения ON и WHERE выполняют разные роли и поэтому не являются взаимозаменяемыми.
Предложения WHERE выполняет роль фильтра - точнее, оно сохраняет строки дающее значение true, и отбрасывает строки,
дающие значение false или unknown.
Однако, предложение ON не является просто фильтром, напротив, его основная задача - сопоставление данных.
Это значит, что строка из сохраненной стороны будет возвращена,
независимо от того, найдет предикат ON совпадение или нет. Таким образом, предикат ON только определяет,
какие строки из несохроненной стороны совпадают со строками в сохраненной таблице,
но не определяет, возвращать эти строки или нет.
По отношению к сохраненной стороне соединения, предложение ON не является конечным;
конечным будет предложение WHERE.
Поэтому при сомнении какой предикат использовать, необходимо ответить на вопрос:
для чего будет использоваться предикат - для фильтрации или сопоставления? Будет ли он конечным или нет?

Для действующих поставщиков (Purchasing.Vendor значение ActiveFlag=1),
вывести его кредитный рейтинг и общее количество товаров, который он поставляет.
  */

SELECT V.Name,
       V.CreditRating,
       V.ActiveFlag,
       COUNT(PV.ProductID) AS Products
FROM Purchasing.Vendor AS V
    LEFT OUTER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID
WHERE V.ActiveFlag = 1
GROUP BY V.Name, V.CreditRating, V.ActiveFlag
GO
-- 100

-- Неправильный запрос с использованием AND без WHERE,
-- т.к. возвращает поставщтков, которые прекратили свою деятельность.
SELECT V.Name,
       V.CreditRating,
       V.ActiveFlag,
       COUNT(PV.ProductID) AS Products
FROM Purchasing.Vendor AS V
    LEFT OUTER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID
               AND V.ActiveFlag = 1
GROUP BY V.Name, V.CreditRating, V.ActiveFlag
GO
-- 104

-- Для поставщиков вывести его кредитный рейтинг
-- и общее количество товаров с последней поставленной ценной более 50.
-- Неправильный запрос. Условие LastReceiptCost > 50 проверяется в предложении WHERE.
SELECT V.Name,
       V.CreditRating,
       COUNT(PV.ProductID) AS Products,
       PV.LastReceiptCost  AS LastReceiptCost
FROM Purchasing.Vendor AS V
    LEFT OUTER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID
WHERE PV.LastReceiptCost > 50
GROUP BY V.Name, V.CreditRating, LastReceiptCost
ORDER BY V.CreditRating DESC
GO
-- 16

-- Правильный запрос. Условие LastReceiptCost > 50 проверяется при соединении таблиц в предложении ON.
SELECT V.Name,
       V.CreditRating,
       COUNT(PV.ProductID) AS Products,
       PV.LastReceiptCost  AS LastReceiptCost
FROM Purchasing.Vendor AS V
    LEFT OUTER JOIN Purchasing.ProductVendor AS PV
        ON V.BusinessEntityID = PV.BusinessEntityID
               AND PV.LastReceiptCost > 50
GROUP BY V.Name, V.CreditRating, LastReceiptCost
ORDER BY V.CreditRating DESC
GO
-- 109
