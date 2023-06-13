<h1 align="center"> 📮:pencil2: Case Study #3: Foodie_Fi :pencil2::postbox:</h1>

## B. Data Analysis Questions

***

#### 1. How many customers has Foodie-Fi ever had?

```sql
select count(distinct (customer_id)) as cusomter_no from subscriptions
```

#### Result set:

| cusomter_no | 
| ----------- | 
| 1000        |

***

#### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value


```sql
select month(start_date) as month, year(start_date) as year, count(month(start_date)) as subscription_count from subscriptions
where plan_id = 0
group by month(start_date), year(start_date)
order by [month]
```

#### Result set:

| month   |  year  | subscription_count |
| ------- | ------ | ------------------ |
| 1       | 2020   | 88                 |
| 2       | 2020   | 68                 |
| 3       | 2020   | 94                 |
| 4       | 2020   | 81                 |
| 5       | 2020   | 88                 |
| 6       | 2020   | 79                 |
| 7       | 2020   | 89                 |
| 8       | 2020   | 88                 |
| 9       | 2020   | 87                 |
| 10      | 2020   | 79                 |
| 11      | 2020   | 75                 |
| 12      | 2020   | 84                 |

***

#### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
select start_date from subscriptions
where year(start_date) > 2020
order by start_date
```

```sql
with t1 as (
select p.plan_name, count(p.plan_name) as sub from subscriptions s join plans p on 
s.plan_id = p.plan_id
where year(start_date) > 2020
group by plan_name
)
select t1.plan_name, t1.sub
from t1 join plans p on 
t1.plan_name = p.plan_name
order by p.plan_id
```

#### Result set:

| plan_name    |  sub                 |
| ------------ | -------------------- |
| basic_monthly| 8                    |
| pro_monthly  | 60                   |
| pro_annual   | 63                   |
| churn        | 71                   |

-> In 2020, the number of churn plan was only fewer than half of pro annual or pro monthly. In 2021, however the churning rate is currently the highest number.

-> After 2020, there is nearly 0 people using trial or basic monthly plan.
***

#### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
select plan_name, count(distinct(customer_id)) as count, round(count(distinct(customer_id))/10.0,1) as share
from subscriptions s join plans p on 
s.plan_id = p.plan_id
where s.plan_id = 4
group by plan_name
```
#### Result set:

| plan_name | count  | share |
| --------- | ------ | ----- |
| churn     | 307    | 30.7  |
***

#### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
with t1 as (
select customer_id, plan_id, start_date,
LEAD(plan_id) OVER (PARTITION by customer_id order by start_date) as next_plan
from subscriptions
)
select count(plan_id) as churning_count, round(count(plan_id)/10.0, 1) as churning_pct from t1 
where plan_id = 0 and next_plan = 4
```

#### Result set:

| churning_count |  churning_pct        |
| -------------- | -------------------- |
| 92             | 9.2                  |
***

#### 6. What is the number and percentage of customer plans after their initial free trial?

```sql
--create table with next plan column
with t1 as (
select customer_id, plan_id, start_date,
LEAD(plan_id) OVER (PARTITION by customer_id order by start_date) as next_plan
from subscriptions
)

--get the number and percentage of next_plan with plan_id =0 
drop table t2

select t1.next_plan, count(next_plan) as plan_count, round(count(next_plan)/10.0, 1) as plan_pct into t2 from t1 
join plans on 
t1.next_plan = plans.plan_id
where t1.plan_id = 0
group by t1.next_plan

select plan_name,plan_count, plan_pct from t2
join plans on 
t2.next_plan = plans.plan_id
```

#### Result set:

| plan_name    | plan_count  | plan_pct |
| ------------ | ----------- | -------- |
| basic_monthly| 546         | 54.6     |
| pro_monthly  | 325         | 32.5     |
| pro_annual   | 37          | 3.7      |
| churn        | 92          | 9.2      |
***

#### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```sql
drop table t2

select *, rank() over (PARTITION by customer_id order by start_date desc) as plan_order into t2
from subscriptions
where year(start_date) = 2020
order by customer_id, start_date asc

select plan_name, count(plan_name) as cus_count, round(count(plan_name)/10.0,1) as pct from t2 join plans on 
t2.plan_id = plans.plan_id
where plan_order = 1
group by plan_name
```

#### Result set:

| plan_name    | cus_count   | pct.     |
| ------------ | ----------- | -------- |
| basic_monthly| 224         | 22.4     |
| churn        | 236         | 23.6     |
| pro_annual   | 195         | 19.5     |
| pro_monthly  | 326         | 32.6     |
| trial        | 19          | 1.9      |
***

#### 8. How many customers have upgraded to an annual plan in 2020?

```sql
select plan_id, count(plan_id) as cus_count 
from subscriptions
where year(start_date) = 2020 and plan_id = 3
group by plan_id
```

#### Result set:

| plan_id      | cus_count   |
| ------------ | ----------- |
| 3            | 195         |
***

#### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql
--create table containing the first joining date
drop TABLE first_plan_tab
select customer_id, min(start_date) as first_date into first_plan_tab
from subscriptions
group by customer_id

--join with the table with plan_id = 3 and get the datediff
select s.customer_id, s.start_date, f.first_date, DATEDIFF(DAY, f.first_date, s.start_date) as consider_time
from subscriptions s join first_plan_tab f on 
s.customer_id = f.customer_id 
where plan_id = 3
order by DATEDIFF(DAY, f.first_date, s.start_date)

--get the average value of 
with t1 as (
select s.customer_id, s.start_date, f.first_date, DATEDIFF(DAY, f.first_date, s.start_date) as consider_time
from subscriptions s join first_plan_tab f on 
s.customer_id = f.customer_id 
where plan_id = 3
)
select avg(consider_time) as average_consider_time
from t1
```

#### Result set:

| average_consider_time |
| --------------------- |
| 104                   |
***

#### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```sql
--calculate date diff column -> name as "period 1; period 2;…" for order -> group by period
with t1 as (
select s.customer_id, DATEDIFF(DAY, f.first_date, s.start_date) as exploring_time,
case
when DATEDIFF(DAY, f.first_date, s.start_date) <= 30 then 'period 1: 0-30 days'
when DATEDIFF(DAY, f.first_date, s.start_date) <= 60 and DATEDIFF(DAY, f.first_date, s.start_date) > 30 then 'period 2: 30-60 days'
when DATEDIFF(DAY, f.first_date, s.start_date) <= 90 and DATEDIFF(DAY, f.first_date, s.start_date) > 60 then 'period 3: 60-90 days'
when DATEDIFF(DAY, f.first_date, s.start_date) <= 120 and DATEDIFF(DAY, f.first_date, s.start_date) > 90 then 'period 4: 90-120 days'
when DATEDIFF(DAY, f.first_date, s.start_date) <= 150 and DATEDIFF(DAY, f.first_date, s.start_date) > 120 then 'period 5: 120-150 days'
when DATEDIFF(DAY, f.first_date, s.start_date) <= 180 and DATEDIFF(DAY, f.first_date, s.start_date) > 150 then 'period 6: 150-180 days'
else 'period 7: 180+ days'
end as periods
from subscriptions s join first_plan_tab f on 
s.customer_id = f.customer_id 
where plan_id = 3
)
select periods, count(periods) as count 
from t1 
group by periods
order by periods
```

#### Result set:

| periods               | count  |
| --------------------- | ------ |
| period 1: 0-30 days   | 49     |
| period 2: 30-60 days  | 24     |
| period 3: 60-90 days  | 34     |
| period 4: 90-120 days | 35     |
| period 5: 120-150 days| 42     |
| period 6: 150-180 days| 36     |
| period 7: 180+ days   | 38     |
***

#### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
with t1 as (
select *, 
lead(plan_id) over (partition by customer_id order by start_date asc) as next_plan 
from subscriptions
where year(start_date) = 2020
)
select * from t1
where plan_id = 2 and next_plan = 1
```

#### Result set:
-> none
