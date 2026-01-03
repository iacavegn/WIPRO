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

    List<Beacon> getSortedBeacons() {
        final entries = beaconsWithDistances.entries.toList();
        entries.sort((a, b) => a.value.compareTo(b.value));
        return entries.map((e) => e.key).toList();
    }
}
