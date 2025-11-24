# Earthquake Alert Backend Service

This backend service continuously fetches earthquake data from multiple sources, calculates S-wave warning times for monitored cities in Bangladesh, and sends early-warning push notifications via Firebase Cloud Messaging (FCM).

## Setup Instructions

### 1. Install Dependencies

Navigate to the `backend` directory and install the required Python packages using pip:

```bash
pip install -r requirements.txt
```

### 2. Configure Firebase

This service requires a Firebase project to send push notifications.

1.  **Create a Firebase Project:** If you haven't already, create a new project at the [Firebase Console](https://console.firebase.google.com/).
2.  **Generate a Private Key:**
    *   In your Firebase project, go to **Project settings** > **Service accounts**.
    *   Click on **Generate new private key**. A JSON file containing your service account credentials will be downloaded.
3.  **Add Credentials to the Project:**
    *   Rename the downloaded JSON file to `firebase-credentials.json`.
    *   Place this file in the `backend` directory (the same directory as this `README.md`).
4.  **Update `notification_sender.py`:**
    *   Open `notification_sender.py` and ensure the path to your credentials file is correct. It should point to the file you just added:
        ```python
        cred = credentials.Certificate('firebase-credentials.json')
        ```

### 3. Configure Monitored Cities and Thresholds

You can customize the cities, API endpoints, and minimum earthquake magnitude by editing the `config.py` file.

## Running the Service

Once the setup is complete, you can run the backend service from the `backend` directory:

```bash
python main.py
```

The service will start, initialize Firebase, and begin fetching earthquake data every 60 seconds. It will print logs to the console indicating its status, any new earthquakes found, and any alerts that are sent.

## Deployment

For a production environment, you should run this script on a server or as a cloud function (e.g., Google Cloud Function, AWS Lambda) that is configured to run continuously.
