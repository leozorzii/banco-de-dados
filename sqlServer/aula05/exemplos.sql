-- Having
SELECT COUNT(f.Pnome) as 'qtd', DP.Dnome as 'Nome do Departamento'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS DP
ON F.Dnr = DP.Dnumero
GROUP BY dp.Dnome
HAVING COUNT(F.Pnome) > 3
ORDER BY dp.Dnome

-- listar projetos que exigem no minimo 50 horas no total
SELECT SUM(T.Horas) as 'qtd', P.Projnome
FROM TRABALHA_EM T
JOIN PROJETO as P
ON T.Pnr = P.Projnumero
GROUP BY P.Projnome
HAVING SUM(T.Horas) >= 50
ORDER BY 'qtd'


-- Exists
-- listar funcionarios que sao gerentes de algum departamento
SELECT F.Pnome, f.Unome, Cpf 
FROM FUNCIONARIO AS F
WHERE 
	EXISTS(
		SELECT 1
		FROM DEPARTAMENTO AS DP 
		WHERE DP.Cpf_gerente = F.Cpf -- me retorna 1 caso esse cara seja gerente de um DP
	);

--listar departamentos que possuem projetos associados
SELECT *
FROM DEPARTAMENTO AS D
WHERE
	EXISTS(
	SELECT 1
	FROM PROJETO AS P
	WHERE D.Dnumero = P.Dnum
	);

--ANY
-- encontrar os funcionarios que ganhem mais do que qualquer funcionario do departamento de 'Administração'
SELECT F.Pnome
FROM FUNCIONARIO AS F
WHERE f.Salario > 
ANY(
	SELECT F.Salario
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
	WHERE D.Dnome = 'Administração'
) AND Dnr <> 4

-- ALL
-- encontrar projetos que exigem mais horas do que todos os projetos no local de 'São Paulo'
SELECT Projnome, SUM(Horas) AS 'HORAS'
FROM PROJETO 
JOIN TRABALHA_EM
ON Pnr = Projnumero
GROUP BY Projnumero, Projnome
HAVING SUM(Horas) > ALL
(
	SELECT SUM(T.Horas)
	FROM PROJETO AS P
	JOIN TRABALHA_EM AS t
	ON T.Pnr = P.Projnumero 
	WHERE p.Projlocal = 'São Paulo'
	GROUP BY P.Projnome
);








