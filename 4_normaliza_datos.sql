/* Script for normalization of data in table RVMexico.prices_normalized
 * The date for the beginning of the normalization of funds is: '2010-12-31' */

USE RVMexico;

/* Normalize prices based on the price of the provided date */
CALL RVMexico.c_normalize_prices('2010-12-31'); -- Execution time: 5.355

SELECT * FROM RVMexico.prices_normalized LIMIT 240000;

/* Total number of normalized prices: 238,761 */
SELECT count(*) FROM RVMexico.prices_normalized;
