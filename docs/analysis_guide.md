# Analysis Guide

## Analysis sequence

### Step 1 — Understand the source

Inspect:

- tables
- keys
- grain
- timestamps
- categorical fields
- numeric measures

### Step 2 — Validate the source

Run the quality checks before interpreting trends.

### Step 3 — Build reusable views

Use the analytics schema to centralize repeated joins and business definitions.

### Step 4 — Calculate KPIs

Start with the marketplace-level view before drilling into customer, product, seller, and operational dimensions.

---

## Marketplace performance

Typical questions:

- How many orders are there?
- How many are delivered?
- How does volume change over time?
- What is the item-price value?
- What is freight?
- How do recorded payments compare?
- What is the order-status distribution?

Interpret these as descriptive measures of the dataset snapshot.

---

## Customer analysis

Use `customer_unique_id`.

Typical questions:

- How many unique customers are present?
- What share of customers have multiple delivered orders?
- How often do customers purchase?
- How concentrated is customer value?
- How does customer behavior vary geographically?

---

## Product and category analysis

Typical questions:

- Which categories generate the most item value?
- Which products perform strongly within their category?
- How concentrated is value among products?
- How do category sizes differ?

Always confirm whether the analysis is:

```text
item-level
order-level
product-level
category-level
```

before comparing metrics.

---

## Seller analysis

Typical questions:

- Which sellers have high sales volume?
- Which sellers handle many items?
- How does seller delivery performance compare?
- How do seller results vary geographically?

Do not treat high sales volume as proof of high operational quality.

---

## Delivery and review analysis

Typical questions:

- How often are orders delivered after their estimated date?
- Which states/categories/sellers show different delay patterns?
- How are review scores distributed?
- How do review scores differ across on-time and late-delivery groups?

The last question describes an association. It does not establish causal impact.

---

## Retention analysis

Typical workflow:

1. Find each customer's first purchase period.
2. Assign the acquisition cohort.
3. Find future purchase periods.
4. Calculate cohort age.
5. Count active customers.
6. Divide by the original cohort population.

Remember that later cohorts have less observation time.

---

## RFM analysis

Build:

```text
Recency
Frequency
Monetary
```

from delivered purchases.

Document the scoring rules used by the SQL.

Avoid vague customer labels unless the underlying scoring method is documented.

---

## From analysis to business story

Use:

```text
Observation
   ↓
Evidence
   ↓
Implication
   ↓
Potential action
   ↓
Monitoring KPI
```

The report should separate:

- what the data shows,
- what the analyst infers,
- what management could consider doing.

---

## Reproducibility

Every finding in the final report should be traceable to:

- a SQL query/view,
- a defined metric,
- an identified population,
- a time window,
- and the source data version.
