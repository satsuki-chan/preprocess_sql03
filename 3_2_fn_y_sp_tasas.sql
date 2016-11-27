DELIMITER $$
USE `RVMexico`$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_market_rrates`$$
CREATE PROCEDURE `a_fillin_dates_market_rrates`()
BEGIN
    DECLARE vindex VARCHAR(20) default '';
    DECLARE cindexes_done TINYINT DEFAULT 0;

    DECLARE clist_indexes CURSOR FOR
        SELECT distinct a_index
        FROM RVMexico.market_rrates;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cindexes_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing interpolated data for the selected indexes
    TRUNCATE TABLE RVMexico.market_rrates_interpolated;

    # Add existing data
    INSERT INTO RVMexico.market_rrates_interpolated (a_index, b_date, c_rate)
        SELECT market_rrates.a_index, market_rrates.b_date, market_rrates.c_rate
        FROM RVMexico.market_rrates
            ON DUPLICATE KEY UPDATE market_rrates_interpolated.c_rate = market_rrates.c_rate;
    COMMIT;

    # Begin search for indexes
    OPEN clist_indexes;
    l_indexes: LOOP
        FETCH clist_indexes INTO vindex;
        IF cindexes_done THEN
            LEAVE l_indexes;
        END IF;

        CALL a_fillin_dates_per_index_rrates(vindex);
    END LOOP l_indexes;
    CLOSE clist_indexes;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `a_fillin_dates_per_index_rrates`$$
CREATE PROCEDURE `a_fillin_dates_per_index_rrates`(in_index VARCHAR(20))
BEGIN
    DECLARE vdate_start VARCHAR(12) default '';
    DECLARE vdate_end VARCHAR(12) default '';
    DECLARE vdate_new VARCHAR(12) default '';
    DECLARE cdates_done TINYINT DEFAULT 0;

    DECLARE clist_dates CURSOR FOR
        SELECT b_date
        FROM RVMexico.market_rrates
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
                INSERT IGNORE INTO RVMexico.market_rrates_interpolated (a_index, b_date)
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

DROP PROCEDURE IF EXISTS `b_interpolate_index_rrates`$$
CREATE PROCEDURE `b_interpolate_index_rrates`()
BEGIN
    DECLARE vindex VARCHAR(20) DEFAULT '';
    DECLARE cindex_done TINYINT DEFAULT 0;

    DECLARE clist_indexes CURSOR FOR
        SELECT distinct a_index
        FROM RVMexico.market_rrates_interpolated
        WHERE c_rate IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cindex_done = 1;

    # Begin search for indexes
    OPEN clist_indexes;
    l_indexes: LOOP
        FETCH clist_indexes INTO vindex;
        IF cindex_done THEN
            LEAVE l_indexes;
        END IF;

        CALL b_interpolate_rrates_per_index(vindex);
    END LOOP l_indexes;
    CLOSE clist_indexes;

    SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `b_interpolate_rrates_per_index`$$
CREATE PROCEDURE `b_interpolate_rrates_per_index`(in_index VARCHAR(20))
BEGIN
    DECLARE vdate_start VARCHAR(12) DEFAULT '';
    DECLARE vdate_end VARCHAR(12) DEFAULT '';
    DECLARE drate_start DOUBLE DEFAULT NULL;
    DECLARE drate_end DOUBLE DEFAULT NULL;
    DECLARE ipoints INT DEFAULT 0;
    DECLARE inumber_rows INT DEFAULT 0;
    DECLARE cpoints_done TINYINT DEFAULT 0;

    DECLARE clist_price_points CURSOR FOR
        SELECT b_date, c_rate
        FROM RVMexico.market_rrates
        WHERE a_index = in_index
        ORDER BY b_date;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cpoints_done = 1;

    # Disable autocommit to speed up update transactions
    SET autocommit = 0;
    # Search for rate points to interpolate
    OPEN clist_price_points;
    l_points: LOOP
        FETCH clist_price_points INTO vdate_end, drate_end;
        IF cpoints_done THEN
            LEAVE l_points;
        END IF;

        SELECT count(distinct b_date)
        INTO ipoints
        FROM RVMexico.market_rrates_interpolated
        WHERE a_index = in_index
            AND b_date BETWEEN if(trim(vdate_start) = '', vdate_end, trim(vdate_start)) AND vdate_end;

        # If there are, at least, 2 points between dates, use data interpolation
        IF ipoints >= 4 THEN
            SET @number_rows = 0;
            UPDATE RVMexico.market_rrates_interpolated LEFT JOIN
                    (SELECT @number_rows := @number_rows + 1 AS n_row, market_rrates_interpolated.*
                     FROM RVMexico.market_rrates_interpolated
                     WHERE a_index = in_index
                       AND b_date BETWEEN vdate_start AND vdate_end
                    ) AS p_i
                    ON market_rrates_interpolated.a_index = p_i.a_index AND market_rrates_interpolated.b_date = p_i.b_date
            SET market_rrates_interpolated.c_rate = ifnull(market_rrates_interpolated.c_rate, round(RVMexico.fn_interpolation(1, drate_start, ipoints, drate_end, p_i.n_row), 10))
            WHERE market_rrates_interpolated.a_index = in_index
              AND market_rrates_interpolated.b_date BETWEEN vdate_start AND vdate_end
			  AND market_rrates_interpolated.b_date NOT IN (vdate_start, vdate_end);
            
        # If there are 3 points between dates, there is only one date missing (probably a hollyday). The previous rate is copied.
        ELSEIF ipoints = 3 THEN
            UPDATE RVMexico.market_rrates_interpolated
            SET c_rate = drate_start
            WHERE a_index = in_index
                AND b_date > vdate_start
                AND b_date < vdate_end
                AND c_rate IS NULL
            LIMIT 1;
        END IF;

        SET vdate_start = vdate_end;
        SET drate_start = drate_end;
        SET ipoints = 0;
    END LOOP l_points;
    CLOSE clist_price_points;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `d_rrates_yearly_return_rates`$$
CREATE PROCEDURE `d_rrates_yearly_return_rates`(in_start_date VARCHAR(12), in_end_date VARCHAR(12))
BEGIN
    DECLARE vrindex VARCHAR(20) default '';
    DECLARE crrates_done TINYINT DEFAULT 0;

    DECLARE clist_rrates CURSOR FOR
        SELECT distinct a_index
          FROM RVMexico.market_rrates_interpolated
         WHERE b_date >= trim(in_start_date)     # Expected format '%Y-%m-%d'
           AND b_date <= trim(in_end_date);      # Expected format '%Y-%m-%d'
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET crrates_done = 1;

    # Disable autocommit to speed up delete and insert transactions
    SET autocommit = 0;
    # Clear all existing yearly return rates for the selected return indexes
    TRUNCATE TABLE RVMexico.market_rrates_return_rates;

    # Begin search for return indexes
    OPEN clist_rrates;
    lindexes: LOOP
        FETCH clist_rrates INTO vrindex;
        IF crrates_done THEN
            LEAVE lindexes;
        END IF;
        
        INSERT INTO RVMexico.market_rrates_return_rates (a_index, b_date, c_rate)
            SELECT i0.a_index, i0.b_date
                , round(ifnull(i1.c_rate, ifnull(i2.c_rate, i3.c_rate)) / 100, 12)
            FROM RVMexico.market_rrates_interpolated i0
                LEFT JOIN RVMexico.market_rrates_interpolated i1 ON i0.a_index = i1.a_index 
                    AND date_sub(i0.b_date, INTERVAL 364 DAY) = i1.b_date
                LEFT JOIN RVMexico.market_rrates_interpolated i2 ON i0.a_index = i2.a_index 
                    AND date_sub(i0.b_date, INTERVAL 365 DAY) = i2.b_date
                LEFT JOIN RVMexico.market_rrates_interpolated i3 ON i0.a_index = i3.a_index 
                    AND date_sub(i0.b_date, INTERVAL 366 DAY) = i3.b_date
            WHERE i0.a_index = vrindex
              AND i0.b_date >= trim(in_start_date)
              AND i0.b_date <= trim(in_end_date)
              AND (i1.c_rate IS NOT NULL OR i2.c_rate IS NOT NULL OR i3.c_rate IS NOT NULL)
        ON DUPLICATE KEY UPDATE market_rrates_return_rates.c_rate = round(ifnull(i1.c_rate, ifnull(i2.c_rate, i3.c_rate)) / 100, 12);

    END LOOP lindexes;
    CLOSE clist_rrates;

    COMMIT;
END$$
DELIMITER ;
