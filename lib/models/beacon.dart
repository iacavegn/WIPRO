import 'package:flutter/material.dart';
import '/data/beacon_layouts.dart';
import '/models/point3d.dart';

class Beacon {
  final String id;
  final String name;
  final int rssiAt1m; // RSSI at 1 meter in dBm
  late final Point3d coordinates;

  Beacon(
    this.id,
    this.name,
    this.rssiAt1m,
  ) {
    coordinates = BeaconsLayout.coordinates[name] ?? Point3d(0, 0, 0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beacon && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Beacon(id: $id, name: $name, rssiAt1m: $rssiAt1m)';
}
