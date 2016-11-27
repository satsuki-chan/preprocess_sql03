/* Script para normalización de datos en RVMexico.market_normalized
 * La fecha para el inicio de la normalización de fondos es: '2010-12-31' */

USE RVMexico;

/* Normalizar precios en base al precio de la fecha proporcionada */
CALL RVMexico.c_normalize_prices_market('2010-12-31'); -- 1.850 segs.

/* Total de precios normalizados: 5,220 */
SELECT count(*) FROM RVMexico.market_normalized;
