/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 10.4.24-MariaDB : Database - enet
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`enet` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `enet`;

/*Table structure for table `departments` */

DROP TABLE IF EXISTS `departments`;

CREATE TABLE `departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `departmentname` varchar(50) DEFAULT NULL,
  `dateadded` datetime DEFAULT NULL,
  `addedby` int(11) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `hodid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hodid` (`hodid`),
  KEY `addedby` (`addedby`),
  CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`hodid`) REFERENCES `user` (`id`),
  CONSTRAINT `departments_ibfk_2` FOREIGN KEY (`addedby`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

/*Data for the table `departments` */

insert  into `departments`(`id`,`departmentname`,`dateadded`,`addedby`,`deleted`,`hodid`) values (1,'Finance','2021-08-20 16:13:39',5,0,5),(2,'HR and Administration','2021-08-20 16:13:44',5,0,5),(3,'BTS','2021-08-20 16:15:13',5,1,5),(4,'Fibre','2021-08-20 16:17:02',5,0,5),(5,'Build','2021-08-20 16:17:10',5,0,5),(6,'Managed Services','2021-08-20 16:17:19',5,0,5),(7,'Supply Chain','2021-08-20 17:26:43',5,0,5),(8,'Commercial','2021-08-20 17:26:49',5,0,5);

/* Procedure structure for procedure `sp_checkdepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkdepartment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkdepartment`($id int,$departmentname varchar(50))
BEGIN
	select * from departments  where `departmentname`=$departmentname and `id`<>$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletedepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletedepartment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_deletedepartment`($id int)
BEGIN
	update `departments` set deleted=1 where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdepartmentdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdepartmentdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getdepartmentdetails`($id int)
BEGIN
	select * from `departments` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdepartments` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdepartments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getdepartments`()
BEGIN	
	select d.* ,date_format(d.`dateadded`,'%d-%b-%Y') addedon, concat(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) addedbyname,
	concat(h.`firstname`,' ',h.`middlename`,' ',h.`lastname`) hodname
	from `departments`  d, `user` u, `user` h
	where d. `addedby`=u.id and  h.id=d.hodid and `deleted`=0 
	order by `departmentname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savedepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savedepartment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_savedepartment`($id int,$departmentname varchar(50),$userid int,$hodid int)
BEGIN
	if $id=0 then 
		insert into `departments`(`departmentname`,`dateadded`,`addedby`, `hodid`)
		values($departmentname,now(),$userid,$hodid);
	else
		update `departments` 
		set `departmentname`=$departmentname , `hodid`=$hodid
		where `id`=$id;
	end if;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
