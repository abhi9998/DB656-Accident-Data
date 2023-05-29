# Queries to interact with the accidents database
# Accident related tables
# Accident
# Junction_Accident

from ..models.modelutils import prompt_user_input
import logging
from .. import config
import re

def get_detailed_schema(cnx, table_name):
    """Function that returns list of fields in the table"""
    cursor = cnx.cursor()
    req_columns = ['COLUMN_NAME', 'DATA_TYPE', 'IS_NULLABLE', 'COLUMN_TYPE', 'COLUMN_KEY']
    cursor.execute(f"SELECT {', '.join(req_columns)} FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table_name}' and TABLE_SCHEMA = '{config['database']}' order by ORDINAL_POSITION")

    fields = [list(row) for row in cursor.fetchall()]

    logging.debug(f'Fields: {fields}')
    # if the fields are enum, populate the 4th column with the enum values
    for itr, field in enumerate(fields):
        if type(field[1]) == bytes:
            field[1] = field[1].decode('utf-8')

        if field[1] == 'enum':
            enum_str = field[3].decode('utf-8')  # decode bytes to string
            logging.info(f'Enum here: {enum_str}')
            # enum_list = enum_str.strip("enum()").replace("'", "").split(",")  # parse enum values from string
            match = re.search(r"enum\((.*)\)", enum_str)
            if match:
                values_string = match.group(1)
                values = re.findall(r"'(.*?)'", values_string)
                enum_list = [value.strip() for value in values]
                logging.info(f'Enum list: {enum_list}')
                field[3] = enum_list
    cursor.close()    
    return fields

def get_accidents_schema(cnx):
    """Get the schema of the accidents table"""
    return get_detailed_schema(cnx, 'Accident')

def get_junction_accidents_schema(cnx):
    """Get the schema of the accidents junction table"""
    return get_detailed_schema(cnx, 'Junction_Accident')

def get_police_authority_schema(cnx):
    """Get the schema of the police authority table"""
    return get_detailed_schema(cnx, 'PoliceAuthority')

def get_road_schema(cnx):
    """Get the schema of the road table"""
    return get_detailed_schema(cnx, 'Road')

def get_vehicle_schema(cnx):
    """Get the schema of the vehicle table"""
    return get_detailed_schema(cnx, 'Vehicle')

def get_junction_vehicle_schema(cnx):
    """Get the schema of the vehicle junction table"""
    return get_detailed_schema(cnx, 'Junction_Vehicle')

def get_person_profile_schema(cnx):
    """Get the schema of the profile table"""
    return get_detailed_schema(cnx, 'PersonProfile')

def get_casualty_schema(cnx):
    """Get the schema of the casualty table"""
    return get_detailed_schema(cnx, 'Casualty')

# The insert procedure is a bit more complex
# We need to insert as below
def get_values_for_accident_SP(cnx):
    """Insert a new accident"""
    # Get the schema of the accident table
    accident_schema = get_accidents_schema(cnx)
    logging.debug(f'Accident Schema: {accident_schema}')

    ## GET THE ACCIDENT TABLES SPECIFIC DETAILS ##
    # Prompt the user to enter the values for the accident table
    accident_related_input = prompt_user_input(accident_schema, 
                                               prompt_primary_key=True, 
                                               disregard_fields = ['road_id', 'authority_id'])
    
    police_authority_schema = get_police_authority_schema(cnx)
    logging.debug(f'Police Authority Schema: {police_authority_schema}')

    police_authority_input = prompt_user_input(police_authority_schema, 
                                               prompt_primary_key=False)
    accident_related_input.update(police_authority_input)

    # Get the details for the road where the accident happened   
    road_schema = get_road_schema(cnx)
    logging.debug(f'Road Schema: {road_schema}')

    road_input = prompt_user_input(road_schema,
                                   prompt_primary_key=False)
    
    accident_related_input.update(road_input)
    return accident_related_input

def get_values_for_Junction_Accident_SP(cnx):
    """Insert a new accident"""
    # Get the schema of the accident table
    junction_accident_schema = get_junction_accidents_schema(cnx)
    logging.debug(f'Junction Accident Schema: {junction_accident_schema}')

    # Prompt the user to enter the values for the accident table
    junction_accident_input = prompt_user_input(junction_accident_schema, 
                                               prompt_primary_key=False)
    return junction_accident_input

def get_values_for_PoliceAuthority_SP(cnx):
    """Insert a new accident"""
    # Get the schema of the accident table
    police_authority_schema = get_police_authority_schema(cnx)
    logging.debug(f'Police Authority Schema: {police_authority_schema}')

    # Prompt the user to enter the values for the accident table
    police_authority_input = prompt_user_input(police_authority_schema, 
                                               prompt_primary_key=False)
    return police_authority_input

def get_person_profile(cnx):
    """Get the person profile information"""
    person_profile_schema = get_person_profile_schema(cnx)
    logging.debug(f'Person Profile Schema: {person_profile_schema}')

    person_profile_input = prompt_user_input(person_profile_schema, 
                                            prompt_primary_key=False)
    return person_profile_input

def get_values_for_Vehicle_Data_SP(cnx):
    """Insert a new accident"""
    # Get the schema of the accident table
    vehicle_data_schema = get_vehicle_schema(cnx)
    logging.debug(f'Vehicle Data Schema: {vehicle_data_schema}')

    # Prompt the user to enter the values for the accident table
    vehicle_data_input = prompt_user_input(vehicle_data_schema, 
                                            prompt_primary_key=False,
                                            disregard_fields = ['profile_id'])
    ## Get Driver Profile Information ##
    print("------------------------")
    print('Enter the driver profile information:')
    print("------------------------")
    driver_profile_input = get_person_profile(cnx)
    vehicle_data_input.update(driver_profile_input)

    return vehicle_data_input

def get_values_for_Junction_Vehicle_SP(cnx):
    # Get the schema of the junction table
    junction_data_schema = get_junction_vehicle_schema(cnx)
    logging.debug(f'Vehicle Data Schema: {junction_data_schema}')

    # Prompt the user to enter the values for the junction data table
    vehicle_data_input = prompt_user_input(junction_data_schema, 
                                            prompt_primary_key=False)

    return vehicle_data_input

def get_values_for_casualty_SP(cnx):
    """Get values of each casualty from the user"""
    # Get the schema of the accident table
    casualty_schema = get_casualty_schema(cnx)
    logging.debug(f'Casualty Schema: {casualty_schema}')

    # Prompt the user to enter the values for the accident table
    casualty_input = prompt_user_input(casualty_schema, 
                                        prompt_primary_key=False,
                                        disregard_fields = ['profile_id'])
    print("------------------------")
    print('Enter the casualty profile information:')
    print("------------------------")
    casualty_input_profile = get_person_profile(cnx)
    casualty_input.update(casualty_input_profile)
    return casualty_input

def insert_into_database(cnx):
    """Insert all the values related to an accident in the database"""
    accident_related_input = get_values_for_accident_SP(cnx)
    junction_accident_related_input = None

    if (input('Is the accident junction related? (y/n): ').lower() == 'y'):
        junction_accident_related_input = {'accident_id': accident_related_input['accident_id']}
        _user_junc_input = get_values_for_Junction_Accident_SP(cnx)
        junction_accident_related_input.update(_user_junc_input)
    
    # For the number of vehicles involved in the accident, get the input
    vehicle_data_related_input = []
    vehicle_junction_data_related_input = []

    total_casualties = int(accident_related_input['number_of_casualties'])
    _casualty_itr = 1

    casualty_data_related_input = []

    for val in range(1, int(accident_related_input['number_of_vehicles']) + 1):
        print("--------------------------------------------")
        print("\tEnter the details for vehicle ", val, ":")
        print("--------------------------------------------")
        vehicle_data_input = {'accident_id': accident_related_input['accident_id'], 'vehicle_id': val}
        _vehicle_input = get_values_for_Vehicle_Data_SP(cnx)
        vehicle_data_input.update(_vehicle_input)
        vehicle_data_related_input.append(vehicle_data_input)

        if (input('Does this vehicle have junction related information? (y/n): ').lower() == 'y'):
            vehicle_junction_data_input = {'accident_id': accident_related_input['accident_id'], 'vehicle_id': val}
            _vehicle_junction_input = get_values_for_Junction_Vehicle_SP(cnx)
            vehicle_junction_data_input.update(_vehicle_junction_input)
            vehicle_junction_data_related_input.append(vehicle_junction_data_input)
        
        while total_casualties > 0:
            if (input('Are there any(more) casualties from this vehicle? (y/n): ').lower() == 'y'):
                print("----------------------------------------")
                print("\tEnter the details for casualty ", _casualty_itr, ":")
                print("----------------------------------------")
                casualty_data_input = {'casualty_id': _casualty_itr, 'vehicle_id': val, 'accident_id': accident_related_input['accident_id']}
                _casualty_input = get_values_for_casualty_SP(cnx)
                casualty_data_input.update(_casualty_input)
                casualty_data_related_input.append(casualty_data_input)
                total_casualties -= 1
                _casualty_itr += 1
            else:
                break
    
    logging.debug("Accident Related Input: %s", accident_related_input)
    logging.debug("Junction Accident Related Input: %s", junction_accident_related_input)
    logging.debug("Vehicle Data Related Input: %s", vehicle_data_related_input)
    for val in vehicle_data_related_input:
        logging.debug(val)
    
    logging.info("Vehicle Junction Data Related Input: %s", vehicle_junction_data_related_input)
    for val in vehicle_junction_data_related_input:
        logging.debug(val)
    
    logging.info("Casualty Data Related Input: %s", casualty_data_related_input)
    for val in casualty_data_related_input:
        logging.debug(val)
    
    ## Insert the values into the database for the given accident
    try:
        # begin a transaction
        cursor = cnx.cursor()
        cursor.execute("START TRANSACTION")

        # Insert into the accident table
        # Call the Accident SP
        cursor.callproc('Insert_Accident_Data_SP', tuple(accident_related_input.values()))

        # Insert into the junction accident table
        if junction_accident_related_input:
            cursor.callproc('Insert_Junction_Accident_Data_SP', tuple(junction_accident_related_input.values()))
        
        # Insert into the vehicle data table
        for vehicle_data_input in vehicle_data_related_input:
            cursor.callproc('Insert_Vehicle_Data_SP', tuple(vehicle_data_input.values()))
        
        # Insert into the junction vehicle table
        for vehicle_junction_data_input in vehicle_junction_data_related_input:
            cursor.callproc('Insert_Junction_Vehicle_Data_SP', tuple(vehicle_junction_data_input.values()))
        
        # Insert into the casualty table
        for casualty_data_input in casualty_data_related_input:
            cursor.callproc('Insert_Casualty_Data_SP', tuple(casualty_data_input.values()))
        
        # commit the transaction
        cursor.execute("COMMIT")
        logging.info('Successfully inserted into database')

    except Exception as e:
        cursor.execute("ROLLBACK")
        logging.error(f'Error while inserting into database: {e}')
    finally:
        cursor.close()

def delete_from_database(cnx):
    """Delete the accident data from the database"""
    # Get the accident id to delete
    accident_id = input('Enter the accident id to delete: ')

    # Delete the accident data from the database
    try:
        cursor = cnx.cursor()
        cursor.callproc('Delete_Accident_by_ID_SP', (accident_id,))
        logging.info('Successfully deleted from database')
    except Exception as e:
        cursor.execute("ROLLBACK")
        logging.error(f'Error while deleting from database: {e}')
    finally:
        cursor.close()