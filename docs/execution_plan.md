# Detailed Execution Plan

## Phase 1 — Setup

1. Install Git, Python, Docker Desktop, and DBeaver.
2. Download the Olist dataset from Kaggle.
3. Place the nine CSV files under `data/raw/`.
4. Start PostgreSQL with Docker Compose.
5. Create the `olist` database/schema with `01_schema.sql`.
6. Confirm tables and indexes.

## Phase 2 — Load and validate

1. Run `02_load.sql`.
2. Confirm the row counts.
3. Run every check in `03_quality_checks.sql`.
4. Record null counts.
5. Record orphan counts.
6. Review order-status distribution.
7. Investigate unexpected patterns before continuing.

## Phase 3 — Analytical layer

1. Run `04_base_views.sql`.
2. Inspect `analytics.v_order_items`.
3. Inspect `analytics.v_delivered_items`.
4. Inspect `analytics.v_customer_order`.
5. Inspect `analytics.v_order_financials`.
6. Write down the grain of each view.
7. Manually verify a few orders.

## Phase 4 — KPIs

1. Run `05_kpis.sql`.
2. Build a KPI summary table.
3. Check the population and grain of each metric.
4. Re-write several queries from memory.
5. Explain the KPI definitions without SQL terminology.

## Phase 5 — Customers and products

1. Run `06_customer_analysis.sql`.
2. Run `07_product_analysis.sql`.
3. Practice customer-frequency calculations.
4. Practice top-3-per-category analysis.
5. Practice ranking with `ROW_NUMBER()`.
6. Interpret product/category concentration.

## Phase 6 — Sellers, delivery, and reviews

1. Run `08_seller_analysis.sql`.
2. Run `09_delivery_reviews.sql`.
3. Compare seller volume and delivery outcomes.
4. Compare review distributions by delivery outcome.
5. Write hypotheses before reading the final interpretation.

## Phase 7 — Retention and RFM

1. Run `10_retention_rfm.sql`.
2. Explain every derived RFM field.
3. Complete cohort retention analysis.
4. Check the observation-window limitation.
5. Create a simple cohort table for presentation.

## Phase 8 — Advanced SQL interview cases

Practice without looking at solutions:

- second-highest value
- top 3 per group
- previous-order value
- running total
- customers with no orders
- month-over-month growth
- duplicate detection

Use a timer and explain the reasoning aloud.

## Phase 9 — Final client report

1. Run `12_final_client_report.sql`.
2. Select several material findings.
3. Trace every finding to a metric definition.
4. Separate observations from recommendations.
5. Identify the KPI to monitor for each action.

## Phase 10 — Python and presentation

1. Activate the virtual environment.
2. Run `python/olist_analysis.py`.
3. Validate SQL outputs with Python where appropriate.
4. Create four to six useful charts.
5. Build the Power BI/reporting layer.
6. Build a concise client-style presentation.

---

## Final quality gate

Before publishing:

- [ ] SQL scripts execute in order.
- [ ] Raw data is not accidentally committed.
- [ ] Key row counts are documented.
- [ ] Metric definitions are documented.
- [ ] Analytical grain is clear.
- [ ] One-to-many joins have been reviewed.
- [ ] Findings are traceable to queries.
- [ ] Limitations are documented.
- [ ] Python environment is reproducible.
- [ ] Power BI/reporting outputs match the SQL definitions.
- [ ] README links to the documentation.
