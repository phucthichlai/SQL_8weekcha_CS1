<h1 align="center"> :runner::pizza: Case Study #2: Pizza Runner :pizza::runner:</h1>

## A. Pizza Metrics

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

#### Click [HERE](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Solution%3A%20B.%20Runner%20and%20Customer%20Experience.md) to see Solution Part B: Runners and Customers



