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
Найди самые дорогие товары в каждой категории товаров. Выведи столбцы:

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

-- chapter Подзапрос вернул более одной строки (3/9)
/*
Для каждой категории товаров получи пример товара.

Выведи поля:

name - название категории;
product_example - название примера продукта в категории. 
Возьми первый по алфавиту товар в категории.
Отсортируй результат по названию категории.
*/
select 
	c."name" 
	, (select 
		p."name" 
	from product p 
	where p.category_id = c.category_id 
	order by p."name" 
	limit 1) as product_example
from category c 
order by 1

--4/9
select 
	c.category_id 
	, c."name" 
from category c 
where (select 
		p."name" 
	from product p 
	where p.category_id = c.category_id 
	order by p."name" 
	limit 1) is NULL
order by 2

--5/9
select 
	e.employee_id 
	, e.last_name 
	, e.first_name
	, e.rank_id 
from employee e 
where e.employee_id in (
	select distinct e.manager_id 
	from employee e 
	where e.manager_id is not null)
order by 2,4

-- 6/9
select 
	p.product_id 
	, p."name" 
from product p 
where p.product_id not in (
	select distinct 
	pi2.product_id 
	from purchase_item pi2 
)

--NULL значения в NOT IN (7/9)
/*
Получи информацию о сотрудниках, которые никем 
не руководят (идентификатор сотрудника отсутствует 
в столбце employee.manager_id). Выведи следующие столбцы:

employee_id - идентификатор сотрудника;
last_name - фамилия;
first_name - имя;
rank_id - идентификатор должности.
Отсортируй результат сначала по фамилии, затем 
по идентификатору сотрудника.*/
select 
	e.employee_id 
	, e.last_name 
	, e.first_name
	, e.rank_id 
from employee e 
where e.employee_id not in (
	select e.manager_id 
	from employee e 
	where e.manager_id is not null)
order by 2,4

--Проверка существования строки (8/9)
/*
Получи информацию о сотрудниках, которые кем-либо руководят 
(идентификатор сотрудника присутствует в столбце 
employee.manager_id). Выведи следующие столбцы:

employee_id - идентификатор сотрудника;
last_name - фамилия;
first_name - имя;
rank_id - идентификатор должности.
Отсортируй результат сначала по фамилии, 
затем по идентификатору сотрудника.

P.S. Да-да, такое задание уже было :) Но теперь воспользуйся EXISTS.*/
select 
	m.employee_id 
	, m.last_name 
	, m.first_name
	, m.rank_id 
from employee m 
where exists (
	select e.manager_id 
	from employee e 
	where e.manager_id = m.employee_id)
order by 2,1

--9/9
select 
	e.employee_id 
	, e.last_name 
	, e.
	, e.first_name
	, e.rank_id 
from employee e 
where not exists (
	select 1 
	from employee m 
	where m.manager_id = e.employee_id)
order by 2,1

--2/9
select
  lower(concat(e.last_name, ' ', e.first_name)) as lower,
  upper(concat(e.last_name, ' ', e.first_name)) as upper,
  initcap(concat(e.last_name, ' ', e.first_name)) as initcap
from employee as e
order by e.last_name, e.first_name

--3/9
select e.last_name , length(e.last_name) as "length"
from employee e 
order by 2 desc,1

--4/9
select e.employee_id , concat(e.last_name, ' ', Upper(left(e.first_name, 1)))
from employee e

--5/9
select e.last_name,
	left(e.last_name, position('а' in lower(e.last_name))) as substring
from employee e 
order by e.last_name 

--6/9
select concat(e.last_name, ' ', rpad(left(e.first_name,1), length(e.first_name), '*')) as mask
from employee e
order by 1

--7/9
--select trim(concat(e.last_name, ' ', e.first_name, ' ', e.middle_name)) as full_name
select  trim(both ' ' from concat(e.last_name, ' ', e.first_name, ' ', e.middle_name)) as full_name
from employee e 
order by 1

--8/9
select replace(replace(sa.address, 'пр.', 'проспект'), 'ул.', 'улица') as address_full
from store_address sa 

--9/9
SELECT distinct 
e.first_name 
, translate(e.first_name
	, 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщыэюяЬЪьъ'
	, 'ABVGDEEJZIJKLMNOPRSTUFHCHSSYEYAabvgdeejzijklmnoprstufhchssyeya') as first_name_translated
from employee e 
order by 1

--chapter Арифметические операции

-- Простейшие арифметические операции (+ - * /) (1/13)
select
	pi2.purchase_id 
	, pi2.product_id 
	, pi2.price 
	, pi2."count"
	, pi2.price * pi2.count as total_price
from purchase_item pi2 
order by 1,2

--Порядок выполнения операций (2/13)
/*
В некоторых магазинах существует "гарантия лучшей цены". 
Если вы находите такой же товар дешевле в другом магазине, 
то вам предоставляют скидку в размере определенного процента от разницы цен.

В этом задании будем предоставлять скидку в размере 50% от разницы цен. 
Например, если товар в текущем магазине стоит 2000, а в другом 1800, 
то скидка составит (2000 - 1800) * 0.5 = 100.

Определи размер скидки на товар из product_price от минимальной цены 
на этот товар по всем магазинам.

product_id - идентификатор товара;
store_id - идентификатор магазина;
price - цена на товар в магазине;
discount - размер 50% скидки от минимальной стоимости на товар в других магазинах.
Отсортируй результат сначала по идентификатору товара, затем по цене на товар в магазине.
*/
select 
	pp.product_id 
	, pp.store_id 
	, pp.price 
	, (pp.price - (select min(pp2.price)
		from product_price pp2 
		where pp2.product_id  = pp.product_id)) * 0.5 as discount
from product_price pp 
order by 1, 3

--3/13
select 
	pi2.purchase_item_id 
	, pi2.count 
	, (pi2.count / 2) as whole
	, pi2.count * 1.0 / 2 as fractional
from purchase_item pi2 
order by 2

--4/13
select 
	pi2.purchase_item_id 
	, pi2.count 
	, pi2.count % 2 as is_odd
from purchase_item pi2 
order by 2 desc 

--5/13
select 
	t.timezone_id 
from timezone t 
where right(t.time_offset, -4)::integer =4

--6/13
select 
	pp.store_id 
	, avg(pp.price) as average_price
	, round(avg(pp.price), 2) as average_price_rounded
from product_price pp 
group by pp.store_id 
order by 2

--7/13
select 
	pp.store_id 
	, avg(pp.price) as average_price
	, round(avg(pp.price), 2) as average_price_round
	, trunc(avg(pp.price), 2) as average_price_trunc 
from product_price pp 
group by pp.store_id 
order by 2

--8/13
select 
	pp.product_id  
	, avg(pp.price) as price_avg
	, round(avg(pp.price), 0) as price_avg_round
	, ceil(avg(pp.price)) as price_avg_ceil 
from product_price pp 
group by pp.product_id  
order by 2 desc 

--9/13
select 
	pp.product_id  
	, avg(pp.price) as price_avg
	, round(avg(pp.price), 0) as price_avg_round
	, ceil(avg(pp.price)) as price_avg_ceil
	, floor(avg(pp.price)) as price_avg_floor
	, trunc(avg(pp.price)) as price_avg_trunc
from product_price pp 
group by pp.product_id  
order by 2 desc 

--10/13
select 
	pp.product_id 
	, pp.store_id 
	, pp.price 
	, greatest(round(0.05 * pp.price,0), 1000) as prepayment
from product_price pp 
order by 3,1,2

--11/13
select 
	pp.product_id 
	, pp.store_id 
	, pp.price 
	, least(round(0.05 * pp.price,0), 1000) as prepayment_least
	, greatest(round(0.05 * pp.price,0), 1000) as prepayment_greatest
from product_price pp 
order by 3,1,2

--12/13
select 
	pp.product_id 
	, pp.store_id 
	, pp.price 
	, (select round(avg(pp2.price), 2)
		from product_price pp2
		where pp2.product_id = pp.product_id) as price_avg
	, abs(pp.price - (select round(avg(pp2.price), 2)
		from product_price pp2
		where pp2.product_id = pp.product_id)) as price_difference	
from product_price pp 
order by 1,3,2
