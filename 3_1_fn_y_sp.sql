DELIMITER $$
USE `RVMexico`$$

DROP PROCEDURE IF EXISTS `a_fillin_dates`$$
CREATE PROCEDURE `a_fillin_dates`()
BEGIN
    DECLARE vfound VARCHAR(20) default '';
    DECLARE cfounds_done TINYINT DEFAULT 0;

    DECLARE clist_founds CURSOR FOR
        SELECT distinct a_found
        FROM RVMexico.prices;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cfounds_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing interpolated data for the selected founds
    TRUNCATE TABLE RVMexico.prices_interpolated;

    # Add existing data
    INSERT INTO RVMexico.prices_interpolated (a_found, b_date, c_price)
        SELECT prices.a_found, prices.b_date, prices.c_price
        FROM RVMexico.prices
            ON DUPLICATE KEY UPDATE prices_interpolated.c_price = prices.c_price;
    COMMIT;

    # Begin search for founds
    OPEN clist_founds;
    lfounds: LOOP
        FETCH clist_founds INTO vfound;
        IF cfounds_done THEN
            LEAVE lfounds;
        END IF;

        CALL a_fillin_dates_per_found(vfound);
    END LOOP lfounds;
    CLOSE clist_founds;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_per_found`$$
CREATE PROCEDURE `a_fillin_dates_per_found`(in_found VARCHAR(20))
BEGIN
    DECLARE vdate_start VARCHAR(12) default '';
    DECLARE vdate_end VARCHAR(12) default '';
    DECLARE vdate_new VARCHAR(12) default '';
    DECLARE cdates_done TINYINT DEFAULT 0;

    DECLARE clist_dates CURSOR FOR
        SELECT b_date
        FROM RVMexico.prices
        WHERE a_found = in_found
        ORDER BY b_date;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cdates_done = 1;

    # Disable autocommit to speed up insert transactions
    SET autocommit = 0;

    # Begin search for ranges of dates to the interpolated
    OPEN clist_dates;
    l_dates: LOOP
        FETCH clist_dates INTO vdate_end;
        IF cdates_done THEN
            LEAVE l_dates;
        END IF;

        SET vdate_new = vdate_start;
        # If the current day difference between dates is, at least, of 2 days, then, at least a new date can be added
        WHILE datediff(vdate_end, vdate_new) >= 2 DO
            SET vdate_new = date_format(date_add(vdate_new, INTERVAL 1 DAY), '%Y-%m-%d');
            # Exclude 1: Sundays and 7: Saturdays
            IF dayofweek(vdate_new) IN (2, 3, 4, 5, 6) THEN
                INSERT IGNORE INTO RVMexico.prices_interpolated (a_found, b_date)
                VALUES (
                    in_found,
                    vdate_new
                    );
            END IF;
        END WHILE;

        SET vdate_start = vdate_end;
    END LOOP l_dates;
    CLOSE clist_dates;

    COMMIT;
END$$

DROP FUNCTION IF EXISTS `fn_interpolation`$$
CREATE FUNCTION `fn_interpolation`(in_x1 INT, in_y1 DOUBLE, in_x3 INT, in_y3 DOUBLE, in_x2 INT)
RETURNS DOUBLE
BEGIN
    # References:
    # https://en.wikipedia.org/wiki/Linear_interpolation
    # http://ncalculators.com/geometry/linear-interpolation-calculator.htm
    DECLARE d_y2 DOUBLE DEFAULT NULL;
    # Formula: y2 = ((x2 - x1)(y3 - y1) / (x3 - x1)) + y1
    IF (in_x3 - in_x1) <> 0 THEN
        SET d_y2 = ((in_x2 - in_x1) * (in_y3 - in_y1) / (in_x3 - in_x1)) + in_y1;
    END IF;

RETURN d_y2;
END$$

DROP PROCEDURE IF EXISTS `b_interpolate_prices`$$
CREATE PROCEDURE `b_interpolate_prices`(in_found_initial CHAR(2))
BEGIN
    DECLARE vfound VARCHAR(20) DEFAULT '';
    DECLARE cfounds_done TINYINT DEFAULT 0;

    DECLARE clist_founds CURSOR FOR
        SELECT distinct a_found
        FROM RVMexico.prices_interpolated
        WHERE a_found LIKE concat(trim(in_found_initial), '%')
            AND c_price IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cfounds_done = 1;

    # Begin search for founds
    OPEN clist_founds;
    l_founds: LOOP
        FETCH clist_founds INTO vfound;
        IF cfounds_done THEN
            LEAVE l_founds;
        END IF;

        CALL b_interpolate_prices_per_found(vfound);
    END LOOP l_founds;
    CLOSE clist_founds;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `b_interpolate_prices_per_found`$$
CREATE PROCEDURE `b_interpolate_prices_per_found`(in_found VARCHAR(20))
BEGIN
    DECLARE vdate_start VARCHAR(12) DEFAULT '';
    DECLARE vdate_end VARCHAR(12) DEFAULT '';
    DECLARE dprice_start DOUBLE DEFAULT NULL;
    DECLARE dprice_end DOUBLE DEFAULT NULL;
    DECLARE ipoints INT DEFAULT 0;
    DECLARE inumber_rows INT DEFAULT 0;
    DECLARE cpoints_done TINYINT DEFAULT 0;

    DECLARE clist_price_points CURSOR FOR
        SELECT b_date, c_price
        FROM RVMexico.prices
        WHERE a_found = in_found
        ORDER BY b_date;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cpoints_done = 1;

    # Disable autocommit to speed up update transactions
    SET autocommit = 0;
    # Search for price points to interpolate
    OPEN clist_price_points;
    l_points: LOOP
        FETCH clist_price_points INTO vdate_end, dprice_end;
        IF cpoints_done THEN
            LEAVE l_points;
        END IF;

        SELECT count(distinct b_date)
        INTO ipoints
        FROM RVMexico.prices_interpolated
        WHERE a_found = in_found
            AND b_date BETWEEN vdate_start AND vdate_end;

        # If there are, at least, 2 points between dates, use data interpolation
        IF ipoints >= 4 THEN
            SET @number_rows = 0;
            UPDATE RVMexico.prices_interpolated LEFT JOIN
                    (SELECT @number_rows := @number_rows + 1 AS n_row, prices_interpolated.*
                     FROM RVMexico.prices_interpolated
                     WHERE a_found = in_found
                        AND b_date BETWEEN vdate_start AND vdate_end
                    ) AS p_i
                    ON prices_interpolated.a_found = p_i.a_found AND prices_interpolated.b_date = p_i.b_date
            SET prices_interpolated.c_price = ifnull(prices_interpolated.c_price, round(RVMexico.fn_interpolation(1, dprice_start, ipoints, dprice_end, p_i.n_row), 10))
            WHERE prices_interpolated.b_date NOT IN (vdate_start, vdate_end);

        # If there are 3 points between dates, there is only one date missing (probably a hollyday). The previous price is copied.
        ELSEIF ipoints = 3 THEN
            UPDATE RVMexico.prices_interpolated
            SET c_price = dprice_start
            WHERE a_found = in_found
                AND b_date > vdate_start
                AND b_date < vdate_end
                AND c_price IS NULL
            LIMIT 1;
        END IF;

        SET vdate_start = vdate_end;
        SET dprice_start = dprice_end;
        SET ipoints = 0;
    END LOOP l_points;
    CLOSE clist_price_points;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `c_normalize_prices`$$
CREATE PROCEDURE `c_normalize_prices`(in_date VARCHAR(12))
BEGIN
    DECLARE vfound VARCHAR(20) default '';
    DECLARE dnormal_price DOUBLE DEFAULT 0.0;
    DECLARE cfounds_done TINYINT DEFAULT 0;

    DECLARE clist_founds CURSOR FOR
        SELECT distinct a_found
        FROM RVMexico.prices_interpolated
        WHERE b_date = trim(in_date);    # Expected format '%Y-%m-%d'
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cfounds_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing normalized data for the selected founds
    TRUNCATE TABLE RVMexico.prices_normalized;

    # Begin search for founds
    OPEN clist_founds;
    lfounds: LOOP
        FETCH clist_founds INTO vfound;
        IF cfounds_done THEN
            LEAVE lfounds;
        END IF;

        # Get the first historical price
        SELECT et.c_price
          INTO dnormal_price
          FROM RVMexico.prices_interpolated et
         WHERE et.a_found = vfound
           AND et.b_date = (SELECT min(it.b_date) 
                              FROM prices_interpolated it 
                             WHERE it.a_found = et.a_found
                               AND it.b_date >= trim(in_date)
                           );
        
        IF dnormal_price <> 0 THEN
        # Add normalized data
            INSERT INTO RVMexico.prices_normalized (a_found, b_date, c_price)
                SELECT prices_interpolated.a_found, prices_interpolated.b_date, round((prices_interpolated.c_price / dnormal_price), 12)
                FROM RVMexico.prices_interpolated
                WHERE prices_interpolated.a_found = vfound
                AND prices_interpolated.b_date >= trim(in_date)
                ON DUPLICATE KEY UPDATE prices_normalized.c_price = prices_interpolated.c_price;
        END IF;
        
        SET dnormal_price = 0.0;
    END LOOP lfounds;
    CLOSE clist_founds;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `d_prices_yearly_return_rates`$$
CREATE PROCEDURE `d_prices_yearly_return_rates`()
BEGIN
    DECLARE vfound VARCHAR(20) default '';
    DECLARE cfounds_done TINYINT DEFAULT 0;

    DECLARE clist_founds CURSOR FOR
        SELECT distinct a_found
        FROM RVMexico.prices_normalized;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cfounds_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing normalized data for the selected founds
    TRUNCATE TABLE RVMexico.prices_return_rates;

    # Begin search for founds
    OPEN clist_founds;
    lfounds: LOOP
        FETCH clist_founds INTO vfound;
        IF cfounds_done THEN
            LEAVE lfounds;
        END IF;

        INSERT INTO RVMexico.prices_return_rates (a_found, b_date, c_rate)
            SELECT n0.a_found, n0.b_date
                , round((n0.c_price / ifnull(n1.c_price, ifnull(n2.c_price, n3.c_price))) - 1, 12)
            FROM RVMexico.prices_normalized n0
                LEFT JOIN RVMexico.prices_normalized n1 ON n0.a_found = n1.a_found 
                    AND date_sub(n0.b_date, INTERVAL 1 YEAR) = n1.b_date
                LEFT JOIN RVMexico.prices_normalized n2 ON n0.a_found = n2.a_found 
                    AND date_sub(date_sub(n0.b_date, INTERVAL 1 DAY), INTERVAL 1 YEAR) = n2.b_date
                LEFT JOIN RVMexico.prices_normalized n3 ON n0.a_found = n3.a_found 
                    AND date_sub(date_sub(n0.b_date, INTERVAL 2 DAY), INTERVAL 1 YEAR) = n3.b_date
            WHERE n0.a_found = vfound
              AND (n1.c_price IS NOT NULL OR n2.c_price IS NOT NULL OR n3.c_price IS NOT NULL)
            ON DUPLICATE KEY UPDATE prices_return_rates.c_rate = round((n0.c_price / ifnull(n1.c_price, ifnull(n2.c_price, n3.c_price))) - 1, 12);

    END LOOP lfounds;
    CLOSE clist_founds;

    COMMIT;
END$$
DELIMITER ;
