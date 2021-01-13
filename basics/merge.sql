/*
 Инструкция MERGE выполняет слияние данных из исходной таблицы или табличного выражения и целевой таблицы
 с помещением их в целевую таблицу.

 Общий формат инструкции выглядит так:
 MERGE INTO <target table> AS TGT
 USING <source table> AS SRC
 ON <merge predicate>
 WHEN MATCHED [AND <predicate>]  -- допускается два предложения:
    THEN <action> -- одно с UPDATE и одно с DELETE
 WHEN NOT MATCHED BY TARGET [AND <predicate>]  -- допускается одно предложение:
    THEN INSERT... -- если указано, должно быть действие INSERT
WHEN NOT MATCHED BY SOURCE [AND <predicate>]  -- допускается два предложения:
    THEN <action>; -- одно с UPDATE и одно с DELETE
 */

USE test;

TRUNCATE TABLE Products_new;
TRUNCATE TABLE Price;

CREATE TABLE Products_new
(
    [Code]               INT PRIMARY KEY,
    [Name]               NVARCHAR(50) NOT NULL,
    [Price]              MONEY        NOT NULL,
    [Status]             NVARCHAR(20) NOT NULL, -- выпускается и выпуск приостановлен
    [Data_change_status] DATE
)
GO

CREATE TABLE Price
(
    [Code]   INT PRIMARY KEY,
    [Name]   NVARCHAR(50) NOT NULL,
    [Price]  MONEY        NOT NULL,
    [Status] NVARCHAR(20) NOT NULL, -- выпускается и выпуск приостановлен
)
GO

INSERT INTO Products_new (Code, Name, Price, Status, Data_change_status)
OUTPUT inserted.*
VALUES (1, 'Horns', 25, 'Produced by', '20150115'),
       (2, 'Hooves', 17, 'Produced by', '20160309'),
       (3, 'Tails', 10, 'Release completed', '20160203'),
       (4, 'Skins', 22, 'Produced by', '20130517'),
       (5, 'Awl', 5, 'Release completed', '20141228'),
       (6, 'Soap', 6, 'Produced by', '20100701'),
       (7, 'Bread crumbs', 11, 'Release completed', '20160701')
GO

INSERT INTO Price (Code, Name, Price, Status)
OUTPUT inserted.*
VALUES (1, 'Horns', 30, 'Produced by'),
       (2, 'Hooves', 15, 'Produced by'),
       (4, 'Skins', 22, 'Release completed'),
       (7, 'Bread crumbs', 13, 'Produced by'),
       (10, 'Soap bubbles', 9, 'Produced by')
GO

-- удаляем товары, выпуск которых приостановлен (товар 4);
MERGE INTO Products_new AS product
USING Price AS price
ON product.Code = price.Code
WHEN MATCHED AND price.Status = 'Release completed'
    THEN DELETE
    -- обновляем те товары, у которых статус 'Produced by'
-- и у которых изменилось хотя бы одно поле в таблице price (товар 1, 2, 7);
WHEN MATCHED AND (price.Status = 'Produced by' AND product.Name <> price.Name
    OR product.Price <> price.Price
    OR product.Status <> price.Status)
    THEN
    UPDATE
    SET product.Name               = price.Name,
        product.Price              = price.Price,
        product.Status             = price.Status,
        product.Data_change_status = IIF(product.Status = 'Release completed', GETDATE(), product.Data_change_status)
    -- добавляем новый товар и ставим ему текущую дату (товар 10);
WHEN NOT MATCHED BY TARGET AND price.Status = 'Produced by'
    THEN
    INSERT (Code, Name, Price, Status, Data_change_status)
    VALUES (Price.Code, Price.Name, Price.Price, Price.Status, GETDATE())
-- меняем статус у товара, который первый раз отсутствует в прайсе (товар 10) и ставим ему текущую дату;
WHEN NOT MATCHED BY SOURCE AND product.Status = 'Produced by'
    THEN
    UPDATE
    SET product.Status             = 'Release completed',
        product.Data_change_status = GETDATE()
-- удаляем товары, который отсутствует в прайсе и выпуск которых приостановлен, более 365 дней тому назад (товар 5).
WHEN NOT MATCHED BY SOURCE
    AND product.Status = 'Release completed'
    AND DATEDIFF(day, product.Data_change_status, GETDATE()) > 365
    THEN DELETE;
GO

-- Вывод текущуй даты в виде таблтцы.
SELECT CAST(GETDATE() AS date) AS Now
