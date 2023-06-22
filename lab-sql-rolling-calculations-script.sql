	-- 1.
with rental_2 as (
	select customer_id,
	date_format(rental_date, '%m') as rental_month,
	date_format(rental_date, '%Y') as rental_year
    from rental
)
select count(distinct customer_id) active_users, rental_month, rental_year from rental_2
group by rental_year, rental_month;

	-- 2.
with rental_2 as (
	select customer_id,
	date_format(rental_date, '%m') as rental_month,
	date_format(rental_date, '%Y') as rental_year
    from rental
),
active_users as (
	select count(distinct customer_id) active_users, rental_month, rental_year
    from rental_2
	group by rental_year, rental_month
)
select *, lag(active_users) over () as previous_month_users from active_users;

	-- 3.
with rental_2 as (
	select customer_id,
	date_format(rental_date, '%m') as rental_month,
	date_format(rental_date, '%Y') as rental_year
    from rental
),
count_active_users as (
	select count(distinct customer_id) active_users, rental_month, rental_year
    from rental_2
	group by rental_year, rental_month
),
count_current_previous as (
	select *, lag(active_users) over () as previous_month_users
	from count_active_users
)
select *, (active_users - previous_month_users) as difference,
concat(round((active_users - previous_month_users)/active_users*100), "%") as percent_difference
from count_current_previous;

	-- 4.
with rental_2 as (
	select customer_id,
	date_format(rental_date, '%m') as rental_month,
	date_format(rental_date, '%Y') as rental_year
    from rental
    order by customer_id
),
active_users as (
	select distinct customer_id, rental_month, rental_year
    from rental_2
    order by customer_id
),
current_previous as (
	select *, lag(customer_id) over () as previous_month
	from active_users
)
select customer_id, rental_month, rental_year from current_previous cp1
where customer_id = previous_month
order by rental_year, rental_month, customer_id;