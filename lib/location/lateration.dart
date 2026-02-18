import 'dart:math';

import '/data/beacons.dart';
import '/models/beacon.dart';
import '/models/beacon_measured.dart';
import '/models/point3d.dart';


/// Lateration solver for 3D anchors with a fixed tag height.
///
/// Use this when:
/// - Anchors (A, B, C, D, ...) are in 3D
/// - Distances are noisy / inconsistent (real-world sensors)
/// - The tracked object always has a fixed height (e.g. z = 1.0)
class Lateration {
  final double fixedZ;
  final int iterations;
  final double learningRate;
  const Lateration({
    this.fixedZ = 0.0,
    this.iterations = 800,
    this.learningRate = 0.03,
  });

  Point solve(List<BeaconMeasured> beaconMeasurements) {
    if (beaconMeasurements.length < 3) {
      throw ArgumentError('At least 3 beacon measurements are required for lateration.');
    }

    final initial = _centroid2D(beaconMeasurements);

    double x = initial.x.toDouble();
    double y = initial.y.toDouble();
    final double z = fixedZ;

    for (int i = 0; i < iterations; i++) {
      double gradX = 0.0;
      double gradY = 0.0;

      for (final beaconMeasure in beaconMeasurements) {
        final dx = x - beaconMeasure.beacon.coordinates.x;
        final dy = y - beaconMeasure.beacon.coordinates.y;
        final dz = z - beaconMeasure.beacon.coordinates.z;

        final predictedDist = sqrt(dx * dx + dy * dy + dz * dz);

        if (predictedDist == 0) continue;

        final error = predictedDist - beaconMeasure.distance;

        gradX += (error * dx) / predictedDist;
        gradY += (error * dy) / predictedDist;
      }

      x -= learningRate * gradX;
      y -= learningRate * gradY;
    }

    return Point(x, y);
  }

  Point _centroid2D(List<BeaconMeasured> beaconMeasurements) {
    double sumX = 0.0;
    double sumY = 0.0;

    for (final beaconMeasured in beaconMeasurements) {
      sumX += beaconMeasured.beacon.coordinates.x;
      sumY += beaconMeasured.beacon.coordinates.y;
    } 

    return Point((sumX / beaconMeasurements.length).abs(), (sumY / beaconMeasurements.length).abs());
  }
}