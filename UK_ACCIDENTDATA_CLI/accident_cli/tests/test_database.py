# unit tests for the database module
import unittest
from ..database import connect, disconnect

class TestDatabase(unittest.TestCase):
    def setUp(self):
        self.test_config = {
        'user': 'root',
        'password': 'root',
        'host': '127.0.0.1',
        'database': 'test_db'
        }

    def test_connection(self):
        cnx = connect(self.test_config)
        self.assertIsNotNone(cnx)
        disconnect(cnx)