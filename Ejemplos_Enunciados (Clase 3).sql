/*

SQL Nivel Intermedio
WINDOW FUNCTIONS - EJEMPLOS ENUNCIADOS 
Base de datos: hhrr_db

Nombre relatora: Romina Sepúlveda

Nombre Participante: Javiera Zavala
Fecha: 30-05-2024

*/

-- #################
-- 1 Agregaciones
-- ################



-- 1.a Explora las tablas

SELECT * FROM employee;
SELECT * FROM sales;


-- 1.b Obtener el salario máximo desde la tabla employee.

SELECT 
	MAX(salary)
FROM employee;

-- 1.c Obtener el salario máximo por cada dpto. Usa el alias sal_max y orderda el 
-- 	resultado por sal_max descendiente.

SELECT 	
	dept_name,
	MAX(salary) AS sal_max
FROM 	employee
GROUP BY dept_name
ORDER BY sal_max DESC;

-- #################
-- 2. Funciones de ventana de agregación
-- ################

-- 2.a Obten la tabla employee más una columna con el salario máximo.

SELECT 	
	e.*, 							 --Con esto (*) puedo llamar todas las columnas de la tabla--
	MAX(salary) OVER ()
FROM 	employee e;


-- 2.b Al query anterior añade un alias al query anterior


SELECT 	
	e.*,
	MAX(salary) OVER () AS sal_max_comp
FROM 	employee e;


-- 
-- 2.c Obten la tabla employee más una columna con el salario máximo del depto correspondiente a cada registro

SELECT 	
	e.*,
	MAX(salary) OVER (PARTITION BY dept_name) AS sal_max_dpto
FROM 	employee e;


-- #################
-- 3. Funciones de ventana:  PARTICION VS sin particion
-- ################	

-- 3.a Escribe en un solo query una funcion de ventana MAX con particion y otra sin particion
-- con: OVER( PARTITION BY dept_name) 
-- sin: OVER()
	
-- CON 

SELECT
	e.*,
	max(salary) OVER( PARTITION BY dept_name)
FROM employee e
ORDER BY salary DESC;
	
-- SIN 

SELECT
	e.*,
	max(salary) OVER()
FROM employee e
ORDER BY salary DESC;
	

-- #################
-- 4. Total acumulado
-- ################

-- 4.a Explorar Sales

SELECT * FROM sales;


-- 4.b Obten el total de las ventas (price * quantity) para cada tienda. 
-- el resultado debe tener una column por tienda
-- Recuerda añadir alias y ordenar tu resultado


SELECT
	store_name,
	SUM(price * quantity) AS total_venta_por_tienda
FROM sales
GROUP BY store_name
ORDER BY total_venta_por_tienda DESC;


-- 4.c Obten el total de las ventas (price * quantity) para cada tienda
--	como una columna extra en la tabla sales.
	
SELECT
	s.*,
	SUM(price * quantity) OVER(PARTITION BY store_name) AS total_venta_por_tienda
FROM sales s;

-- #################
-- 5. Total acumulado RUNNING SUM
-- ################ 
-- ¿Qué es una suma acumulada?
-- Para obtener suma acumulada incorporamos ORDER BY dentro de OVER()
	
-- 5.a Obten al suma acumulada del total de ventas (price * quantity) por cada tienda

SELECT
	s.*,
	SUM(price) OVER (ORDER BY store_id)
FROM sales s

-- 5.b
-- Añade el siguiente FRAME para que los registros iguales sean tomados como independientes.
--	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 



-- 5.c
-- RUNNING SUM PARA TODA LA TABLA (SIN PARTICION)
	


	
-- #################
-- 6 Funciones ventana de Ranking: ROW_NUMBER
-- ################

-- 6.a Asignar un numero incremental a cada fila de la tabla

SELECT
	e.*,
	ROW_NUMBER () OVER()
FROM employee e;


-- 6.b Ejecuta el query anterior con un alias.

SELECT
	e.*,
	ROW_NUMBER () OVER() AS rw
FROM employee e;

-- 6.c asigna un número de fila dentro de cada dpto

SELECT
	e.*,
	ROW_NUMBER () OVER(PARTITION BY dept_name) AS rw_dpto
FROM employee e;


-- 6.c Asigna el numero de fila segun el salario.
-- consigo un ranking de los que ganan menos o mas en cada dpto desgun desc

SELECT
	e.*,
	ROW_NUMBER () OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rw_depto
FROM employee e;

	
-- #####
-- DESAFIO
-- #####


-- La empresa dará un reconocimiento a los 2 empleados de mayor antigüedad en cada dpto.
-- Los empleados de menor id se unieron antes a la compañía.
-- Obten un resultado con todos los campos de la tabla employee que contenga los registro 
-- de los dos empleados de mayor antiguedad en cada dpto.

-- Primero asignemos un número de fila a los empleados por cada departamento

SELECT
	e.*,
	ROW_NUMBER () OVER(PARTITION BY dept_name) AS rn_depto
FROM employee e

-- Debemos ordenar los empleados según emp_id

SELECT
	e.*,
	ROW_NUMBER () OVER(PARTITION BY dept_name ORDER BY emp_id) AS rn_depto
FROM employee e

-- ahora es posible filtar pero no podemos hacerlo directamente. Debemos hacer una subconsulta

SELECT	
	*
FROM 	(
	SELECT
	e.*,
	ROW_NUMBER () OVER(PARTITION BY dept_name ORDER BY emp_id) AS rn_depto
	FROM employee e
	) AS Subquery
WHERE rn_depto <= 2;

-- #################
-- 7 Funciones ventana de Ranking: RANK
-- ################

-- 7.a Obtener los 3 empleados con mejor salario por departamento
-- primero: crear un ranking

SELECT
	e.*,
	RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rk_salary
FROM employee e;


-- 7.b Cuando hay registros que tienen el mismo valor, se les asigna el mismo ranking 
-- y el se salta los valores cuando existen valores repetidos ej 1,2,2,4

SELECT
	*
FROM 	(
	SELECT
	e.*,
	RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rk_salary
	FROM employee e
	)
WHERE rk_salary <= 3;


-- #################
-- 8 Funciones ventana de Ranking: DENSE_RANK
-- ################


-- La funcion DENSE_RANK tambien asigna el mismo ranking a los valores
-- que empatan. La diferencia radica en que no habrá ningun salto de valor luego de valores repetitos 1,2,2,3

-- rank,row_number,dense_rank  no llevan argumento
-- Explora cada una de las funciones de ranking en un mismo resultado y compara

SELECT
	e.*,
	DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC)
FROM employee e;
