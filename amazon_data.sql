--Load Data into PostgreSQL using pgAdmin--

#### --Step 1: Create the Table Structure
	--> In pgAdmin, open the 'Query Tool' and create a table that reflects your data’s structure

CREATE TABLE amazon_data (
    product_id VARCHAR(50),
    product_name VARCHAR(500),
    category VARCHAR(255),
    discounted_price DECIMAL(10, 2),
    actual_price DECIMAL(10, 2),
    discount_percentage VARCHAR(20),
    rating DECIMAL(3, 2),
    rating_count INT,
    about_product TEXT,
    user_id VARCHAR(255),
    user_name VARCHAR(150),
    review_id VARCHAR(255),
    review_title VARCHAR(500),
    review_content TEXT,
    img_link VARCHAR(255),
    product_link VARCHAR(255)
);

#### --Step 2: Load Data into PostgreSQL
	--> select the table name and import or export the .csv file

#### --Step 3: Check the Data
--- Run a simple query to check if the data is loaded correctly ---
SELECT * FROM amazon_data LIMIT 10;

#### --Step 4: Generate Queries in PostgreSQL
--- 1. Find the top-rated products ---
SELECT product_name, rating
FROM amazon_data
ORDER BY rating DESC
LIMIT 10;

--- 2. Find products with the highest discount percentage ---
SELECT product_name, discount_percentage
FROM amazon_data
ORDER BY discount_percentage DESC
LIMIT 10;

--- 3. Top 5 users with the most reviews ---
SELECT user_name, count(review_id) as reviews
FROM amazon_data
GROUP BY user_name
ORDER BY reviews DESC
LIMIT 5;

--- 4. Count the user_id's that may contain missing values ---
SELECT 
COUNT(*) AS Total_Rows, 
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS Missing_Values 
FROM amazon_data;

--- 5. change actual_price is null if rating is less than 1 ---
UPDATE amazon_data
SET actual_price = NULL 
WHERE rating < 1;

#### --Step 5: Data Cleaning and Transformation
--- 1. Remove Duplicates ---
SELECT *, COUNT(*) 
FROM amazon_data 
GROUP BY product_id, product_name, category, discounted_price, actual_price,
	discount_percentage, rating, rating_count, about_product, user_id, user_name,
	review_id, review_title, review_content, img_link, product_link
HAVING COUNT(*) > 1;

--- 2. Handle Missing or Incorrect Data ---
/*Fill in missing values or handle them based on analysis. 
For example, if you need to fill in missing actual_price values with an average*/
UPDATE amazon_data
SET actual_price = (SELECT round(AVG(actual_price),2) FROM amazon_data)
WHERE actual_price IS NULL;

--- 3. Add Calculated Columns ---
/*the dataset contains columns actual_price and discounted_price. You can create a new column for how much discount we got*/
ALTER TABLE amazon_data
ADD COLUMN discount Decimal(10,2)

UPDATE amazon_data
SET discount = actual_price-discounted_price
