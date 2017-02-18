/* Script for data interpolation in table RVMexico.prices_interpolated */

USE RVMexico;

/* Creates missing date ranges to interpolate (business days) */
CALL RVMexico.a_fillin_dates();

/* Total of dates to interpolate: 292,498 */
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is null;

/* Interpolation process per fund's ticker symbol initial. */
CALL RVMexico.b_interpolate_prices('C'); -- Execution time:   785 segs
CALL RVMexico.b_interpolate_prices('O'); -- Execution time:   887 segs
CALL RVMexico.b_interpolate_prices('E'); -- Execution time:  1,139 segs
CALL RVMexico.b_interpolate_prices('D'); -- Execution time:  2,959 segs
CALL RVMexico.b_interpolate_prices('N'); -- Execution time:  5,194 segs
CALL RVMexico.b_interpolate_prices('M'); -- Execution time:  5,718 segs
CALL RVMexico.b_interpolate_prices('P'); -- Execution time:  6,304 segs
CALL RVMexico.b_interpolate_prices('G'); -- Execution time:  8,714 segs
CALL RVMexico.b_interpolate_prices('F'); -- Execution time:  9,245 segs
CALL RVMexico.b_interpolate_prices('A'); -- Execution time:  9,716 segs
CALL RVMexico.b_interpolate_prices('H'); -- Execution time: 11,219 segs
CALL RVMexico.b_interpolate_prices('B'); -- Execution time: 11,355 segs
CALL RVMexico.b_interpolate_prices('S'); -- Execution time: 14,356 segs
CALL RVMexico.b_interpolate_prices('V'); -- Execution time: 15,822 segs
CALL RVMexico.b_interpolate_prices('I'); -- Execution time: 16,593 segs

/* Total number of interpolated dates: 452,070 */
SELECT count(*) FROM RVMexico.prices_interpolated WHERE c_price is not null;
