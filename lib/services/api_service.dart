import 'dart.convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/earthquake.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {
  final List<Map<String, String>> feeds = [
    {'url': 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson', 'agency': 'USGS'},
    {'url': 'https://www.emsc-csem.org/service/rss/rss.php?typ=emsc', 'agency': 'EMSC'},
    // Add IRIS/BMD if feed is available
  ];

  Future<List<Earthquake>> fetchAllEarthquakes() async {
    List<Earthquake> earthquakes = [];
    bool hasErrors = false;

    for (var feed in feeds) {
      try {
        final response = await http.get(Uri.parse(feed['url']!));
        if (response.statusCode == 200) {
          if (feed['agency'] == 'USGS') {
            final data = jsonDecode(response.body);
            for (var feature in data['features']) {
              earthquakes.add(Earthquake.fromJson(feature, feed['agency']!));
            }
          } else if (feed['agency'] == 'EMSC') {
            final document = XmlDocument.parse(response.body);
            final items = document.findAllElements('item');
            for (var item in items) {
              earthquakes.add(Earthquake.fromRssItem(item, feed['agency']!));
            }
          }
        } else {
          // Throw an exception if the status code is not 200
          hasErrors = true;
          print("Error fetching ${feed['agency']}: Status code ${response.statusCode}");
        }
      } catch (e) {
        hasErrors = true;
        print("Error fetching ${feed['agency']}: $e");
      }
    }

    if (hasErrors && earthquakes.isEmpty) {
      throw ApiException("Could not fetch earthquake data from any source. Please check your connection.");
    }

    return earthquakes;
  }
}
