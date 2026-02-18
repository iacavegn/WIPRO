import 'package:flutter/material.dart';
import 'dart:math';
import '/models/beacon.dart';
  
class BeaconMeasured {
    final Beacon beacon;
    final int rssi;
    final double distance;

    BeaconMeasured(
        this.beacon,
        this.rssi,
    ): distance = calculateDistance(rssi, beacon.rssiAt1m) * 100;

    //
    static double calculateDistance(int rssi, int txPower) {
        const int n = 3;
        return pow(10, (txPower - rssi) / (10 * n)).toDouble();
    }

    @override
    String toString() => 'BeaconMeasured(beacon: ${beacon.name}, rssi: $rssi, distance: ${distance.toStringAsFixed(2)} cm)'; 
}

