-- Cursores em SQLSERVER
DECLARE @nome VARCHAR(50);
DECLARE cursorFuncionario CURSOR FOR
SELECT F.Pnome 
FROM FUNCIONARIO AS F

-- para cada funcionario dentro do banco pega o nome e bota dentro do cursor
OPEN cursorFuncionario;
FETCH NEXT FROM cursorFuncionario INTO @nome;

-- enquanto a algo no vetor, no valor no fetch status é um(tem algo a ser relacionado)
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT @nome
	FETCH NEXT FROM cursorFuncionario INTO @nome;
END
CLOSE cursorFuncionario;
DEALLOCATE cursorFuncionario; -- para nao ficar guardando infos na memoria do pc o tempo todo
