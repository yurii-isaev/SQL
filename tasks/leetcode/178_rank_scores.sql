-- Задача 178.
-- Напишите SQL-запрос для ранжирования оценок. Рейтинг должен рассчитываться по следующим правилам:
-- Баллы должны быть ранжированы от самого высокого к самому низкому.
-- Если между двумя счетами есть равная сумма, оба должны иметь одинаковый рейтинг.
-- После ничьей следующий номер рейтинга должен быть следующим последовательным целочисленным значением.
-- Иными словами, между рядами не должно быть дыр.
-- Вывести: таблицу результатов, упорядоченную по убыванию.

USE leetcode;

CREATE TABLE Scores (id int, score DECIMAL(3,2));
TRUNCATE TABLE Scores;
INSERT INTO Scores (id, score) VALUES ('1', '3.5');
INSERT INTO Scores (id, score) VALUES ('2', '3.65');
INSERT INTO Scores (id, score) VALUES ('3', '4.0');
INSERT INTO Scores (id, score) VALUES ('4', '3.85');
INSERT INTO Scores (id, score) VALUES ('5', '4.0');
INSERT INTO Scores (id, score) VALUES ('6', '3.65');

-- Solution using Dense_Rank()
SELECT score,
       dense_rank() OVER (ORDER BY score DESC) AS rank
FROM Scores;


-- Input:
-- Scores table:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+

-- Output:
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+