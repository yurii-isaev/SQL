/*
Аналитические оконные функции, или функции распределения (distribution function),
предоставляют информацию о распределении данных и используются в основном для статистического анализа.
Оконные функции LAG и LEAD возвращают значение выражения,
вычисленного для предыдущей строки (LAG) или следующей строки (LEAD) результирующего набора соответственно.

Синтаксис:
LAG (scalar_expression [, offset] [, default]) OVER ([partition_by_clause] order_by_clause)
LEAD (scalar_expression [, offset], [default]) OVER ([partition_by_clause] order_by_clause)
FIRST_VALUE (скалярное выражение) OVER ([partition_by_clause] order_by_clause [rows_range_clause])
LAST_VALUE (скалярное выражение) OVER ([partition_by_clause] order_by_clause [rows_range_clause])
PERCENT_RANK () OVER ([partition_by_clause] order_by_clause)
CUME_DIST () OVER ([partition_by_clause] order_by_clause)
PERCENTILE_DISC (numeric_literal) WITHIN GROUP (ORDER BY order_by_expression [ASC | DESC]) OVER ([<partition_by_clause>])
PERCENTILE_CONT (numeric_literal) WITHIN GROUP (ORDER BY order_by_expression [ASC | DESC]) OVER ([<partition_by_clause>])

Примеры:
Из таблицы Person and PersonType равного SP вывести 3 столба:
ФИО (LastName, MiddleName, FirstName),
ФИО предыдущего в списке,
ФИО последубщего в списке,
Для первой строки в поле Предыдущий вывести фразу "Первый!!" и указать ФИО последнего человека.
Для последней строки в поле Последующей вывести фразу "Последний!!" и указать ФИО первого человека.
 */

USE AdventureWorks2014;

-- 1 способ;
WITH T1 (ФИО) AS
    (SELECT LastName + ISNULL('' + MiddleName, '') + '' + FirstName
     FROM Person.Person
     WHERE PersonType = 'SP')
SELECT ФИО,
       LAG(ФИО) OVER (ORDER BY ФИО)  AS Предыдущий,
       LEAD(ФИО) OVER (ORDER BY ФИО) AS Cледующий
FROM T1;
GO

-- 2 способ;
WITH T1 (ФИО) AS
    (SELECT LastName + ISNULL('' + MiddleName, '') + '' + FirstName
     FROM Person.Person
     WHERE PersonType = 'SP')
SELECT ФИО,
       COALESCE(LAG(ФИО) OVER (ORDER BY ФИО), N'Перый -> ' + LAST_VALUE(ФИО)
           OVER (ORDER BY ФИО ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))                AS Предыдущий,
       COALESCE(LEAD(ФИО) OVER (ORDER BY ФИО), N'Последний -> ' + FIRST_VALUE(ФИО) OVER (ORDER BY ФИО)) AS Cледующий
FROM T1;
GO
