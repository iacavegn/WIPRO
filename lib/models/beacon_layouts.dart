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
    static const Map<String, List<int int int>> coordinates = {
        "a": [0, 0, 0],
        "b": [0, 2, 0],
        "c": [2, 0, 0],
        "d": [2, 2, 0],
    };

    static double getDistance(String firstBeacon, String secondBeacon) {
        coordinatesFirst = coordinates[firstBeacon];
        coordinatesSecond = coordinates[secondBeacon];
        xFirst = coordinatesFirst[0];
        yFirst = coordinatesFirst[1];
        zFirst = coordinatesFirst[2];
        xSecond = coordinatesSecond[0];
        ySecond = coordinatesSecond[1];
        zSecond = coordinatesSecond[2];
    
        return sqrt(
            pow(xFirst - xSecond, 2) +
            pow(yFirst - ySecond, 2) +
            pow(zFirst - zSecond, 2)
        );
    }
}