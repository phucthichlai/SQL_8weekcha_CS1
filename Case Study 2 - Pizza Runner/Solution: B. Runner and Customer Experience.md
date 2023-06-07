<h1 align="center"> :runner::pizza: Case Study #2: Pizza Runner :pizza::runner:</h1>

## B. Runner and Customer Experience

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

#### Click [HERE]() to see Solution Part C: Ingredient Optimisation
