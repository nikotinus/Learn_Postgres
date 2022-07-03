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
	
--GROUPING SETS (13/13)
/*

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

--chapter5. Объединение результатов (1/8). ilike - поиск по вхождению
/*
 Давай представим, что мы делаем поиск по названию товаров и категорий товаров.

Найди все товары и категории товаров, в названии которых встречается подстрока 
'но' без учета регистра (name ilike '%но%'). В результате выведи один столбец:

name - название товара или категории товаров.
Сортировать строки результата не нужно.
 */
select 
	p.name
from product p 
where p."name" ilike '%но%' 
union 
select c.name
from category c 
where c."name" ilike '%но%'

--chapter5. Пересечение строк (3/8) 
/*

Выведи товары заказа (таблицы purchase_item и purchase), которые проданы 
по цене из каталога (таблица product_price).

Выведи столбцы:

product_id - идентификатор товара;
store_id - идентификатор магазина;
price - цена.
Для определения идентификатора магазина для товара заказа, нужно присоединить 
таблицу purchase.
*/
select 
	p_i.product_id 
	, p.store_id 
	, p_i.price 
from purchase p
inner join purchase_item as p_i
on p_i.purchase_id = p.purchase_id
intersect 
select 
	pp.product_id 
	, pp.store_id 
	, pp.price 
from product_price pp ;

--chapter5. Исключение строк (4/8)
/*
Выведи товары заказа (таблицы purchase_item и purchase), которых 
больше нет в каталоге в магазине заказа по цене заказа (таблица product_price).

Выведи столбцы:

product_id - идентификатор товара;
store_id - идентификатор магазина;
price - цена.
Для определения идентификатора магазина для товара заказа, 
нужно присоединить таблицу purchase.
*/
select 
	p_i.product_id 
	, p.store_id 
	, p_i.price 
from purchase p
inner join purchase_item as p_i
on p_i.purchase_id = p.purchase_id
except 
select 
	pp.product_id 
	, pp.store_id 
	, pp.price 
from product_price pp ;

--chapter5. Дубликаты строк (5/8)
select 
	p.name
	, 'Товар' as "type"
from product p 
where p."name" ilike '%но%' 
union all
select 
	c.name
	, 'Категория' as "type"
from category c 
where c."name" ilike '%но%'

--Совпадение типов данных столбцов (6/8)
/*
Объедини строки таблиц product_price и purchase_item и выведи три столбца:

product_id - идентификатор товара;
price - цена;
count - количество приобретенных товаров. Для таблицы product_price выведи 
значение 'отсутствует'.
*/
select 
	pp.product_id 
	, pp.price
	, 'отсутствует' as "count"
from product_price as pp
union all
select 
	pi2.product_id 
	, pi2.price
	, pi2.count :: text 
from purchase_item pi2;

-- 7/8
select 
	p.name
	, 'Товар' as "type"
from product p 
where p."name" ilike '%но%' 
union all
select 
	c.name
	, 'Категория' as "type"
from category c 
where c."name" ilike '%но%'
order by name, "type"

-- 8/8
(select
	pp.product_id 
from product_price pp
except
select
	pi2.product_id 
from purchase_item pi2)
union
(select
	pi2.product_id 
from purchase_item pi2
except
select
	pp.product_id 
from product_price pp)

-- chapter Subqueries. 1/9
select 
	p."name" as product_name
	, pi2.count 
	, pi2.price  
from purchase_item as pi2
inner join product p 
on p.product_id = pi2.product_id 
where pi2.price = (select max(pi3.price) from purchase_item pi3) 

-- chapter Subqueries. 2/9 Коррелированные подзапросы
/*
 * Найди самые дорогие товары в каждой категории товаров. Выведи столбцы:

category_name - название категории товара;
product_name - название товара;
price - стоимость товара.
Отсортируй результат сначала по названию категории, затем по названию товара.

Помни, что в подзапросах тоже можно выполнять соединение таблиц.
*/
select
	c.name as category_name
	, p.name as product_name
	, pp.price
from category c 
inner join product p  
on p.category_id  = c.category_id 
inner join product_price pp 
on pp.product_id = p.product_id 
where pp.price = (
	select max(pp2.price)
	from product_price pp2
	inner join product p2 
	on p2.product_id  = pp2.product_id 
	where p2.category_id = c.category_id 
)
order by 1,2, pp.price desc  

