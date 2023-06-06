# Case Study #1: Danny's Diner

## Questions 
 
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
10. What is the total items and amount spent for each member before they became a member?
11. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
12. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
***

###  1. What is the total amount each customer spent at the restaurant?

```sql
SELECT S.customer_id, Sum(M.price) as spending
FROM sales as S 
left join menu as M 
ON S.product_id = M.product_id
group by S.customer_id
``` 
	
#### Result set:
| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |



***
###  2. How many days has each customer visited the restaurant?

```sql
select customer_id, 
count (distinct (order_date)) as Visit_day from sales
group by customer_id
``` 
	
#### Result set:
| customer_id |  Visit_day  |
| ----------- | ----------- |
| A           | 4           |
| B           | 6           |
| C           | 2           |

***
###  3. What was the first item from the menu purchased by each customer?

```sql
with t1 as(
select *, rank() over(partition by customer_id order by order_date asc) as rnumber
from sales
)
select t1.customer_id, menu.product_name
from t1
left join menu ON
t1.product_id = menu.product_id
where rnumber = 1
``` 
	
#### Result set:
| customer_id | product_name |
| ----------- | -----------  |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |
| C           | ramen        |

***
### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
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
```

#### Result set:
| product_name | unit_sold |
| -----------  | --------- |
| ramen        | 8         |

***
### 5. Which item was the most popular for each customer?

```sql
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
```

#### Result set:
| customer_id | product_name |
| ----------- | -----------  |
| A           | ramen        |
| B           | sushi        |
| B           | curry        |
| B           | ramen        |
| C           | ramen        |

***
### 6. Which item was purchased first by the customer after they became a member?

```sql
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
```

#### Result set:
| customer_id | order_date   | product_name |
| ----------- | -----------  | -----------  |
| A           | 2021-01-10   | ramen        |
| B           | 2021-01-11   | sushi        |

***
### 6. Which item was purchased first by the customer after they became a member?

```sql
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
```

#### Result set:
| customer_id | order_date   | product_name |
| ----------- | -----------  | -----------  |
| A           | 2021-01-10   | ramen        |
| B           | 2021-01-11   | sushi        |

***
### 7. Which item was purchased just before the customer became a member?

```sql
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
```

#### Result set:
| customer_id | order_date   | product_name |
| ----------- | -----------  | -----------  |
| A           | 2021-01-07   | curry        |
| B           | 2021-01-04   | sushi        |

***
### 8. What is the total items and amount spent for each member before they became a member?

```sql
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
```

#### Result set:
| customer_id | total_item   | total_price |
| ----------- | -----------  | ----------- |
| A           | 3            | 40          |
| B           | 3            | 40          |

***
### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
alter table menu add points as (
   case when product_name = 'sushi' then price*20
   else price*10
   END
)
select sales.customer_id, sum(menu.points) as cus_points
from sales join menu ON
sales.product_id = menu.product_id
group by customer_id
```

#### Result set:
| customer_id | total_item   | total_price |
| ----------- | -----------  | ----------- |
| A           | 3            | 40          |
| B           | 3            | 40          |

***
### 10. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
alter table menu add points as (
   case when product_name = 'sushi' then price*20
   else price*10
   END
)
select sales.customer_id, sum(menu.points) as cus_points
from sales join menu ON
sales.product_id = menu.product_id
group by customer_id
```

#### Result set:
| customer_id | total_item   | total_price |
| ----------- | -----------  | ----------- |
| A           | 3            | 40          |
| B           | 3            | 40          |

