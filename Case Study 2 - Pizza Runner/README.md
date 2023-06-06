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
![ER diagram](https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%201%20-%20Danny's%20Diner/CS1%20ER%20diagram.png?raw=true)

## Dataset
  - Table 1: Sales
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%201%20-%20Danny's%20Diner/CS1%20table%20SALES.png?raw=true" alt="Image1" width="450" height="700">
  
  - Table 2: Menu
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%201%20-%20Danny's%20Diner/CS1%20table%20MENU.png?raw=true" alt="Image2" width="468" height="214">
  
  - Table 3: Members
  <img src="https://github.com/phucthichlai/SQL_8weekchallenge/blob/main/Case%20Study%201%20-%20Danny's%20Diner/CS1%20table%20MEMBERS.png?raw=true" alt="Image3" width="468" height="180">
  
## Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Bonus Questions
1. Join all the things: Recreate the following table
<img width="682" alt="bonus table 1" src="https://github.com/phucthichlai/SQL_8weekchallenge/assets/104643138/9ddede6e-667d-4fca-a251-b62ca95df973">
