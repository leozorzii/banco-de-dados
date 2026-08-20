USE EMPRESA;
GO; --Separa em blocos de comando, como se fosse uma nova query



--listar as diferentes faixas salariais
SELECT DISTINCT f.Pnome,f.Salario
FROM FUNCIONARIO AS F
WHERE f.Salario >= 30000;

-- recupere todas as informacoes dos funcionarios com primeiro nome = Joao
SELECT * 
FROM FUNCIONARIO AS F
WHERE f.Pnome = 'João';

-- liste todos funcionarios do sexo masculino e com salario maior ou igual a 30000
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Sexo = 'M' AND F.Salario >= 300000;

-- liste os funcionarios que mora em SP ou Curitiba
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Endereco LIKE '%São Paulo%' OR
F.Endereco LIKE '%Curitiba%';

-- liste os funcionaris que nao moram em São Paulo
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Endereco NOT LIKE '%São Paulo%';

--liste os funcionarios em ordem descrescente de salario
SELECT f.Pnome, f.Salario
FROM FUNCIONARIO AS F
ORDER BY F.Salario ASC;

--liste os funcionarios que nao possuem supervisor
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NULL;


--liste os funcionarios que possuem supervisor
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NOT NULL;

-- recupere o registro dos 3 funcionarios de maior salari
SELECT TOP 3 F.Pnome, f.Salario
FROM FUNCIONARIO AS F
ORDER BY f.Salario DESC;

-- recupere as informacoes do funcionario com menor salario,  utlizando MIN()
-- Somente para valores numericos
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario = (
SELECT MIN(f.Salario) 
FROM FUNCIONARIO AS F
);
-- COUNT(), AVG(), SUM()
-- quantos funcionarios existem no meu banco do sexo masculino, COUNT - CONTA
SELECT COUNT(F.Pnome) AS 'quantidade'
FROM FUNCIONARIO AS F
WHERE F.Sexo LIKE 'M'


-- qual a media salarial dos funcionarios, AVG - MEDIA
SELECT AVG(F.Salario) AS 'media_salarial'
FROM FUNCIONARIO AS F


-- qual o total salarial dos funcionarios, SUM - SOMA



-- recupere os funcionarios nascidos em 72
SELECT F.Pnome, F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Datanasc LIKE '__72%'; --cada underline é um campo = 1972

-- recupere infos dos funcionarios que recebem 25000 e 30000 R$
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario in(25000, 30000);

-- recupere registros de funcionarios que trabalham (TRABALHA_EM) no mesmo projeto e na mesma qtd de horas do "Fernando" (Fcpf = "33344555587")
SELECT *  
FROM FUNCIONARIO AS F
-- quais projetos fernando trabalha
SELECT T.Pnr 
FROM TRABALHA_EM AS T
WHERE t.Fcpf = '33344555587'

SELECT * 
FROM TRABALHA_EM AS T
WHERE pnr IN (2,3,10,20)
AND NOT Fcpf = '33344555587'



DECLARE @Cpf VARCHAR(11) -- String cpf por exemplo
SET @Cpf = (SELECT Cpf FROM FUNCIONARIO WHERE Pnome = 'Fernando');

SELECT T.Pnr
FROM TRABALHA_EM AS T
WHERE T.Fcpf = @Cpf;


SELECT T.Fcpf, F.Pnome, F.Unome
FROM TRABALHA_EM AS T, FUNCIONARIO AS F
WHERE T.Pnr in (
	SELECT Pnr
	FROM TRABALHA_EM AS T
	WHERE Fcpf = @Cpf)
	AND Fcpf <> @Cpf 
	AND T.Fcpf = F.Cpf;


-- as letras AS F, esse F é um aliase