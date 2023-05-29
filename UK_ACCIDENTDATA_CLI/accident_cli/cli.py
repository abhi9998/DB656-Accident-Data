# main CLI script that uses argparse to handle command-line arguments and invokes other functions in the package
import accident_cli.dbutils as utils
import accident_cli.models.accidents as accidents
import accident_cli.queries.plotLocation as plotLocation
import accident_cli.queries.profileWiseCount as proflieWiseCount
import accident_cli.queries.junctionAccidentCount as junctionAccidentCount 
import logging

# Define the allowed operations
# Each operation is a tuple of the form (function, description, active connection required)
OPERATIONS = {
    # Exit the program
    0: (None, 'Exit the program', False),
    # Database connection Options
    1: (utils.connection_test, 'Test the connection to the UK Accidents database', False),
    2: (utils.connect_db, 'Connect to the UK Accidents database', False),
    # Generic Database Operations
    3: (utils.show_tables, 'List all the tables in a database', True),
    4: (utils.show_user_grants, 'Show current user grants', True),
    5: (utils.show_table_schema, 'Show table schema', True),
    # Select Operations on tables
    6: (utils.select_all, 'Select all rows from a table', True),
    7: (utils.select_where, 'Select rows from a table based on a condition', True),
    8: (utils.select_where_like, 'Select rows from a table based on a condition with LIKE', True),
    # Insert Operations on tables
    9: (accidents.insert_into_database, 'Insert UK accident data', True),
    10: (accidents.delete_from_database, 'Delete UK accident data', True),
    #insights queries
    11: (plotLocation.plot_location, 'Plot the location of accidents', True),
    12: (proflieWiseCount.profile_wise_count,'Get the profile wise count of accidents', True),
    13: (junctionAccidentCount.junction_accident_count,'Get the junction wise count of accidents', True)
}

def main():
    """Main function"""
    cnx = None
    while True:
        print(" " * 20 + "-" * 50)
        print(" " * 20 + "Choose an operation from below:")

        # Print the available operations
        for key, value in OPERATIONS.items():
            print(" " * 20 + f"{key}: {value[1]}")
            
        print(" " * 20 + "-" * 50)

        # Get the user's choice
        try:
            choice = int(input("Enter the option number: "))
            print()
            
            if choice not in OPERATIONS:
                logging.error("Response: Invalid option! Please try again.")
                continue
            elif choice == 0:
                break
            elif choice == 2:
                # Connect to the database
                cnx = OPERATIONS[choice][0]()
            else:
                # check if the operation requires an active connection
                if OPERATIONS[choice][2]:
                    if cnx is None:
                        logging.error("Response: No active connection! Please connect to the database first.")
                        continue
                    else:
                        # Invoke the function
                        OPERATIONS[choice][0](cnx)
                else:
                    # Invoke the function
                    OPERATIONS[choice][0]()
            print()
        except ValueError:
            logging.error("Response: Invalid option! Please try again.")
            continue


if __name__ == '__main__':
    # execute only if run as a script
    main()