-- CASE 1: Top 3 product categories by each customer state
WITH state_category AS (
    SELECT customer_state, product_category_english AS category, SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY 1,2
), ranked AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY customer_state ORDER BY revenue DESC) AS rnk
    FROM state_category
)
SELECT customer_state, category, ROUND(revenue,2) AS revenue
FROM ranked
WHERE rnk <= 3
ORDER BY customer_state, revenue DESC;

-- CASE 2: Highest and lowest month for each category
WITH monthly AS (
    SELECT DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
           product_category_english AS category,
           SUM(price) AS revenue
    FROM analytics.v_delivered_items
    GROUP BY 1,2
), ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS high_rn,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue ASC) AS low_rn
    FROM monthly
)
SELECT * FROM ranked WHERE high_rn = 1 OR low_rn = 1 ORDER BY category, high_rn;

-- CASE 3: Customers whose latest purchase was at least 20% smaller than their previous purchase
WITH customer_orders AS (
    SELECT customer_unique_id,
           order_id,
           order_purchase_timestamp,
           SUM(price) AS order_revenue
    FROM analytics.v_delivered_items
    GROUP BY 1,2,3
), with_prev AS (
    SELECT *,
           LAG(order_revenue) OVER (PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp) AS previous_order_revenue,
           ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp DESC) AS latest_rn
    FROM customer_orders
)
SELECT customer_unique_id,
       order_id AS latest_order_id,
       ROUND(order_revenue,2) AS latest_order_revenue,
       ROUND(previous_order_revenue,2) AS previous_order_revenue,
       ROUND(100.0 * (order_revenue - previous_order_revenue) / NULLIF(previous_order_revenue,0),2) AS change_pct
FROM with_prev
WHERE latest_rn = 1
  AND previous_order_revenue IS NOT NULL
  AND order_revenue < previous_order_revenue * 0.80
ORDER BY change_pct;

-- CASE 4: Payment value reconciliation gap by order
WITH items AS (
    SELECT order_id, SUM(price + freight_value) AS order_value
    FROM raw.olist_order_items
    GROUP BY 1
), payments AS (
    SELECT order_id, SUM(payment_value) AS paid_value
    FROM raw.olist_order_payments
    GROUP BY 1
)
SELECT
    i.order_id,
    ROUND(i.order_value,2) AS order_value,
    ROUND(p.paid_value,2) AS paid_value,
    ROUND(p.paid_value - i.order_value,2) AS gap
FROM items i
JOIN payments p USING(order_id)
WHERE ABS(p.paid_value - i.order_value) > 10
ORDER BY ABS(p.paid_value - i.order_value) DESC;

-- CASE 5: Sellers with high sales but high late-delivery rate
WITH seller_orders AS (
    SELECT DISTINCT seller_id, order_id
    FROM analytics.v_delivered_items
), delivery AS (
    SELECT
        so.seller_id,
        so.order_id,
        CASE WHEN o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date THEN 1 ELSE 0 END AS late_flag,
        ov.item_price
    FROM seller_orders so
    JOIN raw.olist_orders o USING(order_id)
    JOIN analytics.v_order_financials ov USING(order_id)
    WHERE o.order_status = 'delivered'
), agg AS (
    SELECT seller_id,
           SUM(item_price) AS revenue,
           AVG(late_flag) AS late_rate,
           COUNT(DISTINCT order_id) AS orders
    FROM delivery
    GROUP BY 1
)
SELECT seller_id, orders, ROUND(revenue,2) AS revenue, ROUND(100.0*late_rate,2) AS late_rate_pct
FROM agg
WHERE orders >= 50
ORDER BY late_rate DESC, revenue DESC;

-- CASE 6: Find the first order and first category for each unique customer
WITH customer_orders AS (
    SELECT customer_unique_id, order_id, order_purchase_timestamp
    FROM analytics.v_customer_order
    WHERE order_status = 'delivered'
), first_order AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp, order_id) AS rn
    FROM customer_orders
)
SELECT f.customer_unique_id,
       f.order_id,
       f.order_purchase_timestamp,
       oi.product_category_english AS first_category
FROM first_order f
LEFT JOIN analytics.v_delivered_items oi USING(order_id)
WHERE f.rn = 1;
