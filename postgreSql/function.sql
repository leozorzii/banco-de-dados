-- indice acelera consulta de dados
-- atalho pra localizar registros sem andar por toda tabela(para altos volumes de dados)
-- Atividade Prática
-- Crie uma tabela chamada clientes com os campos: id, nome, email.
-- Crie um índice sobre o campo email.
-- Crie uma function chamada mascarar_email que retorna apenas o domínio do e-mail.
-- Exemplo: fabiano@gmail.com -- gmail.com.
-- Crie uma tabela chamada auditoria com os campos: id, acao, data.
-- Crie um trigger que insira na tabela de auditoria uma linha sempre que um novo cliente for inserido.
-- Teste inserindo alguns clientes e verifique:
-- Se o índice acelera buscas por email.
-- Se a função retorna corretamente o domínio.
-- Se o trigger registra a ação na auditoria.
-- Utilizando postgreSQL


CREATE TABLE clientes(
id_cliente SERIAL PRIMARY KEY,
nome VARCHAR(100),
email VARCHAR(100)
)
CREATE TABLE auditoria(
id_auditoria SERIAL PRIMARY KEY,
acao VARCHAR(50),
data TIMESTAMP
)

CREATE INDEX idx_cliente_email ON clientes(email)

CREATE OR REPLACE FUNCTION mascarar_email(emailMascarado VARCHAR(50))
RETURNS VARCHAR(50)
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN SPLIT_PART(emailMascarado, '@', 2); -- funcao que retira o que vem apos a parametro escolhido, como por ex: '@'
	END;
   $$;

CREATE OR REPLACE FUNCTION fn_auditacao_cliente() -- contem toda a logica
	RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
	BEGIN
		INSERT INTO auditoria(acao, data) VALUES ('cliente ' || NEW.nome || ' cadastrado', NOW());
		RETURN NEW; -- nova linha que esta sendo inserida
	END;
   $$;
CREATE TRIGGER get_auditar_cliente -- define quando a funcao vai ser chamada
AFTER INSERT ON clientes
FOR EACH ROW
EXECUTE FUNCTION fn_auditacao_cliente();


-- testes de inserção de clientes
INSERT INTO clientes (nome, email) VALUES ('Leo', 'leo@gmail.com');
INSERT INTO clientes (nome, email) VALUES ('João', 'joao@hotmail.com');
-- testando se o trigger registrou na auditoria
SELECT * FROM auditoria;
-- teste da function
SELECT mascarar_email('leo@gmail.com');
SELECT mascarar_email('joao@hotmail.com');



