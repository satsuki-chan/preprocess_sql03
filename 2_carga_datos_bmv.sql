/* Script for charging the history of prices of the Mexican Stock Exchange (BMV) obtained from the
Yahoo! Finance site. */
USE RVMexico;

TRUNCATE TABLE RVMexico.market;

/* Examples:
[Windows] LOAD DATA INFILE 'C:\home\usario\Projects\yahoo-finance\found_data_201511_1.csv'
[Linux] LOAD DATA INFILE '/home/usuario/Projects/yahoo-finance/found_data_201511_1.csv' */
LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_BMV_data_format.csv'
    REPLACE
    INTO TABLE RVMexico.market
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_index, b_date, c_price);

LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_consulta_banxico_cetes_28d_diario_format.csv'
    REPLACE
    INTO TABLE RVMexico.market
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_index, b_date, c_price);

LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_consulta_banxico_bonos_0-3a_diario_format.csv'
    REPLACE
    INTO TABLE RVMexico.market
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_index, b_date, c_price);

LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_consulta_banxico_bonos_3-5a_diario_format.csv'
    REPLACE
    INTO TABLE RVMexico.market
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_index, b_date, c_price);

UPDATE RVMexico.market
SET b_date = trim(replace(b_date, '"', ''))
WHERE b_date is not null
LIMIT 12000;

SELECT * FROM RVMexico.market LIMIT 12000;

/* Total de filas con precios: 10,727*/
SELECT count(distinct a_index, b_date) FROM RVMexico.market;
