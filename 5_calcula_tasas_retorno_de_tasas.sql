/* Script for the calculation of the regularized (divided between 100, due to orginally being percentanges) annual rates of return (1 year), based on the interpolated return rates of the indexes on table RVMexico.market_rrates_interpolated
 * The yearly rates start date is '2012-01-02', given that is the first date from wich the annual return rates can be calculated from '2010-12-31' (the date used to begin the funds' price normalization process)
 * Date for end of analysis: '2015-12-31' */

USE RVMexico;

/* Calculate the annual rates from the same date used in the funds' price normalization process
to the limit date for the funds' price analysis. */
CALL RVMexico.d_rrates_yearly_return_rates('2012-01-02', '2015-12-31'); -- 1.363 segs.

SELECT * FROM RVMexico.market_rrates_return_rates LIMIT 1100;

/* Total calculated rates of return: 1,044 */
SELECT count(*) FROM RVMexico.market_rrates_return_rates;
