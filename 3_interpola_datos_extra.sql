/* Script para continuar interpolacion de datos agregados en RVMexico.prices_interpolated */

USE RVMexico;

/* Crea rangos de fechas faltantes para interpolar (dias laborales) */
CALL RVMexico.a_fillin_dates_from_last_date();

/* Total de fechas a interpolar: 299 */
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is null;

/* Proceso de interpolacion por letra de inicio de los fondos */
CALL RVMexico.b_interpolate_prices_from_last_date('C'); --   785
CALL RVMexico.b_interpolate_prices_from_last_date('O'); --   887
CALL RVMexico.b_interpolate_prices_from_last_date('E'); --  1139
CALL RVMexico.b_interpolate_prices_from_last_date('D'); --  2959
CALL RVMexico.b_interpolate_prices_from_last_date('N'); --  5194
CALL RVMexico.b_interpolate_prices_from_last_date('M'); --  5718
CALL RVMexico.b_interpolate_prices_from_last_date('P'); --  6304
CALL RVMexico.b_interpolate_prices_from_last_date('G'); --  8714
CALL RVMexico.b_interpolate_prices_from_last_date('F'); --  9245
CALL RVMexico.b_interpolate_prices_from_last_date('A'); --  9716
CALL RVMexico.b_interpolate_prices_from_last_date('H'); -- 11219
CALL RVMexico.b_interpolate_prices_from_last_date('B'); -- 11355
CALL RVMexico.b_interpolate_prices_from_last_date('S'); -- 14356
CALL RVMexico.b_interpolate_prices_from_last_date('V'); -- 15822
CALL RVMexico.b_interpolate_prices_from_last_date('I'); -- 16593

/* Total de fechas interpoladas: 452,070 + 4,069 + 299 = 456,438*/
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is not null;
