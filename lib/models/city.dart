class City {
  final String name;
  final double latitude;
  final double longitude;

  City({required this.name, required this.latitude, required this.longitude});
}

final List<City> monitoredCities = [
  City(name: 'Dhaka', latitude: 23.8103, longitude: 90.4125),
  City(name: 'Chittagong', latitude: 22.3569, longitude: 91.7832),
  City(name: 'Sylhet', latitude: 24.8949, longitude: 91.8687),
  City(name: 'Khulna', latitude: 22.8456, longitude: 89.5403),
];
