DROP PROCEDURE IF EXISTS `spcheckuser`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spcheckuser`(
    IN `$clientid` INT, 
    IN `$userid` INT, 
    IN `$checkfield` VARCHAR(50), 
    IN `$checkvalue` VARCHAR(50)
)
BEGIN
    IF `$checkfield` = 'username' THEN 
        SELECT * FROM `user` 
        WHERE `clientid` = `$clientid` AND `userid` <> `$userid` AND `username` = `$checkvalue`;
    ELSEIF `$checkfield` = 'email' THEN 
        SELECT * FROM `user` 
        WHERE `clientid` = `$clientid` AND `userid` <> `$userid` AND `email` = `$checkvalue`;
    ELSEIF `$checkfield` = 'mobile' THEN 
        SELECT * FROM `user` 
        WHERE `clientid` = `$clientid` AND `userid` <> `$userid` AND `mobile` = `$checkvalue`;
    END IF;
END$$

DELIMITER ;
