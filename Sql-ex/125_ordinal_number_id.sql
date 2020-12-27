/*
Задача 125.
Данные о продаваемых моделях и ценах (из таблиц Laptop, PC и Printer) объединить в одну таблицу LPP
и создать в ней порядковую нумерацию (id) без пропусков и дубликатов.
Считать, что модели внутри каждой из трёх таблиц упорядочены по возрастанию поля code.
Единую нумерацию записей LPP сделать по следующему правилу: сначала идут первые модели из таблиц (Laptop, PC и Printer),
потом последние модели, далее - вторые модели из таблиц, предпоследние и т.д.
При исчерпании моделей определенного типа, нумеровать только оставшиеся модели других типов.
Вывести: id, type, model и price. Тип модели type является строкой 'Laptop', 'PC' или 'Printer'.
 */

USE computer;

-- создать порядковую нумерацию (id) без пропусков и дубликатов с помощью обобщенного табличного выражения;
WITH CTE AS
         (SELECT *
          FROM (SELECT row_number() over (order by code)      ca,
                       row_number() over (order by code desc) cd,
                       count(*) over ()                       cc,
                       'PC' as                                type,
                       model,
                       price
                FROM PC) _
          UNION
          SELECT *
          FROM (SELECT row_number() over (order by code)      ca,
                       row_number() over (order by code desc) cd,
                       count(*) over ()                       cc,
                       'Laptop' as                            type,
                       model,
                       price
                FROM Laptop) _
          UNION
          SELECT *
          FROM (SELECT row_number() over (order by code)      ca,
                       row_number() over (order by code desc) cd,
                       count(*) over ()                       cc,
                       'Printer' as                           type,
                       model,
                       price
                FROM Printer) _)
-- запрос на выборку id, type, model и price из обобщенного табличного выражения.
SELECT row_number() over
    (ORDER BY IIF(ca > ceiling((cc * 1.0) / 2), cd * 2, cc - cd + ca)) id,
    CTE.type,
    CTE.model,
    CTE.price
FROM CTE
ORDER BY id
GO
+------+---------+--------+-----------+
|  id  |  type   |  model |   price   |
+------+---------+--------+-----------+
|   1  | Laptop  |  1298  |  700.0000 |
|   2  | Printer |  1276  |  400.0000 |
|   3  | PC      |  1232  |  600.0000 |
|   4  | Laptop  |  1298  |  950.0000 |
|   5  | Printer |  1288  |  400.0000 |
|   6  | PC      |  1233  |  970.0000 |
|   7  | Laptop  |  1321  |  970.0000 |
|   8  | Printer |  1433  |  270.0000 |
|   9  | PC      |  1121  |  850.0000 |
|  10  | Laptop  |  1752  | 1150.0000 |
|  11  | Printer |  1408  |  270.0000 |
|  12  | PC      |  1233  |  980.0000 |
|  13  | Laptop  |  1750  | 1200.0000 |
|  14  | Printer |  1434  |  290.0000 |
|  15  | PC      |  1233  |  600.0000 |
|  16  | Laptop  |  1298  | 1050.0000 |
|  17  | Printer |  1401  |  150.0000 |
|  18  | PC      |  1260  |  350.0000 |
|  19  | PC      |  1121  |  850.0000 |
|  20  | PC      |  1232  |  350.0000 |
|  21  | PC      |  1121  |  850.0000 |
|  22  | PC      |  1232  |  350.0000 |
|  23  | PC      |  1233  |  950.0000 |
|  24  | PC      |  1232  |  400.0000 |
+------+---------+--------+-----------+
