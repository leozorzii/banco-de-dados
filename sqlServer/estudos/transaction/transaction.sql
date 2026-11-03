USE EMPRESA;

-- Exercícios de TRANSACTION - banco EMPRESA
-- Dica geral: antes e depois de cada exercício, faça um SELECT nas tabelas
-- envolvidas para conferir se a mudança aconteceu (ou se foi desfeita).
-- Comandos: BEGIN TRANSACTION / COMMIT / ROLLBACK / SAVE TRANSACTION
--           BEGIN TRY ... END TRY / BEGIN CATCH ... END CATCH
--           @@ROWCOUNT (linhas afetadas pelo último comando)
--           @@TRANCOUNT (quantas transações estão abertas)


-- 1- Abra uma transação, aumente em 10% o salário de todos os funcionários
-- do departamento 5 (Pesquisa), faça um SELECT para ver os novos salários
-- e depois dê ROLLBACK. Confira com outro SELECT que os salários voltaram ao normal.
GO
BEGIN TRANSACTION
UPDATE FUNCIONARIO
SET Salario = Salario * 1.10
WHERE Dnr = 5
PRINT 'Salarios atualizados'

ROLLBACK TRANSACTION;
GO


SELECT *
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE Dnr = 5



-- 2- Faça uma transação que transfira o funcionário 'Joice Leite' (Cpf 45345345376)
-- do departamento 5 para o departamento 8 (TI) e, na mesma transação,
-- torne-a gerente do departamento 8 (Cpf_gerente e Data_inicio_gerente = hoje).
-- As duas alterações devem acontecer juntas ou nenhuma. Finalize com COMMIT.
GO
BEGIN TRANSACTION
UPDATE FUNCIONARIO
SET Dnr = 8
WHERE Cpf = '45345345376'

UPDATE DEPARTAMENTO
SET Cpf_gerente = '45345345376', Data_inicio_gerente = GETDATE()
WHERE Dnumero = 8

COMMIT;

GO
SELECT F.Pnome, Data_inicio_gerente
FROM DEPARTAMENTO AS D
INNER JOIN FUNCIONARIO AS F
ON D.Dnumero = F.Dnr
WHERE Cpf = '45345345376'


-- 3- Usando uma variável @cpf, faça uma transação que dê um bônus de 2000
-- ao funcionário. Antes de atualizar, verifique com IF EXISTS se o Cpf existe:
-- se não existir, faça ROLLBACK e PRINT 'Funcionário não encontrado';
-- se existir, faça o UPDATE, COMMIT e PRINT 'Bônus aplicado'.
-- Teste com um Cpf que existe e com um que não existe.
GO
BEGIN TRANSACTION
DECLARE @cpf VARCHAR(11)
SET @cpf = '2422324234233'
IF EXISTS(SELECT 1 FROM FUNCIONARIO WHERE Cpf = @cpf)
BEGIN
    UPDATE FUNCIONARIO
    SET Salario = Salario + 2000
    WHERE Cpf = @cpf
    PRINT 'Bonus aplicado'
    COMMIT TRAN;
END
ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Funcionario nao encontrado'
    END
GO



-- 4- Encontre o erro: no exemplo bancário da aula 08 (Transactions-Aula.sql),
-- quando o saldo é insuficiente o código faz ROLLBACK, mas os UPDATEs
-- continuam executando depois. Por quê? Reescreva a lógica abaixo,
-- usando as tabelas do EMPRESA: transfira 5 horas do funcionário
-- '12345678966' do projeto 1 para o projeto 2, mas só se ele tiver
-- pelo menos 5 horas no projeto 1. Use IF/ELSE corretamente.



-- 5- Tente excluir o departamento 5 (Pesquisa) dentro de uma transação
-- com BEGIN TRY / BEGIN CATCH. Vai dar erro de FOREIGN KEY (há funcionários
-- e projetos ligados a ele). No CATCH, faça ROLLBACK e mostre
-- ERROR_MESSAGE() com PRINT. Explique nos comentários por que deu erro.
GO
BEGIN TRANSACTION
BEGIN TRY
    DELETE DEPARTAMENTO
    WHERE Dnumero = 5
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE() 
    END CATCH
GO
--JUSTIFICATIVA: deu erro por que a tabela DEPARTAMENTO tem funcionarios e projetos ligados a ela, por isso nao se pode deletar.
--devido a FOREIGN KEY DE AMBOS




-- 6- Faça uma transação que exclua o funcionário 'João Silva' (Cpf 12345678966)
-- por completo. Para isso, apague antes os registros que dependem dele
-- (DEPENDENTE e TRABALHA_EM) e só depois o FUNCIONARIO. Use TRY/CATCH:
-- se qualquer DELETE falhar, nada deve ser apagado.
-- (Teste com ROLLBACK no final em vez de COMMIT, para não perder os dados.)



-- 7- Use SAVE TRANSACTION: abra uma transação, aumente em 5% o salário
-- de todo mundo, crie um ponto de salvamento chamado 'aumento_geral',
-- depois zere o Bonus de todos. Volte só até o ponto de salvamento
-- (ROLLBACK TRANSACTION aumento_geral) e dê COMMIT.
-- Qual das duas alterações ficou valendo? Confira com SELECT.



-- 8- Faça um UPDATE dentro de uma transação que mude o salário de um
-- funcionário pelo Cpf. Use @@ROWCOUNT logo depois do UPDATE:
-- se nenhuma linha foi afetada (Cpf errado), faça ROLLBACK e avise;
-- se foi exatamente 1, faça COMMIT.



-- 9- Crie uma PROCEDURE usp_transferir_funcionario (@cpf, @novo_dnr)
-- que, dentro de uma transação com TRY/CATCH:
--   - verifique se o funcionário existe e se o departamento de destino existe;
--   - não permita transferir quem é gerente de algum departamento
--     (Cpf aparece em DEPARTAMENTO.Cpf_gerente);
--   - se tudo ok, atualize o Dnr e faça COMMIT; senão ROLLBACK com mensagem.
-- Teste com: um caso válido, um departamento que não existe e um gerente.



-- 10- Desafio: crie uma PROCEDURE usp_reajuste_departamento (@dnr, @percentual)
-- que aplique o reajuste a todos do departamento, mas com uma regra:
-- se, após o reajuste, a soma dos salários do departamento passar de 200000,
-- desfaça tudo (ROLLBACK) e mostre a soma que teria ficado.
-- Dica: faça o UPDATE primeiro e verifique a soma dentro da transação.
