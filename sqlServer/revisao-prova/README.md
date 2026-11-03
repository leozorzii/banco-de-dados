# Prova de Banco de Dados — Planner, Resumo e Exercícios (SQL Server)

> 31 de out. de 2026 · @Projetos Agrocash

## Sumário

1. [Como a prova funciona e a estratégia](#1-como-a-prova-funciona-e-a-estratégia)
2. [Planner de estudos (7 dias)](#2-planner-de-estudos-7-dias-2h-por-dia)
3. [Resumo teórico](#3-resumo-teórico)
4. [Colinha — FRENTE (moldes de código)](#4-colinha--frente-moldes-de-código)
5. [Colinha — VERSO (teoria, pegadinhas e inglês)](#5-colinha--verso-teoria-pegadinhas-e-inglês)
6. [Exercícios de VIEW resolvidos (MICROSOFT / Northwind)](#6-exercícios-de-view-resolvidos-banco-microsoft--northwind)
7. [Exercícios de TRIGGER resolvidos (BIBLIOTECA)](#7-exercícios-de-trigger-resolvidos-banco-biblioteca)
8. [Prática extra em bancos diferentes](#8-prática-extra-em-bancos-diferentes)
9. [Roteiro para o banco do pendrive](#9-roteiro-para-o-banco-do-pendrive)

---

## 1. Como a prova funciona e a estratégia

A prova tem três partes: múltipla escolha teórica, questões práticas num banco novo entregue por pendrive e uma questão extra em inglês. A estratégia é dominar a sintaxe de cor nos dias de treino e deixar na colinha só o que você costuma esquecer.

| Parte | O que cai | Como garantir os pontos |
|---|---|---|
| Teórica (múltipla escolha) | ACID, AFTER × INSTEAD OF, inserted/deleted, o que uma view guarda, tipos de integridade, GRANT × DENY × REVOKE, LOGIN × USER | Verso da colinha com as "pegadinhas"; refazer as perguntas de revisão da seção 3 |
| Prática (banco novo) | Criar views, triggers, transações com TRY/CATCH, constraints e permissões num esquema desconhecido | Frente da colinha com moldes prontos; seguir o roteiro da seção 9 nos primeiros 5 minutos |
| Inglês (extra) | Afirmativa sobre um dos conceitos, escrita em inglês | Glossário inglês → português no verso da colinha |

O material de referência é o repositório da disciplina (Aulas 06, 07, 08, 09 e 11). O professor usa `RAISERROR(..., 16, 1)` + `ROLLBACK TRANSACTION` nos triggers, `EXECUTE AS USER` / `REVERT` para testar permissões e `TRY...CATCH` com `XACT_STATE()` nas transações: escreva no mesmo estilo.

---

## 2. Planner de estudos (7 dias, ~2h por dia)

Cada tema é estudado num banco e praticado em outro, para treinar exatamente o que a prova cobra: aplicar o conceito num esquema que você não conhece. Se faltar menos de uma semana, junte os dias 1+2, 3+4 e 5+6.

| Dia | Tema | Estudo (40 min) | Prática (80 min) | Banco de prática |
|---|---|---|---|---|
| 1 | Views | Seção 3 (views) + Aula 09 | As 6 views da seção 6, sem olhar a resposta | MICROSOFT (Northwind) |
| 2 | Restrições de integridade | Seção 3 (integridade) + Aula 08 | Bloco B da seção 8: criar, violar de propósito e ler a mensagem de erro | PAPELARIA ou banco criado do zero |
| 3 | Transações | Seção 3 (transações) + Aula 06 | Bloco A da seção 8 + exercícios 1 a 6 da Aula 06 | EMPRESA |
| 4 | Triggers I | Seção 3 (triggers) + Aula 07 | Triggers 1 a 9 da seção 7 | BIBLIOTECA |
| 5 | Triggers II | Revisar inserted/deleted e multi-linha | Triggers 10 a 18 da seção 7 + 3 triggers do bloco D | BIBLIOTECA e MICROSOFT |
| 6 | Gerenciamento de acesso | Seção 3 (acesso) + Aula 11 | Bloco C da seção 8, testando cada permissão com `EXECUTE AS USER` | FACULDADE ou AULA08_LOJA |
| 7 | Simulado + colinha | Montar a colinha à mão a partir das seções 4 e 5 | Simulado de 2h: bloco E da seção 8 com cronômetro, num banco que você ainda não usou | FACULDADE_2 ou EMPRESA_2026 |

**Regras do treino:**

- Escreva cada comando sem consultar nada; só depois compare com a resposta.
- Teste sempre o caso que deve falhar (insert duplicado, delete proibido, usuário sem permissão). Na prova o professor corrige pelo comportamento.
- Anote num papel à parte cada erro que você cometeu duas vezes. Essa lista vira o conteúdo da colinha no dia 7.

**Checklist da semana:**

- [ ] Dia 1 — 6 views no MICROSOFT
- [ ] Dia 2 — constraints criadas e violadas
- [ ] Dia 3 — transações com SAVE TRANSACTION e TRY/CATCH
- [ ] Dia 4 — triggers 1 a 9
- [ ] Dia 5 — triggers 10 a 18 + extras
- [ ] Dia 6 — login, user, role, GRANT/DENY/REVOKE testados
- [ ] Dia 7 — simulado cronometrado + colinha escrita

---

## 3. Resumo teórico

Cinco temas, cada um com o que você precisa saber explicar e o que costuma virar alternativa errada na múltipla escolha.

### Transações

Uma transação é um conjunto de comandos tratado como unidade: ou tudo é gravado (`COMMIT`) ou nada é (`ROLLBACK`). Sem `BEGIN TRAN`, o SQL Server trabalha em **autocommit**: cada comando é uma transação sozinho.

| Propriedade ACID | Significado | Exemplo |
|---|---|---|
| Atomicidade | Tudo ou nada | Transferência: débito e crédito juntos |
| Consistência | Sai de um estado válido para outro válido, respeitando PK, FK, CHECK | FK inexistente faz a transação falhar |
| Isolamento | Uma transação não enxerga o trabalho incompleto da outra | `SET TRANSACTION ISOLATION LEVEL SERIALIZABLE` |
| Durabilidade | Depois do COMMIT, sobrevive a queda do servidor | Log de transações |

- `SAVE TRANSACTION nome` cria um ponto de salvamento; `ROLLBACK TRANSACTION nome` desfaz só até ele, e a transação continua aberta até o `COMMIT`.
- `ROLLBACK` sem nome desfaz tudo, mesmo com savepoints.
- `@@ERROR` vale só para o comando imediatamente anterior; `@@TRANCOUNT` mostra quantas transações estão abertas.
- `XACT_STATE()`: `1` = transação ativa e comitável; `-1` = incomitável, só ROLLBACK; `0` = nenhuma transação.
- `SET XACT_ABORT ON` faz a maioria dos erros de execução abortar e reverter a transação inteira.
- Níveis de isolamento, do mais fraco ao mais forte: `READ UNCOMMITTED` (permite leitura suja), `READ COMMITTED` (padrão do SQL Server), `REPEATABLE READ`, `SERIALIZABLE` (impede leitura fantasma). Também existe `SNAPSHOT`.
- Problemas de concorrência: leitura suja (lê dado não confirmado), leitura não repetível (o mesmo SELECT dá valores diferentes), leitura fantasma (aparecem linhas novas), atualização perdida.

### Triggers

Trigger é código associado a uma tabela (ou view) que roda sozinho quando acontece INSERT, UPDATE ou DELETE. Diferente da procedure, não é chamado com `EXEC` e não recebe parâmetros.

| | AFTER (= FOR) | INSTEAD OF |
|---|---|---|
| Quando roda | Depois do comando, com os dados já na tabela | No lugar do comando; a tabela não é alterada se o trigger não refizer a operação |
| Pode ser criado em | Só tabelas | Tabelas e views |
| Quantos por evento | Vários | Um por evento (INSERT, UPDATE, DELETE) |
| Como cancelar | `ROLLBACK TRANSACTION` | Simplesmente não executar a operação |
| Uso típico | Auditoria, totais, validação com rollback | Bloquear/substituir a operação, view com várias tabelas |

Tabelas virtuais dentro do trigger:

| Evento | inserted | deleted |
|---|---|---|
| INSERT | linhas novas | vazia |
| DELETE | vazia | linhas apagadas |
| UPDATE | valores novos | valores antigos |

- O trigger dispara **uma vez por comando, não por linha**. Um `INSERT ... SELECT` de 10 linhas coloca 10 linhas em `inserted`. Por isso, prefira lógica com `JOIN`/`EXISTS` no lugar de `SELECT @var = coluna FROM inserted`.
- `UPDATE(coluna)` retorna verdadeiro se a coluna apareceu no SET do comando, mesmo que o valor não tenha mudado.
- O trigger roda dentro da transação do comando que o disparou: `ROLLBACK` no trigger desfaz o comando original também.
- `RAISERROR('msg', 16, 1)`: severidade 0–10 informativa, 11–16 erro do usuário/regra de negócio, 17–25 erro grave do servidor. `THROW 50001, 'msg', 1` é a alternativa moderna (número ≥ 50000).
- Gerenciar: `ALTER TRIGGER`, `DROP TRIGGER nome`, `DISABLE TRIGGER nome ON tabela`, `ENABLE TRIGGER nome ON tabela`.
- Triggers DDL existem (`ON DATABASE FOR CREATE_TABLE`), mas o foco da disciplina é DML.

### Views

View é uma **tabela virtual**: guarda a consulta, não os dados. Cada SELECT na view executa a consulta de novo e devolve dados atualizados.

- Vantagens: reutilização de consultas, segurança (expor só algumas colunas/linhas e dar GRANT só na view), simplicidade e mascaramento da estrutura do banco.
- `ORDER BY` não é permitido dentro da view, a não ser com `TOP`, `OFFSET` ou `FOR XML`. E mesmo com TOP, a ordem do resultado só é garantida com ORDER BY no SELECT que lê a view.
- Toda coluna calculada precisa de alias (`COUNT(*) AS Qtde`), e os nomes de coluna não podem se repetir.
- `WITH CHECK OPTION`: impede INSERT/UPDATE pela view que gerem linhas que a própria view não mostraria.
- `WITH SCHEMABINDING`: impede alterar/excluir as tabelas de base de forma que quebre a view (exige nomes com schema, `dbo.Tabela`, e proíbe `SELECT *`). Base das views indexadas (materializadas).
- `WITH ENCRYPTION`: esconde o texto da view.
- View atualizável: dá para fazer INSERT/UPDATE/DELETE se o comando afetar uma só tabela base e a view não tiver agregação, DISTINCT, GROUP BY ou TOP. Para views com JOIN, usa-se trigger INSTEAD OF.
- Ver o código: `sp_helptext 'nome_view'`.

### Restrições de integridade

Regras que o próprio banco garante, sem depender da aplicação.

| Tipo de integridade | Garante | Como |
|---|---|---|
| De domínio | Valor dentro do tipo/faixa permitida | Tipo de dado, CHECK, DEFAULT |
| De vazio | Se a coluna aceita NULL | NOT NULL |
| De chave | Unicidade e não nulo | PRIMARY KEY, UNIQUE |
| Referencial | FK aponta para algo que existe | FOREIGN KEY ... REFERENCES |
| Definida pelo usuário | Regra de negócio | CHECK com regra, ou trigger quando envolve outras tabelas |

- `PRIMARY KEY` = NOT NULL + UNIQUE; uma por tabela. `UNIQUE` pode haver várias e aceita **um único NULL** no SQL Server.
- Ações referenciais em `ON DELETE` / `ON UPDATE`: `NO ACTION` (padrão, bloqueia), `CASCADE` (propaga), `SET NULL` (coluna precisa aceitar NULL), `SET DEFAULT`.
- CHECK só enxerga a linha atual; regras que consultam outra tabela exigem trigger.
- `WITH CHECK` valida os dados já existentes ao adicionar a constraint; `WITH NOCHECK` não valida (a constraint fica "não confiável").
- `ALTER TABLE t NOCHECK CONSTRAINT ALL` desliga temporariamente; `CHECK CONSTRAINT ALL` religa (o script do Northwind usa isso nas cargas).
- Não existe `ALTER CONSTRAINT`: para mudar, `DROP CONSTRAINT` e cria de novo. Por isso nomeie as constraints (`CK_PRODUTO_PRECO`, `FK_PRODUTO_CATEGORIA`).

### Gerenciamento de acesso

O acesso tem dois níveis: **LOGIN** autentica no servidor; **USER** dá identidade dentro de um banco. Um login sem user no banco não entra nele.

| Comando | Efeito | Detalhe que cai na prova |
|---|---|---|
| GRANT | Concede a permissão | `WITH GRANT OPTION` deixa o usuário repassar a permissão |
| DENY | Nega explicitamente | Vence qualquer GRANT, inclusive o herdado de uma role |
| REVOKE | Remove um GRANT ou DENY dado antes | Não nega; o usuário ainda pode ter a permissão por uma role |

- Permissões de objeto: SELECT, INSERT, UPDATE, DELETE (tabela/view), EXECUTE (procedure/função), ALTER, CONTROL. Dá para restringir por coluna: `GRANT SELECT (Nome, Preco) ON dbo.Produto TO u`.
- Sem `ON objeto`, a permissão vale para o banco inteiro: `GRANT EXECUTE TO Juca` libera todas as procedures.
- Roles de banco fixas: `db_owner` (tudo), `db_datareader` (SELECT em tudo), `db_datawriter` (INSERT/UPDATE/DELETE em tudo), `db_denydatareader`, `db_denydatawriter`, `db_ddladmin`, `db_securityadmin`, `db_backupoperator`, `public` (todos são membros).
- Roles de servidor fixas: `sysadmin`, `securityadmin`, `serveradmin`, `dbcreator`.
- Role criada pelo usuário: `CREATE ROLE` + `ALTER ROLE ... ADD MEMBER`. É a boa prática: dá permissão à role e coloca usuários nela.
- Encadeamento de proprietário (ownership chaining): quem tem GRANT só na view ou procedure consegue ler as tabelas de baixo, se o dono for o mesmo. É assim que a view vira mecanismo de segurança.
- Testar sem trocar de conexão: `EXECUTE AS USER = 'u' ... REVERT`.
- Princípio do menor privilégio: dar só o necessário.

### Perguntas de revisão

1. Um trigger AFTER INSERT faz ROLLBACK. O INSERT original fica gravado? **(Não.)**
2. Num UPDATE, onde está o valor antigo? **(deleted.)**
3. Uma view guarda dados? **(Não, só a consulta, exceto view indexada.)**
4. O usuário tem GRANT SELECT pela role e DENY SELECT direto. Ele consegue ler? **(Não, DENY vence.)**
5. Depois de REVOKE SELECT, o usuário ainda pode ler? **(Pode, se uma role der a permissão.)**
6. Depois de `ROLLBACK TRANSACTION sp1`, a transação ainda está aberta? **(Sim; é preciso COMMIT ou ROLLBACK para fechá-la.)**
7. Qual restrição garante que Salario > 0? **(CHECK, integridade de domínio.)**
8. `ON DELETE SET NULL` funciona com FK NOT NULL? **(Não.)**

---

## 4. Colinha — FRENTE (moldes de código)

A frente tem só moldes para copiar e adaptar na parte prática. Escreva à mão em letra pequena, em duas colunas; cada bloco abaixo cabe em 4 a 8 linhas.

```sql
-- VIEW --------------------------------------------------
CREATE OR ALTER VIEW vw_Nome AS
SELECT t.Col, COUNT(*) AS Qtde          -- alias obrigatório
FROM T1 t JOIN T2 u ON u.Id = t.IdFk
LEFT JOIN T3 x ON x.Id = t.Id           -- LEFT p/ incluir quem tem 0
WHERE ... GROUP BY t.Col HAVING COUNT(*) > 1;
-- ORDER BY só com TOP (100) PERCENT / TOP n; ordene ao consultar
-- WITH CHECK OPTION (no fim) | WITH SCHEMABINDING (antes do AS)
-- "maior/menor": WHERE x = (SELECT MAX(x) FROM ...) ou TOP 1 ... ORDER BY
-- "não é / não tem": NOT EXISTS (SELECT 1 FROM ... WHERE ...)

-- TRANSAÇÃO --------------------------------------------
BEGIN TRY
  BEGIN TRAN;
    UPDATE ...;
    SAVE TRAN sp1;            -- ROLLBACK TRAN sp1 = desfaz só até aqui
    INSERT ...;
  COMMIT;
END TRY
BEGIN CATCH
  IF XACT_STATE() <> 0 ROLLBACK;   -- 1 ok | -1 só rollback | 0 sem tran
  PRINT CONCAT('Erro ', ERROR_NUMBER(), ' linha ', ERROR_LINE(), ': ', ERROR_MESSAGE());
  -- THROW;  (relança)
END CATCH;
-- Estilo antigo: IF @@ERROR <> 0 ROLLBACK ELSE COMMIT
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; | SET XACT_ABORT ON;

-- TRIGGER (bloquear) ------------------------------------
CREATE OR ALTER TRIGGER trg_Tab_AfterIns ON Tab
AFTER INSERT          -- AFTER/FOR | INSTEAD OF ; INSERT, UPDATE, DELETE
AS BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT 1 FROM inserted i WHERE <condição ruim>)
  BEGIN
    RAISERROR('Mensagem', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
END;
-- TRIGGER (auditar UPDATE) ------------------------------
  IF UPDATE(Col)
  INSERT INTO Log (Id, Antigo, Novo, Data, Usuario)
  SELECT d.Id, d.Col, i.Col, GETDATE(), SUSER_SNAME()
  FROM inserted i JOIN deleted d ON d.Id = i.Id;
-- TRIGGER (atualizar total) -----------------------------
  UPDATE c SET total = total + x.n
  FROM Categoria c JOIN (SELECT fk, COUNT(*) n FROM inserted GROUP BY fk) x
  ON x.fk = c.id;
-- INSTEAD OF: se ok, refazer -> INSERT INTO Tab SELECT ... FROM inserted
-- INSERT=inserted | DELETE=deleted | UPDATE=inserted(novo)+deleted(velho)
-- DISABLE/ENABLE TRIGGER nome ON Tab ; DROP TRIGGER nome

-- RESTRIÇÕES -------------------------------------------
CREATE TABLE Produto (
  Id INT IDENTITY(1,1) CONSTRAINT PK_Produto PRIMARY KEY,
  Nome VARCHAR(80) NOT NULL CONSTRAINT UQ_Produto_Nome UNIQUE,
  Preco DECIMAL(10,2) NOT NULL CONSTRAINT CK_Produto_Preco CHECK (Preco > 0),
  Qtd INT CONSTRAINT DF_Produto_Qtd DEFAULT 0,
  Sit CHAR(1) CHECK (Sit IN ('A','I')),
  IdCat INT NOT NULL,
  CONSTRAINT FK_Produto_Cat FOREIGN KEY (IdCat) REFERENCES Categoria(Id)
    ON DELETE CASCADE ON UPDATE CASCADE  -- NO ACTION | SET NULL | SET DEFAULT
);
ALTER TABLE T WITH CHECK ADD CONSTRAINT CK_X CHECK (...);
ALTER TABLE T ADD CONSTRAINT DF_X DEFAULT 0 FOR Col;
ALTER TABLE T DROP CONSTRAINT CK_X;      -- mudar = DROP + ADD
ALTER TABLE T NOCHECK CONSTRAINT ALL;    -- CHECK CONSTRAINT ALL religa
EXEC sp_help 'T';                        -- lista constraints

-- ACESSO ------------------------------------------------
USE master;  CREATE LOGIN joao WITH PASSWORD = 'Senha#Forte123',
             DEFAULT_DATABASE = Banco, CHECK_POLICY = ON;
USE Banco;   CREATE USER joao FOR LOGIN joao;
GRANT SELECT, INSERT ON dbo.Tab TO joao [WITH GRANT OPTION];
GRANT SELECT (Col1, Col2) ON dbo.Tab TO joao;  GRANT EXECUTE ON dbo.sp TO joao;
DENY DELETE ON dbo.Tab TO joao;    REVOKE INSERT ON dbo.Tab FROM joao;
CREATE ROLE rl_leitura; GRANT SELECT ON SCHEMA::dbo TO rl_leitura;
ALTER ROLE rl_leitura ADD MEMBER joao;  ALTER ROLE db_datareader ADD MEMBER joao;
EXECUTE AS USER = 'joao'; SELECT ...; REVERT;     -- testar
SELECT * FROM fn_my_permissions('dbo.Tab','OBJECT');
DROP USER joao; USE master; DROP LOGIN joao;
```

---

## 5. Colinha — VERSO (teoria, pegadinhas e inglês)

O verso responde a múltipla escolha e a questão em inglês. Copie em frases curtas; os números e as palavras-chave são o que importa.

**Transação.** ACID = Atomicidade (tudo/nada), Consistência (estado válido→válido), Isolamento (uma não vê a outra), Durabilidade (COMMIT persiste). Autocommit = padrão sem BEGIN TRAN. ROLLBACK sem nome desfaz tudo. Isolamento: READ UNCOMMITTED (leitura suja) < READ COMMITTED (padrão) < REPEATABLE READ < SERIALIZABLE (sem fantasma).

**Trigger.** Dispara sozinho, sem EXEC, sem parâmetro, 1 vez por comando (não por linha). AFTER = FOR, só em tabela, roda depois. INSTEAD OF = no lugar, em tabela ou view, 1 por evento. ROLLBACK no trigger desfaz o comando que o disparou. UPDATE(col) = coluna citada no SET. Severidade 16 = erro de regra de negócio.

**View.** Tabela virtual, guarda a consulta e não os dados. Serve para segurança, simplicidade e reutilização. Sem ORDER BY (só com TOP). CHECK OPTION barra linhas que sairiam da view. SCHEMABINDING protege as tabelas base. Atualizável se mexer em 1 tabela e não tiver agregação/DISTINCT/GROUP BY.

**Integridade.** Domínio (tipo, CHECK, DEFAULT), vazio (NOT NULL), chave (PK, UNIQUE), referencial (FK), usuário (CHECK de regra, trigger). PK = NOT NULL + UNIQUE, 1 por tabela. FK padrão = NO ACTION. SET NULL exige coluna nulável. CHECK não consulta outra tabela → trigger.

**Acesso.** LOGIN = servidor (autenticação); USER = banco (autorização). DENY vence GRANT. REVOKE só remove, não nega. WITH GRANT OPTION = pode repassar. db_datareader lê tudo, db_datawriter escreve tudo, db_owner faz tudo, sysadmin manda no servidor. Menor privilégio. GRANT na view sem GRANT na tabela funciona (ownership chaining).

### Pegadinhas

- "View armazena dados" → **falso** (só view indexada).
- "REVOKE impede o acesso" → **falso**, só remove a permissão explícita.
- "Trigger executa uma vez por linha" → **falso** no SQL Server.
- "INSTEAD OF não pode ser usado em view" → **falso**, é justamente o uso clássico.
- "Trigger pode ser chamado com EXEC" → **falso**.
- "UNIQUE não aceita NULL" → **falso**, aceita um.
- "COMMIT pode ser desfeito com ROLLBACK" → **falso**.

### Glossário para a questão em inglês

| Inglês | Português |
|---|---|
| statement / is true / is false | afirmação / é verdadeira / é falsa |
| fires / is triggered / instead of | dispara / é disparado / em vez de |
| stored query / virtual table / underlying table | consulta armazenada / tabela virtual / tabela base |
| rolled back / committed / undone | revertido / confirmado / desfeito |
| enforce / constraint / foreign key | garantir/impor / restrição / chave estrangeira |
| referential integrity / cascade | integridade referencial / propagar |
| grant / deny / revoke / privilege | conceder / negar / revogar / privilégio |
| takes precedence over / overrides | tem precedência sobre / sobrepõe |
| role / login / user / principal | papel (grupo) / login do servidor / usuário do banco / entidade de segurança |
| dirty read / phantom read / lock | leitura suja / leitura fantasma / bloqueio |
| either all or none / unit of work | ou tudo ou nada / unidade de trabalho |
| must / cannot / may / only / always / never | deve / não pode / pode / somente / sempre / nunca |

> **Dica:** em afirmativas em inglês, as palavras absolutas (*always, never, only, cannot*) costumam marcar a alternativa falsa. Exemplo: "A DENY permission always takes precedence over a GRANT" → verdadeira; "A view always stores its data physically" → falsa.

---

## 6. Exercícios de VIEW resolvidos (banco MICROSOFT / Northwind)

As seis views abaixo rodam no script `MICROSOFT.sql` da disciplina. Os resultados esperados foram conferidos contra os dados do próprio script; tente resolver antes de olhar.

Tabelas usadas: `Employees` (ReportsTo = chefe), `Products`, `[Order Details]` (UnitPrice, Quantity, Discount), `Orders` (CustomerID, EmployeeID), `Customers`, `Territories`, `EmployeeTerritories`, `Suppliers`, `Categories`. O nome *Order Details* tem espaço, então sempre entre colchetes.

### 1. Funcionários que não são chefes

<details><summary>Resposta</summary>

```sql
CREATE OR ALTER VIEW vw_FuncionariosNaoChefes AS
SELECT e.EmployeeID,
       e.FirstName + ' ' + e.LastName AS Nome,
       e.Title AS Cargo
FROM Employees e
WHERE NOT EXISTS (SELECT 1
                  FROM Employees sub
                  WHERE sub.ReportsTo = e.EmployeeID);
GO
SELECT * FROM vw_FuncionariosNaoChefes;
```

**Resultado esperado:** 7 funcionários; ficam de fora Andrew Fuller (2) e Steven Buchanan (5). **Pegadinha:** `WHERE EmployeeID NOT IN (SELECT ReportsTo FROM Employees)` retorna zero linhas, porque o Fuller tem ReportsTo NULL e `NOT IN` com NULL na lista nunca é verdadeiro. Use `NOT EXISTS` ou acrescente `WHERE ReportsTo IS NOT NULL` na subconsulta.
</details>

### 2. Quanto cada produto foi vendido

<details><summary>Resposta</summary>

```sql
CREATE OR ALTER VIEW vw_VendasPorProduto AS
SELECT p.ProductID,
       p.ProductName AS Produto,
       COUNT(od.OrderID)          AS QtdePedidos,
       ISNULL(SUM(od.Quantity),0) AS UnidadesVendidas
FROM Products p
LEFT JOIN [Order Details] od ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName;
GO
SELECT * FROM vw_VendasPorProduto ORDER BY UnidadesVendidas DESC;
```

**Resultado esperado:** 77 produtos; o mais vendido é o produto 60 (Camembert Pierrot), com 1.577 unidades. O `LEFT JOIN` garante que um produto nunca vendido apareça com 0.
</details>

### 3. Territórios e quantos vendedores estão vinculados

<details><summary>Resposta</summary>

```sql
CREATE OR ALTER VIEW vw_VendedoresPorTerritorio AS
SELECT t.TerritoryID,
       RTRIM(t.TerritoryDescription) AS Territorio,
       COUNT(et.EmployeeID)          AS QtdeVendedores
FROM Territories t
LEFT JOIN EmployeeTerritories et ON et.TerritoryID = t.TerritoryID
GROUP BY t.TerritoryID, t.TerritoryDescription;
GO
SELECT * FROM vw_VendedoresPorTerritorio ORDER BY QtdeVendedores DESC, Territorio;
```

**Resultado esperado:** 53 territórios; 49 têm 1 vendedor e 4 têm 0. Com `INNER JOIN` esses 4 sumiriam, e `COUNT(*)` contaria 1 para eles: conte sempre uma coluna da tabela da direita. O `RTRIM` remove os espaços do tipo `nchar(50)`.
</details>

### 4. Nome do cliente da venda de maior valor

<details><summary>Resposta</summary>

```sql
CREATE OR ALTER VIEW vw_ClienteMaiorVenda AS
SELECT TOP 1 WITH TIES
       c.CompanyName AS Cliente,
       o.OrderID     AS Pedido,
       CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(12,2)) AS ValorVenda
FROM Orders o
JOIN Customers c         ON c.CustomerID = o.CustomerID
JOIN [Order Details] od  ON od.OrderID   = o.OrderID
GROUP BY c.CompanyName, o.OrderID
ORDER BY ValorVenda DESC;
GO
SELECT * FROM vw_ClienteMaiorVenda;
```

**Resultado esperado:** QUICK-Stop, pedido 10865, 16.387,50. `ORDER BY` é aceito aqui porque a view usa `TOP`; `WITH TIES` traz empates. Alternativa sem TOP: calcular o total por pedido numa subconsulta e filtrar `WHERE Valor = (SELECT MAX(Valor) FROM ...)`.
</details>

### 5. Vendedores ordenados pela lucratividade

O banco não tem custo dos produtos, então "lucratividade" aqui é o faturamento líquido de desconto. Se o professor quiser outro critério (ex.: descontar o frete), troque a expressão do SUM.

<details><summary>Resposta</summary>

```sql
CREATE OR ALTER VIEW vw_RankingVendedores AS
SELECT e.EmployeeID,
       e.FirstName + ' ' + e.LastName AS Vendedor,
       COUNT(DISTINCT o.OrderID) AS QtdeVendas,
       CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(12,2)) AS Faturamento,
       RANK() OVER (ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC) AS Posicao
FROM Employees e
JOIN Orders o           ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] od ON od.OrderID   = o.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;
GO
SELECT * FROM vw_RankingVendedores ORDER BY Posicao;
```

**Resultado esperado:** 1º Margaret Peacock (232.890,85), 2º Janet Leverling, 3º Nancy Davolio; último Steven Buchanan. A view não garante ordem sozinha: a coluna `Posicao` deixa o ranking explícito, e o `ORDER BY` vai no SELECT que consulta a view. Se o professor exigir a ordem dentro da view, use `SELECT TOP 100 PERCENT ... ORDER BY Faturamento DESC` e comente que o SQL Server não garante essa ordem.
</details>

### 6. Produtos em estoque com fornecedor, categoria, preço e descontinuado

<details><summary>Resposta</summary>

```sql
CREATE OR ALTER VIEW vw_ProdutosEmEstoque AS
SELECT p.ProductName  AS Produto,
       s.CompanyName  AS Fornecedor,
       c.CategoryName AS Categoria,
       p.UnitPrice    AS Preco,
       p.UnitsInStock AS Estoque,
       CASE WHEN p.Discontinued = 1 THEN 'Sim' ELSE 'Não' END AS Descontinuado
FROM Products p
LEFT JOIN Suppliers  s ON s.SupplierID = p.SupplierID
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE p.UnitsInStock > 0;
GO
SELECT * FROM vw_ProdutosEmEstoque ORDER BY Produto;
```

`SupplierID` e `CategoryID` aceitam NULL em `Products`, por isso o `LEFT JOIN`: um produto sem fornecedor cadastrado continuaria aparecendo. O `CASE` transforma o bit 0/1 em texto legível.
</details>

### Para treinar a ideia de view como segurança

Depois de criar as views, crie um usuário, dê `GRANT SELECT ON vw_ProdutosEmEstoque` e teste com `EXECUTE AS USER`: ele lê a view mas recebe erro ao fazer `SELECT * FROM Products`. Essa combinação view + permissão é uma boa candidata a questão prática.

---

## 7. Exercícios de TRIGGER resolvidos (banco BIBLIOTECA)

Os 18 exercícios da lista do professor, resolvidos no esquema `Categoria`, `Autor`, `Editora`, `Livro`, `LivroAutor` do [BIBLIOTECA.sql](../estudos/views/biblioteca.sql). Todos tratam várias linhas por comando (JOIN com inserted/deleted), que é o jeito correto e o que diferencia uma resposta boa na prova.

**Três regras para não se perder:**

- Teste um exercício por vez. Vários triggers na mesma tabela e evento se somam; use `DISABLE TRIGGER nome ON tabela` ou `DROP TRIGGER` antes do próximo.
- A FK é verificada antes do trigger AFTER. Se o DELETE fere uma FK, ele falha e o AFTER nunca roda. Por isso os exercícios 3, 5, 11 e 13 usam INSTEAD OF.
- Só existe um INSTEAD OF DELETE por tabela. Os exercícios 3 e 11 disputam o mesmo trigger em Livro: o 11 é a versão ampliada do 3.

| Ex. | Tabela | Tipo | Ideia |
|---|---|---|---|
| 1 | Livro | AFTER INSERT | Título repetido → ROLLBACK |
| 2 | Livro | AFTER INSERT | UPDATE ano = YEAR(GETDATE()) |
| 3 | Livro | INSTEAD OF DELETE | Apaga LivroAutor e depois Livro |
| 4 / 10 | Livro | AFTER INSERT | Soma em Categoria.total_livros |
| 5 | Categoria | INSTEAD OF DELETE | Tem livro → erro; senão apaga |
| 6 / 18 | Livro | AFTER UPDATE | INSERT no log com deleted + inserted |
| 7 / 17 | LivroAutor | AFTER INSERT | Soma em Autor.total_livros_escritos |
| 8 | Livro | AFTER UPDATE | IF UPDATE(isbn) → ROLLBACK |
| 9 | LivroAutor | AFTER INSERT | Autor com mais de 5 → ROLLBACK |
| 11 | Livro | INSTEAD OF DELETE | Ex. 3 + apaga autor que ficou sem livro |
| 12 | Livro | AFTER INSERT | Categoria com mais de 100 → ROLLBACK |
| 13 | Autor | INSTEAD OF DELETE | Troca a exclusão por nacionalidade = 'Desconhecida' |
| 14 | Livro | AFTER DELETE | INSERT no log com deleted |
| 15 | Livro | AFTER UPDATE | Título com "proibido" → volta o antigo |
| 16 | Livro | AFTER INSERT | Editora na lista proibida → ROLLBACK |

### Preparação (rodar uma vez)

Alguns exercícios citam colunas e tabelas que não existem no script original.

```sql
USE BIBLIOTECA;
GO
ALTER TABLE Categoria ADD total_livros INT NOT NULL CONSTRAINT DF_Categoria_total DEFAULT 0;
ALTER TABLE Autor     ADD total_livros_escritos INT NOT NULL CONSTRAINT DF_Autor_total DEFAULT 0;
GO
-- acerta os totais com os dados que já existem
UPDATE c SET total_livros = (SELECT COUNT(*) FROM Livro l WHERE l.fk_categoria = c.id) FROM Categoria c;
UPDATE a SET total_livros_escritos = (SELECT COUNT(*) FROM LivroAutor la WHERE la.fk_autor = a.id) FROM Autor a;

CREATE TABLE AuditoriaLivro (
  id INT IDENTITY PRIMARY KEY, isbn VARCHAR(50), titulo_antigo VARCHAR(100), titulo_novo VARCHAR(100),
  ano_antigo INT, ano_novo INT, data_hora DATETIME DEFAULT GETDATE(), usuario SYSNAME DEFAULT SUSER_SNAME());
CREATE TABLE LogExclusaoLivros (
  id INT IDENTITY PRIMARY KEY, isbn VARCHAR(50), titulo VARCHAR(100), ano INT,
  fk_editora INT, fk_categoria INT, data_hora DATETIME DEFAULT GETDATE(), usuario SYSNAME DEFAULT SUSER_SNAME());
CREATE TABLE LogAtualizacaoLivros (
  id INT IDENTITY PRIMARY KEY, isbn VARCHAR(50), titulo_antigo VARCHAR(100), titulo_novo VARCHAR(100),
  ano_antigo INT, ano_novo INT, editora_antiga INT, editora_nova INT,
  categoria_antiga INT, categoria_nova INT, data_hora DATETIME DEFAULT GETDATE());
CREATE TABLE EditoraProibida (id_editora INT PRIMARY KEY REFERENCES Editora(id));
INSERT INTO EditoraProibida VALUES (5);   -- Matrix, só para testar
GO
```

### 1. Impedir livros com o mesmo título

```sql
CREATE OR ALTER TRIGGER trg_Livro_TituloUnico ON Livro
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT 1 FROM Livro l JOIN inserted i ON l.titulo = i.titulo
             GROUP BY l.titulo HAVING COUNT(*) > 1)
  BEGIN
    RAISERROR('Já existe um livro com este título.', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
END;
GO
-- teste: deve falhar
INSERT INTO Livro VALUES ('111','O Papai é Pop',2020,1,1);
```

No AFTER o livro novo já está na tabela, por isso o teste é `COUNT(*) > 1`, não `> 0`. Na prática, `UNIQUE (titulo)` resolveria sem trigger: vale citar na prova.

### 2. Ano de publicação = ano atual ao inserir

```sql
CREATE OR ALTER TRIGGER trg_Livro_AnoAtual ON Livro
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  UPDATE l SET ano = YEAR(GETDATE())
  FROM Livro l JOIN inserted i ON i.isbn = l.isbn;
END;
GO
```

### 3. Excluir LivroAutor quando o livro é excluído

```sql
CREATE OR ALTER TRIGGER trg_Livro_ExcluiCascata ON Livro
INSTEAD OF DELETE AS
BEGIN
  SET NOCOUNT ON;
  DELETE la FROM LivroAutor la JOIN deleted d ON d.isbn = la.fk_livro;
  DELETE l  FROM Livro l       JOIN deleted d ON d.isbn = l.isbn;
END;
GO
```

Com AFTER DELETE não funciona: a FK de LivroAutor barra o DELETE antes do trigger rodar. A alternativa sem trigger é recriar a FK com `ON DELETE CASCADE`.

### 4 e 10. Atualizar total_livros da categoria

```sql
CREATE OR ALTER TRIGGER trg_Livro_TotalCategoria ON Livro
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  UPDATE c SET total_livros = c.total_livros + x.qtd
  FROM Categoria c
  JOIN (SELECT fk_categoria, COUNT(*) AS qtd FROM inserted GROUP BY fk_categoria) x
    ON x.fk_categoria = c.id;
END;
GO
```

O `GROUP BY` em inserted cobre um INSERT de vários livros da mesma categoria. Versão completa: `AFTER INSERT, DELETE` e subtrair o que vier em deleted.

### 5. Não excluir categoria com livros

```sql
CREATE OR ALTER TRIGGER trg_Categoria_BloqueiaExclusao ON Categoria
INSTEAD OF DELETE AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT 1 FROM Livro l JOIN deleted d ON d.id = l.fk_categoria)
  BEGIN
    RAISERROR('Categoria possui livros e não pode ser excluída.', 16, 1);
    RETURN;
  END
  DELETE c FROM Categoria c JOIN deleted d ON d.id = c.id;
END;
GO
```

No INSTEAD OF não precisa de ROLLBACK: basta não executar o DELETE.

### 6. Auditoria de atualização de livro

```sql
CREATE OR ALTER TRIGGER trg_Livro_Auditoria ON Livro
AFTER UPDATE AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO AuditoriaLivro (isbn, titulo_antigo, titulo_novo, ano_antigo, ano_novo)
  SELECT i.isbn, d.titulo, i.titulo, d.ano, i.ano
  FROM inserted i JOIN deleted d ON d.isbn = i.isbn;
END;
GO
-- teste
UPDATE Livro SET ano = 2016 WHERE isbn = '9788581742458';
SELECT * FROM AuditoriaLivro;
```

### 7 e 17. Total de livros escritos pelo autor

```sql
CREATE OR ALTER TRIGGER trg_LivroAutor_TotalAutor ON LivroAutor
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  UPDATE a SET total_livros_escritos = a.total_livros_escritos + x.qtd
  FROM Autor a
  JOIN (SELECT fk_autor, COUNT(*) AS qtd FROM inserted GROUP BY fk_autor) x
    ON x.fk_autor = a.id;
END;
GO
```

Variante "recalcular" (mais segura, aceita também DELETE): `SET total_livros_escritos = (SELECT COUNT(*) FROM LivroAutor WHERE fk_autor = a.id)` para os autores presentes em inserted ou deleted.

### 8. Proibir alteração do ISBN

```sql
CREATE OR ALTER TRIGGER trg_Livro_BloqueiaISBN ON Livro
AFTER UPDATE AS
BEGIN
  SET NOCOUNT ON;
  IF UPDATE(isbn)
  BEGIN
    RAISERROR('O ISBN não pode ser alterado.', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
END;
GO
```

### 9. Máximo de 5 livros por autor

```sql
CREATE OR ALTER TRIGGER trg_LivroAutor_Max5 ON LivroAutor
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT la.fk_autor FROM LivroAutor la
             WHERE la.fk_autor IN (SELECT fk_autor FROM inserted)
             GROUP BY la.fk_autor HAVING COUNT(*) > 5)
  BEGIN
    RAISERROR('Um autor pode ter no máximo 5 livros.', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
END;
GO
```

### 11. Excluir livro e remover autor que ficou sem livros

Substitui o trigger do exercício 3 (mesmo evento INSTEAD OF DELETE em Livro).

```sql
CREATE OR ALTER TRIGGER trg_Livro_ExcluiCascata ON Livro
INSTEAD OF DELETE AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @autores TABLE (id INT);
  INSERT INTO @autores
  SELECT DISTINCT la.fk_autor FROM LivroAutor la JOIN deleted d ON d.isbn = la.fk_livro;

  DELETE la FROM LivroAutor la JOIN deleted d ON d.isbn = la.fk_livro;
  DELETE l  FROM Livro l       JOIN deleted d ON d.isbn = l.isbn;

  DELETE a FROM Autor a JOIN @autores x ON x.id = a.id
  WHERE NOT EXISTS (SELECT 1 FROM LivroAutor la WHERE la.fk_autor = a.id);
END;
GO
-- teste: Tiririca só tem esse livro, deve sumir de Autor
DELETE FROM Livro WHERE isbn = '9788582302026';
```

Os autores são guardados antes, porque depois de apagar LivroAutor não dá mais para saber quem escreveu o livro.

### 12. Máximo de 100 livros por categoria

```sql
CREATE OR ALTER TRIGGER trg_Livro_Max100Categoria ON Livro
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT l.fk_categoria FROM Livro l
             WHERE l.fk_categoria IN (SELECT fk_categoria FROM inserted)
             GROUP BY l.fk_categoria HAVING COUNT(*) > 100)
  BEGIN
    RAISERROR('A categoria já atingiu o limite de 100 livros.', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
END;
GO
```

### 13. Nacionalidade "Desconhecida" ao excluir autor

O enunciado é contraditório: se o autor for excluído, não há linha para atualizar. A leitura possível é uma exclusão lógica: o INSTEAD OF troca o DELETE por um UPDATE.

```sql
CREATE OR ALTER TRIGGER trg_Autor_ExclusaoLogica ON Autor
INSTEAD OF DELETE AS
BEGIN
  SET NOCOUNT ON;
  UPDATE a SET nacionalidade = 'Desconhecida'
  FROM Autor a JOIN deleted d ON d.id = a.id;
END;
GO
```

> **Atenção:** com este trigger ativo, o exercício 11 deixa de apagar autores (o DELETE em Autor vira UPDATE). Teste um de cada vez.

### 14. Log de exclusões de livros

```sql
CREATE OR ALTER TRIGGER trg_Livro_LogExclusao ON Livro
AFTER DELETE AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO LogExclusaoLivros (isbn, titulo, ano, fk_editora, fk_categoria)
  SELECT isbn, titulo, ano, fk_editora, fk_categoria FROM deleted;
END;
GO
```

Convive com o INSTEAD OF do exercício 3/11: o DELETE feito dentro dele dispara este AFTER normalmente.

### 15. Reverter título que contenha "proibido"

```sql
CREATE OR ALTER TRIGGER trg_Livro_TituloProibido ON Livro
AFTER UPDATE AS
BEGIN
  SET NOCOUNT ON;
  IF UPDATE(titulo)
    UPDATE l SET titulo = d.titulo
    FROM Livro l
    JOIN inserted i ON i.isbn = l.isbn
    JOIN deleted  d ON d.isbn = i.isbn
    WHERE i.titulo LIKE '%proibido%';
END;
GO
```

O enunciado pede para reverter o título, não a operação toda: outras colunas alteradas no mesmo UPDATE continuam valendo. Se quiser cancelar tudo, use RAISERROR + ROLLBACK.

### 16. Bloquear editora proibida

```sql
CREATE OR ALTER TRIGGER trg_Livro_EditoraProibida ON Livro
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT 1 FROM inserted i JOIN EditoraProibida p ON p.id_editora = i.fk_editora)
  BEGIN
    RAISERROR('Editora está na lista de editoras proibidas.', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
END;
GO
```

### 18. Log de atualizações de livros

```sql
CREATE OR ALTER TRIGGER trg_Livro_LogAtualizacao ON Livro
AFTER UPDATE AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO LogAtualizacaoLivros (isbn, titulo_antigo, titulo_novo, ano_antigo, ano_novo,
                                    editora_antiga, editora_nova, categoria_antiga, categoria_nova)
  SELECT i.isbn, d.titulo, i.titulo, d.ano, i.ano,
         d.fk_editora, i.fk_editora, d.fk_categoria, i.fk_categoria
  FROM inserted i JOIN deleted d ON d.isbn = i.isbn;
END;
GO
```

Para consultar os triggers criados:

```sql
SELECT name, OBJECT_NAME(parent_id) AS tabela, is_disabled, is_instead_of_trigger FROM sys.triggers;
```

---

## 8. Prática extra em bancos diferentes

Cinco blocos, cada um num banco do repositório que você ainda não usou para aquele tema. Resolva primeiro; o gabarito de cada bloco vem logo abaixo dos enunciados.

### Bloco A — Transações (EMPRESA)

1. Reajuste o salário do departamento 5 em 10% numa transação. Antes do COMMIT, consulte a média; se passar de 40.000, faça ROLLBACK.
2. Numa única transação: crie o departamento 7 "Inovacao", `SAVE TRANSACTION depto_ok`, transfira um funcionário para ele e depois desfaça só a transferência. Confirme e prove com SELECT que o departamento existe e o funcionário não mudou.
3. Com TRY/CATCH: insira um projeto válido e em seguida um funcionário com Cpf_supervisor inexistente. Mostre no CATCH o número e a mensagem do erro e garanta que o projeto também não ficou.
4. Abra duas janelas no SSMS. Na primeira, BEGIN TRAN + UPDATE sem COMMIT. Na segunda, rode um SELECT com READ COMMITTED (espera) e outro com READ UNCOMMITTED (leitura suja). Explique a diferença.

<details><summary>Gabarito do A3</summary>

```sql
BEGIN TRY
  BEGIN TRAN;
    INSERT INTO PROJETO (Projnome, Projnumero, Projlocal, Dnum) VALUES ('Teste', 99, 'Maua', 5);
    INSERT INTO FUNCIONARIO (Pnome, Unome, Cpf, Cpf_supervisor, Dnr)
    VALUES ('Ana', 'Lima', '99999999999', '00000000000', 5);   -- FK falha
  COMMIT;
END TRY
BEGIN CATCH
  IF XACT_STATE() <> 0 ROLLBACK;
  PRINT CONCAT('Erro ', ERROR_NUMBER(), ': ', ERROR_MESSAGE());
END CATCH;
SELECT * FROM PROJETO WHERE Projnumero = 99;   -- vazio: atomicidade
```
</details>

### Bloco B — Restrições de integridade (PAPELARIA)

1. Adicione `CHECK (PrecoVenda > 0)` e `CHECK (QuantidadeEstoque >= 0)` em Produtos, com nomes.
2. Adicione `CHECK (Quantidade > 0)` em ItensVenda.
3. Recrie a FK ItensVenda → Vendas com `ON DELETE CASCADE` e teste excluindo uma venda.
4. Tente inserir um cliente com e-mail repetido e com Status = 'X'. Anote qual restrição barrou cada um.
5. Adicione uma constraint `WITH NOCHECK` que viole dados já existentes e explique por que ela entrou.

<details><summary>Gabarito do B3</summary>

```sql
ALTER TABLE ItensVenda DROP CONSTRAINT FK_ItensVenda_Vendas;
ALTER TABLE ItensVenda WITH CHECK ADD CONSTRAINT FK_ItensVenda_Vendas
  FOREIGN KEY (VendaID) REFERENCES Vendas(VendaID) ON DELETE CASCADE;
```
</details>

### Bloco C — Gerenciamento de acesso (FACULDADE)

1. Crie o login e o usuário `secretaria`: lê todas as tabelas, insere em HISTORICO_ESCOLAR, não pode excluir nada.
2. Crie a view `vw_HistoricoPublico` (nome do aluno, disciplina, nota) e a role `rl_consulta` com SELECT só nela. Coloque o usuário `estagiario` na role e prove que ele não lê a tabela ALUNO diretamente.
3. Dê `GRANT UPDATE (Nota) ON HISTORICO_ESCOLAR` ao usuário `professor` e teste que ele não consegue alterar outra coluna.
4. Ponha `secretaria` em db_datareader e dê `DENY SELECT ON ALUNO`. Ela lê ALUNO? Agora troque o DENY por REVOKE. E agora?

<details><summary>Gabarito do C1 e C4</summary>

```sql
USE master; CREATE LOGIN secretaria WITH PASSWORD = 'Secret#2026', DEFAULT_DATABASE = FACULDADE;
USE FACULDADE; CREATE USER secretaria FOR LOGIN secretaria;
ALTER ROLE db_datareader ADD MEMBER secretaria;
GRANT INSERT ON dbo.HISTORICO_ESCOLAR TO secretaria;
DENY DELETE TO secretaria;                 -- banco todo
-- C4
DENY SELECT ON dbo.ALUNO TO secretaria;    -- não lê: DENY vence a role
REVOKE SELECT ON dbo.ALUNO FROM secretaria;-- volta a ler: a role ainda concede
EXECUTE AS USER = 'secretaria'; SELECT TOP 1 * FROM ALUNO; REVERT;
```
</details>

### Bloco D — Triggers extras (PAPELARIA)

Os três triggers mais clássicos de prova de vendas:

1. Ao inserir em ItensVenda, dar baixa em `Produtos.QuantidadeEstoque`.
2. Bloquear o item se o estoque não for suficiente.
3. Manter `Vendas.ValorTotal` igual à soma de `Quantidade * PrecoUnitario` dos itens (INSERT e DELETE).

<details><summary>Gabarito (1 e 2 juntos)</summary>

```sql
CREATE OR ALTER TRIGGER trg_ItensVenda_BaixaEstoque ON ItensVenda
AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT 1 FROM Produtos p
             JOIN (SELECT CodigoBarras, SUM(Quantidade) q FROM inserted GROUP BY CodigoBarras) i
               ON i.CodigoBarras = p.CodigoBarras
             WHERE p.QuantidadeEstoque < i.q)
  BEGIN
    RAISERROR('Estoque insuficiente.', 16, 1);
    ROLLBACK TRANSACTION; RETURN;
  END
  UPDATE p SET QuantidadeEstoque = p.QuantidadeEstoque - i.q
  FROM Produtos p
  JOIN (SELECT CodigoBarras, SUM(Quantidade) q FROM inserted GROUP BY CodigoBarras) i
    ON i.CodigoBarras = p.CodigoBarras;
END;
GO
```
</details>

<details><summary>Gabarito do 3</summary>

```sql
CREATE OR ALTER TRIGGER trg_ItensVenda_Total ON ItensVenda
AFTER INSERT, DELETE AS
BEGIN
  SET NOCOUNT ON;
  UPDATE v SET ValorTotal = ISNULL((SELECT SUM(Quantidade * PrecoUnitario)
                                    FROM ItensVenda iv WHERE iv.VendaID = v.VendaID), 0)
  FROM Vendas v
  WHERE v.VendaID IN (SELECT VendaID FROM inserted UNION SELECT VendaID FROM deleted);
END;
GO
```
</details>

### Bloco E — Simulado em banco novo (2h, cronômetro)

Este banco não existe no repositório: é o ensaio do "pendrive". Rode o script, gaste 5 minutos lendo o esquema (seção 9) e resolva sem consultar nada além da sua colinha.

```sql
CREATE DATABASE CLINICA_VET;
GO
USE CLINICA_VET;
GO
CREATE TABLE Tutor (
  IdTutor INT IDENTITY PRIMARY KEY, Nome VARCHAR(80) NOT NULL,
  Cpf CHAR(11) UNIQUE, Telefone VARCHAR(20));
CREATE TABLE Animal (
  IdAnimal INT IDENTITY PRIMARY KEY, Nome VARCHAR(50) NOT NULL,
  Especie VARCHAR(20), DataNasc DATE,
  IdTutor INT NOT NULL REFERENCES Tutor(IdTutor));
CREATE TABLE Veterinario (
  IdVet INT IDENTITY PRIMARY KEY, Nome VARCHAR(80) NOT NULL,
  Crmv VARCHAR(10) UNIQUE, Salario DECIMAL(10,2));
CREATE TABLE Consulta (
  IdConsulta INT IDENTITY PRIMARY KEY,
  IdAnimal INT NOT NULL REFERENCES Animal(IdAnimal),
  IdVet INT NOT NULL REFERENCES Veterinario(IdVet),
  DataHora DATETIME NOT NULL, Valor DECIMAL(10,2), Status VARCHAR(12));
GO
INSERT INTO Tutor (Nome, Cpf, Telefone) VALUES
 ('Ana Souza','11111111111','5599-0001'), ('Bruno Lima','22222222222','5599-0002'),
 ('Carla Dias','33333333333',NULL);
INSERT INTO Animal (Nome, Especie, DataNasc, IdTutor) VALUES
 ('Rex','Cachorro','2019-03-10',1), ('Mia','Gato','2021-07-01',1),
 ('Thor','Cachorro','2015-11-20',2), ('Luna','Gato','2022-01-15',3);
INSERT INTO Veterinario (Nome, Crmv, Salario) VALUES
 ('Dr. Paulo','RS1234',9000), ('Dra. Julia','RS5678',9500), ('Dr. Marcos','RS9012',8000);
INSERT INTO Consulta (IdAnimal, IdVet, DataHora, Valor, Status) VALUES
 (1,1,'20260901 10:00',150,'Realizada'), (2,1,'20260903 14:00',120,'Realizada'),
 (3,2,'20260905 09:00',200,'Realizada'), (4,2,'20261210 16:00',180,'Agendada'),
 (1,1,'20261212 11:00',150,'Agendada');   -- 'AAAAMMDD' não depende do idioma do servidor
GO
```

**Questões:**

1. **Restrições:** Valor > 0; Status só aceita 'Agendada', 'Realizada', 'Cancelada', com padrão 'Agendada'; Especie só 'Cachorro', 'Gato', 'Ave', 'Outro'.
2. **View:** `vw_FaturamentoVet` com nome do veterinário, quantidade de consultas realizadas e total faturado, incluindo quem não teve consulta (aparece com 0).
3. **View:** tutores com mais de um animal (nome do tutor e quantidade).
4. **Trigger:** impedir consulta 'Agendada' com DataHora no passado.
5. **Trigger:** quando uma consulta mudar para 'Cancelada', gravar em LogCancelamento (IdConsulta, data, usuário).
6. **Transação:** passar as consultas agendadas do Dr. Paulo para o Dr. Marcos e excluir o Dr. Paulo, tudo ou nada, com TRY/CATCH. (Dica: as consultas realizadas dele continuam apontando para ele. O que acontece?)
7. **Acesso:** login `recepcao` com SELECT em Tutor, Animal e vw_FaturamentoVet, INSERT em Consulta e DELETE negado no banco. Teste com EXECUTE AS USER.
8. **Inglês (V ou F):**
   a) "An INSTEAD OF trigger can be defined on a view."
   b) "Revoking a permission always prevents the user from accessing the object."
   c) "A transaction that has been committed can still be rolled back."
   d) "A CHECK constraint can reference columns from another table."

<details><summary>Gabarito resumido</summary>

```sql
-- 1
ALTER TABLE Consulta ADD CONSTRAINT CK_Consulta_Valor CHECK (Valor > 0);
ALTER TABLE Consulta ADD CONSTRAINT CK_Consulta_Status CHECK (Status IN ('Agendada','Realizada','Cancelada'));
ALTER TABLE Consulta ADD CONSTRAINT DF_Consulta_Status DEFAULT 'Agendada' FOR Status;
ALTER TABLE Animal   ADD CONSTRAINT CK_Animal_Especie CHECK (Especie IN ('Cachorro','Gato','Ave','Outro'));
GO
-- 2
CREATE OR ALTER VIEW vw_FaturamentoVet AS
SELECT v.Nome AS Veterinario, COUNT(c.IdConsulta) AS QtdeRealizadas, ISNULL(SUM(c.Valor),0) AS Faturado
FROM Veterinario v
LEFT JOIN Consulta c ON c.IdVet = v.IdVet AND c.Status = 'Realizada'   -- filtro no ON, não no WHERE
GROUP BY v.Nome;
GO
-- 3
CREATE OR ALTER VIEW vw_TutoresVariosAnimais AS
SELECT t.Nome, COUNT(*) AS QtdeAnimais
FROM Tutor t JOIN Animal a ON a.IdTutor = t.IdTutor
GROUP BY t.Nome HAVING COUNT(*) > 1;
GO
-- 4
CREATE OR ALTER TRIGGER trg_Consulta_DataFutura ON Consulta
AFTER INSERT, UPDATE AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS (SELECT 1 FROM inserted WHERE Status = 'Agendada' AND DataHora < GETDATE())
  BEGIN RAISERROR('Consulta agendada não pode estar no passado.',16,1); ROLLBACK TRANSACTION; RETURN; END
END;
GO
-- 5
CREATE TABLE LogCancelamento (IdConsulta INT, DataHora DATETIME DEFAULT GETDATE(), Usuario SYSNAME DEFAULT SUSER_SNAME());
GO
CREATE OR ALTER TRIGGER trg_Consulta_LogCancel ON Consulta
AFTER UPDATE AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO LogCancelamento (IdConsulta)
  SELECT i.IdConsulta FROM inserted i JOIN deleted d ON d.IdConsulta = i.IdConsulta
  WHERE i.Status = 'Cancelada' AND d.Status <> 'Cancelada';
END;
GO
-- 6
BEGIN TRY
  BEGIN TRAN;
    UPDATE Consulta SET IdVet = 3 WHERE IdVet = 1 AND Status = 'Agendada';
    DELETE FROM Veterinario WHERE IdVet = 1;   -- falha: consultas realizadas ainda referenciam
  COMMIT;
END TRY
BEGIN CATCH
  IF XACT_STATE() <> 0 ROLLBACK;            -- o UPDATE também é desfeito
  PRINT ERROR_MESSAGE();
END CATCH;
-- 7
USE master; CREATE LOGIN recepcao WITH PASSWORD = 'Recep#2026', DEFAULT_DATABASE = CLINICA_VET;
USE CLINICA_VET; CREATE USER recepcao FOR LOGIN recepcao;
GRANT SELECT ON dbo.Tutor TO recepcao; GRANT SELECT ON dbo.Animal TO recepcao;
GRANT SELECT ON dbo.vw_FaturamentoVet TO recepcao; GRANT INSERT ON dbo.Consulta TO recepcao;
DENY DELETE TO recepcao;
-- 8: a) V  b) F  c) F  d) F
```
</details>

---

## 9. Roteiro para o banco do pendrive

Nos primeiros 5 minutos, entenda o esquema antes de escrever qualquer resposta: quase todo erro na parte prática vem de JOIN pela coluna errada ou de FK que você não viu.

1. Rode o script e confira o nome do banco (`USE nome;`). Se o script não cria o banco, crie um antes, como no `MICROSOFT.sql`.
2. Liste tabelas e colunas:
   ```sql
   SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS ORDER BY TABLE_NAME;
   ```
3. Mapeie as FKs, que dizem como fazer os JOINs:
   ```sql
   SELECT OBJECT_NAME(parent_object_id) AS tabela, name AS fk, OBJECT_NAME(referenced_object_id) AS referencia FROM sys.foreign_keys;
   ```
4. Desenhe no rascunho as tabelas com setas das FKs. Marque colunas nuláveis (pedem LEFT JOIN) e nomes com espaço (pedem colchetes).
5. Veja as restrições e triggers que já existem: `EXEC sp_help 'Tabela';` e `SELECT name, OBJECT_NAME(parent_id) FROM sys.triggers;`
6. Rode `SELECT TOP 5 * FROM` cada tabela para ver o formato real dos dados.
7. Resolva primeiro as questões que valem mais e que você já domina. Para cada uma: escreva, execute, teste o caso que deve dar certo e o caso que deve falhar.
8. Antes de entregar, salve tudo num `.sql` com comentários `-- Questão N` e com `GO` entre os objetos (`CREATE VIEW` e `CREATE TRIGGER` precisam ser o primeiro comando do lote).

**Erros que mais tiram ponto:**

- Esquecer `GO` antes de `CREATE VIEW`/`CREATE TRIGGER`.
- Coluna calculada sem alias na view.
- `ORDER BY` em view sem `TOP`.
- Trigger que lê inserted com `SELECT @var = ...` e quebra num INSERT de várias linhas.
- `COUNT(*)` com LEFT JOIN (conta 1 para quem não tem nada); use `COUNT(coluna_da_direita)`.
- `NOT IN` em subconsulta com NULL.
- Testar permissão logado como sa/admin: use `EXECUTE AS USER` e depois `REVERT`.
- Esquecer `CREATE USER` depois do `CREATE LOGIN`.
