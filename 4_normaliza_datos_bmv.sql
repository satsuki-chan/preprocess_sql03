/* Script for normalization of data in table RVMexico.market_normalized.
 * The date for the beginning of the normalization of funds is: '2010-12-31' */

USE RVMexico;

/* Normalize prices based on the price of the provided date */
CALL RVMexico.c_normalize_prices_market('2010-12-31'); -- Execution time: 1.850 segs.

/* Total number of normalized prices: 5,220 */
SELECT count(*) FROM RVMexico.market_normalized;
