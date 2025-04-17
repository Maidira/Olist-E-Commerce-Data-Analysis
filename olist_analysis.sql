-------------------------------------------------
-- CASE STUDY: Exploring Olist E-Commerce  Data--
-------------------------------------------------

-- Tool used: MySQL Workbench

-------------------------------------------------
-- CASE STUDY QUESTIONS AND ANSWERS--
-------------------------------------------------

-- Database Setup
CREATE database olist;
USE olist;

-- Changing header product_category_translation table
ALTER TABLE 
	product_category_translation
RENAME COLUMN
	ï»¿product_category_name TO product_category_name;


----------------- Customer Behaviour -----------------------

-- Repeat customers vs one time buyers
with cte AS(
	SELECT 
		customer_id,
        COUNT(order_id) AS order_count
	FROM 
    olist_orders_dataset
  GROUP BY customer_id)
SELECT
	  COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END) AS repeat_customers,
    COUNT(DISTINCT CASE WHEN order_count = 1 THEN customer_id END) AS one_time_custmers
FROM 
    cte;

-- Average Order per customer by state
SELECT 
	c.customer_state,
    COUNT(order_id)/COUNT(DISTINCT o.customer_id) AS avg_orders_per_customer
FROM 
	olist_orders_dataset o 
JOIN
	olist_customers_dataset c
    ON o.customer_id = c.customer_id
GROUP BY 
	c.customer_state
ORDER BY avg_orders_per_customer;


 --------------------Sales Insight -----------------   

-- Monthly Sales trend
SELECT
	  EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
    COUNT(o.order_id) AS total_orders,
    SUM(price) AS total_revenue
FROM 
    olist_orders_dataset o
JOIN
	  olist_order_items_dataset oi
    ON o.order_id = oi.order_id
GROUP BY 
    order_month
ORDER BY 
    order_month;
    

-- High revenue generating sellers
SELECT
	  s.seller_id,
    s.seller_city,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM 
    olist_sellers_dataset s
JOIN 
    olist_order_items_dataset oi
	  ON 
    s.seller_id = oi.seller_id
GROUP BY 
	  s.seller_id,
    s.seller_city
ORDER BY
	  total_revenue DESC;































