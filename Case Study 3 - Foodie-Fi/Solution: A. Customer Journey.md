<h1 align="center"> 📮:pencil2: Case Study #3: Foodie_Fi :pencil2::postbox:</h1>

## A. Customer Journey

***
####  1. Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey. 

#### Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

```sql
with t1 as (
select s.customer_id, s.plan_id, s.start_date, p.plan_name from subscriptions as s 
join plans as p on 
s.plan_id = p.plan_id 
where customer_id <=8
)
select customer_id, string_agg(plan_name, ' -> ') as journey
from t1
group by customer_id
``` 
	
#### Result set:

| cusotmer_id |  journey                               |
| ----------- | -------------------------------------- |
| 1           | trial -> basic monthly                 |
| 2           | trial -> pro annual                    |
| 3           | trial -> basic monthly                 |
| 4           | trial -> basic monthly -> churn        |
| 5           | trial -> basic monthly                 |
| 6           | trial -> basic monthly -> churn        |
| 7           | trial -> basic monthly -> pro monthly  |
| 8           | trial -> basic monthly -> pro monthly  |


