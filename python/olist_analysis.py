from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine, text

# 1) Point this to your local PostgreSQL database.
# Example: postgresql+psycopg2://postgres:postgres@localhost:5432/olist
DB_URL = "postgresql+psycopg2://postgres:postgres@localhost:5432/olist"
engine = create_engine(DB_URL)

OUT = Path("outputs")
OUT.mkdir(exist_ok=True)


def query(sql: str) -> pd.DataFrame:
    with engine.connect() as conn:
        return pd.read_sql(text(sql), conn)


monthly = query("""
SELECT DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(price),2) AS revenue
FROM analytics.v_delivered_items
GROUP BY 1 ORDER BY 1;
""")

monthly["month"] = pd.to_datetime(monthly["month"])
monthly.plot(x="month", y="revenue", legend=False, figsize=(10,5), title="Monthly merchandise revenue")
plt.tight_layout()
plt.savefig(OUT / "monthly_revenue.png", dpi=180)
plt.close()

category = query("""
SELECT product_category_english AS category,
       ROUND(SUM(price),2) AS revenue
FROM analytics.v_delivered_items
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;
""")
category = category.sort_values("revenue")
category.plot.barh(x="category", y="revenue", legend=False, figsize=(10,6), title="Top product categories by merchandise revenue")
plt.tight_layout()
plt.savefig(OUT / "top_categories.png", dpi=180)
plt.close()

states = query("""
SELECT customer_state,
       ROUND(SUM(price),2) AS revenue,
       COUNT(DISTINCT order_id) AS orders
FROM analytics.v_delivered_items
GROUP BY 1
ORDER BY revenue DESC;
""")

states.to_csv(OUT / "state_performance.csv", index=False)
monthly.to_csv(OUT / "monthly_revenue.csv", index=False)
category.to_csv(OUT / "top_categories.csv", index=False)

print("Saved outputs to", OUT.resolve())
