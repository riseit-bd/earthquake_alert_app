import requests
import xmltodict
from datetime import datetime
from dataclasses import dataclass

from config import USGS_URL, EMSC_URL

@dataclass
class Earthquake:
    id: str
    latitude: float
    longitude: float
    magnitude: float
    time: datetime
    agency: str

def fetch_usgs_data():
    """Fetches and parses earthquake data from the USGS GeoJSON feed."""
    try:
        response = requests.get(USGS_URL, timeout=10)
        response.raise_for_status()
        data = response.json()

        earthquakes = []
        for feature in data.get('features', []):
            try:
                mag = feature['properties']['mag']
                if mag is None:
                    continue

                earthquakes.append(Earthquake(
                    id=feature['id'],
                    latitude=feature['geometry']['coordinates'][1],
                    longitude=feature['geometry']['coordinates'][0],
                    magnitude=float(mag),
                    time=datetime.utcfromtimestamp(feature['properties']['time'] / 1000),
                    agency='USGS'
                ))
            except (KeyError, TypeError, ValueError) as e:
                print(f"Skipping USGS record due to parsing error: {e}")
        return earthquakes
    except requests.RequestException as e:
        print(f"Error fetching USGS data: {e}")
        return []

def fetch_emsc_data():
    """Fetches and parses earthquake data from the EMSC RSS feed."""
    try:
        response = requests.get(EMSC_URL, timeout=10)
        response.raise_for_status()
        data = xmltodict.parse(response.content)

        earthquakes = []
        for item in data.get('rss', {}).get('channel', {}).get('item', []):
            try:
                # Magnitude is in the title, e.g., "M 4.5 - CENTRAL TURKEY"
                title = item.get('title', '')
                mag_str = title.split(' ')[1]

                earthquakes.append(Earthquake(
                    id=item['guid'],
                    latitude=float(item['geo:lat']),
                    longitude=float(item['geo:long']),
                    magnitude=float(mag_str),
                    time=datetime.strptime(item['pubDate'].replace(' GMT', ''), '%a, %d %b %Y %H:%M:%S'),
                    agency='EMSC'
                ))
            except (KeyError, TypeError, ValueError, IndexError) as e:
                print(f"Skipping EMSC record due to parsing error: {e}")
        return earthquakes
    except requests.RequestException as e:
        print(f"Error fetching EMSC data: {e}")
        return []

def get_all_earthquakes():
    """Fetches earthquake data from all available sources."""
    return fetch_usgs_data() + fetch_emsc_data()
