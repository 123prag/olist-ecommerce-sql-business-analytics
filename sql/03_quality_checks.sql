-- 1. Row counts
SELECT 'customers' AS table_name, COUNT(*) FROM raw.olist_customers
UNION ALL SELECT 'orders', COUNT(*) FROM raw.olist_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM raw.olist_order_items
UNION ALL SELECT 'payments', COUNT(*) FROM raw.olist_order_payments
UNION ALL SELECT 'reviews', COUNT(*) FROM raw.olist_order_reviews
UNION ALL SELECT 'products', COUNT(*) FROM raw.olist_products
UNION ALL SELECT 'sellers', COUNT(*) FROM raw.olist_sellers
UNION ALL SELECT 'geolocation', COUNT(*) FROM raw.olist_geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM raw.product_category_translation;

-- 2. Duplicate business keys
SELECT customer_id, COUNT(*) FROM raw.olist_customers GROUP BY customer_id HAVING COUNT(*) > 1;
SELECT order_id, order_item_id, COUNT(*) FROM raw.olist_order_items GROUP BY order_id, order_item_id HAVING COUNT(*) > 1;
SELECT order_id, payment_sequential, COUNT(*) FROM raw.olist_order_payments GROUP BY order_id, payment_sequential HAVING COUNT(*) > 1;

-- 3. Orphan foreign keys
SELECT COUNT(*) AS orphan_orders
FROM raw.olist_orders o
LEFT JOIN raw.olist_customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_items
FROM raw.olist_order_items i
LEFT JOIN raw.olist_orders o ON o.order_id = i.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_products
FROM raw.olist_order_items i
LEFT JOIN raw.olist_products p ON p.product_id = i.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS orphan_sellers
FROM raw.olist_order_items i
LEFT JOIN raw.olist_sellers s ON s.seller_id = i.seller_id
WHERE s.seller_id IS NULL;

-- 4. Missingness
SELECT
    COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS missing_customer_unique_id,
    COUNT(*) FILTER (WHERE customer_city IS NULL) AS missing_customer_city,
    COUNT(*) FILTER (WHERE customer_state IS NULL) AS missing_customer_state
FROM raw.olist_customers;

SELECT
    COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS missing_purchase_ts,
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS missing_delivery_date,
    COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL) AS missing_estimated_date
FROM raw.olist_orders;

-- 5. Negative / impossible monetary values
SELECT COUNT(*) AS negative_item_price FROM raw.olist_order_items WHERE price < 0;
SELECT COUNT(*) AS negative_freight FROM raw.olist_order_items WHERE freight_value < 0;
SELECT COUNT(*) AS negative_payment FROM raw.olist_order_payments WHERE payment_value < 0;

-- 6. Timestamp consistency
SELECT COUNT(*) AS invalid_delivery_sequence
FROM raw.olist_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

-- 7. Payment reconciliation against item + freight at order level
WITH item_totals AS (
    SELECT order_id, SUM(price + freight_value) AS item_plus_freight
    FROM raw.olist_order_items
    GROUP BY order_id
), payment_totals AS (
    SELECT order_id, SUM(payment_value) AS paid
    FROM raw.olist_order_payments
    GROUP BY order_id
)
SELECT
    COUNT(*) AS orders_checked,
    COUNT(*) FILTER (WHERE ABS(p.paid - i.item_plus_freight) > 0.01) AS orders_with_payment_gap
FROM item_totals i
JOIN payment_totals p USING(order_id);

-- 8. Order status distribution
SELECT order_status, COUNT(*) AS orders
FROM raw.olist_orders
GROUP BY order_status
ORDER BY orders DESC;
