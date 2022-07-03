there are several interesting functions in postgresql:

- *group by cube (аттр1, аттр2 и т.д.)* - выводит информацию для всех возможных сочетаний внутри группы:
аттр1 аттр2
null аттр2
аттр1 null
null null
- *group by rollup (attr1, attr2 ...)* - убирает сочетания по одному, начиная справа:
attr1 attr2
att1 null
null null

- *group by groupingsets ((attr1, attr2), ())* - группирует по заданным сетам:
attr1 attr2
null null

если задать **group by groupingsets ((attr1, attr2))** - это будет эквивалетно **group by attr1, attr2**


##CHAPTER5. UNION, INTERSECTION, EXCEPT. All of mentioned previously with ALL.

###Дубликаты строк (5/8)

По умолчанию UNION, INTERSECT и EXCEPT исключают дубликаты строк. Это работает так же, как и добавление DISTINCT после ключевого слова SELECT.

Посмотрим на несколько запросов.

    SELECT value
      FROM table1
    #	value
    1	1
    2	1
    3	3
    4	3
    5	3
    6	5
    SELECT value
      FROM table2
 
    #	value
    1	2
    2	3
    3	3
    4	4
Обрати внимание на намеренно задублированные строки. Теперь посмотрим на результаты операций над множествами:

    SELECT value
      FROM table1
    UNION
    SELECT value
    FROM table2

    #	value
    1	1
    2	2
    3	3
    4	4
    5	5

    SELECT value
     FROM table1
    INTERSECT
    SELECT value
    FROM table2

#	value
1	3
SELECT value
  FROM table1
EXCEPT
SELECT value
  FROM table2
#	value
1	1
2	5
Дубликаты строк отсутствуют независимо от того, были они в исходных таблицах, или получились в результате операции над множествами.

Чтобы СУБД не исключала из результата задублированные строки, нужно к ключевому слову операции над множествами добавить ALL. Перепишем наши запросы и посмотрим на результат:

SELECT value
  FROM table1
 UNION ALL
SELECT value
  FROM table2
#	value
1	1
2	1
3	2
4	3
5	3
6	3
7	3
8	3
9	4
10	5
В результате присутствуют все строки table1 и table2.

SELECT value
  FROM table1
INTERSECT ALL
SELECT value
  FROM table2
#	value
1	3
2	3
Пересечение выдает довольно интересный результат. В table1 значение 3 встречается три раза, а в table2 значение 3 встречается два раза. В результате выполнения запроса мы видим две строки со значением 3. INTERSECT ALL оставляет столько копий одинаковых строк, сколько их встретилось в обеих таблицах (наименьшее количество из двух таблиц). Например, если бы в первой таблице значение 9 встречалось 10 раз, а во второй 15 раз, то в результате INTERSECT ALL значение 9 встретилось 10 раз. Не веришь - проверь самостоятельно :)

SELECT value
  FROM table1
EXCEPT ALL
SELECT value
  FROM table2
#	value
1	1
2	1
3	3
4	5
Откуда появилось значение 3 в результате? При EXCEPT такого не было. EXCEPT ALL исключает из результатов первого запроса столько одинаковых строк, сколько найдет в результате выполнения второго запроса. Разберем каждое значение из table1:

Значение 1 в table1 встречается 2 раза, в table2 ни разу. В результате видим 2 строки со значением 1.
Значение 3 в table1 встречается 3 раза, в table2 2 раза. Из трех строк были исключены две, в результате осталась одна.
Значение 5 в table1 встречается 1 раз, в table2 ни разу. В результате видим 1 строку со значением 5.


