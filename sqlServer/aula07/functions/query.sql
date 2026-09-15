-- crie uma funcao  fn_projetosPorFuncionario que receba o CPF de um funcionario e retorno os nomes dos projetos 
-- nos quais ele trabalha, usando a tabela TRABALHA_EM
CREATE OR ALTER FUNCTION fn_projetosPorFuncionario(@cpf CHAR(11))
    RETURNS TABLE
    AS
        RETURN(
        SELECT p.Projnome
        FROM FUNCIONARIO AS F
        INNER JOIN TRABALHA_EM AS T 
        ON T.Fcpf = F.Cpf
        INNER JOIN PROJETO AS P 
        ON p.Projnumero = T.Pnr
        WHERE f.Cpf = @cpf 
     );
GO

SELECT *
FROM dbo.fn_projetosPorFuncionario('12345678966')

GO

-- crie uma funcao fn_GanhaMaisQsupervisor que receba o salario de un funcionario e retorne 1(true) se o
-- salario dele for maior que o salario do seu supervisor, ou 0(false) caso contrario

CREATE OR ALTER FUNCTION fn_GanhaMaisQsupervisor(@cpf_base CHAR(11))
RETURNS BIT
AS
BEGIN
    DECLARE @salario_funcionario DECIMAL(10,2), @salario_supervisor DECIMAL(10,2), @res BIT
    SET @salario_funcionario = (
        SELECT f.Salario
        FROM FUNCIONARIO AS F
        WHERE f.Cpf = @cpf_base
    )
    SET @salario_supervisor = (
        SELECT S.Salario 
        FROM FUNCIONARIO AS S
        INNER JOIN FUNCIONARIO AS F
        ON F.Cpf_supervisor = s.Cpf
        WHERE F.Cpf = @cpf_base
    )

        IF(@salario_funcionario > @salario_supervisor)
            SET @res = 1
        ELSE
            SET @res = 0
    RETURN @res
END

GO
SELECT dbo.fn_GanhaMaisQsupervisor('12345678966')
GO


-- crie uma funcao fn_FuncionarioEstrela que receba o CPF de um funcionario e retorne 
-- nome completo
-- quantos dependentes possui
-- quantos projetos participa
-- se ganha mais que o supervisor

CREATE OR ALTER FUNCTION fn_FuncionarioEstrela(@cpf_base CHAR(11))
RETURNS @tabela TABLE(
    nomeCompleto VARCHAR(40),

    quantidadeDependentes INT,
    quantidadeProjetos INT,
    ganhaMaisQueSupervisor BIT
)
AS BEGIN
    INSERT INTO @tabela(
        nomeCompleto,
        quantidadeDependentes,
        quantidadeProjetos,
        ganhaMaisQueSupervisor
    )
    SELECT
        CONCAT(F.Pnome, ' ', F.Unome),
        (
            SELECT COUNT(*)
            FROM DEPENDENTE AS D
            WHERE D.Fcpf = F.Cpf
        ),
        (
            SELECT COUNT(*)
            FROM TRABALHA_EM AS T
            WHERE T.Fcpf = F.Cpf
        ),
        dbo.fn_GanhaMaisQsupervisor(F.Cpf)
    FROM FUNCIONARIO AS F
    WHERE F.Cpf = @cpf_base;

    RETURN;
END;
GO

SELECT *
FROM dbo.fn_FuncionarioEstrela('12345678966');
GO


-- Crie uma funcao fn_CustoDepartamento que receba o numero de um departamento
-- e retorne a soma dos salarios de todos os funcionarios do departamento,
-- ou seja, quanto custa manter esse time por mes

CREATE OR ALTER FUNCTION fn_CustoDepartamento(@numero_departamento INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @custo_mensal DECIMAL(10,2)

    SET @custo_mensal = (
        SELECT COALESCE(SUM(F.Salario), 0)
        FROM FUNCIONARIO AS F
        WHERE F.Dnr = @numero_departamento
    )

    RETURN @custo_mensal
END
GO

-- Teste a funcao mostrando o custo mensal de cada departamento.

SELECT
    D.Dnumero,
    D.Dnome,
    dbo.fn_CustoDepartamento(D.Dnumero) AS 'CUSTO MENSAL'
FROM DEPARTAMENTO AS D;
GO


-- Crie uma funcao fn_NomeDependentesFuncionario que receba o CPF de um
-- funcionario e retorne uma string concatenada com os nomes de todos os seus
-- dependentes. Use STRING_AGG (SQL Server 2017+).

CREATE OR ALTER FUNCTION fn_NomeDependentesFuncionario(@cpf_base CHAR(11))
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @nomes_dependentes VARCHAR(8000)

    SET @nomes_dependentes = (
        SELECT STRING_AGG(D.Nome_dependente, ', ')
        FROM DEPENDENTE AS D
        WHERE D.Fcpf = @cpf_base
    )

    RETURN @nomes_dependentes
END
GO

SELECT dbo.fn_NomeDependentesFuncionario('12345678966') AS 'NOMES DOS DEPENDENTES';
GO
