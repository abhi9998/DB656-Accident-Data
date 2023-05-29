use ukfinal;

--  PoliceAuthority table ------

INSERT INTO ukfinal.PoliceAuthority 
        (police_force, local_authority_district, local_authority_highway) 
		SELECT DISTINCT police_force, local_authority_district, local_authority_highway 
        FROM rawdataukaccidents.rawaccident;

-- PersonProfile table -----
-- run Profile_Data_Populate.sql ---



-- Road table ---------------
CREATE OR REPLACE VIEW raw_road_view as
        SELECT DISTINCT road_class, road_number, road_type, speed_limit, urban_or_rural 
        FROM rawdataukaccidents.rawaccident;

INSERT INTO Road(road_class, road_number, road_type, speed_limit, urban_or_rural) 
        SELECT road_class, road_number, road_type, speed_limit, urban_or_rural from raw_road_view;

DROP VIEW raw_road_view;


-- Road_Authority table ---------
CREATE OR REPLACE VIEW raw_road_policeauthority_view as
        SELECT road_class,road_number,road_type,speed_limit,urban_or_rural, police_force, local_authority_district,local_authority_highway
        FROM rawdataukaccidents.rawaccident;

CREATE OR REPLACE VIEW road_id_authority_id_view as
        SELECT DISTINCT road_id, authority_id 
        FROM raw_road_policeauthority_view as t1 
            LEFT JOIN Road as t2 
            on (t1.road_class=t2.road_class and t1.road_number=t2.road_number and t1.road_type=t2.road_type and t1.speed_limit=t2.speed_limit and t1.urban_or_rural=t2.urban_or_rural)
            LEFT JOIN PoliceAuthority as t3 
            on (t1.police_force=t3.police_force and t1.local_authority_district=t3.local_authority_district and t1.local_authority_highway=t3.local_authority_highway);


INSERT INTO ukfinal.Road_Authority(road_id, authority_id)
        SELECT road_id, authority_id FROM road_id_authority_id_view;

DROP VIEW raw_road_policeauthority_view;
DROP VIEW road_id_authority_id_view;


--  Accident table   ------------------

CREATE OR REPLACE VIEW accident_road_id_authority_id_view as
        SELECT accident_id,latitude,longitude,number_of_vehicles,number_of_casualties,
        datee,day_of_week,timee,weather_condition,light_condition,
        pedestrian_crossing_facility,accident_severity,road_condition, special_condition,
        road_id, authority_id 
        
        FROM rawdataukaccidents.rawaccident as t1 
            LEFT JOIN Road as t2 
            on (t1.road_class=t2.road_class and t1.road_number=t2.road_number and t1.road_type=t2.road_type and t1.speed_limit=t2.speed_limit and t1.urban_or_rural=t2.urban_or_rural) 
            LEFT JOIN
            PoliceAuthority as t3 
            on (t1.police_force=t3.police_force and t1.local_authority_district=t3.local_authority_district and t1.local_authority_highway=t3.local_authority_highway);

INSERT INTO Accident SELECT * FROM accident_road_id_authority_id_view;

DROP VIEW accident_road_id_authority_id_view;


-- Junction_Accident table -------------------

CREATE OR REPLACE VIEW junction_accident_view as
        SELECT accident_id, junction_detail, junction_control 
        FROM rawdataukaccidents.rawaccident where junction_detail<>'Not at junction or within 20 metres';

INSERT INTO junction_accident SELECT * FROM junction_accident_view;

DROP VIEW junction_accident_view;

-- Vehicle table -------------------

INSERT INTO Vehicle 
            SELECT accident_id, vehicle_id, vehicle_location_restricted_lane,
                   point_of_impact, journey_purpose, engine_capacity, age_of_vehicle,
                   hit_object_in_carriageway, vehicle_manoeuvre, skidding_and_overturning,
                   vehicle_leaving_carriageway,profile_id 
            FROM rawdataukaccidents.rawvehicle as t1 
            LEFT JOIN PersonProfile as t2 
            on  (t1.age=t2.age and t1.age_group= t2.age_group and t1.sex =t2.sex);

--- Junction_Vehicle table ---------------

CREATE OR REPLACE VIEW junction_accident_view as
        SELECT accident_id,vehicle_id,junction_location from rawdataukaccidents.rawvehicle 
        WHERE junction_location<>'Not at or within 20 metres of junction' 
        and junction_location<>'Data missing or out of range';

INSERT INTO junction_vehicle
SELECT * FROM junction_accident_view;

DROP VIEW junction_accident_view;

-- Casualty table ----------
INSERT INTO Casualty
	    SELECT casualty_id, vehicle_id, accident_id, 
		       casualty_class, casualty_severity, pedestrian_movement, 
               pedestrian_location, casualty_type, profile_id 
        FROM rawdataukaccidents.rawcasualty as t1 
            LEFT JOIN PersonProfile as t2 
            on  (t1.age=t2.age and t1.age_group= t2.age_group and t1.sex =t2.sex);
