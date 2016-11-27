/* Script para carga de historial de tasas de rendimiento (retorno) de instrumentos de deuda mexicana obtenidos del sitio de Banxico:
(CF107) - Valores Gubernamentales 
http://www.banxico.org.mx/SieInternet/consultarDirectorioInternetAction.do?accion=consultarCuadro&idCuadro=CF107&sector=22&locale=es */
USE RVMexico;

TRUNCATE TABLE RVMexico.market_rrates;

/*Ejemplos:
[Windows] LOAD DATA INFILE 'C:\home\usario\Projects\yahoo-finance\raw_consulta_banxico_cetes_364d_tasas_format.csv'
[Linux] LOAD DATA INFILE '/home/usuario/Projects/yahoo-finance/raw_consulta_banxico_cetes_364d_tasas_format.csv' */
-- LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/rraw_consulta_banxico_cetes_364d_tasas_format.csv'
LOAD DATA INFILE '/home/satsuki/Projects/yahoo-finance-t01/raw_consulta_banxico_cetes_364d_tasas_format.csv'
    REPLACE
    INTO TABLE RVMexico.market_rrates
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_index, b_date, c_rate);

UPDATE RVMexico.market_rrates
SET b_date = trim(replace(b_date, '"', ''))
WHERE b_date is not null
LIMIT 1000;

SELECT * FROM RVMexico.market_rrates LIMIT 1000;

/* Total de filas con tasas: 586 */
SELECT count(distinct a_index, b_date) FROM RVMexico.market_rrates;

