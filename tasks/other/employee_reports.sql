/*
Задача:
Вывести код, ФИО и должность сотрудника, ФИО, должность руководителя из таблицы Employees.
 */

USE northwind;

SELECT *
FROM Employees
GO

-- Самообъединение таблиц.
SELECT Сотрудник.EmployeeID                                 AS Код_сотрудника,
       Сотрудник.FirstName + ' ' + Сотрудник.LastName       AS ФИО_сотрудника,
       Сотрудник.Title                                      AS Должность_сотрудника,
       Сотрудник.ReportsTo                                  AS Код_руководителя,
       Руководитель.FirstName + ' ' + Руководитель.LastName AS ФИО_руководителя,
       Руководитель.Title                                   AS Должность_руководителя
FROM Employees AS Сотрудник
    INNER JOIN Employees AS Руководитель
        ON Сотрудник.ReportsTo = Руководитель.EmployeeID
GO
-- 8
+------------+------------------+----------------------+-------------+-----------------+---------------------+
| Код_сотруд |    ФИО_сотрудн   |   Должность_сотруд   | Код_руковод | ФИО_руководит   | Должность_руководит |
+------------+------------------+----------------------+-------------+-----------------+---------------------+
|     1      | Nancy Davolio    | Sales Representative |      2      | Andrew Fuller   |    Vice President   |
|     3      | Janet Leverling  | Sales Representative |      2      | Andrew Fuller   |    Vice President   |
|     4      | Margaret Peacock | Sales Representative |      2      | Andrew Fuller   |    Vice President   |
|     5      | Steven Buchanan  | Sales Manager        |      2      | Andrew Fuller   |    Vice President   |
|     8      | Laura Callahan   | Sales Coordinator    |      2      | Andrew Fuller   |    Vice President   |
|     6      | Michael Suyama   | Sales Representative |      5      | Steven Buchanan |    Sales Manager    |
|     7      | Robert King      | Sales Representative |      5      | Steven Buchanan |    Sales Manager    |
|     9      | Anne Dodsworth   | Sales Representative |      5      | Steven Buchanan |    Sales Manager    |
+------------+------------------+----------------------+-------------+-----------------+---------------------+

-- Для вывода всех сотрудников левой таблицы необходимо применить LEFT OUTER JOIN.
SELECT Сотрудник.EmployeeID                                 AS Код_сотрудника,
       Сотрудник.FirstName + ' ' + Сотрудник.LastName       AS ФИО_сотрудника,
       Сотрудник.Title                                      AS Должность_сотрудника,
       Сотрудник.ReportsTo                                  AS Код_руководителя,
       Руководитель.FirstName + ' ' + Руководитель.LastName AS ФИО_руководителя,
       Руководитель.Title                                   AS Должность_руководителя
FROM Employees AS Сотрудник
    LEFT JOIN Employees AS Руководитель
        ON Сотрудник.ReportsTo = Руководитель.EmployeeID
GO
-- 9
+------------+------------------+----------------------+-------------+-----------------+---------------------+
| Код_сотруд |    ФИО_сотрудн   |   Должность_сотруд   | Код_руковод | ФИО_руководит   | Должность_руководит |
+------------+------------------+----------------------+-------------+-----------------+---------------------+
|     1      | Nancy Davolio    | Sales Representative |      2      | Andrew Fuller   |    Vice President   |
|     2      | Andrew Fuller    | Vice President       |     NULL    |      NULL       |         NULL        |
|     3      | Janet Leverling  | Sales Representative |      2      | Andrew Fuller   |    Vice President   |
|     4      | Margaret Peacock | Sales Representative |      2      | Andrew Fuller   |    Vice President   |
|     5      | Steven Buchanan  | Sales Manager        |      2      | Andrew Fuller   |    Vice President   |
|     6      | Michael Suyama   | Sales Representative |      5      | Steven Buchanan |    Sales Manager    |
|     7      | Robert King      | Sales Representative |      5      | Steven Buchanan |    Sales Manager    |
|     8      | Laura Callahan   | Sales Coordinator    |      2      | Andrew Fuller   |    Vice President   |
|     9      | Anne Dodsworth   | Sales Representative |      5      | Steven Buchanan |    Sales Manager    |
+------------+------------------+----------------------+-------------+-----------------+---------------------+
