/* Script for the calculation of annual rates of return (364 days), based on normalized index data (BMV),
 * at RVMexico.market_return_rates
 * The date for the start of index normalization is: '2010-12-31' */

USE RVMexico;

/* Calculate the annualized rate of return based on the normalized prices of the indices (from the
 * date provided for standardization). */
CALL RVMexico.d_market_yearly_return_rates(); -- Execution time: 2.4 segs.

SELECT * FROM RVMexico.market_return_rates LIMIT 4400;

/* Total number of rates of return of calculated indices: 4,176 */
SELECT count(*) FROM RVMexico.market_return_rates;
