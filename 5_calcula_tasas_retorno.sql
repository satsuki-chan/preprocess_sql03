/* Script para el cálculo de las tasas de retorno anual (1 año), en base a datos normalizados, en RVMexico.prices_return_rates 
 * La fecha para el inicio de la normalización de fondos es: '2010-12-31' */

USE RVMexico;

/* Normalizar precios en base al precio de la fecha proporcionada */
CALL RVMexico.d_prices_yearly_return_rates(); -- 7.73 segs.

SELECT * FROM RVMexico.prices_return_rates LIMIT 200000;

/* Total de tasas de retorno calculadas: 190,998 */
SELECT count(*) FROM RVMexico.prices_return_rates;
