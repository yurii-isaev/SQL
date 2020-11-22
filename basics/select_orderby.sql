/*
При выполнении SELECT запроса, строки по умолчанию возвращаются в неопределенном порядке.
ORDER BY применяется для упорядочивания записей.
TOP позволяет извлечь определенное количество строк, начиная с начала таблицы.
OFFSET и FETCH применяется для извлечения набора строк из любого места.
OFFSET и FETCH применяются только в отсортированном наборе данных после выражения ORDER BY.
 */

USE AdventureWorks2014;

SELECT *
FROM Production.Product
GO

-- Выбрать количество товара каждого цвета и стиля в порядке убывания средней цены
SELECT Color, Class, Style, AVG(ListPrice) AS Средняя_цена
FROM Production.Product
WHERE (Color IS NOT NULL)
  AND (Class IS NOT NULL)
  AND (Style IS NOT NULL)
  AND (ListPrice > 0)
GROUP BY Color, Class, Style
HAVING AVG(ListPrice) > 1000
ORDER BY Средняя_цена ASC, Color DESC
GO

-- Аналогичный запрос с использованием номеров столбцов.
SELECT Color, Class, Style, AVG(ListPrice) AS Средняя_цена
FROM Production.Product
WHERE (Color IS NOT NULL)
  AND (Class IS NOT NULL)
  AND (Style IS NOT NULL)
  AND (ListPrice > 0)
GROUP BY Color, Class, Style
HAVING AVG(ListPrice) > 1000
ORDER BY 4 ASC, 1 DESC
GO

-- Выбрать количество товара начиная со 101 строки вернуть 10 строк.
SELECT Name, Color, Class, Style, ListPrice
FROM Production.Product
WHERE ListPrice > 0
  AND Style IS NOT NULL
ORDER BY Name
OFFSET 100 ROWS FETCH NEXT 10 ROWS ONLY
GO

-- Без сортировки конструкция OFFSET ... FETCH не работает.
-- Используем ORDER BY (SELECT null), если хотим тспользовать конструкцию OFFSET ... FETCH без фактической сортировки.
-- ORDER BY - трудоёмкая операция.
SELECT Name, Color, Class, Style, ListPrice
FROM Production.Product
WHERE ListPrice > 0
  AND Style IS NOT NULL
ORDER BY (SELECT null)
OFFSET 100 ROWS FETCH NEXT 10 ROWS ONLY
GO

-- Использование переменных для задания границ в конструкции OFFSET ... FETCH.
DECLARE
    @RowsOffSet AS INT = 100,
    @RowsFetch AS INT = 10
SELECT *
FROM Production.Product
ORDER BY ProductID
OFFSET @RowsOffSet ROWS FETCH NEXT @RowsFetch ROWS ONLY
GO
