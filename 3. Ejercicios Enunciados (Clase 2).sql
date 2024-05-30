/*
SQL Nivel Intermedio
Mastering joins
Base de datos: bank_db

Nombre Relatora: Romina Sepúlveda
Nombre Participante: Javiera Zavala
Fecha: 22-05-2024
*/

/* 
	1. El objetivo comercial de este año en la institución bancaria es dar uso todos los productos bancarios.
	En la tabla account encontrarás todos los productos que usan los clientes. 
	¿Qué productos no están siendo usados por los usuarios del banco?
	Combina la tablas product y account para averiguarlo

	Vuelve a explorar las tablas si necesitas recordar su contenido:
	SELECT * FROM product;
	SELECT * FROM account;

*/

SELECT * FROM product;
SELECT * FROM account;


SELECT 	p.product_cd, 
	p.name
FROM	product p
LEFT JOIN account a ON p.product_cd = a.product_cd
WHERE a.product_cd IS NULL;


/*
	2. La institución decide promocionar sus productos vía email con los clientes (individual y business).
	Cada email debe contener el nombre de cliente (fname)(lname) y el o los productos que cliente tiene (product_cd).
	El equipo comercial necesita obtener el nombre de cliente asociado a cada cuenta (account_id)
	Combina la tabla account con individual y business para obtener la siguiente información:
		
	SELECT account.account_id,
		account.product_cd,
		individual.fname, 
		individual.lname,
		business.name AS business
	FROM 

	NOTA. la tabla account tiene una clave que es comun a las tablas customer y bunsiness que no esta mostrada en el ERD con una linea de relación
	Esto no es impdimento para poder hacer un JOIN en esas tablas.

	Vuelve a explorar las tablas si necesitas recordar su contenido:
	SELECT * FROM account;
	SELECT * FROM individual;
	SELECT * FROM business;
	
	*/

SELECT * FROM account;
SELECT * FROM individual;
SELECT * FROM business;


SELECT 	account.account_id,
	account.product_cd,
	individual.fname, 
	individual.lname,
	business.name AS business
FROM 	account
LEFT JOIN
	individual ON account.cust_id = individual.cust_id
LEFT JOIN
	business ON account.cust_id = business.cust_id;


/*
	3. Obten e.emp_id, title, e.assigned_branch_id, b.name para los empleados 'Teller' OR 'Head Teller'
	y que pertenezcan a la Woburn brunch

	Utiliza los siguientes alias: 
	employee AS e
	branch AS b

	Vuelve a explorar las tablas si necesitas recordar su contenido:
	SELECT * FROM employee;
	SELECT * FROM branch;
	
*/

SELECT * FROM employee;
SELECT * FROM branch;


SELECT 
    e.emp_id, 
    e.title, 
    e.assigned_branch_id, 
    b.name
FROM  employee AS e
JOIN 
    branch AS b ON e.assigned_branch_id = b.branch_id
WHERE 
    (e.title = 'Teller' OR e.title = 'Head Teller') 
    AND b.name = 'Woburn Branch';


/*
	4.Obten información de las cuentas asociadas a los ejecutivos del resultado de la consulta anterior
	Es Decir que pertenezcan a Woburn brunch y que su titulo sea 'Teller' OR 'Head Teller'
	Obten la siguiente información:
	a.account_id, 
    a.cust_id, 
    a.open_date, 
    a.product_cd

	hint: Una forma de de resolverlo es usando el query como una tabla dentro de un subquery 
	¿En que columna harías el JOIN?

	Vuelve a explorar las tablas si necesitas recordar su contenido:
	SELECT * FROM employee;
	SELECT * FROM branch;
	SELECT * FROM account ;
	
*/
	SELECT * FROM employee;
	SELECT * FROM branch;
	SELECT * FROM account;
	
	
	

SELECT 
    a.account_id, 
    a.cust_id, 
    a.open_date, 
    a.product_cd
FROM  account AS a
JOIN 
    (SELECT 
    	e.emp_id, 
    	e.title, 
    	e.assigned_branch_id, 
    	b.name
	FROM 
   		employee AS e
	JOIN 
   		branch AS b ON e.assigned_branch_id = b.branch_id
	WHERE 
    	(e.title = 'Teller' OR e.title = 'Head Teller') 
    	AND b.name = 'Woburn Branch') AS subquery
ON 
	a.open_branch_id = subquery.assigned_branch_id
GROUP BY
	a.account_id, 
    a.cust_id, 
    a.open_date, 
    a.product_cd;

	
/*
	5¿Quién es jefe de quién?
	La tabla employee hace tiene un atributo superior_emp_id que indica el imp_id del supervisorasociado a ese empleado.
	
	Crea un query para obtener las siguientes columnas:
		emp.fname AS nombre_emp,  
		emp.lname AS apellido_emp,
		jef.fname AS nombre_supervisor,
		jef.lname  AS apellido_supervidor
	
	Note: Tu resultado debe incluir empleados que no tengan supervisor 

	Vuelve a explorar las tablas si necesitas recordar su contenido:
	SELECT * FROM employee
*/

SELECT * FROM employee


SELECT 
    emp.fname AS nombre_emp,  
    emp.lname AS apellido_emp,
    jef.fname AS nombre_supervisor,
    jef.lname AS apellido_supervisor
FROM  employee AS emp
LEFT JOIN 
    employee AS jef ON emp.superior_emp_id = jef.emp_id;


	
/*
	 6.-- ****  Pregunta Bonnus ******
	
	La empresa organizara un torneo de ajedrez entre los trabajadores con el cargo  'Tellers'.
	Necesitas explorar armar los pares rivales para la primera fase del torneo.
		
	Vuelve a explorar las tablas si necesitas recordar su contenido:
	SELECT * FROM employee

	
		
	a) Explorar cuántos 'Teller' hay.
*/

SELECT * FROM employee;


SELECT * 
FROM employee
WHERE title = 'Teller';


	
/* 
	b) Haz una self JOIN usando el atributo emp_id como un primer intento de armar las duplas 
	para el torneo de ajedres de Tellers. 
	Nota: Utiliza operador != en ON para que a nadie le toque ser ribal de si mismo.
	Filtra "ambas tablas" por title = 'Teller'

	Usa alias e1 y e2 para las tablas:
	
	SELECT 
		e1.fname AS nombre_emp,  
		e1.lname AS apellido_emp,
		e2.fname AS nombre_supervisor,
		e2.lname  AS apellido_supervidor
	FROM 

	
	
*/	
	
SELECT 
    e1.emp_id AS emp_id_1,
    e1.fname AS nombre_emp_1,  
    e1.lname AS apellido_emp_1,
    e2.emp_id AS emp_id_2,
    e2.fname AS nombre_emp_2,  
    e2.lname AS apellido_emp_2
FROM employee e1
JOIN employee e2 ON e1.emp_id != e2.emp_id AND e1.title = 'Teller' AND e2.title = 'Teller';


	
/*
	c) En el query anterior las parejas de repiten:
	
		 Chis Tucker vs Sarah Parker  =   Sarah Parker vs Chis Tucker
	
	Modifica el operador de la cláusula ON para que las parejas no se repitan.
*/

SELECT 
    e1.emp_id AS emp_id_1,
    e1.fname AS nombre_emp_1,  
    e1.lname AS apellido_emp_1,
    e2.emp_id AS emp_id_2,
    e2.fname AS nombre_emp_2,  
    e2.lname AS apellido_emp_2
FROM employee e1
JOIN employee e2 ON e1.emp_id < e2.emp_id AND e1.title = 'Teller' AND e2.title = 'Teller';





