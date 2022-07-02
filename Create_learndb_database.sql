DROP TABLE IF EXISTS timezone;

CREATE TABLE timezone(
	timezone_id integer NOT null, 
	time_offset text NOT NULL
);

insert into timezone (timezone_id, time_offset) values ('1', 'UTC+2');
insert into timezone (timezone_id, time_offset) values ('2', 'UTC+3');
insert into timezone (timezone_id, time_offset) values ('3', 'UTC+4');
insert into timezone (timezone_id, time_offset) values ('4', 'UTC+5');
insert into timezone (timezone_id, time_offset) values ('5', 'UTC+6');
insert into timezone (timezone_id, time_offset) values ('6', 'UTC+7');
insert into timezone (timezone_id, time_offset) values ('7', 'UTC+8');
insert into timezone (timezone_id, time_offset) values ('8', 'UTC+10');
insert into timezone (timezone_id, time_offset) values ('9', 'UTC+1');
insert into timezone (timezone_id, time_offset) values ('10','UTC+9');

select * from information_schema.columns as i
where i.table_name = 'timezone';

DROP TABLE IF EXISTS city;

CREATE TABLE city(
	city_id integer NOT null, 
	name text NOT null,
	timezone_id integer not NULL
);

insert into city values('1',   'Москва',  '2');
insert into city values('2',   'Санкт-Петербург', '2');
insert into city values('3',   'Новосибирск', '5');
insert into city values('4',   'Владивосток', '8');
insert into city values('5',   'Уфа',         '4');
insert into city values('6',   'Калининград', '1');
insert into city values('7',   'Кемерово',    '6');
insert into city values('8',   'Самара',      '3');
insert into city values('9',   'Барнаул',     '5');
insert into city values('10',  'Иркутск',     '7');