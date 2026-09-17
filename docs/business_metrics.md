# Business Metrics

This document defines the project metrics before they are used in dashboards, reports, or conclusions.

## Core metrics

| Metric | Definition | Notes |
|---|---|---|
| Orders | Count of `order_id` | Order volume |
| Delivered orders | Orders with `order_status = 'delivered'` | Completed-delivery population |
| Item price | Sum of `price` | Recorded merchandise price |
| Freight | Sum of `freight_value` | Freight recorded at item level |
| Item + freight | `price + freight_value` | Gross order-value proxy |
| Payment value | Sum of `payment_value` | Recorded payment amount |
| Late days | Actual delivery date minus estimated delivery date | Positive = late |
| Customer frequency | Delivered orders per `customer_unique_id` | Repeat behavior |
| RFM monetary | Delivered merchandise price per customer | Project-defined customer value |

## Revenue terminology

The project uses careful terminology.

### Item price

The source item `price` field.

### Freight

The source `freight_value` field.

### Gross order-value proxy

```text
price + freight_value
```

This is an analytical proxy only.

It should not be described as:

- accounting revenue
- profit
- contribution margin
- net sales

unless additional accounting definitions and data support such a claim.

## Customer metric definitions

### Unique customer

Count distinct:

```text
customer_unique_id
```

### Frequency

For RFM:

```text
count of delivered orders
```

### Recency

Days from the customer's latest delivered purchase to the dataset snapshot endpoint used by the analysis.

### Monetary

Total delivered item price associated with the customer.

## Delivery metrics

### Late flag

A delivery is late when:

```text
actual delivery date > estimated delivery date
```

### Delay days

```text
actual delivery date - estimated delivery date
```

A positive number indicates lateness.

## Review metrics

Review score is the dataset's 1–5 review measure.

Review outcomes should be summarised descriptively. A difference in review scores across delivery groups is not automatically evidence of causality.

## Retention metrics

Retention is measured by cohort and subsequent customer activity.

A cohort is typically assigned using the customer's first purchase period.

## Metric governance rule

Every KPI shown in the final report should have:

1. a defined numerator,
2. a defined denominator when applicable,
3. a defined population,
4. a defined time window,
5. a clear interpretation,
6. a documented caveat where needed.
