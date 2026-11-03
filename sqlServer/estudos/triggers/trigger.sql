USE BIBLIOTECA;

-- 1 - crie um trigger que impeça a insercao de livros com o mesmo titulo na tabela livro
GO
CREATE OR ALTER TRIGGER trg_livros_mesmo_titulo
ON Livro
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS(
        -- titulo que ja existe na tabela livro
        SELECT 1
        FROM inserted AS I
        JOIN Livro AS L
        ON I.titulo = L.titulo
    )
    BEGIN
        RAISERROR('Erro: nao eh permitido inserir livros com o mesmo titulo', 16, 1);
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO livro (isbn, titulo, ano, fk_editora, fk_categoria)
        VALUES ('1111111111', 'O Papai é Pop', 2016, 4, 3);
       PRINT 'teste'
    END
END
GO--trigger desativado

-- 2 - criar um trigger que atualize automaticamente 
-- o ano de publicaao na tabela Livro
-- para o ano atual quando um novo livro eh inserido
GO
CREATE OR ALTER TRIGGER trg_atualiza_ano_atual
ON Livro
AFTER INSERT
AS
BEGIN
    UPDATE L
    SET L.ano = YEAR(GETDATE())
    FROM Livro AS L
    INNER JOIN inserted i ON L.isbn = i.isbn;
END

INSERT INTO Livro(isbn, titulo, ano, fk_editora, fk_categoria)
VALUES('124124123', 'Bob esponja body pants', 2001, 5, 2)



EXEC sp_helptext 'trg_livros_mesmo_titulo';
DISABLE TRIGGER trg_livros_mesmo_titulo ON Livro;

-- 3 - crie um trigger que exclua automaticamente registros
-- da tabela livroAutor quando o livro correspondente eh
-- excluido da tabela livro

GO
CREATE OR ALTER TRIGGER trg_exclui_registros_livroAutor
ON Livro
INSTEAD OF DELETE
AS
BEGIN
    -- deleta o filho primeiro
     DELETE la
     FROM LivroAutor la
     INNER JOIN deleted d ON la.fk_livro = d.isbn
    
    -- agora deleta o pai
    DELETE L
    FROM Livro L
    INNER JOIN deleted d ON L.isbn = d.isbn
END;
GO

    DELETE FROM Livro 
    WHERE isbn = '9788577345670'

    
SELECT *
FROM Livro AS L
SELECT *
FROM LivroAutor

-- 4 - Crie um trigger que atualize o numero total de livros em uma categoria especifica na tabela Categoria
-- sempre que um novo livro é inserido
GO
CREATE OR ALTER TRIGGER trg_atualiza_total_livros
ON Livro
AFTER INSERT
AS
BEGIN
    DECLARE @id_cat INT, @total INT;
    SELECT @id_cat = fk_categoria FROM inserted;

    SELECT @total = COUNT(*)
    FROM Livro
    WHERE Livro.fk_categoria = @id_cat
    PRINT 'O total de livros para a categoria ' + CAST(@id_cat AS VARCHAR) + ' SERIA: ' + CAST(@total AS VARCHAR);
END;
GO
-- TESTANDO COM UM INSERT
insert into livro values('97211222458','senta aqui','2005',4,3);


SELECT *
FROM Categoria AS C
INNER JOIN Livro AS L
ON C.id = L.fk_categoria
WHERE C.id = 3







