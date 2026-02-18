import 'package:flutter/material.dart';
import 'dart:math';
import '/models/point3d.dart';

/*    x
 |a--|---|--b|
 |   |   |   |
 |---|---|---|
y|   |   |   |
 |---|---|---|
 |   |   |   |
 |c--|---|--d|
*/

class BeaconsLayout {
    static const Map<String, Point3d> coordinates = {
        "a": Point3d(0, 0, 0),
        "b": Point3d(0, 20, 0),
        "c": Point3d(20, 0, 0),
        "d": Point3d(20, 20, 0),
    };

    static double getDistance(String firstBeacon, String secondBeacon) {
        final firstCoords = coordinates[firstBeacon];
        final secondCoords = coordinates[secondBeacon];
        if (firstCoords == null || secondCoords == null) {
            throw ArgumentError('Invalid beacon names: $firstBeacon, $secondBeacon');
        }
        return firstCoords.distanceTo(secondCoords);
    }

    static double getMaxDistance() {
        double maxDistance = 0;
        for (final coord1 in coordinates.values) {
            for (final coord2 in coordinates.values) {
                final distance = coord1.distanceTo(coord2);
                if (distance > maxDistance) {
                    maxDistance = distance;
                }
            }
        }
        return maxDistance;
    }
}