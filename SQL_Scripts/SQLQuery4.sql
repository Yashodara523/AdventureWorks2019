USE AdventureWorksDW;
GO

-- Product Dimension
CREATE TABLE DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(255),
    ProductCategory NVARCHAR(255),
    ProductSubcategory NVARCHAR(255)
);

-- Customer Dimension
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CustomerName NVARCHAR(255),
    TerritoryID INT
);

-- Territory Dimension
CREATE TABLE DimTerritory (
    TerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID INT,
    TerritoryName NVARCHAR(255)
);

-- Date Dimension
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    Day INT
);

-- Fact Sales Table
CREATE TABLE FactSales (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey),
    CustomerKey INT FOREIGN KEY REFERENCES DimCustomer(CustomerKey),
    TerritoryKey INT FOREIGN KEY REFERENCES DimTerritory(TerritoryKey),
    DateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    QuantitySold INT,
    SalesAmount DECIMAL(10,2),
    OrderDueDate DATE
);

-- Fact Sales Order Forecast Table
CREATE TABLE FactSalesOrderForecast (
    ForecastKey INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryKey INT FOREIGN KEY REFERENCES DimTerritory(TerritoryKey),
    DateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    ForecastedSalesAmount DECIMAL(10,2)
);
