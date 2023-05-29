use RawDataUKAccidents;

drop table if exists RawAccident;

create table RawAccident(
    
    accident_id char(20),
    longitude decimal(8,6),
    latitude decimal(8,6),
    number_of_vehicles INT,
    number_of_casualties INT,
    datee DATE ,
    day_of_week INT,
    timee  time,
    road_number INT ,
    speed_limit INT,                  
    police_force char(100) ,
    accident_severity char(50) ,
    local_authority_district char(100) ,
    local_authority_highway char(100) ,
    road_class char(50) ,
    road_type char(50) ,
    junction_detail char(100) ,
    junction_control char(100),
    pedestrian_crossing_facility char(100),
    weather_condition char(50),
    light_condition char(50),
    road_condition char(50),
    urban_or_rural char(10),
    special_condition char(50),
  

    primary key(accident_id)
);


load data local infile "D:\\aaaaaaaaa\\LoadAllData-20230402T185233Z-001\\LoadAllData\\clean-2014-data\\accident_raw_clean.csv"
    ignore into table RawAccident
    fields terminated by ','
	enclosed by '"'
    lines terminated by '\n'
    ignore 1 rows
    (
    @index,    
    @accident_id,
    @longitude,
    @latitude,
    @number_of_vehicles,
    @number_of_casualties,
    @date ,
    @day_of_week,
    @time ,
    @road_number ,
    @speed_limit ,                  
    @police_force ,
    @accident_severity ,
    @local_authority_district ,
    @local_authority_highway ,
    @road_class ,
    @road_type ,
    @junction_detail ,
    @junction_control,
    @pedestrian_crossing_facility,
    @weather_conditon,
    @light_condition,
    @road_conditon,
    @urban_or_rural,
    @special_conditon
    )

    SET 
     accident_id=@accident_id,
    longitude=@longitude,
    latitude=@latitude,
    number_of_vehicles=@number_of_vehicles,
    number_of_casualties=@number_of_casualties,
    datee=@date ,
    day_of_week=@day_of_week,
    timee=@time ,
    road_number=@road_number ,
    speed_limit=@speed_limit ,                  
    police_force=@police_force ,
    accident_severity=@accident_severity ,
    local_authority_district=@local_authority_district ,
    local_authority_highway=@local_authority_highway,
    road_class=@road_class ,
    road_type=@road_type ,
    junction_detail=@junction_detail ,
    junction_control=@junction_control,
    pedestrian_crossing_facility=@pedestrian_crossing_facility,
    weather_condition=@weather_conditon,
    light_condition=@light_condition,
    road_condition=@road_conditon,
    urban_or_rural=@urban_or_rural,
    special_condition=@special_conditon;



