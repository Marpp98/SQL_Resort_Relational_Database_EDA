# 🏨 SQL_Resort_Relational_Database_EDA

Este proyecto se centra en el diseño y la implementación de una base de datos relacional para la gestión de un resort hotelero, incluyendo la automatización de cálculos de facturación y análisis de datos de servicios.


## 📂 Estructura del Repositorio
/
├── data/                       # Datos originales y transformados
│
├── 01_schema                   # Diseño de la base de datos
│
├── 02_data                     # Inserción de datos
│ 
├── 03_eda                      # Creación de querys, vistas y funciones
│
├── .gitignore                  # Archivo que indica que elementos debe ignorar Git
│
└── README.md                   # Documentación principal del repositorio 


## 📊 Diagrama de la Base de Datos (EER)
![Diagrama del Hotel](./tu_imagen.png) 
*(Asegúrate de que la ruta de la imagen sea correcta)*


## 🚀 Funcionalidades Principales
* **Gestión de Reservas:** Registro completo de entradas, salidas y ocupantes.
* **Cálculo de Pagos:** Función personalizada `calcular_pago_pendiente` que automatiza el balance de cuentas (Total - Depósito).
* **Control de Servicios:** Seguimiento de gastos extras en Parking, Spa y otros servicios.
* **Vistas de Facturación:** Consultas optimizadas para obtener el estado financiero de cada reserva en tiempo real.


## 🛠️ Tecnologías Utilizadas
* **MySQL / MySQL Workbench:** para el diseño del modelo EER y la creación de la base de datos.
* **SQL:** implementación de funciones, triggers y consultas complejas (HAVING, GROUP BY, JOINs).
* **Python (Jupyter Notebooks):** para la limpieza y comprobación inicial de los datos de entrada. También se ha usado para la creación de algunas columnas de la base de datos.
* **Excel:** para la creación de la tabla 'Spa'.

     