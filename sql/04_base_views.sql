CREATE OR REPLACE VIEW analytics.v_order_items AS
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    i.shipping_limit_date,
    i.price,
    i.freight_value,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    p.product_category_name,
    COALESCE(t.product_category_name_english, p.product_category_name) AS product_category_english,
    s.seller_state,
    s.seller_city
FROM raw.olist_order_items i
JOIN raw.olist_orders o ON o.order_id = i.order_id
JOIN raw.olist_customers c ON c.customer_id = o.customer_id
LEFT JOIN raw.olist_products p ON p.product_id = i.product_id
LEFT JOIN raw.product_category_translation t ON t.product_category_name = p.product_category_name
LEFT JOIN raw.olist_sellers s ON s.seller_id = i.seller_id;

CREATE OR REPLACE VIEW analytics.v_delivered_items AS
SELECT *
FROM analytics.v_order_items
WHERE order_status = 'delivered';

CREATE OR REPLACE VIEW analytics.v_customer_order AS
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM raw.olist_orders o
JOIN raw.olist_customers c ON c.customer_id = o.customer_id;

CREATE OR REPLACE VIEW analytics.v_order_financials AS
WITH item_totals AS (
    SELECT
        order_id,
        SUM(price) AS item_price,
        SUM(freight_value) AS freight_value,
        SUM(price + freight_value) AS item_plus_freight
    FROM raw.olist_order_items
    GROUP BY order_id
),
payment_totals AS (
    SELECT order_id, SUM(payment_value) AS payment_value
    FROM raw.olist_order_payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    o.order_purchase_timestamp,
    COALESCE(i.item_price, 0) AS item_price,
    COALESCE(i.freight_value, 0) AS freight_value,
    COALESCE(i.item_plus_freight, 0) AS item_plus_freight,
    COALESCE(p.payment_value, 0) AS payment_value
FROM raw.olist_orders o
JOIN raw.olist_customers c ON c.customer_id = o.customer_id
LEFT JOIN item_totals i USING(order_id)
LEFT JOIN payment_totals p USING(order_id);
