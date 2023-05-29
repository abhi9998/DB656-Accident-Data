use ukfinal;


-- junction accident count ---
Drop procedure if exists Junction_Accident_Count_SP;

DELIMITER @@
CREATE PROCEDURE Junction_Accident_Count_SP(
	IN in_year INT,
    IN in_police_force char(100)
    
)

BEGIN
	with accidents_of_police_region as (select accident_id, accident_severity from accident where authority_id in 
    (select authority_id from policeauthority where police_force LIKE in_police_force)),
    
    junction_accident_of_police_region as (select * from junction_accident inner join accidents_of_police_region
    using (accident_id))
    
    select junction_detail as junction, accident_severity , count(*) from junction_accident_of_police_region
    group by junction_detail,accident_severity order by junction_detail,accident_severity;
    
END @@
DELIMITER ;

call Junction_Accident_Count_SP(2014,'Northumbria');
call Junction_Accident_Count_SP(2014,'City of London');

call Junction_Accident_Count_SP(2014,'Staffordshire');