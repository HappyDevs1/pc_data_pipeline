USE pc_data;
GO

IF OBJECT_ID('dbo.pc_data', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.pc_data;
END;
GO

CREATE TABLE dbo.pc_data
(
    [Continent] NVARCHAR(255) NULL,
    [Country or State] NVARCHAR(255) NULL,
    [Province or City] NVARCHAR(255) NULL,
    [Shop Name] NVARCHAR(255) NULL,
    [Shop Age] NVARCHAR(255) NULL,
    [PC Make] NVARCHAR(255) NULL,
    [PC Model] NVARCHAR(255) NULL,
    [Storage Type] NVARCHAR(255) NULL,
    [Customer Name] NVARCHAR(255) NULL,
    [Customer Surname] NVARCHAR(255) NULL,
    [Customer Contact Number] NVARCHAR(255) NULL,
    [Customer Email Address] NVARCHAR(255) NULL,
    [Sales Person Name] NVARCHAR(255) NULL,
    [Sales Person Department] NVARCHAR(255) NULL,
    [Cost Price] NVARCHAR(255) NULL,
    [Sale Price] NVARCHAR(255) NULL,
    [Payment Method] NVARCHAR(255) NULL,
    [Discount Amount] NVARCHAR(255) NULL,
    [Purchase Date] NVARCHAR(255) NULL,
    [Ship Date] NVARCHAR(255) NULL,
    [Finance Amount] NVARCHAR(255) NULL,
    [RAM] NVARCHAR(255) NULL,
    [Credit Score] NVARCHAR(255) NULL,
    [Channel] NVARCHAR(255) NULL,
    [Priority] NVARCHAR(255) NULL,
    [Cost of Repairs] NVARCHAR(255) NULL,
    [Total Sales per Employee] NVARCHAR(255) NULL,
    [PC Market Price] NVARCHAR(255) NULL,
    [Storage Capacity] NVARCHAR(255) NULL
);
GO