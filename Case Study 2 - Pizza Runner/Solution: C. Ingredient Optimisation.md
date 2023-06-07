## Questions: C.Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?

• Change topping data type -> varchar
```sql
--alter table pizza_recipes 
--alter column toppings VARCHAR(40)
```
- Change topping name data type -> varchar
```sql
--alter table pizza_toppings 
--alter column topping_name VARCHAR(15)
```
- Remove ' ' value
```sql
--update pizza_recipes 
--set toppings = REPLACE(toppings,' ','')
```

#### ---> split topping id into rows

```sql
with t1 as (
select pizza_id, [value] as topping_id from pizza_recipes
cross APPLY string_split(toppings, ',')
)
```

| pizza_id | topping_id |
| -------- | ---------- |
| 1        | 1          |
| 1        | 2          |
| 1        | 3          |
| 1        | 4          |
| 1        | 5          |
| 1        | 6          |
| 1        | 8          |
| 1        | 10         |
| 2        | 4          |
| 2        | 6          |
| 2        | 7          |
| 2        | 9          |
| 2        | 11         |
| 2        | 12         |

#### ---> join with topping name and combine again

```sql
select pizza_name, string_agg(topping_name, ',') as ingredients
from t1 left JOIN pizza_toppings ON
t1.topping_id = pizza_toppings.topping_id
left join pizza_names ON
t1.pizza_id = pizza_names.pizza_id
group by pizza_name
```

#### Result set:

| pizza_name | topping_id						      |
| ---------- | -------------------------------------------------------------- |
| Meatlovers | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami |
| Vegetarian | Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce	      |

***
### 2. What was the most commonly added extra?

#### Remove unnecessary blank space
```sql
update customer_orders
set extras = REPLACE(extras, ' ','')
```

#### Split
```sql
with t1 as (
select order_id, [value] as single_extra 
from customer_orders
CROSS APPLY string_split(extras, ',')
)
```

#### Combine 3 tables
```sql
select top 1 topping_name, count(topping_name) as total
from t1 join runner_orders ON
t1.order_id = runner_orders.order_id
join pizza_toppings ON
t1.single_extra = pizza_toppings.topping_id
where pickup_time != 'null'
group by topping_name
order by total desc
```

#### Result set:
| topping_name | total |
| ------------ | ----- |
| Bacon        | 3     |

***
### 3. What was the most common exclusion?

#### Remove unnecessary blank space
```sql
update customer_orders
set exclusions = REPLACE(exclusions, ' ','')
```

#### execute
```sql
with t1 as (
select order_id, [value] as single_exclu 
from customer_orders
CROSS APPLY string_split(exclusions, ',')
)
select topping_name, count(topping_name) as total
from t1 join runner_orders ON
t1.order_id = runner_orders.order_id
join pizza_toppings ON
t1.single_exclu = pizza_toppings.topping_id
where pickup_time != 'null'
group by topping_name
order by total desc
```

#### Result set:
| topping_name | total |
| ------------ | ----- |
| Cheese       | 3     |
| Mushrooms    | 1     |
| BBQ Sauce    | 1     |

### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
• Meat Lovers
• Meat Lovers - Exclude Beef
• Meat Lovers - Extra Bacon
• Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

#### *Confession: I gave up on generating the last option (exclude or extras more than 1), so this is only for generating the first 3 options

#### step 1. split the values into seperate rows and save the results into a temp table #ex
```sql
drop table #ex
with t1 as (
select order_id, pizza_id, [value] as single_exclusions, extras from customer_orders
outer apply string_split(exclusions,',')
)
select order_id, pizza_id, single_exclusions, [value] as single_extras
into #ex from t1
outer apply string_split(extras,',')
order by order_id
select * from #ex
```

| order_id | pizza_id | single_exclusions | extras |
| -------- | -------- | 	--------  |------- |
| 3	   |1	      |NULL	          |NULL	   |
| 3	   |2	      |NULL		  |NULL	   |
| 4	   |1	      |4		  |NULL	   |
| 4	   |1	      |4		  |NULL	   |
| 4	   |2	      |4		  |NULL	   |
| 5	   |1	      |NULL		  |1	   |
| 6	   |2	      |NULL		  |NULL	   |
| 7	   |2	      |NULL		  |1	   |
| 8	   |1	      |NULL		  |NULL	   |
| 9	   |1	      |4		  |1	   |
| 9	   |1	      |4		  |5	   |
| 10	   |1	      |NULL		  |NULL	   |
| 10	   |1	      |2		  |1	   |
| 10	   |1	      |2		  |4	   |
| 10	   |1	      |6		  |1	   |
| 10	   |1	      |6		  |4	   |

#### step 2. replace pizza name, exclusions name, and extras name with their ids, then save into #exname
```sql
drop table #exname
select order_id, pizza_name, pt1.topping_name as exclusions_name, pt2.topping_name as extras_name
into #exname 
from #ex 
left join pizza_toppings pt1 ON
#ex.single_exclusions = pt1.topping_id
left join pizza_toppings pt2 ON
#ex.single_extras = pt2.topping_id
left join pizza_names ON
#ex.pizza_id = pizza_names.pizza_id
```

#### step 3. execute
```sql
select *,
case
    when pizza_name = 'Meatlovers' and exclusions_name = 'Cheese' and extras_name = 'Bacon' then 'Meat Lovers - Exclude Cheese, Extras Bacon'
    when pizza_name = 'Meatlovers' and exclusions_name = 'Cheese' and (extras_name != 'Bacon' or extras_name is null) then 'Meat Lovers - Exclude Cheese'
    when pizza_name = 'Meatlovers' and (exclusions_name != 'Cheese' or exclusions_name is null) and extras_name = 'Bacon' then 'Meat Lovers - Extras Bacon'
    when pizza_name = 'Meatlovers' and exclusions_name is null and extras_name is null then 'Meat Lovers'
end as Details
from #exname
```

#### Result set:
![result](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/result%20cs2%20q4.png?raw=true)

#### Click [HERE]() to see the solution Part D: Pricing and Ratings
