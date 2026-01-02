/*===============================================
			Proyecto SQL: Resort Hotelero
 =================================================           
- Este archivo contiene la creación de querys.
*/

/*===============================================
	1. Cuantas reservas se han realizado
 =================================================*/ 
 -- Se han realizado 49157 reservas.

SELECT 
    COUNT(*)
FROM
    reservas;
    
 /*===============================================
	2. ¿Cuantas reservas han sido canceladas?
 =================================================*/ 
 -- Han cancelado 16959 reservas.
 
SELECT 
    COUNT(*) AS total_canceladas
FROM
    reservas
WHERE
    estado_reserva = 'Canceled';
 
 
 /*===============================================
	3. ¿Cuantas adultos han acudido a nuestro hotel? ¿Y niños o bebés?
 =================================================*/ 
 -- Han acudido 56462 adultos, 2428 ninos y 334 bebes.
 
SELECT 
    SUM(adultos) AS total_adultos,
    SUM(ninos) AS total_ninos,
    SUM(bebes) AS total_bebes
FROM
    reservas
WHERE
	estado_reserva = 'Check-Out';
    
 /*===============================================
	3. ¿Cuatas nacionalidades diferentes han acudido a nuestro hotel?
 =================================================*/
 -- Hay 135 nacionalidades diferentes.
 
 SELECT 
    COUNT(DISTINCT pais)
FROM
    clientes;

 /*===============================================
	4. En nuestra base de clientes, ¿cuál es la nacionalidad de la mayoría de nuestros clientes?
    - Obtén los 10 primeros. Si coinciden ordénalos por ordena alfabético.
 =================================================*/ 
 -- Portugal, Angola, Grecia, Argentina y Australia.
SELECT 
    pais, 
    COUNT(DISTINCT id_cliente) AS total_clientes_unicos
FROM 
    clientes
GROUP BY 
    pais
ORDER BY 
    total_clientes_unicos DESC, pais
LIMIT 5;

 /*===============================================
	5. Qué régimen de comida es el más contratado.
 =================================================*/ 
 -- El régimen más contratado es BB(bed & breakfast)
SELECT 
    tipo_comida, 
    COUNT(*) AS contrataciones
FROM
    servicio_comida
GROUP BY tipo_comida
ORDER BY contrataciones DESC;
 
 
 select * from servicio_comida;
