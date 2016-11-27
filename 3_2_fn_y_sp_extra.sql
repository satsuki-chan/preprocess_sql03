DELIMITER $$
USE `RVMexico`$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_from_last_date`$$
CREATE PROCEDURE `a_fillin_dates_from_last_date`()
BEGIN
    DECLARE vfound VARCHAR(20) default '';
    DECLARE vdate_cont VARCHAR(12) default '';
    DECLARE cfounds_done TINYINT DEFAULT 0;

    DECLARE clist_founds CURSOR FOR
        SELECT distinct a_found
        FROM RVMexico.prices;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cfounds_done = 1;

    # Begin search for founds
    OPEN clist_founds;
    lfounds: LOOP
        FETCH clist_founds INTO vfound;
        IF cfounds_done THEN
            LEAVE lfounds;
        END IF;
        # Get last interpolated date to continue data interpolation
        SELECT max(distinct b_date)
          INTO vdate_cont
          FROM RVMexico.prices_interpolated
         WHERE a_found = vfound;

        # Disable autocommit to speed up insert transactions
        SET autocommit = 0;

        # Add new data for existing found
        INSERT INTO RVMexico.prices_interpolated (a_found, b_date, c_price)
            SELECT prices.a_found, prices.b_date, prices.c_price
            FROM RVMexico.prices
            WHERE prices.a_found = vfound
              AND prices.b_date >= vdate_cont
                ON DUPLICATE KEY UPDATE prices_interpolated.c_price = prices.c_price;
        COMMIT;
    
        # Continue date interpolation
        CALL a_fillin_dates_per_found_from_date(vfound, vdate_cont);
    END LOOP lfounds;
    CLOSE clist_founds;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_per_found_from_date`$$
CREATE PROCEDURE `a_fillin_dates_per_found_from_date`(in_found VARCHAR(20), in_date VARCHAR(12))
BEGIN
    DECLARE vdate_start VARCHAR(12) default '';
    DECLARE vdate_end VARCHAR(12) default '';
    DECLARE vdate_new VARCHAR(12) default '';
    DECLARE cdates_done TINYINT DEFAULT 0;

    DECLARE clist_dates CURSOR FOR
        SELECT b_date
        FROM RVMexico.prices
        WHERE a_found = in_found
          AND b_date >= trim(in_date)   # Expected format '%Y-%m-%d'
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

DROP PROCEDURE IF EXISTS `b_interpolate_prices_from_last_date`$$
CREATE PROCEDURE `b_interpolate_prices_from_last_date`(in_found_initial CHAR(2))
BEGIN
    DECLARE vfound VARCHAR(20) DEFAULT '';
    DECLARE vdate_cont VARCHAR(12) DEFAULT '';
    DECLARE iprices INT DEFAULT 0;
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

        # Get first not interpolated date to continue data interpolation
        SELECT min(distinct b_date)
        INTO vdate_cont
        FROM RVMexico.prices_interpolated
        WHERE a_found = vfound
          AND c_price IS NULL;

		WHILE iprices <= 0 DO
			SET vdate_cont = date_format(date_sub(vdate_cont, INTERVAL 1 DAY), '%Y-%m-%d');
            
            SELECT count(c_price)
              INTO iprices
			  FROM RVMexico.prices
			 WHERE a_found = vfound
			   AND b_date = vdate_cont;
        END WHILE;
        
        CALL b_interpolate_prices_per_found_from_date(vfound, vdate_cont);
        SET iprices = 0;
    END LOOP l_founds;
    CLOSE clist_founds;

    SELECT trim(in_found_initial);
END$$

DROP PROCEDURE IF EXISTS `b_interpolate_prices_per_found_from_date`$$
CREATE PROCEDURE `b_interpolate_prices_per_found_from_date`(in_found VARCHAR(20), in_date VARCHAR(12))
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
          AND b_date >= trim(in_date)   # Expected format '%Y-%m-%d'
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
          AND b_date BETWEEN if(trim(vdate_start) = '', vdate_end, trim(vdate_start)) AND vdate_end;

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

DELIMITER ;
