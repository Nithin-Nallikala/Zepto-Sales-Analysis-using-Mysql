use zepto_project;

Select * from zepto_v2;

/* Data Exploration */
Select count(*) from zepto_v2;

/* Adding an extra column to Convert outOfStock True/False values imported as text datatype initially to
boolean datatype as outofstock_boolean where True=1 and False=0 */
alter table zepto_v2
add column outOfStock_bool tinyint(10);

/* Converting and adding the extra column as outofstock_boolean where True=1 and False=0 */
update zepto_v2
set outOfStock_bool =
case 
 when lower(outOfStock) ='True' then 1
 when lower(outOfStock)='False' Then 0
 Else null
End;

/* Converting and adding the extra column as outofstock_boolean where True=1 and False=0 */

Select * from Zepto_v2 limit 10;

/*Checking for  Null values */
Select * from zepto_v2 where name is Null
or category is Null
or mrp is null
or discountPercent is null
or discountedSellingPrice is null
or weightInGms is null
or availableQuantity is null
or outOfStock is null
or quantity is null
or outOfStock_bool is null;

/* Different Product Categories */
select distinct category from zepto_v2
order by category asc;

/* Products in Stock v/s Products out of Stock*/
Select outOfStock,count(*) as product_count
from zepto_v2
group by outOfStock;

/* Describe Zepto */
Describe zepto_v2;

/* Product Names which are present more than once (multiple times)*/
Select name, count(*) as Number_Skus
from zepto_v2
group by name 
having count(*)>1
order by name Asc;
 
 /* Product Names and count with condom*/
 Select * from zepto_V2
 where name like '%Condom%';
 
Select count(*) from zepto_V2
 where name like '%condom%';
 
 /* Data Cleaning */
/* Checking for any Products with Price=0  which pratically cannot happen if quantity sold is more than one
and literally the product price is completely zero*/
Select * from zepto_v2
where mrp=0
or discountedSellingPrice=0;


/*Delecting From Zepto_V2*/
select * from zepto_v2
where mrp=0;


/*Converting Paise o Rupees*/
Update Zepto_V2
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

Select mrp,discountedSellingPrice from Zepto_V2;

/*Answering Business Questions and generating Insights*/
/* Q1) Find the top 10 best - value products based on the discount percentage*/
Select distinct name,mrp,discountPercent
from zepto_V2
where discountPercent>0
Group By name, mrp,discountPercent
order by discountPercent DESC, mrp DESC,name
Limit 10;
/*This query is useful for the customers to know the discounts and bargains and for the business to know the products that are being mostly sold and heavily promoted*/

/*Q2) What are the products with high MRP but out of stock, as this vould be a missed revenue opportunity */
Select distinct name, max(mrp) as max_mrp,outOfStock
from zepto_v2
where outOfStock_bool=1
Group By name, outOfStock
order by max_mrp DESC;

/*Q3)Calculate the Estimated Total Revenue for each category*/
Select category, sum(discountedSellingPrice*availableQuantity) as Total_Revenue
from zepto_V2
Group by category
order by Total_Revenue DESC;

/*Q4) Finding all the products where MRP is greater than Rs 500 and the disount is less than 10%*/
Select distinct name, mrp, discountPercent
from Zepto_V2
where mrp>500 
and discountPercent<10
order by mrp DESC, discountPercent Desc;
/*These are not premimum products and these products are already popular enough and they are sold very well and so, there is no discount*/

/*Q5)which product category (top 5 categories offering the highest average discount) gives the best avaerga disount*/
select category, round(avg(discountPercent),2) as avg_discount
from zepto_v2
Group by category
order by avg_discount DESC
limit 5;
/* Very useful for marketing and understanding where the price cuts are happening the most and how they can optmize accordingly*/

/*Q6) Find the price per gram for products above 100g and sort by best value*/
Select distinct name weightInGms,discountedSellingPrice,
Round(discountedSellingprice/weightInGms,2) as price_per_gram
from zepto_v2
where weightInGms>100
Order By Price_per_gram;
/* this is helpful for customers for comparing the value for money for products and also for internal pricing strategies*/

/*Q7) Grup the products into weight categories like low, medium, bulk based on their weight in grams*/
Select distinct name, weightInGms,
case 
 when weightInGms <1000 Then 'Low'
 when weightInGms <5000 Then 'Medium'
 Else 'Bulk'
End As weight_category
from zepto_v2;
/*This kind of segmentation is helpful for packaging and delivery planning and even in bulk order strategies*/

/*Q8) What is the total inventory Weight In Gms per category (which category contrbutes most to the total inventory weight*/
 Select category, sum(weightInGms*availableQuantity) as Total_Weight
 from Zepto_v2
 group by Category
 Order by Total_Weight;
/*This is really great for warehouse planning or identifying the bulky product categories*/