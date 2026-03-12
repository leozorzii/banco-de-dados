-- Criar e usar o banco
CREATE DATABASE faculdade;
USE faculdade;

-- Tabela de alunos
CREATE TABLE aluno (
    numeroAluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    curso VARCHAR(100),
    tipoAluno INT
);


INSERT INTO aluno (numero_aluno, nome, curso, tipo_aluno) VALUES
    (17, 'fwasdf', 'cc', 1),
    (18, 'leonardo', 'cc', 2),
    (19, 'zorzi', 'si', 2);

CREATE TABLE disciplina (
    numeroDisciplina INT PRIMARY KEY,
    nomeDisciplina VARCHAR(100),
    creditos INT,
    departamento VARCHAR(20)
);
INSERT INTO disciplina (numeroDisciplina, nomeDisciplina, creditos, departamento) VALUES
    (1310, 'Introd. a ciência da computação', 4, 'cc'),
    (3320, 'Estruturas de dados', 4, 'cc'),
    (2410, 'Matemática discreta', 3, 'mat'),
    (3380, 'Banco de dados', 3, 'cc'),
    (3018, 'Projeto a banco de dados', 3, 'g03');

-- Tabela de pré-requisitos
CREATE TABLE preRequisito (
    numeroDisciplina INT,
    numeroPreRequisito INT,
    PRIMARY KEY (numeroDisciplina, numeroPreRequisito),
    FOREIGN KEY (numeroDisciplina) REFERENCES disciplina(numeroDisciplina),
    FOREIGN KEY (numeroPreRequisito) REFERENCES disciplina(numeroDisciplina)
);

INSERT INTO preRequisito (numeroDisciplina, numeroPreRequisito) VALUES
    (3320, 1310),
    (3380, 2410),
    (3018, 3380);

CREATE TABLE turma (
    identificacaoTurma INT AUTO_INCREMENT PRIMARY KEY,
    numeroDisciplina INT, 
    semestre VARCHAR(20),f
    ano INT,
    professor VARCHAR(100),
    FOREIGN KEY (numeroDisciplina) REFERENCES disciplina(numeroDisciplina)
);

-- Inserir turmas
INSERT INTO turma (numeroDisciplina, semestre, ano, professor) VALUES
    (2410, 'segundo', 2007, 'Messi'),
    (1310, 'segundo', 2007, 'Anderson'),
    (3320, 'primeiro', 2008, 'Carlos'),
    (2410, 'segundo', 2008, 'Chang'),
    (1310, 'segundo', 2008, 'Norlan'),
    (3380, 'segundo', 2008, 'Londero'),
    (3018, 'sexto', 2008, 'Herysson');

-- Tabela de histórico escolar
CREATE TABLE historicoEscolar (
    historicoId INT AUTO_INCREMENT PRIMARY KEY,
    numeroAluno INT,
    identificacaoTurma INT,
    nota VARCHAR(1),
    FOREIGN KEY (numeroAluno) REFERENCES aluno(numeroAluno),
    FOREIGN KEY (identificacaoTurma) REFERENCES turma(identificacaoTurma)
);

-- Inserir histórico escolar
INSERT INTO historicoEscolar (numeroAluno, identificacaoTurma, nota) VALUES
    (17, 4, 7.5),
    (17, 5, 3.5),
    (18, 1, 4.5),
    (18, 2, 9.5),
    (18, 3, 10),
    (18, 6, 4.5),
    (18, 7, 8.5);

-- Testes solicitados na parte final:

-- A) Tentativa de inserir aluno com número duplicado — ERRO intencional para teste
-- INSERT INTO aluno (numeroAluno, nome, tipoAluno, curso) VALUES (17, 'Juca', 2, 'cc');

-- B) Tentativa de histórico com aluno que não existe — ERRO intencional para teste
-- INSERT INTO historico_escolar (numeroAluno, identificacaoTurma, nota) VALUES (99, 4, 'A');

-- C) Atualizar créditos de disciplina com valor negativo — permitido, mas ilógico
UPDATE disciplina SET creditos = -3 WHERE numeroDisciplina = 1310;

-- D) Deletar disciplina (irá falhar se houver dependências via chave estrangeira)
-- DELETE FROM disciplina WHERE numeroDisciplina = 1310;
