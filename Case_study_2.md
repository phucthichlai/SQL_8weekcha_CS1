# SQL_8weekchallenge
 The 8 Week SQL Challenge is created by the Data With Danny virtual data apprenticeship program! A huge thanks to Danny!

**Case Study #2 - Pizza Runner**

**Introduction**

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

**Available Data**

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

<img width="696" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 39 42" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/93968eeb-dc50-481f-8854-2dbfd928a920">

**Table 1: runners** <br>
<img width="353" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 40 10" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/e7bdef5b-40f5-4c1c-9a1d-af296318b6c2">


**Table 2: customer_orders** <br>
<img width="739" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 40 40" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/15bc324c-43fe-4e4c-8672-9ea7eb15401b">


**Table 3: runner_orders**<br>
<img width="739" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 41 09" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/a4ecbc6f-187e-4556-96af-bc85c14fca76">


**Table 4: pizza_names**<br>
<img width="376" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 41 34" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/7de3efe0-7b33-4162-a846-f01539867aca">


**Table 5: pizza_recipes**<br>
<img width="376" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 41 49" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/ed29e792-3696-4b65-9a8d-984a70e970b4">


**Table 6: pizza_toppings**<br>
<img width="376" alt="Ảnh chụp Màn hình 2023-06-05 lúc 16 42 07" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/16f11d96-cff0-456d-93f1-e39ca4075ad7">

# Case Study Questions

**A. Pizza Metrics**

How many pizzas were ordered?<br>
How many unique customer orders were made?<br>
How many successful orders were delivered by each runner?<br>
How many of each type of pizza was delivered?<br>
How many Vegetarian and Meatlovers were ordered by each customer?<br>
What was the maximum number of pizzas delivered in a single order?<br>
For each customer, how many delivered pizzas had at least 1 change and how many had no changes?<br>
How many pizzas were delivered that had both exclusions and extras?<br>
What was the total volume of pizzas ordered for each hour of the day?<br>
What was the volume of orders for each day of the week?<br>

**B. Runner and Customer Experience**

How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)<br>
What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?<br>
Is there any relationship between the number of pizzas and how long the order takes to prepare?<br>
What was the average distance travelled for each customer?<br>
What was the difference between the longest and shortest delivery times for all orders?<br>
What was the average speed for each runner for each delivery and do you notice any trend for these values?<br>
What is the successful delivery percentage for each runner?<br>

**C. Ingredient Optimisation**

What are the standard ingredients for each pizza?<br>
What was the most commonly added extra?<br>
What was the most common exclusion?<br>
Generate an order item for each record in the customers_orders table in the format of one of the following:<br>
Meat Lovers<br>
Meat Lovers - Exclude Beef<br>
Meat Lovers - Extra Bacon<br>
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers<br>
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients<br>
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"<br>
What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?<br>

**D. Pricing and Ratings**

If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?<br>
What if there was an additional $1 charge for any pizza extras?<br>
Add cheese is $1 extra<br>
The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.<br>
Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?<br>
customer_id<br>
order_id<br>
runner_id<br>
rating<br>
order_time<br>
pickup_time<br>
Time between order and pickup<br>
Delivery duration<br>
Average speed<br>
Total number of pizzas<br>
If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?<br>

**E. Bonus Questions**

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
