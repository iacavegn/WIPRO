import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '/models/section.dart';
import '/data/beacons.dart';
import '/models/beacon.dart';
import '/models/beacon_measured.dart';
import '/data/beacon_layouts.dart';
import '/location/lateration.dart';
import '/models/square.dart';
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
        Section("A", Square(Point(  0,   0), Point( 30, 30)), Colors.red),
        Section("B", Square(Point( 30,   0), Point( 60, 30)), Colors.orange),
        Section("C", Square(Point( 60,   0), Point( 90, 30)), Colors.yellow),
        Section("D", Square(Point(  0,   0), Point( 30, 60)), Colors.green),
        Section("E", Square(Point( 30,   0), Point( 60, 60)), Colors.blue),
        Section("F", Square(Point( 60,   0), Point( 90, 60)), Colors.indigo),
        Section("G", Square(Point(  0,   0), Point( 30, 90)), Colors.purple),
        Section("H", Square(Point( 30,   0), Point( 60, 90)), Colors.teal),
        Section("I", Square(Point( 60,   0), Point( 90, 90)), Colors.brown),
    ];

    static Section? getSection(List<BeaconMeasured> others) {
        var maxDistance = BeaconsLayout.getMaxDistance();

        print("Maximale Distanz: $maxDistance");
        others.forEach((bm) {
            print("Beacon: ${bm.beacon.name}, RSSI: ${bm.rssi}, Berechnete Distanz: ${bm.distance}, in prozentualer Relation zur maximalen Distanz: ${(bm.distance / maxDistance * 100).toStringAsFixed(2)}% distances");
        });

        final lateration = Lateration();
        final position = lateration.solve(others);
        print("Position: $position");

        for (final section in sections) {
            if (section.square.contains(position)) {
                print("Position $position liegt in Section ${section.name}");
                return section;
            }
        }

        return null;
    }
}