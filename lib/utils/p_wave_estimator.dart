class PWaveEstimator {
  static const double pWaveSpeedKmPerSecond = 6.0;

  static double estimatePWaveTravelTime(double distanceInKm) {
    return distanceInKm / pWaveSpeedKmPerSecond;
  }
}
