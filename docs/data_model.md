# Data Model

## Relationship overview

```text
customers
    │ customer_id
    ▼
orders
    ├──────────────► order_items ─────────► products
    │                    │                     │
    │                    └──────────────────► sellers
    │
    ├──────────────► payments
    │
    └──────────────► reviews

products
    │ product_category_name
    ▼
product_category_translation

customers / sellers
    │ ZIP prefix
    ▼
geolocation
```

## Entity reference

| Entity | Key | Grain |
|---|---|---|
| Customers | `customer_id` | Customer record associated with an order |
| Orders | `order_id` | One row per order |
| Order items | `order_id`, `order_item_id` | One row per item line |
| Payments | `order_id`, `payment_sequential` | Payment record |
| Reviews | Review/order identifiers | Review record associated with an order |
| Products | `product_id` | Catalog product |
| Sellers | `seller_id` | Seller |
| Geolocation | ZIP-code prefix | Location mapping |
| Category translation | Category name | Translation mapping |

## Important key distinction

The dataset provides both:

```text
customer_id
customer_unique_id
```

`customer_id` is the order-specific customer identifier referenced by orders.

`customer_unique_id` is the stable customer identifier used for customer-level behavior.

## Grain risks

Several source tables are one-to-many relative to orders.

Examples:

```text
orders        1 → many order_items
orders        1 → many payments
```

If these tables are joined directly and then aggregated, one order's item rows can be multiplied by its payment rows.

## Financial-view design

The project follows this pattern:

```text
order_items
    │
    └── aggregate by order_id
              │
              ▼
        item_totals

payments
    │
    └── aggregate by order_id
              │
              ▼
        payment_totals

item_totals + payment_totals
              │
              ▼
      v_order_financials
```

This protects the order-level financial output from join multiplication.

## Analytical views

`analytics.v_order_items` provides enriched item-level context.

`analytics.v_delivered_items` filters the item view to delivered orders.

`analytics.v_customer_order` provides a customer-order analytical grain.

`analytics.v_order_financials` provides an order-level financial summary.
