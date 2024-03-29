﻿--Создание таблиц по спроектированной модели и заполнение их данными

--------------------------------------------------
BEGIN;


CREATE TABLE store (
id serial PRIMARY KEY,
name varchar(255),
postal_code bigint,
open_date timestamptz,
close_date timestamptz NULL,
adress varchar(255)
);

INSERT INTO store (name, postal_code, open_date, close_date, adress)
VALUES
('Двоечка', '171504', '1999-02-15','2005-02-11', 'Kimry'), 
('Четверочка', '171501', '1999-03-14',NULL, 'Dubna'),
('Шестерочка', '171502', '1999-04-26',NULL, 'Dubna'),
('Мир', '171503', '2001-05-15',NULL, 'Moscow'),
('Труд', '171503', '2001-06-15',NULL, 'Moscow'), --5
('Май', '171503', '2001-07-15',NULL, 'Moscow'),
('Океан', '171525', '2002-11-02', NULL, 'Tver'),
('СССР', '171526', '2005-02-13', '1991-02-15', 'Tver'),
('Савок', '171526', '2007-09-20', '1991-02-15', 'Tver'),
('Патриот', '171526', '2010-07-26', NULL, 'Tver');

INSERT INTO store (name, postal_code, open_date, close_date, adress)
VALUES
('Троечка', '171544', '2021-02-15',NULL, 'Kimry'); 


CREATE TABLE department (
id serial PRIMARY KEY,
name varchar(255),
description varchar(255),
open_date timestamptz,
close_date timestamptz NULL,
adress varchar(255)
);
INSERT INTO department (name, description, open_date, close_date, adress)
VALUES
('Основной', 'Основное управление отделами', '1998-02-15','2005-02-15', 'Moscow'), 
('Главный', 'Основное управление отделами', '2005-03-14',NULL, 'Moscow'),
('Второстепенный1', 'Второстепенное управление отделами', '1999-04-26',NULL, 'Dubna'),
('Второстепенный2', 'Второстепенное управление отделами', '2001-05-15',NULL, 'Moscow'),
('Второстепенный3', 'Второстепенное управление отделами', '2002-06-15',NULL, 'Moscow'),
('Второстепенный4', 'Второстепенное управление отделами', '2003-07-15',NULL, 'Moscow'),
('Окружной', 'Окружное управление отделами', '2004-11-02', NULL, 'Tver'),
('Областной', 'Областное управление отделами', '2005-02-13', NULL, 'Moscow'),
('Международный', 'Международное управление отделами', '2007-09-20',NULL, 'Tver'),
('Местный', 'Местное управление отделами', '2001-07-26', NULL, 'Tver');

CREATE TABLE store_department (
department_id bigint,
store_id integer,
PRIMARY KEY(department_id, store_id)
);
INSERT INTO store_department (department_id, store_id)
VALUES
(1, 1),
(2, 2),--general
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 10),
(3, 4),
(3, 5),
(4, 6),
(5, 7),
(6, 10),
(7, 6),
(8, 4),
(9, 10),
(10, 10);

------
CREATE TABLE unit (
id serial PRIMARY KEY,
name varchar(255),
description varchar(255),
kind_of_activity varchar(255),
open_date timestamptz,
close_date timestamptz NULL,
department_id integer REFERENCES department (id)
/*CONSTRAINT  unit_department_id FOREIGN KEY (department_id)
 REFERENCES department (id) MATCH SIMPLE*/
/*ON UPDATE NO ACTION
/*ON DELETE CASCADE*/--сносит все ссылки
/*ON DELETE set null*/--полезен при хранении статистики
ON DELETE NO ACTION*/
);

INSERT INTO unit (name, description, kind_of_activity, open_date, close_date, department_id)
VALUES
('Отдел1', 'Отдел занимающийся управлением персоналом','управление','1998-02-15','2005-02-15', 1), 
('Отдел2', 'Отдел занимающийся распределениме ресурсов','управление','2005-03-14',NULL, 2),
('Отдел3', 'Отдел занимающийся работой сервисов','управление', '1999-04-26',NULL, 4),
('Отдел4', 'Отдел занимающийся магазинов', 'управление','2001-05-15',NULL, 5),
('Отдел5', 'Отдел занимающийся управлением персоналом','управление', '2005-02-16',NULL, 2),
('Отдел6', 'Отдел занимающийся поставками', 'управление','1998-02-15',NULL, 6),
('Отдел7', 'Отдел занимающийся скучной работой','неизвестно', '1998-02-15',NULL, 7),
('Отдел8', 'Отдел занимающийся формированием трудоустройсва','труд', '2002-06-15',NULL, 8),
('Отдел9', 'Отдел занимающийся запасной','управление', '2002-06-15',NULL, 9),
('Отдел10', 'Отдел для размышлений','май?','2002-06-15',NULL, 10);

CREATE TABLE worker (
id serial PRIMARY KEY,
name varchar(255),
surname varchar(255),
position varchar(255),
registration bigint UNIQUE,
number_phone bigint UNIQUE,
email varchar(255)UNIQUE,
birth_day timestamptz,
store bigint NULL,----------
unit_id integer REFERENCES unit (id)
);

INSERT INTO worker (name, surname, position, registration, number_phone, email,birth_day, store, unit_id)
VALUES
('Олег', 'Петров','Директор','115431','89800553535', 'petrov@gmail.com', '1989-02-21', NULL, 1), 
('Диман', 'Белоусов','Гендиректор','115433','89800553536', 'bel@gmail.com', '1990-02-11', NULL, 5), 
('Влад', 'Смирнов','продавец','115437','89800553537', 'vs@gmail.com', '1989-02-26', NULL, 4), 
('Ярик', 'Медведев','продавец','115423','89800553538', 'ya@gmail.com', '1990-04-26', NULL, 4), 
('Славик', 'Ершов','продавец','115422','89800553539', 'clava@gmail.com', '1999-12-26', NULL, 4), 
('Костян', 'Маслов','кладовщик','114531','89800553545', 'km@gmail.com', '1956-11-26', '2' ,2), -- 6
('Веня', 'Аксёнов','менеджер','119431','89800553555', 'venchik@gmail.com', '1977-05-26' ,NULL, 6), 
('Паша', 'Елисеев','кадровик','125431','89800553635', 'pavel@gmail.com', '1976-02-21', NULL, 3), 
('Саня', 'Костин','HR-спец','115504','89800553575', 'kostin@gmail.com', '1987-07-16', NULL, 8), 
('Антон', 'Брагин','Проектировщик','112221','89800553935', 'bragin@gmail.com', '1990-01-16', NULL, 5), 
('Аноним', 'Котов','ничего не делает','215431','89820553535', 'anonymous@gmail.com', '1989-02-16', NULL, 9), 
('Роман', 'Соколов','притворяется что работает','325431','89844553535', 'sokol@gmail.com', '1968-02-16', NULL, 10), 
('Олег', 'Морозов','Инженер','225431','89230553535', 'oleg@gmail.com', '1986-03-26', NULL, 5), 
('Денчик', 'Петров','Админ','445431','89430553535', 'den@gmail.com', '1987-04-26', NULL, 9); 


CREATE TABLE timetable (
id serial PRIMARY KEY,
date_begin timestamp,
date_finish timestamp,
date_number timestamptz,
worker_id integer REFERENCES worker (id)
);
INSERT INTO timetable (date_begin, date_finish, date_number, worker_id)
VALUES
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-23', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-24', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-25', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-26', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-27', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-28', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-29', 6),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-27', 5),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-28', 4),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-29', 3),
('2020-05-23 09:00:00','2020-05-23 18:00:00','2020-05-20', 2);

-------

CREATE TABLE supplier (
id serial PRIMARY KEY,
name varchar(255),
adress varchar(255),
availability varchar(255) NULL,
inn integer UNIQUE
);
INSERT INTO supplier (name, adress,availability,inn )
VALUES
('молочная продукция', 'Moscow','доступно',133123),
('молочная продукция', 'Dubna',' недоступно',133255),
('мясная продукция', 'Moscow','доступно',444123),
('мясная продукция', 'Moscow',' недоступно',111123),
('выпечка', 'Dubna','доступно',222123),-- 5
('пряности', 'Moscow','доступно',666123),
('выпечка', 'Moscow','доступно',133777),
('овощи', 'Dubna','доступно',868123),
('фрукты', 'Moscow','доступно',133888),
('соки', 'Moscow','доступно',133223),
('алкоголь', 'Moscow','доступно',133923);



CREATE TABLE registration_product (
id serial PRIMARY KEY,
information varchar(255),
price bigint,
amount integer,
date timestamp,
requisites varchar(255) UNIQUE,
worker_id integer REFERENCES worker (id),
store_id integer REFERENCES store (id),
supplier_id integer REFERENCES supplier (id)
);
INSERT INTO registration_product (information, price, amount,date, requisites, worker_id, store_id, supplier_id )
VALUES
('мясо', '250', '10', '2020-05-01 20:05:06', 'general in mir1', 6, 4, 3),
('молоко', '20', '25', '2020-05-01 20:05:06', 'general in trud1', 6, 5, 1),
('хлеб', '10', '10', '2020-05-01 20:05:06', 'general in may1', 6, 6, 5),
('булочка', '10', '10', '2020-05-01 20:05:06', 'general in mir2', 6, 4, 6),
('пряники', '15', '10', '2020-05-01 20:05:06', 'general in 22trud', 6, 5, 7),
('картошка', '20', '10', '2020-05-01 20:05:06', 'general in 33may2', 6, 6, 8),
('сок', '40', '10', '2020-05-01 20:05:06', 'general in 44mir3', 6, 6, 10),
('колбаса', '90', '10', '2020-05-01 20:05:06', 'general in 55trud2', 6, 6, 10),
('ряженка', '30', '10', '2020-05-01 20:05:06', 'general in66 may3', 6, 6, 10),
('водка', '100', '10', '2020-05-01 20:05:06', 'general in 00may5', 6, 6, 11);

-------
CREATE TABLE product (
id serial PRIMARY KEY,
name varchar(255),
type integer,
price bigint,
description varchar(255),
weight integer NULL,
size integer NULL
);

INSERT INTO product (name, type, price, description, weight, size )
VALUES
('мясо', '1','500', 'мясной продукт', ' 1',' 1'),
('молоко', '2','40', 'молочный продукт', '1','1'),
('хлеб', '3','35', 'хлебобулочное изделие', '1','1'),
('булочка', '3','25', 'хлебобулочное изделие', '1','1'),
('пряники', '3','50', 'хлебобулочное изделие', '1','1'),
('картошка', '4','90', 'овощи', '1','1'),
('сок', '5','90', 'нектары', '1','1'),
('колбаса', '1','200', 'мясной продукт', '1','1'),
('ряженка', '2','60', 'молочный продукт', '1','1'),
('водка', '10','400', 'алкогольный продукт', '1','1');

CREATE TABLE price_history (
id serial PRIMARY KEY,
price bigint,
date timestamp,
product_id integer REFERENCES product (id)
);

INSERT INTO price_history (price,date,product_id  )
VALUES
('550', '2020-05-27 20:05:06', 1),
('600', '2020-06-03 15:05:06', 1),
('50', '2020-05-22 15:05:06', 2),
('55', '2020-05-28 15:05:06', 2),
('39', '2020-05-22 15:05:06', 3),
('65', '2020-05-29 15:05:06', 3),
('50', '2020-05-28 15:05:06', 10),
('50', '2020-06-07 15:05:06', 10),
('399', '2020-05-27 15:05:06', 7),
('450', '2020-06-03 15:05:06', 7);



CREATE TABLE product_in_store (
store_id integer,
product_id integer,
PRIMARY KEY(store_id, product_id )
);

INSERT INTO product_in_store (store_id, product_id)
VALUES
(2,1),
(2,2),
(2,3),
(2,4),
(2,5),
(2,6),
(2,7),
(2,8),
(2,9),
(2,10);

CREATE TABLE product_attribute (
id serial PRIMARY KEY,
attribute varchar(255),
value varchar(100),
product_id integer REFERENCES product (id)
);
INSERT INTO product_attribute (attribute, value, product_id)
VALUES
('kilogram', '0,5', 1),-- методика работает
('quality', '100', 1),--
('fat', '3,2%', 2),
('liters', '2', 2),
('alko', '40%', 10),
('liters', '0,5', 10),
('quantity', '15', 6),
('liters', '0,5', 9),
('fat', '3,2%', 1);

----
CREATE TABLE client (
id serial PRIMARY KEY,
name varchar(255),
surname varchar(255),
email varchar(255) NULL UNIQUE,
phone bigint NULL UNIQUE,
birth_day timestamptz NULL,
gender char(1) NULL
);
INSERT INTO client (name, surname, email, phone, birth_day ,gender )
VALUES
('Oleg','Prapor', 'olegi4@mail.ru', NULL,'1988-09-22', 'M'),
('Canya','CHuvaw', 'CHuvaw@mail.ru', '89354545','1988-09-22', 'M'),
('Dima','Ytkin', 'Ytkin@mail.ru',  NULL, NULL, 'M'),
('Masha','Yagorova', 'Yagorova@mail.ru', '8734545',NULL, 'W'),
('Petr','Prapor', NULL, NULL,NULL, 'M'),
('Kolya','Vrapor', NULL, '78325545',NULL, 'M'),
('Lolya','Tapor', NULL, NULL,'1988-09-22', 'M'),
('Pavel','Belousov', 'Belousov@mail.ru', '9004545','1988-09-22', 'M'),
('Dima','Politeh', NULL, NULL,'1988-09-22', 'M'),
('Olya','Prapor', NULL, NULL,'1988-09-22', 'W');


CREATE TABLE purchase(
id serial PRIMARY KEY,
date timestamp,
list_product varchar(255),
playment_method varchar(255),
client_id integer REFERENCES client (id)
);
INSERT INTO purchase (date, list_product, playment_method, client_id )
VALUES
('2020-05-03 15:05:06', 'milk', 'money', 1),
('2020-05-25 15:45:06', 'milk', 'money', 2),
('2020-05-04 09:05:06', 'milk', 'card', 3),
('2020-05-06 14:05:06', 'milk', 'card', 4),
('2020-05-14 16:23:06', 'milk', 'money', 5),
('2020-05-09 11:15:06', 'milk', 'card', 6),
('2020-05-12 12:01:06', 'milk', 'card', 7),
('2020-05-12 13:02:06', 'milk', 'money', 8),
('2020-05-30 14:35:06', 'milk', 'money', 9),
('2020-05-20 15:25:06', 'milk', 'money', 10);

INSERT INTO purchase (date, list_product, playment_method, client_id )
VALUES
('2020-05-03 15:05:06', 'мясо', 'money', 1),
('2020-05-31 15:05:06', 'мясо', 'money', 1),
('2020-06-01 17:05:06', 'мясо', 'money', 1);

INSERT INTO purchase (date, list_product, playment_method, client_id )
VALUES
('2020-05-26 19:05:06', 'milk', 'money', 2),
('2020-05-27 15:05:06', 'milk', 'money', 2);


CREATE TABLE purchase_product (
amount integer,
purchase_id integer,
product_id integer,
PRIMARY KEY(purchase_id , product_id)
);
INSERT INTO purchase_product (amount, purchase_id, product_id )
VALUES
('2', 1,2),
('1', 2,2),
('3', 3,2),
('4', 4,2),
('2', 5,2),
('2', 6,2),
('4', 7,2),
('3', 8,2),
('2', 9,2),
('1', 10,2);

INSERT INTO purchase_product (amount, purchase_id, product_id )
VALUES
('1', 14,2),
('1', 15,2);

INSERT INTO purchase_product (amount, purchase_id, product_id )
VALUES
('1', 11,1),
('1', 12,1),
('1', 13,1);

----
CREATE TABLE discount (
id serial PRIMARY KEY,
name varchar(255),
description varchar(255),
type varchar(255),
product_id integer REFERENCES product (id)
);
INSERT INTO discount (name, description, type, product_id )
VALUES
('low prices', 'низкие цены на все', '1', 1),
('very low prices', 'низкие цены', '1', 1),
('happy', 'cool цены на все', '2', 5),
('one day', '1 day низкие цены на все', '3', 1),
('new weekends', 'низкие цены на все weekends', '1', 1),
('goods ptoduct', 'низкие цены на все продукты', '2', 1),
('up', 'низкие цены на все', '1', 1),
('puch', 'низкие цены на все', '4', 4),
('hey milk', 'низкие цены на все', '4', 4),
('hey meat', 'низкие цены на все', '4', 4);


CREATE TABLE loyalty_card (
id serial PRIMARY KEY,
name varchar(255),
create_data timestamptz,
amount_of_expenses bigint,
card_expiration_date timestamptz,
discount_id integer REFERENCES discount (id)
);

INSERT INTO loyalty_card (name, create_data, amount_of_expenses, card_expiration_date,discount_id )
VALUES
('loyalty_card1', '2019-05-01', '500', '2029-05-07', 1),
('loyalty_card2', '2019-02-07', '500', '2029-05-07', 2),
('loyalty_card3', '2019-04-03', '500', '2029-05-07', 3),
('loyalty_card4', '2019-08-07', '500', '2029-05-07', 4),
('loyalty_card5', '2019-07-20', '500', '2029-05-07', 5),
('loyalty_card6', '2019-09-13', '500', '2029-05-07', 6),
('loyalty_card7', '2019-12-07', '500', '2029-05-07', 7),
('loyalty_card8', '2019-11-15', '500', '2029-05-07', 8),
('loyalty_card9', '2019-10-10', '500', '2029-05-07', 9),
('loyalty_card10', '2019-05-11', '500', '2029-05-07', 10);


CREATE TABLE special_discount (
id serial PRIMARY KEY,
name varchar(255),
description varchar(255),
access_for_client varchar(255) UNIQUE,
loyalty_card_id integer REFERENCES loyalty_card (id)
);
INSERT INTO special_discount (name, description, access_for_client, loyalty_card_id )
VALUES
('special client', 'for special client', '11', 1),
('special client', 'for special client', '22', 2),
('special client', 'for special client', '33', 3),
('special client', 'for special client', '44', 4),
('special client', 'for special client', '55', 5),
('special client', 'for special client', '66', 6),
('special client', 'for special client', '77', 7),
('special client', 'for special client', '88', 8),
('special client', 'for special client', '99', 9),
('special client', 'for special client', '101', 10);


COMMIT;


-------------------- Запросы на спроектированную БД---------------------------

--1) Для заданного города выведите ближайшие открытия магазинов

SELECT *
FROM store st
WHERE now() < st.open_date
  AND st.adress = 'Kimry'
ORDER BY st.open_date;
-- 2) Для заданного магазина вывести расписание работы его сотрудников на завтрашний день.

SELECT w.name,
       t.date_begin,
       t.date_finish
FROM worker w
INNER JOIN timetable t ON w.id = t.id
WHERE w.store = 2
  AND t.date_number > now()::date + (1)::integer ;
-- ближайшая дата 23.05 последней записи , примерно - (30)::integer

-- 3) Выведите клиентов, которые в любых магазинах компании за последние 14 дней потратили более 10000 рублей на покупки.

	select cl.id as c, cl.name as n, count(Distinct pu.id)::real as pushes, sum(pr.price) as s
	from client cl
	inner join purchase pu ON cl.id = pu.client_id
	inner join purchase_product pp ON pu.id = pp.purchase_id
	inner join product pr ON pp.product_id = pr.id
	inner join price_history ph ON ph.product_id = pr.id
	where pu.date > now()::date - (14)::integer
	group by cl.id
	Having sum(pr.price)>10000
    ORDER BY sum(pr.price) DESC;
--таковых нет, так как макимум 2000

-- 4) Выведите 10% (можете увеличить процент) клиентов, которые потратили за последние 240 часов наибольшую сумму.

	select cl.id, cl.name as n, count(Distinct pu.id)::real as pushes, sum(pr.price) as summ
	from client cl
	inner join purchase pu ON cl.id = pu.client_id
	inner join purchase_product pp ON pu.id = pp.purchase_id
	inner join product pr ON pp.product_id = pr.id
	inner join price_history ph ON ph.product_id = pr.id
	where pu.date > now()::date - (240/24)::integer
	group by cl.id
    ORDER BY sum(pr.price) DESC
  limit (SELECT COUNT (*)/10 FROM CLIENT);

-- 5) На основе предыдущего запроса (сделайте его WITH) посчитайте среднюю сумму, потраченную этими клиентами.

WITH top_client AS
  (SELECT cl.id AS i,
          cl.name AS n,
          count(DISTINCT pu.id)::numeric AS pushes,
          sum(pr.price) AS summ
   FROM client cl
   INNER JOIN purchase pu ON cl.id = pu.client_id
   INNER JOIN purchase_product pp ON pu.id = pp.purchase_id
   INNER JOIN product pr ON pp.product_id = pr.id
   INNER JOIN price_history ph ON ph.product_id = pr.id
   WHERE pu.date > now()::date - (240/24)::integer
   GROUP BY cl.id
   ORDER BY sum(pr.price) DESC
   LIMIT
     (SELECT COUNT (*)/10
      FROM CLIENT)
), average_amount AS
  (SELECT tc.i AS i,
          tc.n AS n,
          tc.summ AS average
   FROM top_client tc)
SELECT aa.n,
       (aa.average/tc.pushes)::real AS average_amount
FROM top_client tc
INNER JOIN average_amount aa ON tc.i = aa.i
AND tc.summ = aa.average;

-- 6) За последние 4 недели выведите проданное количество единиц товара (В формате: ID, Название товара, 1,2,3, 4 недели).

SELECT pr.id,
       pr.name,
       CASE
           WHEN pu.date < now() AND pu.date > now()::date - (7)::integer THEN pp.amount
       END AS "1 неделя",
       CASE
           WHEN pu.date < now()::date - (7)::integer AND pu.date > now()::date - (14)::integer THEN pp.amount
       END AS "2 неделя",
       CASE
           WHEN pu.date < now()::date - (14)::integer AND pu.date > now()::date - (21)::integer THEN pp.amount
       END AS "3 неделя",
       CASE
           WHEN pu.date < now()::date - (21)::integer AND pu.date > now()::date - (28)::integer THEN pp.amount
       END AS "4 неделя"
FROM product pr
INNER JOIN purchase_product pp ON pr.id = pp.purchase_id
INNER JOIN purchase pu ON pp.purchase_id = pu.id;

-- 7) Сравните количество единиц товара на складе с полученными в результате предыдущего запроса данными. Вывести нужно те товары и их количество, которого не хватит на неделю исходя из статистики 4-х прошедших недель.

SELECT pr.id,
       pr.name,
       rp.amount,
       CASE
           WHEN pu.date < now()::date AND pu.date > now()::date - (28)::integer THEN pp.amount
       END AS "4 неделя"
FROM product pr
INNER JOIN purchase_product pp ON pr.id = pp.purchase_id
INNER JOIN purchase pu ON pp.purchase_id = pu.id
INNER JOIN product_in_store pis ON pr.id = pis.product_id
INNER JOIN registration_product rp ON pis.product_id = rp.id
WHERE rp.amount<pp.amount;
----таковых нет, так как под условие WHERE (rp.amount<pp.amount) никто не попал

-- 8) Для заданного сотрудника выведите его месячный график работы.

SELECT w.name,
       t.worker_id,
       t.date_number
FROM worker w
INNER JOIN timetable t ON w.id = t.worker_id
WHERE w.id = 6
  AND t.date_number BETWEEN '2020/05/01' AND '2020/05/31';

-- 9) Для всех товаров в магазине выведите цену в таком виде:

  SELECT product.id,
         product.name,
         CASE
             WHEN second_week.price IS NULL THEN 'нет инф.'
             ELSE second_week.price::varchar
         END AS "-2 недели",
         CASE
             WHEN first_week.price IS NULL THEN 'нет инф.'
             ELSE first_week.price::varchar
         END AS "-1 недели",
         CASE
             WHEN current_week.price IS NULL THEN 'нет инф.'
             ELSE current_week.price::varchar
         END AS "Текущая",
         CASE
             WHEN next_week.price IS NULL THEN 'нет инф.'
             ELSE next_week.price::varchar
         END AS "След неделя",
         CASE
             WHEN after_2_week.price IS NULL THEN 'нет инф.'
             ELSE after_2_week.price::varchar
         END AS "+2 недели"
  FROM product
  LEFT JOIN
    (SELECT *
     FROM price_history
     WHERE date < now()::date - (7)::integer AND date > now()::date - (14)::integer ) second_week ON product.id = second_week.product_id
  LEFT JOIN
    (SELECT *
     FROM price_history
     WHERE date < now() AND date > now()::date - (7)::integer ) first_week ON product.id = first_week.product_id
  LEFT JOIN
    (SELECT *
     FROM price_history
     WHERE date > now() AND date < now()::date + (7)::integer ) current_week ON product.id = current_week.product_id
  LEFT JOIN
    (SELECT *
     FROM price_history
     WHERE date > now()::date + (7)::integer AND date < now()::date + (14)::integer ) next_week ON product.id = next_week.product_id
  LEFT JOIN
    (SELECT *
     FROM price_history
     WHERE date > now()::date + (14)::integer AND date < now()::date + (21)::integer ) after_2_week ON product.id = after_2_week.product_id;

--10) Для каждого клиента найдите самый частый день недели и время его посещения магазина.

SELECT CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 1 THEN cl.id
       END AS "пн",
       CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 2 THEN cl.id
       END AS "вт",
       CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 3 THEN cl.id
       END AS "ср",
       CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 4 THEN cl.id
       END AS "чт",
       CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 5 THEN cl.id
       END AS "пт",
       CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 6 THEN cl.id
       END AS "сб",
       CASE
           WHEN extract(dow FROM pu.date::TIMESTAMP) = 0 THEN cl.id
       END AS "вс"
FROM client cl
INNER JOIN purchase pu ON cl.id = pu.client_id;

-- 11) Клиент может отказаться от карты лояльности, в таком случае, согласно GDPR хранить его данные нельзя.
-- Объясните, как правильно организовать такое удаление, напишите запрос(ы).

BEGIN;

UPDATE purchase
SET client_id = NULL
WHERE id = '10';

DELETE
FROM client
WHERE id = '10';

COMMIT;


--12) Для заданного поставщика выведите в заданном магазине сотрудника, который принимал их товар наибольшее количество раз.

SELECT r.worker_id,
       count(*) AS prinyal_raz
FROM registration_product r
WHERE r.store_id = 6
  AND supplier_id = 10
GROUP BY r.worker_id
HAVING count(*) =
  (SELECT max(prinyal_raz)
   FROM
     (SELECT r.worker_id,
             count(*) AS prinyal_raz
      FROM registration_product r
      WHERE r.store_id = 6
        AND supplier_id = 10
      GROUP BY r.worker_id) t1); 

--13) Посчитайте относительную (напр.: 25%) и абсолютную (напр.: 35 р.) наценку на каждый товар в момент последней поставки.

SELECT rp.id,
       rp.information,
       rp.price,
       pr.price,
       sum(pr.price - rp.price) AS "абсолютная наценка",
       ((pr.price - rp.price)/rp.price)*100 AS "странные проценты"
FROM product pr
INNER JOIN product_in_store pis ON pr.id = pis.product_id
INNER JOIN registration_product rp ON pis.product_id = rp.id
WHERE rp.date BETWEEN '2020/05/01' AND '2020/05/5'
GROUP BY rp.id,
         rp.information,
         rp.price,
         pr.price ;

--14) Посчитайте для каждого магазина доходы и расходы на последнюю неделю. Подумайте, какая очевидная проблема есть в расчёте и как можно её устранить.

SELECT rp.id,
       rp.information,
       rp.price,
       pr.price,
       pp.amount,
       (pr.price - rp.price)*pp.amount AS "доход"
FROM product pr
INNER JOIN purchase_product pp ON pr.id = pp.product_id
INNER JOIN purchase pu ON pp.product_id = pu.id
INNER JOIN product_in_store pis ON pr.id = pis.product_id
INNER JOIN registration_product rp ON pis.product_id = rp.id
WHERE pu.date < now()
  AND pu.date > now()::date - (7)::integer
  AND rp.date < now()
  AND rp.date > now()::date - (35)::integer;

--AND rp.date > now()::date - (35)::integer - потому что в начале мая был привоз

--15) Появилась задача хранить зарплаты сотрудников. Подумайте, как можно это хранить и напишите запрос для изменения базы данных. Бухгалтерия сообщила, что самая распространённая з/п - 30000, 

BEGIN;

ALTER TABLE worker ADD salary bigint NOT NULL DEFAULT '30000';

UPDATE worker
SET salary = 25000
WHERE position = 'продавец';

UPDATE worker
SET salary = 35000
WHERE name = 'Oleg';

COMMIT;
