import 'package:flutter_test/flutter_test.dart';
import 'package:earthquake_alert_app/utils/p_wave_estimator.dart';

void main() {
  group('PWaveEstimator', () {
    test('estimatePWaveTravelTime returns correct time', () {
      expect(PWaveEstimator.estimatePWaveTravelTime(100), closeTo(16.67, 0.01));
      expect(PWaveEstimator.estimatePWaveTravelTime(0), equals(0));
    });
  });
}
