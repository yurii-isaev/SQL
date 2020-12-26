-- Задача 107.
-- Для пятого по счету пассажира из числа вылетевших из Ростова в апреле 2003 года определить компанию, номер рейса и дату вылета.
-- Замечание. Считать, что два рейса одновременно вылететь из Ростова не могут.

USE aero
GO

-- подсчитываем пятого по счету пассажира из числа вылетевших из Ростова с помощью конструкции OFFSET ... FETCH
SELECT comp.name, pit.trip_no, pit.date
FROM Pass_in_trip pit
    join Trip tr on tr.trip_no = pit.trip_no
    join Company comp on comp.ID_comp = tr.ID_comp
WHERE town_from = 'Rostov'
ORDER BY date,
         time_out offset 4 row fetch next 1 row only
GO

-- подсчитываем пятого по счету пассажира из числа вылетевших из Ростова с помощью обобщенного табличного выражения
-- (SELECT name, trip.trip_no, date, ROW_NUMBER() over (partition by name ORDER BY date) num
WITH CTE AS
         (SELECT ROW_NUMBER() over (ORDER BY date) num,
                 name, trip.trip_no, date
          -- таблицы выборки
          FROM Company comp,
               Pass_in_trip pit,
               Trip trip
          -- параметры соединения таблиц
          WHERE comp.ID_comp = trip.ID_comp
            and trip.trip_no = pit.trip_no
            and town_from = 'Rostov')
-- запрос на выборку компании, номер рейса и даты вылета из обобщенного табличного выражения
SELECT name, trip_no, date
FROM CTE
WHERE num = 5
GO

-- подсчитываем пятого по счету пассажира из числа вылетевших из Ростова с помощью производной таблицы
SELECT name, trip_no, date
FROM (SELECT row_number() over (ORDER BY date + time_out, ID_psg) num,
             name, trip.trip_no, date
      FROM Company comp,
           Pass_in_trip pit,
           Trip trip
      WHERE comp.ID_comp = trip.ID_comp
        and trip.trip_no = pit.trip_no
        and town_from = 'Rostov'
        and year(date) = 2003
        and month(date) = 4) _
WHERE num = 5
GO
+--------------+----------+------------+
|     name     |  trip_no |    date    |
+--------------+----------+------------+
|   Dale_avia  |   1123   | 2003-04-08 |
+--------------+----------+------------+
