-- Seller performance
SELECT
    seller_id,
    seller_state,
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(*) AS item_lines,
    ROUND(SUM(price), 2) AS merchandise_revenue,
    ROUND(AVG(price), 2) AS avg_item_price
FROM analytics.v_delivered_items
GROUP BY 1,2
ORDER BY merchandise_revenue DESC
LIMIT 25;

-- Top sellers per state
WITH seller_perf AS (
    SELECT seller_id, seller_state, SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY 1,2
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY seller_state ORDER BY revenue DESC) AS rn
    FROM seller_perf
)
SELECT seller_state, seller_id, ROUND(revenue,2) AS revenue
FROM ranked
WHERE rn <= 3
ORDER BY seller_state, revenue DESC;

-- Seller concentration
WITH seller_rev AS (
    SELECT seller_id, SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY seller_id
), ranked AS (
    SELECT *, SUM(revenue) OVER () AS total_revenue,
           SUM(revenue) OVER (ORDER BY revenue DESC ROWS UNBOUNDED PRECEDING) AS cumulative_revenue
    FROM seller_rev
)
SELECT
    seller_id,
    ROUND(revenue,2) AS revenue,
    ROUND(100.0 * cumulative_revenue / total_revenue, 2) AS cumulative_revenue_pct
FROM ranked
ORDER BY revenue DESC
LIMIT 50;
