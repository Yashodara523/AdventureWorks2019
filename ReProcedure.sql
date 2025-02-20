USE AW_STAGE;
GO

SELECT * FROM [dbo].[stg_vw_Customer];
SELECT * FROM [dbo].[stg_vw_Date];
SELECT * FROM [dbo].[Stg_vw_Erp_Fact_InternetSales];
SELECT * FROM [dbo].[Stg_vw_Erp_Product];
SELECT * FROM [dbo].[stg_vw_Reseller];
SELECT * FROM [dbo].[stg_vw_SalesTerritory];

USE AW_STAGE;
GO

SELECT name FROM sys.views;



SELECT TOP 10 * FROM DimCustomer;
SELECT TOP 10 * FROM DimProduct;
SELECT TOP 10 * FROM FactInternetSales;
SELECT TOP 10 * FROM FactResellerSales;


USE AW_DW;
GO


ALTER PROCEDURE Refresh_DimProduct
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimProduct (ProductAlternateKey, EnglishProductName, StandardCost, Color, Size, ProductSubcategoryCode)
    SELECT 
        p.ProductNumber, 
        p.Name, 
        p.StandardCost, 
        ISNULL(p.Color, 'NA'),  -- ✅ Fix: Replace NULL with 'NA'
        p.Size, 
        p.ProductSubcategoryCode
    FROM AW_STAGE.dbo.Stg_vw_Erp_Product p  
    LEFT JOIN DimProduct d ON p.ProductNumber = d.ProductAlternateKey
    WHERE d.ProductAlternateKey IS NULL;
END;
GO



USE AW_DW;
GO

EXEC [dbo].[Refresh_DimProduct];  -- ✅ Correct (Executing the stored procedure)

/**customer ETL**/
USE AW_DW;
GO



USE AW_DW;
GO

ALTER PROCEDURE [dbo].[Refresh_Reseller]
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert New Resellers
    INSERT INTO DimReseller (ResellerAlternateKey, ResellerName, NumberEmployees, YearOpened)
    SELECT 
        stg.ResellerID, 
        stg.ResellerName, 
        stg.NumberEmployees, 
        stg.YearOpened
    FROM AW_STAGE.dbo.stg_vw_Reseller stg
    LEFT JOIN DimReseller d ON stg.ResellerID = d.ResellerAlternateKey
    WHERE d.ResellerAlternateKey IS NULL;

    -- Update Existing Resellers
    UPDATE d
    SET 
        d.ResellerName = stg.ResellerName,
        d.NumberEmployees = stg.NumberEmployees,
        d.YearOpened = stg.YearOpened
    FROM DimReseller d
    INNER JOIN AW_STAGE.dbo.stg_vw_Reseller stg
    ON d.ResellerAlternateKey = stg.ResellerID;
END;
GO

-- Execute the procedure
EXEC [dbo].[Refresh_Reseller];
GO

USE AW_DW;
GO

ALTER PROCEDURE [dbo].[Refresh_SalesTerritory]
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert New Sales Territories
    INSERT INTO DimSalesTerritory (SalesTerritoryAlternateKey, SalesTerritoryRegion, SalesTerritoryCountry, SalesTerritoryGroup)
    SELECT 
        stg.TerritoryID, 
        stg.SalesTerritoryRegion, 
        stg.SalesTerritoryCountry, 
        stg.SalesTerritoryGroup
    FROM AW_STAGE.dbo.stg_vw_SalesTerritory stg
    LEFT JOIN DimSalesTerritory d ON stg.TerritoryID = d.SalesTerritoryAlternateKey
    WHERE d.SalesTerritoryAlternateKey IS NULL;

    -- Update Existing Sales Territories
    UPDATE d
    SET 
        d.SalesTerritoryRegion = stg.SalesTerritoryRegion,
        d.SalesTerritoryCountry = stg.SalesTerritoryCountry,
        d.SalesTerritoryGroup = stg.SalesTerritoryGroup
    FROM DimSalesTerritory d
    INNER JOIN AW_STAGE.dbo.stg_vw_SalesTerritory stg
    ON d.SalesTerritoryAlternateKey = stg.TerritoryID;
END;
GO

-- Execute the procedure
EXEC [dbo].[Refresh_SalesTerritory];
GO

USE AW_DW;
GO

USE AW_STAGE;
GO



USE AW_STAGE;
GO

SELECT TOP 1 * FROM dbo.stg_vw_Customer;
GO