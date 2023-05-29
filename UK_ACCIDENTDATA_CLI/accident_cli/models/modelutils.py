import logging
from accident_cli.database import connect

def get_rows(cnx, table_name, limit=10):
    """Get the accidents from the database"""
    try:
        cursor = cnx.cursor()
        query = f'SELECT * FROM {table_name} LIMIT {limit}'
        cursor.execute(query)
        accidents = cursor.fetchall()
        logging.info(f'Response: {len(accidents)} accidents retrieved from the database.')
        return accidents
    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        cursor.close()
    
def prompt_user_input(fields, prompt_primary_key=True, infer_input_for = None, disregard_fields = None):
    """Prompt the user to input the values for the fields"""
    user_input = {}
    for field in fields:
        if not prompt_primary_key and field[4] == 'PRI':
            continue

        _field_name = field[0]

        if disregard_fields and _field_name in disregard_fields:
            continue

        if infer_input_for and _field_name in infer_input_for.keys():
            user_input[_field_name] = infer_input_for[_field_name]
            continue

        if type(field[1]) == bytes:
            field[1] = field[1].decode('utf32')

        if field[1] == 'enum':
            print(f'Enter the value for the field {field[0]} from the following values: ')

            if field[2] != 'NO':
                print(f'\t0: None')

            for itr, val in enumerate(field[3]):
                print(f'\t{itr+1}: {val}')

            choice = None
            start_range = 0 if field[2] != 'NO' else 1

            while choice not in range(start_range, len(field[3]) + 1):
                try:
                    choice = int(input("--> Choice:"))

                    if choice not in range(start_range, len(field[3]) + 1):
                        logging.error("Input a valid choice")
                except ValueError:
                    logging.error("Input a valid choice")
                    continue
            
            if choice == 0:
                user_input[_field_name] = None
            else:
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