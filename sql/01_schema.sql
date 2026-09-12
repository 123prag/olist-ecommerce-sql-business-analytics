CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS raw.olist_order_reviews CASCADE;
DROP TABLE IF EXISTS raw.olist_order_payments CASCADE;
DROP TABLE IF EXISTS raw.olist_order_items CASCADE;
DROP TABLE IF EXISTS raw.olist_orders CASCADE;
DROP TABLE IF EXISTS raw.olist_customers CASCADE;
DROP TABLE IF EXISTS raw.olist_products CASCADE;
DROP TABLE IF EXISTS raw.olist_sellers CASCADE;
DROP TABLE IF EXISTS raw.olist_geolocation CASCADE;
DROP TABLE IF EXISTS raw.product_category_translation CASCADE;

CREATE TABLE raw.olist_customers (
    customer_id VARCHAR(40) PRIMARY KEY,
    customer_unique_id VARCHAR(40) NOT NULL,
    customer_zip_code_prefix INTEGER,
    customer_city TEXT,
    customer_state VARCHAR(2)
);

CREATE TABLE raw.olist_orders (
    order_id VARCHAR(40) PRIMARY KEY,
    customer_id VARCHAR(40) NOT NULL,
    order_status TEXT NOT NULL,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES raw.olist_customers(customer_id)
);

CREATE TABLE raw.olist_order_items (
    order_id VARCHAR(40) NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id VARCHAR(40),
    seller_id VARCHAR(40),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),
    PRIMARY KEY(order_id, order_item_id),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES raw.olist_orders(order_id)
);

CREATE TABLE raw.olist_order_payments (
    order_id VARCHAR(40) NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type TEXT,
    payment_installments INTEGER,
    payment_value NUMERIC(12,2),
    PRIMARY KEY(order_id, payment_sequential),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES raw.olist_orders(order_id)
);

CREATE TABLE raw.olist_order_reviews (
    review_id VARCHAR(40),
    order_id VARCHAR(40) NOT NULL,
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE raw.olist_products (
    product_id VARCHAR(40) PRIMARY KEY,
    product_category_name TEXT,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g NUMERIC(12,3),
    product_length_cm NUMERIC(12,3),
    product_height_cm NUMERIC(12,3),
    product_width_cm NUMERIC(12,3)
);

CREATE TABLE raw.olist_sellers (
    seller_id VARCHAR(40) PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city TEXT,
    seller_state VARCHAR(2)
);

CREATE TABLE raw.olist_geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat NUMERIC(12,8),
    geolocation_lng NUMERIC(12,8),
    geolocation_city TEXT,
    geolocation_state VARCHAR(2)
);

CREATE TABLE raw.product_category_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT
);

CREATE INDEX idx_orders_customer ON raw.olist_orders(customer_id);
CREATE INDEX idx_orders_purchase_ts ON raw.olist_orders(order_purchase_timestamp);
CREATE INDEX idx_items_product ON raw.olist_order_items(product_id);
CREATE INDEX idx_items_seller ON raw.olist_order_items(seller_id);
CREATE INDEX idx_payments_order ON raw.olist_order_payments(order_id);
CREATE INDEX idx_reviews_order ON raw.olist_order_reviews(order_id);
CREATE INDEX idx_geo_zip ON raw.olist_geolocation(geolocation_zip_code_prefix);
