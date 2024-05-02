use cap_project;

select * from amazon;

/*To check the description of the table and match it with the data provided by the stakeholders*/
DESCRIBE amazon;

SHOW CREATE TABLE amazon; 
/*"contains the SQL code that defines the structure of the table, including the column names, data types, constraints, and any other table properties."*/

/* To check the no. of rows - 1000*/
SELECT COUNT(*) AS row_count
FROM amazon;

/* To check the columns count - 20 */
SELECT COUNT(*) AS column_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'amazon';

SET sql_safe_updates = 0; 
/*Now we can use delete/update commands even without using where clause.*/

select * from amazon;

-- First, rename the columns
ALTER TABLE amazon
RENAME COLUMN `Invoice ID` TO invoice_id,
RENAME COLUMN `Branch` TO branch,
RENAME COLUMN `City` TO city,
RENAME COLUMN `Customer type` TO customer_type,
RENAME COLUMN `Gender` TO gender,
RENAME COLUMN `Product line` TO product_line,
RENAME COLUMN `Unit price` TO unit_price,
RENAME COLUMN `Quantity` TO quantity,
RENAME COLUMN `Tax 5%` TO tax_5,
RENAME COLUMN `Total` TO total,
RENAME COLUMN `Date` TO transaction_date,
RENAME COLUMN `Time` TO transaction_time,
RENAME COLUMN `Payment` TO payment_method,
RENAME COLUMN `cogs` TO cogs,
RENAME COLUMN `gross margin percentage` TO gross_margin_percentage,
RENAME COLUMN `gross income` TO gross_income,
RENAME COLUMN `Rating` TO rating;


UPDATE amazon
SET transaction_date = DATE_FORMAT(transaction_date, '%d-%m-%y');

ALTER TABLE amazon
MODIFY COLUMN transaction_time TIME;



-- To modify the data types

ALTER TABLE amazon
MODIFY COLUMN invoice_id VARCHAR(30),
MODIFY COLUMN branch VARCHAR(5),
MODIFY COLUMN city VARCHAR(30),
MODIFY COLUMN customer_type VARCHAR(30),
MODIFY COLUMN gender VARCHAR(10),
MODIFY COLUMN product_line VARCHAR(100),
MODIFY COLUMN unit_price DECIMAL(10, 2),
MODIFY COLUMN quantity INT,
MODIFY COLUMN tax_5 DECIMAL(10, 2),
MODIFY COLUMN total DECIMAL(10, 2),
MODIFY COLUMN transaction_date DATE,
MODIFY COLUMN transaction_time TIME,
MODIFY COLUMN payment_method VARCHAR(30),
MODIFY COLUMN cogs DECIMAL(10, 2),
MODIFY COLUMN gross_margin_percentage DECIMAL(10, 2),
MODIFY COLUMN gross_income DECIMAL(10, 2),
MODIFY COLUMN rating DECIMAL(3, 1);

/*To check the null values*/

SELECT * FROM amazon
WHERE invoice_id IS NULL OR
      branch IS NULL OR
      city IS NULL OR
      customer_type IS NULL OR
      gender IS NULL OR
      product_line IS NULL OR
      unit_price IS NULL OR
      quantity IS NULL OR
      tax_5 IS NULL OR
      total IS NULL OR
      transaction_date IS NULL OR
      transaction_time IS NULL OR
      payment_method IS NULL OR
      cogs IS NULL OR
      gross_margin_percentage IS NULL OR
      gross_income IS NULL OR
      rating IS NULL;

-- There are no null values in the dataset.

/* Feature Engineering:*/

/*2.1 Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
This will help answer the question on which part of the day most sales are made.*/

ALTER TABLE amazon
ADD COLUMN timeofday VARCHAR (20);

UPDATE amazon
SET timeofday =
CASE
WHEN transaction_time BETWEEN '04:00:00' AND '11:59:59' THEN 'Morning'
WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
WHEN transaction_time BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
ELSE 'Night'
END;

/*2.2 Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
This will help answer the question on which week of the day each branch is busiest.*/

ALTER TABLE amazon
ADD COLUMN day VARCHAR (20);

UPDATE amazon
SET day = DAYNAME(transaction_date);

select * from amazon;

/*2.3 Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 
Helps determine which month of the year has the most sales and profit.*/

ALTER TABLE amazon
ADD COLUMN month_name VARCHAR (20);

UPDATE amazon
SET month_name = MONTHNAME(transaction_date);

ALTER TABLE amazon
RENAME COLUMN `timeofday` TO time_of_day,
RENAME COLUMN `day` TO transaction_day,
RENAME COLUMN `month_name` TO transaction_month;








