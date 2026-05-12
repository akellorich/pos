/*
SQLyog Enterprise v13.1.1 (64 bit)
MySQL - 10.4.27-MariaDB : Database - distributor
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


/*Table structure for table `tempstockreconcilebalancedetails` */

DROP TABLE IF EXISTS `tempstockreconcilebalancedetails`;

CREATE TABLE `tempstockreconcilebalancedetails` (
  `refno` VARCHAR(50) DEFAULT NULL,
  `itemid` INT(11) DEFAULT NULL,
  `quantity` DECIMAL(18,2) DEFAULT NULL,
  `unitprice` DECIMAL(18,2) DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `tempstockreconcilebalancedetails` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
