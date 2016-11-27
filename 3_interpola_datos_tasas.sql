/* Script para interpolacion de datos en RVMexico.market_rrates_interpolated */
USE RVMexico;

/* Crea rangos de fechas faltantes para interpolar (dias laborales) */
CALL RVMexico.a_fillin_dates_market_rrates(); -- 3.219 segs.

/* Total de fechas a interpolar: 5,975 */
SELECT count(*) FROM RVMexico.market_rrates_interpolated WHERE c_rate is null;

/* Proceso de interpolacion para todas las tasas de los índices */
CALL RVMexico.b_interpolate_index_rrates(); -- 0.484 segs

/* Total de fechas interpoladas: 6,561 */
SELECT count(*) FROM RVMexico.market_rrates_interpolated WHERE c_rate is not null;
