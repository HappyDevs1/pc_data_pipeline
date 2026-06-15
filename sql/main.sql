CREATE DATABASE dwh_pc_data

SELECT * FROM stg_pc_data.[dbo].pc_data

DROP TABLE stg_pc_data.[dbo].stg_dim_location

CREATE TABLE stg_pc_data.[dbo].stg_dim_location
(
    [location_id] INT IDENTITY(1, 1),
    [continent] [varchar](250) NOT NULL,
    [country] [varchar] (250),
    [province] [varchar] (250)
)

-- Load stg.dim_location data
INSERT INTO stg_pc_data.[dbo].stg_dim_location (continent, country, province)
SELECT DISTINCT Continent, Country_or_State, Province_or_City
FROM stg_pc_data.[dbo].pc_data

-- Create stg_dim_shop table and load data
CREATE TABLE stg_pc_data.[dbo].stg_dim_shop
(
    [shop_id] INT IDENTITY(1, 1),
    [shop_name] [varchar](250) NOT NULL,
    [shop_age] [int],
)

-- Load stg.dim_location data
INSERT INTO stg_pc_data.[dbo].stg_dim_shop(shop_name, shop_age)
SELECT DISTINCT Shop_Name, Shop_Age
FROM stg_pc_data.[dbo].pc_data

-- Create stg_dim_payment table and load data
CREATE TABLE stg_pc_data.[dbo].stg_dim_payment
(
    [payment_id] INT IDENTITY(1, 1),
    [payment_method] [varchar](250) NOT NULL,
    [channel] [varchar](250),
    [priority] [varchar](250)
)

-- Load stg.dim_payment data
INSERT INTO stg_pc_data.[dbo].stg_dim_payment(payment_method, channel, [priority])
SELECT DISTINCT Payment_Method, Channel, [Priority]
FROM stg_pc_data.[dbo].pc_data

-- Create stg_dim_sales table
CREATE TABLE stg_pc_data.[dbo].stg_dim_sales
(
    [sales_id] INT IDENTITY(1, 1),
    [sales_person_name] [varchar](250) NOT NULL,
    [sales_person_department] [varchar](250),
)

-- Load stg_dim_sales table data
INSERT INTO stg_pc_data.[dbo].stg_dim_sales(sales_person_name, sales_person_department)
SELECT DISTINCT Sales_Person_Name, Sales_Person_Department
FROM stg_pc_data.[dbo].pc_data

-- Create stg_dim_specs table
CREATE TABLE stg_pc_data.[dbo].stg_dim_specs
(
    [spec_id] INT IDENTITY(1, 1),
    [pc_make] [varchar](250) NOT NULL,
    [pc_model] [varchar](250),
    [storage_type] [varchar](250),
    [ram] [varchar](250),
)

-- Load stg_dim_specs table data
INSERT INTO stg_pc_data.[dbo].stg_dim_specs(pc_make, pc_model, storage_type, ram)
SELECT DISTINCT PC_Make, PC_Model, Storage_Type, RAM
FROM stg_pc_data.[dbo].pc_data

--Create a fact table
CREATE TABLE stg_pc_data.[dbo].stg_fact_table
(
    [fact_id] INT IDENTITY(1, 1),
    [location_id] [int],
    [shop_id] [int],
    [spec_id] [int],
    [sales_id] [int],
    [payment_id] [int],
    [cost_price] [int],
    [sale_price] [int],
    [discount_amount] [int],
    [finance_amount] [int],
    [credit_score] [int],
    [cost_of_repairs] [int],
    [total_sales_per_employee] [int],
    [pc_market_price] [int],
    [purchase_price] [int],
    [ship_date] Date,

)

-- Clear the fact table first if it exist
DROP TABLE IF EXISTS stg_pc_data.[dbo].[stg_fact_table]

CREATE TABLE stg_pc_data.[dbo].[stg_fact_table]
(
    [fact_id] INT IDENTITY(1, 1),
    [location_id] [int],
    [shop_id] [int],
    [spec_id] [int],
    [sales_id] [int],
    [payment_id] [int],
    [cost_price] [int],
    [sale_price] [int],
    [discount_amount] [int],
    [finance_amount] [int],
    [credit_score] [int],
    [cost_of_repairs] [int],
    [total_sales_per_employee] [int],
    [pc_market_price] [int],
    [ship_date] Date
)

INSERT INTO stg_pc_data.[dbo].[stg_fact_table] (
    location_id, shop_id, spec_id, sales_id, payment_id,
    cost_price, sale_price, discount_amount, finance_amount,
    credit_score, cost_of_repairs, total_sales_per_employee,
    pc_market_price, ship_date
)
SELECT
    l.location_id,
    sh.shop_id,
    sp.spec_id,
    s.sales_id,
    p.payment_id,
    src.[Cost_Price],
    src.[Sale_Price],
    src.[Discount_Amount],
    src.[Finance_Amount],
    src.[Credit_Score],
    src.[Cost_of_Repairs],
    src.[Total_Sales_per_Employee],
    src.[PC_Market_Price],
    TRY_CONVERT(Date, src.[Ship_Date])
FROM stg_pc_data.[dbo].pc_data src
JOIN stg_pc_data.[dbo].stg_dim_location l
    ON  src.[Continent]        = l.continent
    AND src.[Country_or_State] = l.country
    AND src.[Province_or_City] = l.province
JOIN stg_pc_data.[dbo].stg_dim_shop sh
    ON  src.[Shop_Name] = sh.shop_name
    AND src.[Shop_Age]  = sh.shop_age
JOIN stg_pc_data.[dbo].stg_dim_specs sp
    ON  src.[PC_Make]      = sp.pc_make
    AND src.[PC_Model]     = sp.pc_model
    AND src.[Storage_Type] = sp.storage_type
    AND src.[RAM]          = sp.ram
JOIN stg_pc_data.[dbo].stg_dim_sales s
    ON  src.[Sales_Person_Name]       = s.sales_person_name
    AND src.[Sales_Person_Department] = s.sales_person_department
JOIN stg_pc_data.[dbo].stg_dim_payment p
    ON  src.[Payment_Method] = p.payment_method
    AND src.[Channel]        = p.channel
    AND src.[Priority]       = p.priority

-- Move data from the stg_pc_data into dwh_pc_data
-- Move dimension tables
SELECT * INTO dwh_pc_data.[dbo].[dim_location]
FROM stg_pc_data.[dbo].[stg_dim_location]

SELECT * INTO dwh_pc_data.[dbo].[dim_shop]
FROM stg_pc_data.[dbo].[stg_dim_shop]

SELECT * INTO dwh_pc_data.[dbo].[dim_payment]
FROM stg_pc_data.[dbo].[stg_dim_payment]

SELECT * INTO dwh_pc_data.[dbo].[dim_sales]
FROM stg_pc_data.[dbo].[stg_dim_sales]

SELECT * INTO dwh_pc_data.[dbo].[dim_specs]
FROM stg_pc_data.[dbo].[stg_dim_specs]

-- Move fact table
SELECT * INTO dwh_pc_data.[dbo].[fact_table]
FROM stg_pc_data.[dbo].[stg_fact_table]

-- Confirm if data was copied correctly
SELECT * FROM dwh_pc_data.[dbo].[fact_table]
SELECT * FROM dwh_pc_data.[dbo].[dim_location]

SELECT COUNT(*) FROM stg_pc_data.[dbo].[stg_fact_table]