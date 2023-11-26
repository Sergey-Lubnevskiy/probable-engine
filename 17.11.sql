CREATE TRIGGER IncreaseBookCount
ON S_Cards
AFTER UPDATE
AS
BEGIN
    IF UPDATE(date_in)
    BEGIN
        UPDATE Books
        SET Quantity = Quantity + 1
        FROM Books
        JOIN inserted
        ON Books.BookId = inserted.BookId;
    END
END;

----------------------------------------

CREATE TRIGGER CheckStudentDebt
ON S_Cards
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1
               FROM S_Cards
               WHERE StudentId = (SELECT StudentId FROM inserted)
               AND date_in IS NULL
               GROUP BY StudentId
               HAVING COUNT(*) >= 3)
    BEGIN
        RAISERROR ('Студент не может взять книгу, так как у него есть долг по возврату книг в количестве 3 экземпляра.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO S_Cards
        SELECT * FROM inserted;
    END
END;
