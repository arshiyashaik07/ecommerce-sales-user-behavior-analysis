-- E-Commerce Sales & User Behavior Analysis

-- 1. Total Summary
SELECT
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'Completed' THEN o.total_amount ELSE 0 END), 2) AS total_revenue,
    SUM(CASE WHEN o.order_status = 'Completed' THEN o.quantity ELSE 0 END) AS total_products_sold,
    COUNT(DISTINCT c.cart_id) AS total_cart_records
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN cart c ON u.user_id = c.user_id;

-- 2. Revenue by Product Category
SELECT
    p.category,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    SUM(o.quantity) AS total_quantity_sold
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 3. Top Products by Revenue
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    SUM(o.quantity) AS total_quantity_sold
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;

-- 4. Cart Status Analysis
SELECT
    cart_status,
    COUNT(cart_id) AS total_cart_records,
    SUM(quantity) AS total_quantity
FROM cart
GROUP BY cart_status
ORDER BY total_cart_records DESC;

-- 5. Order Status Analysis
SELECT
    order_status,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_amount
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 6. Payment Mode Analysis
SELECT
    payment_mode,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_amount
FROM orders
GROUP BY payment_mode
ORDER BY total_amount DESC;

-- 7. User Activity by City
SELECT
    u.city,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'Completed' THEN o.total_amount ELSE 0 END), 2) AS completed_revenue
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.city
ORDER BY completed_revenue DESC;

-- 8. Monthly Revenue Trend
SELECT
    DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%M') AS month_name,
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS year_value,
    ROUND(SUM(total_amount), 2) AS monthly_revenue,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_status = 'Completed'
GROUP BY month_name, year_value
ORDER BY MIN(STR_TO_DATE(order_date, '%d-%m-%Y'));