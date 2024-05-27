create database pizza
use pizza
select *from order_details
select *from orders
select *from pizza_types
select *from pizzas
drop table orders
create table orderss(
order_id int not null primary key,
order_date date not null,
order_time time not null
);
--Basic:
--Retrieve the total number of orders placed.
select count(order_id) as total_orders
from 
order_details

--Calculate the total revenue generated from pizza sales.
select round(sum(pizzas.price*order_details.quantity),2) as total_money
from pizzas
join order_details
on pizzas.pizza_id=order_details.pizza_id

--Identify the highest-priced pizza.
select top 1 pizza_types.name,pizzas.price
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc 



--Identify the most common pizza size ordered.
select pizzas.size, count(order_details.quantity) as most_ordered
from pizzas
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by most_ordered desc

--List the top 5 most ordered pizza types along with their quantities.
select top 5  pizza_types.name , sum(order_details.quantity) as q
from pizza_types 
join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.name
order by q desc 

select pizza_types.name
from pizza_types
--Join the necessary tables to find the total quantity of each pizza category ordered.
select top 5  pizza_types.category , sum(order_details.quantity) as q
from pizza_types 
join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.category
order by q desc 

--=Determine the distribution of orders by hour of the day.
select (orders.time),sum(orders.order_id)
from orders
group by (orders.time)
order by orders.time

--Join relevant tables to find the category-wise distribution of pizzas.

select count(pizza_types.name ),pizza_types.category
from pizza_types
group by pizza_types.category

--Group the orders by date and calculate the average number of pizzas ordered per day.
select (avg(total)) as final from
(select orders.date, sum(order_details.quantity) as total
from orders
join order_details
on orders.order_id=order_details.order_id
group by orders.date) as dat;
--Determine the top 3 most ordered pizza types based on revenue.
select top 3 pizza_types.name,sum(pizzas.price*order_details.quantity)as total
from pizzas
join order_details
on order_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.name
order by total desc

--Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,sum(order_details.quantity*pizzas.price)/(select sum(order_details.quantity*pizzas.price)
from pizzas
join order_details
on order_details.pizza_id=pizzas.pizza_id )*100 as revenue
from order_details
join pizzas
on order_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.category
order by revenue desc


--Analyze the cumulative revenue generated over time.
select date, sum (revenue) over (order by date) 
from
(select orders.date, round(sum(order_details.quantity*pizzas.price),2) as revenue 
from order_details
join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.date) as t;

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category , name, rank
from
(select  category,name, rank() over (partition by category order by revenue) as rank
from
(select  pizza_types.category, pizza_types.name, round(sum(order_details.quantity*pizzas.price),2) as revenue 
from order_details
join pizzas
on order_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by  pizza_types.category, pizza_types.name) as table1)as table2
where rank<=3


