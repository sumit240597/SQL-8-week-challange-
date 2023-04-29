--How many pizzas were ordered?

select count(distinct(order_id)) as Total_orderd_Pizza
from customer_orders

--How many unique customer orders were made?

SELECT customer_id, COUNT(order_id) AS unique_customer_orders
FROM  customer_orders
GROUP BY customer_id

--How many successful orders were delivered by each runner?

SELECT COUNT(order_id) AS successful_orders
FROM  runner_orders
WHERE distance != 0

--How many of each type of pizza was delivered?

select pizza_names.pizza_id , count(customer_orders.pizza_id) as No_pizza_deliverd
from customer_orders
join pizza_names on pizza_names.pizza_id = customer_orders.pizza_id
join runner_orders on customer_orders.order_id = runner_orders.order_id
where distance !=0
group by pizza_names.pizza_id

---How many Vegetarian and Meatlovers were ordered by each customer?

select pizza_names.pizza_id , count(customer_orders.pizza_id) as No_pizza
from customer_orders
right join pizza_names on pizza_names.pizza_id = customer_orders.pizza_id
group by pizza_names.pizza_id

--What was the maximum number of pizzas delivered in a single order?

select customer_orders.order_id, count(customer_orders.pizza_id) as Max_number_of_orders
from customer_orders
join runner_orders on customer_orders.order_id = runner_orders.order_id 
where distance !=0
group by order_id
order by Max_number_of_orders desc limit 1

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select c.customer_id,
SUM(CASE 
		WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
		ELSE 0
		END) AS with_changes,
	SUM(CASE 
		WHEN c.exclusions IS NULL OR c.extras IS NULL THEN 1 
		ELSE 0
		END) AS no_changes
	FROM customer_orders AS c
JOIN runner_orders AS r
	ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id



--How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(DISTINCT customer_orders.order_id) as total_pizzas
FROM customer_orders
join runner_orders on customer_orders.order_id= runner_orders.order_id
WHERE customer_orders.exclusions != '' 
AND customer_orders.exclusions IS NOT NULL AND customer_orders.extras != ''
 AND customer_orders.extras IS NOT NULL and runner_orders.distance != 0


--What was the total volume of pizzas ordered for each hour of the day?

SELECT HOUR(order_time) AS hour_of_the_day, COUNT(order_id) AS total_pizzas_ordered
from customer_orders
GROUP BY hour_of_the_day 
order by hour_of_the_day desc


---What was the volume of orders for each day of the week?

select dayname(order_time) as Perdayorder , count(order_id) as Total_pizzas_orders
from customer_orders
group by Perdayorder