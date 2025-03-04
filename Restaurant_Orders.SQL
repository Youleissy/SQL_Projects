SELECT * FROM orders_detail;

CREATE TABLE menu_items (
 		menu_item_id SMALLINT NOT NULL,
  		item_name VARCHAR(45),
 		category VARCHAR(45),
 		price DECIMAL(5,2),
 		PRIMARY KEY (menu_item_id)
);


--- (1) View the menu_items table and write a query to find the number of items on the menu --
               
SELECT COUNT (DISTINCT menu_item_id) FROM menu_items; 

-- (2) What are the least and most expensive items on the menu? --


-- The most expensive items on menu:

SELECT price, item_name FROM menu_items
WHERE (price= (SELECT MIN(price) AS "SmallestPrice" FROM menu_items) OR
	   price= (SELECT MAX(price) AS "HightestPrice" FROM menu_items)
	   );

	
-- (3)How many Italian dishes are on the menu? 
-- What are the least and most expensive Italian dishes on the menu?


SELECT COUNT (category) FROM menu_items
WHERE category = 'Italian';



SELECT * FROM menu_items
WHERE(category = 'Italian')
ORDER BY price ASC  ;



--How many dishes are in each category? What is the average dish price within each category?
SELECT COUNT (DISTINCT category) FROM menu_items;


--View the order_details table. What is the date range of the table?--

SELECT MIN(order_date), MAX(order_date)  FROM orders_detail;

--How many orders were made within this date range? 
--How many items were ordered within this date range?


SELECT COUNT(order_id), COUNT(item_id) FROM orders_detail
WHERE order_date BETWEEN '2023-02-01' and '2023-03-31';


--Which orders had the most number of items?

SELECT  COUNT(item_id)AS item_id_by_order, order_id FROM orders_detail
GROUP BY order_id
ORDER by COUNT(item_id) DESC;

--How many orders had more than 12 items?--


SELECT  COUNT(item_id)AS item_id_by_order FROM orders_detail
--GROUP BY order_id
HAVING COUNT(item_id) >= 12;

---Combine the menu_items and order_details tables into a single table 
--CREATE NEW TABLE orders_and_menu (

--1-- Combine the menu_items and order_details tables into a single table
SELECT * FROM menu_items;
SELECT * FROM orders_detail;

SELECT *
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id;

--What were the least and most ordered items? What categories were they in?

SELECT item_id,item_name, category, COUNT(order_id) AS total_orders
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY item_id, item_name, category
ORDER BY total_orders desc;


--What were the top 5 orders that spent the most money?

SELECT order_id, SUM(price) AS total_spent
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE price != 0
GROUP BY order_id
ORDER BY total_spent DESC
LIMIT 5;


--View the details of the highest spend order
SELECT *
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id = 440;

--Which specific items were purchased?




--BONUS: View the details of the top 5 highest spend orders*/

SELECT *
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id in (440, 2075, 1957, 330, 2675);


SELECT order_id, category, COUNT(item_id) AS num_item
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id in (440, 2075, 1957, 330, 2675)
GROUP BY category, order_id;

--How much was the most expensive order in the dataset?

SELECT order_id, SUM(price) AS total_spent
FROM orders_detail od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE price != 0
GROUP BY order_id
ORDER BY total_spent DESC
LIMIT 1;
