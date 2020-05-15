1.Однотабличные запросы
Select *
from students
where n_group = 2072
1)
SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score BETWEEN 4 and 4.5

SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score NOT BETWEEN 4.5 AND 5

SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score <=4.5 and st.score >=4

SELECT st.name, st.surname, st.score
FROM students st
WHERE NOT st.score >=4.5 AND st.score >=4

SELECT st.name, st.surname, st.score
FROM students st
WHERE NOT st.score >=4.5 OR NOT st.score >=4//(or NOT score >=4)- не имеет смысловой нагрузки

SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score NOT IN
(4.85, 4.75)
2)
SELECT CAST (st.score AS varchar)
FROM students st
WHERE st.surname LIKE '%';
3)
SELECT *
FROM students st
ORDER BY st.n_group DESC,st.name ASC
4)
SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score >4
ORDER BY st.score DESC
5)
SELECT h.name, h.risk
FROM hobbies h
WHERE h.name
LIKE 'Ф%'
OR h.name LIKE 'Х%'
6)
SELECT sh.student_id, sh.hobby_id, sh.date_start, sh.date_finish
FROM students_hobbies sh
WHERE sh.date_start BETWEEN '2012/02/08' AND '2015/03/10' 
AND sh.date_finish IS NULL
7)
SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score >4.5
ORDER BY st.score DESC
8)
SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score >4.5
ORDER BY st.score DESC
LIMIT 5

SELECT st.name, st.surname, st.score
FROM students st
WHERE st.score >4.5
ORDER BY st.score DESC FETCH FIRST 5 ROWS ONLY
9)
SELECT
CASE
WHEN h.risk>=8 THEN 'очень высокий'
WHEN h.risk>=6 AND h.risk<8 THEN 'высокий'
WHEN h.risk>=4 AND h.risk<8 THEN 'средний'
WHEN h.risk>=2 AND h.risk<4 THEN 'низкий'
 ELSE 'очень низкий'
END
FROM hobbies h
10)
SELECT h.name, h.risk
FROM hobbies h
WHERE NOT h.risk >=9999
ORDER BY h.risk DESC
LIMIT 3
--Групповые функции
--1)Выведите на экран номера групп и количество студентов, обучающихся в них
SELECT st.n_group, count(*)
FROM students st
GROUP BY st.n_group
ORDER BY st.n_group DESC;
--2)Выведите на экран для каждой группы максимальный средний балл
SELECT st.n_group, max(st.score)
FROM students st
GROUP BY st.n_group
ORDER BY st.n_group DESC;
--3)Подсчитать количество студентов с каждой фамилией
SELECT COUNT(DISTINCT st.surname)
FROM students st;
--5)Для студентов каждого курса подсчитать средний балл
SELECT substring (st.n_group::varchar, 1, 1) , count (*), st.n_group, st.name, st.surname,avg(st.score)
FROM students st
GROUP BY substring (st.n_group::varchar, 1, 1), st.n_group, st.name, st.surname
ORDER BY st.n_group DESC;
--6)Для студентов заданного курса вывести один номер групп с максимальным средним баллом
SELECT substring (st.n_group::varchar, 1, 1) , count (DISTINCT st.n_group), st.n_group, MAX(st.score)
FROM students st
GROUP BY substring (st.n_group::varchar, 1, 1), st.n_group
ORDER BY st.n_group DESC;
--7)Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл, в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.
SELECT st.n_group, st.name, st.surname,avg(st.score)
FROM students st
GROUP BY st.n_group, st.name, st.surname
ORDER BY st.n_group DESC;
--8)Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе, средний балл в группе, минимальный балл в группе
SELECT st.n_group,COUNT(DISTINCT st.surname), max(st.score), avg(st.score), min(st.score)
FROM students st
GROUP BY st.n_group
ORDER BY st.n_group DESC;
--9)Вывести студента/ов, который/ые имеют наибольший балл в заданной группе
SELECT st.n_group, st.name, st.surname, st.score
FROM students st
WHERE st.score = (SELECT MAX(st.score)FROM students st) AND st.n_group = 2074;
--10)Аналогично 9 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом.
SELECT st.n_group , st.name, st.surname, st.score
FROM students st
WHERE st.score = (SELECT MAX(st.score)FROM students st)
GROUP BY st.n_group
ORDER BY st.n_group DESC;
--Многотабличные запросы
--1)Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.

SELECT st.surname,
       st.name,
       h.name
FROM students st,
     hobbies h;

--2)Вывести информацию о студенте, занимающимся хобби самое продолжительное время.

SELECT *
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
WHERE sh.date_finish IS NOT NULL
  AND CASE
          WHEN sh.date_finish IS NULL THEN age(now(), date_start) =
                 (SELECT MAX(age (sh.date_finish, sh.date_start))
                  FROM students_hobbies sh)
          ELSE age (sh.date_finish, sh.date_start) =
                 (SELECT MAX(age (sh.date_finish, sh.date_start))
                  FROM students_hobbies sh)
      END;

--3)Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего,
--а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.

SELECT st.name,
       st.surname,
       st.birth_date,
       avg(score),
       sum(h.risk)
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id
WHERE sh.date_finish IS NULL
GROUP BY st.name,
         st.surname,
         st.score,
         st.birth_date
HAVING sum(h.risk) > 0.9
AND st.score >
  (SELECT avg(score)
   FROM students);

--4)Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби.

SELECT st.*,
       EXTRACT (MONTH
                FROM age(sh.date_finish, sh.date_start)) + extract(YEAR FROM age(sh.date_finish, sh.date_start)*12) +EXTRACT (YEAR
                                                                                                                         FROM now())*12
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
WHERE sh.date_finish IS NOT NULL;

--5)Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.
--explain analyze

SELECT ST.*
FROM students st
INNER JOIN
  (SELECT sh.student_id
   FROM StUDENTS_HOBBIES sh
   WHERE sh.date_finish IS NULL
   GROUP BY sh.student_id
   HAVING count(*)>1) t ON st.id = t.student_id; 
--6)Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.

SELECT n_group,
       avg(score)
FROM students st,
     students_hobbies sh
WHERE (sh.date_finish IS NOT NULL)
GROUP BY n_group;

--7)Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента и номер его группы.

SELECT h.name,
       h.risk,
       extract(YEAR
               FROM age(sh.date_finish, sh.date_start))*12 + extract(MONTH FROM age(sh.date_finish, sh.date_start))
FROM hobbies h
INNER JOIN students_hobbies sh ON h.id = sh.hobby_id
INNER JOIN students st ON sh.student_id = st.id
WHERE sh.date_finish IS NOT NULL
  AND age (sh.date_finish, sh.date_start) =
    (SELECT MAX(age (sh.date_finish, sh.date_start))
     FROM students_hobbies sh)
  AND st.n_group = 2074;

--8)Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.

SELECT st.surname,
       h.name,
       st.score
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON h.id = sh.hobby_id
AND st.score =
  (SELECT MAX(st.score)
   FROM students st);

--9)Найти все действующие хобби, которыми увлекаются отличники 2-го курса.

SELECT st.surname,
       h.name,
       st.score,
       st.n_group,
       SUBSTRING (st.n_group::varchar, 1, 1)
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON h.id = sh.hobby_id
WHERE sh.date_finish IS NULL
  AND substring(st.n_group::varchar, 1, 1) = '2'
GROUP BY SUBSTRING (st.n_group::varchar, 1, 1),st.surname,
                       h.name,
                       st.score,
                       st.n_group;

--10)Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.

WITH all_students AS
  (SELECT SUBSTRING (st.n_group::varchar, 1, 1) AS course,
                    COUNT(st.id)::real AS c
   FROM students st
   GROUP BY SUBSTRING (st.n_group::varchar, 1, 1)),
     STUDENTS_WITH_HOBBIES AS
  (SELECT SUBSTRING (st.n_group::varchar, 1, 1)AS course,
                    COUNT(DISTINCT st.id)::real AS c
   FROM students st
   INNER JOIN STUDENTS_HOBBIES SH ON st.id = sh.student_id
   WHERE sh.date_finish IS NULL
   GROUP BY SUBSTRING (st.n_group::varchar, 1, 1))
SELECT a_s.course
FROM all_students a_s
INNER JOIN STUDENTS_WITH_HOBBIES swh ON a_s.course = swh.course
WHERE swh.c/a_s.c>0.3;

--11)Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.

  SELECT st.n_group
  FROM students st
  INNER JOIN
    (SELECT st.n_group
     FROM students st
     WHERE st.score > 4 ) t ON st.n_group = t.n_group WHERE t.n_group/st.n_group>0.6
GROUP BY st.n_group ;

--12)Для каждого курса подсчитать количество различных действующих хобби на курсе.

SELECT SUBSTRING (st.n_group::varchar, 1, 1) AS course,
                 COUNT(DISTINCT sh.student_id)::real AS c
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
WHERE sh.date_finish IS NULL
GROUP BY SUBSTRING (st.n_group::varchar, 1, 1);

--13)Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби.
--Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.

SELECT st.name,
       st.surname,
       st.birth_date,
       st.score
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id
WHERE sh.date_finish IS NOT NULL
  AND score>4.5
ORDER BY st.birth_date DESC;

--14)Создать представление, в котором отображается вся информация о студентах,
-- которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.

SELECT st.*,
       extract(YEAR
               FROM age(sh.date_finish, sh.date_start))
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
WHERE extract(YEAR
              FROM age(sh.date_finish, sh.date_start)) >5
ORDER BY sh.date_start;

--15) Для каждого хобби вывести количество людей, которые им занимаются.

SELECT count(st.id) AS id,
       h.name
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id
GROUP BY h.name;

--16)Вывести ИД самого популярного хобби.

SELECT count(sh.student_id) AS id,
       h.name
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id
GROUP BY hobby_id,
         h.name
ORDER BY id DESC
LIMIT 1;

--17)Вывести всю информацию о студентах, занимающихся самым популярным хобби.

SELECT ST.*,
       sh.id
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN
  (SELECT count(sh.student_id) AS c,
          sh.hobby_id
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
   WHERE sh.date_finish IS NULL
   GROUP BY sh.hobby_id
   ORDER BY c DESC
   LIMIT 1
	)p_h ON p_h.hobby_id = sh.hobby_id;

--18)Вывести ИД 3х хобби с максимальным риском.

SELECT h.risk,
       h.id,
       h.name
FROM hobbies h
ORDER BY risk DESC
LIMIT 3;

--19)Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

SELECT *
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
WHERE sh.date_finish IS NULL
ORDER BY sh.date_start
LIMIT 10;

--20)Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.

SELECT st.n_group
FROM students st
INNER JOIN
  (SELECT *
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
   WHERE sh.date_finish IS NULL
   ORDER BY sh.date_start
   LIMIT 10
   ) t ON st.n_group = t.n_group
GROUP BY st.n_group;

 --21)Создать представление, которое выводит номер зачетки, имя и фамилию студентов, отсортированных по убыванию среднего балла.

WITH all_students AS
    (SELECT st.name,
            st.surname,
            avg(score)
     FROM students st
     GROUP BY st.name,
              st.surname,
              score
     ORDER BY score DESC)
  SELECT a_s.*
  FROM all_students a_s;

--22)Представление: найти каждое популярное хобби на каждом курсе.

WITH c_hobbies AS
  (SELECT substr(st.n_group::varchar, 1, 1) AS course,
          sh.hobby_id,
          count(*) AS c
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
   GROUP BY substr(st.n_group::varchar, 1, 1),
            sh.hobby_id),  max_for_course AS (
SELECT c_h.course,
   max(c) AS max_c
   FROM c_hobbies c_h
   GROUP BY c_h.course
   )
SELECT c_h.course,
       c_h.hobby_id
FROM c_hobbies c_h
INNER JOIN max_for_course mfc ON c_h.course = mfc.course
AND c_h.c = mfc.max_c;

 --23)Представление: найти хобби с максимальным риском среди самых популярных хобби на 2 курсе.

WITH c_hobbies AS
  (SELECT substr(st.n_group::varchar, 1, 1) AS course,
          sh.hobby_id,
          count(*) AS c,
          MAX(h.risk)
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
   INNER JOIN hobbies h ON sh.hobby_id = h.id
   WHERE substr(st.n_group::varchar, 1, 1) = '2'
   GROUP BY substr(st.n_group::varchar, 1, 1),
            sh.hobby_id
   HAVING MAX(h.risk) > 8
   ), max_for_course AS
  (SELECT c_h.course,
          c_h.c
   FROM c_hobbies c_h
   GROUP BY c_h.course,
            c_h.c
   ORDER BY c_h.c DESC
   LIMIT 1
   )
SELECT c_h.course,
       c_h.hobby_id
FROM c_hobbies c_h
INNER JOIN max_for_course mfc ON c_h.course = mfc.course
AND c_h.c = c_h.c;

 --24)Представление: для каждого курса подсчитать количество студентов на курсе и количество отличников.

WITH all_students AS
    (SELECT SUBSTRING (st.n_group::varchar, 1, 1) AS course,
                      COUNT(st.id)::real AS c
     FROM students st
     GROUP BY SUBSTRING (st.n_group::varchar, 1, 1)),
     STUDENTS_otl AS
    (SELECT SUBSTRING (st.n_group::varchar, 1, 1)AS course ,
                      COUNT (DISTINCT st.n_group), MAX(st.score)
     FROM students st
     GROUP BY SUBSTRING (st.n_group::varchar, 1, 1))
  SELECT a_s.course,
         swh.count
  FROM all_students a_s
  INNER JOIN STUDENTS_otl swh ON a_s.course = swh.course;
--25)Представление: самое популярное хобби среди всех студентов.
WITH all_students AS
  (SELECT st.*
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
    ), popular AS
  (SELECT count(sh.student_id) AS id,
          h.name
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
   INNER JOIN hobbies h ON sh.hobby_id = h.id
   GROUP BY hobby_id,
            h.name
   ORDER BY id DESC
   LIMIT 1
   )
SELECT pop.id,
       pop.name
FROM all_students a_s
INNER JOIN popular pop ON a_s.id = pop.id;

--26)Создать обновляемое представление.
/*CREATE VIEW view_lev2 AS (
SELECT 'now'::timestamp, now()
)*/
SELECT *
FROM view_lev2;
 --27)Для каждой буквы алфавита из имени найти максимальный, средний и минимальный балл.
--(Т.е. среди всех студентов, чьё имя начинается на А (Алексей, Алина, Артур, Анджела)
--найти то, что указано в задании. Вывести на экран тех, максимальный балл которых больше 3.6

SELECT SUBSTRING (st.name, 1, 1), max(st.score),
                      min(st.score),
                      avg(st.score)
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
GROUP BY SUBSTRING (st.name, 1, 1)
HAVING MAX(st.score) > 3.6;

 --28)Для каждой фамилии на курсе вывести максимальный и минимальный средний балл.
-- (Например, в университете учатся 4 Иванова (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 4.1,
-- 4, 3.8 соответственно, а 4 Иванов учится на 3 курсе и имеет балл 4.5. На экране должно быть следующее:
-- 2 Иванов 4.1 3.8 3 Иванов 4.5 4.5)

SELECT SUBSTRING (st.n_group::varchar, 1, 1) AS course,
                 substring(st.surname, 1, 1),
                 max(st.score),
                 min(st.score),
                 count(*)
FROM students st
GROUP BY SUBSTRING (st.n_group::varchar, 1, 1), st.surname

 --29)Для каждого года рождения подсчитать количество хобби, которыми занимаются или занимались студенты.

  SELECT st.birth_date,
         COUNT(DISTINCT sh.student_id)::real
  FROM students st
  INNER JOIN students_hobbies sh ON st.id = sh.student_id
GROUP BY st.birth_date ;

--30)Для каждой буквы алфавита в имени найти максимальный и минимальный риск хобби.

SELECT SUBSTRING (st.name, 1, 1), max(h.risk),
                      min(h.risk)
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id
GROUP BY SUBSTRING (st.name, 1, 1);

--31)Для каждого месяца из даты рождения вывести средний балл студентов, которые занимаются хобби с названием «Футбол»

SELECT extract(MONTH FROM(st.birth_date)),
       avg(st.score)
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id
WHERE h.name = 'Футбол'
GROUP BY extract(MONTH FROM(st.birth_date));

--32)Вывести информацию о студентах, которые занимались или занимаются хотя бы 1 хобби в следующем формате:
-- Имя: Иван, фамилия: Иванов, группа: 1234

SELECT CONCAT(st.name,' ', st.surname, ' ',st.n_group)
FROM students st
INNER JOIN students_hobbies sh
ON st.id = sh.student_id;

--33)Найдите в фамилии в каком по счёту символа встречается «ов». Если 0 
--(т.е. не встречается, то выведите на экран «не найдено».

SELECT st.surname,
CASE WHEN position('ов' in  st.surname)::varchar = '0' THEN 'не найдено'
	ELSE position('ов' in  st.surname)::varchar END AS pos
FROM students st;

--34)Дополните фамилию справа символом # до 10 символов.
SELECT *
FROM view_lev4;
/*CREATE VIEW view_lev4 AS (
SELECT RPAD(st.surname, 10, '#')
FROM students st
)*/

--35)При помощи функции удалите все символы # из предыдущего запроса.

SELECT trim(rpad, '#')
from
view_lev4;

--36) Выведите на экран сколько дней в апреле 2018 года.

SELECT '2018-05-01'::TIMESTAMP - '2018-04-01'::TIMESTAMP;

--37)Выведите на экран какого числа будет ближайшая суббота.

SELECT 'TOMORROW'::date + ( 6 + 7 - extract ( dow FROM 'TOMORROW'::date))::int%7;

--38)Выведите на экран век, а также какая сейчас неделя года и день года.

SELECT EXTRACT(century FROM now()) as century ,
	EXTRACT(WEEK FROM NOW()) as week,
	 EXTRACT(doy FROM now()) as dayofyear ;

--39)Выведите всех студентов, которые занимались или занимаются хотя бы 1 хобби. Выведите на экран Имя, Фамилию, Названию хобби,
-- а также надпись «занимается», если студент продолжает заниматься хобби в данный момент или «закончил», если уже не занимает.

SELECT st.name,
       st.surname,
       h.name,
       CASE
           WHEN sh.date_finish IS NULL THEN 'занимается'
           ELSE 'закончил'
       END
FROM students st
INNER JOIN students_hobbies sh ON st.id = sh.student_id
INNER JOIN hobbies h ON sh.hobby_id = h.id;



--Создание таблиц по спроектированной модели и заполнение их данными

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
unit_id integer REFERENCES unit (id)
);

INSERT INTO worker (name, surname, position, registration, number_phone, email,birth_day,unit_id)
VALUES
('Олег', 'Петров','Директор','115431','89800553535', 'petrov@gmail.com', '1989-02-21', 1), 
('Диман', 'Белоусов','Гендиректор','115433','89800553536', 'bel@gmail.com', '1990-02-11', 5), 
('Влад', 'Смирнов','продавец','115437','89800553537', 'vs@gmail.com', '1989-02-26', 4), 
('Ярик', 'Медведев','продавец','115423','89800553538', 'ya@gmail.com', '1990-04-26', 4), 
('Славик', 'Ершов','продавец','115422','89800553539', 'clava@gmail.com', '1999-12-26', 4), 
('Костян', 'Маслов','кладовщик','114531','89800553545', 'km@gmail.com', '1956-11-26', 2), -- 6
('Веня', 'Аксёнов','менеджер','119431','89800553555', 'venchik@gmail.com', '1977-05-26', 6), 
('Паша', 'Елисеев','кадровик','125431','89800553635', 'pavel@gmail.com', '1976-02-21', 3), 
('Саня', 'Костин','HR-спец','115504','89800553575', 'kostin@gmail.com', '1987-07-16', 8), 
('Антон', 'Брагин','Проектировщик','112221','89800553935', 'bragin@gmail.com', '1990-01-16', 5), 
('Аноним', 'Котов','ничего не делает','215431','89820553535', 'anonymous@gmail.com', '1989-02-16', 9), 
('Роман', 'Соколов','притворяется что работает','325431','89844553535', 'sokol@gmail.com', '1968-02-16', 10), 
('Олег', 'Морозов','Инженер','225431','89230553535', 'oleg@gmail.com', '1986-03-26', 5), 
('Денчик', 'Петров','Админ','445431','89430553535', 'den@gmail.com', '1987-04-26', 9); 
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
waybill integer,
requisites varchar(255) UNIQUE,
worker_id integer REFERENCES worker (id),
store_id integer REFERENCES store (id),
supplier_id integer REFERENCES supplier (id)
);
INSERT INTO registration_product (information, waybill, requisites, worker_id, store_id, supplier_id )
VALUES
('получение мяса', '100','general in mir1', 6, 4, 3),
('получение молочки', '50','general in trud1', 6, 5, 1),
('получение выпечки', '20','general in may1', 6, 6, 5),
('получение выпечки', '25','general in mir2', 6, 4, 6),
('получение мяса', '56','general in 22trud', 6, 5, 7),
('получение мяса', '234','general in 33may2', 6, 6, 8),
('получение мяса', '12','general in 44mir3', 6, 4, 9),
('получение мяса', '33','general in 55trud2', 6, 5, 10),
('получение мяса', '656','general in66 may3', 6, 6, 10),
('получение мяса', '33','general in 77mir4', 6, 4, 11),
('получение алкоголя', '100','general in 88trud2', 6, 5, 11),
('получение алкоголя', '100','general in 99may4', 6, 6, 11),
('получение алкоголя', '100','general in 00may5', 6, 6, 11);

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