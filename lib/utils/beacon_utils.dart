import 'dart:math';

class BeaconUtils {
  static double calculateDistance(int rssi) {
    const int n = 2;
    const double txPower = -60;
    return pow(10, (txPower - rssi) / (10 * n)).toDouble();
  }
}
