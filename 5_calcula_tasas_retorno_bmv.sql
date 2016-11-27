/* Script para el cálculo de las tasas de retorno anual (1 año), en base a datos normalizados de los índices
 (BMV), en RVMexico.market_return_rates 
 * La fecha para el inicio de la normalización de índices es: '2010-12-31' */

USE RVMexico;

/* Calcular la tasa anualizada de rendimiento en base a los precios normalizados de los índices (a partir de
 la fecha proporcionada par la normalización) */
CALL RVMexico.d_market_yearly_return_rates(); -- 2.4 segs.

SELECT * FROM RVMexico.market_return_rates LIMIT 4400;

/* Total de tasas de retorno de índices calculadas: 4,176 */
SELECT count(*) FROM RVMexico.market_return_rates;
