use ukfinal;

Drop procedure if exists Get_Location_SP;

DELIMITER @@
CREATE PROCEDURE Get_Location_SP(
	IN in_year INT,
    IN in_month INT,
	
    IN in_police_force char(100),
    IN in_local_authority_district char(100),
    IN in_local_authority_highway char(100),
    IN in_accident_severity ENUM(
        'Slight',
        'Serious',
        'Fatal',
        'ALL'
    ) 

)


BEGIN
	DECLARE accident_severity_option VARCHAR(50);
    
    IF in_accident_severity = 'ALL' THEN
		SET accident_severity_option = '%';
    ELSE
		SET accident_severity_option = in_accident_severity;
	END IF;
        
		

	with authorities_id as (select authority_id from PoliceAuthority where
    police_force LIKE in_police_force and local_authority_district LIKE local_authority_district
    and local_authority_highway LIKE in_local_authority_highway)
  SELECT latitude, longitude,accident_severity FROM Accident where authority_id in (select * from authorities_id) 
					and CAST(Month(datee) as char) Like in_month and Year(datee)= in_year
                    and accident_severity LIKE accident_severity_option;
                    

END @@
DELIMITER ;


call Get_Location_SP(2014,5,'%','%','%','ALL')