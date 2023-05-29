use ukfinal;

Drop Procedure IF EXISTS Delete_Accident_by_ID_SP;

DELIMITER @@
CREATE PROCEDURE Delete_Accident_by_ID_SP(
   in_accident_id char(30)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Performing the delete of details based on accident_id';
    END;

    START TRANSACTION;
    -- Delete rows from Accident table
    DELETE FROM Accident WHERE accident_id = in_accident_id;

    -- Delete rows from Vehicle table
    DELETE FROM Vehicle WHERE accident_id = in_accident_id;

    -- Delete rows from Casualty table
    DELETE FROM Casualty WHERE accident_id = in_accident_id;

    -- Delete rows from Junction_Accident table
    DELETE FROM Junction_Accident WHERE accident_id = in_accident_id;

    -- Delete rows from Junction_Vehicle table
    DELETE FROM Junction_Vehicle WHERE accident_id = in_accident_id;
    
    COMMIT;
END;
@@
DELIMITER ;

CALL Delete_Accident_by_ID_SP('Abhi');