import mysql.connector
from flask import g

def get_db_connection():
    if 'db' not in g:
        g.db = mysql.connector.connect(
            host="localhost",
            user="YOUR_DB_USER",  # Cambiar para cada grupo
            password="YOUR_DB_PASSWORD",  # Cambiar para cada grupo
            database="YOUR_DB_NAME"  # Cambiar para cada grupo
        )
    return g.db

def close_db_connection(e=None):
    db = g.pop('db', None)
    if db is not None:
        db.close()
