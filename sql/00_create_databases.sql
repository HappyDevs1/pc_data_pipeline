USE master;
GO

IF DB_ID('pc_data') IS NULL
BEGIN
    CREATE DATABASE pc_data;
END;
GO

IF DB_ID('stg_pc_data') IS NULL
BEGIN
    CREATE DATABASE stg_pc_data;
END;
GO

IF DB_ID('dwh_pc_data') IS NULL
BEGIN
    CREATE DATABASE dwh_pc_data;
END;
GO