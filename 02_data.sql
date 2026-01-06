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




