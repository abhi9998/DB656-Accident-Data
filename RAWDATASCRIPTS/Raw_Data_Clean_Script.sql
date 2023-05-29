use rawdataukaccidents;
 SET SQL_SAFE_UPDATES = 0;

update rawvehicle set engine_capacity =NULL where engine_capacity=-1;
update rawvehicle set age_of_vehicle =NULL where age_of_vehicle=-1;

update rawaccident set junction_control =NULL where junction_control='Data missing or out of range';
update rawvehicle set vehicle_location_restricted_lane =NULL where vehicle_location_restricted_lane='Data missing or out of range';

update rawvehicle set point_of_impact =NULL where point_of_impact='Data missing or out of range';
update rawvehicle set journey_purpose =NULL where journey_purpose='Data missing or out of range';

update rawcasualty set pedestrian_movement =NULL where pedestrian_movement='Data missing or out of range';
update rawcasualty set pedestrian_location =NULL where pedestrian_location='Data missing or out of range';


update rawvehicle set sex=NULL, age_group=NULL, age=NULL where sex='Not known' and age_group='Unknown';
update rawvehicle set age_group='Not known' where age_group='Unknown';
update rawvehicle set age =NULL where age=-1;

update rawcasualty set sex=NULL, age_group=NULL, age=NULL where sex='Data missi' and age_group='Unknown';
update rawcasualty set  age_group='Not known' where age_group='Unknown';
update rawcasualty set age =NULL where age=-1;