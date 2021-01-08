/*
Синтаксис оператора ALTER TABLE в SQL:
ALTER TABLE название_таблицы [WITH CHECK | WITH NOCHECK] {
ADD название_столбца тип_данных_столбца [атрибуты_столбца] |
DROP COLUMN название_столбца | ALTER COLUMN название_столбца тип_данных_столбца [NULL|NOT NULL] |
ADD [CONSTRAINT] определение_ограничения | DROP [CONSTRAINT] имя_ограничения }
 */

USE test;

CREATE TABLE New
(
    ID1 int IDENTITY (1,1) NOT NULL
)
GO

-- Добавление столбца в тадлицу с типом IDENTITY.
ALTER TABLE New
    ADD name int
GO

-- Переименование столбца таблицы с использованием хранимой процедуры sp_rename.
EXEC sp_rename 'dbo.Exam.id', 'ID', 'COLUMN';

-- Удаление столбца таблицы.
ALTER TABLE New
    DROP COLUMN id
GO

-- Изменение типа данных столбца.
ALTER TABLE New
    ALTER COLUMN name VARCHAR(50)
GO

-- Добавление данных в таблицу.
INSERT INTO New
VALUES ('Maria'),
       ('Maria'),
       ('Nika')
GO
+------+-----------+
|  id  |   name    |
+------+-----------+
|  1   |   Maria   |
|  3   |   Maria   |
|  3   |   Nika    |
+------+-----------+

-- Удаление строк из таблицы New, после удаления будут выведены строки, которые были удалены в консоль.
DELETE
FROM New
OUTPUT deleted.*
WHERE name > 'Maria'
GO
+------+-----------+
|  id  |   name    |
+------+-----------+
|  3   |   Nika    |
+------+-----------+

-- Вывод данных.
SELECT *
FROM New
GO
+------+-----------+
|  id  |   name    |
+------+-----------+
|  1   |   Maria   |
|  2   |   Maria   |
+------+-----------+

-- Удаление строк из таблицы New.
DELETE New
WHERE Id > 1
GO
+------+-----------+
|  id  |   name    |
+------+-----------+
|  5   |   Maria   |
|  6   |   Maria   |
+------+-----------+

-- Удаление строк из таблицы New без поддержки свойства идентификации, с помошью инструкции TRUNCATE TABLE.
TRUNCATE TABLE New;
+------+-----------+
|  id  |    name   |
+------+-----------+
|      |           |
+------+-----------+
