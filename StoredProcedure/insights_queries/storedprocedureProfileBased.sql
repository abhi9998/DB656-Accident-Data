use ukfinal;


-- profile wise drivers
Drop procedure if exists Driver_Profile_SP;

DELIMITER @@
CREATE PROCEDURE Driver_Profile_SP(
	IN in_year INT,
    IN in_profile ENUM('Driver')
)


BEGIN
	with profile_wise_drivers as (SELECT * FROM ukfinal.vehicle as t1 inner join personprofile as t2 using (profile_id))

	select sex, age_group, count(*) as count from profile_wise_drivers group by sex,age_group having sex<>'Not known';
                    

END @@
DELIMITER ;


call Driver_Profile_SP(2014,'Driver');







use ukfinal;

Drop procedure if exists Casualty_Type_Profile_SP;

DELIMITER @@
CREATE PROCEDURE Casualty_Type_Profile_SP(
	IN in_year INT,
    IN in_casualty_type ENUM(
                    "Taxi/Private hire car occupant",
                    "Cyclist",
                    "Motorcycle 125cc and under rider or passenger",
                    "Pedestrian",
                    "Car occupant"
                    )
)


BEGIN
	with profile_wise_casualty_type as (SELECT * FROM ukfinal.casualty as t1 inner join personprofile as t2 using (profile_id) where casualty_type like in_casualty_type)

	select sex, age_group, count(*) as count from profile_wise_casualty_type group by sex,age_group having sex<>'Not known' order by sex,age_group;
                    

END @@
DELIMITER ;


call Casualty_Type_Profile_SP(2014,'Cyclist');