-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

with time as

(
select c.order_id,c.order_time, r.pickup_time,
timestampdiff(minute,c.order_time,r.pickup_time) as pickup_minutes
from customer_orders c
join runner_orders r
on c.order_id = r.order_id
where r.distance != 0
)

select round(avg(pickup_minutes),2) as avg_pickup_min
from time ;


--- Is there any relationship between the number of pizzas and how long the order takes to prepare?

with pre_time as(
select c.order_id , count(c.order_id) as No_of_pizzas, c.order_time, r.pickup_time,
timestampdiff(minute, c.order_time, r.pickup_time) as preparation_time
from customer_orders c
join runner_orders r 
on c.order_id = r.order_id
where distance != 0
group by c.order_id , c.order_time, r.pickup_time
)

select No_of_pizzas, round(avg(preparation_time),2) as Avg_prepration_time
from pre_time
group by no_of_pizzas;


-- What was the average distance travelled for each customer?

select c.customer_id , round(avg(r.distance),2) as Avg_distance
from customer_orders c
join runner_orders r
on c.order_id = r.order_id
group by c.customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?

SELECT MAX(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)) - MIN(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)) AS delivery_time_difference
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.distance != 0;


--What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT  r.runner_id, c.customer_id, COUNT(c.order_id) AS pizza_count, 
  r.distance, (r.duration / 60) AS duration_hours , 
  ROUND((r.distance/r.duration * 60), 2) AS avg_speed
FROM runner_orders AS r
JOIN customer_orders AS c
  ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;

---What is the successful delivery percentage for each runner?


SELECT 
  runner_id, 
  ROUND(100 * SUM(
    CASE WHEN distance = 0 THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM runner_orders
GROUP BY runner_id;