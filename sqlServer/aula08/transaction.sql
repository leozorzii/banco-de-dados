-- 1 - Autocommit × Transação Explícita Tarefa: Insira dois departamentos: um em modo autocommit e outro dentro de uma transação explícita. 
-- Em seguida, desfaça o segundo (Rollback) e confirme o primeiro. 
-- Entregável: Demonstre, por consulta, qual linha permaneceu e explique por quê.

USE EMPRESA;
--auto commit
INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
VALUES (10, 'Logística', NULL, NULL);

BEGIN TRANSACTION;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
VALUES (11, 'Notas', NULL, NULL);

ROLLBACK TRANSACTION;

SELECT * FROM DEPARTAMENTO WHERE Dnumero IN (10, 11);
--somente permaneceu o dp de Logistica que criamos agora via auto commit, a transaction por usar o rollback, retorna aquela ao estado de origem, antes do insert INTO
-- ou seja, com autocommit nao tem como desfazer, ja transaction sim, so dar um rollback e esta salvo

-- 2 - SAVEPOINT e ROLLBACK Parcial Tarefa: Dentro de uma única transação, insira dois departamentos.
-- Crie um SAVEPOINT após o primeiro insert e faça ROLLBACK para o savepoint (mantendo o primeiro e desfazendo o segundo). 
-- Entregável: Evidencie que apenas o primeiro persiste após COMMIT.

BEGIN TRANSACTION;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
VALUES (9, 'looksmaxing', NULL, NULL);

-- SAVEPOINT
SAVE TRANSACTION ponto_save;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
VALUES (18, 'Agua', NULL, NULL);

-- Reverte a transação ate o Savepoint
ROLLBACK TRANSACTION ponto_save;

-- confirmar a transaction
COMMIT TRANSACTION;

SELECT * FROM DEPARTAMENTO WHERE Dnumero IN (9, 18);


-- 5 Operação Composta: INSERT + UPDATE (Tudo-ou-Nada) Tarefa: Em uma única transação, 
-- crie um novo departamento e realoque um funcionário para esse departamento. 
-- Ao final, decida entre COMMIT ou ROLLBACK (tudo deve persistir ou nada). 
-- Entregável: Comprove atomicidade: se desfizer, nem o depto novo nem a realocação devem permanecer.

BEGIN TRANSACTION;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
VALUES (30, 'IA', NULL, NULL);

UPDATE FUNCIONARIO
SET Dnr = 30
WHERE Cpf = '12345678966'--joao

-- escolha 1: Desfazer tudo (Comprova a Atomicidade)
-- ROLLBACK TRANSACTION;
-- PRINT 'Transacao revertida!!!!!!! Nenhuma alteracao foi salva';


-- Escolha 2: Confirmar tudo
 COMMIT TRANSACTION;
 PRINT 'Transação confirmada com sucesso!';

-- consultar caso 'confirmar tudo'
 SELECT F.Pnome, D.Dnome
 FROM FUNCIONARIO AS F
 INNER JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
 WHERE F.Cpf = '12345678966'
