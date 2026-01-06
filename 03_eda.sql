/*===============================================
			Proyecto SQL: Resort Hotelero
 =================================================           
- Este archivo contiene la creación de querys.
- El archivo consta de 25 querys que responden a las preguntas que se muestran previamente al resultado. 
Algunos de ellos contienen las respuestas para futuras comprobaciones
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
 -- Han cancelado 16959 reservas, lo que se traduce en un 34% de cancelaciones.
 
SELECT 
    COUNT(*) AS total_canceladas
FROM
    reservas
WHERE
    estado_reserva = 'Canceled';
 
 
 /*===============================================
	3. ¿Cuantas adultos han acudido a nuestro hotel? ¿Y niños o bebés?
 =================================================*/ 
 -- Han acudido 56462 adultos, 2428 niños y 334 bebes.
 
SELECT 
    SUM(adultos) AS total_adultos,
    SUM(ninos) AS total_ninos,
    SUM(bebes) AS total_bebes
FROM
    reservas
WHERE
	estado_reserva = 'Check-Out';
    
 /*===============================================
	3. ¿Cuatas nacionalidades diferentes hay en nuestra base de clientes?
 =================================================*/
 -- Hay 135 nacionalidades diferentes.
 
SELECT 
    COUNT(DISTINCT pais) AS numero_paises
FROM
    clientes;

 /*===============================================
	4. En nuestra base de clientes, ¿cuál es la nacionalidad de la mayoría de nuestros clientes?
    - Obtén los 10 primeros. Si coinciden ordénalos por orden alfabético.
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
	8. ¿Cuál es la estancia media, la máxima y la mínima?
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


 /*===============================================
	9. ¿Qué fechas abarca nuestra Base de Datos?
 =================================================*/
 -- 1 julio 2015 al 19 julio 2016
 
SELECT 
	MIN(checkin) AS Inicio,
    MAX(checkout) AS Final
FROM
	reservas;
    
 /*===============================================
	10. ¿Qué meses se han alquilado más de 500 plazas de garaje?
 =================================================*/    
SELECT 
    YEAR(r.checkin) AS anio,
    MONTHNAME(r.checkin) AS mes,
    COUNT(p.id_reserva) AS total_plazas_parking
FROM 
    servicio_parking p
JOIN 
    reservas r ON p.id_reserva = r.id_reserva
GROUP BY 
    anio, MONTH(r.checkin), mes
HAVING 
    total_plazas_parking > 500
ORDER BY 
    anio DESC, MONTH(r.checkin) DESC;
    
 /*===============================================
	11. ¿Qué perfil de cliente nos visita más? (Individual,parejas o familias)
 =================================================*/
 -- Parejas
 
SELECT 
    IF((adultos + ninos + bebes) = 1, 'Individual', 
        IF((adultos + ninos + bebes) = 2, 'Pareja', 'Familia')
    ) AS tipo_reserva,
    COUNT(DISTINCT id_reserva) AS reservas
FROM reservas
WHERE estado_reserva = 'Check-Out'
GROUP BY tipo_reserva
ORDER BY reservas DESC;

 /*===============================================
	12. ¿Qué perfil de cliente nos cancela más? (Individual,parejas o familias)
 =================================================*/
 -- Parejas
 
SELECT 
    IF((adultos + ninos + bebes) = 1, 'Individual', 
        IF((adultos + ninos + bebes) = 2, 'Pareja', 'Familia')
    ) AS tipo_reserva,
    COUNT(DISTINCT id_reserva) AS reservas
FROM reservas
WHERE estado_reserva = 'Canceled'
GROUP BY tipo_reserva
ORDER BY reservas DESC;

 /*===============================================
	13. ¿Qué tipo de habitaciones se han contratado más?
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
	14. ¿Quiénes son los clientes que más han visitado el hotel? Saca el TOP 10.
 =================================================*/ 
SELECT 
    c.*,
    COUNT(DISTINCT r.id_reserva) AS Reservas
FROM
    clientes c
JOIN reservas r ON c.id_cliente = r.id_cliente
WHERE r.estado_reserva = 'Check-Out'
GROUP BY c.id_cliente
ORDER BY Reservas DESC, c.apellidos
LIMIT 10;

 /*===============================================
	15. ¿Y los que más nos han cancelado? Saca el TOP 10.
 =================================================*/ 
SELECT 
    c.*,
    COUNT(DISTINCT r.id_reserva) AS Reservas
FROM
    clientes c
JOIN reservas r ON c.id_cliente = r.id_cliente
WHERE r.estado_reserva = 'Canceled'
GROUP BY c.id_cliente
ORDER BY Reservas DESC, c.apellidos
LIMIT 10;


 /*===============================================
	16. Clasifica a los clientes en plata, oro y diamante según la cantidad de veces que hayan visitado el hotel. 
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
    r.estado_reserva = 'Check-Out' 
GROUP BY 
    c.id_cliente
ORDER BY 
    numero_visitas DESC;
    
    
 /*===============================================
	17. Cuántos clientes hay de cada categoría de  clientes?
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
	18. Indica cuantas reservas ha habido en cada temporada. Puedes usar las estaciones del año como guía.
 =================================================*/
SELECT 
    CASE 
        WHEN MONTH(checkin) IN (12, 1, 2) THEN 'Invierno'
        WHEN MONTH(checkin) IN (3, 4, 5) THEN 'Primavera'
        WHEN MONTH(checkin) IN (6, 7, 8) THEN 'Verano'
        WHEN MONTH(checkin) IN (9, 10, 11) THEN 'Otoño'
    END AS estacion,
    COUNT(DISTINCT id_reserva) AS total_reservas
FROM 
    reservas
WHERE 
    estado_reserva = 'Check-Out'
GROUP BY 
    estacion
ORDER BY 
    total_reservas DESC;

 /*===============================================
	19. Usando CTEs, indica cuantos adultos, niños o bebes han acudido al hotel en cada mes
 =================================================*/ 

WITH estadisticas_mensuales AS (
    SELECT 
        MONTH(checkin) AS mes_num,
        MONTHNAME(checkin) AS nombre_mes,
        adultos,
        ninos,
        bebes
    FROM reservas
    WHERE checkin BETWEEN '2015-07-01' AND '2016-06-30'
      AND estado_reserva = 'Check-Out'
)
SELECT 
    nombre_mes,
    SUM(adultos) AS total_adultos,
    SUM(ninos) AS total_ninos,
    SUM(bebes) AS total_bebes
FROM estadisticas_mensuales
GROUP BY mes_num, nombre_mes
ORDER BY mes_num;

 /*===============================================
	20. Crea una función que indica cuanto factura el spa en el mes indicado
 =================================================*/ 
DELIMITER $$
CREATE FUNCTION facturacion_spa_mes(mes_consulta INT, anio_consulta INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(s.precio) INTO total
    FROM servicio_spa s
    JOIN reservas r ON s.id_reserva = r.id_reserva
    WHERE MONTH(r.checkin) = mes_consulta 
      AND YEAR(r.checkin) = anio_consulta;

    RETURN IFNULL(total, 0);
END $$

DELIMITER ; 

-- Vemos el resultado obtenido para agosto de 2016:

SELECT facturacion_spa_mes(8, 2015) AS ingresos_spa_agosto;

 /*===============================================
	21. Vista que informa sobre los ingresos del spa en cada mes según año
 =================================================*/
CREATE OR REPLACE VIEW ingresos_spa_mes AS
SELECT 
	YEAR(r.checkin) AS anio,
    MONTHNAME(r.checkin) AS mes,
    SUM(s.precio) AS total_facturado_spa
FROM 
    servicio_spa s
JOIN 
    reservas r ON s.id_reserva = r.id_reserva
GROUP BY 
    anio, MONTH(r.checkin), mes
ORDER BY 
    anio DESC, MONTH(r.checkin) DESC;
    
    
-- Vemos los datos de la vista:
SELECT * FROM ingresos_spa_mes;

-- Aplicamos filtro de año = 2015 a la vista:
SELECT * FROM ingresos_spa_mes WHERE anio = 2015;

 /*===============================================
	22. Vista que informa sobre el precio total para cada reserva
 ================================================= 
 -- Objetivo: obtener el el desglose de costes y el precio total final por reserva.
 -- Pasos:
	-- 1. Creamos una CTE para obtener la estancia de una reserva en días. En caso de que salga y entre el mismo día se pone 1.
    -- 2. Para el cálculo de cada servicio o el coste de la habitacion creamos una subconsulta asociando el id de cada tabla correspondiente al id de la CTE.
		*Para el cálculo del servicio de comida si es niño cobraremos la mitad y si es bebé nada.
	-- 3. Sumamos todos esos costes y multiplicamos por los dias en caso de ser necesario(habitaciones, parking y comida)
    
-- NOTA: la CTE se crea porque es más eficiente en memoria, es más legible y permite reutilizar el código.
 */
 
CREATE OR REPLACE VIEW vista_facturacion_reservas AS
WITH datos_base AS (
    SELECT 
        r.*,
        h.tarifa,
        -- Calculamos los días. Si entran y salen el mismo día, ponemos 1.
        IF(DATEDIFF(r.checkout, r.checkin) = 0, 1, DATEDIFF(r.checkout, r.checkin)) AS dias_estancia
    FROM reservas r
    JOIN habitaciones h ON r.id_habitacion = h.id_habitacion
)
SELECT 
    id_reserva,
    id_cliente,
    adultos,
    ninos,
    estado_reserva,
    dias_estancia,

    -- 1. Precio de la habitación (obtenido mediante el JOIN)
    tarifa AS precio_habitacion,
    
    -- 2. Total Parking (ya viene calculado en su tabla)
    IFNULL((SELECT SUM(p.precio_total) FROM servicio_parking p WHERE p.id_reserva = datos_base.id_reserva), 0) AS coste_parking,
    
    -- 3. Total Spa (suma de todos los tratamientos de esa reserva)
    IFNULL((SELECT SUM(s.precio) FROM servicio_spa s WHERE s.id_reserva = datos_base.id_reserva), 0) AS coste_spa,
    
    -- 4. Total Comida (Precio menú * total de personas que pueden comer. Los bebes no pagan y los niños pagan la mitad)
    -- Aquí sumamos adultos + niños. Si los bebés no pagan, no los incluimos.
    IFNULL((SELECT SUM((c.precio * adultos) + (c.precio * 0.5 * ninos)) 
            FROM servicio_comida c 
            WHERE c.id_reserva = datos_base.id_reserva), 0) AS coste_comida,
            
    -- 5. CÁLCULO DEL GRAN TOTAL
    ((tarifa * dias_estancia) + 
     IFNULL((SELECT SUM(p.precio_total * dias_estancia) FROM servicio_parking p WHERE p.id_reserva = datos_base.id_reserva), 0) +
     IFNULL((SELECT SUM(s.precio) FROM servicio_spa s WHERE s.id_reserva = datos_base.id_reserva), 0) +
     IFNULL((SELECT SUM(((c.precio * adultos) + (c.precio * 0.5 * ninos)) * dias_estancia) FROM servicio_comida c WHERE c.id_reserva = datos_base.id_reserva), 0)
    ) AS factura_total

FROM 
    datos_base;


-- Vemos la vista:
SELECT
	*
FROM 
	vista_facturacion_reservas;


 /*===============================================
	23. Usando funciones ventana, crea un listado donde se vea el gasto acumulado de cada cliente y el puesto que le corresponde en un ranking de gasto.
 =================================================*/ 
-- RANK() OVER(...) compara el total acumulado contra los totales de los demas y le asigna un valor.
-- WHERE estado_reserva = 'Check-out'  porque solo queremos los ingresos confirmados.

-- El cliente 39 es nuestro cliente más rentable ya que su gasto en aproximadamente 1 año es de 33640. 
-- Se observan que hay varios clientes que superan los 30000€, por lo que se valora crear a futuro una nueva clasificación en cuanto al gasto, en vez de las visitas. 

SELECT 
    id_cliente,
    SUM(factura_total) AS gasto_real_ingresado,
    RANK() OVER(ORDER BY SUM(factura_total) DESC) AS posicion_ranking
FROM vista_facturacion_reservas
WHERE estado_reserva = 'Check-out'
GROUP BY id_cliente
ORDER BY posicion_ranking;

/*=============================================================================
    24. Crea una tabla que resuma lo que se ingresa por cada servicio.
 =============================================================================== 
 - Este análisis revela una fuerte dependencia sel servicio de Restaurante ya que aproximadamente triplica los ingresos de parking y spa juntos.
 - Esto indica que este servicio es un pilar fundamental en la rentabilidad del hotel.
 - El servicio de parking genera un margen de beneficio neto muy altos ya que los costes de mantenimiento son muy bajos respecto a los otros dos. Se podría sugerir
 el aumento de la tarifa en temporada alta.
 - El sevicio de spa presenta el valor más bajo de los tres. Además es el que suele tener los costes más altos por lo que se sugiere lanzar promociones cruzadas como vales de descuento.
 */
SELECT 
    s.id_servicio,
    s.tipo_servicio,
    CASE 
        WHEN s.tipo_servicio = 'Restaurante' THEN ROUND((SELECT SUM(coste_comida * dias_estancia) FROM vista_facturacion_reservas WHERE estado_reserva = 'Check-out'),2)
        WHEN s.tipo_servicio = 'Parking' THEN ROUND((SELECT SUM(coste_parking * dias_estancia) FROM vista_facturacion_reservas WHERE estado_reserva = 'Check-out'),2)
        WHEN s.tipo_servicio = 'Spa' THEN ROUND((SELECT SUM(coste_spa) FROM vista_facturacion_reservas WHERE estado_reserva = 'Check-out'),2)
        ELSE 0
    END AS ingresos_totales
FROM servicios s;

/*=============================================================================
    25. Función para calcular el pago pendiente final
 =============================================================================== 
 -- OBJETIVO: Calcular la cantidad exacta que el cliente debe abonar al salir.
 -- PASOS:
    -- 1. Creamos tres variables(total_factura, deposito,pendiente)
    -- 2. Obtenemmos el dato de la vista creada con anterioridad 'vista_facturacion_reservas' y lo guarada en su variable correspondiente.
    -- 3. Obtenemos el dato de deposito de la tabla reservas y lo guarda en su variable correspondiente.
    -- 4. Calculamos la resta. En caso de no haber deposito (null) se pone un 0.
 -- Utilidad: Automatiza el proceso de facturación en el mostrador de recepción.
 */
 
DELIMITER $$
 
CREATE FUNCTION calcular_pago_pendiente(reserva_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total_factura DECIMAL(10,2);
    DECLARE v_deposito DECIMAL(10,2);
    DECLARE v_pendiente DECIMAL(10,2);

    -- 1. Obtenemos el total de la vista que ya suma todo
    SELECT factura_total INTO v_total_factura 
    FROM vista_facturacion_reservas 
    WHERE id_reserva = reserva_id;

    -- 2. Obtenemos el depósito de la tabla original
    SELECT deposito INTO v_deposito 
    FROM reservas 
    WHERE id_reserva = reserva_id;

    -- 3. Calculamos la resta
    SET v_pendiente = v_total_factura - IFNULL(v_deposito, 0);

    RETURN v_pendiente;
END $$

DELIMITER ;

-- Uso de la función para una reserva:
SELECT calcular_pago_pendiente(105) AS total_a_cobrar;