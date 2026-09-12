-- RFM-style segmentation
WITH customer_base AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(price) AS monetary,
        MAX(order_purchase_timestamp::date) AS last_purchase
    FROM analytics.v_delivered_items
    GROUP BY customer_unique_id
),
anchor AS (
    SELECT MAX(order_purchase_timestamp::date) AS max_date
    FROM analytics.v_delivered_items
), scored AS (
    SELECT
        c.*,
        (a.max_date - c.last_purchase) AS recency_days,
        NTILE(5) OVER (ORDER BY (a.max_date - c.last_purchase) DESC) AS recency_bin,
        NTILE(5) OVER (ORDER BY c.frequency) AS frequency_bin,
        NTILE(5) OVER (ORDER BY c.monetary) AS monetary_bin
    FROM customer_base c
    CROSS JOIN anchor a
),
segments AS (
    SELECT *,
        CASE
            WHEN frequency >= 2 AND monetary >= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monetary) FROM customer_base) THEN 'High-value repeat'
            WHEN frequency = 1 AND recency_days <= 120 THEN 'Recent one-time'
            WHEN frequency >= 2 AND recency_days > 180 THEN 'At-risk repeat'
            WHEN recency_days > 365 THEN 'Inactive'
            ELSE 'Other'
        END AS segment
    FROM scored
)
SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(AVG(recency_days),1) AS avg_recency_days,
    ROUND(AVG(frequency),2) AS avg_frequency,
    ROUND(AVG(monetary),2) AS avg_monetary,
    ROUND(SUM(monetary),2) AS total_monetary
FROM segments
GROUP BY 1
ORDER BY total_monetary DESC;

-- Monthly repeat-customer rate
WITH first_purchase AS (
    SELECT customer_unique_id, MIN(DATE_TRUNC('month', order_purchase_timestamp)::date) AS first_month
    FROM analytics.v_delivered_items
    GROUP BY customer_unique_id
), monthly_customer AS (
    SELECT DISTINCT customer_unique_id, DATE_TRUNC('month', order_purchase_timestamp)::date AS month
    FROM analytics.v_delivered_items
), repeat AS (
    SELECT
        m.month,
        COUNT(*) AS purchasing_customers,
        COUNT(*) FILTER (WHERE m.month > f.first_month) AS repeat_customers
    FROM monthly_customer m
    JOIN first_purchase f USING(customer_unique_id)
    GROUP BY 1
)
SELECT
    month,
    purchasing_customers,
    repeat_customers,
    ROUND(100.0 * repeat_customers / NULLIF(purchasing_customers,0),2) AS repeat_customer_pct
FROM repeat
ORDER BY month;

-- Cohort retention: customer activity in months after first purchase
WITH first_purchase AS (
    SELECT customer_unique_id, DATE_TRUNC('month', MIN(order_purchase_timestamp))::date AS cohort_month
    FROM analytics.v_delivered_items
    GROUP BY customer_unique_id
), activity AS (
    SELECT DISTINCT customer_unique_id, DATE_TRUNC('month', order_purchase_timestamp)::date AS activity_month
    FROM analytics.v_delivered_items
), cohort_activity AS (
    SELECT
        f.cohort_month,
        a.activity_month,
        ((EXTRACT(YEAR FROM age(a.activity_month, f.cohort_month)) * 12)
         + EXTRACT(MONTH FROM age(a.activity_month, f.cohort_month)))::int AS month_number,
        COUNT(DISTINCT a.customer_unique_id) AS active_customers
    FROM first_purchase f
    JOIN activity a USING(customer_unique_id)
    GROUP BY 1,2,3
), cohort_size AS (
    SELECT cohort_month, MAX(active_customers) FILTER (WHERE month_number = 0) AS cohort_customers
    FROM cohort_activity
    GROUP BY 1
)
SELECT
    c.cohort_month,
    c.month_number,
    c.active_customers,
    ROUND(100.0 * c.active_customers / NULLIF(s.cohort_customers,0),2) AS retention_pct
FROM cohort_activity c
JOIN cohort_size s USING(cohort_month)
WHERE c.month_number BETWEEN 0 AND 12
ORDER BY c.cohort_month, c.month_number;
