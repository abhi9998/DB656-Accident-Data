import logging

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

# UK database connection options
config = {
        'user': 'root',
        'password': 'root',
        'host': 'localhost',
        'database': 'ukfinal2',
        'raise_on_warnings': True
}