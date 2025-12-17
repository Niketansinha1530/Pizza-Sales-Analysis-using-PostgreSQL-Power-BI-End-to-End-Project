create table pizza_sales(
pizza_id int primary key,
order_id int ,
pizza_name_id varchar(20),
quantity int,
order_date date,
order_time time,
unit_price decimal(10,3),
total_price decimal(10,3),
pizza_size varchar(5),
pizza_category varchar(20),
pizza_ingredients varchar(150),
pizza_name varchar(50)
)

drop table pizza_sales

alter table pizza_sales
alter column pizza_name type varchar(50)

alter table pizza_sales
alter column unit_price type decimal(10,2);

alter table pizza_sales
alter column total_price type decimal(10,2)

select * from pizza_sales

copy pizza_sales
from 'F:\Power_BI\Pizza Sales\pizza_sales.csv'
DELIMITER ','
CSV HEADER;


select
* 
from pizza_sales
where order_date = '2015-02-15'

select
pizza_size,
count(*)
from pizza_sales
group by pizza_size
order by count(*)


select * from pizza_sales

select
count(distinct(pizza_id))
from pizza_sales


select 
pizza_name_id,
count(*)
from pizza_sales
group by pizza_name_id
order by count(*)


select * from pizza_sales
select
sum(unit_price * total_price) as total_sales
from pizza_sales


select 
sum(quantity)
from pizza_sales


select
count(order_id)
from pizza_sales


select 
pizza_category,
count(*)
from pizza_sales
group by pizza_category
order by count(*)

select
distinct(pizza_size)
from pizza_sales


select
pizza_size,
case pizza_size
when 'S' then 'Small'
when 'M' then 'Medium'
when 'L' then 'Large'
when 'XL' then 'Extra Large'
else 'Extra Extra Large'
end Size_Category
from pizza_sales

with temp_cte as(
select
pizza_category,
count(*) as Total_Count
from pizza_sales
group by pizza_category)
select 
pizza_category,
Total_count,
round((Total_count*100/sum(Total_Count) over()),2) as percentage_contribution
from temp_cte


select * from pizza_sales
where quantity = 2


-- 1. Total Revenue : The sum of the total price of all pizza orders
-- 2. Average order value: The Average amount spent per order, calculated by dividing the total revenue by the total number 
-- or orders. 
-- 3. Total pizzas Sold: The sum of the quantities of all pizza sold.
-- 4. Total orders : the total number of orders placed
-- 5. Average pizzas per orders: the AVerage number of pizzas sold per order, calculated by dividing the total number of pizzas sold by 
-- the number of orders

1. 
select
sum(total_price) as Total_Revenue
from pizza_sales

2.
select 
round(sum(total_price)/count(distinct(order_id)),2) Avg_order_value
from pizza_sales

3. 
select 
sum(quantity)
from pizza_sales

4. 
select 
count(distinct(order_id))
from pizza_sales

5.
select
round(sum(quantity) :: decimal(10,2)/count(distinct(order_id)) :: decimal(10,2),2) as Avg_pizza_per_order
from pizza_sales

Chart Requirement
1. Daily Trend for Total Orders.

select 
to_char(order_date,'dy'),
count(distinct(order_id)) as Total_Count
from pizza_sales
group by to_char(order_date,'dy')
order by count(distinct(order_id))

2. Monthly Trend for Total Orders.

select 
to_char(order_date,'mon'),
count(distinct(order_id)) as Total_Count
from pizza_sales
group by to_char(order_date,'mon'),to_char(order_date,'mm')
order by to_char(order_date,'mm')

2. Hourly Trend for Total Orders.

select
date_trunc('h',order_time),
count(distinct(order_id))
from pizza_sales
group by date_trunc('h',order_time)
order by date_trunc('h',order_time)

3. Percentage of sales by pizza category.

with temp_cte as(
select pizza_category,
sum(total_price) as total_revenue 
from pizza_sales
group by pizza_category)
select
pizza_category,
total_revenue,
concat(round((total_revenue * 100 /sum(total_revenue) over()),2) , '%')as Percentage_by_category
from temp_cte

4. Percentange of sales by pizza size

with temp_cte as (
select
pizza_size,
sum(total_price) as Total_revenue
from pizza_sales
group by pizza_size ) 
select
pizza_size,
concat(round((total_revenue*100 / sum(total_revenue) over()),2),'%') as Percentage_Revenue
from temp_cte
order by Percentage_Revenue desc

5. Total Pizza sold by pizza category
select
pizza_category,
sum(quantity)
from pizza_sales
group by pizza_category

6. Top 5 Best sellers by Revenue , total quantity and total orders

select 
pizza_name,
sum(total_price) Total_sales,
sum(quantity) Total_Quantity,
count(distinct(order_id)) order_id_count
from pizza_sales
group by pizza_name
order by sum(total_price) desc
limit 5

7. Botton 5 best sellers by revenue total quantity and total orders

select 
pizza_name,
sum(total_price) Total_sales,
sum(quantity) Total_Quantity,
count(distinct(order_id)) order_id_count
from pizza_sales
group by pizza_name
order by sum(total_price) asc
limit 5
