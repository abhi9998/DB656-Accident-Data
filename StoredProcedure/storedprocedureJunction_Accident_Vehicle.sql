use ukfinal;

-- Stored Procedure for Junction Accident Data ------------------------------

Drop Procedure IF EXISTS Insert_Junction_Accident_Data_SP;

DELIMITER @@
CREATE PROCEDURE Insert_Junction_Accident_Data_SP (
    in_accident_id char(30),
    in_junction_detail char(100),
    in_junction_control char(100)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Performing the insert into the Vehicle data table. Some ENUM data might be different or primary key might be duplicate';
    END;

         INSERT INTO Junction_Accident (accident_id, junction_detail, junction_control)
         VALUES (in_accident_id, in_junction_detail, in_junction_control);
END;
@@
DELIMITER ;


CALL Insert_Junction_Accident_Data_SP('Abhi', 'Roundabout', 'Auto traffic signal');


-- Stored Procedure for Junction Vehicle Data ------------------------------


DROP PROCEDURE IF EXISTS Insert_Junction_Vehicle_Data_SP;

DELIMITER @@
CREATE PROCEDURE Insert_Junction_Vehicle_Data_SP (
    IN in_accident_id CHAR(30),
    IN in_vehicle_id INT,
    IN in_junction_location CHAR(100)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Performing the insert into the  Junction Vehicle data table. Some ENUM data might be different or primary key might be duplicate';
    END;

        INSERT INTO Junction_Vehicle(accident_id, vehicle_id, junction_location)
        VALUES(in_accident_id, in_vehicle_id, in_junction_location);
END;
@@
DELIMITER ;


CALL Insert_Junction_Vehicle_Data_SP('Abhi', 1,'Approaching junction or waiting/parked at junction approach');