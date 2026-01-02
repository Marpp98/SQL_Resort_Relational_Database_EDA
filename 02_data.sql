/* ===============================================
			Proyecto SQL: Resort Hotelero
 =================================================           
- Este archivo contiene la insercción de datos en sus tablas correspondientes.
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
			Tabla Clientes
 ================================================= */ 
 
SET GLOBAL local_infile = 1;
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

select * from habitaciones;
select * from canales;
select * from servicios;
select * from servicio_parking;
select * from clientes;
select * from reservas;
select * from servicio_comida;
select * from servicio_spa;


-- 1. Desactivar temporalmente la revisión de llaves foráneas
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Vaciar la tabla (ahora sí te dejará)
TRUNCATE TABLE servicio_comida;

-- 3. Volver a activar la seguridad (IMPORTANTE)
SET FOREIGN_KEY_CHECKS = 1;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';


