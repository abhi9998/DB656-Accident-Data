use ukfinal;
DROP Procedure IF EXISTS Insert_Accident_Data_SP;

DELIMITER @@
CREATE PROCEDURE Insert_Accident_Data_SP (
    IN in_accident_id char(30),
    IN in_latitude decimal(8,6),
    IN in_longitude decimal(8,6),
    IN in_number_of_vehicles INT,
    IN in_number_of_casualties INT,
    IN in_datee DATE,
    IN in_day_of_week INT,
    IN in_timee time,
    IN in_weather_condition char(50),
    IN in_light_condition char(50),
    IN in_pedestrian_crossing_facility char(100),
    IN in_accident_severity char(50),
    IN in_road_condition char(50),
    IN in_special_condition char(50),
    
    IN in_police_force char(100),
    IN in_local_authority_district char(100),
    IN in_local_authority_highway char(100),

    IN in_road_class char(50),
    IN in_road_number INT,
    IN in_road_type char(50),
    IN in_speed_limit INT,
    IN in_urban_or_rural char(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Performing the insert into the Accident data table. Some ENUM data might be different or primary key might be duplicate';
    END;

            INSERT INTO Accident(accident_id,
                        latitude,
                        longitude,
                        number_of_vehicles,
                        number_of_casualties,
                        datee,
                        day_of_week,
                        timee,
                        weather_condition,
                        light_condition,
                        pedestrian_crossing_facility,
					    accident_severity,
                        road_condition,
                        special_condition,
                        road_id,
                        authority_id
                    )

                    VALUES(in_accident_id,
                        in_latitude,
                        in_longitude,
                        in_number_of_vehicles,
                        in_number_of_casualties,
                        in_datee,
                        in_day_of_week,
                        in_timee,
                        in_weather_condition,
                        in_light_condition,
                        in_pedestrian_crossing_facility,
					    in_accident_severity,
                        in_road_condition,
                        in_special_condition,
                        (SELECT road_id FROM road WHERE road_number=in_road_number AND road_class=in_road_class AND road_type = in_road_type AND speed_limit=in_speed_limit AND urban_or_rural = in_urban_or_rural ),
                        (SELECT authority_id FROM policeAuthority WHERE police_force = in_police_force AND local_authority_district = in_local_authority_district AND local_authority_highway = in_local_authority_highway)
                        );
END;
@@
DELIMITER ;



call insert_Accident_Data_SP('Abhi',
						51.496345,
                        -0.206443,
                        2,
                        1,
                        '2014-09-01',
                        5,
                        '13:21:00',
                        'Raining without high winds',
                        'Daylight',
                        'No physical crossing facilities within 50 metres',
                        'Slight',
                        'Wet',
                        'None',
						
                        'Metropolitan Police', 
                        'Westminster', 
                        'Westminster',
                        
                        'A',
                        4,
                        'Single carriageway',
                        30,
                        'Urban'
                        );
                        
                        
                       