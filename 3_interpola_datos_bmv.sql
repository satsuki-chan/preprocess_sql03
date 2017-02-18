/* Script for the data interpolation in table RVMexico.market_interpolated */

USE RVMexico;

/* Insertion of missing dates and date ranges to interpolate (business days) */
CALL RVMexico.a_fillin_dates_market(); -- Execution time: 2.900 segs.

/* Total number of dates to interpolate: 463 */
SELECT count(*) FROM RVMexico.market_interpolated WHERE c_price is null;

/* Interpolation process for all indexes */
CALL RVMexico.b_interpolate_index_prices(); -- Execution time: 1.200 segs

/* Total number of interpolated dates: 11,190 */
SELECT count(*) FROM RVMexico.market_interpolated WHERE c_price is not null;
