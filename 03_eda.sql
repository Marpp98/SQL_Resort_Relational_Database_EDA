/*===============================================
			Proyecto SQL: Resort Hotelero
 =================================================           
- Este archivo contiene la creación de querys.
- El archivo consta de 27 querys que responden a las preguntas que se muestran previamente al resultado. 
Algunos de ellos contienen las respuestas para futuras comprobaciones
*/

/*===============================================
- Antes de comenzar se van a realizar una serie de inserciones, actualizaciones y borrados de datos para entender como funciona.
- En este caso usaremos la tabla clientes.
===============================================*/
SELECT 
    *
FROM
    clientes;

INSERT INTO clientes (nombre, apellidos, email, telefono, pais)
VALUES ('Lucas', 'Perez', 'lucas.perez@gmail.com', '+34 674 583 961', 'ESP');

SELECT 
    *
FROM
    clientes
ORDER BY id_cliente DESC;

-- Observamos que Lucas Pérez ha sido creado con el id 1008.
-- Supongamos que Lucas, se equivocó a la hora de poner su email:

UPDATE clientes 
SET email = 'lucas.perez@hotmail.com'
WHERE id_cliente = 1008;

-- Comprobamos el cambio:

SELECT 
    *
FROM
    clientes
WHERE id_cliente = '1008';

-- Ahora vemos como Lucas ha cambiado su email de gmail a hotmail.
-- Por último, imaginemos que tenemos que borrar su registro.

DELETE FROM clientes 
WHERE id_cliente = 1008;

-- Comprobamos que ya no existe:
SELECT 
    *
FROM
    clientes
WHERE id_cliente = '1008';


/*===============================================
	1. Cuantas reservas se han realizado
 =================================================*/ 
 -- Se han realizado 49157 reservas.
 -- Esta consulta es útil para obtener totales de reservas independientemente de su estado.

SELECT 
    COUNT(*)
FROM
    reservas;
    
 /*===============================================
	2. ¿Cuantas reservas han sido canceladas?
 =================================================*/ 
 -- Han cancelado 16959 reservas, lo que se traduce en un 34,5% de cancelaciones.
 -- Para la gestión hotelera, es importante saber la cantidad de cancelaciones que se tiene respecto al total debido al coste de oportunidad de no alquilar esas habitaciones
 -- En este caso, el valor obtenido es muy alto. Sería recomendable mirar (si tenemos el dato) cuándo se hicieron esas cancelaciones.

SELECT 
    COUNT(*) AS total_reservas,
    SUM(CASE WHEN estado_reserva = 'Canceled' THEN 1 ELSE 0 END) AS total_canceladas,
    ROUND(
        (SUM(CASE WHEN estado_reserva = 'Canceled' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS porcentaje_cancelacion
FROM reservas;

/*===============================================
	3. ¿Cuantas reservas se hacen por cada canal? ¿Y cuántas cancelaciones?
 =================================================
 -- Gracias a esta query obtenemos la calidad de la demanda ya que por ejemplo, a través de las agencias es donde se obtiene la mayor cantidad de reservas sin embargo,
 un 38,55% de las reservas totales de este tipo acaban en cancelaciones por lo que no es un canal muy eficiente.
 -- Por otro lado, tenemos aquellas reservas que se hacen directamente en el hotel cuya tasa de cancelacion se corresponde a un 14,75% lo que es mucho más eficiente.
 */
SELECT 
    c.canal_distribucion, 
    COUNT(DISTINCT r.id_reserva) AS total_reservas_unicas,
    COUNT(DISTINCT CASE WHEN r.estado_reserva = 'Check-Out' THEN r.id_reserva END) AS total_checkouts,
    COUNT(DISTINCT CASE WHEN r.estado_reserva = 'Canceled' THEN r.id_reserva END) AS total_canceladas,
    -- Cálculo del Ratio de Cancelación
    ROUND((COUNT(DISTINCT CASE WHEN r.estado_reserva = 'Canceled' THEN r.id_reserva END) / COUNT(DISTINCT r.id_reserva)) * 100, 2) AS ratio_cancelacion_pct
FROM reservas r
JOIN canales c ON r.id_canal = c.id_canal
GROUP BY c.canal_distribucion
ORDER BY ratio_cancelacion_pct DESC;

 /*===============================================
	4. ¿Cuantas adultos han acudido a nuestro hotel? ¿Y niños o bebés?
 =================================================*/ 
 -- Han acudido 56462 adultos, 2428 niños y 334 bebes.
 -- Esto indica que nuestro cliente principal son adultos y por tanto se pueden crear packs o actividades más orientadas a ellos.
 
SELECT 
    SUM(adultos) AS total_adultos,
    SUM(ninos) AS total_ninos,
    SUM(bebes) AS total_bebes
FROM
    reservas
WHERE
	estado_reserva = 'Check-Out';
    
/*===============================================================================================================
   - Las siguientes preguntas están relacionadas con la nacionalidad de los clientes.
   - Estos datos son importantes ya que afecta a todos los departamento, por ejemplo para adaptar la oferta gastronómica 
   o para lanzar campañas de marketing en mercados que están en ascenso.
   */
    
    
 /*===============================================
	5. ¿Cuatas nacionalidades diferentes hay en nuestra base de clientes?
 =================================================*/
 -- Hay 135 nacionalidades diferentes.
 
SELECT 
    COUNT(DISTINCT pais) AS numero_paises
FROM
    clientes;

 /*===============================================
	6. En nuestra base de clientes, ¿cuál es la nacionalidad de la mayoría de nuestros clientes?
    - Obtén los 10 primeros. Si coinciden ordénalos por orden alfabético.
 =================================================*/ 
 -- Portugal, Angola, Grecia, Argentina y Australia.
 -- En este caso, por ejemplo, es curioro como la mayoría de clientes son Prtugueses pero que después hay angoleños. 
 -- Esto podría traducirse en la existencia de una conexión entre el mercado principal (Portugal) y mercados secundarios como Angola (país de lengua portuguesa).
 -- Por tanto, sería importante que el personal del hotel hablase portugués para atender a nuestros clientes principales.alter
 
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
	7. Qué régimen de comida es el más contratado.
 =================================================*/ 
 -- El régimen más contratado es BB(bed & breakfast).
 -- Esto podría deberse a que los clientes prefieren salir del hotel y hacer excursiones o hacer turismo en vez de quedarse a descansar o hacer actividades del hotel.
 -- Se podría proponer crear nuevas actividades u ofrecer excursiones propias para retener más clientes y que opten por otros tipos de régimen.
 
SELECT 
    tipo_comida, 
    COUNT(*) AS contrataciones
FROM
    servicio_comida
GROUP BY tipo_comida
ORDER BY contrataciones DESC;
 
 
 /*===============================================
	8. Qué servicio de spa es el más contratado.
 =================================================*/ 
 -- El servicio más contratado es balneario.
 -- En este caso todos los tratamientos se reparten de manera uniforme debido a la política de precios que impide la canibalización entre los servicios ofrecidos.
 -- Se podrían crear promociones cuando el cliente reserva la habitación para aumentar las constrataciones de estos servicios.
 
SELECT 
    tipo_tratamiento, 
    COUNT(*) AS contrataciones
FROM
    servicio_spa
GROUP BY tipo_tratamiento
ORDER BY contrataciones DESC;
 
 
 /*===============================================
	9. ¿Cuál es la media de plazas de parking contratadas?¿Y la moda?
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

-- Como ambos datos convergen en 1, el hotel puede preveer su inventario de parking simplificando su gestión.

 /*===============================================
	10. ¿Cuál es la estancia media, la máxima y la mínima?
 =================================================*/ 
-- Media = 3
-- Max = 60
-- Min = 0

-- Estos daos nos indican que la mayoría de clientes son de corta estancia. Lo que implica una mayor rotación y un mayor gasto, por ejemplo, en costes de limpieza.
-- Existe otro segmento de clientes que usan la habitación por horas (0 días), son clientes muy rentables porque permiten alquilar la misma habitación 2 veces en 24 horas,
-- pero no son nuestro cliente objetivo.
-- Por último, el segmento de estancias largas representa a clientes que nos proporcionan alta rentabilidad debido a su bajo coste operativo.
-- Por ello, el hotel debería tratar de centrarse en clientes que amplien su estancia para obtener una mayor rentabilidad.

SELECT 
	ROUND(AVG(DATEDIFF(checkout, checkin))) AS estancia_media,
    MAX(DATEDIFF(checkout, checkin)) AS estancia_maxima,
    MIN(DATEDIFF(checkout, checkin)) AS estancia_minima
FROM reservas
WHERE estado_reserva = 'Check-Out';


 /*===============================================
	11. ¿Qué fechas abarca nuestra Base de Datos?
 =================================================*/
 -- 1 julio 2015 al 19 julio 2016
 -- Se trata de una query necesaria para saber el rango de fechas que abarca la base de datos.
 
SELECT 
	MIN(checkin) AS Inicio,
    MAX(checkout) AS Final
FROM
	reservas;
    
 /*===============================================
	12. ¿Qué meses se han alquilado más de 500 plazas de garaje?
 =================================================*/  
 -- Query necesaria para conocer picos altos de demanda de plazas de garaje.
 
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
	13. ¿Qué perfil de cliente nos visita más? (Individual,parejas o familias)
 =================================================*/
 -- Parejas
 -- Saber que la mayoría de clientes son parejas nos permite orientar nuestras campañas de marketing a este tipo de clientes, por ejemplo un pack DUO con acceso a spa.
 
SELECT 
    CASE 
        WHEN adultos = 1 AND ninos = 0 AND bebes = 0 THEN 'Individual'
        WHEN adultos = 2 AND ninos = 0 AND bebes = 0 THEN 'Pareja'
        WHEN adultos >= 1 AND (ninos > 0 OR bebes > 0) THEN 'Familia'
        ELSE 'Grupo/Otros' 
    END AS tipo_reserva,
    COUNT(DISTINCT id_reserva) AS reservas
FROM reservas
WHERE estado_reserva = 'Check-Out'
GROUP BY tipo_reserva
ORDER BY reservas DESC;

 /*===============================================
	14. ¿Qué perfil de cliente nos cancela más? (Individual,parejas o familias)
 =================================================*/
 -- Parejas
 -- La alta volatilidad de este segmento nos perjudica ya que no se traslada solo a una perdida de habitación 
 -- sino también en una pérdida en los servicios de spa que podían haber contratado.
 -- Para evitarlo, el hotel debería crear políticas de cancelación como un adelanto no reembolsable hasta 24 horas antes.
 
SELECT 
    CASE 
        WHEN adultos = 1 AND ninos = 0 AND bebes = 0 THEN 'Individual'
        WHEN adultos = 2 AND ninos = 0 AND bebes = 0 THEN 'Pareja'
        WHEN adultos >= 1 AND (ninos > 0 OR bebes > 0) THEN 'Familia'
        ELSE 'Grupo/Otros' 
    END AS tipo_reserva,
    COUNT(DISTINCT id_reserva) AS reservas
FROM reservas
WHERE estado_reserva = 'Canceled'
GROUP BY tipo_reserva
ORDER BY reservas DESC;

 /*===============================================
	15. ¿Qué tipo de habitaciones se han contratado más?
 =================================================*/ 
-- La habitación más contratada es la doble interior.
-- Esto sigue la lógica de que el mayor segmento son parejas. En estos casos podría interesar que alquilasen la doble exterior debido a su mayor precio.
-- Para ello, se podría lanzar un 'pack premiun' donde se ofrezca este tipo de habitacion más un desayuno en la habitacion o un detalle de bienvenida.
SELECT 
	h.tipo, 
	COUNT(r.id_reserva) AS reservas
FROM 
	reservas r
JOIN habitaciones h ON h.id_habitacion = r.id_habitacion
GROUP BY h.tipo
ORDER BY reservas DESC;


 /*===============================================
	16. ¿Quiénes son los clientes que más han visitado el hotel? Saca el TOP 10.
 =================================================*/ 
 -- Saber los clientes que más han visitado el hotel nos permite saber su fidelidad y por tanto crear promociones o ventajas para seguir manteniéndolos.
 
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
	17. ¿Y los que más nos han cancelado? Saca el TOP 10.
 =================================================*/ 
 -- Saber qué clientes cancelan más es importante ya que son un riesgo.
 -- El hotel podría establecer un sistema de alertas para que esos clientes que cancelan tanto tengan que abonar el 100% de la estancia con antelación.
 
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
	18. Clasifica a los clientes en plata, oro y diamante según la cantidad de veces que hayan visitado el hotel. 
 =================================================*/
 -- Una clasificación por categorías permite al hotel crear promociones específicas y crear acciones que aumenten la fidelidad de los clientes.
 
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(DISTINCT r.id_reserva) AS numero_visitas,
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
	19. Cuántos clientes hay de cada categoría de  clientes?
		**Uso de desubconsulta.
 =================================================*/
 -- En este caso, nos interesaría que los clientes de la categoría Plata aumente ya que significaría la existencia de nuevos clientes que podrían fidelizarse.
 -- Por otro lado, nos indica una alta tasa de fidelización, ya que la mayoría son clientes 'Oro'.
 
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
	20. Indica cuantas reservas ha habido en cada temporada. Puedes usar las estaciones del año como guía.
 =================================================
 -- Esta query nos permite preveer cuando se darán los picos de demanda, en este caso primavera.
 -- Saber qué estacionalidad vamos a tener es importante para poder optimizar la gestión de personal o cuando realizar 
	reformas ruidosas o de mantenimiento que pueden molestar a nuestros clientes.
 */
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
	21. Usando CTEs, indica cuantos adultos, niños o bebes han acudido al hotel en cada mes
 =================================================*/ 
-- Esta query nos permite planificar mejor los recursos y el personal ya que con ella podemos preveer en qué meses hay mas niños 
-- para poder ofrecerles servicios de animación o entretenimiento.
-- En este caso, agosto sería el mes donde más niños y bebes hay y por tanto habría que destinar má recursos a este sector.

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
	22. Crea una función que indica cuanto factura el spa en el mes indicado
 ================================================= 
 -- Saber la facturación del spa cada mes es un dato importante ya que nos permite obtener el dato rápidamente sin la necesidad de hacer joins cada vez que nos lo pidan.
 -- También nos permite comparar rápidamente el mes de dos años diferentes o de dos meses consecutivos para ver la diferencia y así observar los cambios que se hayan producido
	o detectar problemas como una menor facturación asociada a obras en el spa o a la baja de un masajista.*/
    
 -- En cuanto a la función, es necesario establecer el delimitador con anterioridad para que no confunda ; como fin de consulta.   
 -- En este caso, a la hora de llamar a la función será necesario hacer referencia al mes y al año de consulta ambos como números.
 
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
	23. Vista que informa sobre los ingresos del spa en cada mes según año
 =================================================*/
 -- Tener una vista que nos muestre los ingresos por cada mes es muy útil ya que nos permite observar con facílidad como han ido variando a lo largo del tiempo.
 -- Así obtendremos de un solo vistazo los meses de mayor ocupación y menor ocupación y podremos promocionar estos últimos para conseguir que aumenten nuestros ingresos.
 
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
    anio, MONTH(r.checkin);
    
    
-- Vemos los datos de la vista:
SELECT * FROM ingresos_spa_mes;

-- Aplicamos filtro de año = 2015 a la vista:
SELECT * FROM ingresos_spa_mes WHERE anio = 2015;

 /*===============================================
	24. Vista que informa sobre el precio total para cada reserva
 ================================================= 
 -- Objetivo: obtener el el desglose de costes y el precio total final por reserva.
 -- Pasos:
	-- 1. Creamos una CTE para obtener la estancia de una reserva en días. En caso de que salga y entre el mismo día se pone 1.
    -- 2. Para el cálculo de cada servicio o el coste de la habitacion creamos una subconsulta asociando el id de cada tabla correspondiente al id de la CTE.
		*Para el cálculo del servicio de comida si es niño cobraremos la mitad y si es bebé nada.
	-- 3. Sumamos todos esos costes y multiplicamos por los dias en caso de ser necesario(habitaciones, parking y comida)
    
-- NOTA: la CTE se crea porque es más eficiente en memoria, es más legible y permite reutilizar el código.
-- Esta vista nos permite centralizar todos los datos y simplificar los cálculos necesarios para realizar un reporting de ingresos.
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
    
-- Uso de la vista para obtener la facturación total.
SELECT ROUND(SUM(factura_total)) AS facturacion_total_historica
FROM vista_facturacion_reservas;


 /*===============================================
	25. Usando funciones ventana, crea un listado donde se vea el gasto acumulado de cada cliente y el puesto que le corresponde en un ranking de gasto.
 =================================================*/ 
 
-- RANK() OVER(...) compara el total acumulado contra los totales de los demas y le asigna un valor.
-- WHERE estado_reserva = 'Check-out'  porque solo queremos los ingresos confirmados.

-- El cliente 39 es nuestro cliente más rentable ya que su gasto en aproximadamente 1 año es de 33640. 
-- Se observan que hay un segmento de clientes que superan los 30000€. 
-- Por lo tanto, es recomendable cambiar el programa de fidelización de un modelo basado en 'volumen de visitas' a uno basado en 'valor de gasto real'.
-- De este modo se priorizaran a los clientes que han generado un mayor ingreso al hotel.

SELECT 
    id_cliente,
    SUM(factura_total) AS gasto_real_ingresado,
    RANK() OVER(ORDER BY SUM(factura_total) DESC) AS posicion_ranking
FROM vista_facturacion_reservas
WHERE estado_reserva = 'Check-out'
GROUP BY id_cliente
ORDER BY posicion_ranking;


-- Como se ha detectado un grupo de clientes que gastan más de 30000€ nos interesa saber cuántos son y su total:

SELECT 
    COUNT(id_cliente) AS numero_de_vips, 
    SUM(gasto_individual) AS facturacion_total_vips
FROM (
    SELECT id_cliente, SUM(factura_total) AS gasto_individual
    FROM vista_facturacion_reservas
    WHERE estado_reserva = 'Check-out'
    GROUP BY id_cliente
    HAVING gasto_individual > 30000
) AS segmento_premium;

/*=============================================================================
    26. Crea una tabla que resuma lo que se ingresa por cada servicio.
 =============================================================================== 
 - Este análisis revela una fuerte dependencia sel servicio de Restaurante ya que aproximadamente triplica los ingresos de parking y spa juntos.
 - Esto indica que este servicio es un pilar fundamental en la rentabilidad del hotel.
 - El servicio de parking genera un margen de beneficio neto muy altos ya que los costes de mantenimiento son muy bajos respecto a los otros dos. Se podría sugerir
 el aumento de la tarifa en temporada alta.
 - El sevicio de spa presenta el valor más bajo de los tres. Además es el que suele tener los costes más altos por lo que se sugiere lanzar promociones cruzadas 
 como vales de descuento.
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
    27. Función para calcular el pago pendiente final
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