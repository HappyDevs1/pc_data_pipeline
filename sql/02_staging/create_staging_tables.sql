USE stg_pc_data;
GO

IF OBJECT_ID('dbo.stg_fact_table', 'U') IS NOT NULL DROP TABLE dbo.stg_fact_table;
IF OBJECT_ID('dbo.stg_dim_specs', 'U') IS NOT NULL DROP TABLE dbo.stg_dim_specs;
IF OBJECT_ID('dbo.stg_dim_sales', 'U') IS NOT NULL DROP TABLE dbo.stg_dim_sales;
IF OBJECT_ID('dbo.stg_dim_payment', 'U') IS NOT NULL DROP TABLE dbo.stg_dim_payment;
IF OBJECT_ID('dbo.stg_dim_shop', 'U') IS NOT NULL DROP TABLE dbo.stg_dim_shop;
IF OBJECT_ID('dbo.stg_dim_location', 'U') IS NOT NULL DROP TABLE dbo.stg_dim_location;
GO

CREATE TABLE dbo.stg_dim_location
(
    location_id INT IDENTITY(1, 1) PRIMARY KEY,
    continent NVARCHAR(250) NOT NULL,
    country NVARCHAR(250) NOT NULL,
    province NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.stg_dim_shop
(
    shop_id INT IDENTITY(1, 1) PRIMARY KEY,
    shop_name NVARCHAR(250) NOT NULL,
    shop_age INT NOT NULL
);

CREATE TABLE dbo.stg_dim_payment
(
    payment_id INT IDENTITY(1, 1) PRIMARY KEY,
    payment_method NVARCHAR(250) NOT NULL,
    channel NVARCHAR(250) NOT NULL,
    priority NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.stg_dim_sales
(
    sales_id INT IDENTITY(1, 1) PRIMARY KEY,
    sales_person_name NVARCHAR(250) NOT NULL,
    sales_person_department NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.stg_dim_specs
(
    spec_id INT IDENTITY(1, 1) PRIMARY KEY,
    pc_make NVARCHAR(250) NOT NULL,
    pc_model NVARCHAR(250) NOT NULL,
    storage_type NVARCHAR(250) NOT NULL,
    ram NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.stg_fact_table
(
    fact_id INT IDENTITY(1, 1) PRIMARY KEY,
    location_id INT NOT NULL,
    shop_id INT NOT NULL,
    spec_id INT NOT NULL,
    sales_id INT NOT NULL,
    payment_id INT NOT NULL,
    cost_price INT NULL,
    sale_price INT NULL,
    discount_amount INT NULL,
    finance_amount INT NULL,
    credit_score INT NULL,
    cost_of_repairs INT NULL,
    total_sales_per_employee INT NULL,
    pc_market_price INT NULL,
    ship_date DATE NULL
);
GO