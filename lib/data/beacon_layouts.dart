import 'package:flutter/material.dart';
import 'dart:math';

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
    static const Map<String, List<int>> coordinates = {
        "a": [0, 0, 0],
        "b": [0, 20, 0],
        "c": [20, 0, 0],
        "d": [20, 20, 0],
    };

    static double getDistance(String firstBeacon, String secondBeacon) {
        List<int> coordinatesFirst = coordinates[firstBeacon] ?? [0, 0, 0];
        List<int> coordinatesSecond = coordinates[secondBeacon] ?? [0, 0, 0];
        int xFirst = coordinatesFirst[0];
        int yFirst = coordinatesFirst[1];
        int zFirst = coordinatesFirst[2];
        int xSecond = coordinatesSecond[0];
        int ySecond = coordinatesSecond[1];
        int zSecond = coordinatesSecond[2];
    
        return sqrt(
            pow(xFirst - xSecond, 2) +
            pow(yFirst - ySecond, 2) +
            pow(zFirst - zSecond, 2)
        );
    }

    static double getMaxDistance() {
        double maxDistance = 0.0;
        for (final firstBeacon in coordinates.keys) {
            for (final secondBeacon in coordinates.keys) {
                if (firstBeacon != secondBeacon) {
                    double distance = getDistance(firstBeacon, secondBeacon);
                    if (distance > maxDistance) {
                        maxDistance = distance;
                    }
                }
            }
        }
        return maxDistance;
    }
}