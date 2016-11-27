/* Script para el cálculo de las tasas de retorno anual (1 año) regularizadas (divididas entre 100, por ser porcentajes), 
 en base a la tasas de interés interpoladas de los índices, en RVMexico.market_rrates_interpolated
 * La fecha para el inicio del cálculo de tasas anuales es: '2012-01-02', dado que es la primera fecha a partir
 de la cual se pueden cualcular las tasas de retorno anualizadas a partir de '2010-12-31' (fecha inicio de
 normalización de precios de fondos) */
/* La fecha para el fin de análisis es: '2015-12-31' */

USE RVMexico;

/* Calcular la tasa anualizada de tasas a partir  de la fecha utilizada en la normalización de precios de fondos
y hasta la fecha límite de análisis de precios de fondos. */
CALL RVMexico.d_rrates_yearly_return_rates('2012-01-02', '2015-12-31'); -- 1.363 segs.

SELECT * FROM RVMexico.market_rrates_return_rates LIMIT 1100;

/* Total de tasas de retorno calculadas: 1,044 */
SELECT count(*) FROM RVMexico.market_rrates_return_rates;
