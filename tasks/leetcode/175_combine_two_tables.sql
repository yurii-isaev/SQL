-- Задача 175.
-- Напишите запрос SQL, чтобы сообщить имя, фамилию, город и состояние каждого человека в таблице Person.
-- Если адрес personId отсутствует в таблице Address, вместо этого сообщите значение null.
-- Вывести: таблицу результатов в любом порядке.

CREATE DATABASE leetcode;
USE leetcode;

CREATE TABLE Person
(
    personId  int,
    firstName varchar(255),
    lastName  varchar(255)
);

CREATE TABLE Address
(
    addressId int,
    personId  int,
    city      varchar(255),
    state     varchar(255)
);

-- SQL Schema
TRUNCATE TABLE Person;
INSERT INTO Person (personId, lastName, firstName)
VALUES ('1', 'Wang', 'Allen');

INSERT INTO Person (personId, lastName, firstName)
VALUES ('2', 'Alice', 'Bob');

TRUNCATE TABLE Address;
INSERT INTO Address (addressId, personId, city, state)
VALUES ('1', '2', 'New York City', 'New York');

INSERT INTO Address (addressId, personId, city, state)
VALUES ('2', '3', 'Leetcode', 'California');

SELECT * FROM Person;
SELECT * FROM Address;

-- Solution
SELECT FirstName, LastName, City, State
FROM Person LEFT JOIN Address
    ON Person.PersonId = Address.PersonId;

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