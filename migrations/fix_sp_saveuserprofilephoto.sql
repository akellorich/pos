DROP PROCEDURE IF EXISTS sp_saveuserprofilephoto;
DELIMITER //
CREATE PROCEDURE sp_saveuserprofilephoto(
    IN $clientid INT, 
    IN $userid INT, 
    IN $profilephoto VARCHAR(255)
)
BEGIN
    UPDATE `user` SET profilephoto = $profilephoto WHERE clientid = $clientid AND userid = $userid;
END //
DELIMITER ;
