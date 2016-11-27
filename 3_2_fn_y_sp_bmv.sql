DELIMITER $$
USE `RVMexico`$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_market`$$
CREATE PROCEDURE `a_fillin_dates_market`()
BEGIN
    DECLARE vindex VARCHAR(20) default '';
    DECLARE cindexes_done TINYINT DEFAULT 0;

    DECLARE clist_indexes CURSOR FOR
        SELECT distinct a_index
        FROM RVMexico.market;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cindexes_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing interpolated data for the selected indexes
    TRUNCATE TABLE RVMexico.market_interpolated;

    # Add existing data
    INSERT INTO RVMexico.market_interpolated (a_index, b_date, c_price)
        SELECT market.a_index, market.b_date, market.c_price
        FROM RVMexico.market
            ON DUPLICATE KEY UPDATE market_interpolated.c_price = market.c_price;
    COMMIT;

    # Begin search for indexes
    OPEN clist_indexes;
    l_indexes: LOOP
        FETCH clist_indexes INTO vindex;
        IF cindexes_done THEN
            LEAVE l_indexes;
        END IF;

        CALL a_fillin_dates_per_index(vindex);
    END LOOP l_indexes;
    CLOSE clist_indexes;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_per_index`$$
CREATE PROCEDURE `a_fillin_dates_per_index`(in_index VARCHAR(20))
BEGIN
    DECLARE vdate_start VARCHAR(12) default '';
    DECLARE vdate_end VARCHAR(12) default '';
    DECLARE vdate_new VARCHAR(12) default '';
    DECLARE cdates_done TINYINT DEFAULT 0;

    DECLARE clist_dates CURSOR FOR
        SELECT b_date
        FROM RVMexico.market
        WHERE a_index = in_index
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
                INSERT IGNORE INTO RVMexico.market_interpolated (a_index, b_date)
                VALUES (
                    in_index,
                    vdate_new
                    );
            END IF;
        END WHILE;

        SET vdate_start = vdate_end;
    END LOOP l_dates;
    CLOSE clist_dates;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `b_interpolate_index_prices`$$
CREATE PROCEDURE `b_interpolate_index_prices`()
BEGIN
    DECLARE vindex VARCHAR(20) DEFAULT '';
    DECLARE cindex_done TINYINT DEFAULT 0;

    DECLARE clist_indexes CURSOR FOR
        SELECT distinct a_index
        FROM RVMexico.market_interpolated
        WHERE c_price IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cindex_done = 1;

    # Begin search for indexes
    OPEN clist_indexes;
    l_indexes: LOOP
        FETCH clist_indexes INTO vindex;
        IF cindex_done THEN
            LEAVE l_indexes;
        END IF;

        CALL b_interpolate_prices_per_index(vindex);
    END LOOP l_indexes;
    CLOSE clist_indexes;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `b_interpolate_prices_per_index`$$
CREATE PROCEDURE `b_interpolate_prices_per_index`(in_index VARCHAR(20))
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
        FROM RVMexico.market
        WHERE a_index = in_index
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
        FROM RVMexico.market_interpolated
        WHERE a_index = in_index
            AND b_date BETWEEN if(trim(vdate_start) = '', vdate_end, trim(vdate_start)) AND vdate_end;

        # If there are, at least, 2 points between dates, use data interpolation
        IF ipoints >= 4 THEN
            SET @number_rows = 0;
            UPDATE RVMexico.market_interpolated LEFT JOIN
                    (SELECT @number_rows := @number_rows + 1 AS n_row, market_interpolated.*
                     FROM RVMexico.market_interpolated
                     WHERE a_index = in_index
                       AND b_date BETWEEN vdate_start AND vdate_end
                    ) AS p_i
                    ON market_interpolated.a_index = p_i.a_index AND market_interpolated.b_date = p_i.b_date
            SET market_interpolated.c_price = ifnull(market_interpolated.c_price, round(RVMexico.fn_interpolation(1, dprice_start, ipoints, dprice_end, p_i.n_row), 10))
            WHERE market_interpolated.a_index = in_index
              AND market_interpolated.b_date BETWEEN vdate_start AND vdate_end
			  AND market_interpolated.b_date NOT IN (vdate_start, vdate_end);
            
        # If there are 3 points between dates, there is only one date missing (probably a hollyday). The previous price is copied.
        ELSEIF ipoints = 3 THEN
            UPDATE RVMexico.market_interpolated
            SET c_price = dprice_start
            WHERE a_index = in_index
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

DROP PROCEDURE IF EXISTS `c_normalize_prices_market`$$
CREATE PROCEDURE `c_normalize_prices_market`(in_date VARCHAR(12))
BEGIN
    DECLARE vindex VARCHAR(20) default '';
    DECLARE dnormal_price DOUBLE DEFAULT 0.0;
    DECLARE cindexes_done TINYINT DEFAULT 0;

    DECLARE clist_indexes CURSOR FOR
        SELECT distinct a_index
        FROM RVMexico.market_interpolated
        WHERE b_date = trim(in_date);    # Expected format '%Y-%m-%d'
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cindexes_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing normalized data for the interpolated indexes
    TRUNCATE TABLE RVMexico.market_normalized;

    # Begin search for interpolated indexes
    OPEN clist_indexes;
    l_indexes: LOOP
        FETCH clist_indexes INTO vindex;
        IF cindexes_done THEN
            LEAVE l_indexes;
        END IF;
        
        # Get the first historical price
        SELECT et.c_price
          INTO dnormal_price
          FROM RVMexico.market_interpolated et
         WHERE et.a_index = vindex
           AND et.b_date = (SELECT min(it.b_date) 
                              FROM market_interpolated it 
                             WHERE it.a_index = et.a_index
                               AND it.b_date >= trim(in_date)
                           );

        IF dnormal_price <> 0 THEN
        # Add normalized data
            INSERT INTO RVMexico.market_normalized (a_index, b_date, c_price)
                SELECT market_interpolated.a_index, market_interpolated.b_date, round((market_interpolated.c_price / dnormal_price), 12)
                FROM RVMexico.market_interpolated
                WHERE market_interpolated.a_index = vindex
                AND market_interpolated.b_date >= trim(in_date)
                    ON DUPLICATE KEY UPDATE market_normalized.c_price = market_interpolated.c_price;
        END IF;
        
        SET dnormal_price = 0.0;
    END LOOP l_indexes;
    CLOSE clist_indexes;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `d_market_yearly_return_rates`$$
CREATE PROCEDURE `d_market_yearly_return_rates`()
BEGIN
    DECLARE vindex VARCHAR(20) default '';
    DECLARE cindexes_done TINYINT DEFAULT 0;

    DECLARE clist_indexes CURSOR FOR
        SELECT distinct a_index
        FROM RVMexico.market_normalized;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cindexes_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing normalized data for the selected indexes
    TRUNCATE TABLE RVMexico.market_return_rates;

    # Begin search for indexes
    OPEN clist_indexes;
    lindexes: LOOP
        FETCH clist_indexes INTO vindex;
        IF cindexes_done THEN
            LEAVE lindexes;
        END IF;

        INSERT INTO RVMexico.market_return_rates (a_index, b_date, c_rate)
            SELECT n0.a_index, n0.b_date
                , round((n0.c_price / ifnull(n1.c_price, ifnull(n2.c_price, n3.c_price))) - 1, 12)
            FROM RVMexico.market_normalized n0
                LEFT JOIN RVMexico.market_normalized n1 ON n0.a_index = n1.a_index 
                    AND date_sub(n0.b_date, INTERVAL 1 YEAR) = n1.b_date
                LEFT JOIN RVMexico.market_normalized n2 ON n0.a_index = n2.a_index 
                    AND date_sub(date_sub(n0.b_date, INTERVAL 1 DAY), INTERVAL 1 YEAR) = n2.b_date
                LEFT JOIN RVMexico.market_normalized n3 ON n0.a_index = n3.a_index 
                    AND date_sub(date_sub(n0.b_date, INTERVAL 2 DAY), INTERVAL 1 YEAR) = n3.b_date
            WHERE n0.a_index = vindex
              AND (n1.c_price IS NOT NULL OR n2.c_price IS NOT NULL OR n3.c_price IS NOT NULL)
            ON DUPLICATE KEY UPDATE market_return_rates.c_rate = round((n0.c_price / ifnull(n1.c_price, ifnull(n2.c_price, n3.c_price))) - 1, 12);

    END LOOP lindexes;
    CLOSE clist_indexes;

    COMMIT;
END$$
DELIMITER ;
