-- Creating Database
CREATE DATABASE zepto;

-- Using zepto database
use zepto;

-- Creating Zepto Table
-- importing CSV data into zepto Table with help of table data import wizard
CREATE TABLE zepto(
Category TEXT NOT NULL,
name TEXT NOT NULL,
mrp INT NOT NULL,
discountPercent INT NOT NULL,
availableQuantity INT NOT NULL,
discountedSellingPrice INT NOT NULL,
weightInGms INT NOT NULL,
outOfStock TEXT NOT NULL,
quantity INT NOT NULL
);


-- Checking the data
SELECT * FROM zepto;



-- Show the first 10 rows of the zepto_v2 table.
SELECT * FROM zepto
limit 10;



-- Display all unique Product Category names from the dataset.
SELECT DISTINCT Category as Category_Name from zepto;



-- Display all columns and records from the table.
SELECT * FROM zepto;


-- Find the total number of products available in the dataset.
SELECT SUM(availableQuantity) as Total_Number_Of_Products
from zepto;



-- Retrieve all products that are currently out of stock.
SELECT Category, name 
from zepto
where outOfStock = 'True';



-- List all products having a discount percentage greater than 10

SELECT Category, name, mrp, discountPercent
from zepto
where discountPercent > 10;



-- Find the average MRP of products in each category.

SELECT Category, ROUND(AVG(mrp),2) as Average_MRP
from zepto
GROUP BY Category
ORDER BY Average_MRP DESC;



-- Show the top 5 most expensive products based on MRP.

SELECT * FROM (
    SELECT Category, name, mrp, 
    DENSE_RANK() OVER(ORDER BY mrp DESC) AS TOP_5
    FROM zepto
) ranked_products
WHERE TOP_5 <= 5;




-- Calculate the total available quantity of products per category.

SELECT Category, SUM(availableQuantity) AS Total_Quantity
FROM zepto
GROUP BY Category
ORDER BY Total_Quantity DESC;


-- Find the average discount percentage for each category.

SELECT Category, ROUND(AVG(discountPercent),2) AS Avg_Pecentage
FROM zepto
GROUP BY Category;



-- Identify products where the discounted selling price is less than 80% of the MRP.

SELECT name, Category, mrp, discountedSellingPrice
FROM zepto
WHERE discountedSellingPrice < (0.8 *mrp);




-- Find the category with the highest total sales value (discountedSellingPrice × availableQuantity).
WITH TOTAL_SALES AS(
SELECT Category, SUM(discountedSellingPrice * availableQuantity) AS TOTAL_SALES
FROM zepto
GROUP BY Category
),
ranked_category AS (
SELECT Category, TOTAL_SALES,
DENSE_RANK() OVER(ORDER BY TOTAL_SALES DESC) AS HIGHEST_TOTAL_SALES
FROM TOTAL_SALES
) SELECT * FROM ranked_category
WHERE HIGHEST_TOTAL_SALES = 1;





-- Determine which category has the highest average discount percentage.

SELECT *
FROM (
    SELECT 
        Category,
        AVG(discountPercent) AS Average_Discount,
        RANK() OVER (ORDER BY AVG(discountPercent) DESC) AS Discount_Rank
    FROM zepto
    GROUP BY Category
) AS ranked_categories
WHERE Discount_Rank = 1;



-- Find the average price per gram for each product and sort them by the lowest first.

SELECT Category,name, mrp, weightInGms, (mrp / weightInGms) AS Price_Per_Grams
FROM zepto
WHERE weightInGms > 0
ORDER BY Price_Per_Grams ASC;




-- Calculate the category-wise stock availability ratio (products in stock ÷ total products).
SELECT 
    Category,
    ROUND(
        SUM(CASE WHEN outOfStock = FALSE THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS stock_availability_ratio
FROM zepto
GROUP BY Category
ORDER BY stock_availability_ratio DESC;


-- List the top 3 categories contributing the most to total discounted sales.

WITH ranked_sales AS (
    SELECT 
        Category,
        SUM(discountedSellingPrice * availableQuantity) AS total_discounted_sales,
        DENSE_RANK() OVER (ORDER BY SUM(discountedSellingPrice * availableQuantity) DESC) AS sales_rank
    FROM zepto
    GROUP BY Category
)
SELECT *
FROM ranked_sales
WHERE sales_rank <= 3;






