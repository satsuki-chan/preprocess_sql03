/* Script para interpolacion de datos en RVMexico.market_interpolated */

USE RVMexico;

/* Crea rangos de fechas faltantes para interpolar (dias laborales) */
CALL RVMexico.a_fillin_dates_market(); -- 2.900 segs.

/* Total de fechas a interpolar: 463 */
SELECT count(*) FROM RVMexico.market_interpolated WHERE c_price is null;

/* Proceso de interpolacion para todos los índices */
CALL RVMexico.b_interpolate_index_prices(); -- 1.200 segs

/* Total de fechas interpoladas: 11,190 */
SELECT count(*) FROM RVMexico.market_interpolated WHERE c_price is not null;
