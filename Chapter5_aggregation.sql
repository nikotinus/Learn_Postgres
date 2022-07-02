select 
	min(pp.price) min_price
	, max(pp.price) max_price
	, count(*) count_rows
from product_price pp
where pp.price < 0;

-- 5_13
select 
	product_id 
	, min(pp.price) price_min
	, max(pp.price) price_max
from product_price pp
group by pp.product_id 
order by 1;

-- 6_13
select 
	p.name as name
	, min(pp.price) as price_min
	, MAX(PP.PRICE) as price_max	
from product_price pp
join product p 
on p.product_id = pp.product_id 
group by p.name 
order by 1

--7_13
select 
	p.category_id 
	, p.name
	, min(pp.price) as price_min
	, max(pp.price) as price_max
from product as p
join product_price as pp 
on pp.product_id = p.product_id
where p.category_id=6 or p.category_id=7
group by 1, 2;

--8_13
select 
	pp.store_id 
	, p.category_id 
	, min(pp.price) as price_min
	, max(pp.price) as price_max
from product_price as pp
join product as p
on p.product_id = pp.product_id 
group by 1,2
order by 1,2;

--9/13
/*
Посчитай статистику по руководителям (employee.manager_id) в магазинах. 
Выведи следующие данные:

store_name - название магазина;
manager_full_name - имя и фамилия руководителя, разделенные пробелом;
amount_employees - количество человек в подчинении.
Если в магазине есть сотрудники, у которых нет руководителя (manager_id is null), 
в результате должна быть строка, в которой manager_full_name принимает 
значение NULL, а amount_employees равно количеству сотрудников 
без руководителя в магазине.

Отсортируй результат по названию магазина, затем по manager_full_name. 
*/
select
	s."name" as store_name
	, m.first_name || ' '|| m.last_name as manager_full_name
	, count(e.*) asamount_employees
from employee as e 
join store as s
on s.store_id = e.store_id
left join employee as m
on m.employee_id = e.manager_id 
group by 1,2
order by 1,2;

select e.first_name & e.last_name from employee e 

--10/13
