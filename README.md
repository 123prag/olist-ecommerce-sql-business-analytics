# Olist Brazilian E-Commerce — SQL Business Analytics

> End-to-end, SQL-first business analytics project using PostgreSQL, Python, Docker, and Power BI on the Brazilian E-Commerce Public Dataset by Olist.

## Project overview

This project transforms relational e-commerce data into a reproducible analytics workflow:

```text
Olist source CSVs
        │
        ▼
PostgreSQL raw schema
        │
        ▼
Data-quality checks
        │
        ▼
Reusable analytical views
        │
        ├── Marketplace KPIs
        ├── Customer analysis
        ├── Product/category analysis
        ├── Seller analysis
        ├── Delivery & review analysis
        ├── Cohort retention
        ├── RFM segmentation
        └── Advanced SQL interview cases
        │
        ▼
Python validation & visualisation
        │
        ▼
Power BI / client reporting
```

## Business question

Management wants to understand:

> **How is the marketplace performing, what drives revenue and customer value, where are retention and delivery problems, and which products, sellers, and categories deserve attention?**

The project is designed to answer that question with transparent metric definitions, validated SQL, and business-oriented reporting.

---

## Dataset

**Brazilian E-Commerce Public Dataset by Olist**

Source:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The project uses the historical Olist marketplace snapshot covering approximately 100,000 orders from 2016–2018, together with customer, product, seller, payment, review, and geolocation information.

The source dataset is anonymised. Review the source's current license and terms before redistributing the raw CSV files.

### Raw-data policy

The raw Olist CSV files should normally remain local and should not be committed to the public repository unless the applicable source terms explicitly allow redistribution.

See [`data/readme.md`](data/readme.md).

---

## What this project demonstrates

- PostgreSQL relational database design
- CSV ingestion into a raw schema
- SQL data-quality validation
- Analytical-view design
- Correct handling of table grain
- CTEs and multi-step SQL transformations
- Joins and conditional aggregation
- Window functions
- `ROW_NUMBER()`, `RANK()`, `LAG()`, `LEAD()`
- Running totals and period comparisons
- Customer-level behavioral analysis
- Product and category performance analysis
- Seller analysis
- Delivery SLA analysis
- Review-score analysis
- RFM-style customer segmentation
- Cohort and retention analysis
- Python validation and visualization
- Power BI-ready reporting
- Dockerized PostgreSQL development
- Client-style business communication

---

## Technology stack

| Layer | Technology |
|---|---|
| Database | PostgreSQL 16 |
| Local infrastructure | Docker / Docker Compose |
| SQL client | DBeaver Community |
| Analysis | SQL + Python |
| Python | pandas, SQLAlchemy, psycopg2, matplotlib, seaborn |
| BI | Power BI |
| Version control | Git / GitHub |

---

## Repository structure

```text
olist-ecommerce-sql-business-analytics/
│
├── README.md
├── docker-compose.yml
├── requirements.txt
│
├── data/
│   ├── readme.md
│   └── raw/                          # local-only Olist CSVs
│
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
│
├── python/
│   └── olist_analysis.py
│
├── powerbi/
│
└── docs/
    ├── project_overview.md
    ├── data_dictionary.md
    ├── data_model.md
    ├── business_metrics.md
    ├── sql_guide.md
    ├── quality_checks.md
    ├── analysis_guide.md
    ├── rfm_retention.md
    ├── interview_story.md
    ├── execution_plan.md
    └── presentation_guide.md
```

---

## PostgreSQL architecture

The target database is:

```text
olist
```

with two logical schemas:

```text
olist
├── raw
│   ├── olist_customers
│   ├── olist_orders
│   ├── olist_order_items
│   ├── olist_order_payments
│   ├── olist_order_reviews
│   ├── olist_products
│   ├── olist_sellers
│   ├── olist_geolocation
│   └── product_category_translation
│
└── analytics
    ├── v_order_items
    ├── v_delivered_items
    ├── v_customer_order
    └── v_order_financials
```

The `raw` schema is source-oriented. The `analytics` schema creates reusable business-facing views.

---

## Important data-grain rules

Grain is treated as a first-class design concern.

### Orders

One row per `order_id`.

### Order items

One row per:

```text
order_id + order_item_id
```

An order can contain multiple item rows.

### Payments

An order may have multiple payment records.

### Customer identity

Use:

```text
customer_unique_id
```

for customer-level behavior.

Use:

```text
customer_id
```

when following the order-to-customer relationship.

### Why this matters

Orders, order items, payments, and reviews do not all have the same grain. Joining several one-to-many datasets and aggregating without controlling grain can multiply records and produce incorrect KPIs.

The project's financial view therefore aggregates item and payment data independently at `order_id` before combining them.

---

## Core business definitions

### Delivered order

```sql
order_status = 'delivered'
```

### Delivery delay

```text
actual_delivery_date - estimated_delivery_date
```

Positive values indicate delivery after the estimated date.

### Merchandise price

The source `price` field is treated as recorded merchandise price for an item line.

### Freight

`freight_value` is kept separate from item price.

### Gross order-value proxy

```text
price + freight_value
```

This project uses the combined amount only as a gross order-value proxy.

It is **not** accounting revenue, gross profit, or net profit.

### RFM

- **Recency** = days since the latest delivered purchase in the dataset snapshot
- **Frequency** = number of delivered orders
- **Monetary** = total merchandise price from delivered orders

These are analytical definitions created for this portfolio project, not official Olist KPIs.

---

## SQL execution order

Run the SQL scripts in this order:

```text
01_schema.sql
02_load.sql
03_quality_checks.sql
04_base_views.sql
05_kpis.sql
06_customer_analysis.sql
07_product_analysis.sql
08_seller_analysis.sql
09_delivery_reviews.sql
10_retention_rfm.sql
11_advanced_interview_cases.sql
12_final_client_report.sql
```

Do not jump directly to the final report. Quality checks and analytical views are part of the reproducible workflow.

---

## Local setup

### 1. Clone the repository

```powershell
git clone https://github.com/123prag/olist-ecommerce-sql-business-analytics.git
cd olist-ecommerce-sql-business-analytics
```

### 2. Download the Olist data

Download the dataset from Kaggle and place the nine CSV files under:

```text
data/raw/
```

See [`data/readme.md`](data/readme.md).

### 3. Start PostgreSQL

```powershell
docker compose up -d
```

Expected connection settings:

```text
Host: localhost
Port: 5432
Database: olist
Username: postgres
Password: postgres
```

### 4. Open DBeaver

Create a PostgreSQL connection using the settings above.

### 5. Create the schema

Run:

```text
sql/01_schema.sql
```

### 6. Load the data

Run:

```text
sql/02_load.sql
```

The source file:

```text
product_category_name_translation.csv
```

is loaded into the table:

```text
raw.product_category_translation
```

### 7. Validate the data

Run:

```text
sql/03_quality_checks.sql
```

Review row counts, nulls, orphan keys, duplicate patterns, and order-status distributions.

### 8. Build the analytical layer

Run:

```text
sql/04_base_views.sql
```

Then continue with scripts `05` through `12`.

---

## Python setup

Create a virtual environment:

```powershell
python -m venv .venv
```

Activate it:

```powershell
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks script execution for your user account:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

Reopen PowerShell and activate the environment again.

Install the project's dependencies:

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Verify the environment:

```powershell
python -c "import pandas, sqlalchemy, psycopg2, matplotlib, seaborn; print('Python environment OK')"
```

---

## Analysis layers

### Marketplace performance

- order volume
- delivered-order volume
- merchandise price
- freight
- payment value
- order-status distribution
- time trends

### Customer behavior

- unique customers
- repeat purchasing
- order frequency
- customer value
- customer geography

### Product and category

- category performance
- product-level performance
- top-N within category
- revenue/value concentration

### Sellers

- seller sales
- item volume
- order volume
- delivery performance
- seller geography

### Delivery and reviews

- estimated versus actual delivery
- late-order rate
- delivery delay
- review-score distribution
- review patterns by delivery outcome

The delivery/review relationship is observational. The project does not claim that delivery performance causes a specific review outcome.

### Retention and RFM

- acquisition cohorts
- repeat-purchase behavior
- cohort retention
- recency/frequency/monetary measures
- customer segments

---

## Data-quality philosophy

Before interpreting analytical results, validate the source and transformations.

Checks include:

- row counts
- missing values
- duplicate patterns
- foreign-key/orphan relationships
- order-status distribution
- date completeness
- analytical grain
- aggregation consistency

A data-quality finding is not automatically a reason to remove records. Investigate whether the pattern is expected from the source structure and document the decision.

---

## Business-story framework

The final analysis should move from data to decisions:

```text
Metric
  ↓
Observation
  ↓
Business implication
  ↓
Potential action
  ↓
Metric to monitor
```

Descriptive facts, analytical interpretations, and recommendations should be kept distinct.

---

## Documentation

| File | Purpose |
|---|---|
| [`docs/project_overview.md`](docs/project_overview.md) | End-to-end architecture and design |
| [`docs/data_dictionary.md`](docs/data_dictionary.md) | Dataset fields and meanings |
| [`docs/data_model.md`](docs/data_model.md) | Tables, keys, grains, and relationships |
| [`docs/business_metrics.md`](docs/business_metrics.md) | KPI and metric definitions |
| [`docs/sql_guide.md`](docs/sql_guide.md) | SQL techniques and reliability rules |
| [`docs/quality_checks.md`](docs/quality_checks.md) | Data validation methodology |
| [`docs/analysis_guide.md`](docs/analysis_guide.md) | Analysis workflow and interpretation |
| [`docs/rfm_retention.md`](docs/rfm_retention.md) | RFM and cohort methodology |
| [`docs/interview_story.md`](docs/interview_story.md) | Interview and portfolio explanation |
| [`docs/execution_plan.md`](docs/execution_plan.md) | Recommended build sequence |
| [`docs/presentation_guide.md`](docs/presentation_guide.md) | Client presentation structure |

---

## Portfolio deliverables

A polished version of the project should contain:

- reproducible SQL scripts
- documented data model
- quality-check outputs
- reusable analytical views
- KPI and business analyses
- Python validation and charts
- Power BI dashboard or screenshots
- client-style presentation
- documented assumptions and limitations
- source-data instructions instead of restricted raw-data redistribution

---

## Limitations

- The dataset is a historical 2016–2018 snapshot and does not represent current marketplace performance.
- The source is anonymised.
- `price + freight_value` is a gross order-value proxy, not accounting revenue or profit.
- RFM measures depend on the observation window used in the dataset.
- Delivery/review relationships are observational rather than causal evidence.
- Geolocation is based on ZIP-code-prefix information and is approximate.
- Business conclusions are conditional on the source data and the project definitions used.

---

## Author

**123prag**

Repository:

https://github.com/123prag/olist-ecommerce-sql-business-analytics
