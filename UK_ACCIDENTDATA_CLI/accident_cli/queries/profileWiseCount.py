import logging
from prettytable import PrettyTable
from ..models.modelutils import prompt_user_input
import matplotlib.pyplot as plt
from .queryutils import get_store_procedure_schema, prompt_user_input_stored_procedure


def profile_wise_count(cnx):

    # Get the parameters of the stored procedure
    profile_type_SP = prompt_profile_select()

    # get the schema of the stored procedure
    stored_procedure_schema = get_store_procedure_schema(cnx,profile_type_SP)
    # Prompt the user for the values of the fields
    user_input = prompt_user_input_stored_procedure(stored_procedure_schema)

    # Get the profile wise data
    cursor = cnx.cursor()
    try:
        
        temp_list = list(user_input.values()) 
        
        logging.debug(f'Fetching Profile Details for: {temp_list}')
    
        cursor.callproc(profile_type_SP, tuple(temp_list))
        
        resultsSol = [] 
        for result in cursor.stored_results():
            resultsSol=result.fetchall()

        logging.info('Profile Details fetched successfully')
        
        plotProfile(resultsSol, temp_list[1])

    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        cursor.close()

    return


def prompt_profile_select():
    print('Enter the type for which want to get the profile [driver/casualty_type]:')
    profile_type = input('')

    if profile_type == 'driver':
        return 'Driver_Profile_SP'
    else:
        return 'Casualty_Type_Profile_SP'


def plotProfile(resultsSol,for_type):

    profiles ={}

    for result in resultsSol:
        profiles.setdefault(result[0], []).append([result[1],result[2]])

    for sex in profiles:
        
        x_values = [item[0] for item in profiles[sex]]
        y_values = [item[1] for item in profiles[sex]]
        
        # Create the bar chart
        plt.figure(figsize=(8, 6))
        plt.bar(x_values, y_values)

        # Add labels and title
        plt.xlabel("Age group")
        plt.ylabel("Count")
        plt.title(f"Distribution of casualty of '{for_type}' for '{sex}'")
        
        # Rotate the x-axis labels for better readability
        plt.xticks(rotation=90)
            
    # Show the plot
    plt.show()


