USE EMPRESA;

--exemplo inicial para verificar se existe alguma procedure no banco e depois apagar
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE TYPE = 'P' AND NAME = 'SP_mostrar_novos_funcionarios')
    BEGIN
        DROP PROCEDURE SP_mostrar_novos_funcionarios
    END

-- 1 crie uma procedure que mostre todos os funcionarios
GO
CREATE OR ALTER PROCEDURE SP_mostrar_novos_funcionarios
AS
SELECT F.Pnome, F.Unome FROM FUNCIONARIO AS F
END;
GO

-- 2 Crie uma procedure que receba o número de um departamento e liste os funcionários daquele departamento.
    CREATE OR ALTER PROCEDURE SP_listar_funcionarios_departamento
        @numero_departamento INT
    AS 
    BEGIN
        SELECT f.Pnome, f.Unome, F.Cpf, F.Salario
        FROM FUNCIONARIO AS F
         WHERE F.Dnr = @numero_departamento;
    END;
GO
-- 3 Crie uma procedure que receba um CPF e mostre os dados completos do funcionario
CREATE OR ALTER PROCEDURE SP_mostrar_dados_pelo_cpf
    @cpf_base VARCHAR(11)
    AS
    BEGIN
        SELECT *
        FROM FUNCIONARIO AS F
        WHERE F.Cpf = @cpf_base
    END;
GO

-- 4 criar uma procedure que mostre o nome do funcionario, nome do departamento, e o salario, usando INNER JOIN
    CREATE OR ALTER PROCEDURE SP_mostrar_dados_pelo_cpf_com_inner_join
    @cpf VARCHAR(11)
    AS
    BEGIN
            SELECT F.Pnome, D.Dnome, F.Salario
            FROM FUNCIONARIO AS F
            INNER JOIN DEPARTAMENTO AS D
            ON F.Dnr = D.Dnumero -- parametro de comparacao entre tabelas
            WHERE F.Cpf = @cpf
        END;
GO


--como executar a procedure
EXEC SP_mostrar_dados_pelo_cpf_com_inner_join
    @cpf = '33344555587'