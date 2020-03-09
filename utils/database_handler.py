import pymssql
import pandas as pd
import logging
import os
import sys
from dotenv import load_dotenv

load_dotenv()


class DatabaseHandler:
    def __init__(self,
                 server_name=os.getenv("SERVER_NAME"),
                 database_name=os.getenv("DATABASE_NAME"),
                 user_name=os.getenv("USER_NAME"),
                 database_password=os.getenv("DATABASE_PASSWORD")
                 ):
        try:
            self.conn = pymssql.connect(server=server_name,
                                        user=user_name,
                                        password=database_password,
                                        database=database_name)
        except pymssql.OperationalError:
            logging.error('Error while connecting to database. '
                          'Check all the parameters.')
            sys.exit(1)
        self.cursor = self.conn.cursor()

    def execute_query(self, query):
        self.cursor.execute(query)
        logging.debug('Reading data from database')
        return pd.read_sql(query, self.conn)

    def close_connection(self):
        self.conn.close()
