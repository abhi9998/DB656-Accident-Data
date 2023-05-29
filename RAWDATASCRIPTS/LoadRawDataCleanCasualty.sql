use RawDataUKAccidents;


drop table if exists RawCasualty ;

create table RawCasualty(
    
 
    accident_id    char(20),       
    vehicle_id  INT,         
    casualty_id    INT,      
    age          INT,        
    casualty_class  char(50),     
    sex          char(10),        
    age_group         char(10),   
    casualty_severity  char(50),  
    pedestrian_movement  char(100), 
    pedestrian_location  char(100),
    casualty_type char(50),
  
    primary key(accident_id,vehicle_id,casualty_id)
);



load data local infile "D:\\aaaaaaaaa\\LoadAllData-20230402T185233Z-001\\LoadAllData\\clean-2014-data\\casualty_raw_clean.csv"
    ignore into table RawCasualty
    fields terminated by ','
	enclosed by '"'
    lines terminated by '\n'
    ignore 1 rows
    (
     @index,   
     @accident_id,    
    @vehicle_id ,          
     @casualty_id,          
    @age,        
    @casualty_class,
    @sex ,       
    @age_group,            
    @casualty_severity,    
    @pedestrian_movement,  
    @pedestrian_location,  
    @casualty_type
    )

    SET 
    accident_id=@accident_id,
    vehicle_id=@vehicle_id,
    casualty_id = @casualty_id,
    age=@age,
    casualty_class=@casualty_class,
    sex= @sex ,       
    age_group=@age_group,            
    casualty_severity=@casualty_severity,    
    pedestrian_movement=@pedestrian_movement,  
    pedestrian_location=@pedestrian_location,  
    casualty_type=@casualty_type;


