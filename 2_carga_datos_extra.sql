/* Script to load historical price data of Mexican equity funds obtained from the Yahoo! Finance site
 * Load of aditional price data. */
USE RVMexico;

/* Examples:
[Windows] LOAD DATA INFILE 'C:\home\usario\Projects\yahoo-finance\found_data_201511_1.csv'
[Linux] LOAD DATA INFILE '/home/usuario/Projects/yahoo-finance/found_data_201511_1.csv' */
LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/found_data_extra_201512_1.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);


LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_found_data_extra_201512_2.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);

LOAD DATA INFILE '/<absolute>/<path>/<to>/<file>/raw_found_data_extra_STER-OP B1_format.csv'
    REPLACE
    INTO TABLE RVMexico.prices
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (a_found, b_date, c_price);

UPDATE RVMexico.prices
SET b_date = trim(replace(b_date, '"', ''))
WHERE b_date is not null
LIMIT 170000;

SELECT * FROM RVMexico.prices LIMIT 170000;

/* Total number of funds: 187 */
/* Funds to ignore
-- Missing data:
ST&ER-D B1 - 1983-06-06
ST&ER-I B1 - 1990-02-16
ST&ER-I F - 2009-08-13
ST&ERBM F - 2007-07-31
-- Stopped operation:
BMERPAT F - 2004-11-24
*/
SELECT count(distinct a_found) FROM RVMexico.prices;

/* Total of data rows: 159,571 + 4070 = 163,641 */
SELECT count(distinct a_found, b_date) FROM RVMexico.prices;
