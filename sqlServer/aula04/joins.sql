-- aula 04 sqlserver 
-- JOINS


-- INNER JOIN
-- selecionar o primeiro e o ultimo nome, e endereco dos funcionarios que trabalham no departamento de pesquisa

SELECT  f.Pnome, f.Unome, Endereco, D.Dnome
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa';

-- liste os funcionarios que estao desenvolvendo o 'produtoX'
SELECT F.Pnome, T.Pnr, P.Projnome
FROM FUNCIONARIO AS F
JOIN TRABALHA_EM AS T
ON t.Fcpf = F.Cpf
JOIN PROJETO AS P
ON T.Pnr = p.Projnumero
WHERE p.Projnome ='produtoX'

-- para cada projeto localizado em maua, listar o numero do projeto, numero do dp que controla, o sobrenome, endereco e data de nasc do gerente do dp
SELECT 
p.Projnumero AS 'NUMERO PROJETO', 
D.Dnumero AS 'NUMERO DEPARTAMENTO', 
f.Unome AS 'SOBRENOME',
f.Endereco AS 'ENDEREÇO', 
F.Datanasc AS 'DATA NASCIMENTO'
FROM PROJETO AS P
INNER JOIN DEPARTAMENTO AS D
ON P.Dnum = D.Dnumero
JOIN FUNCIONARIO AS F
ON D.Cpf_gerente = F.Cpf
WHERE P.Projlocal = 'Mauá'

-- liste o ultimo nome de todos os funcionarios e o ultimo nome dos respectivos gerentes, caso possuam
SELECT f.Pnome AS 'FUNCIONARIO', S.Unome AS 'SUPERVISOR' 
FROM FUNCIONARIO AS F
LEFT JOIN FUNCIONARIO AS S
ON f.Cpf_supervisor = s.Cpf

-- encontrar despartamentos que nao tem nenhum funcionario atrelado a ele
SELECT d.Dnome
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F
ON D.Dnumero = F.Dnr
WHERE F.Cpf IS NULL;
 

-- usando right join encontre os funcionarios que nao tem dependentes
SELECT * 
FROM DEPENDENTE AS DP
RIGHT JOIN FUNCIONARIO AS F
ON DP.Fcpf = F.Cpf
WHERE DP.Fcpf IS NOT NULL;

--cross join    teste relacoes entre FUNCIONARIOS e DEPARTAMENTO
SELECT F.Pnome AS 'NOME', DP.Dnome AS 'DEPARTAMENTO RESPECTIVO'
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS DP
ON DP.Dnumero = F.Dnr

-- UNION listar todos os nomes, sexo e data de nasc de todas as pessoas do banco
SELECT F.Pnome AS 'NOME', F.Sexo AS 'SEXO'
FROM FUNCIONARIO AS F
UNION
SELECT D.Nome_dependente AS 'NOME', D.Sexo AS 'SEXO'
FROM DEPENDENTE AS D;


-- IMAGINE QUE A DIRETORIA DA EMPRESA QUER UMA LISTA DE TODAS AS CIDADES DE ONDE A EMPRESA POSSUI ALGUMA ATIVIDADE, SEJA DE LOCALIZAÇÃO
-- DE UM DEPARTAMENTO OU A LOCALIZACAO DE UM PROJETO
SELECT P.Projlocal AS 'CIDADE'
FROM PROJETO AS P
UNION ALL -- all nao se importa com duplicata
SELECT L.Dlocal AS 'CIDADE'
FROM LOCALIZACAO_DEP AS L

-- EXCEPT LISTAR O CPF DOS FUNCIONARIOS QUE NAO SAO GERENTES DE NENHUM DP
SELECT f.Pnome , F.Unome 
FROM FUNCIONARIO AS F
WHERE F.Cpf IN (
SELECT F.Cpf
FROM FUNCIONARIO AS F

EXCEPT --exeto o que tem abaixo

SELECT DP.Cpf_gerente
FROM DEPARTAMENTO AS DP
)

-- INTERSECT -- Encontre os funcionarios que sao Gerentes
SELECT F.Cpf
FROM FUNCIONARIO AS F
INTERSECT
SELECT DP.Cpf_gerente
FROM DEPARTAMENTO AS DP

-- GROUPY BY - POSSIVEL QUESTAO DE PROVA 
-- CONTAR O NUMERO DE FUNCIONARIOS POR DEPARTAMENTOS
SELECT DP.Dnome, COUNT (F.Cpf) AS 'N DE FUNCIONARIOS'
FROM FUNCIONARIO AS F 
JOIN DEPARTAMENTO AS DP
ON f.Dnr = DP.Dnumero
WHERE F.Sexo = 'M'
GROUP BY DP.Dnome 
ORDER BY DP.Dnome ASC;

-- somar os salarios por departamento
SELECT DP.Dnome, SUM (F.Salario) AS 'Salarios'
FROM FUNCIONARIO AS F 
JOIN DEPARTAMENTO AS DP
ON f.Dnr = DP.Dnumero
GROUP BY DP.Dnome 
ORDER BY DP.Dnome ASC;

-- maior de cada dp
SELECT DP.Dnome, MAX (F.Salario) AS 'Salarios'
FROM FUNCIONARIO AS F 
JOIN DEPARTAMENTO AS DP
ON f.Dnr = DP.Dnumero
GROUP BY DP.Dnome 
ORDER BY DP.Dnome ASC;

-- quantidade de funcionarios por sexo
SELECT Sexo, COUNT (*) AS 'FUNCIONARIOS'
FROM FUNCIONARIO AS F
GROUP BY F.Sexo
ORDER BY F.Sexo

-- numero de projetos em cada local

SELECT P.projlocal, COUNT(*) AS 'QTD PROJETOS LOCAIS'
FROM PROJETO AS P
GROUP BY P.Projlocal
ORDER BY P.Projlocal 
 
