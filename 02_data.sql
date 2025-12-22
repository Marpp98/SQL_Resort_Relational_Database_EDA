/* Insertamos datos dentro de las tablas*/

INSERT INTO servicios (id_servicio, tipo_servicio) VALUES
(1, 'Parking'),
(2, 'Restaurante'),
(3, 'Spa'),
(4, 'Excusriones');

LOAD DATA LOCAL INFILE '"C:\Users\maria\Desktop\Master_data_science\SQL_Resort_Relational_Database_EDA\data\clientes.csv"'
INTO TABLE clientes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_cliente, nombre, apellidos, email, telefono, pais);