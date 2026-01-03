import 'package:flutter/material.dart';

class Beacon {
  final String id;
  final String name;
  final int rssiAt1m; // RSSI at 1 meter in dBm

  Beacon(
    this.id,
    this.name,
    this.rssiAt1m,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beacon && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Beacon(id: $id, name: $name, rssiAt1m: $rssiAt1m)';
}
