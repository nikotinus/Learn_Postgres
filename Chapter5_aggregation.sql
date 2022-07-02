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