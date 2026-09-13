# PC Data Pipeline

A data engineering project demonstrating an end-to-end pipeline from raw flat-file ingestion
through dimensional modelling, staging, warehouse loading, data cleaning, and cloud migration.
Built using Microsoft SQL Server, with cloud infrastructure planned on Azure.

---

## Project Overview

The source data arrived as a single flat CSV file containing all records in one table.
The objective was to apply dimensional modelling principles to restructure this data into
meaningful, normalised dimension tables - separating concerns and laying the foundation for
a proper data warehouse.

The project is being built incrementally, with each stage documented and committed as it is completed.

---

## Data Model

> The draw.io schema below illustrates how the raw flat file was decomposed into dimension tables.

![Data Model](architecture\data-modelling\pc-data-modelling.drawio.png)
* Source file: `docs/data_model.drawio`*

---

## Pipeline Stages

| # | Stage | Status | Description |
|---|-------|--------|-------------|
| 1 | Ingestion | ✅ Done | Load raw CSV into MSSQL Server |
| 2 | Staging | ✅ Done | Split flat file into dimension tables via `stg_pc_data` |
| 3 | Warehouse Load | ✅ Done | Load transformed data from staging into the warehouse |
| 4 | Data Cleaning | ⬜ Planned | Clean and validate data within the warehouse layer |
| 5 | Automation | ✅ Done | Pipeline automated end-to-end via an SSIS package (`ssis_pc_data/`) |
| 6 | Cloud Migration | ⬜ Planned | Migrate to Azure (ADF, Synapse Analytics, Blob Storage) |

---

## Repository Structure

```
pc-data-pipeline/
│
├── README.md
├── .gitignore
├── CHANGELOG.md
│
├── data/
│   └── raw/
│       └── pc_data.csv              # Original source file (flat, unnormalised)
│
├── docs/
│   ├── data_model.drawio            # Editable draw.io schema
│   ├── data_model.png               # Exported PNG (embedded above)
│   └── architecture/
│       ├── on_prem_architecture.png # Current on-prem design
│       └── cloud_architecture.png   # Azure design (coming soon)
│
├── sql/
│   ├── 00_create_databases.sql       # Create pc_data, stg_pc_data and dwh_pc_data
│   ├── 01_ingestion/
│   │   └── create_raw_table.sql      # Create the raw landing table in pc_data
│   │
│   ├── 02_staging/
│   │   ├── create_staging_tables.sql # Create staging dimension and fact tables
│   │   └── load_staging_data.sql     # Split raw rows into staging tables
│   │
│   ├── 03_warehouse/
│   │   ├── create_warehouse_tables.sql # Create warehouse dimension and fact tables
│   │   └── load_warehouse_data.sql     # Load staging data into the warehouse
│   │
│   └── 04_cleaning/
│       └── .gitkeep                 # Planned
│
├── ssis_pc_data/
│   ├── Package.dtsx                 # SSIS Control Flow: automates the full pipeline
│   ├── ssis_pc_data.dtproj          # SSIS project file
│   └── ssis_pc_data.sln             # Visual Studio solution
│
├── cloud/
│   ├── infra/                       # IaC - Bicep / ARM / Terraform (planned)
│   │   └── .gitkeep
│   ├── pipelines/                   # ADF / Synapse pipeline configs (planned)
│   │   └── .gitkeep
│   └── storage/
│       └── storage_config.example.json   # Sanitised config template
│
└── automation/
    └── .gitkeep                     # Unused - automation implemented via SSIS instead (see ssis_pc_data/)
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Database | Microsoft SQL Server |
| Staging | MSSQL - `stg_pc_data` database |
| Warehouse | MSSQL - `dwh_pc_data` database |
| Data Modelling | Draw.io |
| Automation | SQL Server Integration Services (SSIS) |
| Cloud (planned) | Azure - ADF, Synapse Analytics, Blob Storage |

---

## How to Run (Current State)

### Option A: Automated (SSIS)

The full pipeline is automated as an SSIS package.

**Prerequisites**
- Microsoft SQL Server (any recent edition)
- Visual Studio with SQL Server Data Tools (SSDT) and the Integration Services extension installed
- The raw CSV file located at `data/raw/pc_data.csv`

**Steps**
1. Run `sql/00_create_databases.sql` once against your SQL Server instance (one-time setup - creates `pc_data`, `stg_pc_data`, `dwh_pc_data`). `CREATE DATABASE` can't run inside the package itself since it must be the only statement in its batch, so this stays a manual bootstrap step.
2. Open `ssis_pc_data/ssis_pc_data.sln` in Visual Studio.
3. Update the `pc_data` connection manager if your server name differs from the default.
4. Run `Package.dtsx` (F5). This executes, in order: create raw table -> load CSV into `pc_data` -> create staging tables -> load staging data -> create warehouse tables -> load warehouse data.

### Option B: Manual (SSMS)

Useful for debugging a single stage in isolation.

**Prerequisites**
- Microsoft SQL Server (any recent edition)
- SQL Server Management Studio (SSMS) or Azure Data Studio
- The raw CSV file located at `data/raw/pc_data.csv`

**Steps**

1. **Load raw data into MSSQL**
   - Run `sql/00_create_databases.sql`
   - Run `sql/01_ingestion/create_raw_table.sql`
   - Load `data/raw/pc_data.csv` into `pc_data.dbo.pc_data` manually

2. **Run staging transformations**
   - Run `sql/02_staging/create_staging_tables.sql`
   - Run `sql/02_staging/load_staging_data.sql`

3. **Load the warehouse**
   - Run `sql/03_warehouse/create_warehouse_tables.sql`
   - Run `sql/03_warehouse/load_warehouse_data.sql`

> The warehouse layer mirrors the staging model and keeps the same surrogate keys.

---

## Roadmap

- [x] Complete warehouse load scripts (`sql/03_warehouse/`)
- [x] Automate the pipeline end-to-end (`ssis_pc_data/`)
- [ ] Implement data cleaning layer (`sql/04_cleaning/`)
- [ ] Design Azure cloud architecture
- [ ] Provision Azure infrastructure via Bicep (`cloud/infra/`)
- [ ] Build ADF pipeline to replace the SSIS package (`cloud/pipelines/`)

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a full history of changes per stage.
