-- Задача 15.
-- Найдите размеры жестких дисков, совпадающих у двух и более PC.
-- Вывести: HD

USE computer
GO

SELECT hd
FROM PC
GROUP BY hd
HAVING count(model) >= 2
GO
+--------+
|   hd   |
+--------+
|    5   |
|    8   |
|   10   |
|   14   |
|   20   |
+--------+
