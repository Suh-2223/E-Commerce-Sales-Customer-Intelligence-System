
-- E-commerce Sales Analysis
-- 1. Overall sales performance

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_product_revenue,
    ROUND(AVG(oi.price), 2) AS average_item_price,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
