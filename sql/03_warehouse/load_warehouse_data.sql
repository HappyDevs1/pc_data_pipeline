USE dwh_pc_data;
GO

DELETE FROM dbo.fact_table;
DELETE FROM dbo.dim_specs;
DELETE FROM dbo.dim_sales;
DELETE FROM dbo.dim_payment;
DELETE FROM dbo.dim_shop;
DELETE FROM dbo.dim_location;
GO

SET IDENTITY_INSERT dbo.dim_location ON;
INSERT INTO dbo.dim_location (location_id, continent, country, province)
SELECT location_id, continent, country, province
FROM stg_pc_data.dbo.stg_dim_location;
SET IDENTITY_INSERT dbo.dim_location OFF;

SET IDENTITY_INSERT dbo.dim_shop ON;
INSERT INTO dbo.dim_shop (shop_id, shop_name, shop_age)
SELECT shop_id, shop_name, shop_age
FROM stg_pc_data.dbo.stg_dim_shop;
SET IDENTITY_INSERT dbo.dim_shop OFF;

SET IDENTITY_INSERT dbo.dim_payment ON;
INSERT INTO dbo.dim_payment (payment_id, payment_method, channel, priority)
SELECT payment_id, payment_method, channel, priority
FROM stg_pc_data.dbo.stg_dim_payment;
SET IDENTITY_INSERT dbo.dim_payment OFF;

SET IDENTITY_INSERT dbo.dim_sales ON;
INSERT INTO dbo.dim_sales (sales_id, sales_person_name, sales_person_department)
SELECT sales_id, sales_person_name, sales_person_department
FROM stg_pc_data.dbo.stg_dim_sales;
SET IDENTITY_INSERT dbo.dim_sales OFF;

SET IDENTITY_INSERT dbo.dim_specs ON;
INSERT INTO dbo.dim_specs (spec_id, pc_make, pc_model, storage_type, ram)
SELECT spec_id, pc_make, pc_model, storage_type, ram
FROM stg_pc_data.dbo.stg_dim_specs;
SET IDENTITY_INSERT dbo.dim_specs OFF;

INSERT INTO dbo.fact_table
(
    location_id,
    shop_id,
    spec_id,
    sales_id,
    payment_id,
    cost_price,
    sale_price,
    discount_amount,
    finance_amount,
    credit_score,
    cost_of_repairs,
    total_sales_per_employee,
    pc_market_price,
    ship_date
)
SELECT
    location_id,
    shop_id,
    spec_id,
    sales_id,
    payment_id,
    cost_price,
    sale_price,
    discount_amount,
    finance_amount,
    credit_score,
    cost_of_repairs,
    total_sales_per_employee,
    pc_market_price,
    ship_date
FROM stg_pc_data.dbo.stg_fact_table;
GO