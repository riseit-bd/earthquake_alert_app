import sqlite3

DB_FILE = 'processed_earthquakes.db'

def get_db_connection():
    """Establishes a connection to the SQLite database."""
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    return conn

def initialize_db():
    """Initializes the database and creates the 'processed_ids' table if it doesn't exist."""
    conn = get_db_connection()
    conn.execute('''
        CREATE TABLE IF NOT EXISTS processed_ids (
            id TEXT PRIMARY KEY,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()
    print("Database initialized.")

def add_processed_id(conn, earthquake_id):
    """Adds a new earthquake ID to the database."""
    conn.execute('INSERT INTO processed_ids (id) VALUES (?)', (earthquake_id,))

def is_id_processed(conn, earthquake_id):
    """Checks if an earthquake ID has already been processed."""
    cursor = conn.execute('SELECT 1 FROM processed_ids WHERE id = ?', (earthquake_id,))
    return cursor.fetchone() is not None

def clean_old_ids(conn):
    """Removes records older than 24 hours to keep the database size manageable."""
    conn.execute("DELETE FROM processed_ids WHERE timestamp <= datetime('now', '-24 hours')")
    print("Cleaned old earthquake IDs from the database.")
