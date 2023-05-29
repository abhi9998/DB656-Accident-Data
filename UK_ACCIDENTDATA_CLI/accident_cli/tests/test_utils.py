# unit tests for the utils module
import unittest
from unittest.mock import patch
import accident_cli.dbutils as utils
import accident_cli.database as db

class TestDBUtils(unittest.TestCase):
    
    def setUp(self):
        self.test_config = {
        'user': 'root',
        'password': 'root',
        'host': 'localhost',
        'database': 'test_db'
        }
        self.cnx = db.connect(self.test_config)
        
    def tearDown(self):
        self.cnx.close()
    
    def test_prompt_connection_details(self):
        with patch('builtins.input', side_effect=['user', 'password', 'host', 'database']):
            config = utils.prompt_connection_details()
            self.assertEqual(config['user'], 'user')
            self.assertEqual(config['password'], 'password')
            self.assertEqual(config['host'], 'host')
            self.assertEqual(config['database'], 'database')
    
    def test_connection_test_success(self):
        with patch('builtins.input', side_effect=self.test_config.values()), \
             patch('logging.info') as mock_log_info:
            utils.connection_test()
            mock_log_info.assert_called_with('Response: Connection successful!')
            
    def test_connection_test_failure(self):
        with patch('builtins.input', side_effect=['user', 'wrongpassword', 'localhost', 'test_db']), \
             patch('logging.error') as mock_log_error:
            utils.connection_test()
            mock_log_error.assert_called_with('Response: Connection failed!')
            
    def test_show_tables(self):
        with patch('logging.info') as mock_log_info:
            utils.show_tables(self.cnx)
            mock_log_info.assert_called_once()
            log_message = mock_log_info.call_args[0][0]
            self.assertIn('Response: The tables in the database are:', log_message)
            
    def test_show_user_grants(self):
        with patch('logging.info') as mock_log_info:
            utils.show_user_grants(self.cnx)
            mock_log_info.assert_called_once()
            log_message = mock_log_info.call_args[0][0]
            self.assertIn('Response: The grants for current user are:', log_message)
    
    def test_show_table_schema(self):
        self.cursor = self.cnx.cursor()
        self.table_name = 'test_table'
        self.cursor.execute(f"DROP TABLE IF EXISTS {self.table_name}")
        self.cursor.execute(f"CREATE TABLE {self.table_name} (id INT PRIMARY KEY, name VARCHAR(255) NOT NULL, gender ENUM('male', 'female'), age INT)")
        self.cnx.commit()

        expected_fields = [('id', 'int', 'NO', None), ('name', 'varchar', 'NO', None), 
                           ('gender', 'enum', 'YES', ['male', 'female']), ('age', 'int', 'YES', None)]
        result = utils.show_table_schema(self.cnx, self.table_name, False)
        self.assertEqual(result, expected_fields)

        self.cursor.execute(f"DROP TABLE IF EXISTS {self.table_name}")
        self.cnx.commit()
        self.cursor.close()