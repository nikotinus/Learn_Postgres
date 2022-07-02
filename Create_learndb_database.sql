DROP TABLE IF EXISTS timezone, city, store, store_address, category, product
, rank, product_price, employee, purchase, purchase_item;

CREATE TABLE timezone (
    timezone_id SERIAL NOT NULL,
    time_offset TEXT NOT NULL,
    CONSTRAINT timezone__pk PRIMARY KEY (timezone_id),
    CONSTRAINT timezone__offset__uk UNIQUE (time_offset)
);

CREATE TABLE city (
    city_id SERIAL NOT NULL,
    name TEXT NOT NULL,
    timezone_id INTEGER NOT NULL,
    CONSTRAINT city__pk PRIMARY KEY (city_id),
    CONSTRAINT city__to__timezone FOREIGN KEY (timezone_id) REFERENCES timezone (timezone_id)
);

CREATE TABLE store (
    store_id SERIAL NOT NULL,
    name TEXT NOT NULL,
    site_url TEXT,
    CONSTRAINT store__pk PRIMARY KEY (store_id),
    CONSTRAINT store__name__uk UNIQUE (name)
);

CREATE TABLE store_address (
    store_address_id SERIAL NOT NULL,
    store_id INTEGER NOT NULL,
    city_id INTEGER NOT NULL,
    address TEXT NOT NULL,
    opening_hours TEXT,
    phone TEXT,
    CONSTRAINT store_address__pk PRIMARY KEY (store_address_id),
    CONSTRAINT store_address__address__UK UNIQUE (store_id, city_id, address),
    CONSTRAINT store_address__to__store FOREIGN KEY (store_id) REFERENCES store (store_id),
    CONSTRAINT store_address__to__city FOREIGN KEY (city_id) REFERENCES city (city_id)
);
CREATE INDEX store_address__city_id ON store_address (city_id);

CREATE TABLE category (
    category_id SERIAL NOT NULL,
    parent_category_id INTEGER,
    name TEXT NOT NULL,
    CONSTRAINT category__pk PRIMARY KEY (category_id),
    CONSTRAINT category__parent__fk FOREIGN KEY (parent_category_id) REFERENCES category (category_id),
    CONSTRAINT category__name__uk UNIQUE (parent_category_id, name)
);
CREATE INDEX category__parent_category_id ON category (parent_category_id);


CREATE TABLE product (
    product_id SERIAL NOT NULL,
    category_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    CONSTRAINT product__pk PRIMARY KEY (product_id),
    CONSTRAINT product__to__category FOREIGN KEY (category_id) REFERENCES category (category_id),
    CONSTRAINT product__name__uk UNIQUE (category_id, name)
);
CREATE INDEX product__name ON product (name);

CREATE TABLE product_price (
    product_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    price NUMERIC (15, 2) NOT NULL,
    CONSTRAINT product_price__pk PRIMARY KEY (product_id, store_id),
    CONSTRAINT product_price__price__ck CHECK (price > 0)
);
CREATE INDEX product_price__store_id ON product_price (store_id);

CREATE TABLE rank (
    store_id INTEGER NOT NULL,
    rank_id TEXT NOT NULL,
    name TEXT NOT NULL,
    CONSTRAINT rank__pk PRIMARY KEY (store_id, rank_id),
    CONSTRAINT rank__to__store FOREIGN KEY (store_id) REFERENCES store (store_id)
);

CREATE TABLE employee (
    employee_id SERIAL NOT NULL,
    store_id INTEGER NOT NULL,
    rank_id TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    manager_id INTEGER,
    CONSTRAINT employee__pk PRIMARY KEY (employee_id),
    CONSTRAINT employee__to__rank FOREIGN KEY (store_id, rank_id) REFERENCES rank (store_id, rank_id),
    CONSTRAINT employee__manager__fk FOREIGN KEY (manager_id) REFERENCES employee (employee_id)
);
CREATE INDEX employee__manager_id ON employee (manager_id);

CREATE TABLE purchase (
    purchase_id SERIAL NOT NULL,
    purchase_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    store_id INTEGER NOT NULL,
    employee_id INTEGER,
    CONSTRAINT purchase__pk PRIMARY KEY (purchase_id),
    CONSTRAINT purchase__to__employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT purchase__to__store FOREIGN KEY (store_id) REFERENCES store (store_id)
);
CREATE INDEX purchase__employee_id ON purchase (employee_id);

CREATE TABLE purchase_item (
    purchase_item_id SERIAL NOT NULL,
    purchase_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    price NUMERIC (15, 2) NOT NULL,
    count INTEGER NOT NULL,
    CONSTRAINT purchase_item__pk PRIMARY KEY (purchase_item_id),
    CONSTRAINT purchase_item__product__uk UNIQUE (purchase_id, product_id),
    CONSTRAINT purchase_item__to__purchase FOREIGN KEY (purchase_id) REFERENCES purchase (purchase_id),
    CONSTRAINT purchase_item__to__product FOREIGN KEY (product_id) REFERENCES product (product_id),
    CONSTRAINT purchase_item__price__ck CHECK (price > 0),
    CONSTRAINT purchase_item__count__ck CHECK (count > 0)
);
CREATE INDEX purchase_item__product_id ON purchase_item (product_id);


insert into timezone values (1, 'UTC+2');
insert into timezone values (3, 'UTC+4');
insert into timezone values (2, 'UTC+3');
insert into timezone values (4, 'UTC+5');
insert into timezone values (5, 'UTC+6');
insert into timezone values (6, 'UTC+7');
insert into timezone values (7, 'UTC+8');
insert into timezone values (8, 'UTC+10');
insert into timezone values (9, 'UTC+1');
insert into timezone values (10,'UTC+9');

insert into city values(1,   'Москва',  2);
insert into city values(2,   'Санкт-Петербург', 2);
insert into city values(3,   'Новосибирск', 5);
insert into city values(4,   'Владивосток', 8);
insert into city values(5,   'Уфа',         4);
insert into city values(6,   'Калининград', 1);
insert into city values(7,   'Кемерово',    6);
insert into city values(8,   'Самара',      3);
insert into city values(9,   'Барнаул',     5);
insert into city values(10,  'Иркутск',     7);

insert into store values(100, 'Пионер'       , 'pioner.ru');
insert into store values(200, 'Марс'         , 'mars.ru');
insert into store values(300, 'Адалин'       , 'adalin.ru');
insert into store values(400, 'Европа'       , 'evropa.ru');
insert into store values(500, 'Март'         , 'mart.ru');
insert into store values(600, 'Umi'          , NULL);
insert into store values(800, 'Универсам'    , NULL);
insert into store values(900, 'Big'          , 'big.ru');
insert into store values(201, 'Сатурн'       , 'saturn.ru');
insert into store values(301, 'Адалин-family', 'adalin-ultra.ru');
insert into store values(302, 'Адалин-ultra' , NULL);

insert into store_address values(10, 100, 1, 'ул. Арбат, 20', 		'Пн-Пт.:с 09:00-17:00', '7(495)312‒03‒08');
insert into store_address values(11, 100, 1, 'ул. Строителей, 124', 'Пн-Пт.:с 09:00-17:00', '7(495)312‒03‒08');
insert into store_address values(12, 100, 5, 'пр. Ленина, 42', 		'Пн-Пт.:с 08:00-18:00', '7(495)312‒03‒08');
insert into store_address values(20, 200, 2, 'ул. Казанская, 43', 	'Пн-Пт.:с 08:00-16:00', '7(812)700‒03‒03');
insert into store_address values(30, 300, 3, 'ул. Ленина, 18', 		'Пн-Пт.:с 07:00-19:00', '7(383)568‒03‒03');
insert into store_address values(40, 400, 4, 'ул. Мира, 12', 		NULL                  , '7(423)568‒53‒88');
insert into store_address values(50, 500, 5, 'ул. Свободы, 50', 	'Пн-Пт.:с 09:00-17:00', '7(347)668‒56‒66');
insert into store_address values(60, 600, 6, 'ул. Суворова, 11', 	'Пн-Пт.:с 10:00-22:00', NULL);
insert into store_address values(61, 600, 6, 'ул. Чкалова, 42', 	'Пн-Пт.:с 08:00-20:00', NULL);
insert into store_address values(80, 800, 8, 'ул. Мичурина, 60', 	'Пн-Пт.:с 09:00-17:00', '7(846)000‒54‒44');
insert into store_address values(90, 900, 9, 'ул. Лазурная, 79', 	'Пн-Пт.:с 09:00-17:00', '7(385)777‒77‒07');
insert into store_address values(21, 201, 2, 'ул. Седова, 33', 		'Пн-Пт.:с 08:00-16:00', NULL);

insert into category values(1   , NULL  , 'Товары для дома');
insert into category values(2   , NULL  , 'Цифровая техника');
insert into category values(3   , 1     , 'Бытовая техника');
insert into category values(4   , 2     , 'Ноутбуки и аксессуары');
insert into category values(5   , 2     , 'Фотоаппараты');
insert into category values(6   , 2     , 'Игровые консоли');
insert into category values(7   , 2     , 'Аудиотехника');
insert into category values(8   , 2     , 'Сотовые телефоны');
insert into category values(9   , 4     , 'Ноутбуки');
insert into category values(10  , 4     , 'Рюкзаки');

insert into product values(1,   3 ,  'Пылесос S6',  '1400 вт');
insert into product values(2,   3 ,  'Холодильник A2',  'No frost');
insert into product values(3,   6 ,  'Nintendo',  '500 Гб');
insert into product values(4,   6 ,  'PlayStation', '800 ГБ');
insert into product values(5,   6 ,  'Xbox',  NULL);
insert into product values(6,   7 ,  'Наушники S3', 'Беспроводные');
insert into product values(7,   10,  'Deepbox', 'Нейлон');
insert into product values(8,   8 ,  'Слайдер B3',  '1 sim');
insert into product values(9,   8 ,  'Моноблок C4', '2 sim');
insert into product values(10,  9 ,  'Ультрабук X5', '15 дюймов');
insert into product values(11,  5 ,  'Lord Nikon 95', '100 megapixel');
insert into product values(12,	5,	'Nikon D750',	'24.93Mpix');

insert into product_price values(1 ,  300, 10500.00);
insert into product_price values(10,  400, 75600.00);
insert into product_price values(8 ,  400, 37000.00);
insert into product_price values(4 ,  400, 20000.00);
insert into product_price values(2 ,  500, 26100.00);
insert into product_price values(3 ,  500, 22000.00);
insert into product_price values(4 ,  500, 22000.00);
insert into product_price values(5 ,  500, 23500.00);
insert into product_price values(6 ,  500, 17800.00);
insert into product_price values(8 ,  600, 38200.00);
insert into product_price values(9 ,  600, 43800.00);
insert into product_price values(10,  600, 76800.00);
insert into product_price values(2 ,  600, 27500.00);
insert into product_price values(1 ,  800, 12000.00);
insert into product_price values(3 ,  800, 22100.00);
insert into product_price values(4 ,  800, 21000.00);
insert into product_price values(5 ,  800, 24600.00);
insert into product_price values(11,  900, 1321800000.00);
insert into product_price values(3 ,  201, 22900.00);
insert into product_price values(4 ,  201, 21500.00);
insert into product_price values(5 ,  201, 23500.00);
insert into product_price values(6 ,  201, 17800.00);
insert into product_price values(6 ,  301, 17900.00);
insert into product_price values(1 ,  301, 12500.00);
insert into product_price values(7 ,  301, 4900.00);
insert into product_price values(8 ,  302, 38300.00);
insert into product_price values(9 ,  302, 44500.00);

insert into rank values(100, 'CHIEF', 'Директор');
insert into rank values(100, 'MANAGER', 'Менеджер');
insert into rank values(100, 'SELLER', 'Продавец');
insert into rank values(200, 'CHIEF', 'Директор');
insert into rank values(200, 'MANAGER', 'Менеджер');
insert into rank values(200, 'SELLER', 'Продавец');
insert into rank values(300, 'MANAGER', 'Менеджер');
insert into rank values(300, 'SELLER', 'Продавец');
insert into rank values(400, 'CHIEF', 'Директор');
insert into rank values(400, 'MANAGER', 'Менеджер');
insert into rank values(500, 'CHIEF', 'Директор');
insert into rank values(500, 'MANAGER', 'Менеджер');
insert into rank values(500, 'SELLER', 'Продавец');
insert into rank values(600, 'CHIEF', 'Директор');
insert into rank values(600, 'MANAGER', 'Менеджер');
insert into rank values(600, 'SELLER', 'Продавец');
insert into rank values(800, 'CHIEF', 'Директор');
insert into rank values(800, 'MANAGER', 'Менеджер');
insert into rank values(900, 'CHIEF', 'Директор');
insert into rank values(900, 'MANAGER', 'Менеджер');
insert into rank values(900, 'SELLER', 'Продавец');
insert into rank values(201, 'CEO', 'Директор');
insert into rank values(201, 'MANAGER', 'Менеджер');
insert into rank values(201, 'SELLER', 'Продавец');
insert into rank values(301, 'DIRECTOR', 'Директор');
insert into rank values(301, 'MANAGER', 'Менеджер');
insert into rank values(301, 'SELLER', 'Продавец');
insert into rank values(302, 'GENERAL_MANAGER', 'Директор');
insert into rank values(302, 'MANAGER', 'Менеджер');
insert into rank values(302, 'SELLER', 'Продавец');

insert into employee values(1,  100, 'CHIEF',            'Алексей',    'Иванов',     'Петрович',       NULL);
insert into employee values(2,  200, 'CHIEF',            'Кенни',      'Маккормик',  NULL,             NULL);
insert into employee values(3,  400, 'CHIEF',            'Анна',       'Матвеева',   'Игоревна',       NULL);
insert into employee values(4,  500, 'CHIEF',            'Роман',      'Шмидт',      'Сергеевич',      NULL);
insert into employee values(5,  600, 'CHIEF',            'Виктор',     'Сухоруков',  'Витальевич',     NULL);
insert into employee values(6,  800, 'CHIEF',            'Светлана',   'Немцова',    'Леонидовна',     NULL);
insert into employee values(7,  900, 'CHIEF',            'Ольга',      'Вершинина',  'Олеговна',       NULL);
insert into employee values(8,  201, 'CEO',              'Петр',       'Корсаков',   'Константинович', NULL);
insert into employee values(9,  301, 'DIRECTOR',         'Сергей',     'Антонов',    'Кириллович',     NULL);
insert into employee values(10,  302, 'GENERAL_MANAGER',  'Влад',       'Контур',     'Семенович',      NULL);
insert into employee values(11,  100, 'MANAGER',          'Глеб',       'Тарасов',    'Авдеевич',       NULL);
insert into employee values(12,  200, 'MANAGER',          'Владислав',  'Калашников', 'Яковович',       NULL);
insert into employee values(13,  300, 'MANAGER',          'Владислав',  'Бирюков',    'Яковович',       NULL);
insert into employee values(14,  400, 'MANAGER',          'Валерий',    'Медведев',   'Антонинович',    3	);
insert into employee values(15,  500, 'MANAGER',          'Эрик',       'Картман',    NULL,             4	);
insert into employee values(16,  600, 'MANAGER',          'Николай',    'Воробьёв',   'Артёмович',      5	);
insert into employee values(19,  800, 'MANAGER',          'Зиновий',    'Белозёров',  'Семёнович',      6	);
insert into employee values(18,  600, 'MANAGER',          'Вилен',      'Кулаков',    'Федотович',      5	);
insert into employee values(17,  600, 'MANAGER',          'Мирон',      'Калинин',    'Иванович',       5	);
insert into employee values(20,  900, 'MANAGER',          'Павел',      'Авдеев',     'Яковович',       7	);
insert into employee values(21,  201, 'MANAGER',          'Никки',      'Зайцева',    'Аристарховна',   8	);
insert into employee values(22,  301, 'MANAGER',          'Кристина',   'Емельянова', 'Алексеевна',     9	);
insert into employee values(23,  201, 'MANAGER',          'Доминика',   'Тимофеева',  'Федотовна',      NULL);
insert into employee values(24,  302, 'MANAGER',          'Марина',     'Кондратьева','Ивановна',       10	);
insert into employee values(25,  100, 'SELLER',           'Любовь',     'Блинова',    'Львовна',        11	);
insert into employee values(26,  200, 'SELLER',           'Наталия',    'Потапова',   'Евсеевна',       12	);
insert into employee values(27,  200, 'SELLER',           'Лилия',      'Рябова',     'Леонидовна',     NULL);
insert into employee values(28,  300, 'SELLER',           'Эльза',      'Одинцова',   'Алексеевна',     13	);
insert into employee values(29,  500, 'SELLER',           'Зарина',     'Миронова',   'Артемовна',      15	);
insert into employee values(30,  600, 'SELLER',           'Нина',       'Дьячкова',   'Лукьяновна',     16	);
insert into employee values(31,  600, 'SELLER',           'Глеб',       'Петров',     'Авдеевич',       16	);
insert into employee values(32,  600, 'SELLER',           'Мирон',      'Агафьев',    'Иванович',       18	);
insert into employee values(33,  900, 'SELLER',           'Лилия',      'Леонтьева',  'Леонидовна',     20	);
insert into employee values(34,  900, 'SELLER',           'Юлиан',      'Громов',     'Федорович',      20	);
insert into employee values(35,  900, 'SELLER',           'Терентий',   'Буров',      'Федорович',      20	);
insert into employee values(40,  201, 'SELLER',           'Нина',       'Кондратьева','Леонидовна',     21	);
insert into employee values(41,  201, 'SELLER',           'Любомир',    'Ефремов',    'Святославович',  21);
insert into employee values(42,  201, 'SELLER',           'Лука',       'Дементьев',  'Олегович',       21);
insert into employee values(43,  301, 'SELLER',           'Влас',       'Суханов',    'Олегович',       22);
insert into employee values(44,  201, 'SELLER',           'Эдуард',     'Рогов',      'Максович',       23);
insert into employee values(45,  201, 'SELLER',           'Терентий',   'Моисеев',    'Олегович',       23);
insert into employee values(46,  201, 'SELLER',           'Арнольд',    'Никифоров',  'Олегович',       23);
insert into employee values(47,  302, 'SELLER',           'Мартин',     'Субботин',   'Станиславович',  24);
insert into employee values(48,  302, 'SELLER',           'Питер',      'Паркер',     NULL,             24);
insert into employee values(49,  302, 'SELLER',           'Виктор',     'Медведев',   'Анатольевич',    24);
insert into employee values(50,  302, 'SELLER',           'Лев',        'Одинцова',   'Сергеевич',      24);


insert into purchase values(1,     '2019-03-11 17:15:02.206+07',  500, 29);
insert into purchase values(2,     '2019-03-10 17:12:34.206+07',  900, 34);
insert into purchase values(3,     '2019-03-05 16:12:33.206+07',  302, NULL);
insert into purchase values(4,     '2019-03-06 20:12:33.206+07',  500, 15);
insert into purchase values(5,     '2019-03-07 21:22:43.206+07',  301, 43);
insert into purchase values(6,     '2019-03-09 19:25:43.206+07',  600, 32);
insert into purchase values(7,     '2019-03-13 22:10:43.206+07',  302, NULL);
insert into purchase values(8,     '2019-03-07 19:23:43.206+07',  100, 25);
insert into purchase values(9,     '2019-03-06 17:55:43.206+07',  100, 25);
insert into purchase values(10,   '2019-03-01 19:15:43.206+07',  600, 19);
insert into purchase values(11,   '2019-03-10 23:35:43.206+07',  201, 8);

insert into purchase_item values(1, 1, 6,     17800.00,  1);
insert into purchase_item values(2, 1, 2,     26100.00,  30);
insert into purchase_item values(3, 2, 11,    1321800000.00, 1);
insert into purchase_item values(4, 3, 8,     38300.00,  1);
insert into purchase_item values(5, 3, 9,     44500.00,  1);
insert into purchase_item values(6, 4, 5,     23500.00,  2);
insert into purchase_item values(7, 5, 7,     4900.00, 1);
insert into purchase_item values(8, 6, 10,    76800.00,  1);
insert into purchase_item values(9, 6, 9,     43800.00,  1);
insert into purchase_item values(10,  6, 8,    38200.00,  1);
insert into purchase_item values(11,  7, 8,    38300.00,  3);
insert into purchase_item values(12,  8, 3,    26100.00,  1);
insert into purchase_item values(13,  9, 3,    26100.00,  1);
insert into purchase_item values(14,  10,  2,  27500.00,  5);
insert into purchase_item values(15,  10,  10, 76800.00,  1);
insert into purchase_item values(16,  10,  8,   38200.00,  1);
insert into purchase_item values(17,  11,  4,   21500.00,  1);
insert into purchase_item values(18,  11,  12, 	100000.00, 1);