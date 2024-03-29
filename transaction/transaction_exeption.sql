USE bank;

TRUNCATE TABLE Scores;

INSERT INTO Scores ([Account number], Owner, Balance)
VALUES ('111111111111', 'Ivanov', 1000),
       ('222222222222', 'Petrov', 0)
GO

-- Начальные значения.
SELECT 'До начала транзакции' AS 'Состояние',
       Owner,
       Balance,
       @@TRANCOUNT            AS 'Количество_транзакций'
FROM Scores
GO
+----------------------+--------+----------+-----------------------+
|     Состояние        | Owner  | Balance  | Количество_транзакций |
+----------------------+--------+----------+-----------------------+
| До начала транзакции | Ivanov | 1000.00  |           0           |
| До начала транзакции | Petrov |    0.00  |           0           |
+----------------------+--------+----------+-----------------------+


-- BEGIN TRANSACTION - начало явной транзакции.
BEGIN TRANSACTION
BEGIN TRY
    UPDATE Scores
    SET Balance -= 1000
    WHERE Owner = 'Ivanov'
    SELECT 'Уменьшили баланс Иванова' AS 'Состояние',
           Owner,
           Balance,
           @@TRANCOUNT                AS 'Количество_транзакций'
    FROM Scores

    UPDATE Scores
    SET Balance += 1000
    WHERE Owner = 'Petrov'
    SELECT 'Увеличили баланс Петрова' AS 'Состояние',
           Owner,
           Balance,
           @@TRANCOUNT                AS 'Количество_транзакций'
    FROM Scores

    IF @@TRANCOUNT > 0 COMMIT TRANSACTION
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER()    AS 'Номер_ошибки',
           ERROR_MESSAGE()   AS 'Сообщение_об_ошибке',
           ERROR_SEVERITY()  AS 'Уровень_серьезности_ошибки',
           ERROR_LINE()      AS 'Номер_строки_ошибки',
           ERROR_PROCEDURE() AS 'Имя_операции_ошибки',
           ERROR_STATE()     AS 'Состояние_ошибки',
           @@TRANCOUNT       AS 'Количество_транзакций'
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW -- оператор, который обеспечивает механизм возвращение сообщения об ошибки.
END CATCH

SELECT 'После окончания транзакции' AS 'Состояние',
       Owner,
       Balance,
       @@TRANCOUNT        AS 'Количество_транзакций'
FROM Scores
GO
+--------------------------+--------+------------+-----------------------+
|       Состояние          | Owner  |  Balance   | Количество_транзакций |
+--------------------------+--------+------------+-----------------------+
| Уменьшили баланс Иванова | Ivanov |    0.0000  |          1            |
| Уменьшили баланс Иванова | Petrov |    0.0000  |          1            |
+--------------------------+--------+------------+-----------------------+

+--------------------------+--------+------------+-----------------------+
|       Состояние          | Owner  |  Balance   | Количество_транзакций |
+--------------------------+--------+------------+-----------------------+
| Увеличили баланс Петрова | Ivanov |    0.0000  |          1            |
| Увеличили баланс Петрова | Petrov | 1000.0000  |          1            |
+--------------------------+--------+------------+-----------------------+

+----------------------------+--------+------------+-----------------------+
|       Состояние            | Owner  |  Balance   | Количество_транзакций |
+----------------------------+--------+------------+-----------------------+
| После окончания транзакции | Ivanov |    0.0000  |          0            |
| После окончания транзакции | Petrov | 1000.0000  |          0            |
+----------------------------+--------+------------+-----------------------+
