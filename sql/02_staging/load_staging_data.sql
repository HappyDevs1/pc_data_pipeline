USE stg_pc_data;
GO

DELETE FROM dbo.stg_fact_table;
DELETE FROM dbo.stg_dim_specs;
DELETE FROM dbo.stg_dim_sales;
DELETE FROM dbo.stg_dim_payment;
DELETE FROM dbo.stg_dim_shop;
DELETE FROM dbo.stg_dim_location;
GO

INSERT INTO dbo.stg_dim_location (continent, country, province)
SELECT DISTINCT
    LTRIM(RTRIM(src.[Continent])),
    LTRIM(RTRIM(src.[Country or State])),
    LTRIM(RTRIM(src.[Province or City]))
FROM pc_data.dbo.pc_data AS src
WHERE NULLIF(LTRIM(RTRIM(src.[Continent])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[Country or State])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[Province or City])), '') IS NOT NULL;

INSERT INTO dbo.stg_dim_shop (shop_name, shop_age)
SELECT DISTINCT
    LTRIM(RTRIM(src.[Shop Name])),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Shop Age])), ''))
FROM pc_data.dbo.pc_data AS src
WHERE NULLIF(LTRIM(RTRIM(src.[Shop Name])), '') IS NOT NULL;

INSERT INTO dbo.stg_dim_payment (payment_method, channel, priority)
SELECT DISTINCT
    LTRIM(RTRIM(src.[Payment Method])),
    LTRIM(RTRIM(src.[Channel])),
    LTRIM(RTRIM(src.[Priority]))
FROM pc_data.dbo.pc_data AS src
WHERE NULLIF(LTRIM(RTRIM(src.[Payment Method])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[Channel])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[Priority])), '') IS NOT NULL;

INSERT INTO dbo.stg_dim_sales (sales_person_name, sales_person_department)
SELECT DISTINCT
    LTRIM(RTRIM(src.[Sales Person Name])),
    LTRIM(RTRIM(src.[Sales Person Department]))
FROM pc_data.dbo.pc_data AS src
WHERE NULLIF(LTRIM(RTRIM(src.[Sales Person Name])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[Sales Person Department])), '') IS NOT NULL;

INSERT INTO dbo.stg_dim_specs (pc_make, pc_model, storage_type, ram)
SELECT DISTINCT
    LTRIM(RTRIM(src.[PC Make])),
    LTRIM(RTRIM(src.[PC Model])),
    LTRIM(RTRIM(src.[Storage Type])),
    LTRIM(RTRIM(src.[RAM]))
FROM pc_data.dbo.pc_data AS src
WHERE NULLIF(LTRIM(RTRIM(src.[PC Make])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[PC Model])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[Storage Type])), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(src.[RAM])), '') IS NOT NULL;

INSERT INTO dbo.stg_fact_table
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
    l.location_id,
    sh.shop_id,
    sp.spec_id,
    sa.sales_id,
    pa.payment_id,
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Cost Price])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Sale Price])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Discount Amount])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Finance Amount])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Credit Score])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Cost of Repairs])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Total Sales per Employee])), '')),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[PC Market Price])), '')),
    TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(src.[Ship Date])), 'N/A'))
FROM pc_data.dbo.pc_data AS src
INNER JOIN dbo.stg_dim_location AS l
    ON  LTRIM(RTRIM(src.[Continent])) = l.continent
    AND LTRIM(RTRIM(src.[Country or State])) = l.country
    AND LTRIM(RTRIM(src.[Province or City])) = l.province
INNER JOIN dbo.stg_dim_shop AS sh
    ON  LTRIM(RTRIM(src.[Shop Name])) = sh.shop_name
    AND TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(src.[Shop Age])), '')) = sh.shop_age
INNER JOIN dbo.stg_dim_specs AS sp
    ON  LTRIM(RTRIM(src.[PC Make])) = sp.pc_make
    AND LTRIM(RTRIM(src.[PC Model])) = sp.pc_model
    AND LTRIM(RTRIM(src.[Storage Type])) = sp.storage_type
    AND LTRIM(RTRIM(src.[RAM])) = sp.ram
INNER JOIN dbo.stg_dim_sales AS sa
    ON  LTRIM(RTRIM(src.[Sales Person Name])) = sa.sales_person_name
    AND LTRIM(RTRIM(src.[Sales Person Department])) = sa.sales_person_department
INNER JOIN dbo.stg_dim_payment AS pa
    ON  LTRIM(RTRIM(src.[Payment Method])) = pa.payment_method
    AND LTRIM(RTRIM(src.[Channel])) = pa.channel
    AND LTRIM(RTRIM(src.[Priority])) = pa.priority;
GO