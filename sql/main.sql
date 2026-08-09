-- Execution order for the split SQL pipeline:
-- 1. sql/00_create_databases.sql
-- 2. sql/01_ingestion/create_raw_table.sql
-- 3. Manually load data into pc_data.dbo.pc_data from data/raw/pc_data.csv
-- 4. sql/02_staging/create_staging_tables.sql
-- 5. sql/02_staging/load_staging_data.sql
-- 6. sql/03_warehouse/create_warehouse_tables.sql
-- 7. sql/03_warehouse/load_warehouse_data.sql

-- This file is kept as a simple entry point so the old broken monolith is no longer used.