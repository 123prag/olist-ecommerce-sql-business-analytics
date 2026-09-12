# Detailed execution plan

## Phase 1 — Setup (60 min)
1. Download the official dataset from Kaggle.
2. Put the nine CSVs under `data/raw/`.
3. Create PostgreSQL database `olist`.
4. Run `01_schema.sql`.
5. Confirm table creation and indexes.

## Phase 2 — Load and validate (60 min)
1. Edit the absolute paths in `02_load.sql`.
2. Load all nine CSVs.
3. Run every query in `03_quality_checks.sql`.
4. Record row counts, null counts, orphan counts and status distribution.
5. Explain what each check protects against.

## Phase 3 — Analytical layer (60 min)
1. Run `04_base_views.sql`.
2. Inspect `analytics.v_order_items` and `analytics.v_order_financials`.
3. Write down the grain of each view.
4. Verify a few orders manually.

## Phase 4 — KPIs (60 min)
1. Run `05_kpis.sql`.
2. Build a one-page KPI table.
3. Explain each KPI without SQL terminology.

## Phase 5 — Customers/products (90 min)
1. Solve each customer query yourself first.
2. Redo the top-3-per-category problem from memory.
3. Explain `ROW_NUMBER()` and `PARTITION BY` aloud.
4. Interpret revenue concentration.

## Phase 6 — Delivery/reviews/sellers (60 min)
1. Compare seller revenue and late rates.
2. Compare review scores by late flag.
3. Write two hypotheses before looking at results.

## Phase 7 — Retention/RFM (90 min)
1. Run the RFM query.
2. Explain every derived field.
3. Complete cohort retention.
4. Create a simple cohort table in Excel/Sheets.

## Phase 8 — Interview drill (60 min)
Without looking at solutions, solve:
- second-highest value
- top 3 per group
- previous order value
- running total
- customers with no orders
- MoM growth
- duplicate detection

## Phase 9 — Client output (60 min)
Create 5 slides:
1. Executive summary
2. Revenue and growth
3. Customer behavior / retention
4. Product/seller/delivery issues
5. Recommendations and metrics to track

## Phase 10 — Story practice (30 min)
Explain the project in 60 seconds and 3 minutes. Be ready to defend metric definitions, data quality decisions and business recommendations.
