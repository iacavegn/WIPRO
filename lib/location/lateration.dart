import 'dart:math';

import '/data/beacons.dart';
import '/models/beacon.dart';
import '/models/beacon_measured.dart';
import '/models/point3d.dart';
import '/data/beacon_layouts.dart';


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
    this.learningRate = 0.01,
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

        final predictedPercentage = predictedDist / BeaconsLayout.getMaxDistance();
        final measuredPercentage = (beaconMeasure.distance / BeaconsLayout.getMaxDistance()).clamp(0.0, 1.0);
    
        final errorPercentage = (predictedPercentage - measuredPercentage).abs() / measuredPercentage;

        gradX += ((errorPercentage * dx) / predictedPercentage) ;
        gradY += ((errorPercentage * dy) / predictedPercentage);
      }

      x -= learningRate * gradX;
      y -= learningRate * gradY;
    }
    
    return Point(x, y);
  }

  getPointFromDistancesAs1to120(List<BeaconMeasured> beaconMeasurements) {
    final position = solve(beaconMeasurements);
    return Point(position.x.abs() * 1.2, position.y.abs() * 1.2);
  }

  Point _centroid2D(List<BeaconMeasured> beaconMeasurements) {
    double sumX = 0.0;
    double sumY = 0.0;

    for (final beaconMeasured in beaconMeasurements) {
      sumX += beaconMeasured.beacon.coordinates.x;
      sumY += beaconMeasured.beacon.coordinates.y;
    } 

    return Point((sumX / beaconMeasurements.length), (sumY / beaconMeasurements.length));
  }
}