from flask import Flask
import os
import psycopg2

app = Flask(__name__)

def check_db_connection():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB"),
            user=os.getenv("POSTGRES_USER"),
            password=os.getenv("POSTGRES_PASSWORD"),
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT")
        )
        conn.close()
        return True
    except Exception as e:
        print("Database connection failed:", e)
        return False

@app.route("/")
def home():
    if check_db_connection():
        return "✅ Flask is running and connected to the database!"
    else:
        return "⚠️ Flask is running, but DB connection failed."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
