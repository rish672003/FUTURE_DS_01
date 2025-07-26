--- 1. Creating the database
CREATE DATABASE superstore_sales_analysis;

-- 2. Creating the table
CREATE TABLE superstore_sales_data (
    row_id INT PRIMARY KEY,
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales FLOAT,
    quantity INT,
    profit FLOAT,
    returns TEXT,
    payment_mode TEXT
);

-- 3. Loading the data into the table
COPY superstore_sales_data
FROM 'D:\project\SuperStore_Sales_Dataset.csv'
DELIMITER ',' 
CSV HEADER;

-- 4. Data Cleaning

-- (a) Checking for missing values
SELECT COUNT(*) AS missing_values
FROM superstore_sales_data
WHERE order_date IS NULL
   OR ship_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL;

-- (b) Remove records with missing critical fields
DELETE FROM superstore_sales_data
WHERE order_date IS NULL
   OR ship_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL;

-- (c) Ensure consistent formats for string fields
UPDATE superstore_sales_data
SET country = LOWER(country),
    city = LOWER(city),
    state = LOWER(state),
    category = LOWER(category),
    sub_category = LOWER(sub_category);

-- 5. SQL Queries

-- (a) Total Sales Revenue
SELECT SUM(sales) AS total_sales_revenue
FROM superstore_sales_data;

-- (b) Total Profit
SELECT SUM(profit) AS total_profit
FROM superstore_sales_data;

-- (c) Monthly Sales Revenue
SELECT EXTRACT(YEAR FROM order_date) AS year, EXTRACT(MONTH FROM order_date) AS month, SUM(sales) AS monthly_sales
FROM superstore_sales_data
GROUP BY year, month
ORDER BY year, month;

-- (d) Top 10 Best-Selling Products
SELECT product_name, SUM(quantity) AS total_quantity_sold
FROM superstore_sales_data
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- (e) Top 5 Most Profitable Categories
SELECT category, SUM(profit) AS total_profit
FROM superstore_sales_data
GROUP BY category
ORDER BY total_profit DESC
LIMIT 5;

-- (f) Sales by Region
SELECT region, SUM(sales) AS total_sales
FROM superstore_sales_data
GROUP BY region
ORDER BY total_sales DESC;

-- (g) Customer Segment Analysis
SELECT segment, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore_sales_data
GROUP BY segment
ORDER BY total_sales DESC;

-- (h) Most Common Ship Mode
SELECT ship_mode, COUNT(*) AS count
FROM superstore_sales_data
GROUP BY ship_mode
ORDER BY count DESC;

-- (i) Monthly Profit Trend
SELECT EXTRACT(YEAR FROM order_date) AS year, EXTRACT(MONTH FROM order_date) AS month, SUM(profit) AS monthly_profit
FROM superstore_sales_data
GROUP BY year, month
ORDER BY year, month;

-- (j) Most Returned Products (if returns are tracked)
SELECT product_name, COUNT(*) AS return_count
FROM superstore_sales_data
WHERE returns IS NOT NULL
GROUP BY product_name
ORDER BY return_count DESC
LIMIT 10;

-- (k) Profit Margin by Category
SELECT category, (SUM(profit) / NULLIF(SUM(sales), 0)) * 100 AS profit_margin_percentage
FROM superstore_sales_data
GROUP BY category
ORDER BY profit_margin_percentage DESC;
