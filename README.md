# Retail Sales & Customer Intelligence (PostgreSQL)

A SQL analysis of **Duka Smart Electronics**, a fictional Kenyan retailer (phones, laptops, accessories, TVs and appliances in ten towns). The project sets up a PostgreSQL database, answers 46 business questions, and turns the results into recommendations for management.

All people and companies in the data are fictional. Data covers January 2025 to September 2026: 150 customers and 800 orders.

## What is in this repo

| File | Purpose |
|---|---|
| `schema.sql` | `CREATE TABLE` statements for `customers` and `orders`, with keys, constraints and indexes |
| `queries.sql` | All 46 answers, each under a `-- Q1` … `-- Q46` comment, plus two stretch tasks |
| `insights.md` | Eight business insights, each with the number, why it matters and a recommendation |
| `screenshots/` | Output of the data-verification script and selected query results |

## Setting up

You need PostgreSQL 14 or newer.

1. Create the database (connected to any other database, e.g. `postgres`):
   ```bash
   psql -U postgres -d postgres -c "CREATE DATABASE retail_analytics;"
   ```
2. Create the tables:
   ```bash
   psql -U postgres -d retail_analytics -f schema.sql
   ```
3. Load the data with the course files `03_insert_customers.sql` then `04_insert_orders.sql` (customers first, because orders reference them):
   ```bash
   psql -U postgres -d retail_analytics -f 03_insert_customers.sql
   psql -U postgres -d retail_analytics -f 04_insert_orders.sql
   ```
4. Check it loaded (should show 150 customers, 800 orders, 0 orders with no customer):
   ```bash
   psql -U postgres -d retail_analytics -f 05_verify_data.sql
   ```

## Running the queries

```bash
psql -U postgres -d retail_analytics -f queries.sql
```

Or open `queries.sql` in pgAdmin / DBeaver and run one question at a time. Q43 creates a view (`monthly_sales_summary`) and Q44 creates a function (`get_customer_revenue`); both use `CREATE OR REPLACE`, so the file is safe to run more than once.

## Business rules used

| Measure | Definition |
|---|---|
| Revenue | `quantity * unit_price * (1 - discount / 100)` |
| Cost / Profit | `quantity * cost_price` / revenue minus cost |
| Profit margin % | `profit / revenue * 100`, using `NULLIF` to avoid division by zero |

- Money questions use **Completed** orders only. Order counts include every status.
- "Today" is the latest `order_date` in the data (30 September 2026), not the computer's date.
- Months mean year and month together (`DATE_TRUNC('month', order_date)`).

Where a question was open to interpretation (for example "popular" in Q28, or the value-band thresholds in Q45), the definition is explained in a comment above the query.

## Stretch work

- **Cohort retention:** the final query in `queries.sql` groups customers by the month of their first order and shows how many ordered again in later months.


## Key findings

See `insights.md`. In short: accessories have a 42% margin against about 10% for everything else, discounts of 20% and above lose money, and 47 of 132 buyers have not ordered in 90 days.