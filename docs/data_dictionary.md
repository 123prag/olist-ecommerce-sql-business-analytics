# Data Dictionary — Olist project

## customers
- customer_id: order-specific customer identifier used by the orders table.
- customer_unique_id: stable customer identifier for customer-level behavior.
- customer_zip_code_prefix: ZIP-code prefix.
- customer_city: customer city.
- customer_state: customer state.

## orders
- order_id: unique order identifier.
- customer_id: foreign key to customers.
- order_status: order lifecycle status.
- order_purchase_timestamp: purchase time.
- order_approved_at: approval time.
- order_delivered_carrier_date: carrier handoff date.
- order_delivered_customer_date: customer delivery date.
- order_estimated_delivery_date: estimated delivery date.

## order_items
- order_id: foreign key to orders.
- order_item_id: line number inside an order.
- product_id: product identifier.
- seller_id: seller identifier.
- shipping_limit_date: seller shipping deadline.
- price: item price.
- freight_value: freight charged for that line.

## payments
- order_id: order identifier.
- payment_sequential: payment sequence within order.
- payment_type: payment method.
- payment_installments: number of installments.
- payment_value: payment amount.

## reviews
- review_id: review identifier.
- order_id: associated order.
- review_score: 1–5 score.
- comment fields: text feedback.
- creation/answer timestamps: review lifecycle.

## products
Product catalog attributes including category, text lengths, photo count and dimensions/weight.

## sellers
Seller identity and location fields.

## geolocation
ZIP-code prefix mapped to approximate latitude/longitude and location names.

## category translation
Portuguese category name to English category label.
