# Interview Story

## 60-second explanation

> I built an end-to-end business analytics project on the Olist Brazilian e-commerce dataset. I loaded the source data into PostgreSQL, created a raw relational layer, ran data-quality checks, and built reusable analytical views. I then used SQL for marketplace KPIs, customer and product analysis, seller performance, delivery and review analysis, cohort retention, RFM segmentation, and advanced window-function problems. Python was used for validation and visualization, and the outputs were structured for Power BI and client-style reporting. A key focus was getting the table grain and metric definitions right so that one-to-many joins did not distort the business results.

---

## Three-minute explanation

### Situation

A marketplace business needs a structured view of sales activity, customer behavior, seller performance, delivery outcomes, and retention.

### Task

Build a reproducible analytics workflow that can support both business reporting and technical interview discussion.

### Action

1. Created the PostgreSQL database structure.
2. Loaded the source CSVs into a raw schema.
3. Ran data-quality checks.
4. Built reusable analytical views.
5. Developed KPI queries.
6. Analyzed customers, products, sellers, delivery, and reviews.
7. Built cohort retention and RFM analyses.
8. Practiced advanced SQL patterns such as window functions.
9. Used Python for validation and charts.
10. Prepared Power BI/client-reporting outputs.

### Result

The project creates a traceable path from source data to business metrics and recommendations while documenting grain, metric definitions, and limitations.

---

## Questions to be ready for

### Why `customer_unique_id`?

Because `customer_id` is tied to the order-level customer record, while `customer_unique_id` is the stable identifier used for customer behavior.

### What is the grain of `order_items`?

One row per item line:

```text
order_id + order_item_id
```

### Why can payments and items cause problems?

Because an order may have multiple item rows and multiple payment rows. A direct join can multiply rows and inflate totals.

### Why aggregate before joining?

To bring both datasets to the same order-level grain before combining them.

### What is `price + freight_value`?

A gross order-value proxy used by this project. It is not accounting revenue or profit.

### How is a late order defined?

By comparing actual customer delivery date with estimated delivery date.

### Is a delivery/review difference causal?

No. The project treats it as an observational association.

### How is RFM calculated?

Recency, frequency, and monetary measures are calculated for customers using delivered purchases.

### What would you improve in production?

Possible improvements include:

- orchestration,
- automated testing,
- environment-specific configuration,
- stronger lineage,
- incremental loading,
- BI semantic-model governance,
- monitoring and alerting.
