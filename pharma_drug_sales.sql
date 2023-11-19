 -- BASIC QUERIES

 -- Show the first 10 items in the table:
 select top 10 * from [dbo].[pharma sql]

--Get the total number of items in the table:
select count(*) as total_items from [dbo].[pharma sql]

-- Get the number of each distributor
select Distributor, count(*) as total_num from [dbo].[pharma sql]
group by Distributor
order by total_num desc

-- Get the total sales of each channel
select Channel, format(sum(Sales), 'N', 'en-us') as total_sales from [dbo].[pharma sql]
group by Channel

--  How many different product class every single product has?
select Product_Name, count(Product_Class) as number_of_different_product_class from [dbo].[pharma sql]
group by Product_Name


-- Get the number of each product
select Product_Class, count(Product_Name) total_products from [dbo].[pharma sql]
group by Product_Class
order by total_products desc


 -- SALES FOCUSED QUERIES

 -- Get top 10 customers that sell the most

 select top 10 Customer_Name, MAX(Sales) as max_sales
 from [dbo].[pharma sql]
 group by Customer_Name
 order by max_sales desc

  -- Get top 10 customers that sell the most on average
  select top 10 Customer_Name, AVG(Sales) as avg_sales
 from [dbo].[pharma sql]
 group by Customer_Name
 order by avg_sales desc


 -- Get the Product_Class that is sold the most.

 select top 1 Product_Class from [dbo].[pharma sql]
 group by Product_Class
 order by count(Product_Class) desc


  -- Get the Product_Class that is sold the most to each Channel and Sub_Channel

 select distinct Channel,  Sub_Channel, Product_Class 
 from [dbo].[pharma sql]
 where Product_Class =
(select top 1 Product_Class from [dbo].[pharma sql]
 group by Product_Class
 order by count(Product_Class) desc)
 order by Channel


 -- Get the distributers that trade with top 10 most sellers
 

 with cte_seller as
  (select top 10 Customer_Name,Distributor, MAX(Sales) as max_sales
 from [dbo].[pharma sql]
 group by Customer_Name, Distributor
 order by max_sales desc) 

 select  distinct Distributor, count(Customer_Name) 
 as top_sellers from cte_seller
 group by Distributor
 order by top_sellers desc



 -- Get yearly and monthly average and total sales.

  select    Year, Month, Avg(Sales) as avg_sales, sum(Sales) as total_sales
 from [dbo].[pharma sql]
 group by Year, Month
 order by Year desc
 
 
 -- get the growth & shrink of sales teams

 with cte as(
 select Sales_Team, Year as current_year, sum(Sales) as sales
 from [dbo].[pharma sql] 
 group by Sales_Team, Year)

 select c1.*, c1.sales - c2.sales as yearly_growth
 from cte c1
 left join cte c2 on c1.Sales_Team = c2.Sales_Team AND c2.current_year = c1.current_year -1
 order by current_year desc



