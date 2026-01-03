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
 
 
 /*===============================================
	6. Qué servicio de spa es el más contratado.
 =================================================*/ 
 -- El servicio más contratado es balneario.
 SELECT 
    tipo_tratamiento, 
    COUNT(*) AS contrataciones
FROM
    servicio_spa
GROUP BY tipo_tratamiento
ORDER BY contrataciones DESC;
 
 
 /*===============================================
	7. ¿Cuál es la media de plazas de parking contratadas?¿Y la moda?
 =================================================*/ 
 -- Media = 1
SELECT 
    ROUND(AVG(numero_plazas)) AS media_plazas
FROM
    servicio_parking;
    
 -- Moda: 1 plaza moda = 5600
 
SELECT 
	numero_plazas AS moda_plazas,
    COUNT(*) AS frecuencia
FROM 
	servicio_parking
GROUP BY 
	moda_plazas
ORDER BY 
	frecuencia DESC
LIMIT 1;


 /*===============================================
	8. ¿Qué tipo de habitaciones se han contratado más?
 =================================================*/ 
-- La habitación más contratada es la doble interior.
SELECT 
	h.tipo, 
	COUNT(r.id_reserva) AS reservas
FROM 
	reservas r
JOIN habitaciones h ON h.id_habitacion = r.id_habitacion
GROUP BY h.tipo
ORDER BY reservas DESC;

 /*===============================================
	9. ¿Cuál es la estancia media, la máxima y la mínima?
 =================================================*/ 
-- Media = 3
-- Max = 60
-- Min = 0

SELECT 
	ROUND(AVG(DATEDIFF(checkout, checkin))) AS estancia_media,
    MAX(DATEDIFF(checkout, checkin)) AS estancia_maxima,
    MIN(DATEDIFF(checkout, checkin)) AS estancia_minima
FROM reservas
WHERE estado_reserva = 'Check-Out';

select * from reservas;

 /*===============================================
	10. Clasifica a los clientes en plata, oro y diamante según la cantidad de veces que hayan visitado el hotel. 
		**Uso de CASE/WHEN
 =================================================*/
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(r.id_reserva) AS numero_visitas,
    CASE 
        WHEN COUNT(r.id_reserva) >= 30 THEN 'Diamante'
        WHEN COUNT(r.id_reserva) >= 20 THEN 'Oro'
        ELSE 'Plata'
    END AS categoria_fidelidad
FROM 
    clientes c
JOIN 
    reservas r ON c.id_cliente = r.id_cliente
WHERE 
    r.estado_reserva = 'Check-Out' -- Solo contamos visitas completadas
GROUP BY 
    c.id_cliente
ORDER BY 
    numero_visitas DESC;
    
    
 /*===============================================
	11. Cuántos clientes hay de cada categoría de  clientes?
		**Uso de desubconsulta.
 =================================================*/
SELECT 
    categoria_fidelidad, 
    COUNT(*) AS total_clientes
FROM (
    SELECT 
        c.id_cliente,
        CASE 
            WHEN COUNT(r.id_reserva) >= 40 THEN 'Diamante'
            WHEN COUNT(r.id_reserva) >= 20 THEN 'Oro'
            ELSE 'Plata'
        END AS categoria_fidelidad
    FROM 
        clientes c
    JOIN 
        reservas r ON c.id_cliente = r.id_cliente
    WHERE 
        r.estado_reserva = 'Check-Out'
    GROUP BY 
        c.id_cliente
) AS resumen_clientes
GROUP BY 
    categoria_fidelidad
ORDER BY 
    total_clientes DESC;
    
    
 /*===============================================
	11. Funcion que indica el cálculo total para cada reserva
 =================================================*/ 

SELECT 
    r.id_reserva, 
    DATEDIFF(r.checkout, r.checkin) AS estancia,
    r.deposito, 
    p.precio_total AS coste_parking, 
    h.tarifa AS tarifa_habitacion, 
    c.precio AS tarifa_comida,
    s.precio AS tarifa_spa,
    (DATEDIFF(r.checkout, r.checkin) * h.tarifa) + (DATEDIFF(r.checkout, r.checkin) * p.precio_total)AS COSTE_TOTAL
FROM
    reservas r
JOIN servicio_parking p ON r.id_reserva = p.id_reserva
JOIN habitaciones h ON h.id_habitacion = r.id_habitacion
JOIN servicio_comida c ON r.id_reserva = c.id_reserva
JOIN servicio_spa s ON r.id_reserva = s.id_reserva;