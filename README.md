# Newwheels-Data-Analysis-Project
## 📌 Project Overview

NewWheels is a pre-owned vehicle resale company offering end-to-end services—from vehicle listing to delivery and after-sales support—through a mobile application.

In the   year 2018 , NewWheels has experienced:

1. Declining sales
2. Increasing negative customer feedback
3. Reduced customer acquisition

To address these challenges,  a quarterly business performance report covering customer behavior, revenue trends, order patterns, and operational efficiency.

This project uses SQL to analyze business data and derive actionable insights for leadership decision-making.


### 🎯 Business Objectives

- Evaluate customer satisfaction trends
- Identify top-performing vehicle brands and regions
- Analyze revenue and order trends quarterly
- Assess operational efficiency, especially shipping delays
- Provide insights to support strategic business decisions

### 🛠️ Tools & Technologies

- Database: MySQL
- Language: SQL
- Techniques Used:
- Joins
- Window functions (RANK, LAG)
- CTEs
- Aggregations
- Case statements
- Date functions

### 🗂️ Database Schema
The analysis is based on the following tables:
- customer_t – Customer demographic and payment details
- order_t – Order, feedback, discount, revenue, and shipping data
- product_t – Vehicle details (make, price, etc.)

### 🗂 Dataset Description

The dataset contains transactional, customer, product, and logistics information captured through the NewWheels mobile application. It includes details related to vehicle orders, customer profiles, shipping partners, pricing, discounts, and customer feedback, organized at an order level.

### Key entities include:

- Customers (demographics, location, payment details)
- Products (vehicle attributes and pricing)
- Orders (order dates, quantities, discounts)
- Shipping (shipper details, shipping mode, delivery timelines)
- Feedback (customer experience and satisfaction)
- Time Dimensions (quarter-wise segmentation)
  <img width="634" height="614" alt="image" src="https://github.com/user-attachments/assets/fd8758be-e1c0-4fef-af1d-17a6b10f6b66" />

### Key Business Questions Answered
#### 👥 Customer Analysis
1. Distribution of customers across states
2. Average customer rating by quarter
3. Customer dissatisfaction trends over time
4. Top 5 preferred vehicle makers
5. Most preferred vehicle maker in each state

#### 💰 Revenue & Orders
6. Quarterly trend of number of orders
7. Quarter-over-quarter (QoQ) revenue growth/decline
8. Combined trend of revenue and orders

#### 🚚 Operations & Shipping
9. Average discount by credit card type
10. Average shipping time per quarter


# Data Analysis & Findings

#### 1. What is the distribution of customers across states?

```SELECT COUNT(DISTINCT customer_id) AS total_customers FROM order_t;```

#### 2. What is the average rating in each quarter? [Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5]

```SELECT AVG(rating) AS overall_avg_rating FROM
 (SELECT CASE WHEN customer_feedback = 'Very Bad' THEN 1
WHEN customer_feedback = 'Very Bad' THEN 1
WHEN customer_feedback = 'Bad' THEN 2
WHEN customer_feedback = 'Okay' THEN 3
WHEN customer_feedback = 'Good' THEN 4
WHEN customer_feedback = 'Very Good' THEN 5
END AS rating FROM order_t ) AS ratings;
select distinct customer_feedback from order_t;

SELECT quarter_number, AVG(rating) AS avg_rating_per_quarter FROM 
(SELECT quarter_number,
CASE 
	WHEN customer_feedback = 'Very Bad' THEN 1
	WHEN customer_feedback = 'Bad' THEN 2
	WHEN customer_feedback = 'Okay' THEN 3
	WHEN customer_feedback = 'Good' THEN 4
	WHEN customer_feedback = 'Very Good' THEN 5
END AS rating FROM order_t ) AS ratings
GROUP BY quarter_number
ORDER BY quarter_number;```

