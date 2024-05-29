/*

SQL Nivel Intermedio
Mastering JOINs
Base de datos: Chinook

Nombre relatora: Romina Sepúlveda
Nombre Participante: Javiera Zavala
Fecha: 16-05-2024

*/

SELECT * FROM invoice      LIMIT 3;
SELECT * FROM invoice_line LIMIT 3;
SELECT * FROM album        LIMIT 3;
SELECT * FROM artist       LIMIT 3;


/*
 JOIN SIMETRICOS

	 1a. Explora la tabla invoice y filta por invoice_id = 1 para ver la informacion general
	de la primera boleta (invoice_id = 1)
*/

SELECT * FROM invoice
WHERE invoice_id = 1;



/*
	1b. Exploremos el detalle de la primera boleta (tabla invoice_line)
*/

SELECT * FROM invoice_line
WHERE invoice_id = 1;


/*
	1c. Combina ambas tablas para obtener la información general de la primera boleta y 
	 además los track_id asociados a esta.
	 invoice.invoice_id = 1
*/

SELECT invoice.*, track_id
FROM invoice_line
JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
WHERE invoice.invoice_id = 1;


/* 

JOIN ASIMETRICOS!

	2a. Explora la tablas Album y artist
*/
SELECT * FROM album        LIMIT 3;
SELECT * FROM artist       LIMIT 3;

	
/* 
	2.b ¿A qué artista pertenece cada album? ¿Qué tipo de JOIN debo realizar?
*/

SELECT album.*, artist.name
FROM album
LEFT JOIN artist
	ON album.artist_id = artist.artist_id;


/*
	2.c ¿Qué artistas tiene más albums en nuestra bbdd? 
		¿Qué agregación debes realizar?
		¿Qué tipo de JOIN debes usar para considerar a los artistas que no tienen ningún album?

*/	

SELECT album.artist_id, artist.name,
	COUNT(album_id)
FROM album
	JOIN artist ON album.artist_id = artist.artist_id
GROUP BY album.artist_id, artist.name
ORDER BY count(album_id) DESC
LIMIT 6;


/*
	2.d Modifica el query anterior para obtener el ranking solo de los artistas que tiene album(s) disponibles en la bbdd.
*/
	
SELECT album.artist_id, artist.name,
	COUNT(album_id) AS Total
FROM album
	RIGHT JOIN artist ON album.artist_id = artist.artist_id
GROUP BY album.artist_id, artist.name
ORDER BY Total ASC;

/*
 JOIN tabla con Subquery

	3.a Obten todos los track_id que cumplan las siguientes condiciones:
		
		
		genre.name = 'Rock And Roll'
		milliseconds >= 140000
	
		Combina las tablas track y genre
	
		Consulta las tablas involucradas si necesitias recordar su contenido
		SELECT * FROM track LIMIT 3;
		SELECT * FROM genre LIMIT 3;
*/

SELECT * FROM track LIMIT 3;
SELECT * FROM genre LIMIT 3;


SELECT *
FROM track
LEFT JOIN genre 
	ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock And Roll' AND milliseconds >= 140000;


/*
	3.b Obten todos los transacciones (invoice_line) que sean de género 'Rock And Roll' y que tengan una duración de al menor 140000 milliseconds. 
		
	
		Hint: Una forma de resulverlo es haciendo un JOIN entre la tabla invoice_line 
		y la consulta del ejercicio anterior
	
		Vuelve a explorar las tablas si necesitas recordar su contenido:
		SELECT * FROM invoice_line
*/

SELECT *
FROM invoice_line
JOIN (
	SELECT *
	FROM track
	LEFT JOIN genre 
		ON track.genre_id = genre.genre_id
	WHERE genre.name = 'Rock And Roll' AND milliseconds >= 140000
	 ) Track
ON	invoice_line.track_id = Track.track_id;
	




/*-- SELF JOIN
	
	4.a Selecciona las siguientes columnas de la tabla employee:
	employee_id,
	last_name,
	first_name, 
	title,
	reports_to 
*/
	
SELECT 	employee_id,
	last_name,
	first_name, 
	title,
	reports_to 
FROM employee;

/*
	4.b Crea un query con las mismas columnas del query anterior y además añade columnas con el 
	nombre y apellido de jefe asociado a cada empleado.
	Note: Esta vez debes asignar aleas a las tablas e indicar a que tabla pertenecen cada columnas 
*/

SELECT 	e.employee_id,
	e.last_name,
	e.first_name, 
	e.title,
	e.reports_to,
	j.first_name AS nombre_jefe,
	j.last_name AS apellido_jefe
FROM employee e
JOIN employee j ON e.reports_to = j.employee_id;



SELECT 	e.employee_id,
	e.last_name,
	e.first_name, 
	e.title,
	e.reports_to,
	j.first_name AS nombre_jefe,
	j.last_name AS apellido_jefe
FROM employee e
FULL JOIN employee j ON e.reports_to = j.employee_id;


SELECT 	e.employee_id,
	e.last_name,
	e.first_name, 
	e.title,
	e.reports_to,
	j.first_name AS nombre_jefe,
	j.last_name AS apellido_jefe
FROM employee e
LEFT JOIN employee j ON e.reports_to = j.employee_id;



SELECT 	e.employee_id,
	e.last_name,
	e.first_name, 
	e.title,
	e.reports_to,
	j.first_name AS nombre_jefe,
	j.last_name AS apellido_jefe
FROM employee e
RIGHT JOIN employee j ON e.reports_to = j.employee_id
WHERE e.employee_id IS NOT NULL;
