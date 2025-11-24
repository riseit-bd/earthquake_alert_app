import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class Earthquake {
  final String id;
  final String agency;
  final double magnitude;
  final double latitude;
  final double longitude;
  final DateTime time;

  Earthquake({
    required this.id,
    required this.agency,
    required this.magnitude,
    required this.latitude,
    required this.longitude,
    required this.time,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json, String agency) {
    return Earthquake(
      id: json['id'] ?? '',
      agency: agency,
      magnitude: json['properties']['mag']?.toDouble() ?? 0.0,
      latitude: json['geometry']['coordinates'][1],
      longitude: json['geometry']['coordinates'][0],
      time: DateTime.fromMillisecondsSinceEpoch(json['properties']['time']),
    );
  }

  factory Earthquake.fromRssItem(XmlElement item, String agency) {
    // Helper to find namespaced elements
    String? findElement(XmlElement element, String name, {String? namespace}) {
      try {
        return element.findAllElements(name, namespace: namespace).first.innerText;
      } catch (e) {
        return null;
      }
    }

    // Extracting data from RSS item
    final lat = double.parse(findElement(item, 'lat', namespace: 'http://www.w3.org/2003/01/geo/wgs84_pos#') ?? '0.0');
    final lon = double.parse(findElement(item, 'long', namespace: 'http://www.w3.org/2003/01/geo/wgs84_pos#') ?? '0.0');
    final pubDate = findElement(item, 'pubDate') ?? '';
    final guid = findElement(item, 'guid') ?? DateTime.now().toIso8601String(); // Fallback ID

    // Parsing magnitude from title: "M 4.5 - CENTRAL TURKEY"
    final title = findElement(item, 'title') ?? '';
    final magParts = title.split(' ');
    final magnitude = magParts.length > 1 ? double.tryParse(magParts[1]) ?? 0.0 : 0.0;

    DateTime parsedDate;
    try {
        // Example: Fri, 27 Oct 2023 10:30:44 GMT
        parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parseUtc(pubDate);
    } catch (e) {
        parsedDate = DateTime.now().toUtc();
    }

    return Earthquake(
      id: guid,
      agency: agency,
      magnitude: magnitude,
      latitude: lat,
      longitude: lon,
      time: parsedDate,
    );
  }

  factory Earthquake.fromFCM(Map<String, dynamic> data) {
    return Earthquake(
      id: data['id']?.toString() ?? '',
      agency: data['agency']?.toString() ?? '',
      magnitude: double.tryParse(data['magnitude']?.toString() ?? '0.0') ?? 0.0,
      latitude: double.tryParse(data['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(data['longitude']?.toString() ?? '0.0') ?? 0.0,
      time: DateTime.fromMillisecondsSinceEpoch(int.tryParse(data['time']?.toString() ?? '0') ?? 0),
    );
  }
}
