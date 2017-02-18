/* Script for the interpolation of data in table RVMexico.market_rrates_interpolated */
USE RVMexico;

/* Insertion of missing dates and date ranges to interpolate (business days) */
CALL RVMexico.a_fillin_dates_market_rrates(); -- Execution time: 3.219 segs.

/* Total number of dates to interpolate: 5,975 */
SELECT count(*) FROM RVMexico.market_rrates_interpolated WHERE c_rate is null;

/* Interpolation process for all index rates */
CALL RVMexico.b_interpolate_index_rrates(); -- Execution time: 0.484 segs

/* Total number of interpolated dates: 6,561 */
SELECT count(*) FROM RVMexico.market_rrates_interpolated WHERE c_rate is not null;
