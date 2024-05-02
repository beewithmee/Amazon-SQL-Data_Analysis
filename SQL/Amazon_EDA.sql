USE cap_project;

SELECT * FROM amazon;


/*3. Exploratory Data Analysis (EDA)*/

/*Q1. What is the count of distinct cities in the dataset? ANS:- Yangon, Naypyitaw, Mandalay */

SELECT DISTINCT(city) FROM amazon;

/*Q2. For each branch, what is the corresponding city?  ANS:- A-Yangon, B-Mandalay, C-Naypyitaw*/

SELECT branch, city FROM amazon
GROUP BY 1,2
ORDER BY 1;

/*Q3. What is the count of distinct product lines in the dataset? 
ANS:- 6 (Health & Beauty, Electronic accessories, Home and Lifestyle, Sports and Travel, Food and Beverages, Fashion Accessories)*/ 

SELECT COUNT(DISTINCT(product_line)) AS distinct_product_line
FROM amazon;

/*Q4. Which payment method occurs most frequently? 
ANS:- Ewallet-345, Cash-344, Credit card- 311*/

SELECT payment_method, count(payment_method) AS payment_frequency FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q5. Which product line has the highest sales? 
AMS:- Food & Beverages-56144.96, Sports & Travel- 55123, Electronic & Accessories-54337.64, Fashion Accessories-54306.03, 
Home & Lifestyle-53861.96, Health & Beauty-49193.84*/

SELECT product_line, sum(total) as total_sales
FROM amazon
Group BY 1
Order BY 2 DESC;

/*Q6. How much revenue is generated each month? 
ANS:- 'January'- '116292.11','February'- '97219.58', 'March'- '109455.74'
*/

SELECT transaction_month, sum(total) as revenue_generated
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q7. In which month did the cost of goods sold reach its peak? 
ANS:- 'January'- '110754.16', 'March'- '104243.34', 'February'- '92589.88'
*/

SELECT transaction_month, sum(cogs) as total_cogs FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q8. Which product line generated the highest revenue? 
ANS:- 'Food and beverages'- '56144.96', 'Sports and travel'- '55123.00', 'Electronic accessories'- '54337.64', 'Fashion accessories'- '54306.03', 'Home and lifestyle'- '53861.96',
'Health and beauty'- '49193.84', 
*/

SELECT product_line, sum(total) AS total_revenue
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q9. In which city was the highest revenue recorded? 
ANS:- 'Naypyitaw'- '110568.86', 'Yangon'- '106200.57', 'Mandalay'- '106198.00'
*/

SELECT city, sum(total) AS total_revenue
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q10. Which product line incurred the highest Value Added Tax? */

SELECT product_line, sum(tax_5) as total_VAT
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad." 

# product_line	total_sales	avg_sales	sales_classification
Food and beverages	56144.96	53827.905000	Good
'Sports and travel', '55123.00', '53827.905000', 'Good'
Electronic accessories, 54337.64, 53827.905000, Good
Fashion accessories, 54306.03, 53827.905000, Good
Home and lifestyle, 53861.96, 53827.905000, Good
'Health and beauty', '49193.84', '53827.905000', 'Bad'

*/

WITH sales_summary AS (SELECT product_line, SUM(total) AS total_sales, AVG(SUM(total)) OVER() AS avg_sales FROM amazon GROUP BY 1)

SELECT *, 
CASE
WHEN total_sales > avg_sales THEN "Good"
ELSE "Bad"
END AS sales_classification
FROM sales_summary
ORDER BY total_sales DESC;

/*Q12. Identify the branch that exceeded the average number of products sold. 

# branch, city, total_quantity, avg_quantity, branch_classification
A, Yangon, 1859, 1836.6667, Exceeded
C, Naypyitaw, 1831, 1836.6667, Not_Exceeded
B, Mandalay, 1820, 1836.6667, Not_Exceeded
*/

WITH branch_summary AS (
SELECT branch, city, SUM(quantity) as total_quantity, AVG(SUM(quantity)) OVER() AS avg_quantity
FROM amazon 
GROUP BY 1,2)

SELECT *, 
CASE WHEN total_quantity > avg_quantity THEN "Exceeded"
ELSE "Not_Exceeded"
END AS branch_classification
FROM branch_summary
ORDER BY total_quantity DESC;

/*Q13. Which product line is most frequently associated with each gender? 
ANS:- # product_line, gender, frequency
Fashion accessories, Female, 96
Health and beauty, Male, 88
*/

WITH gender_product_frequency AS (
SELECT product_line, gender, COUNT(*) AS frequency, ROW_NUMBER()OVER(PARTITION BY gender ORDER BY COUNT(*) DESC) AS rating 
FROM amazon 
GROUP BY 1,2)

SELECT product_line, gender, frequency FROM gender_product_frequency
WHERE rating=1;

/*Q14. Calculate the average rating for each product line. 
# product_line, avg_rating
Food and beverages, 7.11322
Fashion accessories, 7.02921
Health and beauty, 7.00329
Electronic accessories, 6.92471
Sports and travel, 6.91627
Home and lifestyle, 6.83750
*/

SELECT product_line, AVG(rating) AS avg_rating
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*Q15. Count the sales occurrences for each time of day on every weekday. */

SELECT transaction_day, time_of_day, count(*) AS sales_occurences FROM amazon
WHERE transaction_day != "Sunday" AND transaction_day != "Saturday"
GROUP BY 1,2
ORDER BY 
CASE 
WHEN transaction_day = "Monday" THEN 1
WHEN transaction_day = "Tuesday" THEN 2
WHEN transaction_day = "Wednesday" THEN 3
WHEN transaction_day = "Thursday" THEN 4
When transaction_day = "Friday" THEN 5
ELSE 6
END,
CASE
WHEN time_of_day = "Morning" THEN 1
WHEN time_of_day = "Afternoon" THEN 2
ELSE 3
END;

/*Q16. Identify the customer type contributing the highest revenue. 
# customer_type, total_revenue
Member, 164223.81
Normal, 158743.62
*/

SELECT customer_type, SUM(total) AS total_revenue
FROM amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*17. Determine the city with the highest VAT percentage. 
# city, total_vat, total_sales, vat_sales_percentage
Mandalay, 5057.36, 106198.00, 4.762199
Yangon, 5057.36, 106200.57, 4.762084
Naypyitaw, 5265.33, 110568.86, 4.762037
*/

SELECT city, SUM(tax_5) AS total_vat, SUM(total) AS total_sales, ((SUM(tax_5)/SUM(total))*100) AS vat_sales_percentage
FROM amazon
GROUP BY 1
ORDER BY 4 DESC
LIMIT 1;

/*18. Identify the customer type with the highest VAT payments. 
# customer_type, Vat_Payments
Member, 7820.53
Normal, 7559.52
*/

SELECT customer_type, SUM(tax_5) as Vat_Payments
FROM amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*19. What is the count of distinct customer types in the dataset? 
ANS:- 2*/

SELECT COUNT(DISTINCT(customer_type)) as distinct_customer_count
FROM amazon;

/*20. What is the count of distinct payment methods in the dataset? 
ANS:- 3 - Ewallet, Cash, Credit Card
*/

SELECT COUNT(DISTINCT(payment_method)) as distinct_payment_method
FROM amazon;

/*21. Which customer type occurs most frequently? 

# customer_type, frequency
Member, 501
Normal, 499
*/

SELECT customer_type, COUNT(*) as frequency
FROM amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*22. Identify the customer type with the highest purchase frequency. */

SELECT customer_type, COUNT(*) as frequency
FROM amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*23. Determine the predominant gender among customers. */

SELECT gender, COUNT(*) AS gender_frequency
FROM amazon
GROUP BY 1
ORDER BY 2 DESC;

/*24. Examine the distribution of genders within each branch. */

SELECT gender, branch, COUNT(*) AS branch_gender_frequency
FROM amazon
GROUP BY 1,2
ORDER BY 2,1;

/*25. Identify the time of day when customers provide the most ratings.
ANS:- # time_of_day, rating_frequency
Afternoon, 454
Evening, 355
Morning, 191
 */

SELECT time_of_day, COUNT(*) AS rating_frequency
FROM amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*26. Determine the time of day with the highest customer ratings for each branch. */

SELECT branch, time_of_day, COUNT(*) AS rating_count
FROM amazon
GROUP BY 1,2
ORDER BY 1,3 DESC;

/*27. Identify the day of the week with the highest average ratings. */

SELECT transaction_day, AVG(rating) AS avg_rating FROM amazon
GROUP BY 1
ORDER By 2 DESC
LIMIT 1;

/*28. Determine the day of the week with the highest average ratings for each branch. */

SELECT transaction_day, branch, AVG(rating) AS avg_rating
FROM amazon
GROUP BY 1,2
ORDER BY 2,3 DESC;



