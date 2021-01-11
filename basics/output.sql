USE test;

TRUNCATE TABLE Audit;

CREATE TABLE Audit
(
    [Command] VARCHAR(50),
    [Name]    VARCHAR(50),
    [Price]   VARCHAR(50),
    [User]    VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
    [Date]    DATETIMEOFFSET       DEFAULT SYSDATETIMEOFFSET()
)
GO

-- Заполнение таблицы и добавление данных о вставке в таблицу.
INSERT INTO Audit
OUTPUT 'Insert',
    inserted.Command,
    inserted.Name
    INTO Audit (Command, Name, Price)
DEFAULT
VALUES
GO
+---------+------+--------+-----------------+------------------------+
| Command | Name | Price  |       User      |        Date            |
+---------+------+--------+-----------------+------------------------+
|   NULL  | NULL |  NULL  | SHVED-PC\\Shved | 2020-12-29 20:21:34.6  |
|  Insert | NULL |  NULL  | SHVED-PC\\Shved | 2020-12-29 20:21:34.6  |
+---------+------+--------+-----------------+------------------------+

-- Заполнение таблицы Orders и добавление данных о вставке в таблицу Audit.
INSERT INTO Orders(ID_order, ID_client, Sum, OrderDate)
OUTPUT 'Insert',
    inserted.Sum,
    inserted.OrderDate
    INTO Audit (Command, Price, Date)
OUTPUT 'Insert', inserted.*
VALUES ( 6, 23, 220.0000, '2016-12-31')
GO
+-------------+----------+------------+---------------+--------------------+
| <anonymous> | ID_order | ID_client  |      Sum      |     OrderDate      |
+-------------+----------+------------+---------------+--------------------+
|   Insert    |    6     |      23    |   220.0000    |     2016-12-31     |
+-------------+----------+------------+---------------+--------------------+

-- Audit:
+---------+------+--------+-----------------+-----------------------+
| Command | Name | Price  |       User      |        Date           |
+---------+------+--------+-----------------+-----------------------+
|   NULL  | NULL |  NULL  | SHVED-PC\\Shved | 2020-12-29 20:21:34.6 |
|  Insert | NULL |  NULL  | SHVED-PC\\Shved | 2020-12-29 20:21:34.6 |
|  Insert | NULL | 220.00 | SHVED-PC\\Shved | 2020-12-29 20:21:34.6 |
+---------+------+--------+-----------------+-----------------------+

-- Orders:
+-----------+------------+------------+--------------------+
|  ID_order | ID_client  |    Sum     |     OrderDate      |
+-----------+------------+------------+--------------------+
|     6     |     23     |  220.0000  |    2016-12-31      |
+-----------+------------+------------+--------------------+

-- Создание имя входа Yuriy.
CREATE LOGIN Yuriy
WITH PASSWORD = '12345'

ALTER ROLE db_datareader ADD MEMBER Yuriy
ALTER ROLE db_datawriter ADD MEMBER Yuriy
GO
