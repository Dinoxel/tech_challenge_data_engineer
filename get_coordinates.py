import mysql.connector
import requests


try:
    connection = mysql.connector.connect(user='root', password='password',
                                         host='localhost',
                                         database='dataengineer')
    cursor = connection.cursor(buffered=True)

    cursor.execute("SELECT address_id, full_address FROM address")

    for address_id, full_address in cursor.fetchall():
        r = requests.get(f"https://nominatim.openstreetmap.org/?q={full_address}&format=json&limit=1").json()

        if len(r):
            query = "UPDATE address SET latitude = %s, longitude = %s WHERE address_id = %s"
            cursor.execute(query, (r[0]['lat'], r[0]['lon'], address_id))

    connection.commit()
    print("Data inserted successfully into dataengineer table using the prepared statement")

except mysql.connector.Error as error:
    print("parameterized query failed", error)

finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("MySQL connection is closed")
