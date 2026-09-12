-- Category performance
SELECT
    product_category_english AS category,
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(DISTINCT product_id) AS products_sold,
    SUM(1) AS item_lines,
    ROUND(SUM(price), 2) AS merchandise_revenue,
    ROUND(AVG(price), 2) AS avg_item_price
FROM analytics.v_delivered_items
GROUP BY 1
ORDER BY merchandise_revenue DESC
LIMIT 20;

-- Top 3 products within each category
WITH product_sales AS (
    SELECT
        product_category_english AS category,
        product_id,
        SUM(price) AS revenue,
        COUNT(DISTINCT order_id) AS orders
    FROM analytics.v_delivered_items
    GROUP BY 1, 2
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM product_sales
)
SELECT category, product_id, ROUND(revenue, 2) AS revenue, orders
FROM ranked
WHERE rn <= 3
ORDER BY category, revenue DESC;

-- Month-over-month category growth
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
        product_category_english AS category,
        SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY 1,2
), with_prev AS (
    SELECT *, LAG(revenue) OVER (PARTITION BY category ORDER BY month) AS previous_month_revenue
    FROM monthly
)
SELECT
    month,
    category,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(100.0 * (revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0), 2) AS mom_growth_pct
FROM with_prev
ORDER BY month, category;

-- Product dimensions and pricing sanity
SELECT
    p.product_category_name,
    COUNT(*) AS products,
    ROUND(AVG(product_weight_g), 1) AS avg_weight_g,
    ROUND(AVG(product_photos_qty), 1) AS avg_photos,
    COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS missing_weight
FROM raw.olist_products p
GROUP BY 1
ORDER BY products DESC;
