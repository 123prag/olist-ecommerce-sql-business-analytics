# Olist Dataset Guide

This directory documents how the Olist source dataset should be stored and used locally.

## Source

**Brazilian E-Commerce Public Dataset by Olist**

Kaggle:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset is described by its publisher as real commercial data that has been anonymised. Check the source's current license and terms before redistributing the raw CSV files.

---

## Local directory structure

```text
data/
├── readme.md
└── raw/
    ├── olist_customers_dataset.csv
    ├── olist_orders_dataset.csv
    ├── olist_order_items_dataset.csv
    ├── olist_order_payments_dataset.csv
    ├── olist_order_reviews_dataset.csv
    ├── olist_products_dataset.csv
    ├── olist_sellers_dataset.csv
    ├── olist_geolocation_dataset.csv
    └── product_category_name_translation.csv
```

The `raw/` directory is intended for local development.

### Public-repository rule

Do not commit the raw source CSV files to GitHub unless the applicable source terms explicitly permit redistribution.

The repository should document the source and download process instead of duplicating the source dataset.

---

## Dataset scope

The project uses approximately 100,000 Olist orders from the 2016–2018 historical snapshot, together with related customer, product, seller, payment, review, and geolocation data.

---

## Expected row counts for the supplied snapshot

| Dataset | Expected rows |
|---|---:|
| Customers | 99,441 |
| Orders | 99,441 |
| Order items | 112,650 |
| Payments | 103,886 |
| Reviews | 99,224 |
| Products | 32,951 |
| Sellers | 3,095 |
| Geolocation | 1,000,163 |
| Category translation | 71 |

These counts are useful as ingestion checks. Actual values should be confirmed from the files you downloaded.

---

## Main table grains

| Source | Grain |
|---|---|
| Customers | One order-specific customer record |
| Orders | One row per `order_id` |
| Order items | One row per `order_id` + `order_item_id` |
| Payments | Potentially multiple rows per order |
| Reviews | Review records associated with orders |
| Products | One row per catalog product |
| Sellers | One row per seller |
| Geolocation | ZIP-code-prefix location mapping |
| Category translation | Portuguese category to English category mapping |

---

## Customer identity

The dataset contains:

```text
customer_id
customer_unique_id
```

Use `customer_id` for the relationship between an order and its customer record.

Use `customer_unique_id` for customer-level behavioral analysis because it provides the stable customer identifier used by this project.

---

## Important project definitions

### Delivered order

```sql
order_status = 'delivered'
```

### Delivery delay

```text
actual delivery date - estimated delivery date
```

A positive result indicates delivery after the estimated date.

### Merchandise value

`price` is treated as the recorded item price.

`freight_value` is kept separate.

```text
price + freight_value
```

is used only as a gross order-value proxy.

### RFM

- Recency: days since latest delivered purchase in the dataset snapshot
- Frequency: number of delivered orders
- Monetary: total merchandise price from delivered orders

These definitions belong to the portfolio project and are not claimed to be official Olist KPI definitions.

---

## PostgreSQL naming note

The source filename is:

```text
product_category_name_translation.csv
```

The PostgreSQL table created by the project is:

```text
raw.product_category_translation
```

This naming difference is intentional and should be remembered when loading or querying the table.

---

## Loading workflow

1. Download the nine CSVs.
2. Place them under `data/raw/`.
3. Start the PostgreSQL Docker container.
4. Run `sql/01_schema.sql`.
5. Run `sql/02_load.sql`.
6. Run `sql/03_quality_checks.sql`.
7. Continue through the remaining SQL scripts in order.

---

## Data-quality checks

The quality layer should investigate:

- row counts
- nulls
- duplicates
- orphan keys
- status distribution
- date completeness
- unexpected relationships
- grain mismatches

Do not silently remove source rows simply because a field is missing or unusual. Determine whether the pattern is expected and document the treatment.
