/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 10.4.24-MariaDB : Database - companies
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`companies` /*!40100 DEFAULT CHARACTER SET latin1 */;

/*Table structure for table `mainoutlets` */

DROP TABLE IF EXISTS `mainoutlets`;

CREATE TABLE `mainoutlets` (
  `outletname` varchar(50) DEFAULT NULL,
  `database` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mainoutlets` */

insert  into `mainoutlets`(`outletname`,`database`) values ('Loyalty','distributor'),('Campari','distributor'),('Usenge','distributor');

/* Procedure structure for procedure `spgetcompanies` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcompanies` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetcompanies`()
BEGIN
	select * from `mainoutlets` order by `outletname`;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
