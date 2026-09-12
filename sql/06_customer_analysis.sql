-- Customer revenue summary
WITH customer_revenue AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS delivered_orders,
        SUM(price) AS merchandise_revenue,
        SUM(freight_value) AS freight_value,
        MIN(order_purchase_timestamp) AS first_purchase,
        MAX(order_purchase_timestamp) AS last_purchase
    FROM analytics.v_delivered_items
    GROUP BY customer_unique_id
)
SELECT *
FROM customer_revenue
ORDER BY merchandise_revenue DESC
LIMIT 20;

-- Repeat purchase behavior
WITH customer_orders AS (
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS order_count
    FROM analytics.v_customer_order
    WHERE order_status = 'delivered'
    GROUP BY customer_unique_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'one-time' ELSE 'repeat' END AS customer_type,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS customer_pct
FROM customer_orders
GROUP BY 1;

-- Customer concentration: cumulative share of merchandise revenue
WITH customer_revenue AS (
    SELECT customer_unique_id, SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY customer_unique_id
), ranked AS (
    SELECT
        customer_unique_id,
        revenue,
        SUM(revenue) OVER () AS total_revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
    FROM customer_revenue
)
SELECT
    customer_unique_id,
    revenue,
    ROUND(100.0 * cumulative_revenue / total_revenue, 2) AS cumulative_revenue_pct
FROM ranked
ORDER BY revenue DESC
LIMIT 100;

-- Top 10 customers by state
WITH customer_state_revenue AS (
    SELECT customer_unique_id, customer_state, SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY customer_unique_id, customer_state
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_state ORDER BY revenue DESC) AS rn
    FROM customer_state_revenue
)
SELECT *
FROM ranked
WHERE rn <= 10
ORDER BY customer_state, revenue DESC;
