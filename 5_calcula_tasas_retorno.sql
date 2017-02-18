/* Script for calculating annual rates of return (364 days), based on normalized data, in table
 * RVMexico.prices_return_rates
 * The date for the beginning of the normalization of funds is: '2010-12-31' */

USE RVMexico;

/* Normalize prices based on the price of the provided date */
CALL RVMexico.d_prices_yearly_return_rates(); -- Execution time: 7.73 segs.

SELECT * FROM RVMexico.prices_return_rates LIMIT 200000;

/* Total number of return rates calculated: 190,998 */
SELECT count(*) FROM RVMexico.prices_return_rates;
