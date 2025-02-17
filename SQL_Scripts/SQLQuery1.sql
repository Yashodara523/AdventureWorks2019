USE [AdventureWorksDW]
GO

/****** Object:  Table [dbo].[DimDate]    Script Date: 2/16/2025 12:26:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



USE AdventureWorksDW; -- Replace with your data warehouse database name
GO

CREATE TABLE [dbo].[DimDate] (
    [DateKey] INT NOT NULL PRIMARY KEY, -- Surrogate key for the date (e.g., YYYYMMDD)
    [FullDate] DATE NOT NULL,           -- Full date in DATE format
    [Year] INT NOT NULL,                -- Year (e.g., 2023)
    [Quarter] INT NOT NULL,             -- Quarter (1, 2, 3, 4)
    [Month] INT NOT NULL,               -- Month number (1 to 12)
    [MonthName] NVARCHAR(50) NOT NULL, -- Month name (e.g., January, February)
    [Day] INT NOT NULL,                -- Day of the month (1 to 31)
    [DayOfWeek] INT NOT NULL,          -- Day of the week (1 = Sunday, 2 = Monday, etc.)
    [DayName] NVARCHAR(50) NOT NULL,   -- Day name (e.g., Sunday, Monday)
    [IsWeekend] BIT NOT NULL           -- Indicates if the day is a weekend (1 = Weekend, 0 = Weekday)
);
GO

USE AdventureWorksDW;
GO

-- Declare start and end dates
DECLARE @StartDate DATE = '2010-01-01';
DECLARE @EndDate DATE = '2030-12-31';

-- Loop through each date and insert into DimDate
WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO [dbo].[DimDate] (
        [DateKey],
        [FullDate],
        [Year],
        [Quarter],
        [Month],
        [MonthName],
        [Day],
        [DayOfWeek],
        [DayName],
        [IsWeekend]
    )
    VALUES (
        CONVERT(INT, CONVERT(VARCHAR(8), @StartDate, 112)), -- DateKey (YYYYMMDD)
        @StartDate,                                          -- FullDate
        YEAR(@StartDate),                                    -- Year
        DATEPART(QUARTER, @StartDate),                       -- Quarter
        MONTH(@StartDate),                                   -- Month
        DATENAME(MONTH, @StartDate),                         -- MonthName
        DAY(@StartDate),                                     -- Day
        DATEPART(WEEKDAY, @StartDate),                       -- DayOfWeek
        DATENAME(WEEKDAY, @StartDate),                       -- DayName
        CASE WHEN DATENAME(WEEKDAY, @StartDate) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END -- IsWeekend
    );

    -- Move to the next day
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

USE AdventureWorksDW;
GO

SELECT TOP 10 * FROM [dbo].[DimDate];

SELECT TOP 10 * FROM DimDate;
