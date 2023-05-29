USE ukfinal;
DROP PROCEDURE IF EXISTS Insert_Vehicle_Data_SP;

DELIMITER @@
CREATE PROCEDURE Insert_Vehicle_Data_SP (
    IN in_accident_id CHAR(30),
    IN in_vehicle_id INT,
    IN in_vehicle_location_restricted_lane char(100),
    IN in_point_of_impact char(20),
    IN in_journey_purpose char(30),
    IN in_engine_capacity INT,
    IN in_age_of_vehicle INT,
    IN in_hit_object_in_carriageway char(50),
    IN in_vehicle_manoeuvre CHAR(100),
    IN in_skidding_and_overturning char(60),
    IN in_vehicle_leaving_carriageway CHAR(100),
    
    IN in_sex char(10),
    IN in_age_group char(30),
    IN in_age INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Performing the insert into the Vehicle data table. Some ENUM data might be different or primary key might be duplicate';
    END;
    
    INSERT INTO Vehicle (
        accident_id,
        vehicle_id,
        vehicle_location_restricted_lane,
        point_of_impact,
        journey_purpose,
        engine_capacity,
        age_of_vehicle,
        hit_object_in_carriageway,
        vehicle_manoeuvre,
        skidding_and_overturning,
        vehicle_leaving_carriageway,
        profile_id
        
    ) VALUES (
        in_accident_id,
        in_vehicle_id,
        in_vehicle_location_restricted_lane,
        in_point_of_impact,
        in_journey_purpose,
        in_engine_capacity,
        in_age_of_vehicle,
        in_hit_object_in_carriageway,
        in_vehicle_manoeuvre,
        in_skidding_and_overturning,
        in_vehicle_leaving_carriageway,
        (select profile_id from PersonProfile where age=in_age and age_group = in_age_group and sex =  in_sex)
    );
END;
@@
DELIMITER ;


CALL insert_Vehicle_Data_SP(
    'Abhi',
    2,
    "On main c\'way - not in restricted lane",
    'Front',
    'Commuting to/from work',
    1500,
    3,
    'None',
    'Overtaking moving vehicle - offside',
    'No skidding',
    'Leaving carriageway - nearside',
    
    'Male',
    '16 - 20',
    18
);


