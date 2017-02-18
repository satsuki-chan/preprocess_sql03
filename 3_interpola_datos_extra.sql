/* Script to continue interpolation of aggregate data in table RVMexico.prices_interpolated */

USE RVMexico;

/* Insertion of missing dates and date ranges to interpolate (business days) */
CALL RVMexico.a_fillin_dates_from_last_date();

/* Total of dates to interpolate: 299 */
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is null;

/* Interpolation process per fund's ticker symbol initial. */
CALL RVMexico.b_interpolate_prices_from_last_date('C'); -- Execution time:    785 segs
CALL RVMexico.b_interpolate_prices_from_last_date('O'); -- Execution time:    887 segs
CALL RVMexico.b_interpolate_prices_from_last_date('E'); -- Execution time:  1,139 segs
CALL RVMexico.b_interpolate_prices_from_last_date('D'); -- Execution time:  2,959 segs
CALL RVMexico.b_interpolate_prices_from_last_date('N'); -- Execution time:  5,194 segs
CALL RVMexico.b_interpolate_prices_from_last_date('M'); -- Execution time:  5,718 segs
CALL RVMexico.b_interpolate_prices_from_last_date('P'); -- Execution time:  6,304 segs
CALL RVMexico.b_interpolate_prices_from_last_date('G'); -- Execution time:  8,714 segs
CALL RVMexico.b_interpolate_prices_from_last_date('F'); -- Execution time:  9,245 segs
CALL RVMexico.b_interpolate_prices_from_last_date('A'); -- Execution time:  9,716 segs
CALL RVMexico.b_interpolate_prices_from_last_date('H'); -- Execution time: 11,219 segs
CALL RVMexico.b_interpolate_prices_from_last_date('B'); -- Execution time: 11,355 segs
CALL RVMexico.b_interpolate_prices_from_last_date('S'); -- Execution time: 14,356 segs
CALL RVMexico.b_interpolate_prices_from_last_date('V'); -- Execution time: 15,822 segs
CALL RVMexico.b_interpolate_prices_from_last_date('I'); -- Execution time: 16,593 segs

/* Total number of interpolated dates: 452,070 + 4,069 + 299 = 456,438*/
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is not null;
