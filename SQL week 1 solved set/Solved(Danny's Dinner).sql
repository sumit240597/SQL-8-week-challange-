--What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, SUM(m.price) AS total_amount_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

--How many days has each customer visited the restaurant?

select customer_id, count(distinct order_date) as Total_days
from sales
group by customer_id;

--What was the first item from the menu purchased by each customer?

select s.customer_id,m.product_name as first_order_purchased
from 
(select customer_id, min(order_date) as first_order
from sales
group by customer_id ) as fo
join sales s on fo.customer_id= s.customer_id and fo.first_order= s.order_date
join menu m on s.product_id= m.product_id;

--What is the most purchased item on the menu and how many times was it purchased by all customers?

select m.product_name, sum(sales_count) as Total_purchase
from(
select product_id ,count(*) as sales_count
from sales
group by product_id) p
join menu m on p.product_id=m.product_id
group by m.product_name
order by total_purchase desc ;

--Which item was the most popular for each customer?


SELECT s.customer_id, m.product_name, COUNT(*) AS purchases
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
HAVING COUNT(*) = (
  SELECT MAX(purchases)
  FROM (
    SELECT customer_id, product_id, COUNT(*) AS purchases
    FROM sales
    GROUP BY customer_id, product_id
  ) AS customer_product_counts
  WHERE s.customer_id = customer_product_counts.customer_id
)
ORDER BY s.customer_id ASC;


--Which item was purchased first by the customer after they became a member?

select m.customer_id,menu.product_name
from members m 
join sales s on s.customer_id=m.customer_id and s.order_date>= m.join_date
JOIN menu ON  menu.product_id = s.product_id 
group by m.customer_id ,menu.product_name
having min(s.order_date)
order by m.customer_id asc;


--Which item was purchased just before the customer became a member?

select s.customer_id,menu.product_name
from sales s
join(
select customer_id,join_date
from members) as m
on s.customer_id = m.customer_id and s.order_date<join_date
join menu 
on s.product_id=menu.product_id
order by s.customer_id;

--What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id, SUM(m.price) AS total_amount_spent, COUNT(*) AS total_items
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members ON s.customer_id = members.customer_id AND s.order_date >= members.join_date
GROUP BY s.customer_id;

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


select s.customer_id,
sum( case when 
menu.product_name= 'sushi'
 then price *20 
 else price*10 end) as Total_price
 
from sales s
join menu on s.product_id = menu.product_id
group by customer_id;


---> In the first week after a customer joins the program (including their join date)
---they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January

SELECT s.customer_id,
       SUM(CASE 
           WHEN s.order_date BETWEEN m_jd.join_date AND m_jd.join_date + INTERVAL 6 DAY 
           THEN 2 * m.price 
           ELSE m.price 
       END) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN (
    SELECT customer_id, join_date
    FROM members
) m_jd ON s.customer_id = m_jd.customer_id
WHERE s.order_date BETWEEN '2021-01-01' AND '2021-01-31'
AND s.customer_id IN ('A', 'B')
GROUP BY s.customer_id;
