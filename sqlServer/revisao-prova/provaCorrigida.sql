-- liste o nome dos alunos matriculados na disciplina de "banco de dados I", apresentando tambem a nota, o semestre e o ano da respectiva turma
SELECT A.Nome, H.Nota, T.Semestre, T.Ano, D.Nome_disciplina 
FROM ALUNO AS A
INNER JOIN HISTORICO_ESCOLAR AS H
	ON A.Numero_aluno = H.Numero_aluno 
INNER JOIN TURMA AS T
	ON H.Identificacao_turma = T.Identificacao_turma
INNER JOIN DISCIPLINA AS D
	ON T.Numero_disciplina = D.Numero_disciplina
WHERE D.Nome_disciplina = 'Banco de Dados I'
-- 2  Lista os alunos reprovados por frequencia, considerando frequencia inferior a 75%, mostre
-- nome do aluno, a disciplina, o semestre, o ano, e a frequencia.
-- ordene o resultado do menor para a maior frequencia
SELECT A.Nome, D.Nome_disciplina,T.Ano, T.Semestre, H.Frequencia
FROM ALUNO AS A
INNER JOIN HISTORICO_ESCOLAR AS H
	ON A.Numero_aluno = h.Numero_aluno
INNER JOIN TURMA AS T
	ON A.Numero_aluno = H.Numero_aluno
INNER JOIN DISCIPLINA AS D
	ON T.Numero_disciplina = D.Numero_disciplina
WHERE H.Frequencia < 75
ORDER BY H.Frequencia DESC
-- mais de uma disciplina reprovada por frequencia para cada aluno listado

-- 3 Liste todas as turmas e a quantidade de alunos matriculados em cada uma. Apresente a identificação da turma
-- o nome da disciplina, o semestre, o ano e o total de alunos
-- a consulta deve incluir tambem as turmas que nao possuem alunos matriculados.
SELECT D.Nome_disciplina AS 'NOME DISCIPLINAS', t.Identificacao_turma AS 'NUMERO TURMA', t.Semestre AS 'SEMESTRE', T.Ano AS 'ANO', COUNT(H.Numero_aluno) AS 'QTD ALUNOS'
FROM TURMA AS T
INNER JOIN DISCIPLINA AS D
	ON T.Numero_disciplina = D.Numero_disciplina 
LEFT JOIN HISTORICO_ESCOLAR AS H
	ON h.Identificacao_turma = T.Identificacao_turma
GROUP BY D.Nome_disciplina, T.Identificacao_turma, T.Semestre, T.Ano;

-- 4 criar uma funcao escalar dbo.fn_Situacao aluno, que receba a nota e a frequencia do aluno e retorne a situacao academica
GO
CREATE OR ALTER FUNCTION dbo.fn_Situacao_aluno(@nota DECIMAL(10,2), @frequencia DECIMAL(5,2))
RETURNS VARCHAR(50)
AS
BEGIN
		IF(@nota IS NULL OR @frequencia IS NULL)
			RETURN 'EM ANDAMENTO'
		IF(@frequencia < 75)
			RETURN 'REPROVADO POR FREQUENCIA'
		IF(@frequencia >= 75 AND @nota >= 7 )
			RETURN 'APROVADO'
		IF(@frequencia >= 75 AND @nota >=5 AND @nota <= 6.99)
			RETURN 'EM RECUPERACAO'
	RETURN 'Reprovado por nota'
END;
GO
--depois escreva uma consulta que liste o aluno, disciplina, nota, frequencia e situacao para todos os registros no banco
SELECT dbo.fn_Situacao_aluno(8.0, 90) AS EXEMPLO1;
SELECT dbo.fn_Situacao_aluno(6.0, 90) AS EXEMPLO2;
SELECT dbo.fn_Situacao_aluno(4.0, 90) AS EXEMPLO3;
SELECT dbo.fn_Situacao_aluno(9.0, 90) AS EXEMPLO4;
SELECT dbo.fn_Situacao_aluno(NULL, NULL) AS EXEMPLO5;

-- 5 crie uma funcao escalar chamada dbo.fn_ConverterNotaConceito que recebe uma nota numerica e retorna o conceito correspondente
	GO
	CREATE OR ALTER FUNCTION fn_ConverterNotaConceito(@nota DECIMAL(10,2))
	RETURNS VARCHAR(50)
	AS 
	BEGIN
		IF(@nota >= 9 AND @nota <=10)
			RETURN 'CONCEITO A'
		IF(@nota >= 7 AND @nota <= 8.99)
			RETURN 'CONCEITO B'
		IF(@nota >=5 AND @nota <=6.99)
			RETURN 'CONCEITO C'
		IF(@nota < 5)
		RETURN 'CONCEITO D'
		
		RETURN 'Sem Nota'
	END
	GO
	SELECT dbo.fn_ConverterNotaConceito(9.5) AS EXEMPLO1
	SELECT dbo.fn_ConverterNotaConceito(7.5) AS EXEMPLO2
	SELECT dbo.fn_ConverterNotaConceito(6.5) AS EXEMPLO3
	SELECT dbo.fn_ConverterNotaConceito(4.5) AS EXEMPLO4
	SELECT dbo.fn_ConverterNotaConceito(8.5) AS EXEMPLO5

	--6 Crie um procedimento armazenado chamado dbo.usp_ListarAlunosPorCurso que receba a sigla de um curso como parametro e apresente o numero e o nome dos alunos
-- pertencentes ao curso informado. Ordene o resultado pelo nome do aluno. Depois, execute o procedimento para listar os alunos do curso de Ciencia da Computacao, identificado pela sigla CC
GO
CREATE OR ALTER PROCEDURE sp_listarAlunosPorCurso @sigla NVARCHAR(5)
AS
BEGIN
	SELECT A.Numero_aluno, A.Nome, A.Curso 
	FROM ALUNO AS A
	WHERE a.Curso = @sigla
	ORDER BY A.Nome
END
GO

EXEC sp_listarAlunosPorCurso @sigla = 'CC'
EXEC sp_listarAlunosPorCurso @sigla = 'SI'

-- 7 crie um procedimento armazenado que receba com parametros o codigo, nome, e a qtd de creditos e o departamento de uma nova disciplina
-- o procedimento devera
-- verificar se ja existe uma disciplina com o mesmo codigo
-- impedir cadastro de duas disciplinas com o mesmo nome
-- validar se a quantidade de creditos eh maior que zero
-- cadastrar disciplina quando os dados forem validos
-- exibir uma mensagem informando o sucesso ou motivo da falha no cadastro.

-- ao final execute um procedimento para cadastrar uma nova disciplina.
GO
CREATE OR ALTER PROCEDURE sp_CadastrarDisciplina @codigo VARCHAR(50), @nome VARCHAR(50), @qtd_creditos INT ,@departamento VARCHAR(50)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM DISCIPLINA AS D WHERE D.Numero_disciplina = @codigo)
		BEGIN
			PRINT 'Ja existe uma disciplina com esse CODIGO'
			RETURN;
		END
	IF EXISTS(SELECT 1 FROM DISCIPLINA AS D WHERE D.Nome_disciplina = @nome)
		BEGIN
			PRINT 'ja existe uma disciplina com esse NOME'
			RETURN;
		END
	IF NOT(@qtd_creditos > 0)
		BEGIN
			PRINT 'quantidade de creditos deve ser maior que zero'
			RETURN;
		END

	INSERT INTO DISCIPLINA(Numero_disciplina, Nome_disciplina, Creditos, Departamento)
	VALUES (@codigo, @nome, @qtd_creditos, @departamento);
	PRINT 'SUCESSO AO CADASTRAR DISCIPLINA!'
END
GO

	EXEC sp_CadastrarDisciplina @codigo = 'ABC425', @nome = 'Eletronica', @qtd_creditos = 0, @departamento = '4'

