USE AdventureWorksDW; -- Use your data warehouse database
GO

CREATE TABLE SalesOrderForecast (
    Year INT,
    MonthName NVARCHAR(50),
    SalesOrder DECIMAL(18, 2)
);

USE AdventureWorksDW;
GO

ALTER TABLE SalesOrderForecast
ALTER COLUMN MonthName NVARCHAR(50);


USE AdventureWorksDW;
GO

SELECT * FROM SalesOrderForecast;

USE AdventureWorksDW;
GO

USE AdventureWorksDW;
GO

CREATE TABLE [dbo].[FactSales] (
    [SalesKey] INT PRIMARY KEY IDENTITY(1,1),
    [ProductKey] INT NOT NULL,
    [TerritoryKey] INT NOT NULL,
    [DateKey] INT NOT NULL, -- Reference to DimDate
    [SalesOrderID] INT NOT NULL,
    [SalesAmount] DECIMAL(18, 2) NOT NULL,
    [Quantity] INT NOT NULL,
    FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProduct]([ProductKey]),
    FOREIGN KEY ([TerritoryKey]) REFERENCES [dbo].[DimTerritory]([TerritoryKey]),
    FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])
);
GO

USE AdventureWorksDW;
GO

SELECT * FROM SalesOrderForecast;

-- FactForecast Table
CREATE TABLE FactForecast (
    ForecastKey INT PRIMARY KEY IDENTITY(1,1),
    TimeKey INT,
    SalesOrder DECIMAL(18, 2)
);