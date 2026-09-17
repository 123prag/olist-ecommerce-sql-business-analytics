# Data Quality Checks

Run `sql/03_quality_checks.sql` before relying on downstream analysis.

## 1. Volume checks

Confirm that loaded row counts are plausible relative to the downloaded Olist snapshot.

For the project snapshot, expected approximate counts include:

- customers: 99,441
- orders: 99,441
- order items: 112,650
- payments: 103,886
- reviews: 99,224
- products: 32,951
- sellers: 3,095
- geolocation: 1,000,163
- category translation: 71

## 2. Null checks

Inspect important:

- identifiers
- timestamps
- status fields
- prices
- freight values
- foreign keys

Nulls can be valid depending on the lifecycle of an order, so they should be interpreted rather than automatically deleted.

## 3. Referential checks

Look for records such as:

- order items without matching orders
- payments without matching orders
- reviews without matching orders
- item rows with missing products
- item rows with missing sellers
- products without category translations where a translation is expected

## 4. Duplicate checks

Distinguish:

- genuine duplicate records
- legitimate repeated payment rows
- multiple item lines
- multiple review-related records

A repeated key does not automatically mean that the data is wrong.

## 5. Status checks

Review the distribution of `order_status` before deciding which population belongs in a KPI.

Examples:

- all orders
- delivered orders
- cancelled orders
- unavailable orders

## 6. Date checks

Inspect relationships among:

- purchase time
- approval time
- carrier date
- delivery date
- estimated delivery date

Missing delivery dates can be expected for non-delivered orders.

## 7. Grain checks

Verify the intended row grain before aggregation.

Example:

```text
order-level KPI
```

should not accidentally be calculated directly from:

```text
item-level rows
```

without grouping appropriately.

## 8. Aggregation checks

When multiple one-to-many tables are involved, aggregate independently before joining.

This is especially important for:

```text
order_items
payments
```

## Quality philosophy

Data quality is part of analytical reasoning.

The goal is not to make the source look perfect. The goal is to understand what the data contains, identify limitations, and ensure that derived metrics are trustworthy for their stated purpose.
