/* Script para carga de historial de datos de fondos de Renta Variable Mexicana obtenidos del sitio de Yahoo! Finance */
USE RVMexico;

TRUNCATE TABLE RVMexico.prices;

/*Ejemplos:
[Windows] LOAD DATA INFILE 'C:\home\usario\Projects\yahoo-finance\found_data_201511_1.csv'
[Linux] LOAD DATA INFILE '/home/usuario/Projects/yahoo-finance/found_data_201511_1.csv' */
LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/found_data_201511_1.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);


LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/found_data_201511_2.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);


LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/found_data_201511_3.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);

LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_found_data_201511_4.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);

UPDATE RVMexico.prices
SET b_date = trim(replace(b_date, '"', ''))
WHERE b_date is not null
LIMIT 160000;

SELECT * FROM RVMexico.prices LIMIT 160000;

/* Fondos totales: 187 */
SELECT count(distinct a_found) FROM RVMexico.prices;

/* Total de filas: 159,572 */
SELECT count(distinct a_found, b_date) FROM RVMexico.prices;
