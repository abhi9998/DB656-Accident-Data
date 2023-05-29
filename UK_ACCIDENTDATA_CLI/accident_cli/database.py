# module for connecting to and interacting with the database
import logging
import mysql.connector
from mysql.connector import errorcode

def connect(config):
    """Connect to the MySQL database server"""
    logging.info('Connecting to MySQL database...')
    try:
        cnx = mysql.connector.connect(**config)
        return cnx
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Incorrect username and password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
        return None

def disconnect(cnx):
    """Disconnect from the MySQL database server"""
    logging.info('Disconnecting from MySQL database...')
    cnx.close()
    