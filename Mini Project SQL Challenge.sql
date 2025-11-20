CREATE SCHEMA IDC_Pizza_server;

-- Phase 1: Foundation & Inspection:
-- Question 2
SELECT DISTINCT category FROM pizza_types;

-- Question 3
SELECT pizza_type_id, name, COALESCE(ingredients, "Missing Data") AS ingredients FROM pizza_types LIMIT 5;

-- Question 4
SELECT price FROM pizzas WHERE price IS NULL;

-- Phase 2: Filtering & Exploration:
-- Question 1
SELECT order_id, date FROM orders WHERE date = "2015-01-01";

-- Question 2
SELECT pizza_id, pizza_type_id, price FROM pizzas ORDER BY price DESC;

-- Question 3
SELECT pizza_id, pizza_type_id, size FROM pizzas WHERE size IN ('L', 'XL');

-- Question 4
SELECT pizza_id, price FROM pizzas WHERE price BETWEEN 15 AND 17;

-- Question 5
SELECT pizza_type_id, name FROM pizza_types WHERE name LIKE '%Chicken%'; 

-- Question 6.
SELECT order_id, date, time FROM orders WHERE date = '2015-02-15' AND time >= '20:00:00';

-- Phase 3: Sales Performance:
-- Question 1
SELECT ROUND(SUM(quantity),2) AS total_qty FROM order_details;

-- Question 2
SELECT ROUND(AVG(price),2) AS avg_price FROM pizzas;

-- Question 3
SELECT od.order_id, SUM(od.quantity * p.price) AS total_order_value FROM order_details od JOIN pizzas p ON p.pizza_id = od.pizza_id GROUP BY od.order_id;

-- Question 4
SELECT pt.category, SUM(od.quantity) AS total_qty_sold FROM order_details od  JOIN pizzas p ON p.pizza_id = od.pizza_id JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id GROUP BY pt.category;

-- Question 5
SELECT pt.category, SUM(od.quantity) AS total_sold FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id GROUP BY pt.category HAVING SUM(od.quantity) > 5000;

-- Question 6
SELECT p.pizza_id, p.pizza_type_id, p.size FROM pizzas p LEFT JOIN order_details od ON p.pizza_id = od.pizza_id WHERE od.order_details_id IS NULL;

-- Question 7
SELECT p1.pizza_type_id, p1.size AS size_1, p2.size AS size_2, p1.price AS price_1, p2.price AS price_2, ABS(p1.price - p2.price) AS price_difference FROM pizzas p1 JOIN pizzas p2 ON p1.pizza_type_id = p2.pizza_type_id WHERE p1.price < p2.price;
