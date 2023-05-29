drop schema if exists ukfinal;
create schema ukfinal;


use ukfinal;
drop table if exists Casualty;
drop table if exists Junction_Vehicle;
drop table if exists Vehicle;
drop table if exists Junction_Accident;
drop table if exists Accident;
drop table if exists Road_Authority;
drop table if exists Road;
drop table if exists PersonProfile;
drop table if exists PoliceAuthority;

CREATE TABLE PoliceAuthority(

    authority_id INT AUTO_INCREMENT,
    police_force CHAR(100),
    local_authority_district CHAR(100),
    local_authority_highway CHAR(100),

    PRIMARY KEY(authority_id)
);

CREATE TABLE PersonProfile (

    profile_id INT AUTO_INCREMENT NOT NULL,
    sex ENUM('Male','Female','Not known'),
    age_group ENUM('Not known', 
                   '0 - 5',
                   '6 - 10',
                   '11 - 15',
                   '16 - 20',
                   '21 - 25',
                   '26 - 35',
                   '36 - 45',
                   '46 - 55',
                   '56 - 65',
                   '66 - 75',
                   'Over 75'),
    age INT,

    PRIMARY KEY(profile_id)
);


CREATE TABLE Road (
    road_id INT  AUTO_INCREMENT NOT NULL,
    road_class ENUM(
        'A',
        'C',
        'B',
        'Unclassified',
        'Motorway',
        'A(M)'
    ),

    road_number INT,
    road_type ENUM(
        'Single carriageway',
        'One way street',
        'Roundabout',
        'Dual carriageway',
        'Unknown',
        'Slip road'
    ),

    speed_limit INT,

    urban_or_rural ENUM(
        'Urban',
        'Rural'
    ),

    PRIMARY KEY(road_id)
);



CREATE TABLE Road_Authority(

    road_id INT NOT NULL,
    authority_id INT NOT NULL,

    PRIMARY KEY(road_id,authority_id),
    FOREIGN KEY(road_id) REFERENCES Road(road_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(authority_id) REFERENCES PoliceAuthority(authority_id)  ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE Accident(

    accident_id CHAR(30) NOT NULL,
    latitude DECIMAL(8,6),
    longitude DECIMAL(8,6),
    number_of_vehicles INT,
    number_of_casualties INT,
    datee date,
    day_of_week INT,
    timee time,
    weather_condition ENUM(
        'Raining without high winds',
        'Fine without high winds',
        'Raining with high winds',
        'Unknown',
        'Other',
        'Fine with high winds',
        'Snowing without high winds',
        'Fog or mist — if hazard',
        'Snowing with high winds'
    ),

    light_condition ENUM(
        'Daylight',
        'Darkness - lighting unknown',
        'Darkness - lights lit',
        'Darkness - lights unlit',
        'Darkness - no lighting'

    ),

    pedestrian_crossing_facility ENUM(
        'No physical crossing facilities within 50 metres',
        'Pedestrian phase at traffic signal junction',
        'Zebra',
        'Central refuge',
        'Pelican, puffin, toucan or similar non-junction pedestrian light crossing',
        'Footbridge or subway'

    ),


    accident_severity ENUM(
        'Slight',
        'Serious',
        'Fatal'
    ),

    road_condition ENUM(
        'Wet',
        'Dry',
        'Flood (surface water over 3cm deep)',
        'Ice',
        'Snow',
        'Not known'
    ),

    special_condition ENUM(
        'None',
        'Permanent road signing or marking defective',
        'Roadworks',
        'Road surface defective',
        'Auto traffic signal partially defective',
        'Oil or diesel',
        'Auto traffic signal out',
        'Mud',
        'Not known'
    ),
    road_id INT,
    authority_id INT,

    PRIMARY KEY(accident_id),
    FOREIGN KEY(road_id) REFERENCES Road(road_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(authority_id) REFERENCES PoliceAuthority(authority_id)  ON UPDATE CASCADE ON DELETE CASCADE

);



CREATE TABLE Junction_Accident(

    accident_id char(30) NOT NULL,
    junction_detail ENUM(
    'Slip road',
    'T or staggered junction',
    'More than 4 arms (not roundabout)',
    'Roundabout',
    'Crossroads',
    'Other junction',
    'Private drive or entrance',
    'Mini-roundabout'
    ),

    junction_control ENUM(
      --  'Data missing or out of range',
        'Give way or uncontrolled',
        'Auto traffic signal',
        'Authorised person',
        'Stop sign'
    ),

    PRIMARY KEY(accident_id),
    FOREIGN KEY(accident_id) REFERENCES Accident(accident_id)  ON UPDATE CASCADE ON DELETE CASCADE
    
);




CREATE TABLE Vehicle(

    accident_id CHAR(30) NOT NULL,
    vehicle_id INT NOT NULL ,
    vehicle_location_restricted_lane ENUM(
                "On main c\'way - not in restricted lane",
                'Footway (pavement)',
                'Cycle lane (on main carriageway)',
                'Bus lane',
                'Busway (including guided busway)',
                'Cycleway or shared use footway (not part of  main carriageway)',
                'Leaving lay-by or hard shoulder',
                'Entering lay-by or hard shoulder',
                'On lay-by or hard shoulder',
                'Tram/Light rail track'
                -- 'Data missing or out of range'
    ),

    point_of_impact ENUM(
        'Nearside',
        'Front',
        'Offside',
        'Back',
        'Did not impact'
    --    'Data missing or out of range'
    ),

    journey_purpose ENUM(
        'Journey as part of work',
        'Not known',
        'Commuting to/from work',
        'Taking pupil to/from school',
        'Pupil riding to/from school',
      --  'Data missing or out of range',
        'Other'
    ),

    engine_capacity INT ,

    age_of_vehicle INT,

    hit_object_in_carriageway ENUM(

        'None',
        'Bridge-roof',
        'Open door of vehicle',
        'Parked vehicle',
        'Kerb',
        'Other Object',
        'Roadworks',
        'Previous accident',
        'Central island of roundabout',
        'Animal',
        'Bollard',
        'Bridge-side',
        'Not known'
    ),

    vehicle_manoeuvre CHAR(100),

    skidding_and_overturning ENUM(
        'No skidding',
        'Skidded',
        'Overturned',
        'Skidded and overturned',
        'Jack - knifed and overturned',
        'Jack - knifed'
    ),

    vehicle_leaving_carriageway CHAR(100),

    profile_id INT,

    PRIMARY KEY(accident_id,vehicle_id),
    FOREIGN KEY(accident_id) REFERENCES Accident(accident_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(profile_id) REFERENCES PersonProfile(profile_id)  ON UPDATE CASCADE ON DELETE CASCADE

);

CREATE INDEX idx_Vehicle_vehicle_id on Vehicle(vehicle_id);

CREATE TABLE Junction_Vehicle(

    accident_id CHAR(30),
    vehicle_id INT NOT NULL,
    junction_location ENUM(
        'Approaching junction or waiting/parked at junction approach',
        'Leaving main road',
        'Mid Junction - on roundabout or on main road',
        'Cleared junction or waiting/parked at junction exit',
        'Entering main road',
        'Entering from slip road',
        'Leaving roundabout',
        'Entering roundabout'    
    ),

    PRIMARY KEY(accident_id,vehicle_id),
    FOREIGN KEY(accident_id,vehicle_id) REFERENCES Vehicle(accident_id,vehicle_id)  ON UPDATE CASCADE ON DELETE CASCADE


);




CREATE TABLE Casualty (

    casualty_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    accident_id CHAR(30) NOT NULL,
    casualty_class ENUM('Driver or rider','Pedestrian','Passenger'),
    casualty_severity ENUM('Slight','Serious','Fatal'),
    pedestrian_movement ENUM('Not a Pedestrian',
                             "Crossing from driver's nearside",
                             "In carriageway, stationary - not crossing  (standing or playing) - masked by parked or stationary ve",
                             "Unknown or other",
                             "Crossing from offside - masked by  parked or stationary vehicle",
                             "In carriageway, stationary - not crossing  (standing or playing)",
                             "Crossing from nearside - masked by parked or stationary vehicle",
                             "Walking along in carriageway, back to traffic",
                             "Crossing from driver's offside",
                             "Walking along in carriageway, facing traffic"
                             -- "Data missing or out of range"
                            ),
    pedestrian_location ENUM(
                            'Not a Pedestrian',
                            'Crossing on pedestrian crossing facility',
                            'Unknown or other',
                            'On footway or verge',
                            'In carriageway, not crossing',
                            'Crossing elsewhere within 50m. of pedestrian crossing',
                            'In carriageway, crossing elsewhere',
                            'Crossing in zig-zag approach lines',
                            'In centre of carriageway - not on refuge, island or central reservation',
                            'Crossing in zig-zag exit lines',
                            'On refuge, central island or central reservation'
                            -- 'Data missing or out of range'
                        ),
    
    casualty_type ENUM(
                    "Taxi/Private hire car occupant",
                    "Cyclist",
                    "Motorcycle 125cc and under rider or passenger",
                    "Pedestrian",
                    "Car occupant",
                    "Motorcycle over 125cc and up to 500cc rider or  pa",
                    "Motorcycle 50cc and under rider or passenger",
                    "Van / Goods vehicle (3.5 tonnes mgw or under) occu",
                    "Bus or coach occupant (17 or more pass seats)",
                    "Motorcycle over 500cc rider or passenger",
                    "Minibus (8 - 16 passenger seats) occupant",
                    "Goods vehicle (7.5 tonnes mgw and over) occupant",
                    "Other vehicle occupant",
                    "Goods vehicle (over 3.5t. and under 7.5t.) occupan",
                    "Horse rider",
                    "Tram occupant",
                    "Agricultural vehicle occupant",
                    "Mobility scooter rider",
                    "Motorcycle - unknown cc rider or passenger",
                    "Goods vehicle (unknown weight) occupant",
                    "Electric motorcycle rider or passenger"
                    ),

    profile_id INT,

    PRIMARY KEY(accident_id,vehicle_id,casualty_id),
    FOREIGN KEY(accident_id) REFERENCES Accident(accident_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(accident_id,vehicle_id) REFERENCES Vehicle(accident_id,vehicle_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(profile_id) REFERENCES PersonProfile(profile_id)  ON UPDATE CASCADE ON DELETE CASCADE
);


