/*[Q1] What is the distribution of customers across states?*/

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM order_t;


/* [Q2] What is the average rating in each quarter?
-- Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5.*/
SELECT AVG(rating) AS overall_avg_rating FROM 
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
ORDER BY quarter_number;


-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q3] Are customers getting more dissatisfied over time?*/
SELECT quarter_number,
SUM(CASE WHEN customer_feedback = 'Very Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS very_bad_percentage,
SUM(CASE WHEN customer_feedback = 'Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS bad_percentage,
SUM(CASE WHEN customer_feedback = 'Okay' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS okay_percentage,
SUM(CASE WHEN customer_feedback = 'Good' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS good_percentage,
SUM(CASE WHEN customer_feedback = 'Very Good' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS very_good_percentage
FROM order_t 
GROUP BY quarter_number
ORDER BY quarter_number;

WITH cust_feed AS 
(
	SELECT 
		quarter_number,
		ROUND(SUM(CASE WHEN customer_feedback = 'very good' THEN 1 ELSE 0 END), 2) AS very_good,
		ROUND(SUM(CASE WHEN customer_feedback = 'good' THEN 1 ELSE 0 END), 2) AS good,
		ROUND(SUM(CASE WHEN customer_feedback = 'okay' THEN 1 ELSE 0 END), 2) AS okay,
		ROUND(SUM(CASE WHEN customer_feedback = 'bad' THEN 1 ELSE 0 END), 2) AS bad,
		ROUND(SUM(CASE WHEN customer_feedback = 'very bad' THEN 1 ELSE 0 END), 2) AS very_bad,
		ROUND(COUNT(customer_feedback), 2) AS total_feedback
	FROM order_t
	GROUP BY 1
    ORDER BY 1 ASC
)
   
  SELECT 
		quarter_number,
        ROUND((very_good/total_feedback), 2) AS very_good,
        ROUND((good/total_feedback), 2) AS good,
        ROUND((okay/total_feedback), 2) AS okay,
        ROUND((bad/total_feedback), 2) AS bad,
        ROUND((very_bad/total_feedback),2)AS very_bad
	FROM cust_feed
	GROUP BY 1
    ORDER BY 1 ASC;

 
 
/*[Q4] Which are the top 5 vehicle makers preferred by the customer.*/
SELECT vehicle_maker, COUNT(*) AS num_orders
FROM order_t
JOIN product_t ON order_t.product_id = product_t.product_id
GROUP BY vehicle_maker
ORDER BY num_orders DESC
LIMIT 5;

 

 
/*[Q5] What is the most preferred vehicle make in each state?.*/
SELECT *
FROM
(
	SELECT 
		state, 
		vehicle_maker,
		COUNT(customer_id) AS total_customers,
    RANK() OVER (PARTITION BY state ORDER BY COUNT(customer_id) DESC) AS ranking
    FROM product_t 
    JOIN order_t USING(product_id)
    JOIN customer_t USING(customer_id)
	GROUP BY 1, 2 
) AS preferred_vehicle
WHERE ranking = 1
ORDER BY 3 DESC;
 

 

/* [Q6] What is the trend of number of orders by quarters?*/
SELECT 
	quarter_number,
	COUNT(order_id) AS total_orders
FROM order_t
GROUP BY 1
ORDER BY 1;

 
/* [Q7] What is the quarter over quarter % change in revenue? 
*/
WITH QoQ AS 
(
	SELECT quarter_number, 
        ROUND(SUM(quantity * (vehicle_price - ((discount/100)*vehicle_price))), 0) AS revenue
	FROM order_t
	GROUP BY quarter_number)
SELECT quarter_number, revenue,
ROUND(LAG(revenue) OVER(ORDER BY quarter_number), 2) AS previous_revenue,
ROUND((revenue - LAG(revenue) OVER(ORDER BY quarter_number))/LAG(revenue) OVER(ORDER BY quarter_number), 2) AS qoq_perc_change
FROM QoQ;
 
/* [Q8] What is the trend of revenue and orders by quarters?*/
SELECT 
	quarter_number,
	ROUND(SUM(quantity*vehicle_price), 0) AS revenue,
    COUNT(order_id) AS total_order
FROM order_t
GROUP BY 1
ORDER BY 1;
  

/*  [Q9] What is the average discount offered for different types of credit cards?*/
SELECT 
	credit_card_type,
	ROUND(AVG(discount), 2) AS average_discount
FROM order_t t1
INNER JOIN customer_t t2
 ON t1.customer_id = t2.customer_id
GROUP BY 1
ORDER BY 2 DESC;
 
/* [Q10] What is the average time taken to ship the placed orders for each quarters?*/
SELECT 
	quarter_number,
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 0) AS average_shipping_time
FROM order_t
GROUP BY 1
ORDER BY 1;
/ 