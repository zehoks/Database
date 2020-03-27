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
                FROM age(sh.date_finish, sh.date_start)) + extract(YEAR
                                                                   FROM age(sh.date_finish, sh.date_start)*12) +EXTRACT (YEAR
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
   HAVING count(*)>1) t ON st.id = t.student_id; -- таблицу соединили с результатом запроса (для нескольких значений лучше использовать эту конструкцию)
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
               FROM age(sh.date_finish, sh.date_start))*12 + extract(MONTH
                                                                     FROM age(sh.date_finish, sh.date_start))
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
WITH all_students AS
  (SELECT st.*
   FROM students st
   INNER JOIN students_hobbies sh ON st.id = sh.student_id
   WHERE sh.date_finish IS NULL
     AND age (sh.date_finish, sh.date_start) >5 YEAR )
SELECT a_s.*
FROM all_students a_s 
-- как выставить больше 5 лет?
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
   LIMIT 1)p_h ON p_h.hobby_id = sh.hobby_id;

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
WHERE sh.date_finish IS NOT NULL
  AND CASE
          WHEN sh.date_finish IS NULL THEN age(now(), date_start) =
                 (SELECT (age (sh.date_finish, sh.date_start))
                  FROM students_hobbies sh
                  ORDER BY age(now(), date_start) DESC
                  LIMIT 10)
          ELSE age (sh.date_finish, sh.date_start) =
                 (SELECT (age (sh.date_finish, sh.date_start))
                  FROM students_hobbies sh
                  ORDER BY age(now(), date_start) DESC
                  LIMIT 10)
      END 
--как сделать последних 10 если у нас тут стояло максимальное значение даты?
--20)Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.

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
WITH popular AS
    (SELECT count(sh.student_id) AS id,
            h.name
     FROM students st
     INNER JOIN students_hobbies sh ON st.id = sh.student_id
     INNER JOIN hobbies h ON sh.hobby_id = h.id
     GROUP BY hobby_id,
              h.name
     ORDER BY id DESC
     LIMIT 1),
     courses AS
    (SELECT SUBSTRING (st.n_group::varchar, 1, 1) AS course
     FROM students st
     INNER JOIN students_hobbies sh ON st.id = sh.student_id
     GROUP BY SUBSTRING (st.n_group::varchar, 1, 1))
  SELECT pop.*
  FROM popular pop
  INNER JOIN courses c ON pop.id=c.course ;
  --неправильная свзязь
 --23)Представление: найти хобби с максимальным риском среди самых популярных хобби на 2 курсе.

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
    (SELECT COUNT(st.id) AS c
     FROM students st),
     popular AS
    (SELECT count(sh.student_id) AS id,
            h.name
     FROM students st
     INNER JOIN students_hobbies sh ON st.id = sh.student_id
     INNER JOIN hobbies h ON sh.hobby_id = h.id
     GROUP BY hobby_id,
              h.name
     ORDER BY id DESC
     LIMIT 1)
  SELECT pop.id,
         pop.name
  FROM all_students a_s
  INNER JOIN popular pop ON a_s.c = pop.id;
--не работает
--26)Создать обновляемое представление.

 --27)Для каждой буквы алфавита из имени найти максимальный, средний и минимальный балл.
--(Т.е. среди всех студентов, чьё имя начинается на А (Алексей, Алина, Артур, Анджела)
--найти то, что указано в задании. Вывести на экран тех, максимальный балл которых больше 3.6

 --28)Для каждой фамилии на курсе вывести максимальный и минимальный средний балл.
-- (Например, в университете учатся 4 Иванова (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 4.1,
-- 4, 3.8 соответственно, а 4 Иванов учится на 3 курсе и имеет балл 4.5. На экране должно быть следующее:
-- 2 Иванов 4.1 3.8 3 Иванов 4.5 4.5)

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
GROUP BY SUBSTRING (st.name, 1, 1)
HAVING max(h.risk) =
  (SELECT MAX(h.risk)
   FROM hobbies h)
OR min(h.risk) =
  (SELECT min(h.risk)
   FROM hobbies h);
--ошибка с нахождением мин и макс