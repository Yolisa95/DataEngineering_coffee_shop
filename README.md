# Coffee Shop Sales | SQL Server ETL Project

**Data Engineering | SQL Server | T-SQL | ETL | Stored Procedures | SQL Views**

## Project Overview

This project demonstrates the development of a SQL-based ETL process for managing coffee shop sales transactions using Microsoft SQL Server.

The objective is to extract sales data into a staging database, transform the data, and load it into a data warehouse. The project also demonstrates how SQL views and stored procedures can be used to organise and automate database operations.

## Project Objectives

- Create staging and data warehouse databases.
- Load coffee shop sales transactions into a staging table.
- Transform sales data by calculating the total price after discounts.
- Separate transactions according to payment methods.
- Create SQL views for simplified data retrieval.
- Use stored procedures to automate ETL operations.
- Verify the loaded data using SQL queries.

## Tools and Technologies

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Database development |
| T-SQL | Data transformation and loading |
| SQL Server Management Studio | Database management |
| SQL Views | Simplified data retrieval |
| Stored Procedures | Reusable database operations |
| ETL | Data extraction, transformation, and loading |

## Dataset Description

The project uses a sample dataset containing **15 coffee shop sales records**, covering different beverages, prices, discounts, sizes, and payment methods.

| Column | Description |
|---|---|
| `beverage` | Name of the beverage |
| `price` | Original selling price |
| `discount` | Discount applied |
| `total_price` | Final price after discount |
| `bev_size` | Beverage size |
| `payment_method` | Cash, card, or voucher |

The `total_price` column is calculated during transformation:

```sql
SELECT
    beverage,
    price,
    discount,
    price - discount AS total_price
FROM stg_coffee_shop.dbo.coffee_shop_sales;
```

## ETL Workflow

```text
Sample Coffee Shop Sales Data
             |
             v
      Staging Database
       stg_coffee_shop
             |
             v
      SQL Transformation
     (Price - Discount)
             |
             v
      Data Warehouse
       dwh_coffee_shop
             |
             v
    Payment Method Tables
      /      |       \
    Cash    Card    Voucher
             |
             v
       Data Verification
```

### 1. Database and Table Creation

The project creates two databases:

- `stg_coffee_shop` – Stores the original sales records.
- `dwh_coffee_shop` – Stores transformed sales records.

### 2. Data Transformation

Sales records are loaded from the staging database into the data warehouse.

The transformation calculates the final selling price using:

`total_price = price - discount`

The loading process also uses `NOT EXISTS` conditions to prevent duplicate beverage entries.

### 3. Payment Method Classification

Transactions are separated into three tables:

| Table | Description |
|---|---|
| `cash_payment` | Cash transactions |
| `payment_card` | Card transactions |
| `voucher_payment` | Voucher transactions |

### 4. SQL Views

A SQL view named `DISTINCT_PAYMENT_METHOD` retrieves the available payment methods without duplicates.

```sql
CREATE VIEW DISTINCT_PAYMENT_METHOD AS
SELECT DISTINCT payment_method
FROM dwh_coffee_shop.dbo.coffee_shop_sales;
```

### 5. Stored Procedures

The project includes a stored procedure named `usp_main_etl`, which combines table creation, data loading, and transformation operations into a reusable SQL process.

An additional stored procedure, `usp_test_table`, demonstrates table creation through a stored procedure.

## Project Repository Structure

All files are stored directly in the main GitHub repository.

```text
coffee-shop-sales-sql/
│
├── README.md
├── 0.1 coffee_shop_sales.sql
├── 0.2 create_view.sql
└── 0.3 stored_procedure.sql
```

## Project Files

| File | Description |
|---|---|
| `0.1 coffee_shop_sales.sql` | Creates databases, loads sales data, and separates transactions by payment method |
| `0.2 create_view.sql` | Verifies data, creates a SQL view, and demonstrates a stored procedure |
| `0.3 stored_procedure.sql` | Defines the main ETL stored procedure |

## How to Run the Project

1. Open Microsoft SQL Server Management Studio (SSMS).
2. Execute `0.1 coffee_shop_sales.sql` to create the databases and load the sample data.
3. Execute `0.2 create_view.sql` to inspect the tables and create the SQL view.
4. Execute `0.3 stored_procedure.sql` to create the reusable ETL procedure.
5. Run `usp_main_etl` when needed to execute the ETL workflow again.

**Note:** The view and stored procedures are created in the current database context, so select the intended database before executing those statements.

## Skills Demonstrated

- SQL Server Database Development
- SQL-Based ETL
- Data Transformation
- Staging and Data Warehouse Design
- SQL Views
- Stored Procedures
- Conditional Data Loading
- SQL Queries and Data Verification

## Conclusion

This project demonstrates how SQL Server can be used to build a simple ETL workflow for coffee shop sales data.

By creating staging and data warehouse databases, transforming sales values, separating payment methods, and implementing SQL views and stored procedures, the project demonstrates foundational data engineering and database automation skills.

## Author

**Yolisa Velebayi**

Data Engineering | Data Analytics | Business Intelligence

**GitHub:** [github.com/Yolisa95](https://github.com/Yolisa95)

---

*Part of my data engineering portfolio showcasing SQL Server, ETL, and database development skills.*
