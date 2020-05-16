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
('�������', '171504', '1999-02-15','2005-02-11', 'Kimry'), 
('����������', '171501', '1999-03-14',NULL, 'Dubna'),
('����������', '171502', '1999-04-26',NULL, 'Dubna'),
('���', '171503', '2001-05-15',NULL, 'Moscow'),
('����', '171503', '2001-06-15',NULL, 'Moscow'), --5
('���', '171503', '2001-07-15',NULL, 'Moscow'),
('�����', '171525', '2002-11-02', NULL, 'Tver'),
('����', '171526', '2005-02-13', '1991-02-15', 'Tver'),
('�����', '171526', '2007-09-20', '1991-02-15', 'Tver'),
('�������', '171526', '2010-07-26', NULL, 'Tver');

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
('��������', '�������� ���������� ��������', '1998-02-15','2005-02-15', 'Moscow'), 
('�������', '�������� ���������� ��������', '2005-03-14',NULL, 'Moscow'),
('��������������1', '�������������� ���������� ��������', '1999-04-26',NULL, 'Dubna'),
('��������������2', '�������������� ���������� ��������', '2001-05-15',NULL, 'Moscow'),
('��������������3', '�������������� ���������� ��������', '2002-06-15',NULL, 'Moscow'),
('��������������4', '�������������� ���������� ��������', '2003-07-15',NULL, 'Moscow'),
('��������', '�������� ���������� ��������', '2004-11-02', NULL, 'Tver'),
('���������', '��������� ���������� ��������', '2005-02-13', NULL, 'Moscow'),
('�������������', '������������� ���������� ��������', '2007-09-20',NULL, 'Tver'),
('�������', '������� ���������� ��������', '2001-07-26', NULL, 'Tver');

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
/*ON DELETE CASCADE*/--������ ��� ������
/*ON DELETE set null*/--������� ��� �������� ����������
ON DELETE NO ACTION*/
);

INSERT INTO unit (name, description, kind_of_activity, open_date, close_date, department_id)
VALUES
('�����1', '����� ������������ ����������� ����������','����������','1998-02-15','2005-02-15', 1), 
('�����2', '����� ������������ �������������� ��������','����������','2005-03-14',NULL, 2),
('�����3', '����� ������������ ������� ��������','����������', '1999-04-26',NULL, 4),
('�����4', '����� ������������ ���������', '����������','2001-05-15',NULL, 5),
('�����5', '����� ������������ ����������� ����������','����������', '2005-02-16',NULL, 2),
('�����6', '����� ������������ ����������', '����������','1998-02-15',NULL, 6),
('�����7', '����� ������������ ������� �������','����������', '1998-02-15',NULL, 7),
('�����8', '����� ������������ ������������� ��������������','����', '2002-06-15',NULL, 8),
('�����9', '����� ������������ ��������','����������', '2002-06-15',NULL, 9),
('�����10', '����� ��� �����������','���?','2002-06-15',NULL, 10);

CREATE TABLE worker (
id serial PRIMARY KEY,
name varchar(255),
surname varchar(255),
position varchar(255),
registration bigint UNIQUE,
number_phone bigint UNIQUE,
email varchar(255)UNIQUE,
birth_day timestamptz,
unit_id integer REFERENCES unit (id)
);

INSERT INTO worker (name, surname, position, registration, number_phone, email,birth_day,unit_id)
VALUES
('����', '������','��������','115431','89800553535', 'petrov@gmail.com', '1989-02-21', 1), 
('�����', '��������','�����������','115433','89800553536', 'bel@gmail.com', '1990-02-11', 5), 
('����', '�������','��������','115437','89800553537', 'vs@gmail.com', '1989-02-26', 4), 
('����', '��������','��������','115423','89800553538', 'ya@gmail.com', '1990-04-26', 4), 
('������', '�����','��������','115422','89800553539', 'clava@gmail.com', '1999-12-26', 4), 
('������', '������','���������','114531','89800553545', 'km@gmail.com', '1956-11-26', 2), -- 6
('����', '������','��������','119431','89800553555', 'venchik@gmail.com', '1977-05-26', 6), 
('����', '�������','��������','125431','89800553635', 'pavel@gmail.com', '1976-02-21', 3), 
('����', '������','HR-����','115504','89800553575', 'kostin@gmail.com', '1987-07-16', 8), 
('�����', '������','�������������','112221','89800553935', 'bragin@gmail.com', '1990-01-16', 5), 
('������', '�����','������ �� ������','215431','89820553535', 'anonymous@gmail.com', '1989-02-16', 9), 
('�����', '�������','������������ ��� ��������','325431','89844553535', 'sokol@gmail.com', '1968-02-16', 10), 
('����', '�������','�������','225431','89230553535', 'oleg@gmail.com', '1986-03-26', 5), 
('������', '������','�����','445431','89430553535', 'den@gmail.com', '1987-04-26', 9); 
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
('�������� ���������', 'Moscow','��������',133123),
('�������� ���������', 'Dubna',' ����������',133255),
('������ ���������', 'Moscow','��������',444123),
('������ ���������', 'Moscow',' ����������',111123),
('�������', 'Dubna','��������',222123),-- 5
('��������', 'Moscow','��������',666123),
('�������', 'Moscow','��������',133777),
('�����', 'Dubna','��������',868123),
('������', 'Moscow','��������',133888),
('����', 'Moscow','��������',133223),
('��������', 'Moscow','��������',133923);



CREATE TABLE registration_product (
id serial PRIMARY KEY,
information varchar(255),
waybill integer,
requisites varchar(255) UNIQUE,
worker_id integer REFERENCES worker (id),
store_id integer REFERENCES store (id),
supplier_id integer REFERENCES supplier (id)
);
INSERT INTO registration_product (information, waybill, requisites, worker_id, store_id, supplier_id )
VALUES
('��������� ����', '100','general in mir1', 6, 4, 3),
('��������� �������', '50','general in trud1', 6, 5, 1),
('��������� �������', '20','general in may1', 6, 6, 5),
('��������� �������', '25','general in mir2', 6, 4, 6),
('��������� ����', '56','general in 22trud', 6, 5, 7),
('��������� ����', '234','general in 33may2', 6, 6, 8),
('��������� ����', '12','general in 44mir3', 6, 4, 9),
('��������� ����', '33','general in 55trud2', 6, 5, 10),
('��������� ����', '656','general in66 may3', 6, 6, 10),
('��������� ����', '33','general in 77mir4', 6, 4, 11),
('��������� ��������', '100','general in 88trud2', 6, 5, 11),
('��������� ��������', '100','general in 99may4', 6, 6, 11),
('��������� ��������', '100','general in 00may5', 6, 6, 11);

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
('����', '1','500', '������ �������', ' 1',' 1'),
('������', '2','40', '�������� �������', '1','1'),
('����', '3','35', '������������� �������', '1','1'),
('�������', '3','25', '������������� �������', '1','1'),
('�������', '3','50', '������������� �������', '1','1'),
('��������', '4','90', '�����', '1','1'),
('���', '5','90', '�������', '1','1'),
('�������', '1','200', '������ �������', '1','1'),
('�������', '2','60', '�������� �������', '1','1'),
('�����', '10','400', '����������� �������', '1','1');



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
('kilogram', '0,5', 1),-- �������� ��������
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
('2019-05-03 15:05:06', 'milk', 'money', 1),
('2019-05-04 15:45:06', 'milk', 'money', 2),
('2019-05-05 09:05:06', 'milk', 'card', 3),
('2019-05-06 14:05:06', 'milk', 'card', 4),
('2019-05-07 16:23:06', 'milk', 'money', 5),
('2019-05-09 11:15:06', 'milk', 'card', 6),
('2019-05-11 12:01:06', 'milk', 'card', 7),
('2019-05-12 13:02:06', 'milk', 'money', 8),
('2019-05-13 14:35:06', 'milk', 'money', 9),
('2019-05-14 15:25:06', 'milk', 'money', 10);

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
('low prices', '������ ���� �� ���', '1', 1),
('very low prices', '������ ����', '1', 1),
('happy', 'cool ���� �� ���', '2', 5),
('one day', '1 day ������ ���� �� ���', '3', 1),
('new weekends', '������ ���� �� ��� weekends', '1', 1),
('goods ptoduct', '������ ���� �� ��� ��������', '2', 1),
('up', '������ ���� �� ���', '1', 1),
('puch', '������ ���� �� ���', '4', 4),
('hey milk', '������ ���� �� ���', '4', 4),
('hey meat', '������ ���� �� ���', '4', 4);


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