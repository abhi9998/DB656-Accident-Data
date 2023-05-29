USE ukfinal;
DROP PROCEDURE IF EXISTS Insert_Casualty_Data_SP;

DELIMITER @@
CREATE PROCEDURE Insert_Casualty_Data_SP (
    IN in_casualty_id INT,
    IN in_vehicle_id INT,
    IN in_accident_id CHAR(30),
    IN in_casualty_class CHAR(30),
    IN in_casualty_severity CHAR(30),
    IN in_pedestrian_movement CHAR(100),
    IN in_pedestrian_location CHAR(100),
    IN in_casualty_type CHAR(100),
    IN in_sex CHAR(10),
    IN in_age_group CHAR(30),
    IN in_age INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Performing the insert into the Casualty data table. Some ENUM data might be different or primary key might be duplicate';
    END;
    
    INSERT INTO Casualty (
        casualty_id,
        vehicle_id,
        accident_id,
        casualty_class,
        casualty_severity,
        pedestrian_movement,
        pedestrian_location,
        casualty_type,
        profile_id
    ) VALUES (
        in_casualty_id,
        in_vehicle_id,
        in_accident_id,
        in_casualty_class,
        in_casualty_severity,
        in_pedestrian_movement,
        in_pedestrian_location,
        in_casualty_type,
        (SELECT profile_id FROM PersonProfile WHERE age = in_age AND age_group = in_age_group AND sex = in_sex)
    );
END;
@@
DELIMITER ;


CALL Insert_Casualty_Data_SP(
    1,
    2,
    '201401BS70001',
    'Driver or rider',
    'Slight',
    'Not a Pedestrian',
    'Not a Pedestrian',
    'Taxi/Private hire car occupant',
    
    'Male',
    '16 - 20',
    18
);
