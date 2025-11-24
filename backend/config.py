# Configuration for the earthquake alert backend

# Cities to monitor
CITIES = {
    "Dhaka": (23.8103, 90.4125),
    "Chittagong": (22.3569, 91.7832),
    "Sylhet": (24.8949, 91.8687),
    "Khulna": (22.8456, 89.5403),
}

# Seismic wave speeds in km/s
P_WAVE_SPEED = 6.0
S_WAVE_SPEED = 3.5

# Data feed URLs
USGS_URL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"
EMSC_URL = "https://www.emsc-csem.org/service/rss/rss.php?typ=emsc"

# Minimum magnitude to trigger an alert
MIN_MAGNITUDE = 4.5
