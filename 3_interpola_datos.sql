/* Script para interpolacion de datos en RVMexico.prices_interpolated */

USE RVMexico;
/*
TRUNCATE TABLE RVMexico.prices_interpolated;

LOAD DATA INFILE '/home/satsuki/Projects/cnbvt03/RVMexico.prices_interpolated.csv'
    REPLACE
    INTO TABLE RVMexico.prices_interpolated
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    (a_found, b_date, c_price);
*/

/* Crea rangos de fechas faltantes para interpolar (dias laborales) */
CALL RVMexico.a_fillin_dates();

/* Total de fechas a interpolar: 292,498 */
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is null;

/* Proceso de interpolacion por letra de inicio de los fondos */
CALL RVMexico.b_interpolate_prices('C'); --   785
CALL RVMexico.b_interpolate_prices('O'); --   887
CALL RVMexico.b_interpolate_prices('E'); --  1139
CALL RVMexico.b_interpolate_prices('D'); --  2959
CALL RVMexico.b_interpolate_prices('N'); --  5194
CALL RVMexico.b_interpolate_prices('M'); --  5718
CALL RVMexico.b_interpolate_prices('P'); --  6304
CALL RVMexico.b_interpolate_prices('G'); --  8714
CALL RVMexico.b_interpolate_prices('F'); --  9245
CALL RVMexico.b_interpolate_prices('A'); --  9716
CALL RVMexico.b_interpolate_prices('H'); -- 11219
CALL RVMexico.b_interpolate_prices('B'); -- 11355
CALL RVMexico.b_interpolate_prices('S'); -- 14356
CALL RVMexico.b_interpolate_prices('V'); -- 15822
CALL RVMexico.b_interpolate_prices('I'); -- 16593

/* Total de fechas interpoladas: 452,070 */
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is not null;
