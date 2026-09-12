-- Run this in psql from the project root, or execute equivalent COPY commands in DBeaver.
-- Replace /absolute/path/to/olist_portfolio with your actual project path.

\copy raw.olist_customers FROM '/absolute/path/to/olist_portfolio/data/raw/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.olist_orders FROM '/absolute/path/to/olist_portfolio/data/raw/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.olist_order_items FROM '/absolute/path/to/olist_portfolio/data/raw/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.olist_order_payments FROM '/absolute/path/to/olist_portfolio/data/raw/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.olist_order_reviews FROM '/absolute/path/to/olist_portfolio/data/raw/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.olist_products FROM '/absolute/path/to/olist_portfolio/data/raw/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.olist_sellers FROM '/absolute/path/to/olist_portfolio/data/raw/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.olist_geolocation FROM '/absolute/path/to/olist_portfolio/data/raw/olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');
\copy raw.product_category_translation FROM '/absolute/path/to/olist_portfolio/data/raw/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL '');

-- If COPY reports type/date errors, first load into staging TEXT tables and cast explicitly.
