/*
Два основных режима блокировок:
1.совмещаемые блокировки (shared locks);
2.монопольные блокировки (exclusive locks);
Ситуация, когда несколько прикладных пользовательских программ плновременно выполняют операции чтения и записи данных,
называется одновременным конкурентным доступом (concurrency).
Компонент Database Engine поддерживает две модели одновременного конкурентного доступа:
- пессимистический и оптимистический конкурентный доступ.

Уровень изоляции:
1. READ COMMITTED READ COMMIT имеет в свою очередь две формы.
Первая форма применяется в пессимистической модели одновременного конкурентного доступа.
Вторая READ COMMIT SNAPSHOT - оптимистический модели одновременного конкурентного доступа.
Этот уровень уже запрещает грязное чтение, в данном случае все процессы, запросившие данные,
которые изменяются в тот же момент в другой транзакции,
будут ждать завершения этой транзакции и подтверждения фиксации данных.
Данный уровень по умолчанию используется SQL сервером.
2. READ UNCOMMITTED.
3. REPEATABLE READ.
4. SERIALIZABLE
5. READ COMMIT SNAPSHOT.
6. SNAPSHOT.
*/

USE bank;

-- Отстанавливаем процесс транзакции другого сеанса.
KILL 51;

-- 1. Уровень изоляции READ UNCOMMITTED.
-- Читает неподтвержденные (незакомиченные) данные.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET NOCOUNT ON;

-- Инструкция DВCC USEROPTIONS возвращает информацию о текущих значениях параметров инструкции SET,
-- включая значения уровня изоляции, которое возвращает в параметре ISOLATION LEVEL.

-- Можно вставить новую строку.
INSERT INTO Scores ([Account number], Owner, Balance)
VALUES ('333333333333', 'Sidorov', 3000);
GO

SELECT 'Состояние запроса' AS 'Состояние',
       Owner,
       Balance,
       @@SPID              AS 'Процесс',
       @@TRANCOUNT         AS 'Количество_транзакций'
FROM Scores
GO
+------------------------+---------+----------+---------+-----------------------+
| Состояние              |  Owner  |  Balance | Процесс | Количество_транзакций |
+------------------------+---------+----------+---------+-----------------------+
| Состояние запроса      | Ivanov  |   500.00 |    51   |            0          |
| Состояние запроса      | Petrov  |     0.00 |    51   |            0          |
| Состояние запроса      | Sidorov |  3000.00 |    51   |            0          |
+------------------------+---------+----------+---------+-----------------------+

-- Нельзя удалить вставленную строку из текущего сеанса
DELETE
FROM Scores
WHERE Owner = 'Sidorov'
GO

-- Нельзя удалить строку из сеанса транзакции
DELETE
FROM Scores
WHERE Owner = 'Petrov'
GO

-- Изменить счет Петрова нельзя, так как таблица счета заблокирована в другом сеансе.
UPDATE Scores
SET Balance += 200
WHERE Owner = 'Petrov'
GO

-- READ UNCOMMITTED - крайне нежелательный уровень изоляции.
-- Её используют в двух случаях:
-- 1. когда точность данных не представляет важности;
-- 2. когда данные редко подтвергаются изменению.

-- 2. Уровень изоляции READ COMMITTED.
-- Читает подтвержденные (закомиченные) данные.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Можно вставить новую строку.
INSERT INTO Scores ([Account number], Owner, Balance)
VALUES ('333333333333', 'Krylov', 4000);
GO

-- Нет возможности использовать SELECT, только с использованием WITH (READUNCOMMITTED) / WITH (NOLOCK);
SELECT 'Состояние запроса' AS 'Состояние',
       Owner,
       Balance,
       @@SPID              AS 'Процесс',
       @@TRANCOUNT         AS 'Количество_транзакций'
FROM Scores
GO
+------------------------+---------+----------+---------+-----------------------+
| Состояние              |  Owner  |  Balance | Процесс | Количество_транзакций |
+------------------------+---------+----------+---------+-----------------------+
| Состояние запроса      | Ivanov  |   500.00 |    51   |            0          |
| Состояние запроса      | Petrov  |     0.00 |    51   |            0          |
| Состояние запроса      | Sidorov |  3000.00 |    51   |            0          |
| Состояние запроса      | Krylov  |  4000.00 |    51   |            0          |
+------------------------+---------+----------+---------+-----------------------+

-- Нельзя удалить вставленную строку из текущего сеанса
DELETE
FROM Scores
WHERE Owner = 'Krylov'
GO

-- Нельзя удалить строку из сеанса транзакции
DELETE
FROM Scores
WHERE Owner = 'Petrov'
GO

-- Изменить счет Петрова нельзя, так как таблица счета заблокирована в другом сеансе.
UPDATE Scores
SET Balance += 200
WHERE Owner = 'Petrov'
GO

-- Читаем только подтвержденные дынные (будет ждать 1 секунду в ожидании снятия блокировки
-- и если за это время блокировка не будет снята,
-- то завершит запрос с оштбкой "Превышено время ожидания запроса на блокировку")

-- Указывает количество миллисекунд,
-- В течении которых инструкция ожидает снятия блокировки при обращении к заблоктрованным строкам.
SET LOCK_TIMEOUT 1000;

-- Возврат к значениям задержки по умолчанию.
SET LOCK_TIMEOUT -1;

-- Для реализации уровня READ UNCOMMITTED не для всего сеанса,
-- а в одной команде используется табличная подсказка READUNCOMMITTED.
-- Замените команду SELECT в коде предыдущего запроса на следующую,
-- которая содержит табличную подсказку WITH (READUNCOMMITTED).
-- Затем измените инструкцию, чтобы тспользовать табличную подсказку WITH (NOLOCK).
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT 'Состояние запроса' AS 'Состояние',
       Owner,
       Balance,
       @@SPID              AS 'Процесс',
       @@TRANCOUNT         AS 'Количество_транзакций'
FROM Scores WITH (READUNCOMMITTED);
-- аналогично
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT *
FROM Scores WITH (NOLOCK);

-- READ COMMITTED SNAPSHOT
/*
 Изменим БД Банк. Включим параметр уровня изоляции моментальных снимков на уровне базы данных.
После включения этого параметра транзакции, указывающие уровень READ COMMITTED,
используют управления версиями строк вместо блокировок. Если транзакция выполняется с уровнем изоляции READ COMMITTED,
данные моментального снимка видны всем инструкциям в состоянии,
которое существовало на момент начала выполнения инструкции.
*/
ALTER DATABASE bank
    SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK AFTER 1 SECONDS;
/*
Уровень изоляции READ COMMITTED SNAPSHOT
Оба оптимистических уровня изоляции включаются на уровне базы данных.
READ COMMITTED SNAPSHOT (RCSI) включается командой ALTER DATABASE SET READ_COMMITTED_SNAPSHOT ON.
ПрИзменение этого параметра требует монопольного доступа к базе.
Команда не выполнится, если есть другие подключения к базе.
Вы можете переключить базу данных в однопользовательский режим
или использовать команду ALTER DATABASE SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK AFTER X SECONDS.
При этом откатятся все активные транзакции и завершаться все подключения к базе.
*/

SET LOCK_TIMEOUT 1000;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT 'Состояние запроса' AS 'Состояние',
       Owner,
       Balance,
       @@SPID              AS 'Процесс',
       @@TRANCOUNT         AS 'Количество_транзакций'
FROM Scores
GO

-- Можно вставить новую строку.
INSERT INTO Scores ([Account number], Owner, Balance)
VALUES ('333333333333', 'Krylov', 4000);
GO

-- Нельзя удалить вставленную строку из текущего сеанса.
DELETE
FROM Scores
WHERE Owner = 'Krylov'
GO

-- Нельзя удалить строку из сеанса транзакции.
DELETE
FROM Scores
WHERE Owner = 'Petrov'
GO

-- Изменить счет Петрова нельзя, так как таблица счета заблокирована в другом сеансе.
UPDATE Scores
SET Balance += 200
WHERE Owner = 'Petrov'
GO

SELECT 'Состояние запроса' AS 'Состояние',
       Owner,
       Balance,
       @@SPID              AS 'Процесс',
       @@TRANCOUNT         AS 'Количество_транзакций'
FROM Scores
GO

/*
SNAPSHOT является отдельным уровнем изоляции.
Он должен быть явно задан в коде с помощью команды SET TRANSACTION ISOLATION LEVEL SNAPSHOT
или с помощью табличного указания WITH (SNAPSHOT).

По умолчанию, использование уровня изоляции SNAPSHOT запрещено.
Его необходимо включить с помощью команды ALTER DATABASE SET ALLOW_SNAPSHOT_ISOLATION ON.
Эта команда не требует монопольного доступа к базе и ее можно выполнять когда есть активные пользователи.

Уровень изоляции SNAPSHOT обеспечивает согласованность данных на уровне транзакции.
Транзакции будут работать с версией данными, зафиксированной на начало транзакции вне зависимости от того,
сколько транзакция активна и какие изменения происходили с данными в других транзакциях в это время.
*/
ALTER DATABASE bank SET ALLOW_SNAPSHOT_ISOLATION ON;

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
/*
Нельзя произвести чтение из сеанса транзакции;
Транзакции в режиме изоляции моментального снимка не удалось получить доступ к базе данных "bank",
так как режим изоляции моментального снимка не допускается в этой базе данных.
Используйте инструкцию ALTER DATABASE для разрешения использования режима изоляции моментального снимка.
 */
SELECT *
FROM Scores
GO

-- Можно вставить новую строку.
INSERT INTO Scores ([Account number], Owner, Balance)
VALUES ('333333333333', 'Krylov', 4000);
GO

-- Можно удалить вставленную строку из текущего сеанса.
DELETE
FROM Scores
WHERE Owner = 'Krylov'
GO

-- Можно удалить строку из сеанса транзакции.
DELETE
FROM Scores
WHERE Owner = 'Petrov'
GO

-- Можно изменить счет Петрова в другом сеансе.
UPDATE Scores
SET Balance += 200
WHERE Owner = 'Petrov'
GO

-- Нельзя изменить счет Иванова, который заблокирован транзакцией.
UPDATE Scores
SET Balance -= 500
WHERE Owner = 'Ivanov'
GO
