/*

SQL Nivel Intermedio
WINDOW FUNCTIONS - EJERCICIOS
Base de datos: chinook

Nombre relatora: Romina Sepúlveda
Nombre Participante: Javiera Zavala
Fecha: 30-05-2024

*/

-- 1. Explora la tabla invoice

SELECT * 
FROM invoice;

-- 2. Explora el total de ventas de la tabla invoice
	
SELECT
	SUM(total)
FROM invoice;

/*
	
3. Obten las siguientes columnas y además añade una columna que represente el total de las ventas: SUM(total)

    Customer_Id,
    Invoice_Id,
	Invoice_Date,
    Total,
*/

SELECT
	Customer_Id,
    	Invoice_Id,
	Invoice_Date,
    	Total,
	SUM(total) OVER() AS total_over_all
FROM invoice;


/*

4. Modifica el query anterior para obetener la suma acumulada en base a invoice_id en vez del total de las ventas
nota: Como cada invoice_id es un valor único no es necesario editar el FRAME de la cláusula OVER.
*/
	
SELECT
	Customer_Id,
   	Invoice_Id,
	Invoice_Date,
  	Total,
	SUM(total) OVER( ORDER BY invoice_id) AS running_sum
FROM invoice;

	
/* 
5. Modifica el query anterior para obtener:
	Customer_Id,
    Invoice_Id,
	Invoice_Date,
    Total, el total por cada cliente

	Agrega además una columna con el total de las ventas por cliente.
*/

SELECT
	Customer_Id,
    Invoice_Id,
	Invoice_Date,
    Total,
	SUM(total) OVER( PARTITION BY customer_id) AS running_sum
FROM invoice;


-- 6. Modifica el query anterior para obtener por cada cliente el total acumulado en base a invoice_date.

SELECT
	Customer_Id,
    Invoice_Id,
	Invoice_Date,
    Total,
	SUM(total) OVER( PARTITION BY customer_id   ORDER BY invoice_date) AS running_sum
FROM invoice;


------
