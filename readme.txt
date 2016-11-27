(*) Proyecto para interpolación de datos de fondos de Renta Variable Mexicana
 <-> A continuación, se esplica el orden y los requerimientos en los que debe ejecutarse los scripts para generar la base de datos con los precios de los fondos extraídos y para ejecutar el proceso de interpolación de datos.
Requerimientos:
    * Se requiere tener instalado el servidor MySQL Community Edition 5.7 ó MariaDB 5.5:
        http://dev.mysql.com/downloads/mysql/
    * Se puede utilizar cualquier cliente, o frontend, pero se recomienda MySQLWorkbench 6.3:
        http://dev.mysql.com/downloads/workbench/
    * En el archivo de configuración de MySQL (my.cnf), se deben agregar las siguientes líneas para permitir la carga de archivos directa al servidor y descartar errores en la creación de tablas dinámicas que utilizan algunos StoreProcedures:
        --- Después de:
        [mysqld]

        --- Agregar:
        # Security warning: allow LOAD DATA INFILE
        loose-local-infile=1

        # To allow for slow queries, queries with big columns or with calculated tables (64M)
        max_allowed_packet = 67108864

        --- NOTA: Mantenga copia del archivo "my.cnf" original.
    * En Workbench, vaya a 'Edit->Preferences...->SQL Editor' y en la opción 'DBMS connection read time out (in seconds)' cambie el valor de 600 a 86400.
        --- El proceso de interpolación es lento; sin este cambio, la interpolación de datos quedará inconclusa a los 10 min.
        --- En caso de utilizar otro cliente gráfico, busque la opción que permita aumentar el tiempo de espera para queries en la sección de preferencias.


Los scripts incluídos deben ejecutarse en su cliente en este órden:
    1_crea_basededatos.sql
    --- Crea el esquema de la base de datos, las tablas para los datos originales e interpolados y las funciones y store procedures utilizados en el proceso de interpolación.
    * Base de datos: RVMexico
        Tablas:
        <-> prices
        <-> prices_interpolated
        Funciones:
        <+> fn_interpolation
        Store Procedures:
        <|> a_fillin_dates
        <|> a_fillin_dates_per_found
        <|> b_interpolate_prices
        <|> b_interpolate_prices_per_found

    2_carga_datos.sql
    --- Carga a la base de datos los precios de los fondos para analizar.
    * Los archivos .csv con los datos se encuentran en la carpeta: "01 - Datos crudos de Yahoo! Finance/"
    * Recuerde cambiar la dirección absoluta de todas las instrucciones 'LOAD DATA INFILE ...'

    3_interpola_datos.sql
    --- Ejecuta el proceso de interpolación de datos
        IPORTANTE: Este proceso es sumamente lento y tardará horas (aprox. 30 min X fondo). Recuerde modificar el tiempo de espera de lectura de queries, como se explicó arriba, o la interpolación quedará inconclusa.
    --- Referencias utilizadas para la fúnción de interpolación:
        - https://en.wikipedia.org/wiki/Linear_interpolation
        - http://ncalculators.com/geometry/linear-interpolation-calculator.htm
