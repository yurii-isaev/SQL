/*
UNION – это оператор SQL для объединения результирующего набора данных нескольких запросов,
и данный оператор выводит только уникальные строки в запросах, т.е. например, Вы объединяете два запроса
и в каждом из которых есть одинаковые данные и оператор union объединит их в одну строку для того чтобы не было дублей;
UNION ALL – оператор SQL для объединения результирующего набора данных нескольких запросов,
данный оператор, выведет уже абсолютно все строки, даже дубли.
EXCEPT (разность) — оператор T-SQL, который выводит только те данные из первого набора строк, которых нет во втором наборе.
INTERSECT (пересечение) – оператор T-SQL, который выводит одинаковые строки из первого, второго и последующих наборов данных.
INTERSECT выведет только те строки, которые есть как в первом результирующем наборе, так и во втором (третьем и так далее),
т.е. происходит пересечение этих строк.
  */

CREATE DATABASE test;

USE test;

-- Создание таблиц.
CREATE TABLE Example
(
    colum INT
);
CREATE TABLE New
(
    colum INT
);

-- Заполнение таблиц.
INSERT Example
VALUES (1),(2),(2),(3),(4);
+---------+
| Example |
+---------+
|    1    |
|    2    |
|    2    |
|    3    |
|    4    |
+---------+

INSERT New
VALUES (3),(4),(4),(5),(7);
+----------+
|   New    |
+----------+
|    3     |
|    4     |
|    4     |
|    5     |
|    7     |
+----------+

-- Запрос объединение двух наборов с дублями,
-- Стоимость запроса - 27%.
SELECT colum AS UNION_ALL
FROM Example
UNION ALL
SELECT colum AS B
FROM New
GO
+-----------+
| UNION_ALL |
+-----------+
|     1     |
|     2     |
|     2     |
|     3     |
|     4     |
|     3     |
|     4     |
|     4     |
|     5     |
|     7     |
+-----------+

-- Запрос объединение двух наборов без дублей,
-- Стоимость запроса - 73%
SELECT colum AS 'UNION'
FROM Example
UNION
SELECT colum AS B
FROM New
GO
+----------+
|  UNION   |
+----------+
|    1     |
|    2     |
|    3     |
|    4     |
|    5     |
|    7     |
+----------+

-- Разность наборов (множест) А и В,
-- Проверяет каких чисел нет в таблице В.
SELECT colum AS 'EXCEPT'
FROM Example
EXCEPT
SELECT colum AS B
FROM New
GO
+----------+
| EXCEPT   |
+----------+
|    1     |
|    2     |
+----------+

-- Пересечение (множест) А и В,
-- Находит общие елементы для двух таблтц.
SELECT colum AS 'INTERSECT'
FROM Example
INTERSECT
SELECT colum
FROM New
GO
+------------+
| INTERSECT  |
+------------+
|     4      |
|     3      |
+------------+

-- Переименование таблиц.
EXEC sp_rename Example, Exam;

-- Добавить столбец в тадлицу.
ALTER TABLE dbo.Exam
    ADD colum_new INT
GO

-- Переименование столбца таблицы.
EXEC sp_rename 'dbo.Exam.colum_new', 'column_a', 'COLUMN';

ALTER TABLE dbo.Exam
    ADD column_b VARCHAR(20) NULL, column_c INT NULL

-- Удаление столбца таблицы.
ALTER TABLE dbo.Exam
    DROP COLUMN column_c
GO

-- Удаление таблиц.
DROP TABLE Exam, New;

USE AdventureWorks2014;

-- Разность наборов.
-- Найти какие поставщики из таблицы Vendor не имеют ни одного поставленного товара в таблице .
SELECT BusinessEntityID
FROM Purchasing.Vendor
EXCEPT
SELECT BusinessEntityID
FROM Purchasing.ProductVendor
GO
