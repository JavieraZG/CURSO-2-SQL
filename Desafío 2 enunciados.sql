/*

Nivel Up - SQL Nivel Intermedio - Módulo 8
Desafío práctico n°2

Base de datos: sales
Instructora: Romina Sepúlveda

Fecha: 28-08-2024
Nombre Participante: Javiera Zavala G.

*/

/*1. Análisis de Ventas por local comercial

Utiliza la tabla `pedido` para obtener las columnas `id_comercial` y `total`. 
Además, añade dos columnas donde se muestre:

- El total máximo asociado a cada `id_comercial` (usa el alias`max_ventas_id_comercial`).
- El total mínimo asociado a cada `id_comercial` (usa el alias `min_ventas_id_comercial`).

Usa funciones de ventana (Window Functions) para calcular el máximo y mínimo por `id_comercial`.

Sintaxis: FUNCION(columna) OVER (PARTICION BY columna_particion) AS alias

*/

SELECT id_comercial,
		total,
		MAX(total) OVER (PARTITION BY id_comercial) AS max_ventas_id_comercial,
		MIN(total) OVER (PARTITION BY id_comercial) AS min_ventas_id_comercial
FROM pedido;


/*
2. Participación de Cada local comercial en el total de ventas

Calcula la participación de cada local comercial en el total de ventas realizadas para evaluar 
cómo cada uno contribuye cada uno al éxito de la empresa.


Parte 1: Calcular el Total de Ventas por Comercial

Calcula el total de ventas realizadas por cada comercial. 
Utiliza la tabla `pedido` para sumar el valor total de ventas (`total`) por cada comercial (`id_comercial`).

Agrupa los resultados por `id_comercial` y asigna el siguiente alias `total_ventas_comercial` a la columna agregada.

Tu resultado debe incluir solo dos columnas: `id_comercial` y `total_ventas_comercial`.

Hint: Recuerda usar `GROUP BY` para agrupar los resultados por comercial.
*/


SELECT 
    id_comercial,
    SUM(total) AS total_ventas_comercial
FROM 
    pedido
GROUP BY 
    id_comercial;




/*
Parte 2: Calcular la Participación de Cada Comercial

Utiliza el query anterior como cte con el siguiente nombre:`cte_ventas_totales_comercial`

En la coonsulta principal selecciona las columnas `id`, `nombre`, `apellido1` y `comision` de la tabla `comercial`.

Realiza un `JOIN` entre la tabla `comercial` y la CTE  usando `id_comercial`como clave de unión.

Calcula el porcentaje de participación de cada local comercial respecto al total de ventas dividiendo `total_ventas_comercial` por la suma de todas las ventas y multiplicando por 100.

Utiliza la función ROUND() el porcentaje a dos decimales y asigna el resultado a la columna `porcentaje_participacion`.

Hint: para calcular el porcentaje de participación necesitarás el total de venta de toda la tabla esto puedes lograrlo facilmente usando un subquery directamente al hacer la división.
*/

WITH cte_ventas_totales_comercial AS (
    SELECT 
        id_comercial,
        SUM(total) AS total_ventas_comercial
    FROM 
        pedido
    GROUP BY 
        id_comercial
	)

SELECT 
    c.id,
    c.nombre,
    c.apellido1,
    c.comision,
    ROUND((v.total_ventas_comercial / (SELECT SUM(total_ventas_comercial) FROM cte_ventas_totales_comercial)) * 100, 2) AS porcentaje_participacion
FROM comercial c
JOIN cte_ventas_totales_comercial v
ON c.id = v.id_comercial;

/*

3. Creación de Vistas para Resúmenes de Ventas**

Parte 1: Crea una vista llamada `resumen_ventas_cliente` que muestre un resumen de ventas por cliente,
con las siguientes columnas:

- `cliente_id`, `cliente_nombre`, `numero_pedidos`, `total_ventas`, `promedio_ventas`.

*/
SELECT *
FROM Comercial c 
JOIN pedido p ON p.id = c.id



SELECT *
FROM pedido;




CREATE VIEW resumen_ventas_clientes AS
SELECT
	c.id AS cliente_id,
	c.nombre AS cliente_nombre,
	COUNT(p.id_cliente) AS numero_pedidos,
	SUM(p.total) AS total_ventas,
	AVG(p.total) AS promedio_ventas
FROM cliente c
LEFT JOIN 
	pedido p ON c.id = p.id_cliente
GROUP BY 
	c.id, 
	c.nombre;



SELECT *
FROM resumen_ventas_clientes;

/*
Usa la vista resumen_ventas_cliente para seleccionar los clientes con un total_ventas superior a 2000,
ordenados de mayor a menor.
*/

SELECT 
	cliente_id,
	cliente_nombre,
	total_ventas
FROM resumen_ventas_clientes
WHERE total_ventas > 2000
ORDER BY total_ventas DESC;