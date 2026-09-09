--Funcoes em SQL
CREATE OR ALTER FUNCTION fn_dobro(@numero INT)
RETURNS DECIMAL(10,2)
AS 
BEGIN
	RETURN @numero * 2;
END;

SELECT dbo.fn_dobro(10) AS Resultado;
GO
SELECT f.Pnome, f.Unome, f.Salario AS 'ATUALMENTE', 
		dbo.fn_dobro(f.salario) AS 'DOBRO'
FROM FUNCIONARIO AS F; 
GO


-- crie uma funcao que calcula a idade correta de um funcionario com base na data de nascimento
CREATE OR ALTER FUNCTION calcula_idade(@data DATE)
RETURNS INT
AS
BEGIN
	DECLARE @idade INT;
	SET @idade = DATEDIFF(YEAR, @data, GETDATE());
	IF (MONTH(@data) > MONTH(GETDATE())) 
	   OR 
	   (MONTH(@data) = MONTH(GETDATE()) AND DAY(@data) > DAY(GETDATE()))
		SET @idade = @idade - 1;
	RETURN @idade;
END;
GO
-- select para testa-la
SELECT F.Pnome, F.Unome, CONVERT(VARCHAR, F.Datanasc, 103) AS 'DATA NASC',
dbo.calcula_idade(F.DataNasc) AS 'IDADE'
FROM FUNCIONARIO AS F
WHERE f.Sexo = 'M'
ORDER BY idade ASC;
GO


-- retornar todos os funcionarios de um determinado departamento
-- funcao INLINE
CREATE FUNCTION fn_retornaFuncionarios(@nomeDp VARCHAR(20))
RETURNS TABLE
AS RETURN
(
	SELECT F.Pnome, F.Unome
	FROM FUNCIONARIO AS F
	INNER JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
	WHERE D.Dnome = @nomeDp
)

GO

SELECT * 
FROM dbo.fn_retornaFuncionarios('Pesquisa')

GO

-- criar funcao que retorne o nome completo dos funcionarios e o valor do salario anual, com ferias e decimo terceiro;
CREATE OR ALTER FUNCTION fn_retornaDados()
returns @tabela TABLE(
	nomeCompleto VARCHAR(40),
	salarioAnual DECIMAL(10,2),
	ferias DECIMAL(10,2)
)
AS BEGIN
	INSERT INTO @tabela(nomeCompleto, salarioAnual, ferias)
		SELECT 
		CONCAT(F.Pnome, '', F.Unome),
		Salario,
		Salario *13 + (Salario*0.3) -- ferias
		FROM FUNCIONARIO AS F
	RETURN;
END
-- chama a funcao
GO
SELECT * 
FROM dbo.fn_retornaDados()
GO


-- Queremos calcular o salario anual de funcionarios (12 meses), mas tambem considerar um bonus variavel, (%), passado como parametro
GO
CREATE FUNCTION fn_salarioAnual(
@salario DECIMAL(10,2),
@bonus DECIMAL(10,2)
)
RETURNs DECIMAL(10, 2)

AS BEGIN
	DECLARE @res DECIMAL(10,2)
	SET @res = (@salario*12) * (1 + @bonus/100) 
	RETURN @res
END
GO
	SELECT
	Pnome, Unome, Salario, dbo.fn_salarioAnual(Salario, 10) AS 'salario anual + bonus'
	FROM FUNCIONARIO;
