# Olist Brazilian E-Commerce — SQL Analyst Portfolio Project

## Project goal
Build an end-to-end, client-style e-commerce analytics project using the real, anonymised Brazilian E-Commerce Public Dataset by Olist. The dataset contains about 100,000 orders from 2016–2018 and related customer, product, seller, payment, review and geolocation information.

## Source
Dataset: Brazilian E-Commerce Public Dataset by Olist on Kaggle.

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset publisher describes it as real commercial data that has been anonymised. Use the dataset for learning/portfolio analysis and follow the dataset's license/terms when publishing.

## What you will build
1. PostgreSQL relational database
2. Raw data ingestion from CSV
3. Data-quality checks
4. Analytical views
5. Business KPI layer
6. Customer, product, seller, payment, review and delivery analysis
7. Cohort/retention analysis
8. RFM-style customer segmentation
9. Seller performance analysis
10. Delivery SLA analysis
11. Revenue/profit proxy analysis
12. Advanced SQL interview cases
13. Python validation and charts
14. 5-slide client presentation

## Raw files required
Place these nine CSVs in `data/raw/`:
- olist_customers_dataset.csv
- olist_orders_dataset.csv
- olist_order_items_dataset.csv
- olist_order_payments_dataset.csv
- olist_order_reviews_dataset.csv
- olist_products_dataset.csv
- olist_sellers_dataset.csv
- olist_geolocation_dataset.csv
- product_category_name_translation.csv

Do NOT commit the raw dataset to a public GitHub repository unless its license/terms clearly allow it. Prefer documenting the source and download steps instead.

## Recommended stack
- PostgreSQL
- DBeaver or pgAdmin
- Python 3.11+
- pandas
- SQLAlchemy
- matplotlib
- seaborn

## Project question
Management wants to know:

> How is the marketplace performing, what drives revenue and customer value, where are retention and delivery problems, and which products/sellers/categories deserve attention?

## Important business definitions
### Revenue
For item-level merchandise analysis:
`item_gmv = price + freight_value` is used only as a gross order-value proxy.

For product sales analysis, `price` represents the item price recorded in the dataset. Freight is kept separately because it is not product revenue.

### Delivered order
`order_status = 'delivered'`.

### Delivery delay
`actual_delivery_date - estimated_delivery_date` in days. Positive = late.

### Customer
Use `customer_unique_id` for customer-level behavior because one unique customer can appear across multiple order-specific customer IDs.

### RFM
- Recency = days since the latest delivered purchase in the dataset snapshot
- Frequency = number of delivered orders
- Monetary = total merchandise price for delivered orders

These are analytical definitions for this portfolio project, not Olist's official KPIs.

## Folder structure
```
olist_portfolio/
├── README.md
├── data/raw/                 # put downloaded Olist CSVs here
├── sql/
│   ├── 01_schema.sql
│   ├── 02_load.sql
│   ├── 03_quality_checks.sql
│   ├── 04_base_views.sql
│   ├── 05_kpis.sql
│   ├── 06_customer_analysis.sql
│   ├── 07_product_analysis.sql
│   ├── 08_seller_analysis.sql
│   ├── 09_delivery_reviews.sql
│   ├── 10_retention_rfm.sql
│   ├── 11_advanced_interview_cases.sql
│   └── 12_final_client_report.sql
├── python/
│   └── olist_analysis.py
└── docs/
    ├── data_dictionary.md
    ├── interview_story.md
    └── execution_plan.md
```

## 8–10 hour execution plan
### Hour 1 — Setup and schema
Download the dataset, inspect CSVs, create database, run `01_schema.sql`, understand every relationship.

### Hour 2 — Loading and data quality
Run `02_load.sql`, then `03_quality_checks.sql`. Record every issue rather than blindly ignoring it.

### Hour 3 — Base analytical layer
Run `04_base_views.sql`. Inspect row counts, grain and the key derived fields.

### Hour 4 — Business KPIs
Run `05_kpis.sql`. Re-write at least five queries without looking at the answers.

### Hour 5 — Customers and products
Work through `06_customer_analysis.sql` and `07_product_analysis.sql`.

### Hour 6 — Sellers, delivery and reviews
Work through `08_seller_analysis.sql` and `09_delivery_reviews.sql`.

### Hour 7 — Retention and RFM
Complete `10_retention_rfm.sql` and interpret the segments in plain English.

### Hour 8 — Interview cases
Complete `11_advanced_interview_cases.sql` under a timer.

### Hour 9 — Client report
Run `12_final_client_report.sql`, pick 5–7 findings and turn them into a story.

### Hour 10 — Python and presentation
Run `python/olist_analysis.py`, create 4–6 charts, and build the final 5-slide deck.

## What to publish
- README with problem statement, data model and findings
- SQL scripts
- Python analysis script/notebook
- 5-slide PDF or PPTX presentation
- Screenshots of 2–3 strong query outputs
- No raw dataset unless permitted

## Suggested repository name
`olist-ecommerce-sql-business-analytics`
