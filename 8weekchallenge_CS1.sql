/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT S.customer_id, Sum(M.price) as spending
FROM sales as S 
left join menu as M 
ON S.product_id = M.product_id
group by S.customer_id

-- 2. How many days has each customer visited the restaurant?

select customer_id, count (distinct (order_date)) as Visit_day from sales
group by customer_id

-- 3. What was the first item from the menu purchased by each customer?

with t1 as(
select *, rank() over(partition by customer_id order by order_date asc) as rnumber
from sales
)
select t1.customer_id, menu.product_name
from t1
left join menu ON
t1.product_id = menu.product_id
where rnumber = 1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

with t1 as (
select top 1 product_id, count(product_id) as unit_sold
from sales 
group by product_id
order by unit_sold desc
)
select M.product_name, t1.unit_sold
from menu as M 
join t1 ON
M.product_id = t1.product_id

-- 5. Which item was the most popular for each customer?

with t2 as (
select *, RANK() OVER (PARTITION by customer_id order by unit DESC) as rn
from (
select customer_id, product_id, count(product_id) as unit
from sales
group by customer_id, product_id
) as t1
)
select t2.customer_id, menu.product_name
from t2 join menu ON
t2.product_id = menu.product_id
where t2.rn=1

-- 6. Which item was purchased first by the customer after they became a member?

with t2 as (
select *, RANK() over(PARTITION by customer_id order by order_date asc) as rn 
from (
select sales.customer_id, sales.order_date, sales.product_id, members.join_date
from sales left join members ON
sales.customer_id = members.customer_id
where order_date>join_date
) as t1
)
select t2.customer_id, t2.order_date, menu.product_name
from t2 JOIN menu ON
t2.product_id = menu.product_id
where rn = 1

-- 7. Which item was purchased just before the customer became a member?

with t2 as (
select *, RANK() over(PARTITION by customer_id order by order_date desc) as rn 
from (
select sales.customer_id, sales.order_date, sales.product_id, members.join_date
from sales left join members ON
sales.customer_id = members.customer_id
where order_date<=join_date
) as t1
)
select t2.customer_id, t2.order_date, menu.product_name
from t2 JOIN menu ON
t2.product_id = menu.product_id
where rn = 1

-- 8. What is the total items and amount spent for each member before they became a member?

select customer_id, count(product_id) as total_item, sum(price) as total_price
from (
select sales.customer_id, sales.product_id, menu.price
from sales
left join menu ON
sales.product_id = menu.product_id
right JOIN members ON
sales.customer_id = members.customer_id
where order_date<=join_date
) as t1
group by customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

alter table menu add points as (
   case when product_name = 'sushi' then price*20
   else price*10
   END
)
select sales.customer_id, sum(menu.points) as cus_points
from sales join menu ON
sales.product_id = menu.product_id
group by customer_id

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

with members2 as (
select *, DATEADD(day, 6, join_date) as valid_date, EOMONTH('2021-01-01') as last_date
from members)
select sales.customer_id,
sum (case 
when sales.product_id = 1 then price * 20
when sales.order_date between members2.join_date and members2.valid_date then price*20
else price*10
end) as points
from sales left join members2 ON sales.customer_id = members2.customer_id
left join menu on sales.product_id = menu.product_id
where order_date< '2021-01-31'
group by sales.customer_id

Bonus question #1:

select sales.customer_id, sales.order_date, menu.product_name, menu.price,
case 
when members.join_date <=sales.order_date then 'Y'
else 'N'
end as member
from sales left join menu ON
sales.product_id = menu.product_id
left join members ON
sales.customer_id = members.customer_id

Bonus question #2:
with t1 as
 (
select sales.customer_id, sales.order_date, menu.product_name, menu.price,
(case
when members.join_date <=sales.order_date then 'Y'
else 'N'
end) as member
from sales left join menu ON
sales.product_id = menu.product_id
left join members ON
sales.customer_id = members.customer_id)

select *, 
(case 
when member = 'Y' then dense_RANK() over(partition by customer_id, member order by order_date asc)
else null
end) as ranking
from t1
