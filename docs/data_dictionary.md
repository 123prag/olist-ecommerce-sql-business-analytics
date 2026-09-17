# Data Dictionary — Olist Project

This document summarises the source fields used by the analytical workflow.

## Customers

| Field | Meaning |
|---|---|
| `customer_id` | Order-specific customer identifier used by the orders table |
| `customer_unique_id` | Stable customer identifier for customer-level behavior |
| `customer_zip_code_prefix` | Customer ZIP-code prefix |
| `customer_city` | Customer city |
| `customer_state` | Customer state |

## Orders

| Field | Meaning |
|---|---|
| `order_id` | Unique order identifier |
| `customer_id` | Customer foreign key |
| `order_status` | Order lifecycle status |
| `order_purchase_timestamp` | Purchase timestamp |
| `order_approved_at` | Approval timestamp |
| `order_delivered_carrier_date` | Carrier handoff date |
| `order_delivered_customer_date` | Customer delivery date |
| `order_estimated_delivery_date` | Estimated delivery date |

## Order items

| Field | Meaning |
|---|---|
| `order_id` | Order foreign key |
| `order_item_id` | Item-line number within an order |
| `product_id` | Product identifier |
| `seller_id` | Seller identifier |
| `shipping_limit_date` | Seller shipping deadline |
| `price` | Item price |
| `freight_value` | Freight charged for the item line |

## Payments

| Field | Meaning |
|---|---|
| `order_id` | Order identifier |
| `payment_sequential` | Payment sequence within an order |
| `payment_type` | Payment method |
| `payment_installments` | Number of installments |
| `payment_value` | Payment amount |

## Reviews

| Field | Meaning |
|---|---|
| `review_id` | Review identifier |
| `order_id` | Associated order |
| `review_score` | Review score from 1 to 5 |
| `comment_*` | Customer comment fields |
| Review timestamps | Review creation/answer lifecycle timestamps |

## Products

Product catalog attributes including:

- category
- name-length information
- description-length information
- photo count
- dimensions
- weight

## Sellers

Seller identity and location attributes.

## Geolocation

ZIP-code-prefix mapping with approximate:

- latitude
- longitude
- city
- state

The mapping is approximate and should not be treated as exact customer coordinates.

## Category translation

Maps Portuguese category names to English category labels.

## Analytical identifiers

### Customer-level analysis

Use:

```text
customer_unique_id
```

### Order-level analysis

Use:

```text
order_id
```

### Item-level analysis

Use:

```text
order_id + order_item_id
```

### Seller-level analysis

Use:

```text
seller_id
```

### Product-level analysis

Use:

```text
product_id
```
