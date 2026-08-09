USE dwh_pc_data;
GO

IF OBJECT_ID('dbo.fact_table', 'U') IS NOT NULL DROP TABLE dbo.fact_table;
IF OBJECT_ID('dbo.dim_specs', 'U') IS NOT NULL DROP TABLE dbo.dim_specs;
IF OBJECT_ID('dbo.dim_sales', 'U') IS NOT NULL DROP TABLE dbo.dim_sales;
IF OBJECT_ID('dbo.dim_payment', 'U') IS NOT NULL DROP TABLE dbo.dim_payment;
IF OBJECT_ID('dbo.dim_shop', 'U') IS NOT NULL DROP TABLE dbo.dim_shop;
IF OBJECT_ID('dbo.dim_location', 'U') IS NOT NULL DROP TABLE dbo.dim_location;
GO

CREATE TABLE dbo.dim_location
(
    location_id INT IDENTITY(1, 1) PRIMARY KEY,
    continent NVARCHAR(250) NOT NULL,
    country NVARCHAR(250) NOT NULL,
    province NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.dim_shop
(
    shop_id INT IDENTITY(1, 1) PRIMARY KEY,
    shop_name NVARCHAR(250) NOT NULL,
    shop_age INT NOT NULL
);

CREATE TABLE dbo.dim_payment
(
    payment_id INT IDENTITY(1, 1) PRIMARY KEY,
    payment_method NVARCHAR(250) NOT NULL,
    channel NVARCHAR(250) NOT NULL,
    priority NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.dim_sales
(
    sales_id INT IDENTITY(1, 1) PRIMARY KEY,
    sales_person_name NVARCHAR(250) NOT NULL,
    sales_person_department NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.dim_specs
(
    spec_id INT IDENTITY(1, 1) PRIMARY KEY,
    pc_make NVARCHAR(250) NOT NULL,
    pc_model NVARCHAR(250) NOT NULL,
    storage_type NVARCHAR(250) NOT NULL,
    ram NVARCHAR(250) NOT NULL
);

CREATE TABLE dbo.fact_table
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
    ship_date DATE NULL,
    CONSTRAINT FK_fact_table_dim_location FOREIGN KEY (location_id) REFERENCES dbo.dim_location (location_id),
    CONSTRAINT FK_fact_table_dim_shop FOREIGN KEY (shop_id) REFERENCES dbo.dim_shop (shop_id),
    CONSTRAINT FK_fact_table_dim_specs FOREIGN KEY (spec_id) REFERENCES dbo.dim_specs (spec_id),
    CONSTRAINT FK_fact_table_dim_sales FOREIGN KEY (sales_id) REFERENCES dbo.dim_sales (sales_id),
    CONSTRAINT FK_fact_table_dim_payment FOREIGN KEY (payment_id) REFERENCES dbo.dim_payment (payment_id)
);
GO