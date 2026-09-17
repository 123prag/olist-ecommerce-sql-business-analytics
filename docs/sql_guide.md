# SQL Guide

## SQL skills demonstrated

### Common table expressions

CTEs help break business logic into readable stages.

```sql
WITH base AS (...),
aggregated AS (...)
SELECT ...
FROM aggregated;
```

### Joins

Use joins to enrich entities while preserving the intended analytical population.

### Conditional aggregation

```sql
SUM(CASE WHEN ... THEN ... END)
```

and

```sql
COUNT(CASE WHEN ... THEN ... END)
```

are useful for business KPI tables.

### Window functions

The project uses analytical functions such as:

```sql
ROW_NUMBER()
RANK()
LAG()
LEAD()
SUM(...) OVER (...)
```

Typical applications:

- top-N within a category
- previous-order comparisons
- period-over-period changes
- running totals
- ranking
- sequence analysis

## Example: top 3 within each category

Conceptually:

```sql
ROW_NUMBER() OVER (
    PARTITION BY product_category_english
    ORDER BY sales_value DESC
)
```

Then filter the resulting rank.

The important idea is that the ranking is performed separately inside each category.

## Example: previous-period analysis

`LAG()` can expose a prior value:

```sql
LAG(metric_value) OVER (
    ORDER BY metric_period
)
```

This can support:

- month-over-month comparisons
- previous-order value analysis
- change calculations

## Example: running total

```sql
SUM(metric_value) OVER (
    ORDER BY metric_period
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

## Grain discipline

Before writing a query, identify:

1. What does one row represent?
2. What entity should be counted?
3. Can any join multiply rows?
4. Should a table be aggregated before joining?
5. Which population is included?

## Reusability

When the same relationship or business definition appears in several analyses, prefer an analytical view rather than repeating a long join chain.

## Interview mindset

Be able to explain not only what a query returns, but why it is correct for the intended grain and population.
