-- Create Table 
create table Retail_sales(transactions_id INT PRIMARY KEY,
                          sale_date	DATE,
						  sale_time	TIME,
						  customer_id INT,	
						  gender VARCHAR(15),	
						  age INT,	
						  category	VARCHAR(20),
						  quantiy INT,	
						  price_per_unit FLOAT,	
						  cogs	FLOAT,
						  total_sale FLOAT      
						  );
select*from Retail_sales;

select count(*) from Retail_sales;

-- Data cleaning
select*from Retail_sales where transactions_id is null
                             or sale_date is null
							 or sale_time is null
							 or customer_id is null
							 or gender is null
							 or age is null
							 or category is null
							 or quantiy is null
							 or price_per_unit is null
							 or cogs is null
							 or total_sale is null;
							 
							 
delete from Retail_sales where transactions_id is null
                             or sale_date is null
							 or sale_time is null
							 or customer_id is null
							 or gender is null
							 or age is null
							 or category is null
							 or quantiy is null
							 or price_per_unit is null
							 or cogs is null
							 or total_sale is null;
							 
-- Data Exploration
select count(*) as total_sale from Retail_sales;
select  count(distinct customer_id) as Total_customers from Retail_sales;
select distinct category from Retail_sales;

-- Data Analysis and Business key Problems

--1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
select *from Retail_sales where sale_date ='2022-11-05';

--2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
select *from Retail_sales where category='Clothing'	and to_char(sale_date,'yyyy-mm')='2022-11'	and quantiy>=4;	

--3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
select category,
       sum(total_sale) as net_sale,
	   count(*) as total_orders
	   from Retail_sales
	   group by 1;

--4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select round(avg(age),2) from Retail_sales where category='Beauty';

--5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select*from Retail_sales where total_sale>1000;

--6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select category,
       gender,
	   count(*) as Total_trans
	   from Retail_sales 
	   group by category,
	            gender
				order by 1;

--7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
select
      year,month,avg_sale from
(
select
      extract(year from sale_date) as Year,
	  extract(month from sale_date)as Month,
	  avg(total_sale) as Avg_sale,
	  rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc) 
	  from Retail_sales 
	  group by 1,2
	  ) as t1 where rank=1

--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id, 
       sum(total_sale) as Total_sales
	   from Retail_sales
	   group by 1
	   order by 2 desc
	   limit 5

--9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
select category,
       count(distinct customer_id ) as Distinct_customer
	   from Retail_sales
	   group by 1;

--*Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
with  Hourly_sales as
(select*, 
         case
		      when extract(hour from sale_time)<12 then 'Morning'
			  when extract(hour from sale_time)between 12 and 17 then 'Afternoon'
			  else 'Evening'
			  end as shift
		from Retail_sales)
		select shift,count(*) as total_orders from Hourly_sales
		group by shift;

-- End of project
			  