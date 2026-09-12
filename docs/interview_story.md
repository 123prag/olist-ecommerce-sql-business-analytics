# Interview story

## 60-second version
I built an end-to-end SQL analytics project using the real, anonymised Olist Brazilian e-commerce dataset. I loaded the relational CSVs into PostgreSQL, validated keys and missing data, built analytical views, and used joins, CTEs and window functions to analyze revenue, customers, products, sellers, delivery performance and reviews. I used `customer_unique_id` for customer behavior because the orders table uses an order-specific `customer_id`. I then created RFM-style segments, cohort retention analysis and client-facing KPI queries. The final output was a five-slide business summary focused on where revenue comes from, where retention or delivery is weak, and which segments or categories deserve attention.

## Questions you should expect
1. Why did you choose PostgreSQL?
2. What is the grain of `order_items`?
3. Why is `customer_unique_id` important?
4. How can joins cause double counting?
5. Why do you use `COUNT(DISTINCT order_id)` in some metrics?
6. How did you define an order as delivered?
7. How did you calculate MoM growth?
8. Why use `LAG()`?
9. How did you define churn / at-risk?
10. What are the limits of your revenue definition?
11. How did you validate payment values?
12. What business action follows from your biggest finding?

## Strong answer pattern
Business question → metric definition → data source → query logic → validation → finding → recommendation → limitation.
