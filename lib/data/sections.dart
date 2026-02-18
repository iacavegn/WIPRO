import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '/models/section.dart';
import '/data/beacons.dart';
import '/models/beacon.dart';
import '/models/beacon_measured.dart';
import '/data/beacon_layouts.dart';
import '/location/lateration.dart';
import '/models/square.dart';
import '/models/measurement.dart';
import 'dart:math';

/*    x
 |a--|---|--b|
 | A | B | C |
 |---|---|---|
y| D | E | F |
 |---|---|---|
 | G | H | I |
 |c--|---|--d|
*/

class Sections {
    static final a = Beacons.getByName("a")!;
    static final b = Beacons.getByName("b")!;
    static final c = Beacons.getByName("c")!;
    static final d = Beacons.getByName("d")!;

    static List<Section> sections = [
        Section("A", Square(Point(  0,   0), Point( 40,  40)), Colors.red),
        Section("B", Square(Point( 40,   0), Point( 80,  40)), Colors.orange),
        Section("C", Square(Point( 80,   0), Point(120,  40)), Colors.yellow),
        Section("D", Square(Point(  0,  40), Point( 40,  80)), Colors.green),
        Section("E", Square(Point( 40,  40), Point( 80,  80)), Colors.blue),
        Section("F", Square(Point( 80,  40), Point(120,  80)), Colors.indigo),
        Section("G", Square(Point(  0,  80), Point( 40, 120)), Colors.purple),
        Section("H", Square(Point( 40,  80), Point( 80, 120)), Colors.teal),
        Section("I", Square(Point( 80,  80), Point(120, 120)), Colors.brown),
    ];

    static Section? getSection(Set<Measurement> measurements) {
        if (measurements.isEmpty) return null;

        final beaconMap = <Beacon, int>{};
        measurements.forEach((measurement) {
            measurement.beacons.forEach((beaconMeasured) {
                final existing = beaconMap[beaconMeasured.beacon];
                if (existing != null) {
                    beaconMap[beaconMeasured.beacon] = existing + beaconMeasured.rssi;
                } else {
                    beaconMap[beaconMeasured.beacon] = beaconMeasured.rssi;
                }
                
            });
        });

        final averagedBeacons = beaconMap.entries.map((entry) {
            final beacon = entry.key;
            final values = entry.value;
            final avgRssi = values / measurements.length;
            return BeaconMeasured(beacon, avgRssi.toInt());
        }).toList();

        final others = measurements.toList().first.beacons;
        var maxDistance = BeaconsLayout.getMaxDistance();

        /*print("Maximale Distanz: $maxDistance");
        others.forEach((bm) {
            print("Beacon: ${bm.beacon.name}, RSSI: ${bm.rssi}, Berechnete Distanz: ${bm.distance}, in prozentualer Relation zur maximalen Distanz: ${(bm.distance / maxDistance * 100).toStringAsFixed(2)}% distances");
        });*/

        final lateration = Lateration();
        final position = lateration.getPointFromDistancesAs1to120(others);

        for (final section in sections) {
            if (section.square.contains(position)) {
                print("Position $position liegt in Section ${section.name}");
                return section;
            }
        }

        return null;
    }
}