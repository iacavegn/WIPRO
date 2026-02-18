import 'package:flutter/material.dart';
import '/models/measurement.dart';
import '/models/beacon_measured.dart';
import '/models/beacon.dart';
import 'dart:math';

class BeaconAverage {
    static List<BeaconMeasured>? getAverageBeacon(Set<Measurement> measurements) {
        if (measurements.isEmpty) return null;

        final alpha = 0.2; // Gewichtungsfaktor für den gleitenden Durchschnitt

        final beaconMap = <Beacon, int>{};
        measurements.forEach((measurement) {
            measurement.beacons.forEach((beaconMeasured) {
                final existing = beaconMap[beaconMeasured.beacon];
                if (existing != null) {
                    beaconMap[beaconMeasured.beacon] = (alpha * beaconMeasured.rssi + (1 - alpha) * existing).round();
                } else {
                    beaconMap[beaconMeasured.beacon] = beaconMeasured.rssi;
                }
            });
        });
        final averagedBeacons = beaconMap.entries.map((entry) {
            final beacon = entry.key;
            final rssi = entry.value;
            return BeaconMeasured(beacon, rssi);
        }).toList();
        return averagedBeacons;
    }
}