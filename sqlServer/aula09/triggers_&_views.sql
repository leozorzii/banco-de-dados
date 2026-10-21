USE EMPRESA_2026;
GO
CREATE OR ALTER TRIGGER trg_after_insert_funcionario
ON FUNCIONARIO 
AFTER INSERT -- depois que eu inserir ele vai fazer o que ta dentro do trigger
AS 
BEGIN
	PRINT 'Meu primeiro trigger'
END;
GO 
INSERT INTO DEPARTAMENTO
VALUES('Expedição', 55, NULL, NULL);
SELECT * FROM DEPARTAMENTO
GO
CREATE OR ALTER TRIGGER trg_instead_of_insert_departamento
ON DEPARTAMENTO 
INSTEAD OF INSERT -- ao inves de insert faz o que ta aqui dentro
AS 
BEGIN
	DECLARE @nome VARCHAR(40);
	SELECT @nome = I.Dnome
	FROM inserted AS I;
	PRINT 'o departamento: ' + @nome + ' nao foi inserido'
END;
GO
INSERT INTO DEPARTAMENTO(Dnome, Dnumero)
VALUES('Expedição2', 55);
SELECT * FROM DEPARTAMENTO

--fazer um trigger que nao permita inserir dois departamentos com mesmo nome
GO
CREATE OR ALTER TRIGGER trg_nao_insere_dp_com_mesmo_nome 
ON DEPARTAMENTO 
INSTEAD OF INSERT 
AS 
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted AS I
        JOIN DEPARTAMENTO AS D ON I.Dnome = D.Dnome
    )
    BEGIN
        RAISERROR('Já existe um departamento com este nome.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO DEPARTAMENTO(Dnome, Dnumero, Cpf_gerente, Data_inicio_gerente) 
        SELECT I.Dnome, I.Dnumero, I.Cpf_gerente, I.Data_inicio_gerente 
        FROM inserted AS I;
    END
END;
GO

GO

-- DESABILITAR / HABILITAR TRIGGER
ALTER TABLE DEPARTAMENTO
DISABLE TRIGGER trg_after_insert_departamento;
-- ENABLE
INSERT INTO DEPARTAMENTO(Dnome, Dnumero)
VALUES('Expedição', 55);
SELECT * FROM DEPARTAMENTO

-- SE EU N TENHO INTERFACE GRAFICA
-- VERIFICAR VIA SQL OS TRIGGER DA MINHA TABELA
EXEC sp_helptrigger DEPARTAMENTO


-- VERIFICAR TRIGGER NO BANCO
-- me lista todos os trigger dos sistemas
-- os habilitados e disables
SELECT *
FROM sys.triggers
WHERE is_disabled = 0 OR is_disabled = 1;

-- funcao UPDATE
-- verificando, se o nome de um departamento foi alterado, faça algo
GO
CREATE OR ALTER TRIGGER trg_after_update_nome
ON DEPARTAMENTO
FOR UPDATE
AS
BEGIN
	DECLARE @old VARCHAR(50), @new VARCHAR(50)
	
	SELECT @old = D.Dnome FROM deleted AS D
	SELECT @new = I.Dnome FROM inserted AS I
	IF UPDATE(Dnome)
	BEGIN
	-- serve pra fazer log, TABELA DE LOGS por exemplo.
		PRINT 'O nome ANTIGO era: ' + @old;
		PRINT 'O nome NOVO é: ' + @new;
	END
	ELSE
		PRINT 'O nome nao foi modificado'
END
GO

UPDATE DEPARTAMENTO 
SET Dnome = 'Recursos Humanos'
WHERE Dnome = 'RH'

UPDATE DEPARTAMENTO 
SET Dnumero = 9
WHERE Dnome = 'Expedição'

UPDATE DEPARTAMENTO 
SET Dnome = 'Informatica'
WHERE Dnome = 'TI'

SELECT * FROM DEPARTAMENTO

-- impedir que um funcionario receba menos de 1000 reais
GO
CREATE  OR ALTER TRIGGER trg_nao_pode_salario_menor_1000
ON FUNCIONARIO
AFTER INSERT
AS
BEGIN
	DECLARE @salario DECIMAL(10,2);
	SELECT @salario = I.Salario
	FROM inserted as I
	IF(@salario < 1000)
	BEGIN
		ROLLBACK;
		RAISERROR('Salário nao pode ser < que 1000', 16, 1)
	END
END
GO

INSERT INTO FUNCIONARIO(Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus,Data_Admissao, Dnr)
VALUES('Jorgao', 'Zorzi', '02112212', '2006-07-12','Rua dez', 'M', 200, 0, '2026-10-20', 8);

SELECT * FROM FUNCIONARIO;

--CRIAR UMA TABELA DE LOGS
CREATE TABLE logs_salario_funcionario(
	log_id INT IDENTITY(100,1) PRIMARY KEY, -- começa o id no numero 100
	cpf CHAR(11),
	operacao VARCHAR(10),
	data_hora DATETIME DEFAULT GETDATE(), --vai pegar o timestamp do servidor
	salario_anterior DECIMAL(10,2)
)
-- 3 triggers, insert, update  e delete
-- TRIGGER INSERT
GO
CREATE OR ALTER TRIGGER trg_for_insert_funcionario
ON FUNCIONARIO
FOR INSERT
AS
BEGIN
	INSERT INTO logs_salario_funcionario(cpf, operacao)
	SELECT cpf, 'INSERT'
	FROM inserted
END
GO

-- TRIGGER UPDATE
GO
CREATE OR ALTER TRIGGER trg_for_update_funcionario
ON FUNCIONARIO
FOR UPDATE
AS
BEGIN
	INSERT INTO logs_salario_funcionario(cpf, operacao)
	SELECT cpf, 'UPDATE'
	FROM inserted
END
GO

GO
CREATE OR ALTER TRIGGER trg_for_delete_funcionario
ON FUNCIONARIO
FOR DELETE
AS
BEGIN
	INSERT INTO logs_salario_funcionario(cpf, operacao)
	SELECT cpf, 'DELETE'
	FROM deleted
END
GO

INSERT INTO FUNCIONARIO(Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus,Data_Admissao, Dnr)
VALUES('ogro', 'Magalhaes', '022512523', '2005-07-12','Rua dez', 'M', 1500, 0, '2026-10-20', 8);

SELECT * FROM FUNCIONARIO ORDER BY Pnome
SELECT * FROM logs_salario_funcionario

UPDATE FUNCIONARIO
SET Salario = 500
WHERE Cpf = '022512523'

DELETE FUNCIONARIO
WHERE Cpf = '022512523';

--1 Criar uma tabela para guardar todas as alteração 
-- de salário sofridas por um funcióario. Em seguida
-- crie triggers para guardar nesta tabela informações
-- sobre essas alteraçõe (id, cpf, salario anterior, data e hora)

--2 Crie uma nova coluna na tabela departamente chamada de status.
--Agora crie um trigger que impeça o usuário de deletar um departamento
--já existente. Ou seja ao invés de deltar o departamento altere o valor 
--da coluna de status para '0'.

--3 Crie um trigger que seja disparado depois que uma operação de inserção, 
-- update ou deleção ocorra na tabela FUNCIONARIO. 
-- Esse trigger deve registrar o CPF do novo funcionário 
--inserido, alterado ou deletado e a operação realizada ("INSERT, DELETE, UPDATE") 
-- em uma tabela de log (Log_Funcionario), juntamente com a data e hora da inserção. Esse trigger ajudará a manter um histórico 
-- das inserções realizadas na tabela de funcionários.
GO
CREATE OR ALTER TRIGGER trg_salvar_salario_anterior
ON FUNCIONARIO
FOR UPDATE
AS
BEGIN
	DECLARE @old_salario VARCHAR(50)
	
	SELECT @old_salario = D.Salario FROM deleted AS D
	IF UPDATE(Salario)
	BEGIN
		INSERT INTO logs_salario_funcionario(cpf,operacao, salario_anterior)
		SELECT D.Salario
		FROM deleted AS D
			
	END
	ELSE
		PRINT 'O nome nao foi modificado'
END
GO

--VIEW
GO
CREATE OR ALTER VIEW vw_rh_funcionario_dpt
AS
SELECT 
	CONCAT(Pnome, ' ', Minicial, ' ', Unome) AS 'nome',
	DATEDIFF(YEAR, Datanasc, GETDATE()) AS 'Idade',
	Endereco as 'Endereço',
	Data_Admissao AS 'Admição',
	D.Dnome AS 'DEPARTAMENTO'

FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero;
GO


SELECT * FROM vw_rh_funcionario
