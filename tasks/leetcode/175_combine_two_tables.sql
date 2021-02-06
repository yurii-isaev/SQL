-- Задача 175.
-- Напишите запрос SQL, чтобы сообщить имя, фамилию, город и состояние каждого человека в таблице Person.
-- Если адрес personId отсутствует в таблице Address, вместо этого сообщите значение null.
-- Вывести: таблицу результатов в любом порядке.

CREATE DATABASE leetcode;
USE leetcode;

-- SQL Schema
IF EXISTS(SELECT *
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_NAME = N'Person')
    BEGIN
        DROP TABLE Person
        PRINT 'Table delete successfully'
    END
ELSE
    BEGIN
        CREATE TABLE Person
        (
            personId  int,
            firstName varchar(255),
            lastName  varchar(255)
        )

        CREATE TABLE Address
        (
            addressId int,
            personId  int,
            city      varchar(255),
            state     varchar(255)
        )

        INSERT INTO Person (personId, lastName, firstName) VALUES (1, 'Wang', 'Allen')
        INSERT INTO Person (personId, lastName, firstName) VALUES (2, 'Alice', 'Bob')

        INSERT INTO Address (addressId, personId, city, state) VALUES (1, 2, 'New York City', 'New York')
        INSERT INTO Address (addressId, personId, city, state) VALUES (2, 3, 'Leetcode', 'California')

        PRINT 'Table create successfully'
    END
GO

-- Solution
SELECT FirstName, LastName, City, State
FROM Person
         LEFT JOIN
     Address ON Person.PersonId = Address.PersonId
GO

-- Input:
-- Person table:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+

-- Address table:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+

-- Output:
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+