<h1 align="center"> :runner::pizza: Case Study #2: Pizza Runner :pizza::runner:</h1>

## Questions: A. Pizza Metrics

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

*** 
###  1. How many pizzas were ordered?

```sql
select count(pizza_id) as total_pizza 
from customer_orders
``` 
	
#### Result set:
| total_pizza | 
| ----------- | 
| 14          | 

*** 
###  2. How many unique customer orders were made?

```sql
select count (distinct customer_id) as Unique_customer
from customer_orders
``` 
	
#### Result set:
| Unique_customer | 
| --------------- | 
| 5               | 

*** 
###  3. How many successful orders were delivered by each runner?

```sql
select runner_id, count(pickup_time) as sucessful_order 
from runner_orders
where pickup_time != 'null'
group by runner_id
``` 
	
#### Result set:
| runner_id   |  sucessful_order  |
| ----------- | ----------------- |
| 1           | 4                 |
| 2           | 6                 |
| 3           | 6                 |

*** 
###  4. How many of each type of pizza was delivered?

```sql
select pizza_id, count(pizza_id) as sucessful_delivery 
from customer_orders as co join runner_orders as ro on 
co.order_id = ro.order_id
where pickup_time != 'null'
group by pizza_id
```

#### Result set:
| pizza_id    |  sucessful_delivery  |
| ----------- | -------------------- |
| 1           | 9                    |
| 2           | 3                    |

*** 
###  5. How many Vegetarian and Meatlovers were ordered by each customer?

- Change data type from Text to Varchar for further query
```sql
alter table pizza_names
alter column pizza_name varchar(20)

select customer_id, pizza_name, count(pizza_name) as total
from customer_orders as co JOIN pizza_names as pn ON
co.pizza_id = pn.pizza_id
group by customer_id, pizza_name
order by customer_id asc
``` 
	
#### Result set:
| customer_id   |  pizza_name  | total |
| ------------- | ------------ | ----- |
| 101           | Meatlovers   | 2     |
| 101           | Vegetarian   | 1     |
| 102           | Meatlovers   | 2     |
| 102           | Vegetarian   | 1     |
| 103           | Meatlovers   | 3     |
| 103           | Vegetarian   | 1     |
| 104           | Meatlovers   | 3     |
| 105           | Vegetarian   | 1     |

***
###  6. What was the maximum number of pizzas delivered in a single order?

```sql
select top 1 order_id, count(pizza_id) as maximum 
from customer_orders
group by order_id
order by maximum desc
```

#### Result set:
| order_id   | maximum    |
| ---------- | ---------- |
| 101        | Meatlovers |

***
###  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
update customer_orders
set exclusions = null
where exclusions in ('null','')

update customer_orders
set extras = null
where extras in ('null','')

select customer_id, count(pizza_id) as changed_pizza_count
from customer_orders as co left JOIN runner_orders as ro ON
co.order_id = ro.order_id
where pickup_time != 'null'
and (exclusions is not null or extras is not null)
group by customer_id

select customer_id, count(pizza_id) as unchanged_pizza_count
from customer_orders as co left JOIN runner_orders as ro ON
co.order_id = ro.order_id
where pickup_time != 'null'
and (exclusions is null and extras is null)
group by customer_id
```

#### Result set:
| customer_id |  changed_pizza_count |
| ----------- | -------------------- |
| 103         | 3                    |
| 104         | 2                    |
| 105         | 1                    |

| customer_id | unchanged_pizza_count |
| ----------- | --------------------- |
| 101         | 2                     |
| 102         | 3                     |
| 104         | 1                     |

***
###  8. How many pizzas were delivered that had both exclusions and extras?

```sql
select count(pizza_id) as changed_both
from customer_orders as co left JOIN runner_orders as ro ON
co.order_id = ro.order_id
where pickup_time != 'null'
and (exclusions is not null and extras is not null)
```

#### Result set:
| changed_both |
| ------------ |
| 1            |

***
###  9. What was the total volume of pizzas ordered for each hour of the day?

```sql
select DATEPART(HOUR, order_time) as hour, 
count(DATEPART(HOUR, order_time)) as pizza_each_hour
from customer_orders
group by DATEPART(HOUR, order_time)
order by DATEPART(HOUR, order_time) asc
```

#### Result set:
| hour | pizza_each_hour |
| ---- | --------------- |
| 11   | 1               |
| 13   | 3               |
| 18   | 3               |
| 19   | 1               |
| 21   | 3               |
| 13   | 3               |

***
###  10. What was the volume of orders for each day of the week?

```sql
select DATEPART(WEEKDAY, order_time) as weekdays, 
count(datepart(WEEKDAY, order_time)) as pizza_each_day
from customer_orders
group by datepart(WEEKDAY, order_time) 
order by datepart(WEEKDAY, order_time)
```

#### Result set:
| weekdays | pizza_each_day |
| -------- | -------------- |
| 4        | 5              |
| 5        | 3              |
| 6        | 1              |
| 7        | 5              |

***
## Questions: B. Runner and Customer Experience

###  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
select (DATEDIFF(DAYOFYEAR, '2021-01-01', registration_date)/7+1) as registered_week, 
count(DATEDIFF(DAYOFYEAR, '2021-01-01', registration_date)/7+1) as runner_reg
from runners
group by (DATEDIFF(DAYOFYEAR, '2021-01-01', registration_date)/7+1)
```

#### Result set:
| registered_week | runner_reg |
| --------------- | ---------- |
| 1        	  | 2          |
| 2        	  | 1          |
| 3        	  | 1          |

###  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
with t1 as (
select co.order_id, order_time, pickup_time,
DATEDIFF(MINUTE, order_time, pickup_time) as minute_track
from customer_orders as co left JOIN runner_orders as ro ON
co.order_id = ro.order_id
where pickup_time != 'null')

select AVG(minute_track) as average_time
from t1
```

#### Result set:
| average_time |
| ------------ |
| 18           |

###  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

-> Assume the runner always reaches the HQ before the food has been prepared, so the period from order to pickup would be the time for preparation.

```sql
select co.order_id, count(co.pizza_id) as pizza_count,
DATEDIFF(MINUTE, order_time, pickup_time) as minute_track
from customer_orders as co left JOIN runner_orders as ro ON
co.order_id = ro.order_id
where pickup_time != 'null'
group by co.order_id, DATEDIFF(MINUTE, order_time, pickup_time)
order by DATEDIFF(MINUTE, order_time, pickup_time)
```

#### Result set:
| order_id   |  pizza_count  | minute_track |
| ---------- |  ------------ | ------------ |
| 1          |  1   	     | 10           |
| 2          |  1   	     | 10           |
| 5          |  1   	     | 10           |
| 7          |  1   	     | 10           |
| 10         |  2   	     | 16           |
| 3          |  2   	     | 21           |
| 8          |  1   	     | 21           |
| 4          |  3   	     | 30           |

-> there seems to be a positive relationship between pizza count and preparation time in each order.

### 4. What was the average distance travelled for each customer?

* Removing messy values by Update function -> convert data type to FLOAT -> Manipulation

```sql
update runner_orders
set distance = case(distance as float)

update runner_orders
set duration = case(duration as float)

select customer_id, AVG(distance) as avg_distance
from customer_orders as co LEFT JOIN runner_orders as ro ON
co.order_id = ro.order_id
where distance != 0
group by customer_id
```

#### Result set:
| customer_id | avg_distance |
| ----------- | ------------ |
| 101         | 20           |
| 102         | 16,733       |
| 103         | 23,399       |
| 104         | 10           |
| 105         | 25           |

###  5. What was the difference between the longest and shortest delivery times for all orders?

```sql
select max(duration)-min(duration) as delivery_time_diff
from runner_orders
where duration != 0
```

#### Result set:
| delivery_time_diff |
|  ----------------  |
|  30                |

###  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
select runner_id, avg(distance) as avg_distance, avg(duration) as avg_duration
from runner_orders
where duration!=0
group by runner_id
```

#### Result set:
| runner_id  |  avg_distance | avg_duration |
| ---------- |  ------------ | ------------ |
| 1          |  15,85        | 22,25        |
| 2          |  23,933       | 26,66        |
| 3          |  10   	     | 15           |

###  7. What is the successful delivery percentage for each runner?

```sql
with t1 as (
select runner_id, 
case 
when pickup_time != 'null' then 1.0
else 0
end as success
from runner_orders
)
select runner_id, sum(success)/count(success)*100 as success_rate
from t1
group by runner_id
```

#### Result set:
| runner_id | success_rate |
| --------- | ------------ |
| 1         | 100          |
| 2         | 75,00        |
| 3         | 50,00        |













