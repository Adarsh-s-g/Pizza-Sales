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
