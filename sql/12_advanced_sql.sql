

-- 1. CTE AND WINDOW FUNCTION: Rank product categories by revenue

WITH category_revenue AS (
    SELECT
        COALESCE(p.product_category_name, 'Unknown') AS category,
        SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
    GROUP BY COALESCE(p.product_category_name, 'Unknown')
)
SELECT
    category,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM category_revenue
ORDER BY revenue_rank;


-- 2. CREATE A VIEW FOR MONTHLY SALES

CREATE OR REPLACE VIEW monthly_sales_view AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::DATE
        AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp);


-- 3. CREATE INDEXES TO SUPPORT QUERY PERFORMANCE

CREATE INDEX IF NOT EXISTS idx_orders_purchase_timestamp
    ON orders(order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders(order_status);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_order_items_seller_id
    ON order_items(seller_id);


-- 4. DISPLAY MONTHLY SALES FROM THE VIEW--

SELECT
    sales_month,
    total_orders,
    product_revenue
FROM monthly_sales_view
ORDER BY sales_month;