-- Parte 1: Consultas básicas

USE EMPRESA;
--1 Liste todos os funcionários mostrando nome, sobrenome e salário.
SELECT F.Pnome, f.Unome, f.Salario
FROM FUNCIONARIO AS F
--2 Liste os funcionários que recebem salário maior ou igual a 30000.
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario >= 30000; 
--3 Liste os funcionários do sexo masculino que recebem pelo menos 30000.
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario >= 30000 AND F.Sexo = 'M' ; 
--4 Liste os funcionários que moram em São Paulo ou Curitiba usando LIKE.
SELECT F.Pnome, F.Endereco
FROM FUNCIONARIO AS F
WHERE F.Endereco LIKE '%São Paulo%'
    OR F.Endereco LIKE '%Curitiba%' 
--5 Liste os funcionários que não moram em São Paulo(cidade).
SELECT F.Pnome, F.Salario, F.Endereco
FROM FUNCIONARIO AS F
WHERE F.Endereco NOT LIKE '%São Paulo%'
--6 Liste os funcionários em ordem decrescente de salário.
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC
--7 Liste os três funcionários com os maiores salários usando TOP.
SELECT TOP 3 F.Salario, F.Pnome 
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC
--8 Liste os funcionários que não possuem supervisor.
SELECT F.Pnome AS 'FUNCIONARIO SEM SUPERVISOR'
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NULL;
--9 Liste os funcionários que possuem supervisor.
SELECT F.Pnome AS 'FUNCIONARIO COM SUPERVISOR'
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NOT NULL
--10 Liste os funcionários que recebem exatamente 25000 ou 30000 usando IN.
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario IN (25000, 30000)
--11 Liste os funcionários nascidos no ano de 1972.
SELECT F.Pnome AS 'NASCIDOS EM 1972'
FROM FUNCIONARIO AS F
WHERE YEAR(f.Datanasc) = 1972;
-- ou essa opcao
-- WHERE F.Datanasc >= '1972-01-01' AND F.DataNasc <= '1972-12-31'; 
--12 Encontre o funcionário com o menor salário usando MIN.
SELECT f.Pnome, f.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario = (SELECT MIN(FUNCIONARIO.Salario) FROM FUNCIONARIO)

-- Parte 2: Funções de agregação

-- 13 Conte quantos funcionários existem no banco.
SELECT COUNT(F.Pnome)
FROM FUNCIONARIO AS F

--14 Conte quantos funcionários do sexo masculino existem.
SELECT COUNT(F.Pnome)
FROM FUNCIONARIO AS F
WHERE F.Sexo = 'M'
--15 Calcule a média salarial dos funcionários.
SELECT AVG(F.Salario) AS 'MEDIA SALARIAL'
FROM FUNCIONARIO AS F
--16 Calcule a soma de todos os salários.
SELECT SUM(F.Salario) AS 'SOMA DE TODOS SALARIOS'
FROM FUNCIONARIO AS F
--17 Mostre o maior e o menor salário da empresa.
SELECT TOP 1 Pnome, Salario AS 'MAIOR SALARIO'
FROM FUNCIONARIO
ORDER BY Salario DESC
SELECT TOP 1 Pnome, Salario as 'MENOR SALARIO'
FROM FUNCIONARIO
ORDER BY Salario ASC
--18 Conte quantos funcionários existem em cada departamento.
    SELECT COUNT(F.Pnome) AS 'QTD FUNCIONARIOS POR DP', D.Dnome
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
    GROUP BY D.Dnome -- poder agrupar por departamento
--19 Mostre a soma dos salários por departamento.
    SELECT SUM(F.Salario) AS 'SOMA DE SALARIOS POR DP', D.Dnome
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
    GROUP BY D.Dnome
--20 Mostre o maior salário de cada departamento.
    SELECT D.Dnome AS 'DEPARTAMENTO', MAX(F.Salario) AS 'MAIOR SALARIO'
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
    GROUP BY D.Dnome;
--21 Liste somente os departamentos que possuem mais de três funcionários usando HAVING.
    SELECT D.Dnome AS 'DEPARTAMENTO', COUNT(F.Pnome) AS 'QTD DE FUNCIONARIOS'
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
    GROUP BY D.Dnome
    HAVING COUNT(F.Pnome) > 3
--21 Liste os projetos que exigem pelo menos 50 horas no total.
    SELECT SUM(T.Horas) AS 'TOTAL DE HORAS', P.Projnome AS 'NOME PROJETO'
    FROM TRABALHA_EM AS T
    INNER JOIN PROJETO AS P
    ON t.Pnr = P.Projnumero
    GROUP BY P.Projnome
    HAVING SUM(T.Horas) >= 50

    -- Parte 3: JOINs
-- 22 Liste o nome, sobrenome e departamento de cada funcionário usando INNER JOIN.
    SELECT F.Pnome, F.Unome, D.Dnome
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
-- 23 Liste os funcionários que trabalham no departamento Pesquisa.
    SELECT F.Pnome AS 'PARTICIPA DP DE PESQUISA'
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
    WHERE D.Dnome = 'Pesquisa'
-- 24 Liste os funcionários que trabalham no projeto ProdutoX.
    SELECT F.Pnome AS 'PESSOAS', P.Projnome AS 'NOME PROJETO'
    FROM FUNCIONARIO AS F
    INNER JOIN TRABALHA_EM AS T
        ON T.Fcpf = f.cpf
    INNER JOIN PROJETO AS P
        ON T.Pnr = P.Projnumero
    WHERE P.Projnome = 'ProdutoX'
-- 25 Liste o número do projeto, departamento responsável, sobrenome e endereço do gerente para projetos localizados em Mauá.
    SELECT P.Projnumero AS 'NUMERO DEPARTAMENTO', D.Dnome AS 'NOME DO DP', F.Unome AS 'SOBRENOME', F.Endereco AS 'ENDERECO'
    FROM PROJETO AS P
    INNER JOIN DEPARTAMENTO AS D -- liga PROJETO com DEPARTAMENTO
        ON P.Dnum = D.Dnumero
    INNER JOIN FUNCIONARIO AS F -- liga departamento(DEPARTAMENTO) com gerente(FUNCIONARIO)
        ON D.Cpf_gerente = F.Cpf
    WHERE P.Projlocal = 'Mauá'
    

-- 26 Liste o sobrenome dos funcionários e o sobrenome dos seus respectivos supervisores. Use autorrelacionamento com a tabela FUNCIONARIO.
    SELECT F.Unome AS 'FUNCIONARIO', S.Unome AS 'SUPERVISOR RESPONSAVEL'
    FROM FUNCIONARIO AS F
    LEFT JOIN FUNCIONARIO AS S
        ON S.Cpf_supervisor = F.Cpf
-- 27 Liste os departamentos que não possuem funcionários associados usando LEFT JOIN.
    SELECT D.Dnome AS 'NAO POSSUEM FUNCIONARIOS'
    FROM DEPARTAMENTO AS D
    LEFT JOIN FUNCIONARIO AS F
        ON D.Dnumero = F.Dnr
    WHERE F.Pnome IS NULL
-- 28 Liste todos os funcionários, mesmo aqueles que não possuem departamento.
    SELECT f.Pnome AS 'Todos os funcionarios', D.Dnome AS 'NOME DEPARTAMENTO'
    FROM FUNCIONARIO AS F
    LEFT JOIN
    DEPARTAMENTO AS D
        ON F.Dnr = D.Dnumero

-- 29 Liste os funcionários que não possuem dependentes.
    SELECT F.Pnome AS 'FUNCIONARIOS SEM DEPENDENTES'
    FROM FUNCIONARIO AS F
    LEFT JOIN DEPENDENTE AS DP -- traz todos, nao precisa depender da tabela FUNCIONARIO como o INNER JOIN DEPENDE
    ON F.Cpf = DP.Fcpf
    WHERE DP.Fcpf IS NULL
-- 30 Liste o nome dos funcionários e seus dependentes.
    SELECT F.Pnome AS 'FUNCIONARIOS', Dp.Nome_dependente AS 'DEPENDENTE'
    FROM FUNCIONARIO AS F
    INNER JOIN DEPENDENTE AS DP --Agora precisa ser INNER, pq depende de quem é dependente de funcionario
    ON F.Cpf = DP.Fcpf
--31 Liste todas as cidades presentes em PROJETO ou LOCALIZACAO_DEP usando UNION.
    SELECT P.Projlocal AS 'CIDADE' FROM PROJETO AS P
    UNION
    SELECT L.Dlocal FROM LOCALIZACAO_DEP AS L

-- 32 Repita a questão anterior usando UNION ALL. Explique a diferença entre UNION e UNION ALL.
     SELECT P.Projlocal AS 'CIDADE' FROM PROJETO AS P
    UNION ALL
    SELECT L.Dlocal FROM LOCALIZACAO_DEP AS L
    -- a diferenca que o UNION remove duplicados, e o UNION ALL REPETE TODOS mantem todas as linhas da tabela
-- 33 Liste os funcionários que são gerentes usando INTERSECT.
 SELECT F.Pnome AS 'FUNCIONARIOS GERENTES'
 FROM FUNCIONARIO AS F
 WHERE F.Cpf IN
 (
 SELECT F.Cpf
    FROM FUNCIONARIO AS F
INTERSECT -- cruzar entre tabelas
 SELECT D.Cpf_gerente
    FROM DEPARTAMENTO AS D
 )

-- 34 Liste os funcionários que não são gerentes usando EXCEPT.
 SELECT F.Pnome AS 'FUNCIONARIOS NAO GERENTES'
 FROM FUNCIONARIO AS F
 WHERE F.Cpf IN
 (
 SELECT F.Cpf
    FROM FUNCIONARIO AS F
EXCEPT 
 SELECT D.Cpf_gerente
    FROM DEPARTAMENTO AS D --subtrai os CPFs que sao gerentes de Departamentos
 )
-- 35 Faça um FULL JOIN entre funcionários e departamentos e observe os registros sem correspondência.
    SELECT *
    FROM FUNCIONARIO AS F
    FULL JOIN DEPARTAMENTO AS DP
    ON F.Dnr = DP.Dnumero
    WHERE F.Cpf IS NULL -- trazer Departamentos vazioz - filtrar mais facil
    OR DP.Dnumero IS NULL -- traz funcionarios sem Departamento - filtrar facil
    -- !----------------------------------------------------------!
    -- OBSERVAÇÃO DOS REGISTROS !!!!!!!!
    -- RH , TI E VENDAS, nao possuem funcionarios nem supervisores por exemplo
    -- Carlos, Mariana e Pedro nao estao em nenhum departamento tambem
-- Parte 4: Subconsultas e operadores

-- 36 Liste os funcionários que trabalham em algum projeto que também possui o funcionário Fernando.
    SELECT DISTINCT f.Pnome
    FROM TRABALHA_EM AS T
    INNER JOIN FUNCIONARIO AS F
        ON T.Fcpf = F.cpf
    WHERE T.Pnr IN (
        -- Esse select mostra todos os DPs que funcionarios participam junto do fernando
        SELECT T2.pnr 
        FROM TRABALHA_EM AS T2
        WHERE T2.Fcpf = '33344555587'
        )AND T.Fcpf <> '33344555587'
    
-- 37 Liste os funcionários que ganham mais que qualquer funcionário do departamento Administração usando ANY.
    SELECT F.Pnome, F.Salario
    FROM FUNCIONARIO AS F
    WHERE F.Salario > ANY( --compara o salario com qualquer um dos valores retornados pela subconsulta
        SELECT FA.Salario
        FROM FUNCIONARIO AS FA
        INNER JOIN DEPARTAMENTO AS DP
            ON F.Dnr = DP.Dnumero
        WHERE DP.Dnome = 'Administração'
    );
-- 38 Liste os funcionários que ganham mais que todos os funcionários do departamento Administração usando ALL.
  SELECT F.Pnome, F.Salario
    FROM FUNCIONARIO AS F
    WHERE F.Salario > ALL( --mostra todos os funcionarios que ganham mais no DP de adm
        SELECT FA.Salario
        FROM FUNCIONARIO AS FA
        INNER JOIN DEPARTAMENTO AS DP
            ON F.Dnr = DP.Dnumero
        WHERE DP.Dnome = 'Administração'
    );
-- 39 Use EXISTS para listar os funcionários que são gerentes de algum departamento.
    SELECT CONCAT(F.Pnome, ' ', F.Unome) AS 'GERENTES DE DP', F.Salario, D.Dnome
    FROM FUNCIONARIO AS F
    INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
    WHERE EXISTS(
        SELECT F.Pnome
        FROM DEPARTAMENTO AS G
        WHERE F.Cpf = G.Cpf_gerente
    ) 
-- 40 Use EXISTS para listar os departamentos que possuem algum projeto                                                                                                                                                                                                                                                                                                                                          pelo menos um projeto.
  SELECT D.Dnome AS 'NOME DO DP', P.Projnome AS 'NOME PROJETO'
    FROM DEPARTAMENTO AS D
    INNER JOIN PROJETO AS P
        ON D.Dnumero = P.Dnum
    WHERE EXISTS(
        SELECT 1
        FROM PROJETO AS PJ
        WHERE D.Dnumero = PJ.Dnum
    ) 
-- 41 liste os funcionários que não trabalham em nenhum projeto usando NOT EXISTS.
    SELECT F.Pnome AS 'FUNCIONARIOS QUE NAO TRABALHAM EM NENHUM PROJETO'
    FROM FUNCIONARIO AS F
    WHERE NOT EXISTS(
        SELECT 1
        FROM TRABALHA_EM AS T
        WHERE T.Fcpf = F.Cpf -- onde nao existe um cpf de trabalha_em vinculado a funcionario
    )
-- Parte 5: Variáveis, IF/ELSE e WHILE
-- 42 Declare variáveis para armazenar nome, idade, data e salário. Preencha os valores e exiba-os com SELECT.
DECLARE @nome VARCHAR(50), @idade INT, @data DATE, @salario DECIMAL(10,2) 
SET @nome = 'Leonardo'
SET @idade = 20
SET @data = GETDATE()
SET @salario = 2000.00
SELECT CONCAT ('NOME: ', @nome, ' IDADE: ', @idade, ' DATA DE HOJE: ', @data, ' SALARIO: ', @salario) AS 'MEUS DADOS DE VARIAVEIS'

-- 43 Busque o nome do departamento de número 4, armazene em uma variável e mostre o valor com PRINT.
    SELECT *
    FROM DEPARTAMENTO AS D
    DECLARE @nome_dp VARCHAR(50) 
    SET @nome_dp = 'Administração'
    PRINT @nome_dp;

-- 44 Calcule um aumento de 10% para o funcionário Jennifer sem alterar o salário no banco.
    DECLARE @salario_atual DECIMAL(10,2); 
    DECLARE @salario_aumento DECIMAL(10,2); 

    SELECT @salario_atual = F.Salario
    FROM FUNCIONARIO AS F
    WHERE F.Pnome = 'Jennifer'
    SET @salario_atual = @salario_aumento * 1.10 
    PRINT CONCAT('SALARIO COM AUMENTO: ', @salario_aumento)

    --caso eu usasse UPDATE
    BEGIN TRANSACTION;

    UPDATE FUNCIONARIO
    SET Salario = Salario * 1.10
    WHERE Pnome = 'Jennifer';

    SELECT Pnome, Salario
    FROM FUNCIONARIO
    WHERE Pnome = 'Jennifer';

    ROLLBACK;
-- 45 Calcule a média salarial e informe, 
-- usando IF/ELSE, 
-- se o salário de um funcionário está acima ou abaixo da média.
    DECLARE  @mediaSalarial DECIMAL(10,2)
    SELECT @mediaSalarial = AVG(Salario)
    FROM FUNCIONARIO
    PRINT @mediaSalarial
   SELECT Pnome AS 'NOME FUNCIONARIO', Salario,
    CASE
        WHEN Salario > @mediaSalarial THEN 'Salário acima da média'
        ELSE 'Salário abaixo ou igual à média'
    END AS Classificacao
FROM FUNCIONARIO;
-- 46 Verifique se o funcionário Ana recebeu bônus. Considere que bônus NULL ou menor ou igual a zero significa que não recebeu.
    DECLARE @recebeu_bonus DECIMAL(10,2)
    
    SELECT @recebeu_bonus = F.Bonus
    FROM FUNCIONARIO AS F
    WHERE F.Pnome = 'Ana'
    PRINT @recebeu_bonus
    IF(@recebeu_bonus IS NULL OR @recebeu_bonus <= 0)
        PRINT 'NUNCA RECEBEU BONUS'
    ELSE
        PRINT 'JA RECEBEU BONUS'
-- 47 Use IIF para classificar os funcionários em:
-- Ganha Muito, para salário maior ou igual a 30000;
-- Ganha Pouco, nos demais casos.
    SELECT F.Pnome, F.Salario, F.Unome,
    IIF(F.Salario >= 30000, 'Ganha Muito', 'Ganha Pouco') AS 'CLASSIFICACAO'
    FROM FUNCIONARIO AS F
    ORDER BY F.Pnome
-- Use CASE para classificar os salários:
-- até 8000: Baixo;
-- entre 8000 e 30000: Médio;
-- maior ou igual a 30000: Alto.
   SELECT
    CONCAT(F.Pnome,' ', F.Unome) AS 'NOME COMPLETO',
    F.Salario,
    CASE
        WHEN F.Salario <= 8000 THEN 'Baixo'
        WHEN F.Salario < 30000 THEN 'Medio'
        ELSE 'Alto'
    END AS CLASSIFICACAO
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC;
-- Crie um contador usando WHILE que imprima os números de 1 até 10.
DECLARE @cont INT = 1;

WHILE @cont <= 10
BEGIN
    PRINT CAST(@cont AS VARCHAR)
    SET @cont = @cont + 1
END