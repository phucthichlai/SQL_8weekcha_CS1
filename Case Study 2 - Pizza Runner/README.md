<h1 align='center'> :runner::pizza: Case Study #2: Pizza Runner :pizza::runner: </h1><br>

<p align="center">

<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="Image" width="450" height="450">
<br>
  
## Table Of Contents
  - [Introduction](#introduction)
  - [Problem Statement](#problem-statement)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Datasets used](#dataset)
  - [Case Study Questions](#case-study-questions)
  
## Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Problem Statement
Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

## Entity Relationship Diagram
![ER diagram](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20ER%20diagram.png)

## Dataset
  - Table 1: Runners
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20table%20RUNNERS.png?raw=true" alt="Image1" width="600" height="250">
  
  - Table 2: Customer_orders
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20table%20CUSTOMER_ORDERS.png?raw=true" alt="Image2" width="750" height="666">
  
  - Table 3: Runner_orders
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20table%20RUNNER_ORDERS.png?raw=true" alt="Image3" width="750" height="500">
  
  - Table 4: Pizza_names
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20table%20PIZZA_NAMES.png?raw=true" alt="Image1" width="770" height="304">
  
  - Table 5: Pizza_recipes
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20table%20PIZZA_RECIPES.png?raw=true" alt="Image2" width="770" height="304">
  
  - Table 6: Pizza_toppings
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Images/CS2%20table%20PIZZA_TOPPINGS.png?raw=true" alt="Image3" width="750" height="1174">
  
## Case Study Questions

  ### A. Pizza Metrics [SOLUTION](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Solution%3A%20A.%20Pizza%20Metrics.md)

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

  ### B. Runner and Customer Experience [SOLUTION](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Solution%3A%20B.%20Runner%20and%20Customer%20Experience.md)

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

  ### C. Ingredient Optimisation [SOLUTION](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Solution%3A%20C.%20Ingredient%20Optimisation.md)

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

  ### D. Pricing and Ratings [SOLUTION](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Solution%3A%20D.%20Pricing%20and%20Ratings.md)

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

  ### E. Bonus Questions

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

### Click [HERE](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%202%20-%20Pizza%20Runner/Solution%3A%20A.%20Pizza%20Metrics.md) to reach my solution queries!
  
