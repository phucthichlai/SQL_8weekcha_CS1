<h1 align="center"> :runner::pizza: Case Study #2: Pizza Runner :pizza::runner:</h1>

## D. Pricing and Ratings

***
###  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
with t1 as ( 
select case
when pizza_names.pizza_name = 'Meatlovers' then 12
else 10
end as price
from customer_orders

join runner_orders on 
customer_orders.order_id = runner_orders.order_id
join pizza_names on 
customer_orders.pizza_id = pizza_names.pizza_id
where pickup_time != 'null')

select sum(price) as revenue
from t1
```

#### Result set:
|  revenue  |
| --------- |
| 138       |

***
###  2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra

#### Use the query of question 1 

```sql
with t1 as (
select pizza_name,
case
when pizza_names.pizza_name = 'Meatlovers' and extras is null then 12
when pizza_names.pizza_name = 'Meatlovers' and extras is not null then 13
when pizza_names.pizza_name = 'Vegetarian' and extras is null then 10
else 11
end as price
from customer_orders 
join runner_orders on 
customer_orders.order_id = runner_orders.order_id
join pizza_names on 
customer_orders.pizza_id = pizza_names.pizza_id
where pickup_time != 'null'
)
select sum(price) as new_revenue
from t1
```

#### Result set:
|  revenue  |
| --------- |
| 141       |

***
### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
drop table rating
create table rating (order_id int, rating int, review varchar(100))
insert into rating VALUES
('1', '1', 'Really bad service'),
('2', '1', NULL),
('3', '4', 'Took too long...'),
('4', '1','Runner was lost, delivered it AFTER an hour. Pizza arrived cold' ),
('5', '2', 'Good service'),
('7', '5', 'It was great, good service and fast'),
('8', '2', 'He tossed it on the doorstep, poor service'),
('10', '5', 'Delicious!, he delivered it sooner than expected too!')
```

***
### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
• customer_id
• order_id
• runner_id
• rating
• order_time
• pickup_time
• Time between order and pickup
• Delivery duration
• Average speed
• Total number of pizzas

#### count the pizza per order

with t1 as (
select customer_orders.order_id, count(pizza_id) as total_pizza
from customer_orders join runner_orders on 
customer_orders.order_id = runner_orders.order_id
where pickup_time != 'null'
group by customer_orders.order_id
)

#### execute
select co.customer_id, co.order_id, ro.runner_id, r.rating, co.order_time, ro.pickup_time, total_pizza,
datediff(minute, order_time, pickup_time) as cooking_time, ro.duration, round(distance/duration * 60, 2) as average_speed
from customer_orders co
join runner_orders ro on 
co.order_id = ro.order_id
join rating r on 
co.order_id = r.order_id
join t1 on 
co.order_id = t1.order_id

#### Result set:
![image](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/result%20cs2%20Dq4.png?raw=true)

### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
with t1 as (
select case 
when pizza_id = 1 then round(12-0.3*distance,2)
else round(10-0.3*distance,2)
end as profit 
from customer_orders co
join runner_orders ro on 
co.order_id = ro.order_id
where pickup_time != 'null')

select sum(profit) as profit_total from t1
```
#### Result set:
| profit_total |
| ------------ |
| 73,38        |





