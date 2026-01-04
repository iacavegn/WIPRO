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
    ) { 
        print('Section erstellt: $name, Sortierte Beacons: ${getSortedBeacons().map((b) => b.name).join(', ')}');
    }

    List<Beacon> getSortedBeacons() {
        final entries = beaconsWithDistances.entries.toList();
        entries.sort((a, b) => a.value.compareTo(b.value));
        return entries.map((e) => e.key).toList();
    }

    bool hasSameValues() {
        final entries = beaconsWithDistances.entries.toList();

        final values = entries.map((e) => e.value).toList();
        final uniqueValues = values.toSet();

        return uniqueValues.length != values.length;
    }

    @override
    String toString() {
    final beaconStrings = beaconsWithDistances.entries
        .map((e) => '${e.key}: ${e.value}m')
        .join(', ');
    return 'Section(name: $name, color: $color, beacons: [$beaconStrings])';
  }
}
