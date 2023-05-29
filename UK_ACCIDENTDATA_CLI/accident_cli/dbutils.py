from accident_cli.database import connect
import logging
from prettytable import PrettyTable
from . import config

def prompt_connection_details():
    print('Enter the values for the database connection:')
    config = {
        'user': input('\tUsername: '),
        'password': input('\tPassword: '),
        'host': input('\tHost: '),
        'database': input('\tDatabase: '),
        'raise_on_warnings': True
    }
    print()
    return config

def prompt_tablename():
    print('Enter the name of the table:')
    table_name = input('\tTable name: ')
    print()
    return table_name

def prompt_limit():
    print('Enter the limit for the number of rows :')
    try:
        limit = int(input('\tLimit: '))
    except ValueError:
        limit = None
    print()
    return limit

def connection_test():
    """Input the values for the database connection"""
    # cnf = prompt_connection_details()
    cnf = config
    cnx = connect(cnf)
    if cnx is not None:
        logging.info('Response: Connection successful!')
        cnx.close()
    else:
        logging.error('Response: Connection failed!')

def connect_db():
    """Input the values for the database connection from the user"""
    # cnf = prompt_connection_details()
    cnf = config
    cnx = connect(cnf)
    if cnx is not None:
        logging.info('Response: Connection successful!')
        return cnx
    else:
        logging.error('Response: Connection failed!')
        return None

def show_tables(cnx):
    """Show the tables in the database"""
    try:
        cursor = cnx.cursor()
        cursor.execute('SHOW TABLES')
        tables = [table_name[0] for table_name in cursor.fetchall()]
        table = PrettyTable()
        table.field_names = ["Table Name"]
        for table_name in tables:
            table.add_row([table_name])
        logging.info('Response: The tables in the database are:\n' + table.get_string())
    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        cursor.close()

def show_user_grants(cnx):
    """Show the grants for the current user"""
    try:
        cursor = cnx.cursor()

        # Get all the grants for the user and host
        cursor.execute(f"SHOW GRANTS FOR '{cnx.user}'@'{cnx.server_host}'")
        grants = [grant[0] for grant in cursor.fetchall()]
        logging.debug(f'Grants: {grants}')

        # Create a table to display the grants information
        table = PrettyTable()
        table.field_names = ["Grants"]
        for grant in grants:
            table.add_row([grant])
        logging.info('Response: The grants for current user are:\n' + table.get_string())
        
    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        cursor.close()

def show_table_schema(cnx, table_name=None, display=True):
    """Function that returns list of fields in the table"""
    cursor = cnx.cursor()
    if not table_name:
        table_name = prompt_tablename()

    cursor.execute(f"SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table_name}' and TABLE_SCHEMA = '{config['database']}'")
    fields = [(row[0], row[1], row[2], None) for row in cursor.fetchall()]

    logging.debug(f'Fields: {fields}')
    # if the fields are enum, populate the 4th column with the enum values
    for itr, field in enumerate(fields):
        if field[1] == 'enum':
            cursor.execute(f"SHOW COLUMNS FROM {cnx.database}.{table_name} WHERE Field = '{field[0]}'")
            f_one = cursor.fetchone()
            logging.debug(f'Cursor: {f_one}')
            enum_str = f_one[1].decode('utf-8')  # decode bytes to string
            enum_list = enum_str.strip("enum()").replace("'", "").split(",")  # parse enum values from string
            field = (field[0], field[1], field[2], enum_list)
            fields[itr] = field

    cursor.close()

    if display:
        table = PrettyTable()
        table.field_names = ["Field Name", "Type", "Nullability", "Enum Values"]
        for field in fields:
            table.add_row(field)
        
        for col in table.field_names:
            table.align[col] = 'l'
        logging.info('Response: The fields in the table are:\n' + table.get_string())
        return None
    
    return fields

def select_all(cnx):
    """Select all the rows from the table"""
    cursor = cnx.cursor()
    table_name = prompt_tablename()
    limit = prompt_limit()
    try:
        if limit:
            cursor.execute(f'SELECT * FROM {table_name} LIMIT {limit}')
        else:
            cursor.execute(f'SELECT * FROM {table_name}')

        rows = cursor.fetchall()
        logging.debug(f'Rows: {rows}')
        table = PrettyTable()
        table.field_names = [field[0] for field in cursor.description]
        for row in rows:
            table.add_row(row)
        cursor.close()
        logging.info('Response: The rows in the table are:\n' + table.get_string())
    except Exception as e:
        logging.error(f'Error: {e}')

def select_where(cnx):
    """Select all rows from the table that match given key value pair"""
    cursor = cnx.cursor()
    table_name = prompt_tablename()
    limit = prompt_limit()
    field_name = input('\tEnter the field name: ')
    field_value = input('\tEnter the field value: ')
    try:
        if limit:
            cursor.execute(f"SELECT * FROM {table_name} WHERE {field_name} = '{field_value}' LIMIT {limit}")
        else:
            cursor.execute(f"SELECT * FROM {table_name} WHERE {field_name} = '{field_value}'")

        rows = cursor.fetchall()
        logging.debug(f'Rows: {rows}')
        table = PrettyTable()
        table.field_names = [field[0] for field in cursor.description]
        for row in rows:
            table.add_row(row)
        cursor.close()
        logging.info('Response: The rows in the table are:\n' + table.get_string())
    except Exception as e:
        logging.error(f'Error: {e}')

def select_where_like(cnx):
    """Select all rows from the table that match given key value pair"""
    cursor = cnx.cursor()
    table_name = prompt_tablename()
    limit = prompt_limit()
    field_name = input('\tEnter the field name: ')
    field_value = input('\tEnter the field value: ')
    try:
        if limit:
            cursor.execute(f"SELECT * FROM {table_name} WHERE {field_name} LIKE '%{field_value}%' LIMIT {limit}")
        else:
            cursor.execute(f"SELECT * FROM {table_name} WHERE {field_name} LIKE '%{field_value}%'")
        rows = cursor.fetchall()
        logging.debug(f'Rows: {rows}')
        table = PrettyTable()
        table.field_names = [field[0] for field in cursor.description]
        for row in rows:
            table.add_row(row)
        cursor.close()
        logging.info('Response: The rows in the table are:\n' + table.get_string())
    except Exception as e:
        logging.error(f'Error: {e}')