﻿1.Однотабличные запросы
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