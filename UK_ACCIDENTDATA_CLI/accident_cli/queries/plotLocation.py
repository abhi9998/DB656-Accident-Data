
import logging
from prettytable import PrettyTable
from ..models.modelutils import prompt_user_input
import folium
import webbrowser
from .queryutils import get_store_procedure_schema, prompt_user_input_stored_procedure

def plot_location(cnx):
    """Plot the location of the accidents"""

    # Get the parameters of the stored procedure
    stored_procedure_schema = get_store_procedure_schema(cnx,'Get_Location_SP')
    # Prompt the user for the values of the fields
    user_input = prompt_user_input_stored_procedure(stored_procedure_schema)

    # Get the Locations
    cursor = cnx.cursor()
    try:
        
        temp_list = list( user_input.values()) 
        
        logging.debug(f'Fetching Locations for: {temp_list}')
    
        cursor.callproc('Get_Location_SP', tuple(temp_list))
        
        resultsSol = [] 
        for result in cursor.stored_results():
            resultsSol=result.fetchall()

        locations ={}
        for result in resultsSol:
            locations.setdefault(result[2], []).append([float(result[0]),float(result[1])])
    
        # Create a map centered on a specific location
        m = folium.Map(location=([resultsSol[0][0],resultsSol[0][1]]), zoom_start=12)

        colors={'Slight':'green','Serious':'blue','Fatal':'orange'}
        for key in locations:
            print(key)
            # Add markers for each location to the map
            for location in locations[key]:
                icon=folium.Icon(color=colors[key])
                folium.Marker(location=location, popup=key,icon=icon).add_to(m)            
    
        m.save("map_1.html")
        webbrowser.open("map_1.html")

        logging.info('Locations fetched successfully')
        
    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        cursor.close()



