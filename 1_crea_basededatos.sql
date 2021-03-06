CREATE DATABASE  IF NOT EXISTS `RVMexico` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `RVMexico`;
-- MySQL dump 10.15  Distrib 10.0.22-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: RVMexico
-- ------------------------------------------------------
-- Server version	10.0.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `market`
--

DROP TABLE IF EXISTS `market`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market` (
  `a_index` varchar(20) NOT NULL COMMENT 'Stock prices index to use as baseline for analysis',
  `b_date` varchar(12) NOT NULL,
  `c_price` double NOT NULL,
  PRIMARY KEY (`a_index`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_interpolated`
--

DROP TABLE IF EXISTS `market_interpolated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_interpolated` (
  `a_index` varchar(20) NOT NULL COMMENT 'Interpolated prices of the indexes used as baseline for analysis',
  `b_date` varchar(12) NOT NULL,
  `c_price` double DEFAULT NULL,
  PRIMARY KEY (`a_index`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_normalized`
--

DROP TABLE IF EXISTS `market_normalized`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_normalized` (
  `a_index` varchar(20) NOT NULL COMMENT 'Normilized interpolated index prices to use as baseline for analysis',
  `b_date` varchar(12) NOT NULL,
  `c_price` double NOT NULL,
  PRIMARY KEY (`a_index`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_return_rates`
--

DROP TABLE IF EXISTS `market_return_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_return_rates` (
  `a_index` varchar(20) NOT NULL COMMENT 'Market yearly indexes from normalized index prices',
  `b_date` varchar(12) NOT NULL,
  `c_rate` double NOT NULL,
  PRIMARY KEY (`a_index`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_rrates`
--

DROP TABLE IF EXISTS `market_rrates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_rrates` (
  `a_index` varchar(20) NOT NULL,
  `b_date` varchar(12) NOT NULL,
  `c_rate` double NOT NULL,
  PRIMARY KEY (`a_index`,`b_date`) COMMENT 'Indexes return rates'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_rrates_interpolated`
--

DROP TABLE IF EXISTS `market_rrates_interpolated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_rrates_interpolated` (
  `a_index` varchar(20) NOT NULL,
  `b_date` varchar(12) NOT NULL,
  `c_rate` double DEFAULT NULL,
  PRIMARY KEY (`a_index`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_rrates_return_rates`
--

DROP TABLE IF EXISTS `market_rrates_return_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_rrates_return_rates` (
  `a_index` varchar(20) NOT NULL COMMENT 'Indexes yearly return rates',
  `b_date` varchar(12) NOT NULL,
  `c_rate` double NOT NULL,
  PRIMARY KEY (`a_index`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prices`
--

DROP TABLE IF EXISTS `prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prices` (
  `a_found` varchar(20) NOT NULL COMMENT 'Original founds prices',
  `b_date` varchar(12) NOT NULL,
  `c_price` double NOT NULL,
  PRIMARY KEY (`a_found`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prices_interpolated`
--

DROP TABLE IF EXISTS `prices_interpolated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prices_interpolated` (
  `a_found` varchar(20) NOT NULL COMMENT 'Interpolated found prices',
  `b_date` varchar(12) NOT NULL,
  `c_price` double DEFAULT NULL,
  PRIMARY KEY (`a_found`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prices_normalized`
--

DROP TABLE IF EXISTS `prices_normalized`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prices_normalized` (
  `a_found` varchar(20) NOT NULL COMMENT 'Normalized interpolated found prices',
  `b_date` varchar(12) NOT NULL,
  `c_price` double NOT NULL,
  PRIMARY KEY (`a_found`,`b_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prices_return_rates`
--

DROP TABLE IF EXISTS `prices_return_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prices_return_rates` (
  `a_found` varchar(20) NOT NULL,
  `b_date` varchar(12) NOT NULL,
  `c_rate` double NOT NULL,
  PRIMARY KEY (`a_found`,`b_date`) COMMENT 'Yearly return rates from normalized interpolated prices'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'RVMexico'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_interpolation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_interpolation`(in_x1 INT, in_y1 DOUBLE, in_x3 INT, in_y3 DOUBLE, in_x2 INT) RETURNS double
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_from_last_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_from_last_date`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_market` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_market`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_market_rrates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_market_rrates`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_per_found` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_per_found`(in_found VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_per_found_from_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_per_found_from_date`(in_found VARCHAR(20), in_date VARCHAR(12))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_per_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_per_index`(in_index VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `a_fillin_dates_per_index_rrates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `a_fillin_dates_per_index_rrates`(in_index VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_index_prices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_index_prices`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_index_rrates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_index_rrates`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_prices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_prices`(in_found_initial CHAR(2))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_prices_from_last_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_prices_from_last_date`(in_found_initial CHAR(2))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_prices_per_found` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_prices_per_found`(in_found VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_prices_per_found_from_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_prices_per_found_from_date`(in_found VARCHAR(20), in_date VARCHAR(12))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_prices_per_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_prices_per_index`(in_index VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `b_interpolate_rrates_per_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `b_interpolate_rrates_per_index`(in_index VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `c_normalize_prices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `c_normalize_prices`(in_date VARCHAR(12))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `c_normalize_prices_market` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `c_normalize_prices_market`(in_date VARCHAR(12))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `d_market_yearly_return_rates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `d_market_yearly_return_rates`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `d_prices_yearly_return_rates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `d_prices_yearly_return_rates`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `d_rrates_yearly_return_rates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `d_rrates_yearly_return_rates`(in_start_date VARCHAR(12), in_end_date VARCHAR(12))
BEGIN
    DECLARE vrindex VARCHAR(20) default '';
    DECLARE crrates_done TINYINT DEFAULT 0;

    DECLARE clist_rrates CURSOR FOR
        SELECT distinct a_index
          FROM RVMexico.market_rrates_interpolated
         WHERE b_date >= trim(in_start_date)     # Expected format '%Y-%m-%d'
           AND b_date <= trim(in_end_date);
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
                , round((i0.c_rate / ifnull(i1.c_rate, ifnull(i2.c_rate, i3.c_rate))) - 1, 12)
            FROM RVMexico.market_rrates_interpolated i0
                LEFT JOIN RVMexico.market_rrates_interpolated i1 ON i0.a_index = i1.a_index 
                    AND date_sub(i0.b_date, INTERVAL 1 YEAR) = i1.b_date
                LEFT JOIN RVMexico.market_rrates_interpolated i2 ON i0.a_index = i2.a_index 
                    AND date_sub(date_sub(i0.b_date, INTERVAL 1 DAY), INTERVAL 1 YEAR) = i2.b_date
                LEFT JOIN RVMexico.market_rrates_interpolated i3 ON i0.a_index = i3.a_index 
                    AND date_sub(date_sub(i0.b_date, INTERVAL 2 DAY), INTERVAL 1 YEAR) = i3.b_date
            WHERE i0.a_index = vrindex
              AND ifnull(i1.b_date, ifnull(i2.b_date, i3.b_date)) >= trim(in_start_date)
              AND i0.b_date <= trim(in_end_date)
        ON DUPLICATE KEY UPDATE market_rrates_return_rates.c_rate = round((i0.c_rate / ifnull(i1.c_rate, ifnull(i2.c_rate, i3.c_rate))) - 1, 12);

    END LOOP lindexes;
    CLOSE clist_rrates;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-06  3:03:55
