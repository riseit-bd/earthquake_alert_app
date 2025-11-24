import 'package:flutter_test/flutter_test.dart';
import 'package:earthquake_alert_app/utils/distance_calculator.dart';

void main() {
  group('DistanceCalculator', () {
    test('calculateDistance returns correct distance', () {
      // Test case 1: Short distance
      expect(
        DistanceCalculator.calculateDistance(34.0522, -118.2437, 34.0523, -118.2438),
        closeTo(0.014, 0.001),
      );

      // Test case 2: Long distance
      expect(
        DistanceCalculator.calculateDistance(34.0522, -118.2437, 40.7128, -74.0060),
        closeTo(3935.7, 1),
      );
    });
  });
}
