select 
	min(pp.price) as min_price
	, max(pp.price) as max_price
	, count(*) as count_rows
from product_price as pp
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
order by 1;

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

--10/13
/*
Для каждого товара получи минимальную и максимальную стоимость из таблицы product_price. 
Выведи столбцы:

product_id - идентификатор товара;
price_min - минимальная стоимость товара;
price_max - максимальная стоимость товара.
В результате оставь только те товары, для которых минимальная и максимальная стоимость отличается.

Отсортируй результат по идентификатору товара.
 */
select
	pp.product_id 
	, min(pp.price) as price_min
	, max(pp.price) as price_max
from product_price as pp
group by pp.product_id 
having min(pp.price) != max(pp.price)
order by 1;

-- roolup 11/13
/*
Получи информацию о количестве сотрудников из таблицы employee:

в каждом магазине на каждой должности;
общее количество сотрудников в магазине;
общее количество сотрудников во всех магазинах.
В результате выведи столбцы:

store_id - идентификатор магазина;
rank_id - идентификатор должности;
count_employees - количество сотрудников.
Отсортируй результат сначала по идентификатору магазина, затем по идентификатору должности.
Для обоих полей NULL значения размести в конце, воспользовавшись конструкцией NULLS LAST, 
как это сделано в теории задания.
*/
select 
	e.store_id 
	, e.rank_id 
	, count(*) as count_employees
from employee as e
group by rollup (e.store_id, e.rank_id) 
order by 
	1 nulls last
	, 2 nulls last;

--CUBE (12/13)
/*
Получи информацию о количестве сотрудников из таблицы employee:

в каждом магазине на каждой должности;
общее количество сотрудников в магазине;
общее количество сотрудников, занимающих определенную должность;
общее количество сотрудников во всех магазинах.
В результате выведи столбцы:

store_id - идентификатор магазина;
rank_id - идентификатор должности;
count_employees - количество сотрудников.
Отсортируй результат сначала по идентификатору магазина, затем по идентификатору должности. 
Для обоих полей NULL значения размести в конце, воспользовавшись конструкцией NULLS LAST, 
как это сделано в теории задания.
*/
select 
	e.store_id 
	, e.rank_id 
	, count(*) as count_employees
from employee as e
group by cube (e.store_id, e.rank_id) 
order by 
	1 nulls last
	, 2 nulls last;
	
--
/*
GROUPING SETS (13/13)

Получи информацию о количестве сотрудников из таблицы employee:

в каждом магазине на каждой должности;
общее количество сотрудников во всех магазинах.
В результате выведи столбцы:

store_id - идентификатор магазина;
rank_id - идентификатор должности;
count_employees - количество сотрудников.
Отсортируй результат сначала по идентификатору магазина, 
затем по идентификатору должности. Для обоих полей NULL 
значения размести в конце, воспользовавшись конструкцией NULLS LAST, 
как это сделано в теории задания.*/
select 
	e.store_id 
	, e.rank_id 
	, count(*) as count_employees
from employee as e
group by grouping sets ((e.store_id, rank_id), ()) 
order by 
	1 nulls last
	, 2 nulls last;
