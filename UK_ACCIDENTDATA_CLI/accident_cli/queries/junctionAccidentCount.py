import logging
from prettytable import PrettyTable
from ..models.modelutils import prompt_user_input
import matplotlib.pyplot as plt
from .queryutils import get_store_procedure_schema, prompt_user_input_stored_procedure
import numpy as np

def junction_accident_count(cnx):
    """Get the accident count for each junction"""
    # Get the parameters of the stored procedure
    stored_procedure_schema = get_store_procedure_schema(cnx,'Junction_Accident_Count_SP')
    # Prompt the user for the values of the fields
    user_input = prompt_user_input_stored_procedure(stored_procedure_schema)
    
    

    # Get the Junction Accident Count
    cursor = cnx.cursor()
    try:
        
        temp_list = list( user_input.values()) 
        
        logging.debug(f'Fetching Junction Accident Count for: {temp_list}')
    
        cursor.callproc('Junction_Accident_Count_SP', tuple(temp_list))
        
        resultsSol = [] 
        for result in cursor.stored_results():
            resultsSol=result.fetchall()
   
        logging.info('Junction Accident Count fetched successfully')
        
        plotJunctionAccidentCount(resultsSol, temp_list[1])

    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        cursor.close()

    return

def plotJunctionAccidentCount(resultsSol,area_name):
    """Plot the junction accident count"""
    junction_types = list(set([row[0] for row in resultsSol]))
    junction_types.sort()

    plt.figure(figsize=(10, 5))
    
    severities = ['Slight', 'Serious', 'Fatal']
    finalResults = [[] for _ in range(len(severities))]
    for junction_type in junction_types:
        counts = []
        for severity in severities:    
            count = next((row[2] for row in resultsSol if row[0] == junction_type and row[1] == severity), 0)
            counts.append(count)
        for i in range(len(severities)):    
            finalResults[i].append(counts[i])

    print(finalResults)
    X_axis = np.arange(len(junction_types))

    width = 0.3
    for i, data in enumerate(finalResults):
        plt.bar(X_axis + (i - 1) * width / 2, data, width, label=severities[i])

    plt.margins(0.05)
    plt.xticks(X_axis,junction_types)
    print(junction_types)
    plt.xlabel('Junction Type')
    plt.ylabel('Number of Accidents')
    plt.title(f'Accidents by Junction Type and Severity for {area_name}')
    plt.xticks(rotation=90)
    plt.tight_layout()
    plt.legend()
    plt.show()
    return 