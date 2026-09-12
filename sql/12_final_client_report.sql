-- 1. Executive KPI snapshot
SELECT
    COUNT(*) AS delivered_orders,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    ROUND(SUM(price),2) AS merchandise_revenue,
    ROUND(SUM(price) / NULLIF(COUNT(DISTINCT order_id),0),2) AS avg_order_value
FROM analytics.v_delivered_items;

-- 2. Monthly trend for the client chart
SELECT
    DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_unique_id) AS customers,
    ROUND(SUM(price),2) AS revenue
FROM analytics.v_delivered_items
GROUP BY 1
ORDER BY 1;

-- 3. Top categories
SELECT
    product_category_english AS category,
    ROUND(SUM(price),2) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM analytics.v_delivered_items
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

-- 4. Customer value concentration
WITH customer_rev AS (
    SELECT customer_unique_id, SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY 1
), ranked AS (
    SELECT *,
           SUM(revenue) OVER () AS total_revenue,
           SUM(revenue) OVER (ORDER BY revenue DESC ROWS UNBOUNDED PRECEDING) AS cumulative_revenue
    FROM customer_rev
)
SELECT
    CASE
        WHEN cumulative_revenue / total_revenue <= 0.50 THEN 'Top customers until 50%'
        WHEN cumulative_revenue / total_revenue <= 0.80 THEN 'Next customers until 80%'
        ELSE 'Remaining customers'
    END AS concentration_band,
    COUNT(*) AS customers,
    ROUND(SUM(revenue),2) AS revenue
FROM ranked
GROUP BY 1
ORDER BY MIN(cumulative_revenue / total_revenue);

-- 5. Delivery and satisfaction
WITH delivery AS (
    SELECT
        r.order_id,
        r.review_score,
        CASE WHEN o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date THEN 1 ELSE 0 END AS late_flag
    FROM raw.olist_order_reviews r
    JOIN raw.olist_orders o USING(order_id)
    WHERE o.order_status='delivered'
)
SELECT
    late_flag,
    COUNT(*) AS reviewed_orders,
    ROUND(AVG(review_score),2) AS avg_review_score,
    ROUND(100.0*AVG((review_score <= 2)::int),2) AS low_review_pct
FROM delivery
GROUP BY 1
ORDER BY 1;
