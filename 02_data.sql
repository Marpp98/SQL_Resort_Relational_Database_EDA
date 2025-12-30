/* Insertamos datos dentro de las tablas*/

INSERT INTO servicios (id_servicio, tipo_servicio) VALUES
(1, 'Parking'),
(2, 'Restaurante'),
(3, 'Spa'),
(4, 'Excusriones');

-- Los datos de la tabla clientes han sido importados mediante table Data Import Wizard desde clientes.csv
-- Los datos de la tabla habitaciones han sido importados mediante table Data Import Wizard desde habitaciones.csv


INSERT INTO canales (id_canal, canal_distribucion) VALUES
(1, 'Direct'),
(2, 'TA/TO'),
(3, 'Corporate'),
(4, 'GDS'),
(5, 'Otros');

-- Los datos de la tabla reservas han sido importados mediante table Data Import Wizard desde reservas.csv
-- Los datos de la tabla servicio_parking han sido importados mediante table Data Import Wizard desde parking.csv

select * from habitaciones;
select * from canales;
select * from servicios;
select * from servicio_parking;
select * from clientes;
select * from reservas;

SHOW VARIABLES LIKE 'local_infile';

SET FOREIGN_KEY_CHECKS = 0;  -- desactiva temporalmente FK
TRUNCATE TABLE reservas;      -- vacía toda la tabla
SET FOREIGN_KEY_CHECKS = 1;  -- vuelve a activar FK

