import firebase_admin
from firebase_admin import credentials, messaging

from data_fetcher import Earthquake

def initialize_firebase():
    """
    Initializes the Firebase Admin SDK.
    Replace 'path/to/your/firebase-credentials.json' with the actual path to your credentials.
    """
    try:
        cred = credentials.Certificate('firebase-credentials.json')
        firebase_admin.initialize_app(cred)
        print("Firebase Admin SDK initialized successfully.")
    except Exception as e:
        print(f"Error initializing Firebase Admin SDK: {e}")
        print("Please ensure you have a valid 'firebase-credentials.json' file.")
        # In a production environment, you might want to exit the application
        # if Firebase initialization fails.
        # exit(1)

def send_notification(earthquake: Earthquake, city_name: str, warning_time: int):
    """
    Sends a push notification to a city-specific topic.
    """
    topic = f"city_{city_name.lower()}"

    message = messaging.Message(
        notification=messaging.Notification(
            title="Earthquake Detected!",
            body=f"Strong shaking estimated in {warning_time} seconds for {city_name}. Take cover!"
        ),
        data={
            "messageType": "sWave",
            "id": earthquake.id,
            "agency": earthquake.agency,
            "magnitude": str(earthquake.magnitude),
            "latitude": str(earthquake.latitude),
            "longitude": str(earthquake.longitude),
            "time": str(int(earthquake.time.timestamp() * 1000)),
            "city": city_name,
            "warningTime": str(warning_time),
        },
        topic=topic,
    )

    try:
        response = messaging.send(message)
        print(f"Successfully sent message to topic '{topic}': {response}")
    except Exception as e:
        print(f"Error sending FCM message to topic '{topic}': {e}")
