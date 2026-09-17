# Project Overview

## Objective

Build an end-to-end, client-style marketplace analytics workflow that moves from source CSV data to validated SQL transformations, business analysis, Python validation, and reporting.

## End-to-end architecture

```text
Olist CSV files
      │
      ▼
PostgreSQL raw schema
      │
      ▼
03_quality_checks.sql
      │
      ▼
04_base_views.sql
      │
      ├── KPI analysis
      ├── Customer analysis
      ├── Product analysis
      ├── Seller analysis
      ├── Delivery/review analysis
      ├── Retention analysis
      ├── RFM analysis
      └── Advanced SQL cases
      │
      ▼
Python validation & charts
      │
      ▼
Power BI / client presentation
```

## Raw layer

The `raw` schema mirrors the source-oriented datasets:

- `olist_customers`
- `olist_orders`
- `olist_order_items`
- `olist_order_payments`
- `olist_order_reviews`
- `olist_products`
- `olist_sellers`
- `olist_geolocation`
- `product_category_translation`

## Analytics layer

The base analytical SQL creates:

- `analytics.v_order_items`
- `analytics.v_delivered_items`
- `analytics.v_customer_order`
- `analytics.v_order_financials`

These views reduce repeated join logic and provide reusable starting points for downstream analysis.

## Key design decisions

### 1. Grain comes first

Every analysis begins by identifying the row grain.

### 2. Stable customer identity

Customer behavior uses `customer_unique_id` rather than treating `customer_id` as a lifetime customer key.

### 3. Separate item and payment aggregation

Orders can have multiple items and multiple payments. Aggregating these independently at `order_id` avoids accidental row multiplication.

### 4. Explicit metric definitions

The project documents what "delivered", "late", "monetary", and "order value" mean.

### 5. Association is not causation

Delivery and review results are observational. The project does not claim causal effects.

### 6. Business language

SQL output is translated into observations, implications, potential actions, and monitoring metrics.
