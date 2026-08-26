-- IF E ELSE - WHILE
-- DECLARAÇÃO DE VARIAVEIS
DECLARE @nome VARCHAR(100), @idade INTEGER, @data DATE, @salario MONEY, @nomeDepartamento VARCHAR(100);

SET @nome = 'Juca';
SET @idade = 20;
SET @data = GETDATE();
SET @salario = 2000;

SELECT @nomeDepartamento = D.Dnome
FROM DEPARTAMENTO AS D
WHERE D.Dnumero = 4
PRINT @nomeDepartamento

SELECT @nome AS 'NOME', @idade AS 'IDADE', @salario AS 'MONEY', @data AS 'DATA', @nomeDepartamento AS 'NOME DP';
PRINT @idade;
-- so existe em tempo de execução

--CALCULANDO NOVO SALARIO COM UM AUMENTO DE 10% PARA Jennifer
DECLARE  @salarioJennifer DECIMAL(10,2);
SELECT
@salarioJennifer = f.Salario * 1.10
FROM FUNCIONARIO AS F
WHERE F.Cpf = '98765432168'

PRINT @salarioJennifer
