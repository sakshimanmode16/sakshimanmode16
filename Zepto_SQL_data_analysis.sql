drop tableif exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- product name present multiple times 
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count (sku_id) DESC;

-- data cleaning

--product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--some business questions

--Q1. Find the top 10 best value products based on the discount percentage.
ans-
select distinct name, mrp, discountpercent
from zepto
order by discountpercent desc
limit 10;


--Q2. What are the products with high MRP but out of stocks
ans-
select distinct name, mrp
from zepto where 
outofstock = true and mrp > 300
order by mrp desc;


--Q3.Calculate estimates revenue for each category
ans-
select category,
sum(discountedsellingprice * availablequantity) as total_revenue
from zepto 
group by category
order by total_revenue;


--Q4. Find all products where MRP is greater than 500 and discount is less than 10%
ans-
select distinct name, mrp, discountpercent
from zepto
where mrp> 500 and discountpercent < 10 
order by mrp desc, discountpercent desc;


--Q5. Identify the top 5 categories offering the highest average discount percetage
ans- 
select category, 
round (avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;


--Q6. Find the price per gram for the products above 100g and sort by the best value
ans-
select distinct name, weightingms, discountedsellingprice, 
round(discountedsellingprice/weightingms,2) as price_per_gram
from zepto
where weightingms >= 100
order by price_per_gram;


--Q7. Group the product into categories like Low, Medium, Bulk
ans-
select distinct name, weightingms,
case when weightingms < 1000 then 'low'
     when weightingms < 5000 then 'medium'
	 else 'bulk'
	 end as weight_category
from zepto;


--Q8. What is the total inventory weight per Category
ans-
select category, 
sum(weightingms * availablequantity) as total_weight
from zepto
group by category
order by total_weight;
