# Repo de estudos de banco de dados

Estudos da disciplina de banco de dados em **SQL Server**, **MySQL (Workbench)** e **PostgreSQL (pgAdmin)**.

OBS: contém estudos de data science também no repositório (`bancodados-saude/`).

## Estrutura

```
banco-de-dados/
├── sqlServer/
│   ├── aula03/          consultas básicas (banco EMPRESA)
│   ├── aula04/          JOINs
│   ├── aula05/          HAVING, IF/ELSE, WHILE, variáveis
│   ├── aula06/          conversões de tipos e datas
│   ├── aula07/          cursores e funções
│   ├── aula08/          transações (BEGIN / COMMIT / ROLLBACK)
│   ├── aula09/          triggers e views
│   ├── aula11/          gerenciamento de acesso (LOGIN, USER, GRANT / DENY / REVOKE)
│   ├── estudos/         exercícios de prática por assunto
│   │   ├── views/          views no banco MICROSOFT (Northwind)
│   │   ├── triggers/       triggers no banco BIBLIOTECA
│   │   ├── transaction/    transações no banco EMPRESA
│   │   ├── procedure/      procedures
│   │   ├── revisao_prova/  revisão para a prova
│   │   ├── microsoft.sql   script do banco MICROSOFT (Northwind)
│   │   ├── biblioteca.sql  script do banco BIBLIOTECA
│   │   └── empresa.sql     script do banco EMPRESA
│   └── revisao-prova/   planner, resumo teórico, colinha e exercícios resolvidos (README.md)
├── Mysql/               scripts em MySQL
├── postgreSql/          funções em PostgreSQL
└── bancodados-saude/    backend e data science (dados de dengue)
```

## Bancos usados nos estudos (SQL Server)

| Banco | Script | Usado em |
|---|---|---|
| EMPRESA | `sqlServer/estudos/empresa.sql` | consultas, JOINs, transações |
| MICROSOFT (Northwind) | `sqlServer/estudos/microsoft.sql` | views |
| BIBLIOTECA | `sqlServer/estudos/biblioteca.sql` | triggers |

O script `microsoft.sql` não cria o banco: crie antes com `CREATE DATABASE MICROSOFT;` e rode o script dentro dele.

As conexões com esses bancos (servidor `localhost`, autenticação do Windows) estão em `.vscode/settings.json`, para a extensão SQL Server (mssql) do VS Code.

## Material de revisão

O guia completo para a prova (planner de 7 dias, resumo teórico, moldes de código e exercícios resolvidos) está em [sqlServer/revisao-prova/README.md](sqlServer/revisao-prova/README.md).
