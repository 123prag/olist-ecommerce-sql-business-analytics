# RFM and Retention Methodology

## RFM

RFM is used as a structured way to describe customer purchasing behavior.

### Recency

Recency is:

```text
days since the customer's latest delivered purchase
```

The reference point is the analytical endpoint of the dataset snapshot.

Lower recency values indicate a more recent purchase.

### Frequency

Frequency is:

```text
number of delivered orders associated with the customer
```

### Monetary

Monetary is:

```text
sum of merchandise price from delivered orders
```

Freight is kept separate.

---

## RFM scoring

The project may convert raw RFM values into scores or segments.

The scoring method should always be documented because:

- different quantile rules can produce different segment sizes,
- the dataset is historical,
- monetary values depend on metric definitions,
- the scoring is analytical rather than an official Olist classification.

---

## Cohort retention

### Cohort definition

A customer belongs to the cohort corresponding to the period of their first purchase.

A common monthly workflow is:

```text
customer
   ↓
first purchase month
   ↓
cohort month
   ↓
subsequent active months
   ↓
cohort age
   ↓
retained-customer count
```

### Retention rate

Conceptually:

```text
retained customers at cohort age
----------------------------------
customers in original cohort
```

The exact SQL implementation should be inspected before interpreting a result.

---

## Important caveat

Customers acquired near the end of the dataset have less time available to make repeat purchases.

Therefore:

```text
early cohort ≠ late cohort
```

in terms of available observation horizon.

This is an important interpretation limitation.

---

## Business use

RFM and retention can support questions such as:

- where repeat purchasing is concentrated,
- which cohorts show stronger repeat behavior,
- how customer value is distributed,
- which customer groups might deserve targeted lifecycle analysis.

The analysis should describe what the data supports rather than presenting a segment as an objective measure of customer quality.
