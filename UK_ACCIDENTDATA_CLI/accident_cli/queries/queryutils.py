import logging
from prettytable import PrettyTable




def get_store_procedure_schema(cnx, stored_procedure_name):
    """Get the schema of the accidents table"""
    return show_stored_procedure_parameters(cnx, stored_procedure_name, display=False)



def show_stored_procedure_parameters(cnx,stored_procedure_name, display=True):
    """Function that returns list of fields in the table"""
    cursor = cnx.cursor()
    
    cursor.execute(f"SELECT PARAMETER_NAME, DATA_TYPE, DTD_IDENTIFIER FROM INFORMATION_SCHEMA.Parameters WHERE SPECIFIC_NAME = '{stored_procedure_name}'")
    fields = [(row[0], row[1], row[2], None) for row in cursor.fetchall()]
    print(fields)
    logging.debug(f'Fields: {fields}')
    # if the fields are enum, populate the 4th column with the enum values
    for itr, field in enumerate(fields):
        if field[1] == 'enum':
            
            enum_str = field[2].decode('utf-8')  # decode bytes to string
            enum_list = enum_str.strip("enum()").replace("'", "").split(",")  # parse enum values from string
            field = (field[0], field[1], field[2], enum_list)
            fields[itr] = field

    cursor.close()
    logging.debug(f'Fieldssss: {fields}')
    if display:
        table = PrettyTable()
        table.field_names = ["Parameter Name", "Type", "DTD_Identifier", "Enum Values"]
        for field in fields:
            table.add_row(field)
        
        for col in table.field_names:
            table.align[col] = 'l'
        logging.info('Response: The fields in the table are:\n' + table.get_string())
        return None
    
    return fields


def prompt_user_input_stored_procedure(fields):
    """Prompt the user for the values of the fields"""

    user_input = {}
    for field in fields:
    
        _field_name = field[0]

        if field[1] == 'enum':
            print(f'Enter the value for the field {field[0]} from the following values: ')


            for itr, val in enumerate(field[3]):
                print(f'\t{itr+1}: {val}')
            
            choice = -1
            start_range = 0 

            while choice not in range(start_range, len(field[3]) + 1):
                try:
                    choice = int(input("--> Choice:"))

                    if choice not in range(start_range, len(field[3]) + 1):
                        logging.error("Input a valid choice")
                except ValueError:
                    logging.error("Input a valid choice")
                    continue
            
            user_input[_field_name] = field[3][choice - 1]
        else:
            user_input[_field_name] = input(f'Enter the value for the field {field[0]} ({field[1]}): ')

            while True:
                try:
                    if field[1] == 'int':
                        # check if the value is a valid integer
                        user_input[_field_name] = int(user_input[_field_name])
                    elif field[1] == 'decimal':
                        user_input[_field_name] = float(user_input[_field_name])
                    break
                except ValueError:
                    logging.error(f'Response: A valid entry for {field[0]} is required!')
                    user_input[_field_name] = input(f'Enter the value for the field {field[0]} ({field[1]}): ')
        
        while field[2] == 'NO' and not user_input[_field_name]:
            logging.error(f'Response: A valid entry for {field[0]} is required!')
            user_input[_field_name] = input(f'Enter the value for the field {field[0]} ({field[1]}): ')

    return user_input
    