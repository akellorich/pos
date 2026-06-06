/*
SQLyog Enterprise v13.1.1 (64 bit)
MySQL - 10.4.27-MariaDB : Database - companies
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


/*Table structure for table `mainoutlets` */

DROP TABLE IF EXISTS `mainoutlets`;

CREATE TABLE `mainoutlets` (
  `outletname` VARCHAR(50) DEFAULT NULL,
  `database` VARCHAR(50) DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `mainoutlets` */

INSERT  INTO `mainoutlets`(`outletname`,`database`) VALUES 
('Headquarters','rgvddxtv_pos');


/* Procedure structure for procedure `spgetcompanies` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcompanies` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`rgvddxtv`@`localhost` PROCEDURE `spgetcompanies`()
BEGIN
	select * from `mainoutlets` order by `outletname`;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
