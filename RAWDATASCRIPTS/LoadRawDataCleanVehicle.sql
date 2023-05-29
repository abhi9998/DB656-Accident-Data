use RawDataUKAccidents;


drop table if exists RawVehicle;

create table RawVehicle(
    
    accident_id char(20),
    vehicle_id INT,
    age INT,
    engine_capacity INT,
    age_of_vehicle INT,
    vehicle_location_restricted_lane char(100),
    junction_location char(100),
    hit_object_in_carriageway char(100),
    point_of_impact char(100),
    journey_purpose char(100),
    sex char(10),
    age_group char(10),
    vehicle_type char(50),
    vehicle_manoeuvre char(100),
    skidding_and_overturning char(100),
    vehicle_leaving_carriageway char(100),
  

    primary key(accident_id,vehicle_id)
);


load data local infile "D:\\aaaaaaaaa\\LoadAllData-20230402T185233Z-001\\LoadAllData\\clean-2014-data\\vehicle_raw_clean.csv"
    ignore into table RawVehicle
    fields terminated by ','
	enclosed by '"'
    lines terminated by '\n'
    ignore 1 rows
    (
    @index,
    @accident_id,
    @vehicle_id,
    @age,
    @engine_capacity,
    @age_of_vehicle ,
    @vehicle_location_restricted_lane,
    @junction_location ,
    @hit_object_in_carriageway ,
    @point_of_impact ,
    @journey_purpose ,
    @sex ,
    @age_group ,
    @vehicle_type ,
    @vehicle_manoeuvre ,
    @skidding_and_overturning ,
    @vehicle_leaving_carriageway
    )

    SET 
    accident_id=@accident_id,
    vehicle_id=@vehicle_id,
    age=@age,
    engine_capacity=@engine_capacity,
    age_of_vehicle=@age_of_vehicle ,
    vehicle_location_restricted_lane=@vehicle_location_restricted_lane,
    junction_location=@junction_location,
    hit_object_in_carriageway=@hit_object_in_carriageway,
    point_of_impact=@point_of_impact,
    journey_purpose=@journey_purpose ,
    sex=@sex,
    age_group=@age_group,
    vehicle_type=@vehicle_type,
    vehicle_manoeuvre=@vehicle_manoeuvre,
    skidding_and_overturning=@skidding_and_overturning,
    vehicle_leaving_carriageway=@vehicle_leaving_carriageway;



