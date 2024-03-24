create table if not exists sale(
	invoice_id varchar(30) not null primary key,
	branch varchar(30) not null,
	city varchar(30) not null,
	customer_type varchar(30),
	gender varchar(30),
	product_line varchar(30),
	unit_price decimal(10,2) not null,
	quantity int not null,
	VAT FLOAT not null,
	total decimal(10,2),
	data DATE not null,
	time TIME not null,
	payment_method varchar(30) not null,
	cogs decimal(10,2),
	gross_margin_pct float,
	gross_income decimal(12,2),
	rating float
);

select *
from sales

--table name change

alter table sale rename to sales;





-----------Generic--------
-----How many unique cities does the data have?
select distinct city
from sales

---What is the most common payment method?

select payment_method,count(payment_method)
from sales
group by payment_method
order by count(payment_method)desc

--What is the most selling product line?

select product_line,count(product_line)
from sales
group by product_line
order by count(product_line)desc

------------------------feature engineering----------------------
--- time_of_day-----
SELECT time,
    CASE
        WHEN EXTRACT(HOUR FROM time) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time) BETWEEN 12 AND 15 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_date
FROM sales;

----add column in the table

alter table sales add column time_of_date varchar(15);

--update column

update sales
set time_of_date = (CASE
        WHEN EXTRACT(HOUR FROM time) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time) BETWEEN 12 AND 15 THEN 'Afternoon'
        ELSE 'Evening'
    END )

--rename data column as date
alter table sales rename column data to date ;


--day_name

SELECT date, TO_CHAR(date, 'Day') AS day_name
FROM sales;

alter table sales add column day_name varchar(15);

UPDATE sales
SET day_name = TO_CHAR(date, 'Day');

--month_name


SELECT TO_CHAR(date, 'Month') AS month_name
FROM sales;

--update column

ALTER TABLE sales add column month_name varchar(10);

--update column
UPDATE sales
SET month_name = TO_CHAR(date, 'Month');





--- What is the total revenue by month
select month_name,
	SUM(total) as total_revenue
from sales
GROUP BY month_name
order by total_revenue;

-- what month had largest cost of goods sold

SELECT 
	month_name as month,
	sum(cogs) as cogs
FROM sales
GROUP BY month
ORDER BY cogs;

-- what product line had largest revenue

SELECT
	product_line as p_line,
	sum(total) AS revenue
FROM sales
GROUP BY p_line
ORDER BY revenue DESC

-- What is the city had the largest revenue

SELECT
	city ,
	sum(total) AS ravenue
FROM sales
GROUP BY city
ORDER BY ravenue

-- What product line had the largest VAT

SELECT 
	product_line,
	sum(VAT) as vat
FROM sales
GROUP BY product_line
ORDER BY vat DESC

-- Which branch sold more products than average products sold

SELECT 
	branch,
	avg(quantity),
	sum(quantity) as qty
FROM sales
GROUP BY branch 
HAVING SUM(quantity) > (select avg(quantity) from sales)


--Sales
-- Number of sales made in each time of the day per weekday

SELECT time_of_date,
		count(*) as total_sales
FROM sales
GROUP BY time_of_date
ORDER BY total_sales DESC;

-- Which of the customer types brings the  most revenue 

SELECT customer_type,
		sum(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC

-- Which city has the largest tax percntage / VAT

SELECT city,
		AVG(vat) as total_vat
FROM sales
GROUP BY city
ORDER BY total_vat DESC


--Which cutomer type pays the most in VAT

SELECT customer_type,
		SUM(vat) as total_vat
FROM sales
GROUP BY customer_type
ORDER BY total_vat DESC

---Customer

-- How many unique  customer types does the data have

SELECT DISTINCT(customer_type)
FROM sales ;

-- Homw many unique payment method does the data have
SELECT DISTINCT(payment_method)
FROM sales;

--What customer types buy the most 

SELECT customer_type,
		count(*) as total_sales
FROM sales
GROUP BY customer_type
ORDER BY total_sales DESC

-- What is the gender of most of the customer

SELECT gender,
		count(*) as total_cunstomer
FROM sales
GROUP BY gender
ORDER BY total_cunstomer DESC;

-- What is the gender distribution per branch

SELECT gender,
		
		count(*) as total_cunstomer
FROM sales
WHERE branch = 'C'
GROUP BY gender
ORDER BY total_cunstomer DESC;

-- Which day of the week has best average ratings per branch

SELECT day_name,
		
		AVG(rating) as avg_rating
FROM sales
WHERE branch = 'B'
GROUP BY day_name
ORDER BY avg_rating DESC
		











