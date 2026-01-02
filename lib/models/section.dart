import 'package:flutter/material.dart';
import 'beacon.dart';

class Section {
  final String name;
  final Map<Beacon, int> beaconsWithDistances;
  final Color color;

  Section(
    this.name,
    this.beaconsWithDistances,
    this.color,
  );


}
