/* Insertamos datos dentro de las tablas*/

INSERT INTO servicios (id_servicio, tipo_servicio) VALUES
(1, 'Parking'),
(2, 'Restaurante'),
(3, 'Spa'),
(4, 'Excusriones');

-- Los datos de la tabla clientes han sido importados mediante table Data Import Wizard desde clientes.csv

select * from servicios;
SELECT * FROM clientes;
select * from habitaciones;

INSERT INTO canales (id_canal, canal_distribucion) VALUES
(1, 'Web_Propia'),
(2, 'Call_Center/Recepcion'),
(3, 'Agencia_Viajes_Online'),
(4, 'Agencia_Viajes_Offline'),
(5, 'Corporativo/GDS'),
(6, 'Touroperadores'),
(7, 'MICE_Grupos_Eventos');

select * from canales;
