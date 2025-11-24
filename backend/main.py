import time
from data_fetcher import get_all_earthquakes
from alert_service import process_earthquakes, scheduled_db_cleanup
from notification_sender import initialize_firebase, send_notification
from database import initialize_db

# --- Configuration ---
# Time to wait between fetches in seconds
FETCH_INTERVAL = 60
# Time to wait between DB cleanups in hours
CLEANUP_INTERVAL_HOURS = 24

def main_job():
    """The main job to be run on a schedule."""
    print("Fetching and processing earthquake data...")

    earthquakes = get_all_earthquakes()
    alerts = process_earthquakes(earthquakes)

    if not alerts:
        print("No new alerts to send.")
        return

    for alert in alerts:
        eq = alert['earthquake']
        city_name = alert['city_name']
        warning_time = alert['warning_time']

        print(f"Sending alert for M{eq.magnitude} earthquake to {city_name} with {warning_time}s warning.")
        send_notification(
            earthquake=eq,
            city_name=city_name,
            warning_time=warning_time
        )

def main():
    """Initializes the service and starts the main loop."""
    print("Starting backend service...")

    initialize_db()
    initialize_firebase()

    last_cleanup_time = time.time()

    while True:
        main_job()

        # Check if it's time to clean the database
        if time.time() - last_cleanup_time >= CLEANUP_INTERVAL_HOURS * 3600:
            scheduled_db_cleanup()
            last_cleanup_time = time.time()

        print(f"Waiting for {FETCH_INTERVAL} seconds before next fetch...")
        time.sleep(FETCH_INTERVAL)

if __name__ == "__main__":
    main()
