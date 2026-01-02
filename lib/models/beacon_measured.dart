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
    ): distance = calculateDistance(rssi, beacon.rssiAt1m);

    static double calculateDistance(int rssi, int txPower) {
        const int n = 2;
        return pow(10, (txPower - rssi) / (10 * n)).toDouble();
    }
}
