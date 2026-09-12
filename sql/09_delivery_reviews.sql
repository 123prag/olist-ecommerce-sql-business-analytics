-- Delivery performance by order
WITH delivery AS (
    SELECT
        order_id,
        customer_unique_id,
        customer_state,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        (order_delivered_customer_date::date - order_estimated_delivery_date::date) AS days_vs_estimate
    FROM analytics.v_customer_order
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)
SELECT
    COUNT(*) AS delivered_orders,
    ROUND(AVG(days_vs_estimate), 2) AS avg_days_vs_estimate,
    ROUND(100.0 * AVG((days_vs_estimate > 0)::int), 2) AS late_order_pct
FROM delivery;

-- Late rate by state
WITH delivery AS (
    SELECT
        customer_state,
        (order_delivered_customer_date::date - order_estimated_delivery_date::date) AS days_vs_estimate
    FROM analytics.v_customer_order
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)
SELECT
    customer_state,
    COUNT(*) AS orders,
    ROUND(AVG(days_vs_estimate),2) AS avg_days_vs_estimate,
    ROUND(100.0 * AVG((days_vs_estimate > 0)::int),2) AS late_pct
FROM delivery
GROUP BY 1
HAVING COUNT(*) >= 100
ORDER BY late_pct DESC;

-- Review score distribution
SELECT review_score, COUNT(*) AS reviews
FROM raw.olist_order_reviews
GROUP BY 1
ORDER BY 1;

-- Review score vs delivery timeliness
WITH order_review AS (
    SELECT
        r.order_id,
        r.review_score,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        CASE WHEN o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date THEN 1 ELSE 0 END AS late_flag
    FROM raw.olist_order_reviews r
    JOIN raw.olist_orders o USING(order_id)
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    review_score,
    COUNT(*) AS reviews,
    ROUND(100.0 * AVG(late_flag), 2) AS late_pct
FROM order_review
GROUP BY 1
ORDER BY 1;
