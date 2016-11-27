/* Script para normalización de datos en RVMexico.prices_normalized 
 * La fecha para el inicio de la normalización de fondos es: '2010-12-31' */

USE RVMexico;

/* Normalizar precios en base al precio de la fecha proporcionada */
CALL RVMexico.c_normalize_prices('2010-12-31'); -- 5.355

SELECT * FROM RVMexico.prices_normalized LIMIT 240000;

/* Total de precios normalizados: 238,761 */
SELECT count(*) FROM RVMexico.prices_normalized;
