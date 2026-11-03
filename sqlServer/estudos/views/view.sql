USE MICROSOFT;



-- 6- Faça uma visão que retorne os produtos, seu fornecedor, sua categoria, seu preço e a informação de ele estar descontinuado ou não, para aqueles que possuem estoque



-- 1- Crie uma visão que liste todos os funcionários que não são chefes.
GO
CREATE OR ALTER VIEW vw_lista_nao_chefes
AS
SELECT *
FROM Employees AS E
WHERE NOT EXISTS(
    SELECT *
    FROM Employees AS S -- subordinados
    WHERE S.ReportsTo = E.EmployeeID
);
GO

SELECT *
FROM vw_lista_nao_chefes;


-- 2- Faça uma visão que liste a quantidade de vendas que cada produto
-- (o quanto cada produto foi vendido).
GO
CREATE OR ALTER VIEW vw_lista_vendas_por_produto
AS
SELECT  P.ProductID, 
        P.ProductName, 
        SUM(OD.Quantity) AS TotalVendido
FROM Products AS P
JOIN [Order Details] AS OD
    ON OD.ProductID = P.ProductID
    GROUP BY P.ProductID, P.ProductName;
GO

SELECT * 
FROM vw_lista_vendas_por_produto ORDER BY TotalVendido DESC;


-- 3- Faça uma visão que liste os territórios e quantos vendedores estão vinculados a ele.
GO
CREATE OR ALTER VIEW vw_lista_territorios_vendedores
AS
SELECT T.TerritoryDescription, COUNT(ET.EmployeeID) AS qtdVendedores
FROM Territories AS T
LEFT JOIN EmployeeTerritories AS ET
ON T.TerritoryID = ET.TerritoryID
GROUP BY T.TerritoryID, T.TerritoryDescription
GO

SELECT *
FROM vw_lista_territorios_vendedores;


-- 4- Faça uma visão que retorne o nome do cliente da venda de maior valor.
GO
CREATE OR ALTER VIEW vw_cliente_maior_venda
AS
SELECT TOP 1 C.CompanyName, 
            SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS ValorVenda
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, C.CompanyName
ORDER BY ValorVenda DESC;
GO

SELECT *
FROM vw_cliente_maior_venda


-- 5- Faça uma visão que liste os vendedores ordenados pela lucratividade.
GO
CREATE OR ALTER VIEW vw_vendedores_ordenados_lucratividade
AS  
    SELECT E.FirstName, CAST(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS DECIMAL(10,2)) AS ValorVenda
    FROM Employees AS E
    JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
    JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    GROUP BY E.FirstName
GO

SELECT *
FROM vw_vendedores_ordenados_lucratividade
ORDER BY ValorVenda DESC;