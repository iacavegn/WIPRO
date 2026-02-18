import 'package:flutter/material.dart';
import '/models/measurement.dart';
import '/models/beacon_measured.dart';
import '/models/beacon_average.dart';
import '/location/lateration.dart';

class Location {  
    static getLocation(Set<Measurement> measurements) {
        if (measurements.isEmpty) return null;
        final averagedBeacons = BeaconAverage.getAverageBeacon(measurements);
        if (averagedBeacons == null) return null;

        return Lateration.getPointFromDistancesAs1to120(averagedBeacons);
    } 
}