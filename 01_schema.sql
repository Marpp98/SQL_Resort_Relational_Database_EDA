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
============================================*/
DROP TABLE IF EXISTS servicio_spa;
DROP TABLE IF EXISTS servicio_comida;
DROP TABLE IF EXISTS servicio_parking;
DROP TABLE IF EXISTS reservas;
DROP TABLE IF EXISTS servicios;
DROP TABLE IF EXISTS canales;
DROP TABLE IF EXISTS habitaciones;
DROP TABLE IF EXISTS clientes;

/*============================================
		Creación de tablas
============================================*/

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    pais VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS habitaciones (
    id_habitacion INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    tarifa DECIMAL(10,2) NOT NULL CHECK (tarifa >= 0)
);

CREATE TABLE IF NOT EXISTS canales (
    id_canal INT PRIMARY KEY,
    canal_distribucion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT PRIMARY KEY,
    tipo_servicio VARCHAR(50) NOT NULL UNIQUE
);

/*============================================
		Creación de tabla base
============================================*/

CREATE TABLE IF NOT EXISTS reservas (
    id_reserva INT PRIMARY KEY,
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
CREATE TABLE IF NOT EXISTS servicio_parking (
    servicio_id INT PRIMARY KEY,
    reserva_id INT NOT NULL UNIQUE,
    numero_plazas INT NOT NULL CHECK (numero_plazas > 0),
    precio_unit DECIMAL(10,2) NOT NULL CHECK (precio_unit >= 0),
    precio_total DECIMAL(10,2) NOT NULL CHECK (precio_total >= 0),

    CONSTRAINT fk_parking_servicio
        FOREIGN KEY (servicio_id)
        REFERENCES servicios(id_servicio),

    CONSTRAINT fk_parking_reserva
        FOREIGN KEY (reserva_id)
        REFERENCES reservas(id_reserva)
);

CREATE TABLE IF NOT EXISTS servicio_comida (
    servicio_id INT PRIMARY KEY,
    reserva_id INT NOT NULL UNIQUE,
    tipo_comida VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),

    CONSTRAINT fk_comida_servicio
        FOREIGN KEY (servicio_id)
        REFERENCES servicios(id_servicio),

    CONSTRAINT fk_comida_reserva
        FOREIGN KEY (reserva_id)
        REFERENCES reservas(id_reserva)
);

CREATE TABLE IF NOT EXISTS servicio_spa (
    servicio_id INT PRIMARY KEY,
    reserva_id INT NOT NULL UNIQUE,
    tipo_tratamiento VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),

    CONSTRAINT fk_spa_servicio
        FOREIGN KEY (servicio_id)
        REFERENCES servicios(id_servicio),

    CONSTRAINT fk_spa_reserva
        FOREIGN KEY (reserva_id)
        REFERENCES reservas(id_reserva)
);


