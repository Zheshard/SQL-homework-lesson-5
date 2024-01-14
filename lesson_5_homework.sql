/*.
1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов.
2.Изменить в сущеcтвующем представлении порог для стоимости: пусть цена будет до 30 000 долларов
(используя оператор ALTER VIEW).
3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” (аналогично).

Доп задания:
1* Получить ранжированный список автомобилей по цене в порядке возрастания
2* Получить топ-3 самых дорогих автомобилей, а также их общую стоимость
3* Получить список автомобилей, у которых цена больше предыдущей цены
4* Получить список автомобилей, у которых цена меньше следующей цены
5*Получить список автомобилей, отсортированный по возрастанию цены, и добавить столбец со значением разницы между текущей ценой и ценой следующего автомобиля
*/

DROP DATABASE IF EXISTS lesson_homework_5;
CREATE DATABASE lesson_homework_5;
USE lesson_homework_5;
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT * FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов.
CREATE OR REPLACE VIEW cars_v1 AS
SELECT * FROM cars
WHERE cost < 25000;

SELECT * FROM cars_v1;
SELECT * FROM cars_v2;

/* 2.Изменить в сущеcтвующем представлении порог для стоимости: пусть цена будет до 30 000 долларов
(используя оператор ALTER VIEW).*/
ALTER VIEW cars_v1 AS
SELECT * FROM cars
WHERE cost < 30000;

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” (аналогично).
CREATE OR REPLACE VIEW cars_v2 AS
SELECT * FROM cars
WHERE name = 'Skoda' OR name = 'Audi';

-- 1* Получить ранжированный список автомобилей по цене в порядке возрастания. 
SELECT *,
ROW_NUMBER() OVER(ORDER BY cost) AS `number`
FROM cars;

-- 2* Получить топ-3 самых дорогих автомобилей, а также их общую стоимость. 
SELECT *,
SUM(cost) OVER() AS `sum`
FROM (
SELECT *,
DENSE_RANK() OVER(ORDER BY cost DESC) AS `number`
FROM cars
LIMIT 3) AS `rank`;

-- 3* Получить список автомобилей, у которых цена больше предыдущей цены

SELECT name, cost, lag_cost
FROM
(
SELECT *,
LAG(cost) OVER() `lag_cost`
FROM cars) AS `lag`
WHERE cost > lag_cost;

-- 4* Получить список автомобилей, у которых цена меньше следующей цены
SELECT name, cost, lead_cost
FROM
(
SELECT *,
LEAD(cost) OVER() `lead_cost`
FROM cars) AS `lead`
WHERE cost < lead_cost;

 /* 5*Получить список автомобилей, отсортированный по возрастанию цены, 
 и добавить столбец со значением разницы между текущей ценой и ценой следующего автомобиля*/
 SELECT *, 
cost - lead_cost AS 'dif'
FROM
 (
 SELECT *, 
 LEAD(cost) OVER() AS `lead_cost`
 FROM cars
 ORDER BY cost) AS `lead`;

