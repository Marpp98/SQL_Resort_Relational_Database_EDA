/* ===============================================
			Proyecto SQL: Resort Hotelero
 =================================================           
- Este archivo contiene la creación de la base de datos y 
de las tablas contenidas en ellas. 
- También incluye el establecimientos de las claves primarias y foráneas,
así como constraints*/

/*==============================================
			Creación de la base de datos
==============================================*/
CREATE DATABASE IF NOT EXISTS resort_hotelero;
USE resort_hotelero;

/*============================================
		Eliminación de tablas
============================================
-- 1. Se desactiva la validación de las claves foráneas para poder ejecutar los borrados de tabla sin que aparezca un error de dependencia.
-- 2. Tras haberlas borrado, se activa de nuevo su validación.*/

SET FOREIGN_KEY_CHECKS = 0; 			-- Desactivar

DROP TABLE IF EXISTS servicio_spa;
DROP TABLE IF EXISTS servicio_comida;
DROP TABLE IF EXISTS servicio_parking;
DROP TABLE IF EXISTS reservas;
DROP TABLE IF EXISTS canales;
DROP TABLE IF EXISTS habitaciones;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS servicios;

SET FOREIGN_KEY_CHECKS = 1; 			-- Activar


/*============================================
		CREACIÓN DE TABLAS
============================================*/

/*============================================
	Clientes:
		- Se establece el id_cliente como clave primaria con AUTO_INCREMENT para garantizar la unicidad de cada cliente.
        - Nombre y apellidos no pueden ser nulos ya que son datos obligatorios para identificar al cliente.
        - Email debe ser un valor único ya que se considera un identificador de contacto único para cada cliente.
        - Teléfono no se define como valor único ya que ya que los números pueden ser reasignados 
		por las compañías telefónicas a distintos usuarios a lo largo del tiempo.
        - Pais es opcional porque no es un dato clave para el funcionamiento del sistema.
============================================*/


CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    pais VARCHAR(50)
);

/*============================================
Habitaciones:
		- Se establece el id_habitación como clave primaria. En este caso no se establece el autoincremento ya que 
        los hoteles tienen numeraciones propias en las habitaciones.
        - Tipo no puede ser nulo ya que son datos obligatorios para identificar la habitación.
        - Tarifa puede ser un precio con 2 decimales como máximo. el valor no puede ser menor que 0 ni nulo.
============================================*/

CREATE TABLE IF NOT EXISTS habitaciones (
    id_habitacion INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    tarifa DECIMAL(10,2) NOT NULL CHECK (tarifa >= 0)
);

/*============================================
Canales:
		- Se establece el id_canal como clave primaria con incremento para garantizar la unicidad de cada canal.
        - Canal de distribución se establce como campo único que no debe ser nulo.
============================================*/

CREATE TABLE IF NOT EXISTS canales (
    id_canal INT AUTO_INCREMENT PRIMARY KEY,
    canal_distribucion VARCHAR(50) NOT NULL UNIQUE
);

/*============================================
Servicios:
		- Se establece el id_servicio como clave primaria con incremento para garantizar la unicidad de cada servicio.
        - Tipo de distribución se establce como campo único que no debe ser nulo.
============================================*/

CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    tipo_servicio VARCHAR(50) NOT NULL UNIQUE
);

/*============================================
	Tabla principal o fact table: Reservas
============================================
	- Esta tabla representa el hecho transaccional principal del sistema. Cada fila representa una reserva.
	- Se establece id_reserva como clave primaria para identificar cada reserva como unica.
	- id_cliente, id_habitacion e id_canal son campos que no pueden ser nulos ya que servirán para relacionarse con otras tablas.
	- estado_reserva no puede ser nulo para asegurar la trazabilidad del estado.
	- adultos, bebes y niños indican la cantidad de personas de cada tipo asociado a cada reserva. No pueden ser menos a 0.alter
	- deposito es la cantidad que un cliente deja cuando hace la reserva y por tanto debe ser 0 o mayor.
	- checkin y checkout representa las fechas de entrada y salida en el hotel, por ello no pueden ser nulos.

	- Claves foráneas:
		- fk_reserva_cliente: garantiza la integridad referencial con la tabla clientes.
		- fk_reserva_habitacion: asegura que la habitación asignada existe en el sistema.
		- fk_reserva_canal: referencia el canal de distribución utilizado.
*/

CREATE TABLE IF NOT EXISTS reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_habitacion INT NOT NULL,
    id_canal INT NOT NULL,
    estado_reserva VARCHAR(30) NOT NULL,
    adultos INT NOT NULL CHECK (adultos >= 0),
    ninos INT NOT NULL CHECK (ninos >= 0),
    bebes INT NOT NULL CHECK (bebes >= 0),
    deposito DECIMAL(10,2) CHECK (deposito >= 0),
    checkin DATE NOT NULL,
    checkout DATE NOT NULL,

    CONSTRAINT fk_reserva_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_reserva_habitacion
        FOREIGN KEY (id_habitacion)
        REFERENCES habitaciones(id_habitacion),

    CONSTRAINT fk_reserva_canal
        FOREIGN KEY (id_canal)
        REFERENCES canales(id_canal)
);

/*============================================
		Creación de servicios(subtipos)
============================================*/

/*============================================
	servicio_parking: 
		- Almacena la contratación del servicio de parking asociada a una reserva concreta. Es una relación uno a uno respecto a la tabla reservas.
		- id_reserva se establece como como clave primaria, ya que una reserva puede contratar como máximo un servicio de parking.
		- Número de plazas y precios incluyen restricciones CHECK para garantizar valores coherentes.
		- Claves foráneas:
			- fk_parking_servicio: asegurar su relacion con la tabla servicios.
			- fk_parking_reserva : asegurar la integridad con la tabla reservas.
============================================*/

CREATE TABLE IF NOT EXISTS servicio_parking (
    id_servicio INT NOT NULL DEFAULT 1,
    id_reserva INT PRIMARY KEY,
    numero_plazas INT NOT NULL CHECK (numero_plazas > 0),
    precio_unit DECIMAL(10,2) NOT NULL CHECK (precio_unit >= 0),
    precio_total DECIMAL(10,2) NOT NULL CHECK (precio_total >= 0),

    CONSTRAINT fk_parking_servicio
        FOREIGN KEY (id_servicio)
        REFERENCES servicios(id_servicio),

    CONSTRAINT fk_parking_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva)
);

/*============================================
	servicio_comida: 
		- Almacena la contratación del servicio de comida asociada a una reserva concreta. Es una relación uno a uno respecto a la tabla reservas.
		- id_reserva se establece como como clave primaria, ya que una reserva puede contratar como máximo un servicio de comida.
		- Tipo de comida hace referencia al régimen alimentario que no puede ser nulo
		- Precio incluye restricciones CHECK para garantizar valores coherentes.
		- Claves foráneas:
			- fk_comida_servicio: asegurar su relacion con la tabla servicios.
			- fk_comida_reserva : asegurar la integridad con la tabla reservas.
============================================*/

CREATE TABLE IF NOT EXISTS servicio_comida (
    id_servicio INT NOT NULL DEFAULT 2,
    id_reserva INT PRIMARY KEY,
    tipo_comida VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),

    CONSTRAINT fk_comida_servicio
        FOREIGN KEY (id_servicio)
        REFERENCES servicios(id_servicio),

    CONSTRAINT fk_comida_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva)
);

/*============================================
	servicio_spa: 
		- Almacena los tratamientos de spa contratados durante una reserva. Es una relación uno a muchos respecto a la tabla reservas.
		- id_ticket_spa: se define como clave primaria autoincremental, al tratarse de una entidad dependiente que requiere un identificador 
        propio para cada tratamiento contratado.
		- id_servicio e id_reserva se establecen como valores no nulos ya que cada tratamiento debe estar asociado obligatoriamente a un servicio 
        del catálogo y a una reserva existente.
		- Tipo de tratamiento hace referencia al tratamiento contratado que no puede ser nulo.
		- Precio incluye una restricción CHECK para garantizar valores no negativos.
		- Claves foráneas:
			- fk_spa_servicio: asegurar su relacion con la tabla servicios.
			- fk_spa_reserva : asegurar la integridad con la tabla reservas.
============================================*/


CREATE TABLE IF NOT EXISTS servicio_spa (
	id_ticket_spa INT AUTO_INCREMENT PRIMARY KEY,
    id_servicio INT NOT NULL DEFAULT 3,
    id_reserva INT NOT NULL,
    tipo_tratamiento VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),

    CONSTRAINT fk_spa_servicio
        FOREIGN KEY (id_servicio)
        REFERENCES servicios(id_servicio),

    CONSTRAINT fk_spa_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva)
);

/*============================================
		CREACIÓN DE ÍNDICES
============================================*/

/*============================================
	Estado Reservas
		-- Se crea el índice para el estado de la reserva ya que es una búsqueda que es una búsqueda que se realiza en reiteradas ocasiones.
		-- Su creación permitirá optimizar el rendimiento de las consultas que utilizan la cláusula WHERE en dicho campo, 
        evitando que se escanee por completo la tabla.
============================================*/

CREATE INDEX idx_reservas_estado
ON reservas(estado_reserva);

-- Comprobamos que se ha creado correctaente:
SHOW INDEX FROM reservas;