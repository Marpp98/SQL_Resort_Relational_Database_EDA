/* ===============================================
			Proyecto SQL: Resort Hotelero
 =================================================           
- Este archivo contiene la insercción de datos en sus tablas correspondientes.
- Excepto aquellas que se han insertado de manera manual el resto se trató de cargar por table Wizard.alter
- Este método fue cambiado por dos motivos:
	1. En las instrucciones del trabajo se pedía que el código fuera ejecutable desde 0.
    2. Al tener demasiados registros se demoraba demasiado el tiempo.
- En las tablas Servicios y Canales solo es necesario poner el tipo de servio o canal ya que su id es automático.

- NOTA: para poder usar LOAD DATA LOCAL INFILE fue necesario hacer unas comprobaciones previas.
	1. Añadir OPT_LOCAL_INFILE=1 a la configuración.
	2. Establecer local_infile = 1
    3. SHOW VARIABLES LIKE 'local_infile' para comprobar que verdaderamente está activado;
*/

/* ===============================================
			Tabla Servicios
 ================================================= */ 

INSERT INTO servicios (tipo_servicio) VALUES
('Parking'),
('Restaurante'),
('Spa');

/* ===============================================
			Tabla Canales
 ================================================= */ 

INSERT INTO canales (canal_distribucion) VALUES
('Direct'),
('TA/TO'),
('Corporate'),
('GDS'),
('Otros');

/* ===============================================
			Activar LOAD DATA LOCAL INFILE
 ================================================= */ 
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';


/* ===============================================
			Tabla Clientes
 ================================================= */ 
 
LOAD DATA LOCAL INFILE 'C:/Users/maria/Desktop/Master_data_science/SQL_Resort_Relational_Database_EDA/data/clientes_finales.csv'
INTO TABLE clientes
CHARACTER SET ascii
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* ===============================================
			Tabla Habitaciones
 ================================================= */ 
 
LOAD DATA LOCAL INFILE 'C:/Users/maria/Desktop/Master_data_science/SQL_Resort_Relational_Database_EDA/data/habitaciones.csv'
INTO TABLE habitaciones
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* ===============================================
			Tabla Reservas
 ================================================= */ 
 
LOAD DATA LOCAL INFILE 'C:/Users/maria/Desktop/Master_data_science/SQL_Resort_Relational_Database_EDA/data/reservas_2.3.csv'
INTO TABLE reservas
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* ===============================================
			Tabla Servicio Parking
 ================================================= */ 

LOAD DATA LOCAL INFILE 'C:/Users/maria/Desktop/Master_data_science/SQL_Resort_Relational_Database_EDA/data/parking_2.1.csv'
INTO TABLE servicio_parking
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

/* ===============================================
			Tabla Servicio Comida
 ================================================= */ 

LOAD DATA LOCAL INFILE 'C:/Users/maria/Desktop/Master_data_science/SQL_Resort_Relational_Database_EDA/data/comida_2.csv'
INTO TABLE servicio_comida
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* ===============================================
			Tabla Servicio Comida
 ================================================= */ 

LOAD DATA LOCAL INFILE 'C:/Users/maria/Desktop/Master_data_science/SQL_Resort_Relational_Database_EDA/data/spa_3.csv'
INTO TABLE servicio_spa
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n'
(id_servicio, id_reserva, tipo_tratamiento, precio)
SET id_ticket_spa = NULL;

/* ==================================
			Comprobaciones
================================== */

select * from habitaciones;
select * from canales;
select * from servicios;
select * from servicio_parking;
select * from clientes;
select * from reservas;
select * from servicio_comida;
select * from servicio_spa;



/* ====================================================================================
En caso de querer vaciar una tabla, pero no borrarla habría que usar el siguiente código:

	-- 1. Desactivar temporalmente la revisión de llaves foráneas
		SET FOREIGN_KEY_CHECKS = 0;

	-- 2. Vaciar la tabla
		TRUNCATE TABLE servicio_comida;

	-- 3. Volver a activar la seguridad (PASO CLAVE)
		SET FOREIGN_KEY_CHECKS = 1;
*/

/* ==================================
			Transacciones
================================== */
-- Se crea una transacción que garantiza que la contratación de una reserva y el servicio de comida se creen de forma atómica, es decir, o se crean ambas o ninguna.


DELIMITER $$

-- 1. Indicamos los datos que posteriormente se darán para llamar al procedimiento.
CREATE PROCEDURE insertar_reserva_y_comida(
-- Tabla Reservas
    IN p_id_cliente INT,
    IN p_id_habitacion INT,
    IN p_id_canal INT,
    IN p_estado VARCHAR(30),
    IN p_adultos INT,
    IN p_ninos INT,
    IN p_bebes INT,
    IN p_deposito DECIMAL(10,2),
    IN p_checkin DATE,
    IN p_checkout DATE,
-- Tabla servicio_comida
    IN p_tipo_comida VARCHAR(50),
    IN p_precio_total DECIMAL(10,2)
)
BEGIN
    -- Declaramos una variable para obtener el nuevo id_reserva
    DECLARE v_nuevo_id_reserva INT;

    -- Si algo falla, se hará un  ROLLBACK
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    -- Iniciamos la transacción
    START TRANSACTION;

    -- 1. Insertamos la reserva en la tabla de hechos
    INSERT INTO reservas (
        id_cliente, id_habitacion, id_canal, estado_reserva, 
        adultos, ninos, bebes, deposito, checkin, checkout
    )
    VALUES (
        p_id_cliente, p_id_habitacion, p_id_canal, p_estado, 
        p_adultos, p_ninos, p_bebes, p_deposito, p_checkin, p_checkout
    );

    -- 2. Recuperamos el ID que se acaba de generar para esa reserva
    SET v_nuevo_id_reserva = LAST_INSERT_ID();

    -- 3. Insertamos en servicio_comida de ese id_reserva. No es necesario poner id_servicio ya que está establecido por defecto en 2.
    INSERT INTO servicio_comida (id_reserva, tipo_comida, precio)
    VALUES (v_nuevo_id_reserva, p_tipo_comida, p_precio);

    -- 4. Confirmamos los cambios
    COMMIT;
END $$

DELIMITER ;

-- LLamamos a la transacción
CALL insertar_reserva_y_comida(
    1, '101', 1, 'Ckeck-Out', 2, 0, 0, 50.00, 
    '2026-06-01', '2026-06-10', 'HB', 50.00
);

-- Comprobamos que se ha insertado correctamente:
SELECT 
	*
FROM 
	reservas r
JOIN servicio_comida c ON r.id_reserva = c.id_reserva
WHERE r.id_reserva = LAST_INSERT_ID();

SELECT * FROM RESERVAS where id_cliente = 1 and id_habitacion = 101 ORDER BY id_reserva DESC ;