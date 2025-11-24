from geopy.distance import geodesic
from datetime import datetime, timedelta

from config import CITIES, P_WAVE_SPEED, S_WAVE_SPEED, MIN_MAGNITUDE
from data_fetcher import Earthquake
from database import get_db_connection, add_processed_id, is_id_processed, clean_old_ids

def calculate_warning_time(earthquake_lat, earthquake_lon, city_lat, city_lon):
    """
    Calculates the S-wave warning time for a given city.
    """
    distance_km = geodesic((earthquake_lat, earthquake_lon), (city_lat, city_lon)).km

    p_wave_travel_time = distance_km / P_WAVE_SPEED
    s_wave_travel_time = distance_km / S_WAVE_SPEED

    warning_time = s_wave_travel_time - p_wave_travel_time

    return warning_time if warning_time > 0 else 0

def process_earthquakes(earthquakes):
    """
    Processes a list of earthquakes to determine if any alerts should be sent.
    """
    alerts = []
    conn = get_db_connection()

    try:
        for eq in earthquakes:
            if is_id_processed(conn, eq.id):
                continue

            if datetime.utcnow() - eq.time > timedelta(minutes=5):
                continue

            if eq.magnitude < MIN_MAGNITUDE:
                continue

            for city_name, (city_lat, city_lon) in CITIES.items():
                warning_time = calculate_warning_time(eq.latitude, eq.longitude, city_lat, city_lon)

                if warning_time > 0:
                    alerts.append({
                        'earthquake': eq,
                        'city_name': city_name,
                        'warning_time': int(warning_time),
                    })

            add_processed_id(conn, eq.id)

        conn.commit()
    finally:
        conn.close()

    return alerts

def scheduled_db_cleanup():
    """A scheduled job to clean up old processed IDs from the database."""
    conn = get_db_connection()
    try:
        clean_old_ids(conn)
        conn.commit()
    finally:
        conn.close()
