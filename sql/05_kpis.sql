-- Executive KPI snapshot
SELECT
    COUNT(*) FILTER (WHERE order_status = 'delivered') AS delivered_orders,
    COUNT(DISTINCT customer_unique_id) FILTER (WHERE order_status = 'delivered') AS delivered_customers,
    ROUND(SUM(item_price) FILTER (WHERE order_status = 'delivered'), 2) AS merchandise_revenue,
    ROUND(SUM(freight_value) FILTER (WHERE order_status = 'delivered'), 2) AS freight_value,
    ROUND(SUM(item_price + freight_value) FILTER (WHERE order_status = 'delivered'), 2) AS gmv_proxy,
    ROUND(
        SUM(item_price) FILTER (WHERE order_status = 'delivered')
        / NULLIF(COUNT(*) FILTER (WHERE order_status = 'delivered'), 0), 2
    ) AS avg_order_value_merchandise
FROM analytics.v_order_financials;

-- Monthly revenue and orders
SELECT
    DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
    COUNT(*) FILTER (WHERE order_status = 'delivered') AS delivered_orders,
    ROUND(SUM(item_price) FILTER (WHERE order_status = 'delivered'), 2) AS merchandise_revenue
FROM analytics.v_order_financials
GROUP BY 1
ORDER BY 1;

-- Revenue by state
SELECT
    customer_state,
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(DISTINCT customer_unique_id) AS customers,
    ROUND(SUM(price), 2) AS merchandise_revenue
FROM analytics.v_delivered_items
GROUP BY 1
ORDER BY merchandise_revenue DESC;

-- Payment method mix
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(payment_value), 2) AS payment_value,
    ROUND(AVG(payment_value), 2) AS avg_payment
FROM raw.olist_order_payments p
JOIN raw.olist_orders o USING(order_id)
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY payment_value DESC;
